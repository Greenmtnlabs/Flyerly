//
//  UICollectionViewHelper.swift
//  GifFactoryApp
//
//  DESCRIPTION:
//      Swift helper (SH) UICollectionView extension.
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit

extension UICollectionView {
  
  /**
   *  Returns YES if the collection view is showing an area that is significantly different to the last preheated area.
   *
   *  - parameter previousPreheatArea: The rectangle with assets that were previously cached by PHCachingImageManager.
   *
   */
  func sh_isNotablyScrolledFromPreheatArea(previousPreheatArea: CGRect) -> Bool {
    // delta represents the difference between the current visible area and previously preheated area
    let delta: CGFloat = abs(CGRectGetMidY(sh_preheatArea) - CGRectGetMidY(previousPreheatArea))

    return (delta > CGRectGetHeight(bounds) / 3.0)
  }
  
  /**
   *  Returns an array with NSIndexPath objects which represent items in the collection view.
   *
   *  - parameter rect: The rectangle that contains the target views.
   *  - returns: Array with index paths of the assets in rect.
   *
   */
  func sh_indexPathsForElementsInRect(rect: CGRect) -> [NSIndexPath]? {
    let allLayoutAttributes = collectionViewLayout.layoutAttributesForElementsInRect(rect)
    
    guard let unwrappedAllLayoutAttributes = allLayoutAttributes else {
      return nil
    }
    
    var indexPaths = [NSIndexPath]()
    for layoutAttributes in unwrappedAllLayoutAttributes {
      let indexPath = layoutAttributes.indexPath
      indexPaths.append(indexPath)
    }
    
    return indexPaths
  }
  
  /**
   *  Returns the size of the collection view cell in pixels.
   *
   *
   *  - parameter indexPaths: NSIndexPath object representing collection view cell.
   *  - returns: CGSize that can be used for requesting thumbnail image from photo library. CGSizeZero is returned if the cell size cannot be determined.
   *
   *  - note: Currently works for UICollectionViewDelegateFlowLayout delegate only.
   *
   */
  func sh_cellSizeAtIndexPath(indexPath: NSIndexPath) -> CGSize {
    if delegate is UICollectionViewDelegateFlowLayout {
      let flowLayoutDelegate = delegate as! UICollectionViewDelegateFlowLayout
      let logicalSize = flowLayoutDelegate.collectionView!(self, layout: self.collectionViewLayout, sizeForItemAtIndexPath: indexPath)
      return  UIScreen.sh_deviceSpaceSizeFromLogicalSize(logicalSize)

    } else {
      return CGSizeZero
    }
  }
  
  /**
   *  Current preheat area that is used to find the assets that require caching.
   */
  var sh_preheatArea: CGRect {
    // The preheat window is twice the height of the visible rect
    return CGRectInset(bounds, 0.0, -0.5 * CGRectGetHeight(bounds))
  }
}