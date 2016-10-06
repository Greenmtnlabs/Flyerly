//
//  TimelineCell.swift
//  Pods
//
//  Created by Storix on 6/15/16.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit

/// The collection view cell that is used to display timeline frame.
class TimelineCell: UICollectionViewCell {
  // MARK: Properties
  /// The image view that holds the timeline frame image.
  var imageView = UIImageView(image: nil)
  /// Unique identifier that is used to identify the current reusable cell and set its properties correctly.
  var uniqueIdentifier: String?
  
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
  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
    uniqueIdentifier = ""
  }
  
  /// The common initializer of the `TimelineCell` properties.
  private func commonInit() {
    clipsToBounds = true
    imageView.contentMode = .ScaleAspectFill
    addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    let views = ["imageView": imageView]
    var allConstraints = [NSLayoutConstraint]()
    
    let collectionViewVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-0-[imageView]-0-|",
      options: [],
      metrics: nil,
      views: views)
    allConstraints += collectionViewVerticalConstraints
    
    let collectionViewHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-0-[imageView]-0-|",
      options: [],
      metrics: nil,
      views: views)
    allConstraints += collectionViewHorizontalConstraints
    
    NSLayoutConstraint.activateConstraints(allConstraints)
  }
}
