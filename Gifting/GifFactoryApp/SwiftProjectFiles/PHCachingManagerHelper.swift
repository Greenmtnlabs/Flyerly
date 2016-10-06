//
//  PHCachingManagerHelper.swift
//  GifFactoryApp
//
//  DESCRIPTION:
//      Swift helper (SH) extension that provides new type methods for PHCachingImageManager.
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit
import Photos
import YYWebImage

/// The enumeration that represents the possible states of the animation request from the cache.
enum GFCacheRequestState {
  /// Indicates that the animation request was cancelled.
  case Cancelled
  /// Indicates that the animation is currently being read from the disk.
  case Reading
  /// Indicates that the current request was finished. Check the error object to determine whether it was finished successfuly.
  case Finished
}

/// A string containing the error domain that defines the errors context for the `RequestImagesFromCache` method.
private let kRequestAnimationFromCacheErrorDomain = "com.phcachingmanagerhelper.RequestAnimationFromCache"
/// A string containing the error domain that defines the errors context for the `RequestImagesFromCache` method.
private let kRequestImagesFromCacheErrorDomain = "com.phcachingmanagerhelper.RequestImagesFromCache"
/// A string containing the error domain that defines the errors context for the `sh_requestUpdatedIndexPathsForCollectionView` method.
private let kRequestIndexPathsErrorDomain = "com.phcachingmanagerhelper.RequestIndexPaths"
/// A string containing the error domain that defines the errors context for the `sh_requestUpdatedIndexPathsForCollectionView` method.
private let kIncrementallyReadFileErrorDomain = "com.phcachingmanagerhelper.IncrementallyReadFile"
/// The set of file URLs representing the GIF animations which are currently being read from the disk.
private var currentReadingFromDiskURLs = Set<String>()

extension PHCachingImageManager {
  /**
   *  Resets and cancels all image caching preparation that is currently in progress.
   *
   *  - parameter previousPreheatRect: The preheat rectangle to compare visible area against in the future. The preheat window is twice the height of the visible rectangle.
   *
   */
  func resetCachedAssets(inout previousPreheatRect: CGRect) -> Void {
    stopCachingImagesForAllAssets()
    previousPreheatRect = CGRectZero
  }
  
  /**
   *  Asynchronously starts reading the files with the animation data from the disk or immediatly returns the data if it is already in the memory cache.
   *
   *  - parameter cacheManager: The object that handles the cache management.
   *  - parameter animationURL: The animation file URL the data must be read from. This URL is also used as the animation key in the cache.
   *  - parameter cancelHelper: The object that provides means to check whether the current file is not needed anymore and the reading task can be cancelled.
   *  - parameter resultHandler: The closure that is called when the reading task is finished, cancelled or the error has occurred. It can also be called with the `Reading` state parameter when another collection view cell requested animation from the same file but the current task was not finished.
   *
   *  - note: When the disk-reading task is finished the notification `GFDiskReadTaskFinishedNotification` instead of calling the `resultHanlder`. The next time the image will be requested it will be returned from the memory cache in `resultHandler` as usual.
   *
   *  Animation request error codes description.
   *
   *    - 1101 - Failed to Load Animation From Memory.
   *    - 1102 - Failed to Load Animation From Disk.
   *
   */
  class func sh_requestAnimationFromCache(cacheManager: YYImageCache, forUrl animationURL: NSURL, cancelHelper: GFCancelOperationsHelper, resultHandler: ((image: UIImage?, url: NSURL, state: GFCacheRequestState, error: NSError?) -> Void)?) {
    let animationKey = animationURL.absoluteString
    if animationKey.characters.count <= 0 {
      log.warning("Failed to obtain the animation url.")
      return
    }
    
