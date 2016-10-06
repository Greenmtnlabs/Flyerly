//
//  DashboardCentralControlsView.swift
//  Pods
//
//  Created by Storix on 6/21/16.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit

/// Class that defines the dashboards central controls appearance related static properties.
class CentralControlsAppearance {
  // MARK: Appearance properties
  /// Defines the total time label font.
  static var totalTimeLabelFont = DashboardAppearance.textFieldsFont
  /// The width (in points) of the total time label.
  static var totalTimeLabelWidth: CGFloat = 60.0
  /// Defines the offset between the dashboard central controls.
  static var horizontalSpacing: CGFloat = 5.0
  /// Defines the zoom button template image color.
  static var zoomButtonTintColor = UIColor.redColor()
}

class DashboardCentralControlsView: UIView {
  // MARK: Properties
  /// The view containing the buttons by means of which it is possible to change trimmer timeline zoom mode.
  weak var zoomOptionsView: ZoomOptionsView?

  /**
      Defines the text for the `totalTimeLabel`.
   
      - note: Use this property instead of directly calling `text` on `totalTimeLabel` to automatically recalculate `intrinsicContentSize`.
   */
  var totalTimeText: String {
    get {
      return totalTimeLabel.text ?? ""
    }
    
    set {
      totalTimeLabel.text = newValue
      invalidateIntrinsicContentSize()
    }
  }
  /**
      Defines the image for the `zoomButton` normal state.
   
      - note: Use this property instead of directly calling `setImage` on `zoomButton` to automatically recalculate `intrinsicContentSize`.
   */
  var zoomButtonDefaultImage: UIImage? {
    get {
      return zoomButton.currentImage
    }
    
    set {
      zoomButton.setImage(newValue, forState: .Normal)
      invalidateIntrinsicContentSize()
    }
  }
  
  /// The label showing the total time that will be used to trim the video.
  private var totalTimeLabel: UILabel!
  /// The button that is used to show the timeline zoom options.
  private var zoomButton: UIButton!

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
  override func intrinsicContentSize() -> CGSize {
    super.intrinsicContentSize()
    return CGSizeMake(3 * CentralControlsAppearance.horizontalSpacing + totalTimeLabel.intrinsicContentSize().width + zoomButton.intrinsicContentSize().width, UIViewNoIntrinsicMetric)
  }
  
  /// Action method for the `zoomButton`.
  func zoomButtonTapped(sender: UIButton) {
    guard let unwrappedZoomOptionsView = zoomOptionsView else { return }

    if unwrappedZoomOptionsView.isPresented {
      unwrappedZoomOptionsView.hide(animated: true)
    } else {
      unwrappedZoomOptionsView.show(animated: true)
    }
  }
  
  /// The common initializer of the `DashboardCentralControlsView` properties.
  private func commonInit() {
    translatesAutoresizingMaskIntoConstraints = false
    totalTimeLabel = UILabel(frame: CGRectZero)
    totalTimeLabel.translatesAutoresizingMaskIntoConstraints = false
    totalTimeLabel.font = CentralControlsAppearance.totalTimeLabelFont
    totalTimeLabel.adjustsFontSizeToFitWidth = true
    totalTimeLabel.minimumScaleFactor = 0.5
    
    addSubview(totalTimeLabel)
    
    zoomButton = UIButton(type: .Custom)
    zoomButton.translatesAutoresizingMaskIntoConstraints = false
    zoomButton.tintColor = CentralControlsAppearance.zoomButtonTintColor
    zoomButton.addTarget(self, action: #selector(DashboardCentralControlsView.zoomButtonTapped(_:)),forControlEvents: .TouchUpInside)
    
    addSubview(zoomButton)

    // Configure constraints.
    NSLayoutConstraint(item: totalTimeLabel,
                       attribute: .CenterY,
                       relatedBy: .Equal,
                       toItem: self,
                       attribute: .CenterY,
                       multiplier: 1.0,
                       constant: 0.0).active = true
    
    NSLayoutConstraint(item: totalTimeLabel,
                       attribute: .Width,
                       relatedBy: .Equal,
                       toItem: nil,
                       attribute: .NotAnAttribute,
                       multiplier: 1.0,
                       constant: CentralControlsAppearance.totalTimeLabelWidth).active = true
    
    NSLayoutConstraint(item: zoomButton,
                       attribute: .CenterY,
                       relatedBy: .Equal,
                       toItem: self,
                       attribute: .CenterY,
                       multiplier: 1.0,
                       constant: 0.0).active = true

    var allConstraints = [NSLayoutConstraint]()
    
    let views = ["totalTimeLabel": totalTimeLabel,
                 "zoomButton": zoomButton]
    let metrics = ["spacing": CentralControlsAppearance.horizontalSpacing]
    
    let rightTextFieldHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-spacing-[zoomButton]-spacing-[totalTimeLabel]-spacing-|",
      options: [],
      metrics: metrics,
      views: views)
    allConstraints += rightTextFieldHorizontalConstraints
    
    NSLayoutConstraint.activateConstraints(allConstraints)
  }
}
