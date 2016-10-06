//
//  GFResizablePresentationController.swift
//  GifFactoryApp
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit

private let kDimmingViewPresentingAlpha: CGFloat = 0.3
private let kDimmingViewDismissingAlpha: CGFloat = 0.0

/**
 *  The presentation controller that manages the presented controller so that it can fill only the specified part of the available space.
 */
class GFResizablePresentationController: UIPresentationController {
  /// Specifies whether the presented view controller uses Auto Layout constraints.
  var usesAutoLayout = false
  /// Defines the width of the presented view.
  var contentWidth: CGFloat = 320.0
  /// Defines the offset from the top bar.
  var animatableViewVerticalOffset: CGFloat = 0.0
  /// Dimming view background color.
  var dimmingBackgroundColor = UIColor.sh_colorFromHexCode(Colors.LIGHTSKYBLUE)
  
  /// The background presentation view that is used when the presented controller fills only part of the available space.
  private var dimmingView = UIView()
  
  override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
    super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    
    dimmingView.backgroundColor = dimmingBackgroundColor
    dimmingView.alpha = 0.0
    
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(GFResizablePresentationController.dimmingViewTapped(_:)))
    dimmingView.addGestureRecognizer(tapRecognizer)
  }
  
  override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)

  }
  
  override func frameOfPresentedViewInContainerView() -> CGRect {
    var presentedViewFrame = CGRectZero
    guard let unwrappedContainerView = containerView else { return presentedViewFrame }

    let containerBounds = unwrappedContainerView.bounds
    
    presentedViewFrame.size = sizeForChildContentContainer(presentedViewController, withParentContainerSize: containerBounds.size)
    presentedViewFrame.origin.x = 0
    
    return presentedViewFrame
  }
  
  override func presentationTransitionWillBegin() {
    guard let unwrappedContainerView = containerView else { return }

    // Set the dimming view to the size of the container's
    // bounds, and make it transparent initially.
    dimmingView.frame = unwrappedContainerView.bounds
    dimmingView.alpha = 0.0
    
    // Insert the dimming view below everything else.
    unwrappedContainerView.insertSubview(dimmingView, atIndex:0)
    
    // Fade in the dimming view.
    animateDimmingViewAlpha(toAlpha: kDimmingViewPresentingAlpha)
  }
  
  override func presentationTransitionDidEnd(completed: Bool) {
    // If the presentation was canceled, remove the dimming view.
    if completed == false {
      dimmingView.removeFromSuperview()
    }
  }
  
  override func dismissalTransitionWillBegin() {
    // Fade the dimming view back out.
    animateDimmingViewAlpha(toAlpha: kDimmingViewDismissingAlpha)
  }
  
  override func dismissalTransitionDidEnd(completed: Bool) {
    // If the dismissal was successful, remove the dimming view.
    if completed {
      dimmingView.removeFromSuperview()
    }
  }
  
  /// Sets the frames of the dimming and presented views to the bounds of the container view.
  ///
  /// - note: This resizing is needed when the device is rotated.
  override func containerViewDidLayoutSubviews() {
    super.containerViewDidLayoutSubviews()
    
    updateContentWidth(withTraitCollection: traitCollection)

    guard let unwrappedContainerView = containerView else { return }
    
    dimmingView.frame = unwrappedContainerView.bounds
    
    if usesAutoLayout == false {
      presentedView()?.frame = frameOfPresentedViewInContainerView()
    }
  }
  
  override func sizeForChildContentContainer(container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
    super.sizeForChildContentContainer(container, withParentContainerSize: parentSize)
    
    return CGSizeMake(contentWidth, parentSize.height + animatableViewVerticalOffset)
  }
  
  override func shouldRemovePresentersView() -> Bool {
    return false
  }
  
  override func shouldPresentInFullscreen() -> Bool {
    return false
  }
  
  /// Animates the dimming view fadding in and out.
  /// - parameter toAlpha: Alpha value the dimming view must be animated to.
  func animateDimmingViewAlpha(toAlpha alpha: CGFloat) {
    // Set up the animation for the dimming view.
    if let coordinator = presentedViewController.transitionCoordinator() {
      coordinator.animateAlongsideTransition({
        context in
        
        self.dimmingView.alpha = alpha
        
        }, completion: nil)
    } else {
      dimmingView.alpha = alpha
    }
  }

  /// Gesture recognizer handler that is used to dismiss the presented view controller then the dimming view is tapped.
  /// - parameter gesture: The associated action message from the gesture recognizer.
  func dimmingViewTapped(gesture: UIGestureRecognizer) {
    if (gesture.state == UIGestureRecognizerState.Ended) {
      presentingViewController.dismissViewControllerAnimated(true, completion: nil)
    }
  }
  
  func updateContentWidth(withTraitCollection traitCollection: UITraitCollection) {
    if traitCollection.horizontalSizeClass == .Compact {
      contentWidth = kSettingsControllerCompactContentWidth
    } else if traitCollection.horizontalSizeClass == .Regular {
      contentWidth = kSettingsControllerRegulartContentWidth
    } else {
      log.verbose("Trait collection in the presentation controller is not defined.")
    }
  }
}