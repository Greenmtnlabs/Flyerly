//
//  GFSettingsControllerTransitioningDelegate.swift
//  GifFactoryApp
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit

private let kAnimatableViewVerticalOffset: CGFloat = 44.0

/// Transition delegate that provides custom presetation controller.
class GFSettingsControllerTransitioningDelegate : NSObject, UIViewControllerTransitioningDelegate {

  /// The interaction controller that is used in the current transition.
  var interactionController: GFInteractionControllerWireable?
  /// The animation controller that is used in the current transition.
  var animationController: GFAnimationControllerReversible?
  
  func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
    let presentationController = GFResizablePresentationController(presentedViewController:presented, presentingViewController:presenting)
    
    presentationController.usesAutoLayout = (animationController is GFFoldAnimationController)
    
    // allow the interaction controller to wire-up its gesture recognisers
    interactionController?.wireToViewController(presented, forOperation: .Dismiss)
    // set animation controller to provide a way for correctly completing animation.
    interactionController?.animationController = animationController
    
    return presentationController
  }
  
  func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    // provide the interaction controller if an interactive transition is in progress
    return interactionController?.isInteractionInProgress ?? false ? interactionController : nil
  }
  
  func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    animationController?.reverse = false

    if animationController is GFFoldAnimationController && animationController != nil {
      let ac = animationController as! GFFoldAnimationController
      ac.animatableViewVerticalOffset = kAnimatableViewVerticalOffset
      
      if source.traitCollection.horizontalSizeClass == .Compact {
        ac.contentWidth = kSettingsControllerCompactContentWidth
      } else {
        ac.contentWidth = kSettingsControllerRegulartContentWidth
      }
    }

    return animationController
  }
  
  func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    animationController?.reverse = true

    return animationController
  }
}