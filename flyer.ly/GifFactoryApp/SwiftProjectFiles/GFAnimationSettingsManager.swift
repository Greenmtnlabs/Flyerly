//
//  GFAnimationSettingsManager.swift
//  GifFactoryApp
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit
import Photos


/**
 *  Settings manager class provides an interface for interacting with a persistent user’s preferences regarding animation playing/saving parameters.
 */
class GFAnimationSettingsManager: NSObject {
  /// Ensures that the settings always loaded from the persistent storage (prevents using the cached values).
  var forcesPersistentSettingsLoading = false
  /// Indicates whether the default GIF settings were changed during the current session.
  var didDefaultSettingsChange = false
  
  // GIF file global properties keys.
  /// Key for the CGSize of each animation frame.
  private let kAnimationDimensionsKey = "AnimationDimensions"
  /// Pixel dimensions measure the total number of pixels along the GIF's width and height.
  private let defaultGifDimensions: CGSize = CGSizeMake(500, 540)
  /// Key for the number of times to repeat an animated sequence. 0 means loop forever.
  private let kAnimationLoopCountKey = "CGImagePropertyGIFLoopCount"
  /// Key for the desired cropping level which is used for removing unwanted areas from the GIF frames in the range from 0.0 to 1.0. The default value of 1.0 means the images will remain unchanged. 0.0 is treated the same way. 0.5 means remove half of the image.
  private let kAnimationCroppingLevelKey = "AnimationLCroppingLevelKey"
  /// Key for animation content mode (PHImageContentMode).
  private let kAnimationContentModeKey = "AnimationContentMode"
  /// Key for the amount of time in seconds to wait before displaying the next frame.
  ///
  /// - note: ImageIO clamps delay time values to 100ms if the GIF specifies a delay of less than 40ms.
  private let kAnimationFrameDelayTimeKey = "CGImagePropertyGIFDelayTime"
  /// Key for the boolean flag that indicates whether the transparency should be preserved for the images which support the alpha channel.
  private let kAnimationPreservesTransparencyKey = "AnimationPreservesTransparencyKey"
  
  /// Storage that is used to store/retrieve all the animation settings.
  private let persistentStorage = NSUserDefaults.standardUserDefaults()
  /// Temporary values that the user set during the animation creation.
  private var tempValues = [String: Any]()
  
  override init() {
    super.init()
  
    let defaultsDictionary: [String: AnyObject] = [
      kAnimationDimensionsKey: NSStringFromCGSize(defaultGifDimensions),
      kAnimationFrameDelayTimeKey: Float(NSDate.sh_millisecondsToSeconds(100)),
      kAnimationLoopCountKey: 0,
      kAnimationCroppingLevelKey: 1.0,
      kAnimationContentModeKey: PHImageContentMode.AspectFill.rawValue,
      kAnimationPreservesTransparencyKey: true
    ]
  
    persistentStorage.registerDefaults(defaultsDictionary)
  }
  
  /// Stores all the temporary values that were set by the user during the current session.
  func saveTempValues() {
    if let tempAnimationSize = tempValues[kAnimationDimensionsKey] as? CGSize {
      persistentStorage.setObject(NSStringFromCGSize(tempAnimationSize), forKey: kAnimationDimensionsKey)
    }
    
    if let tempDelayTime = tempValues[kAnimationFrameDelayTimeKey] as? Float {
      persistentStorage.setFloat(tempDelayTime, forKey: kAnimationFrameDelayTimeKey)
    }
    
    if let tempLoopCount = tempValues[kAnimationLoopCountKey] as? Int {
      persistentStorage.setInteger(tempLoopCount, forKey: kAnimationLoopCountKey)
    }
    
    if let tempContentMode = tempValues[kAnimationContentModeKey] as? Int {
      persistentStorage.setInteger(tempContentMode, forKey: kAnimationContentModeKey)
    }
    
    if let tempPreserveTransparencyFlag = tempValues[kAnimationPreservesTransparencyKey] as? Bool {
      persistentStorage.setBool(tempPreserveTransparencyFlag, forKey: kAnimationPreservesTransparencyKey)
    }
    
    if let tempCroppingLevel = tempValues[kAnimationCroppingLevelKey] as? Double {
      persistentStorage.setDouble(tempCroppingLevel, forKey: kAnimationCroppingLevelKey)
    }
  }
  
  /// Retrieves the GIF dimensions from the persistent storage or from the cache.
  ///
  /// - returns: The animation width and height settings.
  func animationDimensions() -> CGSize {
    if !forcesPersistentSettingsLoading {
      if let tempAnimationSize = tempValues[kAnimationDimensionsKey] as? CGSize {
        return tempAnimationSize
      }
    } else {
      tempValues.removeValueForKey(kAnimationDimensionsKey)
    }
    
    if let animationSize = persistentStorage.stringForKey(kAnimationDimensionsKey) {
      return CGSizeFromString(animationSize)
    } else {
      return defaultGifDimensions
    }
  }
  
  /**
   *  Sets the animation size values.
   *
   *  - parameter width: Width value for the GIF animation.
   *  - parameter height: Height value for the GIF animation.
   *
   */
  func setAnimationDimensions(withWidth width: Int, andHeight height: Int) {
    if width > 0 && width <= kMaximumGifWidth && height > 0 && height <= kMaximumGifHeight {
      let animationSize = CGSizeMake(CGFloat(width), CGFloat(height))
      tempValues[kAnimationDimensionsKey] = animationSize
    } else {
      log.warning("Failed to save the animation size values! Check your width and height parameters.")
    }
  }
  
