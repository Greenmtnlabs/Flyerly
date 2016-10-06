//
//  VideoTrimmerView.swift
//  Pods
//
//  Created by Storix on 6/9/16.
//  Copyright (c) 2016 Storix. All rights reserved.
//
//

import UIKit
import AVFoundation
import XCGLogger
import YYWebImage

/// The protocol that provides the methods which are used to notify the trimmer delegate about time changes.
public protocol VideoTrimmerViewDelegate: class {
  /**
      Notifies the delegate about the trimmer times changes.
   
      - parameter trimmerView: TThe trimmer view object that is notifying you of the trimmer times changes.
      - parameter newStartTime: The value in seconds that is used as the start trimming time.
      - parameter newStartTime: The value in seconds that is used as the end trimming time.
   */
  func trimmerView(trimmerView: VideoTrimmerView, didChangeStartTime newStartTime: CGFloat, andEndTime newEndTime: CGFloat)
}


/// Enumeration that defines the trimmer timeline zoom scale options.
public enum TrimmerZoomScale: Int {
  /// Indicates the default zoom mode in which the trimmer view timeline frames are all visible.
  case Default = 1
  /// Indicates the zoom mode in which the trimmer view timeline is increased by 16 times.
  case Zoom16x = 16
  /// Indicates the zoom mode in which the trimmer view timeline is increased by 32 times.
  case Zoom32x = 32
  /// Indicates the zoom mode in which the trimmer view timeline is increased by 64 times.
  case Zoom64x = 64
}

/// Class that defines the video trimmer view appearance related static properties.
class TrimmerAppearance {
  // MARK: Appearance properties
  /// Overlay views background color.
  static var overlayViewsBackgroundColor = UIColor.darkGrayColor()
  /// The alpha level for the overlay views.
  static var overlayViewsAlphaValue: CGFloat = 0.9
  /// The offset (in points) from the frames collection view vertical edges that is used to define the trimmer sliders height.
  static var trimmerSlidersHeightOffset: CGFloat = 0.0
}

/// Path for the cache manager that is used with the trimmer view.
private let kTrimmerViewImageCachePath = "com.storix.videotrimmerview"

/**
	KVO context used to differentiate KVO callbacks for the `VideoTrimmerView` class versus other
	classes in its class hierarchy.
 */
private var videoTrimmerViewKvoContext = 0

/// The `UIView` subclass that represents the view used for trimming the video assets.
public class VideoTrimmerView: UIView {
  // MARK: Properties
  /// The object that is used to set the appearance of the video trimmer view.
  public static let trimmerAppearance = TrimmerAppearanceProxy()
  /// The object that acts as the delegate of the trimmer view.
  weak public var delegate: VideoTrimmerViewDelegate?
  /// The closure that is called when the video frames collection view has been tapped.
  public var timelineTapHandler: ((collectionView: UICollectionView, tappedAtIndexPath: NSIndexPath) -> Void)?
  /// Determines the trimmer view timeline length that is equivalent to the video one second duration.
  public var oneSecondLength: CGFloat {
    guard videoDuration > 0 else { return 0.0 }
    return videoFramesCollectionView.collectionViewLayout.collectionViewContentSize().width  / CGFloat(videoDuration)
  }
  
  /**
      The `AVPlayerItem` object that defines the properties of the video asset which was selected for trimming.
   
      - note: To properly observe the `AVPlayerItem` status it must be associated with `AVPlayer`.
   */
  dynamic public var playerItem: AVPlayerItem? {
    didSet {
      imageGenerator = AVAssetImageGenerator(asset: playerItem!.asset)
    }
  }
  /// The time in seconds representing the maximum allowed trimming time. The default value is 60.0.
  public var maxTime: CGFloat = 60.0 {
    didSet {
      updateTrimmer()
    }
  }
  /**
      The number of the video frames which fill the visible portion of the trimmer timeline. When set the frame width will be calculated automatically. This value must be greater than 0.
  
      - note: You should call `reloadTimelineFrames` to apply changes.
  */
  public var visibleFramesCount: UInt = 5 {
    didSet {
      if visibleFramesCount < 1 {
        log.warning("The visible frames count must be greater than 0. The value won't be changed.")
        visibleFramesCount = oldValue
      }
    }
  }
  /// The time in seconds that defines the video position where the trimming will begin.
  public var startTime: CGFloat {
    return trimmerDashboard.leftFieldTime
  }
  /// The time in seconds that defines the video position where the trimming will end.
  public var endTime: CGFloat {
    return trimmerDashboard.rightFieldTime
  }
  
  /** 
      Determines the scale factor that is applied to the trimmer timeline (timeline is represented by the `videoFramesCollectionView`).
 
      - note: You should call `reloadTimelineFrames` to apply changes.
   */
  public var timelineZoomScale = TrimmerZoomScale.Default {
    didSet {
      trimmerDashboard.centralContainerView.zoomOptionsView?.selectButtonWithTag(timelineZoomScale.rawValue)
    }
  }
  /// The length in seconds that will be cut from the current video asset.
  public var trimmingDuration: CGFloat {
    get {
      return endTime - startTime
    }
  }
  /// The length in seconds of the current video asset. It equals 0.0 by default.
  public var videoDuration: CGFloat {
    if let playerItem = playerItem where playerItem.duration.isNumeric {
      return CGFloat(CMTimeGetSeconds(playerItem.duration))
    } else {
      return 0.0
    }
  }
  /// The timescale that is the most suitable for using with the current player `CMTime` methods.
  public var timescale: CMTimeScale {
    if let playerTimescale = playerItem?.duration.timescale where playerTimescale > 600 {
      return playerTimescale
    } else {
      return 60000
    }
  }
  
