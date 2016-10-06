//
//  TrimmerDashboard.swift
//  Pods
//
//  Created by Storix on 6/20/16.
//  Copyright (c) 2016 Storix. All rights reserved.
//

import UIKit


/// Class that defines the trimmer dashboard appearance related static properties.
class DashboardAppearance {
  // MARK: Appearance properties
  /// Specifies the font for the trimmer time text fields.
  static var textFieldsFont = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)
  /// Defines the dashboard text fields offset from the superview edges.
  static var textFieldsEdgeOffset: CGFloat = 5.0
  /// The width (in points) of the trimmer time text fields.
  static var textFieldsWidth: CGFloat = 60.0
  /// The height (in points) of the trimmer view dashboard.
  static var height: CGFloat = 30.0
  /// The dashboard background color.
  static var backgroundColor = UIColor.whiteColor()
  /// The dashboard corner radius.
  static var cornerRadius: CGFloat = 4.0
  /// The dashboard border width.
  static var borderWidth: CGFloat = 2.0
  /// The dashboard border color.
  static var borderColor = UIColor.brownColor()
}


/// The `UIView` subclass that is used to display information regarding current trimmer times and options to change the current timeline scale.
class TrimmerDashboard: UIView {
  // MARK: Properties
  /// The time that is displayed in the left text field.
  var leftFieldTime: CGFloat = 0.0 
  /// The time that is displayed in the right text field.
  var rightFieldTime: CGFloat = 0.0
  /// The text field that is used to display the selected start time to trim the video.
  var startTimeField: UITextField!
  /// The text field that is used to display the selected end time to trim the video.
  var endTimeField: UITextField!
  /// The view that is used to align the dashboard controls (currently these include the total selected time label and zoom button) at the `TrimmerDashboard` center.
  var centralContainerView: DashboardCentralControlsView!
  /// The auto layout constraint that is used to dynamically change the dashboard width.
  var widthConstraint: NSLayoutConstraint!
  
  /// Specifies the minimum allowed width of the trimmer dashboard.
  var minWidth: CGFloat {
    return 2 * DashboardAppearance.textFieldsEdgeOffset + startTimeField.bounds.width + endTimeField.bounds.width + centralContainerView.bounds.width
  }
  
  
  // MARK: UIView Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  /// Recalculates the total trimmer time label in accordance with the current trimmer times.
  func updateTotalTime() {
    let currentTotalTime = floor(rightFieldTime) - floor(leftFieldTime)
    let formattedTotalTimeString = NSDateComponents.getTrimmerTimesFormatter().stringFromTimeInterval(Double(currentTotalTime))
    centralContainerView.totalTimeText = formattedTotalTimeString ?? "00:00:00"
  }
  
  // MARK: Instance methods
  /// The common initializer of the `TrimmerDashboard` properties.
  private func commonInit() {
    backgroundColor = DashboardAppearance.backgroundColor
    translatesAutoresizingMaskIntoConstraints = false
    layer.masksToBounds = true
    layer.cornerRadius = DashboardAppearance.cornerRadius
    layer.borderWidth = DashboardAppearance.borderWidth
    layer.borderColor = DashboardAppearance.borderColor.CGColor

    // Configure central containter view.
    centralContainerView = DashboardCentralControlsView(frame: CGRectZero)
    centralContainerView.zoomButtonDefaultImage = UIImage(named: "ZoomImageNormal", inBundle: NSBundle.sh_resourceBundle(), compatibleWithTraitCollection: nil)
    centralContainerView.totalTimeText = "00:00:00"
    
    addSubview(centralContainerView)
    
    // Configure start and end time text fields.
    var allFields = [UITextField]()
    
    startTimeField = UITextField(frame: CGRectZero)
    allFields.append(startTimeField)

    endTimeField = UITextField(frame: CGRectZero)
    allFields.append(endTimeField)

    for textField in allFields {
      textField.translatesAutoresizingMaskIntoConstraints = false
      textField.text = "00:00:00"
      textField.adjustsFontSizeToFitWidth = true
      // iOS prevents setting the minimum font size that is smaller than 14.
      // See: https://stackoverflow.com/questions/6045176/uitextfield-minimum-fontsize
      textField.minimumFontSize = 14.0
      textField.enabled = false
      textField.font = DashboardAppearance.textFieldsFont
    }
    
    addSubview(startTimeField)
    addSubview(endTimeField)
    
    // Configure constraints.
    widthConstraint = NSLayoutConstraint(item: self,
                                         attribute: .Width,
                                         relatedBy: .Equal,
                                         toItem: nil,
                                         attribute: .NotAnAttribute,
                                         multiplier: 1.0,
                                         constant: 10.0)
    widthConstraint.active = true
    
    NSLayoutConstraint(item: self,
                       attribute: .Height,
                       relatedBy: .Equal,
                       toItem: nil,
                       attribute: .NotAnAttribute,
                       multiplier: 1.0,
                       constant: DashboardAppearance.height).active = true
    
    // Text fields constraints.
    NSLayoutConstraint(item: startTimeField,
                       attribute: .CenterY,
                       relatedBy: .Equal,
                       toItem: self,
                       attribute: .CenterY,
                       multiplier: 1.0,
                       constant: 0.0).active = true
    
    NSLayoutConstraint(item: startTimeField,
                       attribute: .Width,
                       relatedBy: .Equal,
                       toItem: nil,
                       attribute: .NotAnAttribute,
                       multiplier: 1.0,
                       constant: DashboardAppearance.textFieldsWidth).active = true
    
    NSLayoutConstraint(item: endTimeField,
                       attribute: .CenterY,
                       relatedBy: .Equal,
                       toItem: self,
                       attribute: .CenterY,
                       multiplier: 1.0,
                       constant: 0.0).active = true
    
    NSLayoutConstraint(item: endTimeField,
                       attribute: .Width,
                       relatedBy: .Equal,
                       toItem: nil,
                       attribute: .NotAnAttribute,
                       multiplier: 1.0,
                       constant: DashboardAppearance.textFieldsWidth).active = true
    
    var allConstraints = [NSLayoutConstraint]()

    let views = ["startTimeField": startTimeField,
                 "endTimeField": endTimeField]
    let metrics = ["edgeOffset": DashboardAppearance.textFieldsEdgeOffset]
    
    let leftTextFieldHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-edgeOffset-[startTimeField]",
      options: [],
      metrics: metrics,
      views: views)
    allConstraints += leftTextFieldHorizontalConstraints
    
    let rightTextFieldHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
      "H:[endTimeField]-edgeOffset-|",
      options: [],
      metrics: metrics,
      views: views)
    allConstraints += rightTextFieldHorizontalConstraints
    
    // Containter view constraints.
    NSLayoutConstraint(item: centralContainerView,
                       attribute: .CenterY,
                       relatedBy: .Equal,
                       toItem: self,
                       attribute: .CenterY,
                       multiplier: 1.0,
                       constant: 0.0).active = true
    
    NSLayoutConstraint(item: centralContainerView,
                       attribute: .CenterX,
                       relatedBy: .Equal,
                       toItem: self,
                       attribute: .CenterX,
                       multiplier: 1.0,
                       constant: 0.0).active = true
    
    NSLayoutConstraint(item: centralContainerView,
                       attribute: .Height,
                       relatedBy: .Equal,
                       toItem: self,
                       attribute: .Height,
                       multiplier: 1.0,
                       constant: 0.0).active = true
        
    NSLayoutConstraint.activateConstraints(allConstraints)
  }
}