  /// Retrieves the GIF global frame delay that is used for each frame from the persistent storage or from the cache.
  ///
  /// - returns: The animation delay time in seconds.
  ///
  /// - note: ImageIO for some reason requires this value to be Float.
  func animationFrameDelayTime() -> Float {
    if !forcesPersistentSettingsLoading {
      if let tempDelayTime = tempValues[kAnimationFrameDelayTimeKey] as? Float {
        return tempDelayTime
      }
    } else {
      tempValues.removeValueForKey(kAnimationFrameDelayTimeKey)
    }
    
    return persistentStorage.floatForKey(kAnimationFrameDelayTimeKey)
  }
  
  /**
   *  Sets the animation frame delay time.
   *
   *  - parameter delayTime: The GIF frames delay time in milliseconds.
   *
   */
  func setAnimationFrameDelayTime(delayTime: Float) {
    if delayTime < 0 {
      log.warning("Failed to set the animation delay time!")
    } else {
      tempValues[kAnimationFrameDelayTimeKey] = Float(NSDate.sh_millisecondsToSeconds(Double(delayTime)))
    }
  }
  
  /// Retrieves the GIF loop count settings from the persistent storage or from the cache.
  ///
  /// - returns: The animation loop count.
  func animationLoopCount() -> Int {
    if !forcesPersistentSettingsLoading {
      if let tempLoopCount = tempValues[kAnimationLoopCountKey] as? Int {
        return tempLoopCount
      }
    } else {
      tempValues.removeValueForKey(kAnimationLoopCountKey)
    }
    
    return persistentStorage.integerForKey(kAnimationLoopCountKey)
  }
  
  /**
   *  Sets the animation loop count parameter.
   *
   *  - parameter loopCount: The number of times to repeat an animated sequence. 0 means loop forever.
   *
   */
  func setAnimationLoopCount(loopCount: Int) {
    if loopCount >= 0  {
      tempValues[kAnimationLoopCountKey] = loopCount
    } else {
      log.warning("Failed to save the animation loop count value!")
    }
  }
  
  
  /// Retrieves the GIF global content mode that is used for each frame from the persistent storage or from the cache.
  ///
  /// - returns: The animation content mode.
  func animationContentMode() -> PHImageContentMode {
    if !forcesPersistentSettingsLoading {
      if let tempContentMode = tempValues[kAnimationContentModeKey] as? Int {
        return PHImageContentMode(rawValue: tempContentMode) ?? .AspectFit
      }
    } else {
      tempValues.removeValueForKey(kAnimationContentModeKey)
    }
    
    return PHImageContentMode(rawValue: persistentStorage.integerForKey(kAnimationContentModeKey)) ?? .AspectFit
  }
  
  /**
   *  Sets the animation content mode.
   *
   *  - parameter contentMode: The content mode for resizing GIF frames. AspectFit means each frame will hold original aspect ratio.
   *
   */
  func setAnimationContentMode(contentMode: PHImageContentMode) {
    if contentMode != .AspectFit && contentMode != .AspectFill {
      log.warning("Failed to set the animation content mode!")
    } else {
      tempValues[kAnimationContentModeKey] = contentMode.rawValue
    }
  }
  
  /// Retrieves the GIF transparency setting frame from the persistent storage or from the cache.
  ///
  /// - returns: Value that indicates whether the animation preserves the images transparency.
  func preservesTransparency() -> Bool {
    if !forcesPersistentSettingsLoading {
      if let tempPreservesTransparencyFlag = tempValues[kAnimationPreservesTransparencyKey] as? Bool {
        return tempPreservesTransparencyFlag
      }
    }  else {
      tempValues.removeValueForKey(kAnimationPreservesTransparencyKey)
    }
    
    return persistentStorage.boolForKey(kAnimationPreservesTransparencyKey)
  }
  
  /**
   *  Sets whether the animation preserves the images transparency.
   *
   *  - parameter preservesTransparency: If true the images transparency will be preserved.
   *
   */
  func preservesTransparency(preservesTransparency: Bool) {
    tempValues[kAnimationPreservesTransparencyKey] = preservesTransparency
  }
  
  /// Retrieves the GIF cropping level value from the persistent storage or from the cache.
  ///
  /// - returns: The cropping level.
  func animationCroppingLevel() -> Double {
    if !forcesPersistentSettingsLoading {
      if let tempCroppingLevel = tempValues[kAnimationCroppingLevelKey] as? Double {
        return tempCroppingLevel
      }
    }   else {
      tempValues.removeValueForKey(kAnimationCroppingLevelKey)
    }
    
    return persistentStorage.doubleForKey(kAnimationCroppingLevelKey)
  }
  
  /**
   *  Sets the animation cropping level.
   *
   *  - parameter croppingLevel: The desired cropping level which is used for removing areas from the GIF frames. 0.5 means remove half of the image. 1.0 means use the unchanged image.
   *
   */
  func setAnimationCroppingLevel(croppingLevel: Double) {
    if croppingLevel >= 0.0 && croppingLevel <= 1.0 {
      tempValues[kAnimationCroppingLevelKey] = croppingLevel
    } else {
      log.warning("Failed to save the animation cropping level!")
    }
  }
}
