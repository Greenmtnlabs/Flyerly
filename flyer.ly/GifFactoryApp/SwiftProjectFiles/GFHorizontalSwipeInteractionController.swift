//
//  GFHorizontalSwipeInteractionController.swift
//  GifFactoryApp
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit

/**
 A horizontal swipe interaction controller. When used with a navigation controller, a right-to-left, or left-to-right swipe will cause a 'pop' navigation. When used wth a tabbar controller, right-to-left and left-to-right cause navigation between neighbouring tabs.
 */
class GFHorizontalSwipeInteractionController: UIPercentDrivenInteractiveTransition, GFInteractionControllerWireable {
  /// Indicates whether a navigation controller 'pop' should occur on a right-to-left, or a left-to-right swipe. This property does not affect tab controller or modal interactions.
  var popOnRightToLeft = false
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

    popOnRightToLeft = true
    self.operation = operation
    self.viewController = viewController
  
    // Wire the gesture recognizer
    gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(GFHorizontalSwipeInteractionController.handleGesture(_:)))
    if let gestureRecognizer = gestureRecognizer {
      viewController.view.addGestureRecognizer(gestureRecognizer)
      if let viewController = viewController as? UIGestureRecognizerDelegate {
        gestureRecognizer.delegate = viewController
      }
    }
  }
  
  /// Horizontal gesture recognizer's action method
  func handleGesture(gestureRecognizer: UIPanGestureRecognizer) {
    guard let view = gestureRecognizer.view else { return }
    guard let viewController = viewController else { return }

    // Get the current translation value.
    let translation = gestureRecognizer.translationInView(view.superview)
    let velocity = gestureRecognizer.velocityInView(view)

    switch gestureRecognizer.state {
    case .Began:
      let rightToLeftSwipe = velocity.x < 0
      if operation == .Pop {
        // for pop operation fire on right-to-left
        if (popOnRightToLeft && rightToLeftSwipe) ||
          (!popOnRightToLeft && !rightToLeftSwipe) {
            isInteractionInProgress = true
            viewController.navigationController?.popToRootViewControllerAnimated(true)
        }
        
      } else if operation == .Tab {
        
        // for tab controllers we need to determine which direction to transition
        if let tabBarController = viewController.tabBarController {
          if rightToLeftSwipe {
            if let viewControllers = tabBarController.viewControllers {
              if tabBarController.selectedIndex < viewControllers.count - 1 {
                isInteractionInProgress = true
                tabBarController.selectedIndex += 1
              }
            }
          } else {
            if tabBarController.selectedIndex > 0 {
              isInteractionInProgress = true
              tabBarController.selectedIndex -= 1
            }
          }
        }
      } else {
        // for dismiss fire regardless of the translation direction
        isInteractionInProgress = true
        viewController.dismissViewControllerAnimated(true, completion: nil)
      }
    case .Changed:
      if isInteractionInProgress {
        // compute the current position
        var fraction = fabs(translation.x / 200.0)
        fraction = fmin(fmax(fraction, 0.0), 1.0)
        shouldCompleteTransition = (fraction > 0.5)
        
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