    // Check whether the animation is currently in memory.
    if cacheManager.containsImageForKey(animationKey, withType: .Memory) {
      cacheManager.getImageForKey(animationKey, withType: .Memory) {
        image, type in

        if let image = image {
          resultHandler?(image: image, url: animationURL, state: .Finished, error: nil)
        } else {
          let requestError = NSError(domain: kRequestAnimationFromCacheErrorDomain, code: 1101, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Failed to Load Animation From Memory", comment: "Description of the error that occurs when the animation cannot be loaded from the device's memory.")])
          resultHandler?(image: nil, url: animationURL, state: .Finished, error: requestError)
        }
      }
    } else {
      // Check whether the given file is already being read.
      if currentReadingFromDiskURLs.contains(animationKey) {
        resultHandler?(image: nil, url: animationURL, state: .Reading, error: nil)
        return
      }
      
      currentReadingFromDiskURLs.insert(animationKey)
      
      incrementallyReadFile(animationURL, cancelHelper: cancelHelper) {
        data, state, error in
        dispatch_async(dispatch_get_main_queue()) {
          currentReadingFromDiskURLs.remove(animationKey)

          if let error = error {
            resultHandler?(image: nil, url: animationURL, state: state, error: error)
          } else if state == .Cancelled {
            resultHandler?(image: nil, url: animationURL, state: state, error: nil)
          } else if let animationData = data, let image = YYImage(data: animationData) {
            // At this point the GIF file has been successfuly read.
            // Insteas of calling the resultHandler the notification is posted. This way if the other collection view needs the same animation data it can be registered to recieve this notification.
            let requestInfo = GFGifRequestInfo(image: image, url: animationURL, state: state, error: error)
            let info = [kGFGifRequestInfoKey: requestInfo]
            NSNotificationCenter.defaultCenter().postNotificationName(GFDiskReadTaskFinishedNotification, object: nil, userInfo: info)
            cacheManager.setImage(image, imageData: nil, forKey: animationKey, withType: .Memory)
          } else {
            let requestError = NSError(domain: kRequestImagesFromCacheErrorDomain, code: 1102, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Failed to Load Animation From Disk", comment: "Description of the error that occurs when the animation cannot be loaded from the disk cache.")])
            resultHandler?(image: nil, url: animationURL, state: .Finished, error: requestError)
          }
        }
      }
    }
  }
  
  /**
   *  Prepares the image thumbnail to display in the collection view. Calls the result handler (if it is not `nil`) immediately if the image per the provided key is located in the memory cache. Otherwise loads the image from the disk cache, configures it according to the given target size and content mode, puts it into the memory cache and finally calls the result handler with the loaded image.
   *
   *  - parameter cacheManager: The object that handles the cache management.
   *  - parameter gifFrame: The gif frame object that contains the keys that indentify the image in the cache.
   *  - parameter targetSize: The size (in pixels) the requested image must be resized to.
   *  - parameter contentMode: Determines how a view adjusts its content when it is being resized.
   *  - parameter resultHandler: The closure that is called when the image has been prepared for displaying in the collection view or when the error occurred.
   *
   *  Image request error codes description.
   *
   *    - 901 - Failed to Load Image From Memory.
   *    - 902 - Failed to Load Image From Disk.
   *    - 910 - Failed to Resize Image.
   *
   */
  class func sh_requestThumbnailFromCache(cacheManager: YYImageCache, forGifFrame gifFrame: GFGifFrame, targetSize: CGSize, contentMode: UIViewContentMode, resultHandler: ((image: UIImage?, error: NSError?) -> Void)?) {
    guard let thumbKey = gifFrame.thumbnailCacheKey, let fullSizeKey = gifFrame.fullsizedImageCachekey else {
      log.warning("The image request cannot be completed because the provided gif frame is incorrect.")
      return
    }
    
    // Check whether the image is currently in memory.
    if cacheManager.containsImageForKey(thumbKey, withType: .Memory) {
      cacheManager.getImageForKey(thumbKey, withType: .Memory) {
        image, type in
        
        if let image = image {
          resultHandler?(image: image, error: nil)
        } else {
          let requestError = NSError(domain: kRequestImagesFromCacheErrorDomain, code: 901, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Failed to Load Image From Memory", comment: "Description of the error that occurs when the image cannot be loaded from the device's memory.")])
          resultHandler?(image: nil, error: requestError)
        }
      }
    } else {
      // Load the image from disk.
      cacheManager.getImageForKey(fullSizeKey, withType: .Disk) {
        image, type in
        
        if let image = image {
          
          dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) {
            // Prepare the image in accordance with the given target size and content mode.
            let thumb = image.yy_imageByResizeToSize(targetSize, contentMode: contentMode)
            
            dispatch_async(dispatch_get_main_queue()) {
              
              if let thumb = thumb {
                // Save the thumbnail in the memory.
                cacheManager.setImage(thumb, imageData: nil, forKey: thumbKey, withType: .Memory)
                // Send the resulting image to the calling method.
                resultHandler?(image: thumb, error: nil)
                
                // Clear memory cache from the loaded full-size image.
                cacheManager.memoryCache.removeObjectForKey(fullSizeKey)
              } else {
                let requestError = NSError(domain: kRequestImagesFromCacheErrorDomain, code: 910, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Failed to Resize Image", comment: "Description of the error that occurs when the image cannot be resized in accordance with the given target size and content mode.")])
                resultHandler?(image: nil, error: requestError)
              }
            }
          }
        } else {
          let requestError = NSError(domain: kRequestImagesFromCacheErrorDomain, code: 902, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Failed to Load Image From Disk", comment: "Description of the error that occurs when the image cannot be loaded from the disk cache.")])
          resultHandler?(image: nil, error: requestError)
        }
      }
    }
  }
  
  /**
   *  Requests index paths for the assets which reside in the previous and updated areas accordingly.
   *
   *  - parameter collectionView: UICollectionView instance that contains cached assets.
   *  - parameter resultHandler: A closure to be called when index paths are retrieved.
   *
   *    The closure takes the following parameters:
   *
   *    - addedIndexPaths: Index paths of the assets in the new visible area.
   *    - removedIndexPaths: Index paths of the assets in the previous preheat area.
   *    - error: NSError object that holds the details about failed request.
   *
   *  Image request error codes description.
   *
   *    - 750 - Failed to retrieve index paths for elements in removed rect.
   *    - 751 - Failed to retrieve index paths for elements in added rect.
   *
   */
  class func sh_requestUpdatedIndexPathsForCollectionView(collectionView: UICollectionView, withPreviousPreheatArea previousPreheatArea: CGRect, resultHandler: (addedIndexPaths: [NSIndexPath], removedIndexPaths: [NSIndexPath], error: NSError?) -> Void) -> Void {
    
    // Indicates whether the error occurred during requesting the updated index paths in the collection view.
    var didRequestIndexPathsErrorOccur = false
    
    var addedIndexPaths = [NSIndexPath]()
    var removedIndexPaths = [NSIndexPath]()
    var requestError: NSError?
    
    computeDifferenceBetweenRect(previousPreheatArea, andRect: collectionView.sh_preheatArea, removedAssetsHandler: {
      removedRect in
      
      if !didRequestIndexPathsErrorOccur {
        let indexPaths = collectionView.sh_indexPathsForElementsInRect(removedRect)
        if let indexPaths = indexPaths {
          removedIndexPaths += indexPaths
        } else {
          let removedIndexPathsError: NSError = NSError(domain: kRequestIndexPathsErrorDomain, code: 750, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Failed to retrieve index paths for elements in removed rect.", comment: "Description of the error that occurs when index paths of the previously cached collection view cells cannot be retrieved.")])
          requestError = removedIndexPathsError
          didRequestIndexPathsErrorOccur = true
        }
       }
      }, addedAssetsHandler: {
        (addedRect) -> Void in

        if !didRequestIndexPathsErrorOccur {
          let indexPaths = collectionView.sh_indexPathsForElementsInRect(addedRect)
          if let indexPaths = indexPaths {
            addedIndexPaths += indexPaths
          } else {
            let addedIndexPathsError: NSError = NSError(domain: kRequestIndexPathsErrorDomain, code: 751, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Failed to retrieve index paths for elements in added rect.", comment: "Description of the error that occurs when index paths of the currently visible collection view cells cannot be retrieved.")])
            requestError = addedIndexPathsError
            didRequestIndexPathsErrorOccur = true
          }
        }
    })
    
    resultHandler(addedIndexPaths: addedIndexPaths, removedIndexPaths: removedIndexPaths, error: requestError)
  }
  
  /**
   *  Computes the difference between the given areas to determine what assets should be added to or removed from caching.
   *
   *  - parameters:
   *    - oldRect: Area that was previously used for caching.
   *    - newRect: Area retrieved after scrolling.
   *    - removedAssetsHandler: A closure to be called when the area containing the assets removed from caching is found.
   *    - addedAssetsHandler: A closure to be called when the area containing the assets added to caching is found.
   *
   * - note: It works for vertically scrolled layout only.
   *
   */
  private static func computeDifferenceBetweenRect(oldRect: CGRect, andRect newRect: CGRect, removedAssetsHandler: (removedRect: CGRect) -> Void, addedAssetsHandler: (addedRect: CGRect) -> Void) -> Void {
    if (CGRectIntersectsRect(newRect, oldRect)) {
      let oldMaxY: CGFloat = CGRectGetMaxY(oldRect)
      let oldMinY: CGFloat = CGRectGetMinY(oldRect)
      let newMaxY: CGFloat = CGRectGetMaxY(newRect)
      let newMinY: CGFloat = CGRectGetMinY(newRect)

      if (newMaxY > oldMaxY) {
        let rectToAdd: CGRect = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY))
        addedAssetsHandler(addedRect: rectToAdd)
      }

      if (oldMinY > newMinY) {
        let rectToAdd: CGRect = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
        addedAssetsHandler(addedRect: rectToAdd)
      }
      
      if (newMaxY < oldMaxY) {
        let rectToRemove: CGRect = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY))
        removedAssetsHandler(removedRect: rectToRemove)
      }
      
      if (oldMinY < newMinY) {
        let rectToRemove: CGRect = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY))
        removedAssetsHandler(removedRect: rectToRemove)
      }
    } else {
      addedAssetsHandler(addedRect: newRect);
      removedAssetsHandler(removedRect: oldRect);
    }
  }
  
