//
//  PHImageManagerHelper.swift
//  GifFactoryApp
//
//  DESCRIPTION:
//      Swift helper (SH) PHImageManager extension.
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import Photos

extension PHImageManager {
  
  /**
   *  Cancels all the given requests.
   *
   *  - parameter requests: An array with requests identifiers you can use to cancel task before it completes.
   *
   */
  public class func sh_cancelImageRequests(inout requests: [PHImageRequestID]) -> Void {
    if requests.count > 0 {
      let imageManager = defaultManager()
      for requestId in requests {
        imageManager.cancelImageRequest(requestId)
      }
      
      // Clean-up array with requests 'cause they are now invalidated.
      requests.removeAll()
    }
  }

}