//
//  ImmediatePanGestureRecognizer.swift
//  Pods
//
//  Created by Storix on 6/18/16.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass


/**
    The subclass of the `UIPanGestureRecognizer` that makes it possible to recognize the drag gesture immidiatly after the first touch.
 */
class ImmediatePanGestureRecognizer: UIPanGestureRecognizer {
  /// The distance (in points) the finger must move to set recognizer's `Began` state.
  var distanceToDelayDragEvent: CGFloat = 0.0
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
    if state != .Possible {
      // Starting touch objects have already been recognized.
      return
    }
    
    super.touchesBegan(touches, withEvent: event)
    if  translationInView(view).x >= distanceToDelayDragEvent {
      state = .Began
    }
  }
}
