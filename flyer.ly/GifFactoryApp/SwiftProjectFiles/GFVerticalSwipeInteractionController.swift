//
//  GFVerticalSwipeInteractionController.swift
//  GifFactoryApp
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit

/// A vertical swipe interaction controller. When used with a navigation controller, a top-to-bottom swipe will cause a 'pop' navigation.
class GFVerticalSwipeInteractionController: UIPercentDrivenInteractiveTransition, GFInteractionControllerWireable {
  /// Specifies current operation type.
  var operation: GFInteractionOperation = .Dismiss
  /// The view controller the gesture recognizer is wired to.
  var viewController: UIViewController?
  /// The vertical gesture recognizer.
  var gestureRecognizer: UIPanGestureRecognizer?
  /// The animator object that is used to correctly complete the transition.
  var animationController: GFAnimationControllerReversible? 
  /// Indicates whether the animation must be completed the user releases the finger.
  var shouldCompleteTransition = false

  /// The context object containing information about the transition.
  private var transitionContex: UIViewControllerContextTransitioning?
  
  // MARK: - UICollectionViewDataSource
  var isInteractionInProgress = false
  
  func wireToViewController(viewController: UIViewController, forOperation operation: GFInteractionOperation) {
    if operation == .Tab {
      log.warning("This interaction controller cannot be used with a tabbar controller. That would be silly.")
      return
    }
    
    self.operation = operation
    self.viewController = viewController
    
    //Wire the gesture recognizer
    gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(GFVerticalSwipeInteractionController.handleGesture(_:)))
    if let verticalGestureRecognizer = gestureRecognizer {
      viewController.view.addGestureRecognizer(verticalGestureRecognizer)
    }
  }
  
  /// Vertical gesture recognizer's action method
  func handleGesture(gestureRecognizer: UIPanGestureRecognizer) {
    // Get the current translation value.
    let translation = gestureRecognizer.translationInView(gestureRecognizer.view?.superview)
    
    switch gestureRecognizer.state {
    case .Began:
      let topToBottomSwipe = translation.y > 0
      if operation == .Pop {
        if topToBottomSwipe {
          isInteractionInProgress = true
          viewController?.navigationController?.popToRootViewControllerAnimated(true)
        }
      } else {
        // for dismiss, fire regardless of the translation direction
        isInteractionInProgress = true
        viewController?.dismissViewControllerAnimated(true, completion: nil)
      }
    case .Changed:
      if isInteractionInProgress {
        // compute the current position
        var fraction = fabs(translation.y / 200.0)
        fraction = fmin(fmax(fraction, 0.0), 1.0)
        shouldCompleteTransition = (fraction > 0.5)
        
        // if an interactive transitions is 100% completed via the user interaction, for some reason the animation completion block is not called.
        if fraction >= 1.0 { fraction = 0.99 }
        
        updateInteractiveTransition(fraction)
      }
    case .Cancelled, .Ended:
      if isInteractionInProgress {
        isInteractionInProgress = false
        var success = false
        if (!shouldCompleteTransition || gestureRecognizer.state == .Cancelled) {
          
          cancelInteractiveTransition()
          transitionContex?.completeTransition(false)
          
        } else {
          finishInteractiveTransition()
          transitionContex?.completeTransition(true)
          success = true
        }
        
        // Correctly complete the animation transition. This is needed due to iOS bug.
        // - seealso: [The Stackoverflow question #31466679](https://stackoverflow.com/questions/31466679/uipercentdriveninteractivetransition-doesnt-get-to-animations-completion-on-fa)
        animationController?.completionHandler(success)
      }
    default:
      log.verbose("Unrecognized gesture state. Do nothing...")
      break
    }
  }
  
  override func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
    super.startInteractiveTransition(transitionContext)
    transitionContex = transitionContext
  }
  
  deinit {
    if let gestureRecognizer = gestureRecognizer {
      gestureRecognizer.view?.removeGestureRecognizer(gestureRecognizer)
    }
  }
}
