//
//  GFFramesExtractorViewController.swift
//  GifFactoryApp
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import Foundation
import UIKit
import Photos
import SVProgressHUD
import YYWebImage
import VideoTrimmerView

/**
	KVO context used to differentiate KVO callbacks for this class versus other
	classes in its class hierarchy.
 */
private var framesExtractorControllerKVOContext = 0

/// Progress indicator status message.
private let progressMessage = NSLocalizedString("Loading Video Asset", comment: "Progress bar message when loading the video asset.")

/**
	View controller containing a player view and controls to set video frames extraction parameters.
 */
class GFFramesExtractorViewController: UIViewController, GFBackgroundAlertDismissing {
  // MARK: - GFBackgroundAlertDismissing
  var _backgroundAlertDismissingObserver: NSObjectProtocol?
  
  // MARK: Properties
  /// An instance of AVPlayer to play a single asset.
  let player = AVPlayer()
  /// The options for requesting a representation of the video asset for playback.
  let videoAssetRequestOptions: PHVideoRequestOptions = {
    let videoRequestOptions = PHVideoRequestOptions()
    videoRequestOptions.version = .Current
    videoRequestOptions.deliveryMode = .Automatic
    videoRequestOptions.networkAccessAllowed = true
    videoRequestOptions.progressHandler = {
      progress, error, stop, info in
      
      if error != nil || stop.memory.boolValue == true {
        if SVProgressHUD.isVisible() {
          SVProgressHUD.dismiss()
        }
      }
      
      if progress >= 1.0 {
        SVProgressHUD.showSuccessWithStatus(NSLocalizedString("Video Asset is Loaded", comment:"Success message indicating the video asset has been loaded."))
      } else {
        SVProgressHUD.showProgress(Float(progress), status: progressMessage)
      }
    }
    
    return videoRequestOptions
  }()

