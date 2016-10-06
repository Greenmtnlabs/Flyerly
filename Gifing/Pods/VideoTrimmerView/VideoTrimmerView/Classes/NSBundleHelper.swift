//
//  NSBundleHelper.swift
//  Pods
//
//  Created by Storix on 6/16/16.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit


extension NSBundle {
  /**
      Creates the resource bundle for the current framework (`VideoTrimmerView`).
   
      - returns: The resource bundle that is used to hold all framework assets or `nil` in case of an error.
   */
  class func sh_resourceBundle() -> NSBundle? {
    guard let url = NSBundle(forClass: VideoTrimmerView.self).URLForResource("VideoTrimmerView", withExtension: "bundle") else {
      log.error("Failed to locate the resource bundle.")
      return nil
    }
    
    return NSBundle(URL: url)
  }
}