//
//  GFAnimationPreviewViewController.swift
//  GifFactoryApp
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit
import Photos
import SVProgressHUD
import YYWebImage
import GoogleMobileAds
import RMPZoomTransitionAnimator


/// View controller that manages the animation preview presentation.
class GFAnimationPreviewViewController: UIViewController, GFBackgroundAlertDismissing {
  // MARK: - GFBackgroundAlertDismissing
  var _backgroundAlertDismissingObserver: NSObjectProtocol?
  
  // MARK: Properties
  /// The array that is used as a data source of the collection view.
  /// - seealso: `animationUrls` in `GFMainScreenViewController`.
  var animationUrls: [NSURL]?
  /// Specifies the index path in the collection view that is currenlty observed to handle the GIF presentation.
  var observedIndexPath: NSIndexPath?
  /// The object that represets properties of the GIF that was created from the specified frames.
  var gifAsset: GFGifAsset?
  /// Images for creating the animation.
  var gifFrames: [GFGifFrame]?
  /// Settings manager that is used to store/retrieve the animation parameters.
  var settingsManager: GFAnimationSettingsManager?
  /// Returns the main screen view controller that was set when transitioning from main to preview controller.
  weak var mainScreenControllerForPreviewStage: GFMainScreenViewController?
  /// Returns the main screen view controller that was set as a part of the editing controllers hierarchy.
  weak private var mainScreenControllerForEditingStage: GFMainScreenViewController? {
    return (navigationController?.presentingViewController as? UINavigationController)?.viewControllers[0] as? GFMainScreenViewController
  }
  /// Returns current collection view cell that currently displays the GIF animation.
  ///
  /// - note: it returns `nil` if the cell is not visible.
  weak private var observedCell: GFGifPreviewCell?
  /// Returns the image view that handles the current GIF presentation.
  ///
  /// - note: it returns `nil` if the cell containing the image view is not visible.
  private var observedImageView: YYAnimatedImageView? {
    return observedCell?.animatedImageView
  }
  /// Returns the index path of the currently visible cell.
  private var visibleIndexPath: NSIndexPath? {
    var visibleRect = CGRectZero
    visibleRect.origin = gifPreviewCollectionView.contentOffset
    visibleRect.size = gifPreviewCollectionView.bounds.size
    
    let visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect))
    return gifPreviewCollectionView?.indexPathForItemAtPoint(visiblePoint)
  }
  
  /// The cache manager that is used to cache the GIF fullscreen previews.
  private var cacheManager: YYImageCache = {
    return YYImageCache.sharedCache()
  }()
  
  /// Indicates whether assets conversion should be stopped.
  private var cancelHelper = GFCancelOperationsHelper()
  /// Background color in the full-screen mode.
  private var fullScreenBackgroundColor = UIColor.blackColor()
  /// Specifies whether the view controller is being popped to the parent controller.
  private var isBeingPopped = false
  /// Indicates whether the animation is in fullscreen mode.
  private var isInFullscreenMode = false
  /// Indicates whether the preview controller view appeared on screen.
  private var didViewAppear = false
  /// Indicates whether the collection view cell instets must be updated during the layout.
  private var needsCellInsetsUpdate = true
  /// The reuse identifier by means of which the collection view identifies and queues the views for the gif preview cells.
  private let kGifPreviewCellIdentifier = "GFGIfPreviewCell"
  /// Background color in the normal mode.
  private var normalBackgroundColor = UIColor.whiteColor()
  /// The index of the collection view cell that was previously cached.
  private var previousCachedCellIndex = -1
  /// Specifies the top offset of the collection view fullscreen cell.
  private var topEdgeCellOfsset: CGFloat = 0.0
  /// Specifies the bottom offset of the collection view fullscreen cell.
  private var bottomEdgeCellOffset: CGFloat = 0.0

  
  // MARK: - IBOutlets
  /// The collecion view configured to display GIF per one cell.
  @IBOutlet var gifPreviewCollectionView: UICollectionView!
  /// The bar button used to present `UIActivityViewController` controller.
  @IBOutlet var shareBarButton: UIBarButtonItem!
  /// Fixed space between the share and play buttons.
  @IBOutlet var sharePlayFixedSpace: UIBarButtonItem!
  /// Button that is used to start the animation.
  @IBOutlet var playBarButton: UIBarButtonItem!
  /// Button that is used to stop the animation.
  @IBOutlet var pauseBarButton: UIBarButtonItem!
  /// The toolbar that contains all the controls required for managing the animation.
  @IBOutlet var playAnimationToolbar: UIToolbar!
  /// The auto-layout constraint that is used for hidding bottom toolbar in full-screen mode.
  @IBOutlet var bottomBarConstraint: NSLayoutConstraint!
  /// The fixed space defining the offset from the left screen edge.
  @IBOutlet var leftEdgeFixedSpace: UIBarButtonItem!
  /// The fixed space defining the offset from the right screen edge.
  @IBOutlet var rightEdgeFixedSpace: UIBarButtonItem!
  /// Bar button item holding the timeline slider.
  @IBOutlet var sliderContainterBarItem: UIBarButtonItem!
  /// Slider that controls current animation progress.
  @IBOutlet var animationTimelineSlider: UISlider!
  /// Bar button used to save GIF to Documents folder.
  @IBOutlet var saveGifBarButton: UIBarButtonItem!
  /// Bar button used to delete the GIF.
  @IBOutlet var trashBarButton: UIBarButtonItem!
  /// Gesture recognizer used to detect single tap on the collection view.
  @IBOutlet var singleTapRecognizer: UITapGestureRecognizer!
  /// Gesture recognizer used to detect double tap on the collection view.
  @IBOutlet var doubleTapRecognizer: UITapGestureRecognizer!
  /// The UI Control that is used to display the animation frame count.
  @IBOutlet var frameCountLabel: UILabel!
  
  
  // MARK: - IBActions
  /// It is called when the `Play` button has been clicked.
  @IBAction func playBarButtonTapped() -> Void {
    setPreviewScreenToPlayMode()
  }
  
  /// It is called when the `Pause` button has been clicked.
  @IBAction func pauseBarButtonTapped() -> Void {
    setPreviewScreenToPauseMode()
  }
  
  /// Handles the single-tap to toggle full-screen mode.
  @IBAction func handleCollectionViewSingleTap(recognizer: UITapGestureRecognizer) {
    toggleFullScreen()
  }
  
  /// Handles the double-tap to toggle zoom mode.
  @IBAction func handleCollectionViewDoubleTap(recognizer: UITapGestureRecognizer) {
    observedCell?.toggleZoomMode()
  }
  
  /// It is called when the GIF timeline slider value has been changed.
  @IBAction func sliderValueChanged(sender: AnyObject) {
    guard let imageView = observedImageView else { return }

    // Slider value is changed with the step 1.
    let kSliderStep = 1
    let slider = sender as! UISlider
    slider.value = round(slider.value / Float(kSliderStep)) * Float(kSliderStep)
    
    if imageView.isAnimating() {
      setPreviewScreenToPauseMode()
    }

    if imageView.currentAnimatedImageIndex != UInt(slider.value) {
      imageView.currentAnimatedImageIndex = UInt(slider.value)
    }
  }
  
  /// It is called when the `Save` button has been clicked.
  @IBAction func saveAnimationButtonAction(sender: AnyObject) {
    saveGifToDocuments()
  }
  
  /// It is called when the `Trash` button has been clicked.
  @IBAction func trashButtonAction(sender: AnyObject) {
    setPreviewScreenToPauseMode()
    removeGifFromDocuments()
  }
  
  /// It is called when the `Share` button has been clicked.
  @IBAction func shareButtonAction(sender: AnyObject) {
    guard let animatedImage = observedCell?.animatedImageView.image as? YYImage else {
      log.warning("Failed to obtain the animated image to share.")
      return
    }
    
    var sharedAnimation: NSData?
    
    if let gifData = animatedImage.animatedImageData {
      sharedAnimation = gifData
    } else if let coreImage = animatedImage.CGImage {
      sharedAnimation = UIImagePNGRepresentation(UIImage(CGImage: coreImage))
    }
    
    guard let unwrappedSharedAnimation = sharedAnimation else {
      log.error("Failed to obtain the animation URL to share.")
      return
    }
    
    observedCell?.animatedImageView.stopAnimating()
    
    let objectsToShare = [unwrappedSharedAnimation]
    let ac = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
    ac.modalPresentationStyle = .Popover
    ac.completionWithItemsHandler = {
      [weak self] activityType, completed, returnedItems, activityError in
      guard let weakSelf = self else { return }
      
      dispatch_async(dispatch_get_main_queue()) {
        weakSelf.observedCell?.animatedImageView.startAnimating()
        
        if let error = activityError {
          log.error("Failed to perform the chosen activity. The error description: \(error.localizedDescription)")
          return
        }
        
        if !completed {
          log.verbose("The activity controller was dismissed by the user without performing any action.")
          return
        }
        
        if let chosenActivity = activityType where chosenActivity == UIActivityTypeSaveToCameraRoll {
          SVProgressHUD.showSuccessWithStatus(NSLocalizedString("Saved", comment: "Status string that indicates that the GIF was successfully saved to the Camera Roll."))
        }
      }
    }
    
    presentViewController(ac, animated: true, completion: nil)
    
    // Configure the Popover presentation controller
    if let popController = ac.popoverPresentationController {
      popController.permittedArrowDirections = .Any
      popController.barButtonItem = shareBarButton
    }
  }
  
  // MARK: - View Controller
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let indexPath = gifAsset?.collectionViewIndexPath {
      observedIndexPath = indexPath
    }

    addBackgroundAlertDismissingObserver()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GFAnimationPreviewViewController.diskReadTaskFinished(_:)), name: GFDiskReadTaskFinishedNotification, object: nil)

    
    if let bgColor = gifPreviewCollectionView?.backgroundColor {
      normalBackgroundColor = bgColor
    }
    
    playAnimationToolbar.barTintColor = kGlobalTintColor
    
    setControlsToDefaultState()
    setupToolbarItems()
    setupGestureRecognizers()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
    
    isBeingPopped = false
    cancelHelper.shouldStopOperations = false
    
    // Check whether the animation has already been prepared.
    if let animationUrls = animationUrls where animationUrls.count > 0 {
      // Hide save bar button 'cause the animation was already saved.
      saveGifBarButton.enabled = false
      navigationItem.rightBarButtonItem = nil
    } else {
      observedIndexPath = NSIndexPath(forItem: 0, inSection: 0)
      setupAnimation()
      
      if let mainController = mainScreenControllerForEditingStage {
        mainController.createAndLoadInterstitial()
      }
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(true)
    didViewAppear = true
    needsCellInsetsUpdate = false
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()

    if needsCellInsetsUpdate {
      updateCellInsets()
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    if !didViewAppear {
      gifPreviewCollectionView.collectionViewLayout.invalidateLayout()
      if let indexPath = observedIndexPath {
        gifPreviewCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .None, animated: false)
      }
    }
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(true)

    stopActivityIndicatorIfNeeded()
    
    if isInFullscreenMode {
      toggleFullScreen()
    }
    
    if let imageRequestID = cancelHelper.imageRequestID {
      PHImageManager.defaultManager().cancelImageRequest(imageRequestID)
    }
    
    isBeingPopped = true
    cancelHelper.shouldStopOperations = true
    
    if let animationUrls = animationUrls {
      for url in animationUrls {
        cancelHelper.outdatedFiles.insert(url.absoluteString)
      }
    }
    
    if let mainController = mainScreenControllerForPreviewStage {
      mainController.scrollToIndexPath = visibleIndexPath
      if let cell = observedCell, let animatedImageView = cell.animatedImageView, animatedImage = animatedImageView.image as? YYImage {
        mainController.animatedTransitionFrameIndex = Int(animatedImageView.currentAnimatedImageIndex)
        mainController.animatedTransitionImage = animatedImage
      } else {
        log.warning("Failed to configure the transition to the main controller.")
      }
    }
    
    YYImageCache.sharedCache().memoryCache.removeAllObjects()
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(true)
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return isInFullscreenMode
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
  
  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
   
    gifPreviewCollectionView.collectionViewLayout.invalidateLayout()
    needsCellInsetsUpdate = true
    didViewAppear = false
    
    coordinator.animateAlongsideTransition({ context in
      self.updateSliderWidth()
    }) {
      finished in
      self.needsCellInsetsUpdate = false
      self.didViewAppear = true
    }
  }
  
  deinit {
    removeBackgroundAlertDismissingObserver()
    NSNotificationCenter.defaultCenter().removeObserver(self, name: GFDiskReadTaskFinishedNotification, object: nil)
  }
  
  // MARK: - Instance Methods
  /// Responds to the GFDiskReadTaskFinishedNotification
  func diskReadTaskFinished(notification: NSNotification) {
    if let requestInfo = notification.userInfo?[kGFGifRequestInfoKey] as? GFGifRequestInfo {
      dispatch_async(dispatch_get_main_queue()) {
        if let error = requestInfo.error {
          log.error("Failed to retrieve the animation from cache. The error description: \(error.localizedDescription)")
          return
        }
        
        if requestInfo.state == .Finished {
          for cell in self.gifPreviewCollectionView.visibleCells() {
            if let previewCell = cell as? GFGifPreviewCell where previewCell.uniqueIdentifier == requestInfo.url.absoluteString && previewCell.imageView?.image == nil {
              if let indexPath = self.gifPreviewCollectionView.indexPathForCell(previewCell) {
                self.gifPreviewCollectionView.reloadItemsAtIndexPaths([indexPath])
              }
              break
            }
          }
        }
      }
    } else {
      log.warning("Failed to retrieve the GIF URL from the info dictionary passed with GFDiskReadTaskFinishedNotification.")
    }
  }
  
  /// Performs additional clean-up after the animation data has been loaded.
  private func finalizeAnimationLoading() {
    var frameCount: UInt?

    if let cell = observedCell, let animatedImageView = cell.animatedImageView, let animatedImage = animatedImageView.image as? YYImage {
      if cell.delegate == nil {
        cell.delegate = self
      }
      frameCount = animatedImage.animatedImageFrameCount()
      
      if let asset = gifAsset where asset.transitionFrameIndex > -1 {
        // Start animation from the frame the transition started at.
        animatedImageView.currentAnimatedImageIndex = UInt(asset.transitionFrameIndex)
        
        // Disable further updates.
        asset.transitionFrameIndex = -1
      }
    }
    
    guard let unwrappedFrameCount = frameCount else {
      log.verbose("The animation request was cancelled.")
      return
    }
    
    frameCountLabel.text = String(unwrappedFrameCount + 1)
    
    // animatedImageFrameCount can be less than 1 if the error has been occured.
    let sliderMaximumValue = unwrappedFrameCount < 1 ? 0 : unwrappedFrameCount - 1
    if sliderMaximumValue >= 1 {
      // Configure GIF controls if the animation has more than 1 frame (the minimum slider value starts form 0).
      if animationTimelineSlider.maximumValue != Float(sliderMaximumValue) {
        animationTimelineSlider.maximumValue = Float(sliderMaximumValue)
      }
      
      sliderContainterBarItem.enabled = true
      animationTimelineSlider.enabled = true
      animationTimelineSlider.hidden = false
      
      pauseBarButton.enabled = true
      playBarButton.enabled = true

      setPreviewScreenToPlayMode()
    } else {
      setControlsToDefaultState()
      setPreviewScreenToPauseMode()
    }
    
    updateSliderWidth()

    // Configure trash button for the saved GIFs only.
    if gifAsset?.url != nil {
      trashBarButton.tintColor = UIColor.whiteColor()
      trashBarButton.enabled = true
    }
    
    shareBarButton.enabled = true
    
    // Enable gesture recognizers.
    singleTapRecognizer.enabled = true
    doubleTapRecognizer.enabled = true
    
  }
  
  /// Removes the GIF from the `Documents` folder.
  private func removeGifFromDocuments() {
    
    /// This function is used as a delete handler for the action sheet item.
    /// - parameter deleteAction: `UIAlertAction` object that is displayed as a delete button in the alert.
    func deleteGIFHandler(deleteAction: UIAlertAction) {
      if let indexPath = observedIndexPath, let gifUrl = animationUrls?[indexPath.item] {
        if (try? NSFileManager.defaultManager().removeItemAtURL(gifUrl)) != nil {
          log.verbose("The GIF was successfully deleted.")
          let currentGifAsset = GFGifAsset(animationWrapper: observedImageView?.image, gifUrl: gifUrl, collectionViewIndexPath: indexPath)
          
          let info = [kGFGifAssetInfoKey: currentGifAsset]
          NSNotificationCenter.defaultCenter().postNotificationName(GFGifWasRemovedFromDocumentsNotification, object: self, userInfo: info)
          
          if let mainController = mainScreenControllerForPreviewStage {
            mainController.usesPinterestTransitionAnimation = false
          }
          
          self.navigationController?.popViewControllerAnimated(true)
        } else {
          UIAlertController.sh_showAlertFromViewController(self, withTitle: NSLocalizedString("GIF Has Not Been Deleted Because of the Error", comment: "Alert title describing the error which have occurred during GIF removing."), andMessage: nil) {
            action in
            
            // Try to delete GIF again.
            deleteGIFHandler(deleteAction)
          }
        }
      } else {
        log.warning("The URL of the current GIF is not available.")
        return
      }
    }
    
    let deleteActionTitle = NSLocalizedString("Delete GIF", comment: "Title for the delete GIF action.")
    UIAlertController.sh_showActionSheetFromViewController(self, withPresentingBarButton: trashBarButton, deleteActionTitle: deleteActionTitle, deleteHandler: deleteGIFHandler, cancelHandler: nil)
  }
  
  /// Sets toolbar items to the appropriate initial state.
  private func setupToolbarItems() -> Void {
    playAnimationToolbar.items?.removeAtIndex(pauseBarButton.tag)
  }
  
  /// Sets the preview view controller to the pause mode with stopping animation playing and changing ui control states accordingly.
  private func setPreviewScreenToPauseMode() {
    if let imageView = observedImageView, let image = imageView.image as? YYImage where imageView.isAnimating() || image.animatedImageFrameCount() <= 1 {
      imageView.stopAnimating()
      playAnimationToolbar.sh_replaceBarButtonAtIndex(playBarButton.tag, withBarButton: playBarButton, animated: false)
    }
  }
  
  /// Sets the preview view controller to the play mode with starting animation playing and changing ui control states accordingly.
  private func setPreviewScreenToPlayMode() {
    if let imageView = observedImageView where !imageView.isAnimating() {
      playAnimationToolbar.sh_replaceBarButtonAtIndex(playBarButton.tag, withBarButton: pauseBarButton, animated: false)
      imageView.startAnimating()
    }
  }
  
  /// Saves GIF to the `Documents` folder.
  private func saveGifToDocuments() {
    // Start an activity indicator
    SVProgressHUD.showWithStatus(NSLocalizedString("Saving GIF animation...", comment: "Activity indicator status message that is displayed duting GIF saving."))
    
    // Asynchronously write GIF to the app Documents folder.
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) {
      [weak self] in
      guard let weakSelf = self else { return}
      
      var didOperationSucceed = false
      
      // Compose file url.
      let documentsDirectoryURL = NSFileManager.sh_getDocumentsDirectoryURL()
      
      if let documentsDirectoryURL = documentsDirectoryURL {
        let generatedFileName = NSFileManager.sh_generateFileNameUsingCurrentDate(withPrefix: "GIF")
        let fileUrl = documentsDirectoryURL.URLByAppendingPathComponent(generatedFileName, isDirectory: false).URLByAppendingPathExtension("gif")
        
        // Write animation to file url.
        if let gifAsset = weakSelf.gifAsset {
          var gifData: NSData?
          if let imageData = gifAsset.data {
            gifData = imageData
          } else if let staticImage = gifAsset.staticImage {
            gifData = UIImagePNGRepresentation(staticImage)
          }
          
          if let gifData = gifData {
            didOperationSucceed = gifData.writeToURL(fileUrl, atomically: true)
            if didOperationSucceed {
              log.verbose("The animation data has been successfully wirtten to \(fileUrl.path)")
              gifAsset.url = fileUrl
              let info = [kGFGifAssetInfoKey: gifAsset]
              NSNotificationCenter.defaultCenter().postNotificationName(GFGifWasSavedToDocumentsNotification, object: self, userInfo: info)
              
              dispatch_async(dispatch_get_main_queue()) {
                [weak self] _ in
                guard let weakSelf = self else { return }
                
                if let mainController = weakSelf.mainScreenControllerForEditingStage {
                  mainController.sh_addFullscreenSnapshotOfView(weakSelf.view)
                  weakSelf.navigationController?.presentingViewController?.dismissViewControllerAnimated(false, completion: nil)
                  mainController.interstitial.presentFromRootViewController(mainController)
                }
              }
            }
          }
        }
      }
      
      dispatch_async(dispatch_get_main_queue()) {
        [weak self] _ in
        guard let weakSelf = self else { return }
        
        // Stop an activity indicator
        weakSelf.stopActivityIndicatorIfNeeded()
        
        // Error handling goes here.
        if didOperationSucceed == false {
          UIAlertController.sh_showAlertFromViewController(weakSelf, withTitle: NSLocalizedString("GIF Has Not Been Saved Because of the Error", comment: "Alert title describing the error which have occurred during GIF saving."), andMessage: nil) {
            action in
            
            // Try to save GIF again.
            weakSelf.saveGifToDocuments()
          }
        }
      }
    }
  }
  
  /// Stops an activity indicator.
  private func stopActivityIndicatorIfNeeded() {
    if SVProgressHUD.isVisible() {
      SVProgressHUD.dismiss()
    }
  }
  
  /// Configures current animation for preview.
  private func setupAnimation() -> Void {
    guard let frames = gifFrames else {
      log.warning("Failed to load the assets required for the animation preview.")
      return
    }
    guard let settingsManager = settingsManager else {
      log.warning("Failed to load the settings manager required for the animation preview.")
      return
    }
    
    SVProgressHUD.showWithStatus(NSLocalizedString("Loading GIF animation...", comment: "Activity indicator status message for GIF loading"))

    
    // Convert chosen assets to the animation sequence.
    UIImage.sh_convertFramesToGif(frames, settingsManager: settingsManager, cancelHelper: cancelHelper)  {
      [weak self] (animationData, error) in
      
      guard let weakSelf = self else { return }
      
      dispatch_async(dispatch_get_main_queue()) {
        weakSelf.stopActivityIndicatorIfNeeded()
        
        if weakSelf.isBeingPopped == false {
          if let error = error {
            UIAlertController.sh_showAlertFromViewController(weakSelf, withTitle: error.localizedDescription, andMessage: nil)
          } else {
            guard let unwrappedAnimationData = animationData else {
              UIAlertController.sh_showAlertFromViewController(weakSelf, withTitle: NSLocalizedString("Failed to Load the Animation Data", comment: "Alert title for situation when the animation data cannot be loaded."), andMessage: nil)
              return
            }
            
            // Create animated image.
            let animatedImage = YYImage(data: unwrappedAnimationData)
            
            guard let unwrappedAnimatedImage = animatedImage else {
              UIAlertController.sh_showAlertFromViewController(weakSelf, withTitle: NSLocalizedString("Failed to Set the Animated Image", comment: "Alert title for situation when the animation image cannot be set."), andMessage: nil)
              return
            }
            
            // Finalize animation loading.
            weakSelf.saveGifBarButton.enabled = true
            weakSelf.gifAsset = GFGifAsset(animationWrapper: unwrappedAnimatedImage, gifUrl: nil, collectionViewIndexPath: nil)
            weakSelf.gifPreviewCollectionView.reloadData()
          }
        }
      }
    }
  }
  
  /// Sets the preview controller items to the default state.
  private func setControlsToDefaultState() {
    // Hide slider
    sliderContainterBarItem.enabled = false
    animationTimelineSlider.enabled = false
    animationTimelineSlider.hidden = true
    
    // Hide trash button
    trashBarButton.tintColor = UIColor.clearColor()
    trashBarButton.enabled = false
    
    // Disable buttons
    pauseBarButton.enabled = false
    playBarButton.enabled = false
    shareBarButton.enabled = false

    // Disable gesture recognizers
    singleTapRecognizer.enabled = false
    doubleTapRecognizer.enabled = false
  }
  
  /// Configures the gesture recognizers to handle zoom and full-screen mode toggling.
  private func setupGestureRecognizers() {
    singleTapRecognizer.requireGestureRecognizerToFail(doubleTapRecognizer)
  }
  
  /// Toggles between full-screen and normal modes.
  private func toggleFullScreen() {
    isInFullscreenMode = !isInFullscreenMode

    /// Set initial collection view layout
    needsCellInsetsUpdate = true
    updateCellInsets()
    gifPreviewCollectionView.collectionViewLayout.invalidateLayout()

    if !isInFullscreenMode {
      setNeedsStatusBarAppearanceUpdate()
    }
    
    // Ensure that all pending layout operations have been completed
    view.layoutIfNeeded()

    let animatedColor = isInFullscreenMode ? fullScreenBackgroundColor : normalBackgroundColor
    navigationController?.setNavigationBarHidden(self.isInFullscreenMode, animated: true)
    UIView.animateWithDuration(Double(UINavigationControllerHideShowBarDuration), delay: 0, options: [.CurveEaseInOut], animations: {
      // Animate colors
      self.gifPreviewCollectionView.backgroundColor = animatedColor
      
      // Hide toolbar
      self.bottomBarConstraint.constant = self.isInFullscreenMode ? -self.playAnimationToolbar.frame.size.height : 0
      
      if self.isInFullscreenMode {
        self.setNeedsStatusBarAppearanceUpdate()
      }

      // Animate constraints changes when transitioning from normal to fullscreen mode
      if !self.isInFullscreenMode {
        self.view.layoutIfNeeded()
      } else {
        UIView.performWithoutAnimation {
          self.view.layoutIfNeeded()
        }
      }
    
      }) {
        finished in
        self.needsCellInsetsUpdate = false
    }
  }
  
  /// Updates the `UISlider` width in accordance with the current frame count.
  private func updateSliderWidth() {
    let shareButtonView = shareBarButton.valueForKey("view") as? UIView
    let playButtonView = playBarButton.valueForKey("view") as? UIView
    let trashButtonView = trashBarButton.valueForKey("view") as? UIView
    let kOffsetFromSurroundingViews: CGFloat = 120
    let availableWidthForSlider = UIScreen.mainScreen().bounds.width  - leftEdgeFixedSpace.width - rightEdgeFixedSpace.width - sharePlayFixedSpace.width - (shareButtonView?.frame.width ?? 44.0) - (playButtonView?.frame.width ?? 44.0) - frameCountLabel.frame.width - (trashButtonView?.frame.width ?? 44.0) - kOffsetFromSurroundingViews
    let kOneFrameSlideWidth: CGFloat = 44.0
    let requiredSliderWidth = CGFloat(animationTimelineSlider.maximumValue) * kOneFrameSlideWidth
    let actualSliderWidth = requiredSliderWidth > availableWidthForSlider ? availableWidthForSlider : requiredSliderWidth
    
    animationTimelineSlider.frame.size.width = actualSliderWidth
  }
  
  /// Changes the current observed index path in accordance with the new position in the collection view.
  ///
  /// - parameter newIndexPath: Index path of the new currently displayed cell containing the animated image view.
  private func updateCurrentIndexPath(withIndexPath newIndexPath: NSIndexPath) {
    if let indexPath = observedIndexPath {
      previousCachedCellIndex = indexPath.item
    }
    observedIndexPath = newIndexPath
  }

  /// Updates the memory cache in accordance with the currently visible animation.
  ///
  /// - note: To reduce device memory usage only the neighbors of the current cell are cached.
  private func updateCachedAnimations() {
    guard let animationUrls = animationUrls else { return }
    guard let currentIndexPath = observedIndexPath else { return }
    
    if previousCachedCellIndex == -1 {
      previousCachedCellIndex = currentIndexPath.item
    }
    
    var removedIndexPaths = [NSIndexPath]()
    var addedIndexPaths = [NSIndexPath]()
    
    // Determine cells that must be removed from the memory cache.
    if previousCachedCellIndex < currentIndexPath.item {
      // Select the leftmost cell if it exists.
      if previousCachedCellIndex - 1 >= 0 {
        removedIndexPaths.append(NSIndexPath(forItem: (previousCachedCellIndex - 1), inSection: 0))
      }
    } else if previousCachedCellIndex > currentIndexPath.item {
      // Select the rightmost cell if it exists.
      if previousCachedCellIndex + 1 < animationUrls.count {
        removedIndexPaths.append(NSIndexPath(forItem: (previousCachedCellIndex + 1), inSection: 0))
      }
    }
    
    //Determine cells that must be added to the memory cache.
    if currentIndexPath.item - 1 >= 0 {
      addedIndexPaths.append(NSIndexPath(forItem: (currentIndexPath.item - 1), inSection: 0))
    }
    
    if currentIndexPath.item + 1 < animationUrls.count {
      addedIndexPaths.append(NSIndexPath(forItem: (currentIndexPath.item + 1), inSection:0))
    }
    
    for indexPath in removedIndexPaths {
      cancelHelper.outdatedFiles.insert(animationUrls[indexPath.item].absoluteString)
      YYImageCache.sharedCache().removeImageForKey(animationUrls[indexPath.item].absoluteString)
    }
    
    for indexPath in addedIndexPaths {
      cancelHelper.outdatedFiles.remove(animationUrls[indexPath.item].absoluteString)
      
      PHCachingImageManager.sh_requestAnimationFromCache(cacheManager, forUrl: animationUrls[indexPath.item], cancelHelper: self.cancelHelper, resultHandler: nil)
    }
  }
  
  /// Updates the collection view cell top and bottom insets in accordance with the current screen mode (fullscreen or normal).
  private func updateCellInsets() {
    topEdgeCellOfsset = isInFullscreenMode ? 0.0 : (navigationController?.navigationBar.frame.height ?? 64.0) + UIApplication.sharedApplication().statusBarFrame.height
    bottomEdgeCellOffset = isInFullscreenMode ? 0.0 : playAnimationToolbar.frame.height
  }
}