  /// The time in seconds representing the minimum allowed trimming time. The default value is 1.0.
  var minTime: CGFloat = 1.0
  /// The object that is used to store/retrieve cached images.
  var cacheManager: YYImageCache = {
    let cacheManager = YYImageCache.createImageCacheManagerWithPath(kTrimmerViewImageCachePath)
    
    // Clear previous cached objects.
    cacheManager.diskCache.removeAllObjects()
    
    cacheManager.memoryCache.countLimit = 30
    return cacheManager
  }()
  /// The array with the cache keys for the thumbnails of the video frames.
  var thumbKeys = [String]()
  /// The collection view used to present the video asset timeline frames.
  var videoFramesCollectionView: UICollectionView!
  /// The left trimmer view slider.
  var leftTrimmerSlider: TrimmerSlider!
  /// The right trimmer view slider.
  var rightTrimmerSlider: TrimmerSlider!
  /// The trimmer view dashboard with text fields displaying trimmer times and additional controls.
  var trimmerDashboard: TrimmerDashboard!
  /// The activity view that is displayed during trimmer reloading.
  var activityView: TrimmerActivityView!

  /// Auto layout constraint that is used to drag left trimmer slider.
  private var leftSliderConstraintForDragging: NSLayoutConstraint!
  /// Auto layout constraint that is used to drag right trimmer slider.
  private var rightSliderConstraintForDragging: NSLayoutConstraint!
  /// Auto layout constraint that is used to change trimmer dashboard x coordinate.
  private var dashboardLeadingConstraint: NSLayoutConstraint!
  /// Gesture recognizer for the left trimmer slider.
  private var leftSliderGestureRecognizer: UIPanGestureRecognizer!
  /// Gesture recognizer for the right trimmer slider.
  private var rightSliderGestureRecognizer: UIPanGestureRecognizer!
  /// The overlay view for the left trimmer slider.
  private var leftOverlayView: UIView!
  /// The overlay view for the right trimmer slider.
  private var rightOverlayView: UIView!
  /// Object that provides thumbnail images of the current video asset to fill the trimmer view timeline.
  private var imageGenerator: AVAssetImageGenerator?
  /// The distance in points from the left edge of the left trimmer view slider to the initial touch point.
  private var initialLeftSliderTouchOffset: CGFloat = -1.0
  /// The distance in points from the right edge of the right trimmer view slider to the initial touch point.
  private var initialRightSliderTouchOffset: CGFloat = -1.0
  /// The identifier of the collection view cell view.
  private let kVideoFramesCellIdentifier = "videoFramesCellId"
  /// Indicates whether the timeline frames are being reloaded.
  private var isReloadingTimelineFrames = false
  /// Indicates whether the player item is currently seeking time.
  private var isSeekingTime = false
  
  
  /**
      Returns the minimum allowed distance between the trimmer sliders.
   
      - note: If the minimum distance in accordance with the current minimum time is bigger than the current maximum allowed distance it will return the `maxAllowedDistance`.
   */
  private var minAllowedDistance: CGFloat {
    let minDistanceAccordingToMinTime = convertTimeToDistance(seconds: minTime)
    let appropriateMinDistance = minDistanceAccordingToMinTime > maxAllowedDistance ? maxAllowedDistance : minDistanceAccordingToMinTime
    return appropriateMinDistance
  }
  /**
      Returns the maximum allowed distance between the trimmer sliders.
   
    - note: If the maximum distance in accordance with the current maximum time is bigger than the current available distance it will return the available distance.
   */
  private var maxAllowedDistance: CGFloat {
    let maxDistanceAccordingToMaxTime = convertTimeToDistance(seconds: maxTime)
    let availableDistance = bounds.width - 2 * SliderAppearance.width
    let appropriateMaxDistance = maxDistanceAccordingToMaxTime > availableDistance ? availableDistance : maxDistanceAccordingToMaxTime

    return appropriateMaxDistance
  }
  /// Returns the current distance between the trimmer sliders.
  private var currentDistanceBetweenSliders: CGFloat {
    return (bounds.width - fabs(rightSliderConstraintForDragging.constant) - rightTrimmerSlider.bounds.width) - (leftSliderConstraintForDragging.constant + leftTrimmerSlider.bounds.width)
  }
  /// Returns the x coordinate (in the trimmer view coordinate system) of the left trimmer slider's right edge.
  private var leftSliderRightEdgeXCoordinate: CGFloat {
    return leftSliderConstraintForDragging.constant + leftTrimmerSlider.bounds.width
  }
  /// Returns the x coordinate (in the trimmer view coordinate system) of the right trimmer slider's left edge.
  private var rightSliderLeftEdgeXCoordinate: CGFloat {
    return (bounds.width - fabs(rightSliderConstraintForDragging.constant) - rightTrimmerSlider.bounds.width)
  }
  
  // MARK: UIView Lifecycle
  public override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  deinit {
    imageGenerator?.cancelAllCGImageGeneration()
    playerItem?.cancelPendingSeeks()
    resetCache()
    removeObserver(self, forKeyPath: "playerItem.status", context: &videoTrimmerViewKvoContext)
  }

  // MARK: Instance methods
  /**
      Converts the video duration in seconds to the trimmer timeline x coordinate. The timeline is represented by the `videoFramesCollectionView`.
   
      - parameter seconds: The time in seconds that must be converted to the trimmer timeline distance.
   
      - returns: x position in the trimmer timeline coordinates.
   */
  public func convertTimeToDistance(seconds seconds: CGFloat) -> CGFloat {
    if seconds <= 0.0 {
      return 0.0
    }
    
    return oneSecondLength * seconds
  }
  
