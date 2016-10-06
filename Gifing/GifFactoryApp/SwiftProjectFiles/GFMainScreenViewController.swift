//
//  GFMainScreenViewController.swift
//  GifFactoryApp
//  
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit
import Photos
import XCGLogger
import CTAssetsPickerController
import YYWebImage
import GoogleMobileAds
import RMPZoomTransitionAnimator


/// View Controller which handles the first screen presentation.
class GFMainScreenViewController: UIViewController, GFBackgroundAlertDismissing {
  // MARK: - GFBackgroundAlertDismissing
  var _backgroundAlertDismissingObserver: NSObjectProtocol?
  
  // MARK: Properties
  /// Defines the identifier of this controller in storyboard.
  static let storyboardId = "GFMainScreenViewControllerId"
  
  /// AdMob banner.
  var bannerView: GADBannerView!
  /// The interstitial ad.
  var interstitial: GADInterstitial!
  /// An array of NSURL objects representing paths of the animated GIF files in the Documents directory
  var animationUrls: [NSURL]?
  /// Indicates whether the animations in the collection view will start animating automatically.
  var isAutoPlayEnabled = true
  /// Represents the index path the collection view must be scrolled to when appearing.
  var scrollToIndexPath: NSIndexPath?
  /// The animated image that was loaded in the preview controller and used as part of the transition.
  var animatedTransitionImage: YYImage?
  /// The index of animation frame that was displayed before the transiton from the preview controller started.
  var animatedTransitionFrameIndex = -1
  /// Indicates whether the Pinterest style transition is used to go to/from the preview controller.
  var usesPinterestTransitionAnimation = true
  
  /// The cache manager that is used to cache the previously saved GIF images.
  private var cacheManager: YYImageCache = {
    return YYImageCache.sharedCache()
  }()
  /// The observer that is used to get notified when `UIApplicationDidEnterBackgroundNotification` has been sent.
  private var backgroundObserver: NSObjectProtocol?
  /// Selected animation in the collection view.
  private var selectedGifAsset: GFGifAsset?
  /// Used to hold the previous selected video asset which is deselected when the user selects a new asset.
  private var previousSelectedItem: PHAsset?
  /// The auto layou constraint controlling the banner height.
  private var bannerHeightConstraint: NSLayoutConstraint!
  /// Indicates whether GIF files reading from disk should be stopped. To stop reading a particular file add its URL to the `outdatedFiles` array.
  private var cancelHelper = GFCancelOperationsHelper()
  /// The previous rectangle that contains cached animations.
  private var previousPreheatArea: CGRect = CGRectZero
  /// The identifier that is used to detect the segue to the animation preview controller.
  private let kAnimationPreviewSegueIdentifier = "FromMainToAnimationPreviewSegue"
  /// The identifier that is used to detect the segue to the editor controller.
  private let kGFEditorNavigationControllerIdentifier = "GFEditorNavigationController"
  /// The identifier that is used to detect the segue to the extractor controller.
  private let kGFExtractorNavigationControllerIdentifier = "GFExtractorNavigationController"
  /// The reuse identifier by means of which the collection view identifies and queues the views for the animations cells.
  private let kSavedAnimationCellIdentifier = "SavedAnimationCell"
  /// Defines the fixed space value for the main controller collection view.
  private let kGFMainScreenCollectionViewFixedSpacing: CGFloat = 5.0
  /// The AdMob banner ad unit id.
    
//    
//  //testADs
//  private let kBannerAdUnitId = "ca-app-pub-3940256099942544/2934735716"
//  /// The AdMob interstitial ad unit id.
//  private let kInterstitialAdUnitId = "ca-app-pub-3940256099942544/4411468910"
    
    
    private let kBannerAdUnitId = "ca-app-pub-5395321550360079/8815856743"
    /// The AdMob interstitial ad unit id.
    private let kInterstitialAdUnitId = "ca-app-pub-5395321550360079/1292589942"

    
    
    
  /// Indicates whether the automatic banner size update is enabled. This flag is used to prevent banner update when the app is in the background.
  private var isBannerSizeUpdateEnabled = true
  /// Indicates whether AdMob banner is in portrait mode.
  private var isBannerInPortraitMode = false

  
  
  // MARK: - IBOutlets
  /// Collection view that is used for holding saved GIF animations.
  @IBOutlet var savedAnimationsCollectionView: UICollectionView!
  /// Auto layout constraint that defines the bottom position of the collection view with the saved animations.
  @IBOutlet var collectionViewBottomConstraint: NSLayoutConstraint!

