//
//  RMPZoomTransitionHelper.swift
//  GifFactoryApp
//
//  Created by Storix on 7/14/16.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit

struct RMPZoomTransitionHelper {
  /// Calculates the new size from the given size that better fits the avaiable size using aspect fit mode.
  ///
  /// - parameter size: the size that should be recalculated to fit the available size.
  /// - parameter availableSize: the size that is available in the destination controller for the image view. It is required to make the correct RMPZoomTransition.
  /// - returns: Calculated image view frame size.
  static func fitSize(size: CGSize, toAvailableSize availableSize: CGSize) -> CGSize {
    let widthScale = availableSize.width / size.width
    let heightScale = availableSize.height / size.height
    let zoomScaleAspectFit = min(widthScale, heightScale)
    
    var fittedSize = CGSizeZero
    fittedSize.width = size.width * zoomScaleAspectFit
    fittedSize.height = size.height * zoomScaleAspectFit
    return fittedSize
  }
}
