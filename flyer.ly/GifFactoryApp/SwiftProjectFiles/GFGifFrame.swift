//
//  GFGifFrame.swift
//  GifFactoryApp
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit
import Photos

/// The enumeration that represents the gif frame source type, i.d. the persistent storage from which it can be loaded.
enum GFGifFrameSourceType {
  /// Specifies that the current gif frame can be loaded from the Photos Library.
  case PhotosAsset
  /// Specifies that the current gif frame can be loaded from the cache of video frames.
  case VideoAsset
  /// Indicates that the gif frame source type cannot be determined.
  case Undefined
}

/**
 *  The class that represents the gif frame properties which are used to retrieve the underlying image that will be used during GIF generation. The gif frame is also used during the image thumbnail loading.
 */
class GFGifFrame {
  /// Represents the image from the Photos Library.
  var photosAsset: PHAsset?
  /// The key that is used to identify the image in the thumbnails cache.
  var thumbnailCacheKey: String?
  /// The key that is used to identify the image in the cache with the full-sized images.
  var fullsizedImageCachekey: String?
  /// Identifies the current gif frame source type.
  var sourceType: GFGifFrameSourceType {
    if thumbnailCacheKey != nil && fullsizedImageCachekey != nil {
      return .VideoAsset
    } else if photosAsset != nil {
      return .PhotosAsset
    } else {
      return .Undefined
    }
  }
}