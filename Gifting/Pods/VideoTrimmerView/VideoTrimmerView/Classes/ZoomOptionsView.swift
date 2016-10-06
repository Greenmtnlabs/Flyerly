//
//  ZoomOptionsView.swift
//  Pods
//
//  Created by Storix on 6/22/16.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit


/// Class that defines the zoom options buttons appearance related static properties.
class ZoomOptionsAppearance {
  // MARK: Appearance properties
  /// Defines the offset between the zoom options buttons.
  static var horizontalSpacing: CGFloat = 10.0
  /// Defines the zoom options view background color.
  static var backgroundColor = UIColor.redColor()
  /// Specifies the animation duration to show/hide zoom options.
  static var animationDuration = 0.3
  /// The color for the `Normal` button state.
  static var buttonsNormalStateColor = UIColor.whiteColor()
  /// The color for the `Selected` button state.
  static var buttonsSelectedStateColor = UIColor.blackColor()
  /// The zoom options buttons font.
  static var buttonsFont = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
}

/// The view that is used to display the buttons by means of which it is possible to change the trimmer timeline zoom.
class ZoomOptionsView: UIView {
  // MARK: Properties
  /// Indicates the current zoom mode.
  var currentZoomScale = TrimmerZoomScale.Default
  /// The auto layout constraint that is used to dynamically change the zoom options view y position.
  var zoomOptionsYPositionConstraint: NSLayoutConstraint?
  /**
      The closure that is called in response to zoom option button tap.
   
      - parameter sender: The button that was tapped.
   */
  var zoomOptionButtonTapHandler: ((sender: UIButton) -> Void)?
  
  /// Specifies whether the zoom options view as been presented.
  var isPresented = false {
    didSet {
      userInteractionEnabled = isPresented
    }
  }
  
  /// The button to set the default 1x zoom mode (in this mode the video frames collection view width equals trimmer view frame width excluding trimmer sliders widths).
  var zoom1xButton: UIButton!
  /** 
      The button to set 16x zoom mode (video frames collection view equals 16 trimmer view frame widths).
   
      - seealso: `zoom1xButton`
  */
  var zoom16xButton: UIButton!
  /**
      The button to set 32x zoom mode.
   
      - seealso: `zoom1xButton`
   */
  var zoom32xButton: UIButton!
  /**
      The button to set 64x zoom mode.
   
      - seealso: `zoom1xButton`
   */
  var zoom64xButton: UIButton!
  
  /// The array with the zoom options buttons.
  var allButtons = [UIButton]()

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
    