  /**
   *  Incrementally reads the animation data from the file in accordance with the given URL. The array with the files which should be removed from the disk-reading task is checked each iteration (when the current bulk of data has been completely read). If the current file was marked for removing the data in the result handler would be `nil`.
   *
   *  - parameter fileURL: The file URL the animation data must be read from.
   *  - parameter cancelHelper: The helper object that allows to check whether the current file was marked for removing by means of the `outdatedFiles` property.
   *  - parameter resultHandler: A closure to be called when the data-reading task was finished. The `error` indicates whether the task was completed successfuly.
   *
   *  File reading error codes description.
   *
   *    - 1001 - Failed to retrieve GIF File Path.
   *    - 1002 - Failed to Obtain File Descriptor.
   *    - 1003 - Failed to Allocate Buffer.
   *
   */
  private static func incrementallyReadFile(fileURL: NSURL, cancelHelper: GFCancelOperationsHelper, resultHandler: ((data: NSData?, state: GFCacheRequestState, error: NSError?) -> Void)) {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) {
      guard let filePath = fileURL.path else {
        let error = NSError(domain: kIncrementallyReadFileErrorDomain, code: 1001, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Failed to retrieve GIF File Path", comment: "Description of the error that occurs when the GIF file path is incorrect.")])
        resultHandler(data: nil, state: .Finished, error: error)
        return
      }
      
      var fd: CInt?
      dispatch_sync(dispatch_get_main_queue()) {
        let isCancelled = cancelHelper.outdatedFiles.contains(fileURL.absoluteString)
        if !isCancelled {
          fd = open(filePath, O_RDONLY)
        }
      }
      
      guard let fileDescriptor = fd else {
        resultHandler(data: nil, state: .Cancelled, error: nil)
        return
      }
      
      if fileDescriptor == -1 {
        let error = NSError(domain: kIncrementallyReadFileErrorDomain, code: 1002, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Failed to Obtain File Descriptor", comment: "Description of the error that occurs when the animation file descriptor cannot be obtained.")])
        resultHandler(data: nil, state: .Finished, error: error)
        return
      }
      
      
      let allocationError = NSError(domain: kIncrementallyReadFileErrorDomain, code: 1003, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Failed to Allocate Buffer", comment: "Description of the error that occurs when the memory is not available for the new buffer.")])
      
      
      // Read a file by 512 bytes at a time.
      let kIncrementalFileOffset = 512
      let fileSize = lseek(fileDescriptor, 0, SEEK_END)

      // Move the file pointer to the beginning of file.
      lseek(fileDescriptor, 0, SEEK_SET)
      
      let resultingData = NSMutableData()
      
      while lseek(fileDescriptor, 0, SEEK_CUR) < fileSize {
        var shouldStopReading = false
        
        dispatch_sync(dispatch_get_main_queue()) {
          shouldStopReading = cancelHelper.outdatedFiles.contains(fileURL.absoluteString)
        }
        
        if shouldStopReading {
          resultHandler(data: nil, state: .Cancelled, error: nil)
          close(fileDescriptor)
          return
        }
        
        autoreleasepool {
          guard let currentBulkOfData = NSMutableData(length: kIncrementalFileOffset) else {
            resultHandler(data: nil, state: .Finished, error: allocationError)
            close(fileDescriptor)
            return
          }
          
          let buffer = currentBulkOfData.mutableBytes
          let actualBytes = read(fileDescriptor, buffer, kIncrementalFileOffset)
          if actualBytes < kIncrementalFileOffset {
            currentBulkOfData.length = actualBytes
          }
          
          resultingData.appendData(currentBulkOfData)
        }
      }
      
      close(fileDescriptor)

      // The whole file was read.
      resultHandler(data: resultingData, state: .Finished, error: nil)
    }
  }
}