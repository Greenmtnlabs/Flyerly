//
//  GFAnimationPreviewDelegate.swift
//  GifFactoryApp
//
//  Created by Storix
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit

/// The protocol that provides methods for observing the animation state.
protocol GFAnimationPreviewDelegate: class {
  /**
   *  Tells the delegate that current animation position has been changed.
   *
   *  - parameter collectionViewCell: The collection view cell containing the image view that handles the animation presentation.
   *  - parameter index: The new index of the animation being played.
   *
   */
  func collectionViewCell(collectionViewCell: GFGifPreviewCell, didChangeAnimationPositionToIndex index: Int)
}