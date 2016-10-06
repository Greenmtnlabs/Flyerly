//
//  GFEmbeddedAnimationSettingsTableViewController
//  GifFactoryApp
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit
import Photos

/// The enumeration that represents the animation settings text fields tags.
enum GFTextFieldTag: Int {
  case GifWidthTextFieldTag = 1
  case GifHeightTextFieldTag = 2
  case GifFramesDelayTimesTextFieldTag = 3
  case LoopCountTextFieldTag = 4
  case CroppingTextFieldTag = 5
}

/// The enumeration that represents the table view cells tags.
enum GFTableViewCellTag: Int {
  case GFAspectFitTableViewCell = 10
  case GFAspectFillTableViewCell = 20
}

/**
 *  The table view controller that is embedded in the main animation settings controller. It manages the animation settings the user can set and store as defaults.
 */
class GFEmbeddedAnimationSettingsTableViewController: UITableViewController, GFBackgroundAlertDismissing {
  // MARK: - GFBackgroundAlertDismissing
  var _backgroundAlertDismissingObserver: NSObjectProtocol?
  
  // MARK: Properties
  /// The view controller that presented this view controller.
  var gf_presentingViewController: GFAnimationSettingsViewController?
  /// Indicates whether the view is being dismissed.
  var isDisappearing = false
  
  // MARK: - IBOutlets
  @IBOutlet var widthTextField: UITextField!
  @IBOutlet var heightTextField: UITextField!
  @IBOutlet var frameDelayTextField: UITextField!
  @IBOutlet var widthSlider: UISlider!
  @IBOutlet var heightSlider: UISlider!
  @IBOutlet var loopCountTextField: UITextField!
  @IBOutlet var croppingTextField: UITextField!
  @IBOutlet var aspectFitTableViewCell: UITableViewCell!
  @IBOutlet var aspectFillTableViewCell: UITableViewCell!
  @IBOutlet var frameDelayStepper: UIStepper!
  @IBOutlet var loopCountStepper: UIStepper!
  @IBOutlet var preserveTransparencySwitch: UISwitch!
  @IBOutlet var croppingStepper: UIStepper!
  
  // MARK: - IBActions
  /// It is called when the slider value which determines the GIF width has been changed.
  @IBAction func widthSliderValueChanged(sender: AnyObject) {
    // Slider value is changed with the step 1.
    let kSliderStep = 1
    let slider = sender as! UISlider
    slider.value = round(slider.value / Float(kSliderStep)) * Float(kSliderStep)
    widthTextField.text = String(Int(slider.value))
  }
  
  /// It is called when the user has stopped dragging the slider that controls the GIF width value.
  @IBAction func widthSliderDidEndDragging(sender: AnyObject) {
    if let settingsManager = gf_presentingViewController?.settingsManager {
      // Store the animation width.
      let animationSize = settingsManager.animationDimensions()
      let slider = sender as! UISlider
      settingsManager.setAnimationDimensions(withWidth: Int(slider.value), andHeight: Int(animationSize.height))
      finalizeSettingsEditing()
    }
  }
  
  /// It is called when the slider value which determines the GIF height has been changed.
  @IBAction func heightSliderValueChanged(sender: AnyObject) {
    // Slider value is changed with the step 1.
    let kSliderStep = 1
    let slider = sender as! UISlider
    slider.value = round(slider.value / Float(kSliderStep)) * Float(kSliderStep)
    heightTextField.text = String(Int(slider.value))
  }
  
  /// It is called when the user has stopped dragging the slider that controls the GIF height value.
  @IBAction func heightSliderDidEndDragging(sender: AnyObject) {
    if let settingsManager = gf_presentingViewController?.settingsManager {
      // Store the animation height.
      let animationSize = settingsManager.animationDimensions()
      let slider = sender as! UISlider
      settingsManager.setAnimationDimensions(withWidth: Int(animationSize.width), andHeight: Int(slider.value))
      finalizeSettingsEditing()
    }
  }
  