  // MARK: - IBActions
  /**
   *  Shows Action Sheet with options for adding/creating GIFs.
   *
   *  - parameter sender: Right Bar Button Item.
   */
  @IBAction func showGifSourcesActionSheet(sender: AnyObject) {
    /**
     *  Configures and presents the assets picker controller so that it can be used to retrieve the required Photos app entities.
     * 
     *  - parameter fetchOptions: The options that ontrol which objects the fetch result includes.
     *  - parameter shouldShowSelectionIndex: Determines whether or not the selection index is shown in the grid view.
     */
    func presentPickerController(withFetchOptions fetchOptions: PHFetchOptions, shouldShowSelectionIndex: Bool = true) -> Void {
      PHPhotoLibrary.requestAuthorization {
        (status) in
        dispatch_async(dispatch_get_main_queue()) {
          if(status == .Authorized) {
            let ctAssetsPickerController: CTAssetsPickerController = CTAssetsPickerController()
            ctAssetsPickerController.delegate = self
            ctAssetsPickerController.showsSelectionIndex = shouldShowSelectionIndex
            ctAssetsPickerController.showsNumberOfAssets = true
            ctAssetsPickerController.alwaysEnableDoneButton = false
            ctAssetsPickerController.assetsFetchOptions = fetchOptions

            //[2.2.2.] Show images picking interface
            self.presentViewController(ctAssetsPickerController, animated: true, completion: nil)
          } else {
            UIAlertController.sh_showAlertFromViewController(self, withTitle: NSLocalizedString("Grant Permission for Photo Library Access to Load Assets Required for GIF Creation", comment: "Photo library access denied dialog message when trying to load the assets to create the GIF animation."),
              andMessage: nil,
              isSettingsButtonRequired: true)
          }
        }
      }
    }
    
    // Create controller which presents Action Sheet
    // - note: iOS human interface guidelines recommend that you do not use a title
    let actionSheetController = UIAlertController(
      title: nil,
      message: nil,
      preferredStyle: .ActionSheet)
    
    // Actions configuration
    // Action for closing Action Sheet
    let cancelAction = UIAlertAction(
      title: kCancelActionButtonLabel,
      style: .Cancel){ (action) -> Void in
        // Place customized cancel code here...
        log.verbose("GIFs sources Action Sheet has been canceled.")
    }
    
    // Action that is used to create GIF from the images.
    let createGifFromImagesAction = UIAlertAction(
      title: NSLocalizedString("Create GIF from Images", comment: "Title for the action that is used to create GIF from images"),
      style: .Default) { (action) -> Void in
        let assetsFetchOptions = PHFetchOptions()
        assetsFetchOptions.predicate = NSPredicate(format: "(mediaType == %d)", PHAssetMediaType.Image.rawValue, 0)
        presentPickerController(withFetchOptions: assetsFetchOptions)
    }
    
    // Action that is used to create GIF from the video file.
    let createGifFromVideoAction = UIAlertAction(
      title: NSLocalizedString("Create GIF from Video", comment: "Title for the action that is used to create GIF from video file."),
      style: .Default) { (action) -> Void in
        let assetsFetchOptions = PHFetchOptions()
        assetsFetchOptions.predicate = NSPredicate(format: "(mediaType == %d)", PHAssetMediaType.Video.rawValue, 0)
        presentPickerController(withFetchOptions: assetsFetchOptions, shouldShowSelectionIndex: false)
    }
    
    // Actions adding section
    actionSheetController.addAction(cancelAction)
    actionSheetController.addAction(createGifFromImagesAction)
    actionSheetController.addAction(createGifFromVideoAction)
    
    // Code section that is required for proper Action Sheet presentation on iPad
    if let iPadPopover = actionSheetController.popoverPresentationController {
      log.verbose("iPad popover presentation style has been detected.")
      
      iPadPopover.barButtonItem = (sender as! UIBarButtonItem)
      iPadPopover.permittedArrowDirections = .Any
      
      // Prevent snapshotting problem on iPad
      actionSheetController.view.layoutIfNeeded()
    }
    
    // Show configured Action Sheet
    presentViewController(actionSheetController, animated: true) {
      log.verbose("GIFs sources Action Sheet has been presented.")
    }
  }
  
  // MARK: - View Controller
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if(segue.identifier == kAnimationPreviewSegueIdentifier) {
      let destinationController = segue.destinationViewController as! GFAnimationPreviewViewController
      if let selectedGifAsset = selectedGifAsset {
        destinationController.gifAsset = selectedGifAsset
        destinationController.animationUrls = animationUrls
        destinationController.mainScreenControllerForPreviewStage = self
      } else {
        log.error("Failed to retrieve the selected GIF animation to perform segue.")
      }
    }
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(true)

    reloadVisibleCells()
    updateCachedAnimations()
    