    return CGSizeMake(5 * ZoomOptionsAppearance.horizontalSpacing +
      zoom1xButton.intrinsicContentSize().width +
      zoom16xButton.intrinsicContentSize().width +
      zoom32xButton.intrinsicContentSize().width +
      zoom64xButton.intrinsicContentSize().width, UIViewNoIntrinsicMetric)
  }
  
  /// Action method for the zoom options buttons.
  func zoomOptionButtonTapped(sender: UIButton) {
    if currentZoomScale.rawValue == sender.tag { return }
    
    guard let zoomMode = TrimmerZoomScale(rawValue: sender.tag) else {
      log.warning("Failed to initialize zoom mode from the button tag.")
      return
    }
    currentZoomScale = zoomMode
    
    selectButtonWithTag(sender.tag)
    zoomOptionButtonTapHandler?(sender: sender)
    hide(animated: true)
  }
  
  /**
      Sets the button's state to `Selected` in accordance with the given tag.
   
      - parameter tag: The tag that identifies the button.
   */
  func selectButtonWithTag(tag: Int) {
    for button in allButtons {
      button.selected = button.tag == tag ? true : false
    }
  }
  
  /**
      Displays the zoom options view by changing the y position constraint.
   
      - parameter animated: Specifies whether the view will be presented with animation.
   */
  func show(animated animated: Bool) {
    guard let unwrappedYPositionConstraint = zoomOptionsYPositionConstraint else { return }
    
    isPresented = true
    
    let animationDuration = animated ? ZoomOptionsAppearance.animationDuration : 0.0
    layoutIfNeeded()
    
    UIView.animateWithDuration(animationDuration, delay: 0.0, options: .CurveLinear, animations: {
      unwrappedYPositionConstraint.constant = self.bounds.height
      self.layoutIfNeeded()
      }, completion: nil)
  }
  
  /**
      Hides the zoom options view by changing the y position constraint.
   
      - parameter animated: Specifies whether the view will be dismissed with animation.
   */
  func hide(animated animated: Bool) {
    guard let unwrappedYPositionConstraint = zoomOptionsYPositionConstraint else { return }
    
    isPresented = false
    
    let animationDuration = animated ? ZoomOptionsAppearance.animationDuration : 0.0
    layoutIfNeeded()
    
    UIView.animateWithDuration(animationDuration, delay: 0.0, options: .CurveEaseIn, animations: {
      unwrappedYPositionConstraint.constant = 0.0
      self.layoutIfNeeded()
      }, completion: nil)
  }
  
  /// The common initializer of the `ZoomOptionsView` properties.
  private func commonInit() {
    translatesAutoresizingMaskIntoConstraints = false
    clipsToBounds = true
    backgroundColor = ZoomOptionsAppearance.backgroundColor
    
    // Configure zoom options buttons.
    zoom1xButton = UIButton(type: .Custom)
    zoom1xButton.setTitle(NSLocalizedString("1x", comment: "1x zoom mode button title."), forState: .Normal)
    zoom1xButton.tag = 1
    zoom1xButton.selected = true
    allButtons.append(zoom1xButton)
    
    zoom16xButton = UIButton(type: .Custom)
    zoom16xButton.setTitle(NSLocalizedString("16x", comment: "16x zoom mode button title."), forState: .Normal)
    zoom16xButton.tag = 16
    allButtons.append(zoom16xButton)

    zoom32xButton = UIButton(type: .Custom)
    zoom32xButton.setTitle(NSLocalizedString("32x", comment: "32x zoom mode button title."), forState: .Normal)
    zoom32xButton.tag = 32
    allButtons.append(zoom32xButton)

    zoom64xButton = UIButton(type: .Custom)
    zoom64xButton.setTitle(NSLocalizedString("64x", comment: "32x zoom mode button title."), forState: .Normal)
    zoom64xButton.tag = 64
    allButtons.append(zoom64xButton)

    // Set common buttons properties.
    for button in allButtons {
      button.translatesAutoresizingMaskIntoConstraints = false
      button.titleLabel?.textAlignment = .Center
      button.titleLabel?.font = ZoomOptionsAppearance.buttonsFont

      button.addTarget(self, action: #selector(ZoomOptionsView.zoomOptionButtonTapped(_:)), forControlEvents: .TouchUpInside)
      button.setTitleColor(ZoomOptionsAppearance.buttonsNormalStateColor, forState: .Normal)
      button.setTitleColor(ZoomOptionsAppearance.buttonsSelectedStateColor, forState: .Selected)
      addSubview(button)
    }
    
    // Configure constraints.
    NSLayoutConstraint(item: zoom1xButton,
                       attribute: .CenterY,
                       relatedBy: .Equal,
                       toItem: self,
                       attribute: .CenterY,
                       multiplier: 1.0,
                       constant: 0.0).active = true
    
    var allConstraints = [NSLayoutConstraint]()
    
    let views = ["zoom1xButton": zoom1xButton,
                 "zoom16xButton": zoom16xButton,
                 "zoom32xButton": zoom32xButton,
                 "zoom64xButton": zoom64xButton]
    let metrics = ["spacing": ZoomOptionsAppearance.horizontalSpacing]
    
    let rightTextFieldHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-spacing-[zoom1xButton]-spacing-[zoom16xButton]-spacing-[zoom32xButton]-spacing-[zoom64xButton]-spacing-|",
      options: [.AlignAllCenterY],
      metrics: metrics,
      views: views)
    allConstraints += rightTextFieldHorizontalConstraints
    
    NSLayoutConstraint.activateConstraints(allConstraints)
  }
}
