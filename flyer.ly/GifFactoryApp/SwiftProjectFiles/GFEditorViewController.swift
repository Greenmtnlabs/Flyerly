//
//  GFEditorViewController.swift
//  GifFactoryApp
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices
import RAReorderableLayout
import CTAssetsPickerController
import YYWebImage
import SVProgressHUD


/// View controller that presents a screen where you can review and edit your GIF's frames.
class GFEditorViewController: UIViewController, GFBackgroundAlertDismissing {
  // MARK: - GFBackgroundAlertDismissing
  var _backgroundAlertDismissingObserver: NSObjectProtocol?
  
  // MARK: Properties
  /// Defines the number of frames per second which will be extracted from the video file.
  let kFramesPerSecond = 10
  /// The array with the items that describe image properties for each GIF frame.
  var gifFrames = [GFGifFrame]()
  /// Selected images in Photo Library.
  var photosAssets: [PHAsset]?
  /// The video asset the images for GIF creation will be extracted from.
  var videoAsset: GFVideoAsset?

  
  /// The cache manager that is used to cache the frames of the edited GIF.
  private var cacheManager: YYImageCache = {
    return YYImageCache.sharedCache()
  }()
  /// Helper object used to stop video frame extraction.
  private var cancelHelper = GFCancelOperationsHelper()
  /// Image manager that is used to cache animation frames.
  private let imageManager = PHCachingImageManager()
  /// Settings manager that is used to store/retrieve the animation parameters.
  private let settingsManager: GFAnimationSettingsManager = GFAnimationSettingsManager()
  /// The array with the request Ids which are used to cancel images downloading.
  private var requestIds = [PHImageRequestID]()
  /// Image generator that is used to extract frames from th video.
  private var imageGenerator: AVAssetImageGenerator?
  /// The delegate that is used to create custom transition to the animation settings controller.
  private var settingsTransitionDelegate = GFSettingsControllerTransitioningDelegate()
  /// The previous rectangle that contains cached animation frames.
  private var previousPreheatArea: CGRect = CGRectZero
  /// Color that is used to restore the collection view cell label's background color.
  private var frameNumberLabelRestorationColor: UIColor = UIColor.clearColor()
  /// The reuse identifier by means of which the collection view identifies and queues the views for the animation frame cells.
  private let kAnimationFrameCellIdentifier = "AnimationFrameCell"
  /// The identifier that is used to detect the segue to the animation settings controller.
  private let kShowAnimationSettingsSegueIdentifier = "ShowAnimationSettingsSegue"
  /// The identifier that is used to detect the segue to the animation preview controller.
  private let kAnimationPreviewSegueIdentifier = "AnimationPreviewSegue"
  /// A string containing the error domain that defines the errors context for the `prepareCacheForFrame` method.
  private let kPrepareCacheForFrameErrorDomain = "com.gfeditorviewcontroller.preparecacheforframe"
  /// The base part of the key that defines the fullsized image in the cache.
  private let kBaseFullSizeImageKey = "FullSizedImageKey"
  /// The base part of the key that defines the thumbnail image in the cache.
  private let kBaseThumbKey = "ThumbnailImageKey"
  /// Defines the fixed space value for the editor controller collection view.
  private let kGFEditorCollectionViewFixedSpacing: CGFloat = 5.0
  /// The options for requesting reduced-size versions of animation frames.
  private let thumbnailRequestOptions: PHImageRequestOptions = {
    let imageRequestOptions = PHImageRequestOptions()
    imageRequestOptions.resizeMode = .Fast
    imageRequestOptions.deliveryMode = .Opportunistic
    return imageRequestOptions
  }()
  
  
  // MARK: - IBOutlets
  /// Bar button that is used to cancel GIF Editor controller.
  @IBOutlet var cancelEditorBarButton: UIBarButtonItem!
  /// Bar button that is used to add images to the GIF being edited.
  @IBOutlet var addImagesToGifBarButton: UIBarButtonItem!
  /// Collection view that holds all selected animation frames.
  @IBOutlet var animationFramesCollectionView: UICollectionView!
  /// Bar button used to open the settings controller.
  @IBOutlet var settingsBarButton: UIBarButtonItem!
  /// Bar button used to open the preview controller.
  @IBOutlet var previewBarButton: UIBarButtonItem!

