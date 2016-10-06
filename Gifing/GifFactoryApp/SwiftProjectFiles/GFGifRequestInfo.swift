//
//  GFGifRequestInfo.swift
//  GifFactoryApp
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit

/// The class that holds the information about the GIF request status.
class GFGifRequestInfo {
  /// The retrieved from the memory cache or read from the disk image. It is `nil` if the error occurred.
  var image: UIImage?
  /// The URL that represents the GIF location.
  var url: NSURL
  /// The status of the current request.
  var state: GFCacheRequestState
  /// This object is set in case of the error that occurred during the GIF request proceeding.
  var error: NSError?
  
  init(image: UIImage?, url: NSURL, state: GFCacheRequestState, error: NSError?) {
    self.image = image
    self.url = url
    self.state = state
    self.error = error
  }
}