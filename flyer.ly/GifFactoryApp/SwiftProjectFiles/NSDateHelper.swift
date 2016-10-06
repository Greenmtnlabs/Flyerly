//
//  NSDateHelper.swift
//  GifFactoryApp
//
//  DESCRIPTION:
//      Swift helper (SH) NSDate extension.
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit

extension NSDate {
  
  /**
   *  Converts milliseconds to hundredths of a second.
   *
   *  - parameter milliseconds: Value in ms.
   *  - parameter precision: Determines the number of decimal places.
   *
   *  - returns: Converted value in hundredths of a second.
   *
   */
  public static func sh_millisecondsToHundredthsOfSecond(milliseconds: Double, withPrecision precision: Int = 3) -> Double {
    return (milliseconds / 10.0).sh_formatWithDecimalPlaces(precision)
  }
  
  /**
   *  Converts milliseconds to seconds.
   *
   *  - parametermilliseconds: Value in ms.
   *  - parameter precision: Determines the number of decimal places.
   *
   *  - returns: Converted value in seconds.
   *
   */
  public static func sh_millisecondsToSeconds(milliseconds: Double, withPrecision precision: Int = 3) -> Double {
    return (milliseconds / 1000.0).sh_formatWithDecimalPlaces(precision)
  }
  
  /**
   *  Converts seconds to milliseconds.
   *
   *  - parameter seconds: Value in seconds.
   *  - parameter precision: Determines the number of decimal places.
   *
   *  - returns: Converted value in milliseconds.
   *
   */
  public static func sh_secondsToMilliseconds(seconds: Double, withPrecision precision: Int = 3) -> Double {
    return (seconds * 1000.0).sh_formatWithDecimalPlaces(precision)
  }
}