  // MARK: - IBActions
  /// Cancels animation editor view controller.
  ///
  /// - parameter sender: Button that is used to cancel the controller.
  @IBAction func cancelAnimationEditor(sender: AnyObject) {
    navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  /// It is called when the `Add` button has been clicked.
  ///
  /// - parameter sender: Button that is used to add images to GIF.
  @IBAction func addImagesToGif(sender: AnyObject) {
    PHPhotoLibrary.requestAuthorization {
      (status) in
      dispatch_async(dispatch_get_main_queue()) {
        if(status == .Authorized) {
          let ctAssetsPickerController = CTAssetsPickerController()
          ctAssetsPickerController.delegate = self
          ctAssetsPickerController.showsSelectionIndex = true
          ctAssetsPickerController.showsNumberOfAssets = true
          ctAssetsPickerController.alwaysEnableDoneButton = false
          
          let assetsFetchOptions = PHFetchOptions()
          assetsFetchOptions.predicate = NSPredicate(format: "(mediaType == %d)", PHAssetMediaType.Image.rawValue, 0)
          
          ctAssetsPickerController.assetsFetchOptions = assetsFetchOptions
          self.presentViewController(ctAssetsPickerController, animated: true, completion: nil)
          
        } else {
          UIAlertController.sh_showAlertFromViewController(self, withTitle: NSLocalizedString("Grant Permission for Photo Library Access to Add Images to the Current GIF", comment: "Photo library access denied dialog message when trying to add images to GIF."),
            andMessage: nil,
            isSettingsButtonRequired: true)
        }
      }
    }
  }
  
  // MARK: - View Controller
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if(segue.identifier == kShowAnimationSettingsSegueIdentifier) {
      let settingsController = segue.destinationViewController as! GFAnimationSettingsViewController
      
      settingsController.transitioningDelegate = settingsTransitionDelegate
      settingsController.modalPresentationStyle = .Custom
      
      settingsController.settingsManager = settingsManager
      
    } else if(segue.identifier == kAnimationPreviewSegueIdentifier) {
      let animationPreviewController: GFAnimationPreviewViewController = segue.destinationViewController as! GFAnimationPreviewViewController

      animationPreviewController.gifFrames = gifFrames
      animationPreviewController.settingsManager = settingsManager
    }
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
    resetCachedAssets()
    animationFramesCollectionView.collectionViewLayout.invalidateLayout()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(true)
    
    // Begin caching assets in and around collection view's visible rect
    updateCachedFrames()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(true)
    
    resetCachedAssets()
    resetCachedThumbnails()

    cancelHelper.shouldStopOperations = true
    
    PHImageManager.sh_cancelImageRequests(&requestIds)

    if let imageGenerator = imageGenerator {
      imageGenerator.cancelAllCGImageGeneration()
    }
    
    if SVProgressHUD.isVisible() {
      SVProgressHUD.dismiss()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setNeedsStatusBarAppearanceUpdate()
    prepareGifFramesArray()
    addBackgroundAlertDismissingObserver()

    settingsTransitionDelegate.interactionController = GFHorizontalSwipeInteractionController()
    settingsTransitionDelegate.animationController = GFSlideAnimationController()
  }
  
  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    
    resetCachedAssets()
    resetCachedThumbnails()

    coordinator.animateAlongsideTransition({
      [weak self] context in
      guard let weakSelf = self else { return }
      weakSelf.updateCachedFrames()
      weakSelf.animationFramesCollectionView.collectionViewLayout.invalidateLayout()
      weakSelf.animationFramesCollectionView.reloadData()
      }, completion: nil)
  }
  
  deinit {
    removeBackgroundAlertDismissingObserver()
    clearCacheForGifFrames(gifFrames)
  }
  
  // MARK: - Assets Management
  /**
   *  Stops caching and clears preheat area.
   */
  func resetCachedAssets() {
    imageManager.stopCachingImagesForAllAssets()
    previousPreheatArea = CGRectZero
  }
  
  /**
   *  Removes all the cached images both from disk and memory.
   *
   *  - parameter removedGifFrames: The array of GFGifFrame objects the cache must be cleared for.
   */
  func clearCacheForGifFrames(removedGifFrames: [GFGifFrame]) {
    // clear cached images.
    for frame in removedGifFrames {
      if let key = frame.fullsizedImageCachekey {
        YYImageCache.sharedCache().removeImageForKey(key)
      }
      
      if let key = frame.thumbnailCacheKey {
        YYImageCache.sharedCache().removeImageForKey(key)
      }
    }
  }
  
