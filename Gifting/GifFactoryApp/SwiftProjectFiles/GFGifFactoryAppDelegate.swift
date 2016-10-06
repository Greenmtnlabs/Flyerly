//
//  GIfFactoryAppDelegate.swift
//  GifFactoryApp
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import UIKit
import XCGLogger
import CTAssetsPickerController
import SVProgressHUD
import YYWebImage
import VideoTrimmerView
import Firebase

@UIApplicationMain
class GifFactoryAppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    // Use helper extension for default logging configuration.
    XCGLogger.sh_configureDefaultLogger()
    
    // Customization of the main app theme.
    // Set main app tint color
    window!.tintColor = kGlobalTintColor
    
    // Customize navigation bar.
    let insets = UIEdgeInsetsMake(0, 0, 2, 0)
    let backButtonImage = UIImage(named: "BackButtonBackgroundImage")?.imageWithAlignmentRectInsets(insets)
    UINavigationBar.appearance().backIndicatorImage = backButtonImage
    UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
    UINavigationBar.appearance().barStyle = .Black
    UINavigationBar.appearance().barTintColor = UIColor.blackColor()
    UINavigationBar.appearance().tintColor = UIColor.whiteColor()
    
    var navigationBarTitleAttributes: [String : NSObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    if let navigationBarFont = UIFont(name: "ArialRoundedMTBold", size: 21) {
      navigationBarTitleAttributes[NSFontAttributeName] = navigationBarFont
    }
    UINavigationBar.appearance().titleTextAttributes = navigationBarTitleAttributes

    var barButtonAttributesNormal: [String : NSObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    var barButtonAttributesDisabled: [String : NSObject] = [NSForegroundColorAttributeName: UIColor(white: 0.0, alpha: 0.7)]

    if let barButtonFont = UIFont(name: "ArialRoundedMTBold", size: 16) {
      barButtonAttributesNormal[NSFontAttributeName] = barButtonFont
      barButtonAttributesDisabled[NSFontAttributeName] = barButtonFont
    }
    UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributesNormal, forState: .Normal)
    UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributesDisabled, forState: .Disabled)

    // Customize assets picker.
    var selectionLabelAttributes: [String : NSObject] = [NSForegroundColorAttributeName: UIColor.sh_colorFromHexCode(Colors.WHITE), NSBackgroundColorAttributeName: kGlobalTintColor]
    if let selectionLabelIndexFont = UIFont(name: kLeagueSpartanFontName, size: 15) {
      selectionLabelAttributes[NSFontAttributeName] = selectionLabelIndexFont
      CTAssetsGridViewFooter.appearance().font = selectionLabelIndexFont
    }
    CTAssetSelectionLabel.appearance().setTextAttributes(selectionLabelAttributes)
    CTAssetsGridViewFooter.appearance().textColor = UIColor.whiteColor()
    CTAssetsGridViewFooter.appearance().backgroundColor = UIColor.blackColor()

    // Customize progress indicator.
    SVProgressHUD.setMinimumDismissTimeInterval(1.0)
    SVProgressHUD.setDefaultStyle(.Custom)
    SVProgressHUD.appearance().foregroundColor = UIColor.blackColor()
    SVProgressHUD.appearance().backgroundColor = UIColor.whiteColor()

    if let progressFont = UIFont(name: kLeagueSpartanFontName, size: 18) {
      SVProgressHUD.appearance().font = progressFont
    }
    
    // Customize video trimmer view.
    VideoTrimmerView.trimmerAppearance.setTrimmerSlidersWidth(32.0)
    VideoTrimmerView.trimmerAppearance.setTrimmerSlidersHeightOffset(12.0)
    VideoTrimmerView.trimmerAppearance.setTrimmerSlidersBackgroundColor(UIColor.sh_colorFromHexCode("000000"))
    VideoTrimmerView.trimmerAppearance.setTrimmerSlidersTintColor(UIColor.whiteColor())
    VideoTrimmerView.trimmerAppearance.setDashboardBorderColor(UIColor.sh_colorFromHexCode("000000"))
    VideoTrimmerView.trimmerAppearance.setDashboardZoomButtonTintColor(UIColor.sh_colorFromHexCode("fefefe"))
    VideoTrimmerView.trimmerAppearance.setZoomOptionsViewBackgroundColor(UIColor.sh_colorFromHexCode("000000"))

    
    if let trimmerTimesFont = UIFont(name: "ArialRoundedMTBold", size: 12) {
      VideoTrimmerView.trimmerAppearance.setDashboardTimeFieldsFont(trimmerTimesFont)
    }
    
    // Configure the cache parameters.
    // Limit memory cache size to 100 mb.
    YYImageCache.sharedCache().memoryCache.costLimit = 100 * 1024 * 1024
    // Clear all the cached on disk assets in case they were not removed.
    YYImageCache.sharedCache().diskCache.removeAllObjects()
    
    // Configure Firebase.
    FIRApp.configure()
        
    return true
  }
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  
}