  /** 
      Converts the trimmer timeline x coordinate to the time in seconds.
   
      - parameter distance: The x positon in the trimmer timeline.
   
      - returns: The time in seconds.
   
      - note: If the distance is bigger than the current timeline width the `videoDuration` is returned. If the distance is less than 0 it returns the `0.0`.
   */
  public func convertDistanceToTime(distance distance: CGFloat) -> CGFloat {
    if distance <= 0.0 {
      return 0.0
    }
    
    if distance >= videoFramesCollectionView.collectionViewLayout.collectionViewContentSize().width {
      return videoDuration
    }
    
    return distance / oneSecondLength
  }
  
  public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String: AnyObject]?, context: UnsafeMutablePointer<Void>) {
    // Make sure the this KVO callback was intended for this view.
    guard context == &videoTrimmerViewKvoContext else {
      super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
      return
    }
    
    guard let unwrappedKeyPath = keyPath else { return }
    
    switch unwrappedKeyPath {
    case "playerItem.status":
      let newStatus: AVPlayerItemStatus
      
      if let newStatusAsNumber = change?[NSKeyValueChangeNewKey] as? NSNumber {
        newStatus = AVPlayerItemStatus(rawValue: newStatusAsNumber.integerValue)!
      }
      else {
        newStatus = .Unknown
      }
      
      switch newStatus {
      case .ReadyToPlay:
        reloadTimelineFrames(resultHandler: nil)
      case .Failed:
        log.warning("The current `AVPlayerItem` has `Failed` status.")
      default:
        break
      }
    default:
      break
    }
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    updateDashboard()
  }
  
  /**
      Asynchronously reloads the trimmer view timeline frames. This function must be called only when the video is in `ready to play` state.
   
      - parameter resultHandler: The closure that is called after the frame image has been successfuly generated or the error has occurred.
   
      `resultHandler` parameters:

        * `finished`: Indicates whether all images were successfuly generated.
        * `generatedImagesCount`: The number of the currently generated and stored in the cache timeline images.
        * `processedImagesCount`: The number of the currently processed images regardless of the errors.
        * `currentImage`: The currently generated `UIImage`.
        * `result`: Indicates status of the frame images generation.
        * `error`: `NSError` object in case of an error or `nil`.
   */
  public func reloadTimelineFrames(resultHandler resultHandler: ((reqestedFramesCount: UInt, generatedImagesCount: UInt, processedImagesCount: UInt, currentImage: UIImage?, result: AVAssetImageGeneratorResult, error: NSError?) -> Void)?) {
    if playerItem?.status != .ReadyToPlay { return }
    guard let unwrappedImageGenerator = imageGenerator else {
      log.warning("Failed to obtain the image generator to add frames to the trimmer view timeline.")
      return
    }
    
    guard videoDuration > 0.0 else {
      log.warning("The video duration is incorrect.")
      return
    }
    
    setTrimmerToDefaultState()
    isReloadingTimelineFrames = true
    resetCache()

    activityView.presentActivity()
    
    let frameWidth = videoFramesCollectionView.frame.width / CGFloat(visibleFramesCount)
    let frameSize = CGSizeMake(frameWidth, videoFramesCollectionView.frame.height)
    if let layout = videoFramesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.itemSize = frameSize
    }
    
    let framesCount = visibleFramesCount * UInt(timelineZoomScale.rawValue)
    
    // Prepare times to extract video frames.
    let duration = Double(videoDuration)
    let timeIncrementValue = duration / Double(framesCount)
    var times = [NSValue]()
    var collectionViewIndices = [Double: Int]()
    for frameIndex in 0..<framesCount {
      let seconds = Double(frameIndex) * timeIncrementValue
      let currentTime = CMTimeMakeWithSeconds(seconds > duration ? duration : seconds, timescale)
      times.append(NSValue(CMTime: currentTime))
      collectionViewIndices[CMTimeGetSeconds(currentTime)] = Int(frameIndex)
    }
    
    // Prepare thumbnails array size.
    thumbKeys = [String](count: times.count, repeatedValue: "")
    
    let scale = UIScreen.mainScreen().scale
    let resultingImageSize = CGSizeMake(frameSize.width * scale, frameSize.height * scale)
    
    unwrappedImageGenerator.requestedTimeToleranceBefore = kCMTimeZero
    unwrappedImageGenerator.requestedTimeToleranceAfter = kCMTimeZero
    
    var generatedImagesCount: UInt = 0
    var processedImagesCount: UInt = 0
    
    unwrappedImageGenerator.generateCGImagesAsynchronouslyForTimes(times) {
      [weak self ] requestedTime, image, actualTime, result, error in
      guard let weakSelf = self else {
        log.debug("VideoTrimmerView is not available anymore. The image for requested time \(requestedTime) won't be generated.")
        return
      }
      
      /**
          Performas additional operations in case of an error.
       
          - parameter trimmerViewInstance: The current instance of the `VideoTrimmerView`.
       */
      func handleError(forSelf trimmerViewInstance: VideoTrimmerView) {
        trimmerViewInstance.isReloadingTimelineFrames = false
        trimmerViewInstance.imageGenerator?.cancelAllCGImageGeneration()
        resultHandler?(reqestedFramesCount: framesCount, generatedImagesCount: generatedImagesCount, processedImagesCount: processedImagesCount, currentImage: nil, result: result, error: error)
      }
      
      dispatch_async(dispatch_get_main_queue()) {
        processedImagesCount += 1
        
        switch result {
        case .Succeeded:
          guard let cgImage = image, let currentFrameImage = UIImage(CGImage: cgImage).yy_imageByResizeToSize(resultingImageSize, contentMode: .ScaleAspectFill)  else {
            log.error("Failed to generate image for the requested time \(requestedTime).")
            handleError(forSelf: weakSelf)
            return
          }
          
          let requestedSeconds = CMTimeGetSeconds(requestedTime)
          let currentFrameCacheKey = "thumbnailKeyWithId:\(requestedSeconds)"

          if let thumbIndex = collectionViewIndices[requestedSeconds] {
            weakSelf.thumbKeys[thumbIndex] = currentFrameCacheKey
          } else {
            log.error("Failed to save the extracted image from the video because the thumnails array index is invalid.")
            handleError(forSelf: weakSelf)
            return
          }
          
          weakSelf.cacheManager.sh_setImage(currentFrameImage, forKey: currentFrameCacheKey) {
            [weak self] key, error in
            guard let weakWeakSelf = self else { return }
            
            dispatch_async(dispatch_get_main_queue()) {
              if let error = error {
                log.error("Failed to store the image in the cache. The error description: \(error.localizedDescription)")
                handleError(forSelf: weakWeakSelf)
                return
              }
              
              generatedImagesCount += 1
              resultHandler?(reqestedFramesCount: framesCount, generatedImagesCount: generatedImagesCount, processedImagesCount: processedImagesCount, currentImage: currentFrameImage, result: .Succeeded, error: nil)
              
              if generatedImagesCount == framesCount {
                weakWeakSelf.finalizeTimelineFramesLoading()
              }
            }
          }
        case .Failed:
          log.warning("Image generation failed because of the error \(error?.localizedDescription)")
          handleError(forSelf: weakSelf)
        case .Cancelled:
          log.debug("Image generation was cancelled")
          weakSelf.isReloadingTimelineFrames = false
          resultHandler?(reqestedFramesCount: framesCount, generatedImagesCount: generatedImagesCount, processedImagesCount: processedImagesCount,  currentImage: nil, result: .Cancelled, error: error)
        }
      }
    }
  }
  
  /**
      Moves the playback cursor to the specified time.
   
      - parameter time: The time in seconds the playhead must be moved to.
      - parameter chaseToStartTime: Indicates whether the resulting playhead time must be equal to the start trimmer time. If `false` the resulting seeking time is compared with the end trimmer time.
   */
  public func seekToTime(time: CGFloat, chaseToStartTime: Bool) {
    guard let unwrappedPlayerItem = playerItem where unwrappedPlayerItem.status == .ReadyToPlay &&  !isSeekingTime else {
      return
    }
    
    isSeekingTime = true
    unwrappedPlayerItem.seekToTime(CMTimeMakeWithSeconds(Double(time), timescale), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero) {
      [weak self] finished in
      guard let weakSelf = self else { return }
      guard finished else { return }
      
      dispatch_async(dispatch_get_main_queue()) {
        weakSelf.isSeekingTime = false
        if chaseToStartTime {
          if time != weakSelf.startTime {
            weakSelf.seekToTime(weakSelf.startTime, chaseToStartTime: true)
          }
        } else {
          if time != weakSelf.endTime {
            weakSelf.seekToTime(weakSelf.endTime, chaseToStartTime: false)
          }
        }
      }
    }
  }
  
  /**
      Action method of the left slider pan gestrue recognizer.
   
      - parameter sender: The pan gesture recognizer.
   */
  func leftSliderDragged(sender: UIPanGestureRecognizer) {
    switch sender.state {
    case .Began:
      initialLeftSliderTouchOffset = sender.locationInView(self).x - leftTrimmerSlider.frame.origin.x
    case .Changed:
      // Calculate the distance from the initial touch point to the current location.
      let delta = sender.locationInView(self).x - initialLeftSliderTouchOffset
      moveTrimmerSlider(leftTrimmerSlider, toXCoordinate: delta)
      updateDistanceBetweenSliders(draggedSlider: leftTrimmerSlider)
      updateTimes()
      seekToTime(startTime, chaseToStartTime: true)
    case .Ended, .Cancelled, .Failed:
      updateDistanceBetweenSliders(draggedSlider: leftTrimmerSlider)
    default:
      break
    }
  }

  /**
      Action method of the right slider pan gestrue recognizer.
   
      - parameter sender: The pan gesture recognizer.
   */
  func rightSliderDragged(sender: UIPanGestureRecognizer) {
    switch sender.state {
    case .Began:
      initialRightSliderTouchOffset = (rightTrimmerSlider.frame.origin.x + rightTrimmerSlider.frame.size.width) - sender.locationInView(self).x
    case .Changed:
      // Calculate the distance from the initial touch point to the current location.
      // - note: When the right slider is moved to the left its dragging constraint constant is reduced.
      let delta = (bounds.width - sender.locationInView(self).x) - initialRightSliderTouchOffset
      moveTrimmerSlider(rightTrimmerSlider, toXCoordinate: delta)
      updateDistanceBetweenSliders(draggedSlider: rightTrimmerSlider)
      updateTimes()
      seekToTime(endTime, chaseToStartTime: false)
    case .Ended, .Cancelled, .Failed:
      updateDistanceBetweenSliders(draggedSlider: rightTrimmerSlider)
    default:
      break
    }
  }
  
  /**
      Changes the given slider position in accordance with the current video duration and available trimmer length which is defined by the video frames collection view content width.
   
      - parameter slider: The trimmer slider that must be moved.
      - parameter xCoordinate: The new x coordinate of the trimmer slider in the trimmer timeline coordinate system. It must be greater than 0 for both sliders and less than the available trimmer view width.
   
      - note: The dragging constraint constant represents x coordinate in the timeline coordinate system.
   */
  func moveTrimmerSlider(slider: TrimmerSlider, toXCoordinate xCoordinate: CGFloat) {
    let currentConstraintForDragging = slider.isRight ? rightSliderConstraintForDragging : leftSliderConstraintForDragging
    guard xCoordinate >= 0.0 else {
      currentConstraintForDragging.constant = 0.0
      return
    }
    
    let availableDistance = bounds.width - 2 * SliderAppearance.width - minAllowedDistance
    guard xCoordinate < availableDistance else {
      currentConstraintForDragging.constant = slider.isRight ? -availableDistance : availableDistance
      return
    }
    
    currentConstraintForDragging.constant = slider.isRight ? -xCoordinate : xCoordinate
  }
  
  /**
      Changes the given slider timeline position in accordance with the given time.
   
      - parameter slider: The trimmer slider that must be moved.
      - parameter time: The time in seconds the slider must be moved to.
   */
  func moveTrimmerSlider(slider: TrimmerSlider, toTime time: CGFloat) {
    guard videoDuration > 0.0 else { return }
    guard time >= 0.0 && time <= (slider.isRight ? videoDuration : (videoDuration - minTime)) else {
      log.warning("The slider won't be moved because the time value is out of bounds.")
      return
    }
    
    let distanceMatchingTime = convertTimeToDistance(seconds: time)
    let newXCoordinate = distanceMatchingTime - videoFramesCollectionView.contentOffset.x
    moveTrimmerSlider(slider, toXCoordinate: slider.isRight ? bounds.width - leftTrimmerSlider.bounds.width - rightTrimmerSlider.bounds.width - newXCoordinate : newXCoordinate)
  }
  
  /// Clears the cache from the outdated thumbnails and removes all keys from the `thumbKeys` array.
  func resetCache() {
    for key in thumbKeys {
      cacheManager.removeImageForKey(key)
    }
    thumbKeys.removeAll()
  }
  
  /**
      Recalculates the distance between the trimmer sliders in accordance with the current time constraints.
   
      - parameter slider: The trimmer slider that was dragged. The distance will be updated by moving the opposite slider.
   
      - note: If the dragged slider is located at right side the left draggable costraint constant must be updated. If the dragged slider is located at left side the right draggable costraint constant must be updated.
   */
  func updateDistanceBetweenSliders(draggedSlider slider: TrimmerSlider) {
    let currentDistance = currentDistanceBetweenSliders
    let constraintForUpdate = slider.isRight ? leftSliderConstraintForDragging : rightSliderConstraintForDragging
    if currentDistance < minAllowedDistance {
      let offset = minAllowedDistance - currentDistance
      var resultingConstant = constraintForUpdate.constant - (slider.isRight ? offset : -offset)
      
      // Check constant bounds. 
      if slider.isRight {
        // The right slider constant must always be equal or less than 0.
        resultingConstant = resultingConstant > 0 ? resultingConstant : 0.0
      } else {
        // The left slider constant must always be equal or greater than 0.
        resultingConstant = resultingConstant < 0 ? resultingConstant : 0.0
      }
      constraintForUpdate.constant = resultingConstant
    } else if currentDistance > maxAllowedDistance {
      let offset = currentDistance - maxAllowedDistance
      constraintForUpdate.constant += slider.isRight ? offset : -offset
    }
  }
  
  /// Recalculates the trimmer dashboard frame size and position in accordance with the current sliders placement.
  func updateDashboard() {
    // Update dashboard width.
    trimmerDashboard.widthConstraint.constant = (currentDistanceBetweenSliders > trimmerDashboard.minWidth) ? currentDistanceBetweenSliders : trimmerDashboard.minWidth

    // Prevent off-screen position on rotation.
    if dashboardLeadingConstraint.constant + trimmerDashboard.widthConstraint.constant > bounds.width {
      dashboardLeadingConstraint.constant = leftTrimmerSlider.bounds.width
    } else if dashboardLeadingConstraint.constant < 0.0 {
      dashboardLeadingConstraint.constant = bounds.width - trimmerDashboard.widthConstraint.constant - rightTrimmerSlider.bounds.width
    }
    
    // Align dashboard position.
    var resultingConstant: CGFloat?
    let dashboardRightEdgeXCoordinate = dashboardLeadingConstraint.constant + trimmerDashboard.widthConstraint.constant
    if dashboardLeadingConstraint.constant < leftSliderRightEdgeXCoordinate && dashboardRightEdgeXCoordinate < rightSliderLeftEdgeXCoordinate {
      // Align dashboard by the right slider's left edge.
      resultingConstant = rightSliderLeftEdgeXCoordinate - trimmerDashboard.widthConstraint.constant
    } else if dashboardRightEdgeXCoordinate > rightSliderLeftEdgeXCoordinate &&
      dashboardLeadingConstraint.constant > leftSliderRightEdgeXCoordinate {
      // Align dashboard by the left slider's right edge.
      resultingConstant = leftSliderRightEdgeXCoordinate
    }
    
    // Ensure that the dashboard is not out of bounds.
    if let resultingConstant = resultingConstant where resultingConstant >= 0.0 && resultingConstant + trimmerDashboard.widthConstraint.constant < bounds.width {
      dashboardLeadingConstraint.constant = resultingConstant
    }
  }
  
  /// Recalculates the trimmer times in accordance with the trimmer sliders current positions.
  func updateTimes() {
    // Calculate start time.
    let leftSliderRightEdgePoint = CGPointMake(leftSliderRightEdgeXCoordinate, bounds.origin.y)
    var leftSliderTime = convertDistanceToTime(distance: convertPoint(leftSliderRightEdgePoint, toView: videoFramesCollectionView).x)

    // Calculate end time.
    let rightSliderLeftEdgePoint = CGPointMake(rightSliderLeftEdgeXCoordinate, bounds.origin.y)
    var rightSliderTime = convertDistanceToTime(distance: convertPoint(rightSliderLeftEdgePoint, toView: videoFramesCollectionView).x)
    
    // Correct time bounds.
    let kEpsilon: CGFloat = 0.001
    leftSliderTime = floor(leftSliderTime + kEpsilon)
    rightSliderTime = floor(rightSliderTime + kEpsilon)

    if (rightSliderTime - leftSliderTime) - maxTime > -kEpsilon {
      rightSliderTime = leftSliderTime + maxTime
    } else if (rightSliderTime - leftSliderTime) - minTime < kEpsilon {
      let expectedRightSliderTime = leftSliderTime + minTime
      rightSliderTime = expectedRightSliderTime >= videoDuration ? videoDuration : expectedRightSliderTime
    }
    
    // Update values if the times are not out of bounds.
    guard let formattedStartTimeString = NSDateComponents.getTrimmerTimesFormatter().stringFromTimeInterval(Double(leftSliderTime)) else {
      log.warning("Failed to calculate the trimmer start time.")
      return
    }
    
    guard let formattedEndTimeString = NSDateComponents.getTrimmerTimesFormatter().stringFromTimeInterval(Double(rightSliderTime)) else {
      log.warning("Failed to calculate the trimmer end time.")
      return
    }
    
    trimmerDashboard.leftFieldTime = leftSliderTime
    trimmerDashboard.startTimeField.text = formattedStartTimeString
    
    trimmerDashboard.rightFieldTime = rightSliderTime
    trimmerDashboard.endTimeField.text = formattedEndTimeString
    trimmerDashboard.updateTotalTime()
    
    delegate?.trimmerView(self, didChangeStartTime: startTime, andEndTime: endTime)
  }

  /// The common initializer of the `VideoTrimmerView` properties.
  private func commonInit() {
    XCGLogger.sh_configureDefaultLogger()
    
    addObserver(self, forKeyPath: "playerItem.status", options: [.Initial, .New], context: &videoTrimmerViewKvoContext)
    
    // Configure the collection view layout.
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .Horizontal
    // Item size must be always greater than zero.
    layout.itemSize = CGSizeMake(1, 1)
    layout.minimumLineSpacing = 0.0
    layout.minimumInteritemSpacing = 0.0
    
    // Configure the collection view.
    videoFramesCollectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
    videoFramesCollectionView.dataSource = self
    videoFramesCollectionView.delegate = self
    
    videoFramesCollectionView.registerClass(TimelineCell.self, forCellWithReuseIdentifier: kVideoFramesCellIdentifier)
    
    addSubview(videoFramesCollectionView)
    
    // Configure overlay views.
    leftOverlayView = UIView(frame: CGRectZero)
    leftOverlayView.backgroundColor = TrimmerAppearance.overlayViewsBackgroundColor
    leftOverlayView.alpha = TrimmerAppearance.overlayViewsAlphaValue
    rightOverlayView = UIView(frame: CGRectZero)
    rightOverlayView.backgroundColor = TrimmerAppearance.overlayViewsBackgroundColor
    rightOverlayView.alpha = TrimmerAppearance.overlayViewsAlphaValue
    
    leftOverlayView.translatesAutoresizingMaskIntoConstraints = false
    rightOverlayView.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(leftOverlayView)
    addSubview(rightOverlayView)
    
    // Configure trimmer sliders.
    leftTrimmerSlider = TrimmerSlider(frame: CGRectZero)
    rightTrimmerSlider = TrimmerSlider(frame: CGRectZero)
    rightTrimmerSlider.isRight = true
    
    addSubview(leftTrimmerSlider)
    addSubview(rightTrimmerSlider)
    
    // Configure zoom options view.
    let zoomOptionsView = ZoomOptionsView(frame: CGRectZero)
    zoomOptionsView.zoomOptionButtonTapHandler = {
      [weak self] sender in
      guard let weakSelf = self else { return }
      guard let newZoomScale = TrimmerZoomScale(rawValue: sender.tag) else {
        log.error("Failed to set the new trimmer timeline zoom scale.")
        return
      }
      
      weakSelf.timelineZoomScale = newZoomScale
      weakSelf.reloadTimelineFrames(resultHandler: nil)
    }
    
    addSubview(zoomOptionsView)
    
    // Configure the trimmer dashboard.
    trimmerDashboard = TrimmerDashboard(frame: CGRectZero)
    trimmerDashboard.centralContainerView.zoomOptionsView = zoomOptionsView
    
    addSubview(trimmerDashboard)
    
    // Configure the activity view.
    activityView = TrimmerActivityView(frame: CGRectZero)
    
    addSubview(activityView)
    
    // Configure the constraints.
    var allConstraints = [NSLayoutConstraint]()
    let views = ["videoFramesCollectionView": videoFramesCollectionView,
                 "leftTrimmerSlider": leftTrimmerSlider,
                 "rightTrimmerSlider": rightTrimmerSlider,
                 "leftOverlayView": leftOverlayView,
                 "rightOverlayView": rightOverlayView,
                 "dashboard": trimmerDashboard,
                 "activityView": activityView]
    let metrics = ["collectionViewTopOffset": TrimmerAppearance.trimmerSlidersHeightOffset / 2 + DashboardAppearance.height,
                   "collectionViewBottomOffset": TrimmerAppearance.trimmerSlidersHeightOffset / 2,
                   "sliderWidth": SliderAppearance.width]
    
    // Trimmer dashboard constraints.
    let dashboardVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-0-[dashboard]",
      options: [],
      metrics: metrics,
      views: views)
    allConstraints += dashboardVerticalConstraints
    
    
    dashboardLeadingConstraint = NSLayoutConstraint(item: trimmerDashboard,
                       attribute: .Leading,
                       relatedBy: .Equal,
                       toItem: self,
                       attribute: .Leading,
                       multiplier: 1.0,
                       constant: leftTrimmerSlider.frame.width)
    allConstraints += [dashboardLeadingConstraint]

    // Collection view constraints.
    videoFramesCollectionView.translatesAutoresizingMaskIntoConstraints = false
    
    let collectionViewVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-collectionViewTopOffset-[videoFramesCollectionView]-collectionViewBottomOffset-|",
      options: [],
      metrics: metrics,
      views: views)
    allConstraints += collectionViewVerticalConstraints
    
    let collectionViewHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-sliderWidth-[videoFramesCollectionView]-sliderWidth-|",
      options: [],
      metrics: metrics,
      views: views)
    allConstraints += collectionViewHorizontalConstraints
    
    // Left trimmer slider constraints.
    let leftSliderConstraints = getConstraintsForTrimmerSlider(leftTrimmerSlider, toItem: videoFramesCollectionView)
    // This constraint will be used for dragging.
    let leftTrimmerSliderLeadingConstraint = NSLayoutConstraint(item: leftTrimmerSlider,
                                                              attribute: .Leading,
                                                              relatedBy: .Equal,
                                                              toItem: self,
                                                              attribute: .Leading,
                                                              multiplier: 1.0,
                                                              constant: 0.0)
    leftSliderConstraintForDragging = leftTrimmerSliderLeadingConstraint
    // Right trimmer slider constraints.
    let rightSliderConstraints = getConstraintsForTrimmerSlider(rightTrimmerSlider, toItem: videoFramesCollectionView)
    // This constraint will be used for dragging.
    let rightTrimmerSliderTrailingConstraint = NSLayoutConstraint(item: rightTrimmerSlider,
                                                               attribute: .Trailing,
                                                               relatedBy: .Equal,
                                                               toItem: self,
                                                               attribute: .Trailing,
                                                               multiplier: 1.0,
                                                               constant: 0.0)
    rightSliderConstraintForDragging = rightTrimmerSliderTrailingConstraint
    allConstraints += leftSliderConstraints
    allConstraints += rightSliderConstraints
    allConstraints += [leftTrimmerSliderLeadingConstraint, rightTrimmerSliderTrailingConstraint]
    
    // Overlay views constraints.
    let leftOverlayHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-0-[leftOverlayView]-0-[leftTrimmerSlider]",
      options: [.AlignAllCenterY],
      metrics: metrics,
      views: views)
    allConstraints += leftOverlayHorizontalConstraints
    
    let rightOverlayHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
      "H:[rightTrimmerSlider]-0-[rightOverlayView]-0-|",
      options: [.AlignAllCenterY],
      metrics: metrics,
      views: views)
    allConstraints += rightOverlayHorizontalConstraints
    
    let leftOverlayHeightConstraint = NSLayoutConstraint(item: leftOverlayView,
                                                         attribute: .Height,
                                                         relatedBy: .Equal,
                                                         toItem: leftTrimmerSlider,
                                                         attribute: .Height,
                                                         multiplier: 1.0,
                                                         constant: 0.0)
    let rightOverlayHeightConstraint = NSLayoutConstraint(item: rightOverlayView,
                                                         attribute: .Height,
                                                         relatedBy: .Equal,
                                                         toItem: rightTrimmerSlider,
                                                         attribute: .Height,
                                                         multiplier: 1.0,
                                                         constant: 0.0)
    allConstraints += [leftOverlayHeightConstraint, rightOverlayHeightConstraint]

    // Zoom options buttons constraints.
    NSLayoutConstraint(item: zoomOptionsView,
                       attribute: .Height,
                       relatedBy: .Equal,
                       toItem: trimmerDashboard,
                       attribute: .Height,
                       multiplier: 1.0,
                       constant: 0.0).active = true
    
    NSLayoutConstraint(item: zoomOptionsView,
                       attribute: .CenterX,
                       relatedBy: .Equal,
                       toItem: trimmerDashboard,
                       attribute: .CenterX,
                       multiplier: 1.0,
                       constant: 0.0).active = true
    
    let zoomOptionsYPositionConstraint = NSLayoutConstraint(item: zoomOptionsView,
                                                        attribute: .Top,
                                                        relatedBy: .Equal,
                                                        toItem: self,
                                                        attribute: .Top,
                                                        multiplier: 1.0,
                                                        constant: 0.0)
    zoomOptionsView.zoomOptionsYPositionConstraint = zoomOptionsYPositionConstraint
    zoomOptionsYPositionConstraint.active = true
    
    // Activity view constraints.
    let activityHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-0-[activityView]-0-|",
      options: [],
      metrics: metrics,
      views: views)
    allConstraints += activityHorizontalConstraints
    
    let activityVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-0-[activityView]-0-|",
      options: [],
      metrics: metrics,
      views: views)
    allConstraints += activityVerticalConstraints
    
    NSLayoutConstraint.activateConstraints(allConstraints)
    
    // Configure gesture recognizers.
    leftSliderGestureRecognizer = ImmediatePanGestureRecognizer(target: self, action: #selector(VideoTrimmerView.leftSliderDragged(_:)))
    leftSliderGestureRecognizer.delaysTouchesBegan = true
    leftSliderGestureRecognizer.enabled = false
    leftTrimmerSlider.addGestureRecognizer(leftSliderGestureRecognizer)
    
    rightSliderGestureRecognizer = ImmediatePanGestureRecognizer(target: self, action: #selector(VideoTrimmerView.rightSliderDragged(_:)))
    rightSliderGestureRecognizer.delaysTouchesBegan = true
    rightSliderGestureRecognizer.enabled = false
    rightTrimmerSlider.addGestureRecognizer(rightSliderGestureRecognizer)
  }
  
  /// Sets the default trimmer view constrols states.
  private func setTrimmerToDefaultState() {
    leftSliderGestureRecognizer.enabled = false
    rightSliderGestureRecognizer.enabled = false
  }
  
  /// Performs additional operations when the timeline frames have been successfuly generated.
  private func finalizeTimelineFramesLoading() {
    videoFramesCollectionView.reloadData()

    updateTrimmer()
    
    leftSliderGestureRecognizer.enabled = true
    rightSliderGestureRecognizer.enabled = true
    isReloadingTimelineFrames = false
    
    activityView.dismissActivity()
  }
  
  /**
      Constructs the `NSLayoutConstraint` array for the given trimmer slider.
     
      - parameter slider: The trimmer view slider.
      - parameter item: The `UIView` object for the right side of the constraint equation.
   
      - returns: The array with the trimmer slider constraints.
   */
  private func getConstraintsForTrimmerSlider(slider: TrimmerSlider, toItem item: UIView) -> [NSLayoutConstraint] {
    let heightConstraint = NSLayoutConstraint(item: slider,
                                             attribute: .Height,
                                             relatedBy: .Equal,
                                             toItem: item,
                                             attribute: .Height,
                                             multiplier: 1.0,
                                             constant: TrimmerAppearance.trimmerSlidersHeightOffset)

    let alignYConstraint = NSLayoutConstraint(item: slider,
                                             attribute: .CenterY,
                                             relatedBy: .Equal,
                                             toItem: item,
                                             attribute: .CenterY,
                                             multiplier: 1.0,
                                             constant: 0.0)
    return [heightConstraint, alignYConstraint]
  }
  
  /// Reconfigures the trimmer view in accordance with the new zoom scale and time constraints.
  private func updateTrimmer() {
    guard playerItem?.status == . ReadyToPlay else { return }
    
    updateTimelineContentOffset()
    moveTrimmerSlider(leftTrimmerSlider, toTime: startTime)
    let rightSliderTime = endTime == 0.0 ? startTime + maxTime : endTime
    moveTrimmerSlider(rightTrimmerSlider, toTime: rightSliderTime >= videoDuration ? videoDuration: rightSliderTime)
    
    updateDistanceBetweenSliders(draggedSlider: leftTrimmerSlider)
    updateDashboard()
    updateTimes()
    
    seekToTime(startTime, chaseToStartTime: true)
  }
  
   /**
      Changes the content offset of the `videoFramesCollectionView` (timeline) in accordance with the current trimmer times and the current timeline zoom scale to make all trimmer frames be visible. Then `endTime` can be reduced to fit the current visible trimmer range.
 
      - note: This function aligns the trimmer range by the left trimmer view edge.
    */
  private func updateTimelineContentOffset() {
    var startTimeDistance = convertTimeToDistance(seconds: startTime)
    
    let visiblePart = videoFramesCollectionView.collectionViewLayout.collectionViewContentSize().width - startTimeDistance
    // Ensure that the timeline fits the available width for the visible frames.
    if visiblePart < videoFramesCollectionView.bounds.width {
      startTimeDistance -= (videoFramesCollectionView.bounds.width - visiblePart)
    }
    
    videoFramesCollectionView.contentOffset.x = startTimeDistance
  }
}