    isBannerSizeUpdateEnabled = true
    updateBannerSize()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(true)

    var excludedURLs = Set<NSURL>()
    // Exclude the selected cell and its the neighbours from the cache clearing.
    if let animationUrls = animationUrls {
      if let selectedGifAsset = selectedGifAsset, let selectedIndexPath = selectedGifAsset.collectionViewIndexPath where selectedIndexPath.item > 0 && selectedIndexPath.item < animationUrls.count {
        
        excludedURLs.insert(animationUrls[selectedIndexPath.item])
        if selectedIndexPath.item - 1 >= 0 {
          excludedURLs.insert(animationUrls[selectedIndexPath.item - 1])
        }
        if selectedIndexPath.item + 1 < animationUrls.count {
          excludedURLs.insert(animationUrls[selectedIndexPath.item + 1])
        }
      }
    }

    stopDiskReadOperations(withExcludedURLs: excludedURLs)
    resetCachedAnimations(withExcludedURLs: excludedURLs)
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(true)
    clearVisibleCells()
  }
  
  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    
    if sh_isViewVisible() {
      savedAnimationsCollectionView.collectionViewLayout.invalidateLayout()
      
      coordinator.animateAlongsideTransition({
        [weak self] context in
        guard let weakSelf = self else { return }
        
        if weakSelf.isBannerSizeUpdateEnabled {
          weakSelf.bannerView.alpha = 0.0
          weakSelf.updateBannerSize()
        }
        
        weakSelf.reloadVisibleCells()
        weakSelf.updateCachedAnimations()
      }) {
        [weak self] context in
        guard let weakSelf = self else { return }
        
        weakSelf.showBanner()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    navigationController?.delegate = self
    
    // Configure AdMob banner.
    bannerView = GADBannerView()
    
    // - note: ads will be updated automatically in accordance with the settings in your AdMob dashboard.
    bannerView.autoloadEnabled = true

    bannerView.alpha = 0.0
    view.addSubview(bannerView)

    bannerView.translatesAutoresizingMaskIntoConstraints = false
    
    // Replace this id with the id configured in your AdMob account.
    bannerView.adUnitID = kBannerAdUnitId
    bannerView.rootViewController = self
    bannerView.delegate = self
    
    // Layout constraint that aligns the banner view to the center of the screen.
    view.addConstraint(NSLayoutConstraint(item: bannerView, attribute: .CenterX,
      relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
    
    // Configure banner bottom constraints.
    NSLayoutConstraint(item: bannerView,
                       attribute: .Bottom,
                       relatedBy: .Equal,
                       toItem: view,
                       attribute: .Bottom,
                       multiplier: 1.0,
                       constant: 0.0).active = true
    bannerHeightConstraint = NSLayoutConstraint(item: bannerView,
                                                attribute: .Height,
                                                relatedBy: .Equal,
                                                toItem: nil,
                                                attribute: .NotAnAttribute,
                                                multiplier: 1.0,
                                                constant: GADBannerView.sh_bannerHeight())
    bannerHeightConstraint.active = true
    
    // Configure a border between the banner and collection view (required by AdMob).
    let borderView = UIView(frame: CGRectZero)
    view.addSubview(borderView)
    borderView.translatesAutoresizingMaskIntoConstraints = false
    borderView.backgroundColor = UIColor.blackColor()
    
    NSLayoutConstraint(item: borderView,
                       attribute: .Leading,
                       relatedBy: .Equal,
                       toItem: view,
                       attribute: .Leading,
                       multiplier: 1.0,
                       constant: 0.0).active = true
    NSLayoutConstraint(item: borderView,
                       attribute: .Trailing,
                       relatedBy: .Equal,
                       toItem: view,
                       attribute: .Trailing,
                       multiplier: 1.0,
                       constant: 0.0).active = true
    NSLayoutConstraint(item: borderView,
                       attribute: .Height,
                       relatedBy: .Equal,
                       toItem: nil,
                       attribute: .NotAnAttribute,
                       multiplier: 1.0,
                       constant: 5.0).active = true
    NSLayoutConstraint(item: borderView,
                       attribute: .Bottom,
                       relatedBy: .Equal,
                       toItem: bannerView,
                       attribute: .Top,
                       multiplier: 1.0,
                       constant: 0.0).active = true
    
    // Configure main collection view bottom constraint.
    collectionViewBottomConstraint.active = false
    
    NSLayoutConstraint(item: savedAnimationsCollectionView,
                       attribute: .Bottom,
                       relatedBy: .Equal,
                       toItem: borderView,
                       attribute: .Top,
                       multiplier: 1.0,
                       constant: 0.0).active = true
    
    addBackgroundAlertDismissingObserver()

    // Add an observer that will respond to GFGifWasSavedToDocumentsNotification
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GFMainScreenViewController.imageWasSaved(_:)), name: GFGifWasSavedToDocumentsNotification, object: nil)
    
    // Add an observer that will respond to GFGifWasRemovedFromDocumentsNotification
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GFMainScreenViewController.imageWasRemoved(_:)), name: GFGifWasRemovedFromDocumentsNotification, object: nil)
    
    // Add an observer that will respond to GFDiskReadTaskFinishedNotification
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GFMainScreenViewController.diskReadTaskFinished(_:)), name: GFDiskReadTaskFinishedNotification, object: nil)
    
    backgroundObserver = NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationDidEnterBackgroundNotification, object: nil, queue: NSOperationQueue .mainQueue()) { [unowned self] notification in
      
      self.isBannerSizeUpdateEnabled = false
    }

    
    // Retrieve the animated GIF URLs.
    let documentsURL = NSFileManager.sh_getDocumentsDirectoryURL()
    if let documentsURL = documentsURL {
      animationUrls = NSFileManager.sh_getFileURLsFromDirectory(documentsURL, withPathExtension: "gif", prefetchPropertiesForKeys: [NSURLContentModificationDateKey])
      if animationUrls != nil {
        NSFileManager.sh_sortFileURLs(&animationUrls!, byDate: .ContentModificationDate, ascending: false)
      } else {
        log.warning("Failed to retrieve GIF URLs.")
      }
    } else {
      log.warning("Failed to retrieve the system Documents directory path.")
    }
  }
  
  override func didReceiveMemoryWarning() {
    forceMemoryCleanup()
    
    if sh_isViewVisible() {
      reloadVisibleCells()
    }
  }
  
  deinit {
    removeBackgroundAlertDismissingObserver()
    NSNotificationCenter.defaultCenter().removeObserver(self, name: GFGifWasSavedToDocumentsNotification, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: GFGifWasRemovedFromDocumentsNotification, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: GFDiskReadTaskFinishedNotification, object: nil)
    if let observer = backgroundObserver {
      NSNotificationCenter.defaultCenter().removeObserver(observer)
    }
    
    // clear cache.
    YYImageCache.sharedCache().memoryCache.removeAllObjects()
    YYImageCache.sharedCache().diskCache.removeAllObjects()
  }
  
  // MARK: - Instance Methods
  /// Updates the cached gif frames in accordance with the scrolled area.
  func updateCachedAnimations() {
    guard let animationUrls = animationUrls else {
      log.warning("Failed to retrieve the array of the animation urls.")
      return
    }
    
    // Update Photos Assets cache.
    PHCachingImageManager.sh_requestUpdatedIndexPathsForCollectionView(savedAnimationsCollectionView, withPreviousPreheatArea: previousPreheatArea) {
      addedIndexPaths, removedIndexPaths, error in
      
      if let error = error {
        log.error("Failed to update the collection view index paths because of the error. The error description: \(error.localizedDescription)")
        return
      }
      
      for indexPath in removedIndexPaths {
        if indexPath.item >= 0 && indexPath.item < animationUrls.count {
          YYImageCache.sharedCache().removeImageForKey(animationUrls[indexPath.item].absoluteString, withType: .Memory)
          
          // Stop reading the file for the invisible cell.
          self.cancelHelper.outdatedFiles.insert(animationUrls[indexPath.item].absoluteString)
          
          // Force memory clean-up for the invisible cell.
          autoreleasepool {
            if let cell = self.savedAnimationsCollectionView.cellForItemAtIndexPath(indexPath) as? GFMainScreenCell, let imageView = cell.imageView {
              imageView.image = nil
            }
          }
        }
      }
      
      for indexPath in addedIndexPaths {
        if indexPath.item >= 0 && indexPath.item < animationUrls.count {
          // Allow disk-reading operation for the new visible cell.
          self.cancelHelper.outdatedFiles.remove(animationUrls[indexPath.item].absoluteString)
          
          PHCachingImageManager.sh_requestAnimationFromCache(self.cacheManager, forUrl: animationUrls[indexPath.item], cancelHelper: self.cancelHelper, resultHandler: nil)
        }
      }
      
      self.previousPreheatArea = self.savedAnimationsCollectionView.sh_preheatArea
    }
  }
  
  /// Clears the preheat area and cached in memory animations.
  ///
  /// - parameter excludedURLs: Determines the URLs which won't be removed from the memory cache.
  func resetCachedAnimations(withExcludedURLs excludedURLs: Set<NSURL>) {
    previousPreheatArea = CGRectZero

    guard let unwrappedAnimationUrls = animationUrls else {
      log.verbose("The memory cache will be completely cleared.")
      YYImageCache.sharedCache().memoryCache.removeAllObjects()
      return
    }
    
    for url in unwrappedAnimationUrls {
      if !excludedURLs.contains(url) {
        YYImageCache.sharedCache().removeImageForKey(url.absoluteString, withType: .Memory)
      }
    }
  }
  
  /// Forces all currently in-proccess disk related operations to stop and clears all the visible collection view cells.
  func forceMemoryCleanup() {
    stopDiskReadOperations(withExcludedURLs: Set<NSURL>())
    clearVisibleCells()
  }
  
  /// Stops all currently in-progress disk read operations.
  ///
  /// - parameter excludedURLs: Determines the URLs for which the disk read tasks won't be stopped.
  func stopDiskReadOperations(withExcludedURLs excludedURLs: Set<NSURL>) {
    // Cancel all the current disk reading operations.
    if let animationUrls = animationUrls {
      for url in animationUrls {
        if !excludedURLs.contains(url) {
          cancelHelper.outdatedFiles.insert(url.absoluteString)
        }
      }
    }
  }
  
  
  /// Removes all currently visible cells and clears memory.
  func clearVisibleCells() {
    // Force clearing the memory taken by the visible cells.
    for cell in savedAnimationsCollectionView.visibleCells() {
      autoreleasepool {
        if let cell = cell as? GFMainScreenCell, let imageView = cell.imageView {
          imageView.image = nil
        }
      }
    }
  }
  
  /// Reloads the visible cells of the collection view. Disk read operations will be allowed only for these cells until the first scrolling.
  func reloadVisibleCells() {
    if let animationUrls = animationUrls {
      for indexPath in savedAnimationsCollectionView.indexPathsForVisibleItems() {
        cancelHelper.outdatedFiles.remove(animationUrls[indexPath.item].absoluteString)
      }
    }
    
    savedAnimationsCollectionView.reloadItemsAtIndexPaths(savedAnimationsCollectionView.indexPathsForVisibleItems())
  }
  
  /// Responds to the GFGifWasSavedToDocumentsNotification
  ///
  /// - parameter notification: The notification that was delivered to the observer.
  func imageWasSaved(notification: NSNotification) {
    dispatch_async(dispatch_get_main_queue()) {

      if let gifAsset = notification.userInfo?[kGFGifAssetInfoKey] as? GFGifAsset, let gifURL = gifAsset.url {
        
        self.updateCollectionView(withAddedImage: gifURL)
        self.scrollToIndexPath = NSIndexPath(forItem: 0, inSection: 0)
      } else {
        log.warning("Failed to retrieve the GIF URL from the info dictionary passed with GFGifWasSavedToDocumentsNotification.")
      }
    }
  }
  
  /// Responds to the GFGifWasRemovedFromDocumentsNotification
  ///
  /// - parameter notification: The notification that was delivered to the observer.
  func imageWasRemoved(notification: NSNotification) {
    dispatch_async(dispatch_get_main_queue()) {
      if let gifAsset = notification.userInfo?[kGFGifAssetInfoKey] as? GFGifAsset, let indexPath = gifAsset.collectionViewIndexPath {
        if let url = gifAsset.url {
          self.cancelHelper.outdatedFiles.insert(url.absoluteString)
        }
        self.updateCollectionView(withRemovedImageAtIndexPath: indexPath)
        self.scrollToIndexPath = NSIndexPath(forItem: (indexPath.item - 1) < 0 ? 0 : (indexPath.item - 1), inSection: 0)
      } else {
        log.warning("Failed to get the index path of the removed image. The collection view won't be updated.")
      }
    }
  }
  
  /// Responds to the GFDiskReadTaskFinishedNotification
  ///
  /// - parameter notification: The notification that was delivered to the observer.
  func diskReadTaskFinished(notification: NSNotification) {
    dispatch_async(dispatch_get_main_queue()) {
      if let requestInfo = notification.userInfo?[kGFGifRequestInfoKey] as? GFGifRequestInfo {
        if let error = requestInfo.error {
          log.error("Failed to retrieve the animation from cache. The error description: \(error.localizedDescription)")
          return
        }
        
        if requestInfo.state == .Finished {
          let gifURL = requestInfo.url
          for cell in self.savedAnimationsCollectionView.visibleCells() {
            if let mainScreenCell = cell as? GFMainScreenCell where mainScreenCell.uniqueIdentifier == gifURL.absoluteString && mainScreenCell.imageView?.image == nil {
              // IF the cell's id equals the GIF URL than it is waiting for the disk read task completion and therefore must be reloaded.
              if let indexPath = self.savedAnimationsCollectionView.indexPathForCell(mainScreenCell) {
                self.savedAnimationsCollectionView.reloadItemsAtIndexPaths([indexPath])
              }
              break
            }
          }
        }
      } else {
        log.warning("Failed to retrieve the GIF URL from the info dictionary passed with GFDiskReadTaskFinishedNotification.")
      }
    }
  }

  /// Updates the collection view with the new saved image.
  ///
  /// - paramter imageURL: The NSURL of the saved image.
  /// - paramter itemIndex: Index path of the added image in the collection view. By default the new image is inserted to the beginning.
  func updateCollectionView(withAddedImage imageURL: NSURL, atIndexPath indexPath: NSIndexPath = NSIndexPath(forItem: 0, inSection: 0)) {
    if animationUrls != nil {
      // Update collection view data source array.
      animationUrls!.insert(imageURL, atIndex: indexPath.item)
    } else {
      log.warning("Failed to obtain the array of animation URLs. The image won't be added to the collection view.")
      return
    }
    savedAnimationsCollectionView.reloadData()
  }

  /// Updates the collection view by removing image at index path.
  ///
  /// - parameter indexPath: Index path of the removed image in the collection view.
  func updateCollectionView(withRemovedImageAtIndexPath indexPath: NSIndexPath) {
    if animationUrls != nil {
      animationUrls!.removeAtIndex(indexPath.item)
    } else {
      log.warning("Failed to obtain the array of animation URLs. The image won't be removed from the collection view.")
      return
    }
    
    savedAnimationsCollectionView.reloadData()
  }
  
  // MARK: - AdMob
  /// Presents the banner view.
  func showBanner() {
    if bannerView.alpha == 0.0 {
      UIView.animateWithDuration(0.3, delay: 0, options: [.CurveEaseInOut], animations: {
        self.bannerView.alpha = 1.0
        }, completion: nil)
    }
  }
  
  /// Recalculates the AdMob banner size in accordance with the current device's orientation.
  func updateBannerSize() {
    bannerHeightConstraint.constant = GADBannerView.sh_bannerHeight()
    bannerView.layoutIfNeeded()
    
    if UIApplication.sharedApplication().statusBarOrientation == .Portrait ||
      UIApplication.sharedApplication().statusBarOrientation == .PortraitUpsideDown {
      if !isBannerInPortraitMode {
        bannerView.adSize = kGADAdSizeSmartBannerPortrait
        isBannerInPortraitMode = true
      }
    } else {
      if isBannerInPortraitMode {
        bannerView.adSize = kGADAdSizeSmartBannerLandscape
        isBannerInPortraitMode = false
      }
    }
    
    let request = GADRequest()
//    
//    /// Replace `kGADSimulatorID` with the ID of your Device.
//    request.testDevices = [kGADSimulatorID]
    bannerView.loadRequest(request)
  }
  
  /// Creates a new `GADInterstitial` object and performs the ad request.
  ///
  /// - note: To request another interstitial, you'll need to create a new `GADInterstitial` object by calling this method.
  func createAndLoadInterstitial() {
    interstitial = GADInterstitial(adUnitID: kInterstitialAdUnitId)
    let request = GADRequest()
    // Request test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made.
//    request.testDevices = [kGADSimulatorID]
    interstitial.delegate = self
    
    interstitial.loadRequest(request)
  }
}

