//
//  GFMainScreenCell.swift
//  GifFactoryApp
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit
import YYImage

/// Global context variable that is used to observe animated image view state.
private var mainCellContext = 0

/**
 *  Custom collection view cell that represents the GIF file saved in the Documents directory.
 */
class GFMainScreenCell: GFCollectionViewBaseCell {
  /// Returns the currently dispalyed GIF frame.
  var currentFrameIndex = 0
  
  /// Indicates whether the observer of the animated image view was set.
  private var didSetObserver = false
  
  @IBOutlet var activityIndicator: UIActivityIndicatorView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    if !didSetObserver {
      if let animatedImageView = imageView as? YYAnimatedImageView {
        animatedImageView.addObserver(self, forKeyPath: "currentAnimatedImageIndex", options: .New, context: &mainCellContext)
        didSetObserver = true
      }
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    activityIndicator.stopAnimating()
    imageView?.image = nil
  }
  
  override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
    dispatch_async(dispatch_get_main_queue()) {
      if context == &mainCellContext {
        if let newAnimationIndex = change?[NSKeyValueChangeNewKey] as? Int {
          self.currentFrameIndex = newAnimationIndex
        }
      } else {
        super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
      }
    }

  }
  
  deinit {
    if didSetObserver {
      if let animatedImageView = imageView as? YYAnimatedImageView {
        animatedImageView.removeObserver(self, forKeyPath: "currentAnimatedImageIndex", context: &mainCellContext)
      }
    }
  }
}