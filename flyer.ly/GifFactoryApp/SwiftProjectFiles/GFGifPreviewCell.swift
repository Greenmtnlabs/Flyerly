//
//  GFGifPreviewCell.swift
//  GifFactoryApp
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit
import YYImage

/// Global context variable that is used to observe animated image view state.
private var previewCellContext = 0

/// The collection view cell subclass for GIF previewing.
class GFGifPreviewCell: GFCollectionViewBaseCell {
  // MARK: Properties
  // The delegate object which is notified about the animation changes.
  weak var delegate: GFAnimationPreviewDelegate?
  
  /// Indicates whether the image view should use all the available height with the acpect ratio preserving.
  private var isHeightFillModeEnabled = false
  /// Indicates whether the observer of the animated image view was set.
  private var didSetObserver = false
  /// Indicates whether the cell is in double-sized mode.
  private var isDoubleSized = false
  
  // MARK: - IBOutlets
  /// Scroll view to make the image view zoomable.
  @IBOutlet var scrollView: UIScrollView!
  /// The image view sublass that is used to handle the GIF animation.
  @IBOutlet var animatedImageView: YYAnimatedImageView!
  /// Indicates that current cell's animation is being loaded.
  @IBOutlet var activityIndicator: UIActivityIndicatorView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    if !didSetObserver {
      animatedImageView.addObserver(self, forKeyPath: "currentAnimatedImageIndex", options: .New, context: &previewCellContext)
      didSetObserver = true
    }
  }
  
  override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
    if context == &previewCellContext {
      if let newAnimationIndex = change?[NSKeyValueChangeNewKey] as? Int {
        delegate?.collectionViewCell(self, didChangeAnimationPositionToIndex: newAnimationIndex)
      }
    } else {
      super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if !isDoubleSized {
      setZoomScalesAspectFit()
    }
    centerAnimation()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    animatedImageView.stopAnimating()
    animatedImageView.image = nil
    delegate = nil
  }
  
  deinit {
    if didSetObserver {
      animatedImageView.removeObserver(self, forKeyPath: "currentAnimatedImageIndex", context: &previewCellContext)
    }
  }
  
  // MARK: - Instance Methods
  /// Places the animation in the screen center.
  func centerAnimation() {
    animatedImageView.sizeToFit()
    let imageViewSize = animatedImageView.frame.size
    let scrollViewSize = bounds.size
    
    let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
    let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
    
    scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
  }
  
  /// Confitures scroll view zoom scale so that the entire image can be seen when fully zoomed out.
  func setZoomScalesAspectFit() {
    animatedImageView.sizeToFit()
    let imageViewSize = animatedImageView.image?.size ?? animatedImageView.frame.size
    scrollView.contentSize = imageViewSize
    
    let scrollViewSize = bounds.size
    let widthScale = scrollViewSize.width / imageViewSize.width
    let heightScale = scrollViewSize.height / imageViewSize.height
    let zoomScaleAspectFit = isHeightFillModeEnabled ? heightScale : min(widthScale, heightScale)
    
    scrollView.minimumZoomScale = zoomScaleAspectFit
    scrollView.zoomScale = zoomScaleAspectFit
    
    if isHeightFillModeEnabled {
      let visibleRect = scrollView.convertRect(scrollView.bounds, toView: animatedImageView)
      let contentOffsetX = (imageViewSize.width - visibleRect.width) / 2
      scrollView.contentOffset = CGPointMake(contentOffsetX, 0)
    }
  }
  
  /// Toggles zoom of the animation between normal and double size modes.
  func toggleZoomMode() {
    if (scrollView.zoomScale > scrollView.minimumZoomScale) {
      scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
      isDoubleSized = false
    } else {
      scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
      isDoubleSized = true
    }
  }
}

// MARK: - UIScrollViewDelegate
extension GFGifPreviewCell: UIScrollViewDelegate {
  
  func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
    return animatedImageView
  }
  
  func scrollViewDidZoom(scrollView: UIScrollView) {
    centerAnimation()
  }
  
  func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
    /// Do nothing. Must be implemented for zooming and panning to work. For more info see also `UIScrollView Class Reference`.
  }
}