// MARK: - CTAssetsPickerControllerDelegate
extension GFMainScreenViewController: CTAssetsPickerControllerDelegate {
  
  /// Tells the delegate that the user has finished picking photos or videos.
  func assetsPickerController(picker: CTAssetsPickerController, didFinishPickingAssets assets: [PHAsset]) {
    log.verbose("Finished picking assets.")
  
    let assetsNavigationController: UINavigationController!
    
    if assets[0].mediaType == .Video {
      previousSelectedItem = nil
      assetsNavigationController = storyboard?.instantiateViewControllerWithIdentifier(kGFExtractorNavigationControllerIdentifier) as! UINavigationController
      let extractorRootViewController = assetsNavigationController.viewControllers.first as! GFFramesExtractorViewController
      
      extractorRootViewController.asset = assets[0]
    } else {
      assetsNavigationController = storyboard?.instantiateViewControllerWithIdentifier(kGFEditorNavigationControllerIdentifier) as! UINavigationController
      let editorRootViewController = assetsNavigationController.viewControllers.first as! GFEditorViewController
      
      editorRootViewController.photosAssets = assets
    }

    sh_addFullscreenSnapshotOfView(picker.view)
    dismissViewControllerAnimated(false, completion: nil)
    presentViewController(assetsNavigationController, animated: true) {
      self.sh_restoreStateAfterSnapshotting()
    }
  }
  
