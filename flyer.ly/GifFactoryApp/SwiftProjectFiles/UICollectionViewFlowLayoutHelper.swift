//
//  UICollectionViewFlowLayoutHelper.swift
//  GifFactoryApp
//
//  DESCRIPTION:
//      Swift helper (SH) UICollectionViewFlowLayout extension.
//
//  Created by Storix on 2/20/16.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit

extension UICollectionViewFlowLayout {
  
  /**
  *  Returns collection view cell size according with the interface environment.
  *
  *  - parameter traitCollection: A trait collection that describes the iOS interface environment, including traits such as horizontal and vertical size class, display scale, and user interface idiom.
  *  - parameter contentSize: The collection view bounds.
  *  - parameter fixedSpacing: Spacing (in pixels) that is used between items and lines. The same value must be used as a return value for `minimumInteritemSpacingForSectionAtIndex` and `minimumLineSpacingForSectionAtIndex` collection layout methods.
  *  - parameter numberOfColumnsForCompactClass: The number of collection view cells for the Compact Size Class.
  *  - parameter numberOfColumnsForRegularClass: The number of collection view cells for the Regular Size Class
  *
  */
  public class func sh_itemSizeForTraitCollection(traitCollection: UITraitCollection, contentSize: CGSize, fixedSpacing: CGFloat, numberOfColumnsForCompactClass: Int = 4, numberOfColumnsForRegularClass: Int = 6) -> CGSize {
    var numberOfColumns: Int = 0
   
    // Determine number of columns with cells for the current size class
    switch traitCollection.userInterfaceIdiom {
    case .Pad:
      numberOfColumns = numberOfColumnsForRegularClass
    case .Phone:
      if traitCollection.horizontalSizeClass == .Regular {
        numberOfColumns = numberOfColumnsForRegularClass
      } else {
        numberOfColumns = numberOfColumnsForCompactClass
      }
    default:
      numberOfColumns = numberOfColumnsForCompactClass
    }
    
    // Calculate total length which is occupied by the spaces between the cells
    let spaces = fixedSpacing * (CGFloat(numberOfColumns) - 1)
    
    // Calculate cell length
    let length = floor((contentSize.width - spaces) / CGFloat(numberOfColumns))
    return CGSizeMake(length, length)
  }
}