// MARK: - UICollectionViewDataSource
extension GFAnimationPreviewViewController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return animationUrls?.count ?? 1
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kGifPreviewCellIdentifier, forIndexPath: indexPath) as! GFGifPreviewCell
    
    // Check whether the animation was loaded as part of the transition from the main screen.
    if let asset = gifAsset where asset.transitionFrameIndex > -1 {
      if let image = asset.animatedImage {
        cell.animatedImageView.image = image
        observedCell = cell
        finalizeAnimationLoading()
        return cell
      }
    }
    
    
    // If the animation URLs array is not nil the preview controller will use the collection view to present all the available GIFs in full-screen mode.
    if let animationUrls = animationUrls {
      cell.uniqueIdentifier = animationUrls[indexPath.item].absoluteString
      
      if !cell.activityIndicator.isAnimating() {
        cell.activityIndicator.startAnimating()
      }

      PHCachingImageManager.sh_requestAnimationFromCache(cacheManager, forUrl: animationUrls[indexPath.item], cancelHelper: cancelHelper) {
        [weak cell, weak self] image, url, state, error in
        
        dispatch_async(dispatch_get_main_queue()) {
          guard let weakSelf = self, let weakCell = cell else { return }
          
          if let error = error {
            log.error("Failed to configure the preview cell. The error description: \(error.localizedDescription)")
            return
          }
          
          if state == .Cancelled {
            
            if weakCell.uniqueIdentifier == url.absoluteString {
              // Check whether the cancelled item is visible again (in case of fast scroll).
              let visibleIndexPaths = weakSelf.gifPreviewCollectionView.indexPathsForVisibleItems()
              if visibleIndexPaths.contains(indexPath) {
                // Ensure that the cancelled item is reloaded.
                weakSelf.cancelHelper.outdatedFiles.remove(animationUrls[indexPath.item].absoluteString)
                weakSelf.gifPreviewCollectionView.reloadItemsAtIndexPaths([indexPath])
              }
            }
            
            log.verbose("The current animation request was cancelled.")
            return
          }
          
          if state == .Reading {
            log.verbose("The animation file is being read from the disk.")
            return
          }
          
          guard let unwrappedImage = image else {
            log.warning("Failed to obtain the preview cell's image.")
            return
          }
          if url.absoluteString == weakCell.uniqueIdentifier {
            weakCell.activityIndicator.stopAnimating()
            weakCell.animatedImageView.image = unwrappedImage
            
            // Finalized animation for the currently observed cell only.
            if let currentIndexPath = weakSelf.observedIndexPath where currentIndexPath == indexPath {
              weakSelf.observedCell = weakCell
              weakSelf.finalizeAnimationLoading()
            }
          }
        }
      }
    } else {
      if let animatedImage = gifAsset?.animatedImage {
        cell.animatedImageView.image = animatedImage

        observedCell = cell
        finalizeAnimationLoading()
      }
    }
    
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GFAnimationPreviewViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    
    let flowLayoutDelegate = self as UICollectionViewDelegateFlowLayout
    let insets = flowLayoutDelegate.collectionView!(collectionView, layout: collectionViewLayout, insetForSectionAtIndex: 0)
    let offset = insets.top + insets.bottom
    return CGSizeMake(collectionView.bounds.width, collectionView.bounds.height - offset)
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 0.0
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 0.0
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    return UIEdgeInsetsMake(topEdgeCellOfsset, 0, bottomEdgeCellOffset, 0)
  }
}