  func assetsPickerController(picker: CTAssetsPickerController, didSelectAsset asset: PHAsset) {
    if asset.mediaType == .Video {
      if let unwrappedPreviousSelectedItem = previousSelectedItem where unwrappedPreviousSelectedItem.localIdentifier != asset.localIdentifier {
        picker.deselectAsset(unwrappedPreviousSelectedItem)
      }
      previousSelectedItem = asset
    }
  }
  
  func assetsPickerController(picker: CTAssetsPickerController, didDeselectAsset asset: PHAsset) {
    if asset.mediaType == .Video {
      previousSelectedItem = nil
    }
  }
}

// MARK: - UICollectionViewDelegate
extension GFMainScreenViewController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    let cell = collectionView.cellForItemAtIndexPath(indexPath) as! GFMainScreenCell
    if let gifURL = animationUrls?[indexPath.item], let imageView = cell.imageView as? YYAnimatedImageView {
      selectedGifAsset = GFGifAsset(animationWrapper: imageView.image as? YYImage, gifUrl: gifURL, collectionViewIndexPath: indexPath)
      selectedGifAsset?.transitionFrameIndex = cell.currentFrameIndex
      performSegueWithIdentifier(kAnimationPreviewSegueIdentifier, sender: self)
    } else {
      log.error("Failed to retrieve the properties of the selected animation in the collection view.")
    }
  }
}

