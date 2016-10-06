//
//  UIColorHelper.swift
//  GifFactoryApp
//
//  DESCRIPTION:
//      Swift helper (SH) extension for flexible and easy creation of UIColor instances.
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit

extension UIColor {
  
  /**
   *  Creates UIColor from pure RGB values.
   *
   *  - parameter pureRed: The red component of the color object, specified as a pure RGB value in a range from 0 to 255.
   *  - parameter pureGreen: The green component of the color object, specified as a pure RGB value in a range from 0 to 255.
   *  - parameter pureBlue: The blue component of the color object, specified as a pure RGB value in a range from 0 to 255.
   *  - parameter alpha: The opacity value of the color object. Default value is 1.0.
   */
  convenience init (pureRed red: Int, pureGreen green: Int, pureBlue blue: Int, alpha: CGFloat = 1.0) {
    // Pure RGB values must be divided by decimal 255
    // - note: Values are rounded to the nearest thousandth
    let redValue: CGFloat = round((CGFloat(red) / 255) * 1_000) / 1_000
    let greenValue: CGFloat = round((CGFloat(green) / 255) * 1_000) / 1_000
    let blueValue: CGFloat = round((CGFloat(blue) / 255) * 1_000) / 1_000
    
    self.init(red: redValue, green: greenValue, blue: blueValue, alpha: alpha)
  }
  
  /**
   *  Creates UIColor from the specified 6-digits hex string.
   *
   *  - parameter hex: Hex Code that represents required color.
   *
   *  - returns: UIColor object with color converted from the hex value.
   */
  public class func sh_colorFromHexCode(hex: String) -> UIColor {
    var trimmedString: String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
    
    if (trimmedString.hasPrefix("#")) {
      trimmedString = (trimmedString as NSString).substringFromIndex(1)
    } else if (trimmedString.hasPrefix("0X")) {
      trimmedString = (trimmedString as NSString).substringFromIndex(2)
    }
        
    if (trimmedString.characters.count != 6) {
      //invalid hex value
      return UIColor.grayColor()
    }
    
    let rString = (trimmedString as NSString).substringToIndex(2)
    let gString = ((trimmedString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
    let bString = ((trimmedString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)

    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    NSScanner(string: rString).scanHexInt(&r)
    NSScanner(string: gString).scanHexInt(&g)
    NSScanner(string: bString).scanHexInt(&b)
    
    return UIColor(pureRed: Int(r), pureGreen: Int(g), pureBlue: Int(b))
  }
}