  /// An asset that represents a video file.
  var asset: PHAsset?
  /// Object that provides thumbnail or preview images of the video asset.
  var imageGenerator: AVAssetImageGenerator?
  /// Current request identifier that can be used to cancel the operation.
  var videoAssetRequestID: PHImageRequestID?
  /// Current video asset duration.
  var duration: Double {
    guard let currentItem = player.currentItem else { return 0.0 }
    
    return CMTimeGetSeconds(currentItem.duration)
  }
  /// The time the playback cursor stays at.
  var currentTime: Double {
    get {
      return CMTimeGetSeconds(player.currentTime())
    }
    set {
      let newTime = CMTimeMakeWithSeconds(newValue, 1)
      player.seekToTime(newTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
    }
  }
  /// The current rate of playback.
  var rate: Float {
    get {
      return player.rate
    }
    
    set {
      player.rate = newValue
    }
  }
  /// Indicates whether the video is currently playing.
  var isPlaying: Bool {
    return rate != 0 && player.error == nil
  }
  /// An `AVPlayerItem` represents the presentation state of an asset that’s played by an `AVPlayer` object. When it's set the item of the current player is replaced automatically.
  private var playerItem: AVPlayerItem? {
    didSet {
      /*
       If needed, configure player item here before associating it with a player.
       (example: adding outputs, setting text style rules, selecting media options)
       */
      player.replaceCurrentItemWithPlayerItem(self.playerItem)
    }
  }
  /// Specifies the maximum video length (in seconds) allowed for trimming.
  private let kMaxTrimmingTime: CGFloat = 40.0
  /// The identifier that is used to detect the segue to the editor controller.
  private let kEditorControllerSegueIdentifier = "GFEditorViewControllerSegue"
  /// A token obtained from calling `player`'s `addPeriodicTimeObserverForInterval(_:queue:usingBlock:)` method.
  private var timeObserverToken: AnyObject?


  // MARK: - IBOutlets
  /// The view that is used to display video asset.
  @IBOutlet var playerView: GFPlayerView!
  /// The view that is used to present video trimming controls.
  @IBOutlet var trimmerView: VideoTrimmerView!
  /// The gesture recognizer that is used to start/stop video playing on tap.
  @IBOutlet var tapRecognizer: UITapGestureRecognizer!
  /// The UIToolbar leftside flexible space.
  @IBOutlet var leftFlexibleSpace: UIBarButtonItem!
  /// The toolbar button used to start video playing.
  @IBOutlet var playBarButton: UIBarButtonItem!
  /// The toolbar button used to stop video playing.
  @IBOutlet var pauseBarButton: UIBarButtonItem!
  /// The UIToolbar rightside flexible space.
  @IBOutlet var rightFlexibleSpace: UIBarButtonItem!
  /// The bottom toolbar with video controls.
  @IBOutlet var videoControlsToolbar: UIToolbar!
  /// The bottom that is used to beging extracting frames from the video asset.
  @IBOutlet var doneBarButton: UIBarButtonItem!
  
  
  // MARK: - IBActions
  /// Invoked when the user has tapped the `Play` button.
  @IBAction func playBarButtonPressed(sender: AnyObject) {
    playVideo()
  }
  
  /// Invoked when the user has tapped the `Pause` button.
  @IBAction func pauseBarButtonPressed(sender: AnyObject) {
    pauseVideo()
  }
  
  /// Invoked when the user has tapped the `Cancel` button.
  @IBAction func cancelFramesExtractorBarButtonPressed(sender: AnyObject) {
    navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  /// Invoked when the user has tapped the video frame.
  @IBAction func playerViewTapped(recognizer: UITapGestureRecognizer) {
    if isPlaying {
      pauseVideo()
    } else {
      playVideo()
    }
  }
  
  
  // MARK: - View Controller
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
    
    /*
     Update the UI when these player properties change.
     
     Use the context parameter to distinguish KVO for our particular observers
     and not those destined for a subclass that also happens to be observing
     these properties.
     */
    addObserver(self, forKeyPath: "player.currentItem.duration", options: [.New, .Initial], context: &framesExtractorControllerKVOContext)
    addObserver(self, forKeyPath: "player.rate", options: [.New, .Initial], context: &framesExtractorControllerKVOContext)
    addObserver(self, forKeyPath: "player.currentItem.status", options: [.New, .Initial], context: &framesExtractorControllerKVOContext)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector:
      #selector(GFFramesExtractorViewController.playerDidFinishPlaying(_:)),
                                                     name: AVPlayerItemDidPlayToEndTimeNotification,
                                                     object: playerItem)

    
    // The closure will be invoked every second during playback to report changing time.
    let interval = CMTimeMake(1, 1)
    timeObserverToken = player.addPeriodicTimeObserverForInterval(interval, queue: dispatch_get_main_queue()) {
      [weak self] time in
      guard let weakSelf = self else { return }
      
      let playTime = CMTimeGetSeconds(time)
        if CGFloat(playTime) >= weakSelf.trimmerView.endTime {
            weakSelf.trimmerView.seekToTime(weakSelf.trimmerView.startTime, chaseToStartTime: true)
        }
    }
    
    SVProgressHUD.showWithStatus(progressMessage)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(true)
    
    asynchronouslyLoadVideoAsset()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(true)
    
    if SVProgressHUD.isVisible() {
      SVProgressHUD.dismiss()
    }
    
    if let videoAssetRequestID = videoAssetRequestID {
      let imageManager = PHImageManager.defaultManager()
      imageManager.cancelImageRequest(videoAssetRequestID)
    }
    
    if let timeObserverToken = timeObserverToken {
      player.removeTimeObserver(timeObserverToken)
      self.timeObserverToken = nil
    }
    
    player.pause()
    
    removeObserver(self, forKeyPath: "player.currentItem.duration", context: &framesExtractorControllerKVOContext)
    removeObserver(self, forKeyPath: "player.rate", context: &framesExtractorControllerKVOContext)
    removeObserver(self, forKeyPath: "player.currentItem.status", context: &framesExtractorControllerKVOContext)
    
    NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: playerItem)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    trimmerView.maxTime = kMaxTrimmingTime
    trimmerView.timelineTapHandler = {
      timeline, frameIndex in
      if self.isPlaying {
        self.pauseVideo()
      } else {
        self.playVideo()
      }
    }
    
    videoControlsToolbar.barTintColor = kGlobalTintColor
    
