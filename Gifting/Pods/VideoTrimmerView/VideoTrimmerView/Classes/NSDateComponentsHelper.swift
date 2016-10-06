//
//  NSDateComponentsHelper.swift
//  Pods
//
//  Created by Storix on 6/23/16.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit

/// The NSDateComponentsFormatter that is used to set time labels text.
private let formatter: NSDateComponentsFormatter = {
  let formatter = NSDateComponentsFormatter()
  formatter.unitsStyle = .Positional
  formatter.zeroFormattingBehavior = .None
  formatter.allowedUnits = [.Hour, .Minute, .Second]
  return formatter
}()

extension NSDateComponents {
  /// Returns the `NSDateComponentsFormatter` configured for trimmer times formatting.
  class func getTrimmerTimesFormatter() -> NSDateComponentsFormatter {
    return formatter
  }
}