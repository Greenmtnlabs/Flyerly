//
//  DoubleHelper.swift
//  GifFactoryApp
//
//  DESCRIPTION:
//      Swift helper (SH) Double type extension.
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import Foundation

extension Double {
  
  /**
   *  Formats Double value with the given decimal places. For example, if decimal places are 3 the Double value of 1.234567 would be formatted as 1.234.
   *
   *  - parameter decimalPlaces: Number of decimal places after decimal point.
   *  - returns: Formatted Double value.
   *
   */
  func sh_formatWithDecimalPlaces(decimalPlaces: Int) -> Double {
    let formattedString = NSString(format: "%.\(decimalPlaces)f", self) as String
    return Double(formattedString)!
  }
}