// MARK: - UIScrollViewDelegate
extension GFAnimationPreviewViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    guard let newIndexPath = visibleIndexPath else {
      log.warning("Failed to obtain the new cell's index path of the scrolled collection view.")
      return
    }

    if let currentIndexPath = observedIndexPath where currentIndexPath != newIndexPath {
      // Update the current observed index path.
      updateCurrentIndexPath(withIndexPath: newIndexPath)
      
      if let updatedIndexPath = observedIndexPath {
        // Enable all the required controls to play animation.
        if let cell = gifPreviewCollectionView.cellForItemAtIndexPath(updatedIndexPath) as? GFGifPreviewCell {
          observedCell = cell
          finalizeAnimationLoading()
          
          // Update the memory cache.
          updateCachedAnimations()
        }
      }
    }
  }
}

// MARK: - GFAnimationPreviewDelegate
extension GFAnimationPreviewViewController: GFAnimationPreviewDelegate {
  func collectionViewCell(collectionViewCell: GFGifPreviewCell, didChangeAnimationPositionToIndex index: Int) {
    dispatch_async(dispatch_get_main_queue()) {
      if let currentCell = self.observedCell {
        if currentCell.uniqueIdentifier == collectionViewCell.uniqueIdentifier {
          if self.animationTimelineSlider.value != Float(index) {
            self.animationTimelineSlider.value = Float(index)
          }
          self.frameCountLabel.text = String(index + 1)
        } else {
          // Reset delegate of the cell that is not currently visible.
          collectionViewCell.delegate = nil
        }
      }
    }
  }
}