    addBackgroundAlertDismissingObserver()
    setupInitialVideoControlsStates()
  }
  
  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    
    coordinator.animateAlongsideTransition({ context in
      self.trimmerView.reloadTimelineFrames(resultHandler: nil)
    }, completion: nil)
  }
  
  // Update our UI when player or `player.currentItem` changes.
  override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String: AnyObject]?, context: UnsafeMutablePointer<Void>) {
    // Make sure the this KVO callback was intended for this view controller.
    guard context == &framesExtractorControllerKVOContext else {
      super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
      return
    }
    
    guard let unwrappedKeyPath = keyPath else { return }

    switch unwrappedKeyPath {
    case "player.currentItem.status":
      let newStatus: AVPlayerItemStatus
      
      if let newStatusAsNumber = change?[NSKeyValueChangeNewKey] as? NSNumber {
        newStatus = AVPlayerItemStatus(rawValue: newStatusAsNumber.integerValue)!
      }
      else {
        newStatus = .Unknown
      }
      
      if newStatus == .ReadyToPlay {
        setVideoReadyToPlayState()
      } else if newStatus == .Failed {
        setVideoFailedState()
        
        // Display an error if status becomes `.Failed`.
        let errorTitle = NSLocalizedString("The Video Cannot Be Played", comment: "Error title concerning failed AVPlayerItemStatus.")
        var errorMessage: String!
        if let error = player.currentItem?.error {
          errorMessage = error.localizedDescription
        } else {
          errorMessage = NSLocalizedString("Ensure that you have chosen the correct video asset.", comment: "Error message concerning failed AVPlayerItemStatus.")
        }
        
        dispatch_async(dispatch_get_main_queue()) {
          UIAlertController.sh_showAlertFromViewController(self, withTitle: errorTitle, andMessage: errorMessage)
        }
      }
    default:
      break
    }
  }
  
  // Trigger KVO for anyone observing our properties affected by player and player.currentItem
  override class func keyPathsForValuesAffectingValueForKey(key: String) -> Set<String> {
    let affectedKeyPathsMappingByKey: [String: Set<String>] = [
      "duration":     ["player.currentItem.duration"],
      "rate":         ["player.rate"],
      "currentTime":  ["player.currentItem.currentTime"],
    ]
    
    return affectedKeyPathsMappingByKey[key] ?? super.keyPathsForValuesAffectingValueForKey(key)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if(segue.identifier == kEditorControllerSegueIdentifier) {
      let destinationController = segue.destinationViewController as! GFEditorViewController
      if let asset = playerItem?.asset {
        destinationController.videoAsset = GFVideoAsset(asset: asset, withStartTime: trimmerView.startTime, andEndTime: trimmerView.endTime)
      } else {
        log.warning("The video asset for the editor controller segue is not available.")
      }
    }
  }
  
  deinit {
    removeBackgroundAlertDismissingObserver()
  }
  
  // MARK: - Instance Methods
  /// Starts playing the video asset.
  func playVideo() {
    if !isPlaying {
      player.play()
      videoControlsToolbar.sh_replaceBarButtonAtIndex(playBarButton.tag, withBarButton: pauseBarButton, animated: false)
    }
  }
  
  /// Stops playing the video asset.
  func pauseVideo() {
    if isPlaying {
      player.pause()
      videoControlsToolbar.sh_replaceBarButtonAtIndex(playBarButton.tag, withBarButton: playBarButton, animated: false)
    }
  }
  
  /// This method is invoked when the video has played to its end time.
  func playerDidFinishPlaying(note: NSNotification) {
    pauseVideo()
  }
  
  /// Sets the video controls to the appropriate initial state.
  private func setupInitialVideoControlsStates() {
    playerView.backgroundColor = UIColor.blackColor()
    playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
    playerView.playerLayer.player = player
    
    // Add toolbar items to the toolbar
    let toolBarItems: [UIBarButtonItem] = [leftFlexibleSpace, playBarButton, rightFlexibleSpace]
    videoControlsToolbar.items = toolBarItems
  }
  
  
  /// If the video asset is ready to play the video controls must allow video playback handling.
  private func setVideoReadyToPlayState() {
    imageGenerator = AVAssetImageGenerator(asset: playerItem!.asset)
    trimmerView.playerItem = playerItem
    
    doneBarButton.enabled = true
    playBarButton.enabled = true
    pauseBarButton.enabled = true
    tapRecognizer.enabled = true
    
    if SVProgressHUD.isVisible() {
      SVProgressHUD.dismiss()
    }
  }
  
  /// If the video asset loading is failed the video controls must be disabled.
  private func setVideoFailedState() {
    doneBarButton.enabled = false
    playBarButton.enabled = false
    pauseBarButton.enabled = false
    tapRecognizer.enabled = false
  }
  
  /// This method is called when the video asset has been loading and the trimmer view has been filled.
  private func finalizeVideoLoading() {
    if SVProgressHUD.isVisible() {
      SVProgressHUD.dismiss()
    }
    
    playBarButton.enabled = true
    pauseBarButton.enabled = true
    tapRecognizer.enabled = true
    doneBarButton.enabled = true
  }
  
  /// Asynchronously loads a representation of the video asset for playback. Obtained `AVPlayerItem` can be used in conjunction with `AVPlayer`.
  private func asynchronouslyLoadVideoAsset() {
    guard let videoAsset = asset else {
      log.warning("Failed to obtain the video PHAsset.")
      return
    }
    
    let imageManager = PHImageManager.defaultManager()
    videoAssetRequestID = imageManager.requestPlayerItemForVideo(videoAsset, options: videoAssetRequestOptions) {
      playerItem, info in
      
      if let info = info {
        if let requestError = info[PHImageErrorKey] as? NSError {
          dispatch_async(dispatch_get_main_queue()) {
            UIAlertController.sh_showAlertFromViewController(self, withTitle: NSLocalizedString(requestError.localizedDescription, comment: "Error during loading a video asset."), andMessage: nil) {
              action in
              
              // Try to load a video asset again.
              self.asynchronouslyLoadVideoAsset()
            }
          }
          return
        }
        
        if let isRequestCancelled = info[PHImageCancelledKey] as? NSNumber {
          if isRequestCancelled == true {
            return
          }
        }
      }
      
      self.playerItem = playerItem
    }
  }
}
