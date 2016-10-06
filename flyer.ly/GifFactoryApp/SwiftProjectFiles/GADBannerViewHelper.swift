//
//  GADBannerViewHelper.swift
//  GifFactoryApp
//
//  Created by Storix on 7/11/16.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit
import GoogleMobileAds

extension GADBannerView {
  /// Calculates banner height taking into account device's orientation.
  ///
  /// - returns: Height of the AdMob banner that is appropriate for the current screen.
  static func sh_bannerHeight() -> CGFloat {
    let currentHeight = UIScreen.mainScreen().bounds.height
    switch currentHeight {
    case 0...400:
      return 32
    case 401...720:
      return 50
    default:
      return 90
    }
  }
}