//
//  GFPlayerView.swift
//  GifFactoryApp
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit
import AVFoundation

/// A `UIView` subclass that is backed by an `AVPlayerLayer` layer.
class GFPlayerView: UIView {
  
  /// A computed property that allows to set an instance of AVPlayer to play a video asset.
  var player: AVPlayer? {
    get {
      return playerLayer.player
    }
    
    set {
      playerLayer.player = newValue
    }
  }
  
  /// A computed property that returns UIView's layer object with type casting to the AVPlayerLayer.
  var playerLayer: AVPlayerLayer {
    return layer as! AVPlayerLayer
  }
  
  override class func layerClass() -> AnyClass {
    return AVPlayerLayer.self
  }
}
