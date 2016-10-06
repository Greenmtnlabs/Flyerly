//
//  GFBackgroundAlertDismissing.swift
//  GifFactoryApp
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit

/// Defines methods that can be used to dismiss an alert when an application is in background. This behaviour is required accordint to the Apple UI guidelines. 
///
/// - note: To correclty use this protocol call `addBackgroundAlertDismissingObserver` in viewDidLoad and `removeBackgroundAlertDismissingObserver` in deinit methods of your class.
protocol GFBackgroundAlertDismissing: class {
  /// The observer object that is set using the `addBackgroundAlertDismissingObserver` method and removed using the `removeBackgroundAlertDismissingObserver`.
  var _backgroundAlertDismissingObserver: NSObjectProtocol? { get set }
  /// Sets the observer of `UIApplicationDidEnterBackgroundNotification`.
  func addBackgroundAlertDismissingObserver()
  /// Removes the `_backgroundAlertDismissingObserver`.
  func removeBackgroundAlertDismissingObserver()
}

/// Provides the default implementations of the GFBackgroundAlertDismissing methods.
extension GFBackgroundAlertDismissing where Self: UIViewController {
  
  func addBackgroundAlertDismissingObserver() {
    
    _backgroundAlertDismissingObserver = NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationDidEnterBackgroundNotification, object: nil, queue: NSOperationQueue .mainQueue()) { [unowned self] notification in
      
      if(self.presentedViewController is UIAlertController) {
        self.dismissViewControllerAnimated(true, completion: nil)
      }
    }
  }
  
  func removeBackgroundAlertDismissingObserver() {
    if let observer = _backgroundAlertDismissingObserver {
      NSNotificationCenter.defaultCenter().removeObserver(observer)
    }
  }
}