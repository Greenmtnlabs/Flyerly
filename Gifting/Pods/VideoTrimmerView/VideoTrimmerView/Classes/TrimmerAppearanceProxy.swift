//
//  TrimmerAppearanceProxy.swift
//  Pods
//
//  Created by Storix on 6/28/16.
//  Copyright (c) 2016 Storix. All rights reserved.
//

import UIKit

/// Class that provides methods to get and set appearance related trimmer view properties.
public class TrimmerAppearanceProxy {
  
  // MARK: Appearance getters and setters
  // MARK: Trimmer sliders appearance
  /**
      Appearance proxy getter for the trimmer view sliders tint color.
   
      - returns: Trimmer view sliders tint color.
   */
  public func trimmerSlidersTintColor() -> UIColor {
    return SliderAppearance.tintColor
  }
  /**
      Appearance proxy setter for the trimmer view sliders tint color.
   
      - parameter color: User-defined color that is used as the trimmer sliders tint color.
   */
  public func setTrimmerSlidersTintColor(color: UIColor) {
    SliderAppearance.tintColor = color
  }
  /**
      Appearance proxy getter for the trimmer view sliders background color.
   
      - returns: Trimmer view sliders background color.
   */
  public func trimmerSlidersBackgroundColor() -> UIColor {
    return SliderAppearance.backgroundColor
  }
  /**
      Appearance proxy setter for the trimmer view sliders background color.
   
      - parameter color: User-defined color that is used as the trimmer sliders background color.
   */
  public func setTrimmerSlidersBackgroundColor(color: UIColor) {
    SliderAppearance.backgroundColor = color
  }
  /**
      Appearance proxy getter for the trimmer view sliders width.
   
      - returns: Trimmer view sliders width.
   */
  public func trimmerSlidersWidth() -> CGFloat {
    return SliderAppearance.width
  }
  /**
      Appearance proxy setter for the trimmer view sliders width.
   
      - parameter width: User-defined width of the trimmer view sliders.
   */
  public func setTrimmerSlidersWidth(width: CGFloat)  {
    SliderAppearance.width = width
  }
  /**
      Appearance proxy getter for the trimmer view sliders height offset.
   
      - returns: Trimmer view sliders height offset.
   */
  public func trimmerSlidersHeightOffset() -> CGFloat {
    return TrimmerAppearance.trimmerSlidersHeightOffset
  }
  /**
      Appearance proxy setter for the trimmer view sliders height offset.
   
      - parameter offset: User-defined height offset from the video frames collection view.
   */
  public func setTrimmerSlidersHeightOffset(offset: CGFloat) {
    TrimmerAppearance.trimmerSlidersHeightOffset = offset
  }
  
  // MARK: Trimmer view appearance
  /**
      Appearance proxy getter for the trimmer overlay views background color.
   
      - returns: Trimmer overlay views background color.
   */
  public func overlayViewsBackgroundColor() -> UIColor {
    return TrimmerAppearance.overlayViewsBackgroundColor
  }
  /**
      Appearance proxy setter for the trimmer overlay views background color.
   
      - parameter color: User-defined color that is used as the trimmer overlay views background color.
   */
  public func setOverlayViewsBackgroundColor(color: UIColor) {
    TrimmerAppearance.overlayViewsBackgroundColor = color
  }
  /**
      Appearance proxy getter for the trimmer overlay alpha value.
   
      - returns: Trimmer overlay views background color.
   */
  public func overlayViewsAlphaValue() -> CGFloat {
    return TrimmerAppearance.overlayViewsAlphaValue
  }
  /**
   Appearance proxy setter for the trimmer overlay alpha value.
   
   - parameter alpha: User-defined value that is used as the trimmer overlay views alpha.
   */
  public func setOverlayViewsAlphaValue(alpha: CGFloat) {
    TrimmerAppearance.overlayViewsAlphaValue = alpha
  }
  