// MARK: - RMPZoomTransitionAnimating
extension GFAnimationPreviewViewController: RMPZoomTransitionAnimating {
  func transitionSourceImageView() -> UIImageView! {
    let imageView = UIImageView()
    imageView.clipsToBounds = true
    imageView.userInteractionEnabled = false
    
    if let cell = observedCell, let animatedImageView = cell.animatedImageView, let animatedImage = animatedImageView.image as? YYImage {
      imageView.frame = getCurrentAnimationFrame()
      imageView.image = animatedImage.animatedImageFrameAtIndex(animatedImageView.currentAnimatedImageIndex)
    } else {
      log.debug("Cannot configure source image frame because the cell is not loaded yet.")
    }
    
    return imageView
  }
  
  func transitionSourceBackgroundColor() -> UIColor! {
    return view.backgroundColor ?? UIColor.whiteColor()
  }
  
  func transitionDestinationImageViewFrame() -> CGRect {
    return getCurrentAnimationFrame()
  }
  
  /// Calculates the frame of the animation that should be displayed in the fullsceen cell. At this point the collection view layout is not upaded so the frame is calculated in accordance with the available size (`UINavgiationBar` and `playAnimationToolbar` heights are excluded) taking into account that the animation must use the scale aspect fit mode.
  func getCurrentAnimationFrame() -> CGRect {
    var frame = CGRectZero
    var availableSize = CGSizeZero
    
    let topOffset = (navigationController?.navigationBar.frame.height ?? 64.0) + UIApplication.sharedApplication().statusBarFrame.height
    frame.origin.y = topOffset
    
    availableSize.width = UIScreen.mainScreen().bounds.width
    availableSize.height = UIScreen.mainScreen().bounds.height - topOffset - playAnimationToolbar.frame.height
    
    if let image = gifAsset?.staticImage {
      let fittedSize = RMPZoomTransitionHelper.fitSize(image.size, toAvailableSize: availableSize)
      frame.size = fittedSize
      
      if fittedSize.width < availableSize.width {
        frame.origin.x = (availableSize.width - fittedSize.width) / 2
      }
      
      if fittedSize.height < availableSize.height {
        frame.origin.y += (availableSize.height - fittedSize.height) / 2
      }
    }
    
    return frame
  }
}

// MARK: - RMPZoomTransitionDelegate
extension GFAnimationPreviewViewController: RMPZoomTransitionDelegate {
}