  /// Removes all the cached thumbnails of the extracted video frames.
  func resetCachedThumbnails() {
    for frame in gifFrames {
      if let key = frame.thumbnailCacheKey {
        YYImageCache.sharedCache().removeImageForKey(key)
      }
    }
  }
  
  /// Updates thumbnails cache of the generated images from the video asset.
  /// - parameter addedIndexPaths: The array of NSIndexPath objects that represent the indices of the gif frames that must be added to the memory cache.
  /// - parameter removedIndexPaths: The array of NSIndexPath objects that represent the inices of the gif frames that must be removed from the memory cache.
  /// - parameter needsRemoveThumbnailsFromMemory: Indicates whether the thumbnails must be removed in accordance with the removedIndexPaths.
  func updateVideoFramesThumbnails(atAddedIndexPaths addedIndexPaths: [NSIndexPath], withRemovedIndexPaths removedIndexPaths: [NSIndexPath], needsRemoveThumbnailsFromMemory: Bool) {
    // Add new thumbnails to the memory cache.
    for indexPath in addedIndexPaths {
      if gifFrames[indexPath.item].sourceType == GFGifFrameSourceType.VideoAsset {
        PHCachingImageManager.sh_requestThumbnailFromCache(cacheManager, forGifFrame: gifFrames[indexPath.item], targetSize: animationFramesCollectionView.sh_cellSizeAtIndexPath(indexPath), contentMode: .ScaleAspectFill, resultHandler: nil)
      }
    }
    
    if needsRemoveThumbnailsFromMemory {
      // Remove redundant gif frames.
      for indexPath in removedIndexPaths {
        if let thumbKey = gifFrames[indexPath.item].thumbnailCacheKey {
          YYImageCache.sharedCache().removeImageForKey(thumbKey, withType: .Memory)
        }
      }
    }
  }
  
   /// Updates the cached gif frames in accordance with the scrolled area.
  func updateCachedFrames() {
    // Update Photos Assets cache.
    PHCachingImageManager.sh_requestUpdatedIndexPathsForCollectionView(animationFramesCollectionView, withPreviousPreheatArea: previousPreheatArea) {
      [weak self] addedIndexPaths, removedIndexPaths, error in
      guard let weakSelf = self else { return }
      
      if let error = error {
        log.error("Failed to update the collection view index paths because of the error. The error description: \(error.localizedDescription)")
        return
      }
      
      // Update thumbnails.
      weakSelf.updateVideoFramesThumbnails(atAddedIndexPaths: addedIndexPaths, withRemovedIndexPaths: removedIndexPaths, needsRemoveThumbnailsFromMemory: true)
      
      let assetsToStartCaching: [PHAsset]? = weakSelf.assetsAtIndexPaths(addedIndexPaths)
      let assetsToStopCaching: [PHAsset]? = weakSelf.assetsAtIndexPaths(removedIndexPaths)
      
      // Update the assets the PHCachingImageManager is caching.
      if let assetsToStartCaching = assetsToStartCaching {
        weakSelf.imageManager.startCachingImagesForAssets(assetsToStartCaching, targetSize: weakSelf.animationFramesCollectionView.sh_cellSizeAtIndexPath(addedIndexPaths[0]), contentMode: .AspectFill, options: weakSelf.thumbnailRequestOptions)
      }
      
      if let assetsToStopCaching = assetsToStopCaching {
        weakSelf.imageManager.stopCachingImagesForAssets(assetsToStopCaching, targetSize: weakSelf.animationFramesCollectionView.sh_cellSizeAtIndexPath(removedIndexPaths[0]), contentMode: .AspectFill, options: weakSelf.thumbnailRequestOptions)
      }
      
      weakSelf.previousPreheatArea = weakSelf.animationFramesCollectionView.sh_preheatArea
    }
  }
  
