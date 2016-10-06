//
//  GFInteractionControllerWireable.swift
//  GifFactoryApp
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit

/// An enumeration that describes the navigation operation that an interaction controller should initiate.
enum GFInteractionOperation {
  /// Indicates that the interaction controller should start a navigation controller 'pop' navigation.
  case Pop
  /// Indicates that the interaction controller should initiate a modal 'dismiss'.
  case Dismiss
  /// Indicates that the interaction controller should navigate between tabs.
  case Tab
}


/// The protocol that manages the connection from the interaction controller to the given view controller.
protocol GFInteractionControllerWireable: class, UIViewControllerInteractiveTransitioning {
  /// This property indicates whether an interactive transition is in progress.
  var isInteractionInProgress: Bool { get set }
  /// The animator object that is used to correctly complete the transition.
  var animationController: GFAnimationControllerReversible? { get set }
  
  /**
   * Connects this interaction controller to the given view controller.
   * 
   *  - parameter viewController: The view controller which this interaction should add a gesture recognizer to.
   *  - parameter operation: The operation that this interaction initiates when.
   */
  func wireToViewController(viewController: UIViewController, forOperation operation: GFInteractionOperation)
}