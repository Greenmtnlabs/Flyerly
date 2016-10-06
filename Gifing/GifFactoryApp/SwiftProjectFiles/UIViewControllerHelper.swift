//
//  UIViewControllerHelper.swift
//  GifFactoryApp
//
//  DESCRIPTION:
//      Swift helper (SH) UIViewController extension.
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit
import GoogleMobileAds

extension UIViewController {
  
  /**
   *  Returns YES if the view is displayed and visible.
   */
  func sh_isViewVisible() -> Bool {
    return (isViewLoaded() && view.window != nil)
  }
  
  /**
      Creates the snapshot from the given view controller and adds it as a fullscreen subview to the current view controller's view.
   
      - parameter viewForSnapshotting: The view that is used for snapshotting. The snapshot image then is used during the transition.
   */
  func sh_addFullscreenSnapshotOfView(viewForSnapshotting: UIView) {
    var snapshot = UIView(frame: CGRectZero)
    
    if let keyWindow = UIApplication.sharedApplication().keyWindow {
      snapshot = keyWindow.snapshotViewAfterScreenUpdates(false)
    } else {
      // Try another method to capture the snapshot.
      // Create a temporary background image from the viewControllerForSnapshot view.
      var image: UIImage?
      UIGraphicsBeginImageContextWithOptions(viewForSnapshotting.frame.size, false, 0.0)
      let context = UIGraphicsGetCurrentContext()
      if let context = context {
        // Create the snapshot of the viewControllerForSnapshot view.
        viewForSnapshotting.layer.renderInContext(context)
        // Save the snapshot as an image.
        image = UIGraphicsGetImageFromCurrentImageContext()
      } else {
        log.warning("Failed to create a context to capture the image of the viewControllerForSnapshot view!")
      }
      UIGraphicsEndImageContext()
      
      // Create an image view that covers the whole screen.
      let imageView = UIImageView(frame: viewForSnapshotting.frame)
      imageView.image = image
      snapshot = imageView
    }
    
    // Add the image view above all the subvies of the current controller.
    navigationController?.setNavigationBarHidden(true, animated: false)
    view.addSubview(snapshot)
  }
  
  // Restores the previous state of the current view controller which was before presenting the modal view controller using snapshotting.
  func sh_restoreStateAfterSnapshotting() {
    view.subviews.last?.removeFromSuperview()
    navigationController?.setNavigationBarHidden(false, animated: false)
  }
}