  /**
   *  Returns an array with PHAssets in accordance with the given indexPaths.
   *
   *  - parameter indexPaths: NSIndexPath objects representing the cached assets that should be updated.
   *  - returns: An array filled with PHAsset objects. It can be nil if no asset is associated with the given index.
   *
   */
  func assetsAtIndexPaths(indexPaths: [NSIndexPath]) -> [PHAsset]? {
    if(indexPaths.count == 0) { return nil }
    
    var assets = [PHAsset]()
    for indexPath in indexPaths {
      let gifFrame = gifFrames[indexPath.item]
      if let asset = gifFrame.photosAsset {
        assets.append(asset)
      }
    }
    
    return assets
  }
  
  // MARK: - Instance Methods
  /// Fills the gif frames array according to the given assets (video and photos).
  private func prepareGifFramesArray() {
    // Use the assets from the Photos Library if available. Otherwise use the video asset to extract the GIF frames.
    if let photosAssets = photosAssets {
      preparePhotosAssets(photosAssets)
    } else if let videoAsset = videoAsset {
      prepareVideoFramesForAsset(videoAsset)
    }
  }
  
  /// Prepares the images extracting them from the video file. 
  ///
  /// - parameter videoAsset: The asset that represents the video file.
  private func prepareVideoFramesForAsset(videoAsset: GFVideoAsset) {
    SVProgressHUD.showWithStatus(NSLocalizedString("Extracting Video Frames...", comment: "Message that is displayed during the video frames extraction."))
    imageGenerator = AVAssetImageGenerator(asset: videoAsset.asset)
    guard let unwrappedImageGenerator = imageGenerator else { return }
    
    unwrappedImageGenerator.requestedTimeToleranceBefore = kCMTimeZero
    unwrappedImageGenerator.requestedTimeToleranceAfter = kCMTimeZero
    unwrappedImageGenerator.appliesPreferredTrackTransform = true
    unwrappedImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeCleanAperture
    
    var times = [CMTime]()
    let timeIncrementValue: Double = 1 / Double(kFramesPerSecond)
    
    let framesCount = Int((videoAsset.endTime - videoAsset.startTime)) * kFramesPerSecond
    for frameIndex in 0..<framesCount {
      let currentTime = CMTimeMakeWithSeconds(Double(videoAsset.startTime) + Double(frameIndex) * timeIncrementValue, videoAsset.asset.duration.timescale ?? 60000)
      times.append(currentTime)
    }
    
    
    let errorHandler = { [weak self] () -> Void in
      dispatch_async(dispatch_get_main_queue()) {
        guard let weakSelf = self else { return }
        
        weakSelf.clearCacheForGifFrames(weakSelf.gifFrames)
        SVProgressHUD.dismiss()
        
        UIAlertController.sh_showAlertFromViewController(weakSelf, withTitle: NSLocalizedString("Failed to Extract Video Frames", comment: "Alert title describing the error which indicates that it is not possible to extract the video frames."), andMessage: nil)
      }
    }
    
    var imageIndex = 0
    
    /// Generates the GIF frame from the video at the given time.
    func generateNextFrameForTime(time: CMTime) {
      if cancelHelper.shouldStopOperations {
        log.verbose("Video frames generation was cancelled.")
        return
      }
      
      dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) {
        let image = try? unwrappedImageGenerator.copyCGImageAtTime(time, actualTime: nil)
        
        dispatch_async(dispatch_get_main_queue()) {
          [weak self] in
          guard let weakSelf = self else { return }
          
          guard let cgImage = image else {
            log.error("Failed to generate CGImage for the main trimmer view.")
            errorHandler()
            return
          }
          
          
          let currentFrame = UIImage(CGImage: cgImage)
          let gifFrame = GFGifFrame()
          
          let fullSizeImageKey = weakSelf.kBaseFullSizeImageKey + String(imageIndex)
          let thumbKey = weakSelf.kBaseThumbKey + String(imageIndex)
          
          gifFrame.fullsizedImageCachekey = fullSizeImageKey
          gifFrame.thumbnailCacheKey = thumbKey
          
          weakSelf.cacheManager.sh_setImage(currentFrame, forGifFrame: gifFrame, createThumbnailInMemoryWithSize: nil) {
            [weak image, weak cgImage, weak currentFrame] gifFrame, error in
            dispatch_async(dispatch_get_main_queue()) {
              [weak image, weak cgImage, weak currentFrame, weak weakSelf] in
              guard let weakWeakSelf = weakSelf else { return }
              
              autoreleasepool {
                
                if let error = error {
                  log.error("Failed to save the GIF frame into cache. The error description: \(error.localizedDescription)")
                  errorHandler()
                  return
                } else {
                  
                  weakWeakSelf.gifFrames.append(gifFrame)

                  imageIndex += 1
                  if imageIndex == framesCount {
                    weakWeakSelf.animationFramesCollectionView.reloadData()
                    weakWeakSelf.finalizeFramesLoading()
                  } else {
                    generateNextFrameForTime(times[imageIndex])
                  }
                  
                  log.verbose("Is image nil: \(image == nil)")
                  log.verbose("Is cgImage nil: \(cgImage == nil)")
                  log.verbose("Is currentFrame nil: \(currentFrame == nil)")
                }
              }
            }
          }
        }
      }
    }
    
