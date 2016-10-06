//
//  TrimmerActivityView.swift
//  Pods
//
//  Created by Storix on 6/27/16.
//  Copyright (c) 2016 Storix. All rights reserved.
//

import UIKit

/// Class that defines the trimmer dashboard appearance related static properties.
class ActivityAppearance {
  // MARK: Appearance properties
  /// The activity view background color.
  static var backgroundColor = UIColor.whiteColor()
  /// The activity indicator color.
  static var indicatorTintColor = UIColor.blackColor()
  /// The activity view presentation animation duration.
  static var animationDuration = 0.3
}


/// The activity view that is displayed when the trimmer view is being reloaded.
class TrimmerActivityView: UIView {
  // MARK: Properties
  /// The activity indicator which is animated when the trimmer view is being reloaded.
  var activityIndicator: UIActivityIndicatorView!
  
  // MARK: UIView Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  // MARK: Instance methods
  /// Shows the activity view and starts the indicator animation.
  func presentActivity() {
    userInteractionEnabled = true

    UIView.animateWithDuration(ActivityAppearance.animationDuration, delay: 0.0, options: .CurveEaseIn, animations: {
      self.alpha = 1.0
      self.activityIndicator.startAnimating()
      }, completion: nil)
  }
  
  /// Hides the activity view and stops the indicator animation.
  func dismissActivity() {
    userInteractionEnabled = false

    UIView.animateWithDuration(ActivityAppearance.animationDuration, delay: 0.0, options: .CurveEaseOut, animations: {
      self.alpha = 0.0
      self.activityIndicator.stopAnimating()
      }, completion: nil)
  }
  
  /// The common initializer of the `TrimmerActivityView` properties.
  private func commonInit() {
    backgroundColor = ActivityAppearance.backgroundColor
    translatesAutoresizingMaskIntoConstraints = false
    userInteractionEnabled = false
    alpha = 0.0
    
    // Configure the activity indicator.
    activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    activityIndicator.hidesWhenStopped = true
    activityIndicator.color = ActivityAppearance.indicatorTintColor
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(activityIndicator)
    
    // Configure constraints.
    NSLayoutConstraint(item: activityIndicator,
                       attribute: .CenterX,
                       relatedBy: .Equal,
                       toItem: self,
                       attribute: .CenterX,
                       multiplier: 1.0,
                       constant: 0.0).active = true
    NSLayoutConstraint(item: activityIndicator,
                       attribute: .CenterY,
                       relatedBy: .Equal,
                       toItem: self,
                       attribute: .CenterY,
                       multiplier: 1.0,
                       constant: 0.0).active = true
  }
}