  /// It is called when the stepper value which determines the GIF frame delay time has been changed.
  @IBAction func frameDelayStepperValueChanged(sender: AnyObject) {
    let stepper = sender as! UIStepper
    let currentValue = Int(stepper.value)
    frameDelayTextField.text = String(currentValue)
    // Store the animation delay time.
    gf_presentingViewController?.settingsManager?.setAnimationFrameDelayTime(Float(currentValue))
    finalizeSettingsEditing()
  }
  
  /// It is called when the stepper value which determines the GIF loop count has been changed.
  @IBAction func loopCountStepperValueChanged(sender: AnyObject) {
    let stepper = sender as! UIStepper
    loopCountTextField.text = String(Int(stepper.value))
    // Store the animation loop count.
    gf_presentingViewController?.settingsManager?.setAnimationLoopCount(Int(stepper.value))
    finalizeSettingsEditing()
  }
  
  /// It is called when the switch controlling the GIF frame transparency setting has been pressed.
  @IBAction func preserveTransparencySwitchPressed(sender: AnyObject) {
    let transparencySwitch = sender as! UISwitch
    // Store the preserving transparency flag.
    gf_presentingViewController?.settingsManager?.preservesTransparency(transparencySwitch.on)
    finalizeSettingsEditing()
  }
  
  /// It is called when the stepper value which determines the cropping level has been changed.
  @IBAction func croppingStepperValueChanged(sender: AnyObject) {
    let stepper = sender as! UIStepper
     let formattedValue = Double(stepper.value).sh_formatWithDecimalPlaces(1)
    croppingTextField.text = String(formattedValue)
    // Store the animation cropping level.
    gf_presentingViewController?.settingsManager?.setAnimationCroppingLevel(formattedValue)
    finalizeSettingsEditing()
  }
  
  // MARK: - View Controller
  override func viewDidLoad() {
    super.viewDidLoad()
    widthSlider.maximumValue = Float(kMaximumGifWidth)
    heightSlider.maximumValue = Float(kMaximumGifHeight)
    
    addBackgroundAlertDismissingObserver()
    restoreSettings()
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(true)
    isDisappearing = true
    view.endEditing(false)
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
  
  deinit {
    removeBackgroundAlertDismissingObserver()
  }
  
  // MARK: - Instance Methods
  /// Retrives the animation settings from the persistent storage.
  func restoreSettings() {
    if let settingsManager = gf_presentingViewController?.settingsManager {
      settingsManager.forcesPersistentSettingsLoading = !settingsManager.didDefaultSettingsChange
      
      let animationSize = settingsManager.animationDimensions()
      let animationWidth = Int(animationSize.width)
      let animationHeight = Int(animationSize.height)
      
      widthSlider.value = Float(animationWidth)
      heightSlider.value = Float(animationHeight)
      
      widthTextField.text = String(animationWidth)
      heightTextField.text = String(animationHeight)
      
      let frameDelay = settingsManager.animationFrameDelayTime()
      let frameDelayInMS = Int(NSDate.sh_secondsToMilliseconds(Double(frameDelay)))
      frameDelayTextField.text = String(frameDelayInMS)
      frameDelayStepper.value = Double(frameDelayInMS)
      
      let loopCount = settingsManager.animationLoopCount()
      loopCountTextField.text = String(loopCount)
      loopCountStepper.value = Double(loopCount)
      
      let preservesTransparency = settingsManager.preservesTransparency()
      preserveTransparencySwitch.setOn(preservesTransparency, animated: false)
      
      let croppingLevel = settingsManager.animationCroppingLevel()
      croppingTextField.text = String(croppingLevel)
      croppingStepper.value = croppingLevel
      
      let contentMode = settingsManager.animationContentMode()
      selectTableViewCell(withContentMode: contentMode)
      
      settingsManager.forcesPersistentSettingsLoading = false
      gf_presentingViewController?.setAsDefaultsButton.enabled = settingsManager.didDefaultSettingsChange
    } else {
      log.warning("Failed to restore the animation settings! Values from the storyboard will be used instead.")
    }
  }
  
  /// Selects the specified table view cell.
  ///
  /// - parameter contentMode: Content mode that defines how GIF frames will be resized.
  func selectTableViewCell(withContentMode contentMode: PHImageContentMode) {
    if contentMode == .AspectFit {
      aspectFitTableViewCell.accessoryType = .Checkmark
      aspectFillTableViewCell.accessoryType = .None
    } else if contentMode == .AspectFill {
      aspectFitTableViewCell.accessoryType = .None
      aspectFillTableViewCell.accessoryType = .Checkmark
    } else {
      log.warning("Failed to detect correct content mode!")
    }
  }
  
  /// Implements additional clean-up code to run after the animation settings were changed.
  func finalizeSettingsEditing() {
    gf_presentingViewController?.setAsDefaultsButton.enabled = true
    gf_presentingViewController?.settingsManager?.didDefaultSettingsChange = true
  }
}

// MARK: - UITextFieldDelegate
extension GFEmbeddedAnimationSettingsTableViewController: UITextFieldDelegate {
  