    // TODO: Preload some frames to memory.
    
    // Start frames extraction.
    generateNextFrameForTime(times[imageIndex])
  }
  
  /// Prepares the images extracting them from the Photos Library. If the GIF type has been detected all the GIF frames will be extracted too.
  ///
  /// - parameter photosAssets: The assets in the Photos Library that the user has selected.
  private func preparePhotosAssets(photosAssets: [PHAsset]) {
    SVProgressHUD.showWithStatus(NSLocalizedString("Loading GIF Frames...", comment: "Message that is displayed when GIF frames are being loaded into the GIF Editor collection view."))
    
    // Due to the asynchronous mechanism the extracted frames from the GIF assets cannot be stored in the array in a predefined order. Instead, they must be firstly stored in the dictionary and than be sorted in accordance with their keys.
    var unsortedGifFrames = [Int: [GFGifFrame]]()
    var uniqueCacheIndex = 0
    var didFrameLoadingSucceed = true
    var didFrameLoadingCancel = false
    let indexPath = NSIndexPath(forItem: 0, inSection: 0)
    let thumbSize = animationFramesCollectionView.sh_cellSizeAtIndexPath(indexPath)
    let dispatchGroup = dispatch_group_create()
    
    // Determine number of group enters.
    var indicesWithGifType = Set<Int>()
    var currentPhotosIndex = 0
    for photosAsset in photosAssets {
      var isGifDetected = false
      if #available(iOS 9, *) {
        let assetResources = PHAssetResource.assetResourcesForAsset(photosAsset)
        if let currentResource = assetResources.first where currentResource.uniformTypeIdentifier == String(kUTTypeGIF) {
          isGifDetected = true
        }
      } else {
        // In iOS 8 and earlier the KVC technique can be used to detect the asset type before downloading the fullsized data.
        let uti = photosAsset.valueForKey("uniformTypeIdentifier")
        if let uniformTypeIdentifier = uti as? String where uniformTypeIdentifier == String(kUTTypeGIF) {
          isGifDetected = true
        }
      }
      
      if isGifDetected {
        indicesWithGifType.insert(currentPhotosIndex)
      }
      currentPhotosIndex += 1
    }
    
    if indicesWithGifType.count > 0 {
      for _ in indicesWithGifType {
        dispatch_group_enter(dispatchGroup)
      }
    }
    
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue()) {
      [weak self] _ in
      guard let weakSelf = self else { return }
      
      if didFrameLoadingCancel {
        return
      }
      
      if !didFrameLoadingSucceed {
        SVProgressHUD.dismiss()
        
        UIAlertController.sh_showAlertFromViewController(weakSelf, withTitle: NSLocalizedString("Failed to Generate GIF thumbnails", comment: "Alert title describing the error which indicates that it is not possible to generate the GIF thumbnails."), andMessage: nil)
      } else {
        let sortedKeys = unsortedGifFrames.keys.sort {
          $0 < $1
        }
        
        for key in sortedKeys {
          let currentFrames = unsortedGifFrames[key]
          if let currentFrames = currentFrames {
            weakSelf.gifFrames.appendContentsOf(currentFrames)
          } else {
            log.error("Failed to unwrap the GIF frames array for the given key \(key).")
          }
        }
        
        weakSelf.animationFramesCollectionView.reloadData()
        weakSelf.finalizeFramesLoading()
        
        // Scroll to bottom.
        let itemsCount = weakSelf.animationFramesCollectionView.numberOfItemsInSection(0)
        if itemsCount > 0 {
          let lastItemIndexPath = NSIndexPath(forItem: weakSelf.animationFramesCollectionView.numberOfItemsInSection(0) - 1, inSection: 0)
          weakSelf.animationFramesCollectionView.scrollToItemAtIndexPath(lastItemIndexPath, atScrollPosition: [.Bottom], animated: true)
        }
      }
    }
    
    currentPhotosIndex = 0
    let errorHandler = { [weak self] () -> Void in
      dispatch_async(dispatch_get_main_queue()) {
        guard let weakSelf = self else {return }

        weakSelf.clearCacheForGifFrames(unsortedGifFrames.values.flatMap { $0 })
        PHImageManager.sh_cancelImageRequests(&weakSelf.requestIds)
        didFrameLoadingSucceed = false
        dispatch_group_leave(dispatchGroup)
      }
    }
    
    for photosAsset in photosAssets {
      if !indicesWithGifType.contains(currentPhotosIndex) {
        let currentGifFrame = GFGifFrame()
        currentGifFrame.photosAsset = photosAsset
        unsortedGifFrames[currentPhotosIndex] = [currentGifFrame]
      } else {
        let gifDataRequestOptions = PHImageRequestOptions()
        gifDataRequestOptions.synchronous = false
        gifDataRequestOptions.networkAccessAllowed = true
        
        let requestId = imageManager.requestImageDataForAsset(photosAsset, options: gifDataRequestOptions) {
          [weak self, currentPhotosIndex] data, dataUti, orientation, info in
          
          dispatch_async(dispatch_get_main_queue()) {
            guard let weakSelf = self else {return }

            if !didFrameLoadingSucceed {
              errorHandler()
              return
            }
            
            if let info = info {
              if let requestError = info[PHImageErrorKey] as? NSError {
                log.error("Failed to load the GIF data. The error description: \(requestError.localizedDescription)")
                errorHandler()
                return
              } else if let isImageCancelled = info[PHImageCancelledKey] as? NSNumber where isImageCancelled == true {
                log.verbose("The GIF data request was cancelled.")
                didFrameLoadingCancel = true
                errorHandler()
                return
              }
            }
            
            guard let gifData = data else {
              log.error("Failed to unwrap the GIF data.")
              errorHandler()
              return
            }
            
            let aw = YYImage(data: gifData)
            guard let animationWrapper = aw else {
              log.error("Failed to unwrap the animation wrapper object.")
              errorHandler()
              return
            }
            
            var frames = [GFGifFrame]()
            var processedFramesCount: UInt = 0
            for i in 0..<animationWrapper.animatedImageFrameCount() {
              autoreleasepool {
                let image = animationWrapper.animatedImageFrameAtIndex(i)
                guard let unwrappedImage = image else {
                  log.error("Failed to unwrap the GIF image.")
                  errorHandler()
                  return
                }
                
                let fullSizeImageKey = weakSelf.kBaseFullSizeImageKey + String(uniqueCacheIndex) + String(i)
                let thumbKey = weakSelf.kBaseThumbKey + String(uniqueCacheIndex) + String(i)
                uniqueCacheIndex += 1

                let gifFrame = GFGifFrame()
                gifFrame.fullsizedImageCachekey = fullSizeImageKey
                gifFrame.thumbnailCacheKey = thumbKey
                frames.append(gifFrame)

                // Store GIF frame in the cache (disk and memory).
                weakSelf.cacheManager.sh_setImage(unwrappedImage, forGifFrame: gifFrame, createThumbnailInMemoryWithSize: thumbSize) {
                  gifFrame, error in
                  
                  dispatch_async(dispatch_get_main_queue()) {
                    
                    if !didFrameLoadingSucceed {
                      return
                    }
                    
                    if let error = error {
                      errorHandler()
                      log.error("Failed to generate the GIF thumbnails. The error description: \(error.localizedDescription)")
                      return
                    } else {
                      processedFramesCount += 1
                      
                      if processedFramesCount == animationWrapper.animatedImageFrameCount() {
                        unsortedGifFrames[currentPhotosIndex] = frames
                        dispatch_group_leave(dispatchGroup)
                        return
                      }
                    }
                  }
                }
              }
            }
          }
        }
        
        requestIds.append(requestId)
      }
      
      currentPhotosIndex += 1
    }
  }
  
  /// Configures the views after the gif frames have been loaded.
  private func finalizeFramesLoading() {
    settingsBarButton.enabled = true
    previewBarButton.enabled = true
    addImagesToGifBarButton.enabled = true
    animationFramesCollectionView.userInteractionEnabled = true
    
    if SVProgressHUD.isVisible() {
      SVProgressHUD.dismiss()
    }
    
    requestIds.removeAll()
  }
}

