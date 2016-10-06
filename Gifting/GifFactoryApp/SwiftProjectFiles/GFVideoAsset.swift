//
//  GFVideoAsset.swift
//  GifFactoryApp
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit
import AVFoundation

/**
 *  The class that represents the video asset properties which can be used to extract frames according to the start and end times and generate GIF consisting of them.
 */
class GFVideoAsset {
  /// The asset that represents the video file.
  var asset: AVAsset
  /// The time in seconds the frames extraction will be started from.
  var startTime: CGFloat
  /// The time in seconds the frames extraction will be finished at.
  var endTime: CGFloat
  
  init(asset: AVAsset, withStartTime startTime: CGFloat, andEndTime endTime: CGFloat) {
    self.asset = asset
    self.startTime = startTime
    self.endTime = endTime
  }
}
