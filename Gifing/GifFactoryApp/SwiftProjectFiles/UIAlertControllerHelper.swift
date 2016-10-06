//
//  UIAlertControllerHelper.swift
//  GifFactoryApp
//
//  DESCRIPTION:
//      Swift helper (SH) UIAlertController extension that simplifies error dialogs creation.
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit

extension UIAlertController {
  /**
   *  Shows the warning dialog from the specified presenting view controller with Cancel button and OK or Settings button (depending on isSettingsButtonRequired parameter).
   *
   *  - parameter viewController: Presenting view controller.
   *  - parameter title: The warning dialog title.
   *  - parameter message: The message displayed in the warning dialog.
   *  - parameter isSettingsButtonRequired: Determines whether alert dialog requires settings button. If true the Settings and Cancel buttons will be displayed instead of the default OK button.
   */
  public class func sh_showAlertFromViewController(viewController: UIViewController, withTitle title: String?, andMessage message: String?, isSettingsButtonRequired: Bool = false) -> Void {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    var alertActions = [UIAlertAction]()
    
    if(isSettingsButtonRequired == false) {
      let defaultAction = UIAlertAction(title: kOKActionButtonLabel, style: .Default, handler: nil)
      alertActions.append(defaultAction)
    } else {
      let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: "Settings action button title"),
        style: .Default) {
          (_) -> Void in
        let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
        if let url = settingsUrl {
          UIApplication.sharedApplication().openURL(url)
        }
      }
      
      let cancelAction = UIAlertAction( title: kCancelActionButtonLabel, style: .Cancel, handler: nil)
      
      alertActions += [settingsAction, cancelAction]
    }

    for alertAction in alertActions {
      alertController.addAction(alertAction)
    }
    
    viewController.presentViewController(alertController, animated: true, completion: nil)
  }
  
  /**
   *  Shows the warning dialog from the specified presenting view controller with Cancel and Try Again buttons.
   *
   *  - parameter viewController: Presenting view controller.
   *  - parameter title: The warning dialog title.
   *  - parameter message: The message displayed in the warning dialog.
   *  - parameter tryAgainHandler: Specifies the action that is performed when Try Again button is tapped.
   */
  public class func sh_showAlertFromViewController(viewController: UIViewController, withTitle title: String?, andMessage message: String?, tryAgainHandler: ((UIAlertAction) -> Void)?) -> Void {
    let cancelAction = UIAlertAction(title: kCancelActionButtonLabel, style: .Cancel, handler: nil)
    
    let tryAgainAction = UIAlertAction(title: NSLocalizedString("Try Again", comment: "Try Again action button title."), style: .Default, handler: tryAgainHandler)

    let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    alertController.addAction(cancelAction)
    alertController.addAction(tryAgainAction)
    
    viewController.presentViewController(alertController, animated: true, completion: nil)
  }
  
  /**
   *  Shows the action sheet with `Cancel` and `Delete` actions.
   *
   *  - parameter viewController: Presenting view controller.
   *  - parameter barButtonItem: The bar button item on which to anchor the popover (required for iPad).
   *  - parameter deleteActionTitle: The title that is used for the delete action.
   *  - parameter deleteHandler: Specifies the closure that is performed when `Delete` action has been chosen.
   *  - parameter cancelHandler: Specifies the closure that is performed when the action sheet was cancelled.
   */
  public class func sh_showActionSheetFromViewController(viewController: UIViewController, withPresentingBarButton barButtonItem: UIBarButtonItem, deleteActionTitle: String, deleteHandler: ((action: UIAlertAction) -> Void)?, cancelHandler: ((action: UIAlertAction) -> Void)?) {
    let actionSheetController = UIAlertController(
      title: nil,
      message: nil,
      preferredStyle: .ActionSheet)
    
    let cancelAction = UIAlertAction(
      title: kCancelActionButtonLabel,
      style: .Cancel,
      handler: cancelHandler)
    
    let deleteAction = UIAlertAction(
      title: deleteActionTitle,
      style: .Destructive,
      handler: deleteHandler)
    
    actionSheetController.addAction(cancelAction)
    actionSheetController.addAction(deleteAction)
    
    if let iPadPopover = actionSheetController.popoverPresentationController {
      iPadPopover.barButtonItem = barButtonItem
      iPadPopover.permittedArrowDirections = .Any
      actionSheetController.view.layoutIfNeeded()
    }
    
    viewController.presentViewController(actionSheetController, animated: true, completion: nil)
  }
}

