//
//  GFCollectionViewBaseCell.swift
//  GifFactoryApp
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit

/**
 *  An abstract collection view cell.
 */
class GFCollectionViewBaseCell: UICollectionViewCell {
  
  /// UIImageView that is used to hold the main image of the current cell.
  var imageView: UIImageView?
  
  /// Convenience computed property that is used to set image property of the imageView and indicates that this image is a thumbnail.
  var thumbnailImage: UIImage? {
    didSet {
      imageView?.image = thumbnailImage
    }
  }
  
  /// Unique identifier that is used to identify the current reusable cell and set its properties correctly.
  var uniqueIdentifier: String?
  
  override func awakeFromNib() {
    for view in contentView.subviews {
      if view is UIImageView {
        // Use the first found UIImageView object to set imageView property instead of using IBOutlet.
        imageView = view as? UIImageView
        return
      }
    }
  }
}