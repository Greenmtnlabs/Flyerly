//
//  UIScreenHelper.swift
//  GifFactoryApp
//
//  DESCRIPTION:
//      Swift helper (SH) extension which adds UIScreen coordinate spaces manipulation capabilities.
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit

extension UIScreen {
  
  /**
   *  Converts from the default logical coordinate space into the device coordinate space of the main screen screen.
   *
   *  - parameter logicalSize: The default logical coordinate space that is measured using points.
   *  - returns: Size object in the device coordinate space.
   *
   */
  public class func sh_deviceSpaceSizeFromLogicalSize(logicalSize: CGSize) -> CGSize {
    let scale: CGFloat = UIScreen.mainScreen().scale
    
    return CGSizeMake(logicalSize.width * scale, logicalSize.height * scale)
  }
}

