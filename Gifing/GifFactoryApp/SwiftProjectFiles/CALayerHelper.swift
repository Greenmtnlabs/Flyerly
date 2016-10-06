//
//  CALayerHelper.swift
//  GifFactoryApp
//
//  DESCRIPTION:
//      Swift helper (SH) CALayer extension.
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit


extension CALayer {
  /// Makes it possible to set UIView border properties from interface builder.
  var borderColorFromUIColor: UIColor {
    set {
      self.borderColor = newValue.CGColor
    }
    
    get {
      return UIColor(CGColor: self.borderColor!)
    }
  }
}