  /// Checks input digits for correctness.
  /// - parameter input: The input string for regular expression searching.
  /// - parameter regex: The regular expression that is used to check the string.
  /// - returns: Bool value indicating whether the given regex was found.
  func checkInput(input: String, withRegex regex: String) -> Bool {
    let trimmedReplacementString = input.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    let regexForEmptyString = regex
    let regexRange = trimmedReplacementString.rangeOfString(regexForEmptyString, options: .RegularExpressionSearch)
    if regexRange == nil { return false }
    return true
  }
  

  /**
   *  Indicateds whether the specified input value should be changed. The input value is considered to be a decimal number.
   *
   *  - parameter currentInput: The input string before inserting new characters.
   *  - parameter string: The resulting string after replacement.
   *  - parameter integralPartRegex: The regular expression that is used to check the integral part of the input decimal number.
   *  - parameter fractionalPartRegex: The regular expression that is used to check the fractional part of the input decimal number.
   *  - parameter resultingNumberRegex: The regular expression that is used to check the resulting input value.
   *  - parameter replacementPosition: A position where the new characters will be inserted.
   *  - parameter separator: A symbol used to separate the integer part from the fractional part of a number written in decimal form..
   *  - parameter fractionDependsOnIntegral: Indicates whether fractionalParteRegex or resultingNumberRegex should be applied to the resulting string.

   *  - returns: Bool value indicating whether a text field should accept current replacement string.
   *
   */
  func shouldChangeCurrentInput(currentInput: String, toString string: String, withIntegralPartRegex integralPartRegex: String, fractionalPartRegex: String, andResultingNumberRegex resultingNumberRegex: String, replacementPosition: Int, fractionDependsOnIntegral: Bool = false, decimalNumberSeparator separator: String = ".") -> Bool {
    let trimmedCurrentString = currentInput.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    // Main steps for validating float input value.
    //[1] If current input is empty only the integral part of a decimal number is allowed in accordance with the integralPartRegex.
    if trimmedCurrentString.isEmpty {
      return checkInput(string, withRegex: integralPartRegex)
    } else
      //[2] Check whether current input contains a decimal separator.
      if let dotRange = currentInput.rangeOfString(separator) {
      //[2.1] Get the decimal separator position.
        let dotPosition: Int = currentInput.startIndex.distanceTo(dotRange.startIndex)
      if replacementPosition <= dotPosition {
        //[2.2] Verify left side of a decimal number in accordance with the integralPartRegex.
        if fractionDependsOnIntegral {
          return checkInput(string, withRegex:resultingNumberRegex)
        } else {
          return checkInput(string.substringToIndex(string.startIndex.advancedBy(dotPosition + 1)), withRegex:integralPartRegex)
        }
      } else {
        //[2.3] Verify right side of a decimal number in accordance with the fractionalPartRegex.
        if fractionDependsOnIntegral {
          return checkInput(string, withRegex:resultingNumberRegex)

        } else {
          return checkInput(string.substringFromIndex(string.startIndex.advancedBy(dotPosition + 1)), withRegex:fractionalPartRegex)
        }
      }
    } else {
      //[3] When the current input doesn't contain a decimal separator we should check resulting string using integralPartRegex and resultingNumberRegex (in case when user has pasted text from somewhere).
      return checkInput(string, withRegex: integralPartRegex) == false ? checkInput(string, withRegex: resultingNumberRegex) : true
    }
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    // When the user deletes one or more characters, the replacement string is empty.
    if string.isEmpty { return true }
    
    // Set initial parameters.
    let currentString = textField.text ?? ""
    
    var resultingString = currentString
    resultingString.insertContentsOf(string.characters, at: currentString.startIndex.advancedBy(range.location))
  
    /// Checks whether the text field contains only the natural numbers (including zero).
    func doesTextFieldContainNaturalNumbersOnly() -> Bool {
      let decimalDigitCharacterSet = NSCharacterSet.decimalDigitCharacterSet()
      for character in string.characters {
        let characterRange = String(character).rangeOfCharacterFromSet(decimalDigitCharacterSet)
        if characterRange == nil { return false }
      }
      
      return true
    }
    
    switch textField.tag {
    case GFTextFieldTag.GifWidthTextFieldTag.rawValue:
      // Check string limit.
      if resultingString.characters.count > 4 { return false }
      
      // Validate Gif width text field.
      return doesTextFieldContainNaturalNumbersOnly()
      
    case GFTextFieldTag.GifHeightTextFieldTag.rawValue:
      // Check string limit.
      if resultingString.characters.count > 4 { return false }
      
      // Validate GIF height text field.
      return doesTextFieldContainNaturalNumbersOnly()
      
    case GFTextFieldTag.GifFramesDelayTimesTextFieldTag.rawValue:
      // More than a day for GIF delay times should be enough :)
      if resultingString.characters.count > 9 { return false }
      
      // Validate delay times text field.
      return doesTextFieldContainNaturalNumbersOnly()
    case GFTextFieldTag.LoopCountTextFieldTag.rawValue:
      // Check string limit.
      if resultingString.characters.count > 9 { return false }
      
      // Validate loop count text field.
      return doesTextFieldContainNaturalNumbersOnly()
      
    case GFTextFieldTag.CroppingTextFieldTag.rawValue:
      // Check string limit.
      if resultingString.characters.count > 3 { return false }
      
      // Validate cropping level text field.
      // This field requires values in the range from 0.0 to 1.0.
      let integralPartRegex = "^[01]$"
      let fractionalPartRegex = "^(?:(?:0[.][0-9]?)|(?:1[.]0?))$"
      let resultingNumberRegex = fractionalPartRegex
      
      return shouldChangeCurrentInput(currentString, toString: resultingString, withIntegralPartRegex: integralPartRegex, fractionalPartRegex: fractionalPartRegex, andResultingNumberRegex: resultingNumberRegex, replacementPosition: range.location, fractionDependsOnIntegral: true)
      
    default:
      break
    }
    
    return true
  }
  
