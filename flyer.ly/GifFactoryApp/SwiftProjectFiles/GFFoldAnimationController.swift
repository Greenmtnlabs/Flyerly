//
//  GFFoldAnimationController.swift
//  GifFactoryApp
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit
import Foundation

/// Custom transition animation controller that uses a paper-fold style transition.
class GFFoldAnimationController: GFAbstractAnimationController {
  
  /// Number of folds for the paper-fold style transition.
  var folds: UInt = 3
  /// Defines the width of the presented view.
  var contentWidth: CGFloat = 320.0
  /// Defines the offset from the top bar.
  var animatableViewVerticalOffset: CGFloat = 0.0

  /// The array that holds snapshots of the fromView.
  private var fromViewFolds = [UIView]()
  /// The array that holds snapshots of the toView.
  private var toViewFolds = [UIView]()
  /// The view that is animated during the transition.
  private var animatableView: UIView?
  /// The view that acts as the superview for the views involved in the transition.
  private var containerView: UIView?
  private var animatableViewHeight: CGFloat {
    guard let animatableView = animatableView else { return 480.0 }
    return animatableView.frame.size.height
  }

  override func completionHandler(success: Bool) {
    
    isCompleted = true
    
    // Remove the snapshot views
    for view in fromViewFolds {
      view.removeFromSuperview()
    }
    
    for view in toViewFolds {
      view.removeFromSuperview()
    }
    
    guard let currentContainerView = containerView else { return }
    
    let animatableViewSize = CGSizeMake(contentWidth, animatableViewHeight)
    var animatableViewFrame = CGRectZero
    animatableViewFrame.origin = currentContainerView.bounds.origin
    animatableViewFrame.size = animatableViewSize
    
    // Restore the animatable view to the initial location
    animatableView?.frame = animatableViewFrame
  }
  
