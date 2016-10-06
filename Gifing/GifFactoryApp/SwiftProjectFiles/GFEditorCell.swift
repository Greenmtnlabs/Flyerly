//
//  GFEditorCell.swift
//  GifFactoryApp
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit

/**
 *  Custom collection view cell that represents the animation frame.
 */
class GFEditorCell: GFCollectionViewBaseCell {

  @IBOutlet var activityIndicator: UIActivityIndicatorView!

  @IBOutlet var frameNumberLabel: GFInsetsLabel!
  
  override func prepareForReuse() {
    super.prepareForReuse()
    activityIndicator.stopAnimating()
    imageView?.image = nil
  }
}
