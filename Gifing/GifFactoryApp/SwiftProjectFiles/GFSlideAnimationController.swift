//
//  GFSlideAnimationController.swift
//  GifFactoryApp
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit
import Foundation

/// Custom transition animation controller that uses a slide style transition.
class GFSlideAnimationController: GFAbstractAnimationController {
  /// The presented view that is used in the transition.
  var toView: UIView?
  
  override func completionHandler(success: Bool) {
    isCompleted = true
    
    // After a failed presentation or successful dismissal, remove the view.
    if !reverse && !success || reverse && success {
      toView?.removeFromSuperview()
    }
  }

  override func animateTransition(transitionContext: UIViewControllerContextTransitioning, fromVC: UIViewController?, toVC: UIViewController?, fromView: UIView?, toView: UIView?) {
    isCompleted = false
    self.toView = nil
    
    /// Cancels transition in case of errors.
    func cleanup() {
      transitionContext.completeTransition(false)
      isCompleted = true
    }
    
    // Errors checking.
    guard let containerView = transitionContext.containerView() else { cleanup(); return }
    
    let containerFrame = containerView.frame
    var toViewStartFrame: CGRect?
    var toViewFinalFrame: CGRect?
    
    if let toVC = toVC {
      toViewStartFrame = transitionContext.initialFrameForViewController(toVC)
      toViewFinalFrame = transitionContext.finalFrameForViewController(toVC)
    }
    
    var fromViewFinalFrame: CGRect?
    if let fromVC = fromVC {
      fromViewFinalFrame = transitionContext.finalFrameForViewController(fromVC)
    }
    
    // Set up the animation parameters.
    if reverse == false {
      // Modify the frame of the presented view so that it starts
      // offscreen at the left corner of the container
      toViewStartFrame?.origin.x = -containerFrame.size.width
    } else {
      // Modify the frame of the dismissed view so it ends in
      // the left corner of the container view.
      fromViewFinalFrame?.origin.x = -containerFrame.size.width
    }
    
    if let toView = toView {
      containerView.addSubview(toView)
      self.toView = toView
      if let toViewStartFrame = toViewStartFrame {
        toView.frame = toViewStartFrame
      }
    }
    
    // Animate using the animator's own duration value.
    UIView.animateWithDuration(transitionDuration(transitionContext),
      delay: 0,
      options: .CurveEaseOut,
      animations: {
      if self.reverse == false {
        // Move the presented view into position.
        if let toViewFinalFrame = toViewFinalFrame {
          toView?.frame = toViewFinalFrame
        }
      } else {
        // Move the dismissed view offscreen.
        if let fromViewFinalFrame = fromViewFinalFrame{
          fromView?.frame = fromViewFinalFrame
        }
      }
      } , completion: {
        
        finished in

        // Call completion handler only if it wasn't called by the interaction controller.
        if self.isCompleted == false {
          self.completionHandler(!transitionContext.transitionWasCancelled())
          transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    })
  }
}