  func textFieldShouldEndEditing(textField: UITextField) -> Bool {
    // When the view is disappearing we must end editing.
    if isDisappearing { return true }
    // If presenting view controller is nil it's impossible to save current values so we should end editing.
    guard let gf_presentingViewController = gf_presentingViewController else { return true }
    // Without the settings manager it makes no sense to continue editing.
    guard let settingsManager = gf_presentingViewController.settingsManager else { return true }
    
    // An alert indicates that something's wrong with the input values so we can't end editing.
    if presentedViewController is UIAlertController { return false }
    // Don't accept an empty input value.
    guard let currentInput = textField.text else { return false }
    
    switch textField.tag {
    case GFTextFieldTag.GifWidthTextFieldTag.rawValue:
      let numberFormatter = NSNumberFormatter()
      numberFormatter.allowsFloats = false
      let outputValue = numberFormatter.numberFromString(currentInput)
      if let outputValue = outputValue?.integerValue {
        if outputValue <= kMaximumGifWidth && outputValue > 0 {
          
          // Store the animation width.
          let animationSize = settingsManager.animationDimensions()
          settingsManager.setAnimationDimensions(withWidth: outputValue, andHeight: Int(animationSize.height))
          widthSlider.value = Float(outputValue)
          break
        }
      }
      
      UIAlertController.sh_showAlertFromViewController(gf_presentingViewController, withTitle: NSLocalizedString("Width Must Be an Integer Value in the Range 1-2048", comment: "Alert message for incorrect GIF's width input value."),
                                                       andMessage: nil)
      return false
      
      
    case GFTextFieldTag.GifHeightTextFieldTag.rawValue:
      let numberFormatter = NSNumberFormatter()
      numberFormatter.allowsFloats = false
      let outputValue = numberFormatter.numberFromString(currentInput)
      if let outputValue = outputValue?.integerValue {
        if outputValue <= kMaximumGifHeight && outputValue > 0 {
          
          // Store the animation height.
          let animationSize = settingsManager.animationDimensions()
          settingsManager.setAnimationDimensions(withWidth: Int(animationSize.width), andHeight: outputValue)
          heightSlider.value = Float(outputValue)
          break
        }
      }
      
      UIAlertController.sh_showAlertFromViewController(gf_presentingViewController, withTitle: NSLocalizedString("Height Must Be an Integer Value in the Range 1-2048", comment: "Alert message for incorrect GIF's height input value."),
                                                       andMessage: nil)
      return false
      
    case GFTextFieldTag.GifFramesDelayTimesTextFieldTag.rawValue:
      let frameDelayRegex = "^[0-9]{1,9}$"
      if checkInput(currentInput, withRegex: frameDelayRegex) {
        if let value = Int(currentInput) {
          // Store the animation frame delay value.
          settingsManager.setAnimationFrameDelayTime(Float(value))
          frameDelayStepper.value = Double(value)
          break
        }
      }
      
      UIAlertController.sh_showAlertFromViewController(self, withTitle: NSLocalizedString("Frame Delay Value is Incorrect", comment: "Alert message for incorrect frame delay input value."),
                                                       andMessage: nil)
      return false
      
    case GFTextFieldTag.LoopCountTextFieldTag.rawValue:
      let loopCountRegex = "^[0-9]{1,9}$"
      if checkInput(currentInput, withRegex: loopCountRegex) {
        if let value = Int(currentInput) {
          // Store the animation loop count.
          settingsManager.setAnimationLoopCount(value)
          loopCountStepper.value = Double(value)
          break
        }
      }
      
      UIAlertController.sh_showAlertFromViewController(self, withTitle: NSLocalizedString("Loop Count Value is Incorrect", comment: "Alert message for incorrect loop count input value."),
                                                       andMessage: nil)
      return false
      
      
    case GFTextFieldTag.CroppingTextFieldTag.rawValue:
      let croppingRegex = "^(?:(?:0[.][0-9])|(?:1[.]0))$"
      if checkInput(currentInput, withRegex: croppingRegex) {
        if let value = Double(currentInput) {
          // Store the animation cropping level.
          settingsManager.setAnimationCroppingLevel(value)
          croppingStepper.value = value
          break
        }
      }
      
      UIAlertController.sh_showAlertFromViewController(self, withTitle: NSLocalizedString("Cropping Value Must Be in the Range [0.0-1.0]", comment: "Alert message for incorrect GIF cropping input value."), andMessage: nil)
      return false
      
    default:
      break
    }
    
    // Additional clean-up after successful input.
    finalizeSettingsEditing()
    return true
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
}

// MARK: - UITableViewDelegate
extension GFEmbeddedAnimationSettingsTableViewController {
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let currentCell = tableView.cellForRowAtIndexPath(indexPath)
    guard let unwrappedCurrentCell = currentCell else { return }
    
    if unwrappedCurrentCell.tag == GFTableViewCellTag.GFAspectFitTableViewCell.rawValue  {
      selectTableViewCell(withContentMode: PHImageContentMode.AspectFit)
      gf_presentingViewController?.settingsManager?.setAnimationContentMode(.AspectFit)
      finalizeSettingsEditing()
    } else if unwrappedCurrentCell.tag == GFTableViewCellTag.GFAspectFillTableViewCell.rawValue {
      selectTableViewCell(withContentMode: PHImageContentMode.AspectFill)
      gf_presentingViewController?.settingsManager?.setAnimationContentMode(.AspectFill)
      finalizeSettingsEditing()
    }
  }
  
  /// Correctly configures properties of the static cells.
  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
                          forRowAtIndexPath indexPath: NSIndexPath)  {
    cell.backgroundColor = UIColor.sh_colorFromHexCode(Colors.BLACK)
  }
}