// MARK: - UICollectionViewDataSource
extension GFMainScreenViewController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return animationUrls?.count ?? 0
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kSavedAnimationCellIdentifier, forIndexPath: indexPath) as! GFMainScreenCell

    guard let animationUrls = animationUrls else {
      log.warning("Failed to get animationUrls array")
      return cell
    }

    if let imageView = cell.imageView as? YYAnimatedImageView {
      imageView.autoPlayAnimatedImage = isAutoPlayEnabled
    }
    
    cell.uniqueIdentifier = animationUrls[indexPath.item].absoluteString
    
    // Chekc whether this cell must be configured as part of the transition from the preview controller.
    if animatedTransitionFrameIndex > -1 {
      if scrollToIndexPath?.item == indexPath.item {
        if let cellAnimatedImageView = cell.imageView as? YYAnimatedImageView {
          cellAnimatedImageView.image = animatedTransitionImage
          cellAnimatedImageView.currentAnimatedImageIndex = UInt(animatedTransitionFrameIndex)
          // Disable further update as the transition is finished.
          animatedTransitionFrameIndex = -1
          return cell
        }
      }
    }
    
    
    // Assign the placeholder image or start the activity indicator before loading begings.
    if !cell.activityIndicator.isAnimating() {
      cell.activityIndicator.startAnimating()
    }
    
    PHCachingImageManager.sh_requestAnimationFromCache(cacheManager, forUrl: animationUrls[indexPath.item], cancelHelper: cancelHelper) {
      [weak cell, weak self] image, url, state, error in
      dispatch_async(dispatch_get_main_queue()) {
        
        guard let weakSelf = self, let weakCell = cell else { return }
        
        if let error = error {
          log.error("Failed to configure the main screen cell. The error description: \(error.localizedDescription)")
          return
        }
        
        if state == .Cancelled {
          
          if weakCell.uniqueIdentifier == url.absoluteString {
            // Check whether the cancelled item is visible again (in case of fast scroll).
            let visibleIndexPaths = weakSelf.savedAnimationsCollectionView.indexPathsForVisibleItems()
            if visibleIndexPaths.contains(indexPath) {
              // Ensure that the cancelled item is reloaded.
              weakSelf.cancelHelper.outdatedFiles.remove(animationUrls[indexPath.item].absoluteString)
              weakSelf.savedAnimationsCollectionView.reloadItemsAtIndexPaths([indexPath])
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
          log.warning("Failed to obtain the main screen cell's image.")
          return
        }
        
        if url.absoluteString == weakCell.uniqueIdentifier {
          weakCell.activityIndicator.stopAnimating()
          weakCell.imageView?.image = unwrappedImage
        }
      }
    }
    
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GFMainScreenViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let currentItemSize = UICollectionViewFlowLayout.sh_itemSizeForTraitCollection(traitCollection, contentSize: collectionView.bounds.size, fixedSpacing: kGFMainScreenCollectionViewFixedSpacing, numberOfColumnsForCompactClass: 2, numberOfColumnsForRegularClass: 3)
    
    return currentItemSize
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
    return kGFMainScreenCollectionViewFixedSpacing
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    return kGFMainScreenCollectionViewFixedSpacing
  }
}

