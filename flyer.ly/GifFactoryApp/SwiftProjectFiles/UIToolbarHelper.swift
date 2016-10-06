//
//  UIToolbarHelper.swift
//  GifFactoryApp
//
//  DESCRIPTION:
//      Swift helper (SH) UIToolbar extension.
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit


extension UIToolbar {
  
  /**
   *  Replaces UIBarButtonItem at the given index with the given bar button.
   *
   *  - parameter index: Index in the UIToolbar items array.
   *  - parameter withBarButton: New UIBarButtonItem which will be used in place of the bar button at the specified index.
   *  - parameter animated: Indicates whether the toolbar items will be set with the animation.
   *
   */
  func sh_replaceBarButtonAtIndex(index: Int, withBarButton barButton: UIBarButtonItem, animated: Bool = true) -> Void {
    if animated {
      if var toolBarItems = items {
        if(index >= 0  && index < toolBarItems.count) {
          toolBarItems[index] = barButton
          
          self.setItems(toolBarItems, animated: true)
        }
      }
    } else {
      items?[index] = barButton
    }
  }
}
