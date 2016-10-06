//
//  TrimmerSlider.swift
//  Pods
//
//  Created by Storix on 6/16/16.
//  Copyright (c) 2016 Storix. All rights reserved.
//


import UIKit


/// Class that defines the trimmer slider appearance related static properties.
class SliderAppearance {
  // MARK: Appearance properties
  /// Trimmer view slider color that fills the arrow templated image.
  static var tintColor = UIColor.redColor()
  /// Trimmer view slider background color.
  static var backgroundColor = UIColor.yellowColor()
  /// The width of the trimmer view sliders.
  static var width: CGFloat = 20.0
}

/// The trimmer view movable slider.
class TrimmerSlider: UIView {
  // MARK: Properties
  /// Image view used to display the arrow image.
  var imageView = UIImageView(image: nil)
  /// Specifies the arrow image direction.
  var isRight = false {
    didSet {
      imageView.transform = isRight == true ? CGAffineTransformMakeScale(-1.0, 1.0) : CGAffineTransformMakeScale(1.0, 1.0)
    }
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
  
  // MARK: Instance methods
  /// The common initializer of the `TrimmerSlider` properties.
  private func commonInit() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = SliderAppearance.backgroundColor
      
    imageView = UIImageView(image: UIImage(named: "Arrow", inBundle: NSBundle.sh_resourceBundle(), compatibleWithTraitCollection: nil))
    imageView.tintColor = SliderAppearance.tintColor
    if imageView.image == nil {
      log.warning("Failed to load the trimmer slider arrow image.")
    }
    addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint(item: imageView,
                       attribute: .CenterX,
                       relatedBy: .Equal,
                       toItem: self,
                       attribute: .CenterX,
                       multiplier: 1.0,
                       constant: 0.0).active = true
    
    NSLayoutConstraint(item: imageView,
                       attribute: .CenterY,
                       relatedBy: .Equal,
                       toItem: self,
                       attribute: .CenterY,
                       multiplier: 1.0,
                       constant: 0.0).active = true
    
    NSLayoutConstraint(item: self,
                       attribute: .Width,
                       relatedBy: .Equal,
                       toItem: nil,
                       attribute: .NotAnAttribute,
                       multiplier: 1.0,
                       constant: SliderAppearance.width).active = true
  }
}
