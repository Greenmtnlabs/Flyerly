//
//  GFGifAsset.swift
//  GifFactoryApp
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit
import YYImage

/// The class that represents the properties of the GIF animation
class GFGifAsset {
  /// If the GIF was successfuly saved to disk this property will hold the file path.
  var url: NSURL?
  /// If the GIF was selected in the collection view this property specifies the index path.
  var collectionViewIndexPath: NSIndexPath?
  /// If the underlying image contains more than one frame this property will hold the original animation data.
  var data: NSData? {
    return animationWrapper?.animatedImageData
  }
  /// If the GIF was created with just one frame this property will return the static image.
  var staticImage: UIImage? {
    return animationWrapper
  }
  /// Tries to cast the current animation wrapper to the animated image.
  var animatedImage: YYImage? {
    return animationWrapper
  }
  
  /// Specifies the GIF frame number.
  var frameCount: UInt {
    return animationWrapper?.animatedImageFrameCount() ?? 0
  }
  
  /// Determines the GIF frame index the animation was stopped at before the transition.
  var transitionFrameIndex: Int = -1
  
  /// High-level object that is used to display animated image data.
  private let animationWrapper: YYImage?
  
  init(animationWrapper: UIImage?, gifUrl: NSURL?, collectionViewIndexPath: NSIndexPath?) {
    self.animationWrapper = animationWrapper as? YYImage
    self.url = gifUrl
    self.collectionViewIndexPath = collectionViewIndexPath
  }
}