// MARK: - UICollectionViewDataSource
extension GFEditorViewController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return gifFrames.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell: GFEditorCell = collectionView.dequeueReusableCellWithReuseIdentifier(kAnimationFrameCellIdentifier, forIndexPath: indexPath) as! GFEditorCell
        
    // It is needed to add 1 'cause Swift arrays are zero-based
    cell.frameNumberLabel.text = String(indexPath.item + 1)
    cell.activityIndicator.startAnimating()
    
  
    if let asset = gifFrames[indexPath.item].photosAsset {
      // Request an image for the asset from the PHCachingImageManager
      cell.uniqueIdentifier = asset.localIdentifier
      
      imageManager.requestImageForAsset(asset, targetSize: collectionView.sh_cellSizeAtIndexPath(indexPath), contentMode: .AspectFill, options: thumbnailRequestOptions) { (result, info) -> Void in
        dispatch_async(dispatch_get_main_queue()) {
          
          if let info = info {
            if let imageRequestError = info[PHImageErrorKey] as? NSError{
              log.error("Failed to load image for the asset. Error description: \(imageRequestError.localizedDescription)")
              return
            } else if let isImageCancelled = info[PHImageCancelledKey] as? NSNumber where isImageCancelled == true {
              log.verbose("Image request was cancelled.")
              return
            }
          }
          
          if cell.uniqueIdentifier == asset.localIdentifier {
            cell.thumbnailImage = result
            cell.activityIndicator.stopAnimating()
          }
        }
      }
    } else if gifFrames[indexPath.item].sourceType == GFGifFrameSourceType.VideoAsset {
      let frame = gifFrames[indexPath.item]
      cell.uniqueIdentifier = frame.thumbnailCacheKey! + frame.fullsizedImageCachekey!
      
      PHCachingImageManager.sh_requestThumbnailFromCache(cacheManager, forGifFrame: frame, targetSize: collectionView.sh_cellSizeAtIndexPath(indexPath), contentMode: .ScaleAspectFill) {
        image, error in
        
        dispatch_async(dispatch_get_main_queue()) {

          if let error = error {
            log.error("Failed to load the image for the collection view's cell due to the occurred error. The error's description: \(error.localizedDescription)")
            return
          }
          
          if let image = image {
            if let thumbKey = frame.thumbnailCacheKey, let fullsizeKey = frame.fullsizedImageCachekey {
              let idUsedForRequest = thumbKey + fullsizeKey
              if cell.uniqueIdentifier == idUsedForRequest {
                cell.thumbnailImage = image
                cell.activityIndicator.stopAnimating()
              }
            } else {
              log.error("Failed to obtain the GIF frame cache keys.")
            }
         
          } else {
            log.error("Failed to load the image for the collection view's cell due to the unrecognized error.")
          }
        }
      }
    } else {
      log.error("Failed to detect gif frame source.")
    }
    
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GFEditorViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let currentItemSize = UICollectionViewFlowLayout.sh_itemSizeForTraitCollection(traitCollection, contentSize: collectionView.bounds.size, fixedSpacing: kGFEditorCollectionViewFixedSpacing)
    
    return currentItemSize
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
    return kGFEditorCollectionViewFixedSpacing
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    return kGFEditorCollectionViewFixedSpacing
  }
}