// MARK: UIScrollViewDelegate
extension VideoTrimmerView: UIScrollViewDelegate {
  public func scrollViewDidScroll(scrollView: UIScrollView) {
    if !isReloadingTimelineFrames {
      updateTimes()
      seekToTime(startTime, chaseToStartTime: true)
    }
  }
}

// MARK: UICollectionViewDelegate
extension VideoTrimmerView: UICollectionViewDelegate {
  public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    timelineTapHandler?(collectionView: collectionView, tappedAtIndexPath: indexPath)
  }
}

// MARK: UICollectionViewDataSource
extension VideoTrimmerView: UICollectionViewDataSource {
  public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return thumbKeys.count
  }
  
  public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kVideoFramesCellIdentifier, forIndexPath: indexPath) as! TimelineCell
    let thumbIndex = indexPath.item
    guard thumbIndex > 0 && thumbIndex < thumbKeys.count else {
      log.debug("The image for the current cell index (\(thumbIndex)) is being generated.")
      return cell
    }
    
    let currentImageKey = thumbKeys[thumbIndex]
    guard currentImageKey.characters.count > 0 else { return cell}
    cell.uniqueIdentifier = currentImageKey
    
    cacheManager.sh_getImageForKey(currentImageKey) {
      [weak self] image, key, error in
      guard self != nil else { return }
      
      dispatch_async(dispatch_get_main_queue()) {
        // Check if the cell has not been reused.
        if cell.uniqueIdentifier == key {
          guard let unwrappedImage = image else {
            log.debug("Failed to get the image from the cache. Possibly it is still being generated.")
            
            return
          }
          
          cell.imageView.image = unwrappedImage
        }
      }
    }
    
    return cell
  }
}
