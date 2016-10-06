//
//  UIImageHelper.swift
//  GifFactoryApp
//
//  DESCRIPTION:
//      Swift helper (SH) UIImage extension.
//
//  Created by Storix.
//  Copyright © 2016 Storix. All rights reserved.
//

import Foundation
import UIKit
import Photos
import CoreGraphics
import MobileCoreServices
import ImageIO
import YYWebImage


/// A string containing the error domain that defines the errors context for the `ConvertFramesToGIF` method.
private let kConvertFramesErrorDomain = "com.uiimagehelper.ConvertFramesToGIF"
/// String that is used to describe the purpose of the queue and is useful during debugging.
private let kCriticalSectionSerialQueueLabel = "com.uiimagehelper.CriticalSectionSerialQueue"

extension UIImage {
  
  /**
   *  Compresses the given image in accordance with the compression quality parameter.
   *
   *  - parameter image: The image you want to compress.
   *  - parameter compressionQuality: The compression quality that must be in the range from 0.0 to 1.0.
   *  - returns: Compressed image or nil if the operation wasn't successful.
   *
   */
  class func sh_compressImage(image: UIImage, compressionQuality: CGFloat) -> UIImage? {
    if compressionQuality < 0.0 || compressionQuality > 1.0 { return nil }
    
    let compressedImageData = UIImageJPEGRepresentation(image, compressionQuality)
    guard let unwrappedCompressedImageData = compressedImageData else { return nil }
    
    let compressedImage = UIImage(data: unwrappedCompressedImageData)
    
    return compressedImage
  }
  
  /**
   *  Verifies whether the image has an alpha channel.
   *
   *  - parameter image: The image you want to verify.
   *  - returns: Bool value that indicates whether the image has alpha.
   *
   */
  class func sh_doesImageHaveAlphaChannel(image: UIImage) -> Bool {
    if let cgImage = image.CGImage {
      let alphaInfo = CGImageGetAlphaInfo(cgImage)
      if alphaInfo == .None || alphaInfo == .NoneSkipFirst || alphaInfo == .NoneSkipLast {
       return false
      } else {
        return true
      }
    } else {
      return false
    }
  }
  
  /**
   *  Resizes the image with the new size using the given content mode and background color.
   *
   *  - parameter image: The image you want to redraw.
   *  - parameter contentMode:  Mode that defines fitting an image’s aspect ratio to a requested size.
   *  - parameter size: New size of the image in pixels.
   *  - parameter backgroundColor: The background color for the image.
   *  - returns: Resized image.
   *
   */
  class func sh_resizeImage(image: UIImage, withContentMode contentMode: PHImageContentMode, toSize size: CGSize, withBackgroundColor backgroundColor: UIColor, doesImageHaveAlphaChannel: Bool) -> UIImage {
    
    // As the size is already provided in pixels we must use the scale factor of 1.0.
    let scale: CGFloat = 1.0
    UIGraphicsBeginImageContextWithOptions(size, !doesImageHaveAlphaChannel, scale)
    
    // Fill background.
    backgroundColor.setFill()
    UIRectFill(CGRectMake(0, 0, size.width, size.height))
    
    // Draw the image in the center position.
    let widthScale = size.width / image.size.width
    let heightScale = size.height / image.size.height
    
    var scaleForNewSize: CGFloat = 1.0
    if contentMode == .AspectFit {
      scaleForNewSize = min(widthScale, heightScale)
    } else if contentMode == .AspectFill {
      scaleForNewSize = max(widthScale, heightScale)
    } else {
      log.warning("Failed to detect content mode to redraw animation frame!")
    }
    
    let newWidth = image.size.width * scaleForNewSize
    let newHeight = image.size.height * scaleForNewSize
    
    let xCoordinate: CGFloat = (size.width - newWidth) / 2
    let yCoordinate: CGFloat = (size.height - newHeight) / 2
    
    image.drawInRect(CGRectMake(xCoordinate, yCoordinate, newWidth, newHeight))
    let finalImage = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    return finalImage
  }
  