// MARK: - UIScrollViewDelegate
extension GFEditorViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(scrollView: UIScrollView) {
    // Update cached assets for the new visible area if needed.
    if(sh_isViewVisible()) {
      if(animationFramesCollectionView.sh_isNotablyScrolledFromPreheatArea(previousPreheatArea)) {
        updateCachedFrames()
      }
    }
  }
}

// MARK: - RAReorderableLayoutDelegate
extension GFEditorViewController: RAReorderableLayoutDelegate {
  
  /// Prevents drag'n'drop capabilities for specific items.
  func collectionView(collectionView: UICollectionView, allowMoveAtIndexPath indexPath: NSIndexPath) -> Bool {
    if collectionView.numberOfItemsInSection(indexPath.section) <= 1 {
      return false
    }
    return true
  }
  
  func collectionView(collectionView: UICollectionView, collectionViewLayout layout: RAReorderableLayout, willBeginDraggingItemAtIndexPath indexPath: NSIndexPath) {
    
    let cell: GFEditorCell = collectionView.cellForItemAtIndexPath(indexPath) as! GFEditorCell
    cell.frameNumberLabel.text = "?"
    
    if let backgroundColor = cell.frameNumberLabel.backgroundColor {
      frameNumberLabelRestorationColor = backgroundColor
    }
    
    cell.frameNumberLabel.backgroundColor = UIColor.clearColor()
  }
  
