//
//  YYImageCacheHelper.swift
//  GifFactoryApp
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit
import YYWebImage

/// A string containing the error domain that defines the error context for the `sh_getImageForKey` method.
private let kSetImageInCacheErrorDomain = "com.yyimagecache.sh_setImageForKey"

extension YYImageCache {
  /**
     Asynchronously stores the image to the cache for the given key.
     
     - parameter image: The image that must be stored into the cache.
     - parameter gifFrame: The object that describes the GIF properties.
     - parameter size: The size in points of the thumbnail that must be stored in the memory cache.If `nil` than the fullsized image will be stored in memory instead. If size is not specified the image won't be stored in memory.
     - parameter resultHandler: The closure that is called when the image has been loaded from the cache.
     
     `resultHandler` parameters:
     
     * `gifFrame`: The GIF frame that was requested to be stored in the cache.
     * `error`: The `NSError` object containing the error information.
     
     Error codes description.
     
     - 400 - Failed to Retrieve GIF Frame Cache Keys.
     - 401 - Failed to Resize Thumbnail.
     - 402 - Failed to Unwrap Image Data.
   */
  func sh_setImage(image: UIImage, forGifFrame gifFrame: GFGifFrame, createThumbnailInMemoryWithSize size: CGSize?, resultHandler:((gifFrame: GFGifFrame, error: NSError?) -> Void)?) {
    guard let fullSizeImageKey = gifFrame.fullsizedImageCachekey, let thumbKey = gifFrame.thumbnailCacheKey else {
      let error = NSError(domain: kSetImageInCacheErrorDomain, code: 400, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Failed to Retrieve GIF Frame Cache Keys", comment: "Description of the error that occurs when the GIF frame cache keys are not available.")])
      resultHandler?(gifFrame: gifFrame, error: error)
      return
    }
    
    var thumb: UIImage?
    if let size = size {
      thumb = image.yy_imageByResizeToSize(size, contentMode: .ScaleAspectFill)
      guard thumb != nil else {
        let error = NSError(domain: kSetImageInCacheErrorDomain, code: 401, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Failed to Resize Thumbnail", comment: "Description of the error that occurs when the GIF frame thumbnail cannot be resized.")])
        resultHandler?(gifFrame: gifFrame, error: error)
        return
      }
      
      // Store image in the memory cache.
      setImage(thumb ?? image, imageData: nil, forKey: thumbKey, withType: .Memory)
    }
    
    // Store image in the disk cache.
    let scale = image.scale
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) {
      autoreleasepool {
        let data = image.yy_imageDataRepresentation()
        
        guard let unwrappedImageData = data else {
          log.warning("The image key is incorrect.")
          let requestError = NSError(domain: kSetImageInCacheErrorDomain, code: 402, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Failed to Unwrap Image Data", comment: "Description of the error concerning the incorrect image data.")])
          resultHandler?(gifFrame: gifFrame, error: requestError)
          return
        }
        
        let archive = NSKeyedArchiver.archivedDataWithRootObject(NSNumber(double: Double(scale)))
        YYDiskCache.setExtendedData(archive, toObject: unwrappedImageData)
        self.diskCache.setObject(unwrappedImageData, forKey: fullSizeImageKey) {
          resultHandler?(gifFrame: gifFrame, error: nil)
        }
      }
    }
  }
}