  // MARK: Trimmer dashboard appearance
  /**
      Appearance proxy getter for the trimmer dashboard background color.
   
      - returns: Trimmer dashboard background color.
   */
  public func dashboardBackgroundColor() -> UIColor {
    return DashboardAppearance.backgroundColor
  }
  /**
      Appearance proxy setter for the trimmer dashboard background color.
   
      - parameter color: User-defined color that is used as the trimmer dashboard background color.
   */
  public func setDashboardBackgroundColor(color: UIColor) {
    DashboardAppearance.backgroundColor = color
  }
  /**
      Appearance proxy getter for the trimmer dashboard border color.
   
      - returns: Trimmer dashboard border color.
   */
  public func dashboardBorderColor() -> UIColor {
    return DashboardAppearance.borderColor
  }
  /**
      Appearance proxy setter for the trimmer dashboard border color.
   
      - parameter color: User-defined color that is used as the trimmer dashboard border color.
   */
  public func setDashboardBorderColor(color: UIColor) {
    DashboardAppearance.borderColor = color
  }
  /**
      Appearance proxy getter for the trimmer dashboard zoom button tint color.
   
      - returns: Trimmer dashboard zoom button color.
   */
  public func dashboardZoomButtonTintColor() -> UIColor {
    return CentralControlsAppearance.zoomButtonTintColor
  }
  /**
      Appearance proxy setter for the trimmer dashboard zoom button tint color.
   
      - parameter color: User-defined color that is used as the trimmer dashboard zoom button color.
   */
  public func setDashboardZoomButtonTintColor(color: UIColor) {
    CentralControlsAppearance.zoomButtonTintColor = color
  }
  /**
      Appearance proxy getter for the trimmer dashboard time text fields font.
   
      - returns: Trimmer dashboard text fields font.
   */
  public func dashboardTimeFieldsFont() -> UIFont {
    return DashboardAppearance.textFieldsFont
  }
  /**
      Appearance proxy setter for the trimmer dashboard time text fields font.
   
      - parameter font: User-defined font that is used as the trimmer dashboard text fields font.
   */
  public func setDashboardTimeFieldsFont(font: UIFont) {
    DashboardAppearance.textFieldsFont = font
  }
  /**
      Appearance proxy getter for the trimmer dashboard total time label font.
   
      - returns: Trimmer dashboard total time label font.
   */
  public func dashboardTotalTimeLabelFont() -> UIFont {
    return CentralControlsAppearance.totalTimeLabelFont
  }
  /**
      Appearance proxy setter for the trimmer dashboard total time label font.
   
      - parameter font: User-defined font that is used as the trimmer dashboard total time label font.
   */
  public func setDashboardTotalTimeLabelFont(font: UIFont) {
    CentralControlsAppearance.totalTimeLabelFont = font
  }
  
  // MARK: Trimmer zoom options view appearance
  /**
      Appearance proxy getter for the zoom options view background color.
   
      - returns: Zoom options view background color.
   */
  public func zoomOptionsViewBackgroundColor() -> UIColor {
    return ZoomOptionsAppearance.backgroundColor
  }
  /**
      Appearance proxy setter for the zoom options view background color.
   
      - parameter color: User-defined color that is used as the zoom options view background color.
   */
  public func setZoomOptionsViewBackgroundColor(color: UIColor) {
    ZoomOptionsAppearance.backgroundColor = color
  }
  /**
      Appearance proxy getter for the zoom options buttons `Normal` state color.
   
      - returns: Zoom options buttons `Normal` state color.
   */
  public func zoomOptionsButtonsNormalStateColor() -> UIColor {
    return ZoomOptionsAppearance.buttonsNormalStateColor
  }
  /**
      Appearance proxy setter for the zoom options buttons `Normal` state color.
   
      - parameter color: User-defined color that is used as the zoom options buttons `Normal` state color.
   */
  public func setZoomOptionsButtonsNormalStateColor(color: UIColor) {
    ZoomOptionsAppearance.buttonsNormalStateColor = color
  }
  /**
      Appearance proxy getter for the zoom options buttons `Selected` state color.
   
      - returns: Zoom options buttons `Selected` state color.
   */
  public func zoomOptionsButtonsSelectedStateColor() -> UIColor {
    return ZoomOptionsAppearance.buttonsSelectedStateColor
  }
  /**
      Appearance proxy setter for the zoom options buttons `Selected` state color.
   
      - parameter color: User-defined color that is used as the zoom options buttons `Selected` state color.
   */
  public func setZoomOptionsButtonsSelectedStateColor(color: UIColor) {
    ZoomOptionsAppearance.buttonsSelectedStateColor = color
  }
  
  /**
      Appearance proxy getter for the zoom options buttons font.
   
      - returns: Zoom options buttons font.
   */
  public func zoomOptionsButtonsFont() -> UIFont {
    return ZoomOptionsAppearance.buttonsFont
  }
  /**
      Appearance proxy setter for the zoom options buttons font.
   
      - parameter font: User-defined font that is used as the zoom options buttons font.
   */
  public func setZoomOptionsButtonsFont(font: UIFont) {
    ZoomOptionsAppearance.buttonsFont = font
  }
  
  // MARK: Trimmer activity view appearance
  /**
        Appearance proxy getter for the activity view background color.
   
      - returns: Activity view background color.
   */
  public func activityViewBackgroundColor() -> UIColor {
    return ActivityAppearance.backgroundColor
  }
  /**
      Appearance proxy setter for the activity view background color.
   
      - parameter color: User-defined color that is used as the activity view background color.
   */
  public func setActivityViewBackgroundColor(color: UIColor) {
    ActivityAppearance.backgroundColor = color
  }
  /**
      Appearance proxy getter for the activity indicator tint color.
   
      - returns: Activity indicator tint color.
   */
  public func activityIndicatorTintColor() -> UIColor {
    return ActivityAppearance.indicatorTintColor
  }
  /**
      Appearance proxy setter for the activity indicator tint color.
   
      - parameter color: User-defined color that is used as the activity indicator tint color.
   */
  public func setActivityIndicatorTintColor(color: UIColor) {
    ActivityAppearance.indicatorTintColor = color
  }
}