  func collectionView(collectionView: UICollectionView, collectionViewLayout layout: RAReorderableLayout, didBeginDraggingItemAtIndexPath indexPath: NSIndexPath) {
    
    let cell: GFEditorCell = collectionView.cellForItemAtIndexPath(indexPath) as! GFEditorCell
    cell.frameNumberLabel.text = String(indexPath.item + 1)
    
    // Restore frame number placeholder color
    cell.frameNumberLabel.backgroundColor = frameNumberLabelRestorationColor
  }

  func collectionView(collectionView: UICollectionView, atIndexPath: NSIndexPath, willMoveToIndexPath toIndexPath: NSIndexPath) {
    // Update data source before animation begins
    let frame: GFGifFrame = gifFrames.removeAtIndex(atIndexPath.item)
    gifFrames.insert(frame, atIndex: toIndexPath.item)
  }
  
  func collectionView(collectionView: UICollectionView, atIndexPath: NSIndexPath, didMoveToIndexPath toIndexPath: NSIndexPath) {

    var range: Range<Int>
    
    // In range start index must be greater than end index
    if atIndexPath.item < toIndexPath.item {
      range = atIndexPath.item...toIndexPath.item
    } else {
      range = toIndexPath.item...atIndexPath.item
    }
    
    let updatedIndexPaths = NSIndexPath.sh_indexPathsFromRange(range)
    
    // Update indices during dragging
    if let updatedIndexPaths = updatedIndexPaths {
      
      dispatch_async(dispatch_get_main_queue()) {
        
        for indexPath in updatedIndexPaths {
          let cell = collectionView.cellForItemAtIndexPath(indexPath) as? GFEditorCell
          if let cell = cell {
            cell.frameNumberLabel.text = String(indexPath.item + 1)
          }
        }
      }
    }
  }
}

// MARK: - RAReorderableLayoutDataSource
extension GFEditorViewController: RAReorderableLayoutDataSource {
  
  /// Sets the opacity value of the cell's placeholder, specified as a value from 0.0 to 1.0.
  func collectionView(collectionView: UICollectionView, reorderingItemAlphaInSection section: Int) -> CGFloat {
    
    return 0.3
  }
  
  /// Specifies insets from the dragged cell that trigger scrolling.
  func scrollTrigerEdgeInsetsInCollectionView(collectionView: UICollectionView) -> UIEdgeInsets {
    return UIEdgeInsetsMake(100.0, 100.0, 100.0, 100.0)
  }
  
  func scrollTrigerPaddingInCollectionView(collectionView: UICollectionView) -> UIEdgeInsets {
    return UIEdgeInsetsMake(animationFramesCollectionView.contentInset.top, 0,animationFramesCollectionView.contentInset.bottom, 0)
  }
}

// MARK: - CTAssetsPickerControllerDelegate
extension GFEditorViewController: CTAssetsPickerControllerDelegate {

  func assetsPickerController(picker: CTAssetsPickerController, didFinishPickingAssets assets: [PHAsset]) {
    // Update bottom cells cache.
    let updateCount = animationFramesCollectionView.visibleCells().count
    var addedIndexPaths = [NSIndexPath]()
    for i in (gifFrames.count - updateCount)..<gifFrames.count {
      addedIndexPaths.append(NSIndexPath(forItem: i, inSection: 0))
    }
    
    updateVideoFramesThumbnails(atAddedIndexPaths: addedIndexPaths, withRemovedIndexPaths: [NSIndexPath](), needsRemoveThumbnailsFromMemory: true)
  
    // Close the assets picker.
    dismissViewControllerAnimated(true, completion: nil)
    
    // Update the collection view data source
    preparePhotosAssets(assets)
  }
}