// MARK: - UIScrollViewDelegate
extension GFMainScreenViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(scrollView: UIScrollView) {
    // Update cached assets for the new visible area if needed.
    if(sh_isViewVisible()) {
      if(savedAnimationsCollectionView.sh_isNotablyScrolledFromPreheatArea(previousPreheatArea)) {
        updateCachedAnimations()
      }
    }
  }
}

// MARK: - GADBannerViewDelegate
extension GFMainScreenViewController: GADBannerViewDelegate {
  func adViewDidReceiveAd(bannerView: GADBannerView!) {
    showBanner()
  }
  
  func adView(bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
    log.warning("Failed to load the AdMob ad. The error description: \(error.localizedDescription)")
  }
  
  func adViewWillDismissScreen(bannerView: GADBannerView!) {
  }
  
  func adViewWillLeaveApplication(bannerView: GADBannerView!) {
  }
}

// MARK: - GADInterstitialDelegate
extension GFMainScreenViewController: GADInterstitialDelegate {
  func interstitialDidReceiveAd(ad: GADInterstitial!) {
  }
  
  func interstitialWillDismissScreen(ad: GADInterstitial!) {
    sh_restoreStateAfterSnapshotting()
  }
  
  func interstitialWillPresentScreen(ad: GADInterstitial!) {
    UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Slide)
  }
  
  func interstitialDidDismissScreen(ad: GADInterstitial!) {
    log.verbose("AdMob Interstitial was succsessfuly dismissed.")
  }
  
  func interstitialDidFailToPresentScreen(ad: GADInterstitial!) {
    log.warning("Failed to load interstitial ad.")
  }
}