  /**
   *  Converts the given frames (images) to GIF format.
   *
   *  - parameter gifFrames: The gif frames which are used to retrieve images required for GIF creation.
   *  - parameter settingsManager: Settings manager object that is used to retrieve all the required properties of the animation frames.
   *  - parameter cancelHelper: The object that is used to provide the current operation identifier to the calling function to make it possible cancel the task on demand.
   *  - parameter resultHandler: A closure that is called when the animation is calculated. It provides error object to check whether the operation was completed successfully. Data object contains the calculated animation. It is called on main thread.
   *
   *  Error codes description.
   *
   *    - 800 - Empty gif frames array.
   *    - 810 - Cannot create CGImageDestination.
   *    - 811 - The image doesn't have a valid CGImage.
   *    - 820 - Request was Cancelled.
   *    - 821 - Cannot retrieve the image from the storage.
   *    - 830 - Failed to Finalize the Image Destination.
   *
   */
  class func sh_convertFramesToGif(gifFrames: [GFGifFrame], settingsManager: GFAnimationSettingsManager, cancelHelper: GFCancelOperationsHelper, resultHandler: ((data: NSData?, error: NSError?) -> Void)) -> Void {
    var convertionError: NSError?
    let kFramesCount: Int = gifFrames.count
    if kFramesCount <= 0 {
      convertionError = NSError(domain: kConvertFramesErrorDomain, code: 800, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("There are no Frames to Convert", comment: "The error concerning the empty input array with gif frames.")])
      resultHandler(data: nil, error: convertionError)
      return
    }
    
    let animationData = NSMutableData()
    
    // CGImageDestination abstracts the data-writing task.
    let destination: CGImageDestination? = CGImageDestinationCreateWithData(animationData, kUTTypeGIF, kFramesCount, nil)
    guard let unwrappedDestination = destination else {
      convertionError = NSError(domain: kConvertFramesErrorDomain, code: 810, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Failed to Create CGImageDestination", comment: "Description of the error that occurs when CGImageDestination cannot be created.")])
      resultHandler(data: nil, error: convertionError)
      return
    }
    
    // Set GIF output data properties.
    let loopCount = settingsManager.animationLoopCount()
    let outputProperties = [kCGImagePropertyGIFDictionary as String:
      [kCGImagePropertyGIFLoopCount as String: loopCount,
        kCGImagePropertyGIFHasGlobalColorMap as String: false] ]
    
    CGImageDestinationSetProperties(unwrappedDestination, outputProperties)
    
    
    // Add images associated with the asset to the destination.
    // Create dispatch group which is used to get notified when all PHImageManager requests are complete.
    let dispatchGroup = dispatch_group_create()
    
    // Create serial queue to synchronize PHImageMananger requests.
    let serialQueueAttributes = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, 0);
    var criticalSectionSerialQueue: dispatch_queue_t = dispatch_queue_create(kCriticalSectionSerialQueueLabel, serialQueueAttributes)
    
    // Get default image manager which is used across the app.
    let imageManager = PHImageManager.defaultManager()
    
    // Properties that is used to create the animation frames.
    let animationSize = settingsManager.animationDimensions()
    let animationContentMode = settingsManager.animationContentMode()
    let animationCroppingLevel = settingsManager.animationCroppingLevel()
    let animationFrameDelayTime = settingsManager.animationFrameDelayTime()

    // Configure requests options.
    let imageRequestOptions = PHImageRequestOptions()
    imageRequestOptions.resizeMode = .Exact
    imageRequestOptions.deliveryMode = .HighQualityFormat
    imageRequestOptions.networkAccessAllowed = true
    imageRequestOptions.synchronous = false
    imageRequestOptions.normalizedCropRect = CGRectMake(0, 0, CGFloat(animationCroppingLevel), CGFloat(animationCroppingLevel))
    
    // This var is used for correctly updating cancelHelper in the main thread.
    var imageRequestID: PHImageRequestID?
    
    // Access to this var must be synchronized.
    var currentFrameIndex = 0
    
    // Indicates whether the frames transparency should be preserved.
    let preservesTransparency = settingsManager.preservesTransparency()
    
