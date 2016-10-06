//
//  GFAnimationSettingsViewController.swift
//  GifFactoryApp
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit


/// View controller for handling settings of the animation you create in editor controller.
class GFAnimationSettingsViewController: UIViewController {
  // MARK: Properties
  /// Settings manager that is used to store/retrieve the animation global parameters.
  var settingsManager: GFAnimationSettingsManager?
  
  /// The embedded in the container view the animation settings table view controller.
  private var embeddedSettingsTableViewController: GFEmbeddedAnimationSettingsTableViewController?
  /// The identifier that is used to detect the embed segue to the animation settings controller.
  private let kGFAnimationSettingsEmbedSegueIdentifier = "GFAnimationSettingsEmbedSegue"
  
  // MARK: - IBOutlets
  /// The navigation bar for the settings controller view.
  @IBOutlet var settingsNavigationBar: UINavigationBar!
  /// The toolbar that is used to present buttons for reseting and saving GIF parameters.
  @IBOutlet var settingsToolbar: UIToolbar!
  /// Button that is used to reset the settings to the last saved values.
  @IBOutlet var resetButton: UIBarButtonItem!
  /// Button that is used to set current input values as defaults so that they will be loaded during the next GIF editing session.
  @IBOutlet var setAsDefaultsButton: UIBarButtonItem!
  /// The containter view that holds the table view with settings cells.
  @IBOutlet var containterView: UIView!
  /// The gesture recognizer used to dismiss the keyboard on tapping.
  @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
  
  // MARK: - IBActions
  /// Cancels animation settings view controller.
  ///
  /// - parameter sender: Button that is used to cancel the controller.
  @IBAction func closeSettingsController(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  /// It is called when the main view of the current controller has been tapped.
  @IBAction func mainViewTapped(sender: AnyObject) {
    containterView.endEditing(false)
  }
  
  /// It is called when the `Set As Defaults` button has been tapped.
  @IBAction func setAsDefaultsButtonTapped(sender: AnyObject) {
    setAsDefaultsButton.enabled = false

    settingsManager?.saveTempValues()
    settingsManager?.didDefaultSettingsChange = false
  }
  
  /// It is called when the `Reset` button has been tapped.
  @IBAction func resetButtonTapped(sender: AnyObject) {
    if let embeddedSettingsControler = embeddedSettingsTableViewController {
      settingsManager?.didDefaultSettingsChange = false
      embeddedSettingsControler.restoreSettings()
    }
  }
  
  // MARK: - View Controller
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
    
    setAsDefaultsButton.enabled = settingsManager?.didDefaultSettingsChange ?? false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Customize nav bar
    settingsNavigationBar.barTintColor = UIColor.sh_colorFromHexCode(Colors.BLACK)
    
    let navigationBarTitleAttributes = [NSForegroundColorAttributeName: UIColor.sh_colorFromHexCode(Colors.WHITE)]
    settingsNavigationBar.titleTextAttributes = navigationBarTitleAttributes
    
    // Customize tool bar
    settingsToolbar.tintColor = UIColor.sh_colorFromHexCode(Colors.BLACK)
    settingsToolbar.barTintColor = UIColor.sh_colorFromHexCode(Colors.BLACK)
    
    if let barButtonFont = UIFont(name: "ArialRoundedMTBold", size: 14) {
      
      let barButtonAttributes = [NSFontAttributeName: barButtonFont]
      resetButton.setTitleTextAttributes(barButtonAttributes, forState: .Normal)
      setAsDefaultsButton.setTitleTextAttributes(barButtonAttributes, forState: .Normal)
    }
    
    // Add observer for keyboard show and hide notifications.
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GFAnimationSettingsViewController.keyboardDidShow), name: UIKeyboardDidShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GFAnimationSettingsViewController.keyboardDidHide), name: UIKeyboardWillHideNotification, object: nil)
    tapGestureRecognizer.enabled = false
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if(segue.identifier == kGFAnimationSettingsEmbedSegueIdentifier) {
      let destinationController = segue.destinationViewController as! GFEmbeddedAnimationSettingsTableViewController
      destinationController.gf_presentingViewController = self
      self.embeddedSettingsTableViewController = destinationController
    }
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  // MARK: - Instance Methods
  /// It's called when the keyboard was shown.
  func keyboardDidShow() {
    tapGestureRecognizer.enabled = true
  }
  
  /// It's called when the keyboard was hidden.
  func keyboardDidHide() {
    tapGestureRecognizer.enabled = false
  }
}

// MARK: - UIGestureRecognizerDelegate
extension GFAnimationSettingsViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
    if touch.view is UISlider {
      return false
    }
    
    return true
  }
}