// MARK: - UINavigationControllerDelegate
extension GFMainScreenViewController: UINavigationControllerDelegate {
  func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
    if !usesPinterestTransitionAnimation {
      /// The pinterest style animation was disabled when the GIF was removed. Now it should be enabled again.
      usesPinterestTransitionAnimation = true
      return nil
    }
    
    if let source = fromVC as? protocol<RMPZoomTransitionAnimating, RMPZoomTransitionDelegate>, let destination = toVC as? protocol<RMPZoomTransitionAnimating, RMPZoomTransitionDelegate> {
      let animator = RMPZoomTransitionAnimator()
      animator.goingForward = (operation == .Push)
      
      animator.sourceTransition = source
      animator.destinationTransition = destination
      
      return animator
    } else {
      return nil
    }
  }
}

// MARK: - RMPZoomTransitionAnimating
extension GFMainScreenViewController: RMPZoomTransitionAnimating {
  func transitionSourceImageView() -> UIImageView! {
    let imageView = UIImageView()
    var transitionIndex: UInt = 0
    if let animationIndex = selectedGifAsset?.transitionFrameIndex where animationIndex > -1 {
      transitionIndex = UInt(animationIndex)
    }
    imageView.image = selectedGifAsset?.animatedImage?.animatedImageFrameAtIndex(transitionIndex)
    imageView.clipsToBounds = true
    imageView.userInteractionEnabled = false
    
    if let indexPath = selectedGifAsset?.collectionViewIndexPath, let cell = savedAnimationsCollectionView.cellForItemAtIndexPath(indexPath) {
      imageView.frame = cell.convertRect(cell.bounds, toView: nil)
    }
    
    return imageView
  }
  
  func transitionSourceBackgroundColor() -> UIColor! {
    return savedAnimationsCollectionView.backgroundColor ?? UIColor.blackColor()
  }
  
  /// Provides frame of the selected cell in its superview coordinate system.
  func transitionDestinationImageViewFrame() -> CGRect {
    savedAnimationsCollectionView.collectionViewLayout.invalidateLayout()
    savedAnimationsCollectionView.layoutIfNeeded()
    
    if savedAnimationsCollectionView.numberOfItemsInSection(0) > 0 {
      if let scrollToIndexPath = scrollToIndexPath {
        savedAnimationsCollectionView.scrollToItemAtIndexPath(scrollToIndexPath, atScrollPosition: .CenteredVertically, animated: false)
        
        if let cell = savedAnimationsCollectionView.cellForItemAtIndexPath(scrollToIndexPath) {
          return cell.convertRect(cell.bounds, toView: nil)
        }
      }
    }
    return CGRectZero
  }
}

// MARK: - RMPZoomTransitionDelegate
extension GFMainScreenViewController: RMPZoomTransitionDelegate {
  func zoomTransitionAnimator(animator: RMPZoomTransitionAnimator!, didCompleteTransition didComplete: Bool, animatingSourceImageView imageView: UIImageView!) {
    // Called when the transition is finished.
  }
}