    // Recursively requests images only if the previous request was without error.
    // - parameter asset: The image asset in the Photos Library.
    func asyncPhotosAssetRequest(asset: PHAsset) {
      dispatch_group_enter(dispatchGroup)
      dispatch_async(criticalSectionSerialQueue) {
        imageRequestID = imageManager.requestImageForAsset(asset, targetSize: animationSize, contentMode: animationContentMode, options: imageRequestOptions, resultHandler: {
          (image, info) -> Void in
          
          dispatch_async(dispatch_get_main_queue()) {
            // Reset current request id.
            cancelHelper.imageRequestID = nil
            imageRequestID = nil
            
            // Check whether all pending operations must be stopped.
            if cancelHelper.shouldStopOperations == false {
              var isRequestSuccessful = true
              
              if let info = info {
                // Error handling.
                if let imageRequestError = info[PHImageErrorKey] as? NSError {
                  isRequestSuccessful = false
                  convertionError = imageRequestError
                  
                } else if let isImageCancelled = info[PHImageCancelledKey] as? NSNumber where isImageCancelled == true {
                  // Handle request cancellation.
                  isRequestSuccessful = false
                  
                  convertionError = NSError(domain: kConvertFramesErrorDomain, code: 820, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Animation Frame Request was Cancelled", comment: "Description of the error that occurs when requestImageForAsset was cancelled.")])
                  
                }
              }
              
              // Add the animation frame to the destination if the request was successful.
              if isRequestSuccessful {
                addImageToGifSequence(image)
              }
            }
            
            // Notify dispatch group that current task is complete.
            dispatch_group_leave(dispatchGroup)
          }
        })
        
        dispatch_async(dispatch_get_main_queue()) {
          // Synchroniously update request id.
          cancelHelper.imageRequestID = imageRequestID
        }
      }
    }
    
    // Asynchronously get the image associated with a given key from the disk.
    // - parameter diskCacheKey: A string identifying the image.
    func asyncImageFromDiskRequest(diskCacheKey: String) {
      dispatch_group_enter(dispatchGroup)
      YYImageCache.sharedCache().getImageForKey(diskCacheKey, withType: .Disk) {
        image, type in
        
        dispatch_async(dispatch_get_main_queue()) {
          addImageToGifSequence(image)
          YYImageCache.sharedCache().memoryCache.removeObjectForKey(diskCacheKey)
          dispatch_group_leave(dispatchGroup)
        }
      }
    }
    
    // Adds the given image to the current positon in the GIF sequence. Current position is determined by the current frame index.
    // - parameter image: The image that must be added to the GIF.
    func addImageToGifSequence(image: UIImage?) {
      if var image = image {
        let doesImageHaveAlphaChannel = sh_doesImageHaveAlphaChannel(image)
        if  doesImageHaveAlphaChannel || image.size.width * image.scale < animationSize.width || image.size.height * image.scale < animationSize.height {
          
          let backgroundColor = currentFrameIndex > 0 && preservesTransparency && doesImageHaveAlphaChannel ? UIColor.clearColor() : UIColor.whiteColor()
          
          let correctedImageForAnimation = sh_resizeImage(image, withContentMode: animationContentMode, toSize: animationSize, withBackgroundColor: backgroundColor, doesImageHaveAlphaChannel: doesImageHaveAlphaChannel)
          image = correctedImageForAnimation
        }
        
        if let animationFrame = image.CGImage {
          // Create animation frame individual properties.
          let individualProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFDelayTime as String: animationFrameDelayTime]]
          
          CGImageDestinationAddImage(unwrappedDestination, animationFrame, individualProperties)
          
          // Recursively request next image.
          currentFrameIndex += 1
          if currentFrameIndex < gifFrames.count {
            requestFrameAtIndex(currentFrameIndex)
          }
          
        } else {
          // Handle incorrect CGImage error.
          convertionError = NSError(domain: kConvertFramesErrorDomain, code: 811, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Failed to Set the Animation Frame", comment: "Description of the error that occurs when image doesn't have a valid CGImage")])
        }
      } else {
        // Handle incorrect image error.
        convertionError = NSError(domain: kConvertFramesErrorDomain, code: 821, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Failed to Retrieve the Animation Frame", comment: "Description of the error that occurs when resultHandler has returned an incorrect image.")])
      }
    }

    // Starts requesting the gif frames from the given index in the gif frames array with the automatic gif source type detection.
    // - parameter idnex: Index in the array with the gif frames.
    func requestFrameAtIndex(index: Int) {
      if index < 0 || index > gifFrames.count {
        log.error("Failed to request gif frame because the given index is out of bounds.")
        return
      }
      
      if let photosAsset = gifFrames[index].photosAsset {
        asyncPhotosAssetRequest(photosAsset)
      } else if let diskCacheKey = gifFrames[index].fullsizedImageCachekey {
        asyncImageFromDiskRequest(diskCacheKey)
      } else {
        log.error("Failed to detect the gif frame source type.")
        return
      }
    }
    
    // Start requesting the images from the first index in the gif frames array.
    requestFrameAtIndex(0)
    
    // Asynchroniously call resultHandler closure after all requests are complete.
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue()) {
      if cancelHelper.shouldStopOperations == false {
        if convertionError == nil {
          if CGImageDestinationFinalize(unwrappedDestination) == false {
            convertionError = NSError(domain: kConvertFramesErrorDomain, code: 830, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Failed to Finalize the Image Destination", comment: "Animation finalizing error description")])
          }
        }
        
        resultHandler(data: animationData, error: convertionError)
      }
    }
  }
}