  override func animateTransition(transitionContext: UIViewControllerContextTransitioning, fromVC: UIViewController?, toVC: UIViewController?, fromView: UIView?, toView: UIView?) {
    isCompleted = false
    
    /// Cancels transition in case of errors.
    func cleanup() {
      transitionContext.completeTransition(false)
      isCompleted = true
    }
    
    // Errors checking.
    guard let containerView = transitionContext.containerView() else { cleanup(); return }
    if toView == nil && fromView == nil { cleanup(); return }
    
    self.containerView = containerView
    let containerBounds = containerView.bounds
    var heightOffest: CGFloat = 0
    
    if toView == nil {
      animatableView = fromView
    } else {
      heightOffest = animatableViewVerticalOffset
      animatableView = toView
    }
    
    if let animatableView = animatableView {
      // Move animatableView offscreen
      animatableView.frame = CGRectOffset(animatableView.frame, 0, containerBounds.size.height)
      
      // Add the animatableView to the container
      containerView.addSubview(animatableView)
    }
    
    // Add a perspective transform
    var transform = CATransform3DIdentity
    transform.m34 = -0.005
    containerView.layer.sublayerTransform = transform
    
    // Set a size for the presented view
    let size = CGSizeMake(contentWidth, animatableViewHeight + heightOffest)
    let animatableViewSize = CGSizeMake(contentWidth, animatableViewHeight)
    let foldWidth = animatableViewSize.width * 0.5 / CGFloat(folds)
    
    // Clear the arrays that hold the snapshot views
    fromViewFolds.removeAll()
    toViewFolds.removeAll()
    
    // Create the folds for the from- and to- views
    for foldIndex in (0..<folds) {
      let offset = CGFloat(foldIndex) * foldWidth * 2
      
      // The left and right side of the fold for the from-view, with identity transform and 0.0 alpha
      // on the shadow, with each view at its initial position
      if let fromView = fromView {
        let leftFromViewFold = createSnapshotFromView(fromView, offset: offset, afterUpdates: false, isLeft: true)
        leftFromViewFold.layer.position = CGPointMake(offset, size.height / 2)
        fromViewFolds.append(leftFromViewFold)
        leftFromViewFold.subviews[1].alpha = 0.0
        
        let rightFromViewFold = createSnapshotFromView(fromView, offset: (offset + foldWidth), afterUpdates: false, isLeft: false)
        rightFromViewFold.layer.position = CGPointMake(offset + foldWidth * 2, size.height / 2)
        fromViewFolds.append(rightFromViewFold)
        rightFromViewFold.subviews[1].alpha = 0.0
      }
      
      // The left and right side of the fold for the to-view, with a 90-degree transform and 1.0 alpha
      // on the shadow, with each view positioned at the very edge of the screen
      if let toView = toView {
        let availableSpaceOffset = containerBounds.size.width - animatableViewSize.width
        let leftToViewFold = createSnapshotFromView(toView, offset: offset + availableSpaceOffset, afterUpdates: true, isLeft: true)
        leftToViewFold.layer.position = CGPointMake(reverse ? size.width : 0.0, size.height / 2)
        leftToViewFold.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI_2), 0.0, 1.0, 0.0)
        toViewFolds.append(leftToViewFold)
        
        let rightToViewFold = createSnapshotFromView(toView, offset: offset + foldWidth + availableSpaceOffset, afterUpdates: true, isLeft: false)
        rightToViewFold.layer.position = CGPointMake(reverse ? size.width : 0.0, size.height / 2)
        rightToViewFold.layer.transform = CATransform3DMakeRotation(CGFloat(-M_PI_2), 0.0, 1.0, 0.0)
        toViewFolds.append(rightToViewFold)
      }
    }
    
    // Create the animation
    let duration = transitionDuration(transitionContext)
    UIView.animateWithDuration(duration,
      delay: 0,
      options: .CurveLinear,
      animations: {
      // Set the final state for each fold
      for foldIndex in (0..<self.folds) {
        let offset = CGFloat(foldIndex) * foldWidth * 2
        // The left and right side of the fold for the from-view, with 90 degree transform and 1.0 alpha
        // on the shadow, with each view positioned at the edge of the screen.
        if self.fromViewFolds.count > 0 {
          let leftFromView = self.fromViewFolds[Int(foldIndex * 2)]
          leftFromView.layer.position = CGPointMake(self.reverse ? 0.0 : size.width, size.height/2)
          leftFromView.layer.transform = CATransform3DRotate(transform, CGFloat(M_PI_2), 0.0, 1.0, 0)
          leftFromView.subviews[1].alpha = 1.0
          
          let rightFromView = self.fromViewFolds[Int(foldIndex * 2 + 1)]
          rightFromView.layer.position = CGPointMake(self.reverse ? 0.0 : size.width, size.height/2)
          rightFromView.layer.transform = CATransform3DRotate(transform, CGFloat(-M_PI_2), 0.0, 1.0, 0)
          rightFromView.subviews[1].alpha = 1.0
        }
        
        // The left and right side of the fold for the to- view, with identity transform and 0.0 alpha
        // on the shadow, with each view at its final position
        if self.toViewFolds.count > 0 {
          let leftToView = self.toViewFolds[Int(foldIndex * 2)]
          leftToView.layer.position = CGPointMake(offset, size.height / 2)
          leftToView.layer.transform = CATransform3DIdentity
          leftToView.subviews[1].alpha = 0.0
          
          let rightToView = self.toViewFolds[Int(foldIndex * 2 + 1)]
          rightToView.layer.position = CGPointMake(offset + foldWidth * 2, size.height / 2)
          rightToView.layer.transform = CATransform3DIdentity
          rightToView.subviews[1].alpha = 0.0
        }
      }
      }, completion: {
        
        finished in

        // Call completion handler only if it wasn't called by the interaction controller.
        if self.isCompleted == false {
          self.completionHandler(!transitionContext.transitionWasCancelled())
          transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    })
  }
  
  /**
   *  Creates a snapshot for the gives view.
   *
   *    - parameter view: The view a snapshot must be taken from.
   *    - parameter offset: X-asis offset that is used to create a snapshot region.
   *    - parameter afterUpdates: Specifies whether to capture the screen in its current state or after recent changes have been incorporated.
   *    - parameter isLeft: Specifies current fold position.
   *
   *  - returns: A new view object containing a snapshot of the current fold.
   */
  func createSnapshotFromView(view: UIView, offset: CGFloat, afterUpdates: Bool, isLeft: Bool) -> UIView {
    let size = view.frame.size
    let containerView = view.superview
    let foldWidth = contentWidth * 0.5 / CGFloat(folds)
    
    var snapshotView: UIView!
    let snapshotRegion = CGRectMake(offset, 0.0, foldWidth, size.height)
    
    if afterUpdates {
      // Create a regular snapshot
      snapshotView = view.resizableSnapshotViewFromRect(snapshotRegion, afterScreenUpdates: afterUpdates, withCapInsets: UIEdgeInsetsZero)
    } else {
      // For the to-view for some reason the snapshot takes a while to create.
      // Here we place the snapshot within another view, with the same bckground color,
      // so that it is less noticeable when the snapshot initially renders.
      snapshotView = UIView(frame: CGRectMake(0, 0, foldWidth, size.height))
      snapshotView.backgroundColor = view.backgroundColor
      let snapshotView2 = view.resizableSnapshotViewFromRect(snapshotRegion, afterScreenUpdates: afterUpdates, withCapInsets: UIEdgeInsetsZero)
      snapshotView.addSubview(snapshotView2)
    }
    
    // Create a shadow
    let snapshotWithShadowView = addShadowToView(snapshotView, reverse: isLeft)
    
    // Add to the container
    containerView?.addSubview(snapshotWithShadowView)
    
    // Set the anchor to the left or right edge of the view
    snapshotWithShadowView.layer.anchorPoint = CGPointMake( isLeft ? 0.0 : 1.0, 0.5)
    
    return snapshotWithShadowView
  }
  
  /**
   *  Adds a gradient to an image by creating a containing UIView with both the given view and the gradient as subviews.
   *
   *  - parameter view: The view a shadow must be applied to.
   *  - parameter reverse: Specifies whether the direction of the animation.
   *
   *  - returns: A new view object with applied shadow.
   */
  func addShadowToView(view: UIView, reverse: Bool) -> UIView {
    // Create a view with the same frame
    let viewWithShadow = UIView(frame: view.frame)
    
    // Create a shadow
    let shadowView = UIView(frame: viewWithShadow.bounds)
    let gradient = CAGradientLayer()
    gradient.frame = shadowView.bounds
    gradient.colors = [UIColor(white: 0.0, alpha: 0.0).CGColor, UIColor(white: 0.5, alpha: 1.0).CGColor]
    gradient.startPoint = CGPointMake(reverse ? 0.0 : 1.0, reverse ? 0.2 : 0.0)
    gradient.endPoint = CGPointMake(reverse ? 1.0 : 0.0, reverse ? 0.0 : 1.0)
    shadowView.layer.insertSublayer(gradient, atIndex: 1)
    
    // Add the original view into our new view
    view.frame = view.bounds
    viewWithShadow.addSubview(view)
    
    // Place the shadow on top
    viewWithShadow.addSubview(shadowView)
    
    return viewWithShadow
  }
}