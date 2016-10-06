//
//  GFInsetsLabel.swift
//  GifFactoryApp
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit

/**
 *  Label that represents the animation frame number with the specified insets.
 */
class GFInsetsLabel: UILabel {
  /// Text inset from the top border.
  var topInset = CGFloat(5.0)
  /// Text inset from the bottom border.
  var bottomInset = CGFloat(5.0)
  /// Text inset from the left border.
  var leftInset = CGFloat(5.0)
  /// Text inset from the right border.
  var rightInset = CGFloat(5.0)
  
  override func drawTextInRect(rect: CGRect) {
    let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
  }
  
  /// This method must be overridden to handle correct intrinsic properties.
  override func intrinsicContentSize() -> CGSize {
    var intrinsicSuperViewContentSize = super.intrinsicContentSize()
    intrinsicSuperViewContentSize.height += topInset + bottomInset
    intrinsicSuperViewContentSize.width += leftInset + rightInset
    return intrinsicSuperViewContentSize
  }
}
