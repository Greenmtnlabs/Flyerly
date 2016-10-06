//
//  YYImageCacheHelper.swift
//  Pods
//
//  Created by Storix on 6/15/16.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit
import YYWebImage

/// A string containing the error domain that defines the error context for the `sh_getImageForKey` method.
private let kGetImageFromCacheErrorDomain = "com.yyimagecache.sh_getImageForKey"

/// A string containing the error domain that defines the error context for the `sh_getImageForKey` method.
private let kSetImageInCacheErrorDomain = "com.yyimagecache.sh_setImageForKey"

extension YYImageCache {
  class func createImageCacheManagerWithPath(path: String) -> YYImageCache {
    let errorHandler = { () -> YYImageCache in
      log.warning("Shared Image Cache will be used instead.")
      return YYImageCache.sharedCache()
    }
    
    guard path.characters.count > 0 else {
      log.error("Failed to create image cache manager because the given path is incorrect.")
      return errorHandler()
    }
    
    let cacheDir = try? NSFileManager.defaultManager().URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
    guard let unwrappedCacheDir = cacheDir else {
      log.error("Failed to obtain Caches Directory.")
      return errorHandler()
    }
    
    let customCacheUrl = unwrappedCacheDir.URLByAppendingPathComponent(path, isDirectory: true)
    guard let customCachePath = customCacheUrl.path else {
      log.error("Failed to construct the image cache path.")
      return errorHandler()
    }
    
    let cacheManager = YYImageCache(path: customCachePath)
    guard let unwrappedCacheManager = cacheManager else {
      log.error("Failed to initialize image cache manager.")
      return errorHandler()
    }
    
    return unwrappedCacheManager
  }
  
  /**
      Asynchronously loads the image from the cache for the given key.
   
      - parameter key: The string that identifies the image in the cache.
      - parameter resultHandler: The closure that is called when the image has been loaded from the cache.
   
      `resultHandler` parameters:
   
        * `image`: The image that was loaded from the cache.
        * `key`: The key the image was associated with.
        * `error`: The `NSError` object containing the error information.
   
      Error codes description:
   
        - 300 - Image Key is Incorrect.
        - 301 - Failed to Load Image From Memory.
        - 302 - Failed to Load Image From Disk.
    */
  func sh_getImageForKey(key: String, resultHandler:((image: UIImage?, key: String, error: NSError?) -> Void)?) {
    guard key.characters.count > 0 else {
      log.warning("The image key is incorrect.")
      let requestError = NSError(domain: kGetImageFromCacheErrorDomain, code: 300, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Image Key is Incorrect", comment: "Description of the error concerning the incorrect image key.")])
      resultHandler?(image: nil, key: key, error: requestError)
      return
    }
    
    // Check whether the image is in memory cache.
    if containsImageForKey(key, withType: .Memory) {
      getImageForKey(key, withType: .Memory) {
        image, type in
        
        if let image = image {
          resultHandler?(image: image, key: key, error: nil)
        } else {
          let requestError = NSError(domain: kGetImageFromCacheErrorDomain, code: 301, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Failed to Load Image From Memory", comment: "Description of the error that occurs when the timeline frame image cannot be loaded from the memory.")])
          resultHandler?(image: nil, key: key, error: requestError)
        }
      }
    } else {
      getImageForKey(key, withType: .Disk) {
        image, type in
        
        if let image = image {
          resultHandler?(image: image, key: key, error: nil)
        } else {
          let requestError = NSError(domain: kGetImageFromCacheErrorDomain, code: 302, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Failed to Load Image From Disk", comment: "Description of the error that occurs when the timeline frame image cannot be loaded from the disk.")])
          resultHandler?(image: nil, key: key, error: requestError)
        }
      }
    }
  }
  
  /**
     Asynchronously stores the image to the cache for the given key.
     
     - parameter image: The image that must be stored into the cache.
     - parameter key: The string that identifies the image in the cache.
     - parameter resultHandler: The closure that is called when the image has been loaded from the cache.
   
     `resultHandler` parameters:

      * `key`: The key the image was associated with.
      * `error`: The `NSError` object containing the error information.
     
     Error codes description.
     
      - 400 - Image Key is Incorrect.
      - 401 - Failed to Unwrap Image Data.
   */
  func sh_setImage(image: UIImage, forKey key: String, resultHandler:((key: String, error: NSError?) -> Void)?) {
    guard key.characters.count > 0 else {
      log.warning("The image key is incorrect.")
      let requestError = NSError(domain: kSetImageInCacheErrorDomain, code: 400, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Image Key is Incorrect", comment: "Description of the error concerning the incorrect image key.")])
      resultHandler?(key: key, error: requestError)
      return
    }
    
    // Store image in the memory cache.
    setImage(image, imageData: nil, forKey: key, withType: .Memory)

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) {
      let data = image.yy_imageDataRepresentation()
      guard let unwrappedImageData = data else {
        log.warning("The image key is incorrect.")
        let requestError = NSError(domain: kSetImageInCacheErrorDomain, code: 401, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Failed to Unwrap Image Data", comment: "Description of the error concerning the incorrect image data.")])
        resultHandler?(key: key, error: requestError)
        return
      }
      
      let archive = NSKeyedArchiver.archivedDataWithRootObject(NSNumber(double: Double(image.scale)))
      YYDiskCache.setExtendedData(archive, toObject: unwrappedImageData)
      self.diskCache.setObject(unwrappedImageData, forKey: key) {
        resultHandler?(key: key, error: nil)
      }
    }
  }
}