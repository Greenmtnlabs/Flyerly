//
//  GFReversibleAnimationController.swift
//  GifFactoryApp
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit

private let kReversibleTransitionDuration = 0.5

/// The protocol that provides methods for the custom reversible transition animations.
protocol GFAnimationControllerReversible: class, UIViewControllerAnimatedTransitioning {
  /// The direction of the animation.
  var reverse: Bool { get set }
  /// Indicates whether the animation is completed.
  var isCompleted: Bool { get set }
  
  /**
   *  Convenience method subclusses must implement to provide the transition animation..
   *
   *
   *  - parameter transitionContext: The context object containing information about the transition.
   *  - parameter fromVC: The view controller that is visible at the beginning of the transition.
   *  - parameter toVC: The view controller that is visible at the end of a completed transition.
   *  - parameter fromView: The view that is shown at the beginning of the transition.
   *  - parameter toView: The view that is shown at the end of a completed transition.
   
   *
   */
  func animateTransition(transitionContext: UIViewControllerContextTransitioning, fromVC: UIViewController?, toVC: UIViewController?, fromView: UIView?, toView: UIView?)
  
  /**
   *  The completion function that is used to correctly complete the animation transiton.
   *
   * - parameter success: Indicates whether the transition was cancelled of finished. True means the transition was finished.
   *
   * - note: The separate completion handler is needed due to the iOS bug.
   * - seealso: [The Stackoverflow question #31466679](https://stackoverflow.com/questions/31466679/uipercentdriveninteractivetransition-doesnt-get-to-animations-completion-on-fa)
   *
   */
  func completionHandler(success: Bool)
}

// TODO: - Replace informal abstract class with a protocol extension (currently protocol extension gives segmentation fault 11 error)
class GFAbstractAnimationController: NSObject, GFAnimationControllerReversible {
  // MARK: - GFAnimationControllerReversible
  var reverse: Bool = false
  var isCompleted: Bool = false
  
   func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return kReversibleTransitionDuration
  }
  
   func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    // Get the set of relevant objects.
    let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
    let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
    
    let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
    
    animateTransition(transitionContext, fromVC: fromVC, toVC: toVC, fromView: fromView, toView: toView)
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning, fromVC: UIViewController?, toVC: UIViewController?, fromView: UIView?, toView: UIView?) {
    log.verbose("You should override this method in a subclass...")
  }
  
  func completionHandler(success: Bool) {
    log.verbose("You should override this method in a subclass...")
  }
}


