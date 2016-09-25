/*------------------------------------------

- Shoutes -

©2015 FV iMAGINATION
All Rights reserved

--------------------------------------------*/


import UIKit
import AVFoundation
import CoreLocation
import CoreMedia
import Social
import MessageUI
import GoogleMobileAds
import AudioToolbox



// MARK: - CUSTOM OVERLAY CELL
class OverlayCell: UICollectionViewCell {
    
    /* Views */
    @IBOutlet var oImage: UIImageView!
}





// MARK: - SHOTT CLASS
class Home: UIViewController,
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
CLLocationManagerDelegate,
UIDocumentInteractionControllerDelegate,
UIGestureRecognizerDelegate,
MFMailComposeViewControllerDelegate,
GADBannerViewDelegate
{

    /* Views */
    @IBOutlet weak var collViewContainer: UIView!
    @IBOutlet var overlaysCollView: UICollectionView!
    
    @IBOutlet var moreOutlet: UIButton!
    @IBOutlet weak var photoBar: UIView!
    
    @IBOutlet var sharingView: UIView!
    @IBOutlet var iconsView: UIView!
    @IBOutlet var shareButtons: [UIButton]!
    
    @IBOutlet weak var snapPicButt: UIButton!
    @IBOutlet weak var switchCameraOutlet: UIButton!
    @IBOutlet weak var flashOutlet: UIButton!
    @IBOutlet weak var libraryOutlet: UIButton!
    @IBOutlet weak var locationOutlet: UIButton!
    @IBOutlet weak var filtersButtOutlet: UIButton!
    @IBOutlet weak var overlaysButtOutlet: UIButton!
    
    @IBOutlet weak var filtersView: UIView!
    @IBOutlet weak var filtersScrollView: UIScrollView!
    
    @IBOutlet weak var imagePreviewView: UIView!
    @IBOutlet weak var captureImage: UIImageView!
    @IBOutlet weak var imageToFilter: UIImageView!
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var overlayImage: UIImageView!
    @IBOutlet var locationLabel: UILabel!
    
    let adMobBannerView = GADBannerView()

    
    
    
    /* Variables */
    var imageToBeSaved = UIImage()
    var imageForFilters = UIImage()
    
    // CoreLocation
    var locationManager = CLLocationManager()
    var isLocation = false

    // AVCapture
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var stillImageOutput: AVCaptureStillImageOutput?
    var frontCameraDev: AVCaptureDevice!
    var backCameraDev: AVCaptureDevice!
    var videoInputDevice: AVCaptureDeviceInput!
    
    // Booleans
    var pickerDidShow  = false
    var FrontCamera = false
    var FlashON = false
    var imgFromLibrary  = false
    var initializeCam  = false
    var photoFromCam  = false
    var imgFromCamera  = false
    
    //Overlay Image position
    var finalOverlayPoint: CGPoint?
    
    var filterButton = UIButton()
    var tagInt = 0
    var filterMenuIsOpen = false
    
    var docIntController = UIDocumentInteractionController()

    
    
    
    
    
// Hide the status bar
override func prefersStatusBarHidden() -> Bool {
    return true
}
func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
    UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
}
    
    
override func viewWillAppear(animated: Bool) {
    collViewContainer.frame.origin.y = view.frame.size.height
    
    // Build a Mutable Array that populates the Overlays CollectionView
    overlaysArray.removeAllObjects()

    // IAP HAS NOT BEEN MADE, SHOW FREE OVERLAYS
    if !IAP_MADE {
        for var i = 0;   i < FREE_OVERLAYS;    i++ {
            let overlayStr = "\(i)"
            overlaysArray.addObject(overlayStr)
            overlaysCollView.reloadData()
        }
        
        
    // IAP MADE, SHOW ALL OVERLAYS
    } else {
        moreOutlet.hidden = true
        
        for var i = 0;   i < ALL_OVERLAYS;   i++ {
            let overlayStr = "\(i)"
            overlaysArray.addObject(overlayStr)
            overlaysCollView.reloadData()
        }
    }
    
    print("IAP MADE: \(IAP_MADE)")
}
   
    
    
override func viewDidLoad() {
        super.viewDidLoad()
    
    // Resize Views accordingly to device screen size
    imagePreviewView.frame = CGRectMake(0, 64, view.frame.size.width, view.frame.size.width)
    captureImage.frame = CGRectMake(0, 64, view.frame.size.width, view.frame.size.width)
    imageToFilter.frame = CGRectMake(0, 64, view.frame.size.width, view.frame.size.width)
    overlayView.frame = CGRectMake(0, 64, view.frame.size.width, view.frame.size.width)

    
    sharingView.frame.origin.y = view.frame.size.height
    iconsView.layer.cornerRadius = 10
    
    // Setup Share Buttons
    var buttTAG = -1
    for butt in shareButtons {
        buttTAG++
        butt.tag = buttTAG
    }
    
    
    
    // Round snap picture button's corners
    snapPicButt.layer.cornerRadius = snapPicButt.bounds.size.width/2
    snapPicButt.layer.borderWidth = 1
    snapPicButt.layer.borderColor = aqua.CGColor
    
    
    // Set up some Views & Buttons
    pickerDidShow = false
    FrontCamera = false
    captureImage.hidden = false
    filtersButtOutlet.enabled = false
    isLocation = false
    
  
    // Add a PAN gesture to the overlay image
    let panGesture = UIPanGestureRecognizer(target: self, action: "moveImage:")
    overlayImage.addGestureRecognizer(panGesture)
    panGesture.delegate = self
    
    // Add a PINCH gesture to the overlay image
    let pinchGest = UIPinchGestureRecognizer(target: self, action: "zoomImage:")
    overlayImage.addGestureRecognizer(pinchGest)
    pinchGest.delegate = self
    
    
    // Keep tracking of the overlay Image position on the screen
    finalOverlayPoint = CGPointMake(overlayImage.frame.origin.x + (overlayImage.frame.size.width/2), overlayImage.frame.origin.y + overlayImage.frame.size.height);
    print( "finalPoint1: \(finalOverlayPoint)" )
    
    
    
    // Initialize Camera
    initializeCam = true
    photoFromCam = true
    initializeCamera()

    
    // Init ad banner
    if !IAP_MADE { initAdMobBanner()
    } else {  adMobBannerView.removeFromSuperview()  }
}


    
    
    
// MARK: - LOCATION MANAGER DELEGATES
func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    let errorAlert = UIAlertView(title: "Location",
    message: "Failed to Get Your Location",
    delegate: nil,
    cancelButtonTitle: "OK")
    errorAlert.show()
}
    
func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
    
    locationManager.stopUpdatingLocation()
    
    let geoCoder = CLGeocoder()
    geoCoder.reverseGeocodeLocation(newLocation, completionHandler: { (placemarks, error) -> Void in
        
        let placeArray:[CLPlacemark] = placemarks!
        var placemark: CLPlacemark!
        placemark = placeArray[0]
        
        // City
        let city = placemark.addressDictionary?["City"] as? String ?? ""
        // Country
        let country = placemark.addressDictionary?["Country"] as? String ?? ""
        
        // CONSOLE LOGS:
        //println("ADDRESS: \(street) - \(zip), \(city) - \(country) - \(state)")
           
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE, MMM d, h:mm a"
        let dateStr = dateFormatter.stringFromDate(currentDate)
        
        self.locationLabel.hidden = false
        self.locationLabel.text = "\(dateStr)\n\(city), \(country)"
    })
    
}
    


    
    
// MARK: - CAMERA INITIALIZATION
func initializeCamera() {
    
    // Remove all inputs and Outputs from the CaptureSession
    captureSession.beginConfiguration()
    captureSession.removeInput(videoInputDevice)
    captureSession.removeOutput(stillImageOutput)
    previewLayer?.removeFromSuperlayer()
    captureSession.commitConfiguration()
    captureSession.stopRunning()
    
    
    // Init AVCaptureSession
    captureSession.sessionPreset = AVCaptureSessionPresetHigh
    
    // Alloc and set the PreviewLayer for the camera
    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
    imagePreviewView.layer.addSublayer(previewLayer!)
    previewLayer?.frame = imagePreviewView.bounds
    
    
    // Create the 2 camera devices (Back & Front)
    let devices = AVCaptureDevice.devices()


    // Check if there's a Camera available
    if devices.count == 0 {
        print("NO CAMERA!")
        disableCameraDeviceControls()
        return
    }

    // Prepare the Back or Front Camera Devices
    for device in devices {
        if device.hasMediaType(AVMediaTypeVideo) {
            if device.position == AVCaptureDevicePosition.Back {
                backCameraDev = device as? AVCaptureDevice
            } else {
                frontCameraDev = device as? AVCaptureDevice
            }
        }
    }
    

    
    
    // BACK CAMERA Input
    if !FrontCamera {
        
        // Check if Back Camera has Flas
        if (backCameraDev?.isFlashModeSupported(AVCaptureFlashMode.On) != nil) {
            print("flashMode: \(backCameraDev!.flashMode.hashValue)")
            
            if backCameraDev?.flashAvailable == true {
                flashOutlet.enabled = true
                do { try backCameraDev?.lockForConfiguration()
                } catch _ { }
                if FlashON {
                    backCameraDev?.flashMode = AVCaptureFlashMode.On
                } else {
                    backCameraDev?.flashMode = AVCaptureFlashMode.Off
                    backCameraDev?.unlockForConfiguration()
                }
                
            } else {  flashOutlet.enabled = false  }
            
            do { videoInputDevice = try AVCaptureDeviceInput(device: backCameraDev)
            } catch  { videoInputDevice = nil }
            captureSession.addInput(videoInputDevice)
        }
    } // END BACK CAMERA Input

    
    
    
    
    // FRONT CAMERA Input
    if FrontCamera {
        flashOutlet.enabled = false
        
        do { videoInputDevice = try AVCaptureDeviceInput(device: frontCameraDev)
        } catch  { videoInputDevice = nil }
        captureSession.addInput(videoInputDevice)
    } // END FRONT CAMERA Input
    
    
    
    // Process StillImageOutput
    if stillImageOutput != nil {
        stillImageOutput = nil
    }
    stillImageOutput = AVCaptureStillImageOutput()
    let outputSettings: NSDictionary = NSDictionary(object: AVVideoCodecJPEG, forKey: AVVideoCodecKey)
    stillImageOutput?.outputSettings = outputSettings as [NSObject : AnyObject]
    captureSession.addOutput(stillImageOutput)
    
    
    
    // Set up some Views & Buttons =====
    imageToFilter.image = nil
    filterMenuIsOpen = false
    filtersButtOutlet.enabled = false
    switchCameraOutlet.enabled = true
    hideFiltersView()
    
    
    captureSession.startRunning()
    print("flash1: \(FlashON)")

}


    

// MARK: - Disable Camera Controls
func disableCameraDeviceControls() {
    switchCameraOutlet.enabled = false
    flashOutlet.enabled = false
    snapPicButt.enabled = false
}


    
    
// MARK: - SWITCH FRONT/BACK CAMERA BUTTON
@IBAction func switchCameraButt(sender: AnyObject) {
    captureSession.stopRunning()
    FrontCamera = !FrontCamera
    print("frontCam: \(FrontCamera)")

    // Check multiple cameras (Front and Back)
    if AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo).count > 1  {
        
        // Remove all inputs and Outputs from the CaptureSession
        captureSession.beginConfiguration()
        captureSession.removeInput(videoInputDevice)
        captureSession.removeOutput(stillImageOutput)
        previewLayer?.removeFromSuperlayer()
        captureSession.commitConfiguration()
        
        // Recall the camera initialization
        dispatch_after(1, dispatch_get_main_queue(), {
            self.initializeCamera()
        })
    }
    
}
    

    
// MARK: - FLASH BUTTON
@IBAction func flashButt(sender: AnyObject) {
    FlashON = !FlashON
    print("flash: \(FlashON)")
    
    
    // BACK Camera with Flash available
    if !FrontCamera {
        // In case the Back camera has Flash
        if backCameraDev?.isFlashModeSupported(AVCaptureFlashMode.On) != nil {
            do {
                try backCameraDev?.lockForConfiguration()
            } catch _ {
            }
            
            if FlashON { // Flash ON
                backCameraDev?.flashMode = AVCaptureFlashMode.On
                flashOutlet.setBackgroundImage(UIImage(named: "flashON"), forState: UIControlState.Normal)
            } else {  // Flash OFF
                backCameraDev?.flashMode = AVCaptureFlashMode.Off
                backCameraDev?.unlockForConfiguration()
                flashOutlet.setBackgroundImage(UIImage(named: "flashOFF"), forState: UIControlState.Normal)
            }
        }
    }

    
    
}
    
    
    
    
// MARK: - OPEN OVERLAYS BUTTON
@IBAction func overlaysButt(sender: AnyObject) {
    showOverlaysTableView()
}


// MARK: - CLOSE OVERLAYS VIEW BUTTON
@IBAction func closeOverlaysButt(sender: AnyObject) {
    hideOverlaysTableView()
}
    
    
// MARK: - FILTERS BUTTON
@IBAction func filtersButt(sender: AnyObject) {
    filterMenuIsOpen = !filterMenuIsOpen
    // println("filterMenuIsOpen: \(filterMenuIsOpen)");
    
    if filterMenuIsOpen {
        setupFiltersMenu()
        showFiltersView()
            
    } else {   hideFiltersView()  }
}
    

    
// MARK: - SNAP IMAGE BUTTON
@IBAction func snapImage(sender: AnyObject) {
    if !imgFromLibrary {
        captureImage.image = nil
        captureImage.hidden = false
        imagePreviewView.hidden = true
        
        // Call the process image method
        processImage()
        
        snapPicButt.setBackgroundImage(UIImage(named: "savePicButt"), forState: UIControlState.Normal)
        libraryOutlet.setBackgroundImage(UIImage(named: "snapPicButt"), forState: UIControlState.Normal)
        
    } else {  savePicture()  }
}

func processImage()  {
    if stillImageOutput != nil {
    
        let layer : AVCaptureVideoPreviewLayer = previewLayer! as AVCaptureVideoPreviewLayer
        stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo).videoOrientation = layer.connection.videoOrientation
        
    
    stillImageOutput?.captureStillImageAsynchronouslyFromConnection(stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo), completionHandler: { (imageDataSampleBuffer,error) -> Void in
            
        if ((imageDataSampleBuffer) != nil) {
            let imageData : NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
            
            // Show taken photo
            self.captureImage.image = UIImage(data: imageData)!
            
            // Flip the taken photo horizontally if it has been taken from Front Camera
            if self.FrontCamera {
                self.captureImage.image = UIImage(CGImage: (self.captureImage.image?.CGImage)!, scale: 1.0, orientation: UIImageOrientation.LeftMirrored)
            }
            
            // Set image for Filters
            self.imageForFilters =  self.captureImage.image!
            
            // Stop capture Session
            self.captureSession.stopRunning()
        }
    })
    
    } // end IF
    
 
    // Reset Bools and views
    imgFromCamera = true
    imgFromLibrary = true
    filtersButtOutlet.enabled = true
    flashOutlet.enabled = false
    
}
  
    
    
// SAVE PICTURE METHOD
func savePicture() {
    let rect = imagePreviewView.frame
    UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
    captureImage.layer.renderInContext(UIGraphicsGetCurrentContext()!)
    imageToFilter.layer.renderInContext(UIGraphicsGetCurrentContext()!)
    overlayView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
    imageToBeSaved = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    
    showSharingView()
}
    
    
    
// MARK: - LIBRARY BUTTON
@IBAction func libraryButt(sender: AnyObject) {
    print("IMAGE FROM CAMERA: \(imgFromCamera)")
    print("IMAGER FROM LIBRARY: \(imgFromLibrary)")
        
    if imgFromCamera == false && imgFromLibrary {
        captureImage.image = nil
        imagePreviewView.hidden = false
        imgFromLibrary = false
        imgFromCamera = false
        FrontCamera = false
        
        NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: Selector("initializeCamera"), userInfo: nil, repeats: false)
            
        snapPicButt.setBackgroundImage(UIImage(named: "snapPicButt"), forState: UIControlState.Normal)
        libraryOutlet.setBackgroundImage(UIImage(named: "libraryButt"), forState: UIControlState.Normal)
            
            
    // Pick an image from Photo library
    } else if imgFromCamera == false && imgFromLibrary == false {
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            imgPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imgPicker.allowsEditing = true;
            presentViewController(imgPicker, animated: true, completion: nil)
            
            
    // Re-initialize Camera
    } else if imgFromCamera && imgFromLibrary {
            captureImage.image = nil
            imagePreviewView.hidden = false;
            imgFromLibrary = false
            imgFromCamera = false
            FrontCamera = false
            
            NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: Selector("initializeCamera"), userInfo: nil, repeats: false)
            
            snapPicButt.setBackgroundImage(UIImage(named: "snapPicButt"), forState: UIControlState.Normal)
            libraryOutlet.setBackgroundImage(UIImage(named: "libraryButt"), forState: UIControlState.Normal)
    }
        
}

    

    
// MARK: - SETUP FILTERS MENU METHOD
func setupFiltersMenu() {
    // Variables for setting the buttons
    var xCoord: CGFloat = 5
    let yCoord: CGFloat = 10
    let buttonWidth:CGFloat = 60
    let buttonHeight: CGFloat = 60
    let gapBetweenButtons: CGFloat = 5
    var itemCount = 0
    
    // Loop for creating buttons
    for itemCount = 0;  itemCount < filtersArray.count;  itemCount++ {

    filterButton = UIButton(type: UIButtonType.Custom)
    filterButton.frame = CGRectMake(xCoord, yCoord, buttonWidth, buttonHeight)
    filterButton.tag = itemCount + 1000
    filterButton.showsTouchWhenHighlighted = true
    filterButton.addTarget(self, action: "filterButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    filterButton.clipsToBounds = true
    filterButton.layer.cornerRadius = filterButton.bounds.size.width/2


    if filterButton.tag == 0 + 1000  {
        // Set original taken image for the 1st button
        filterButton.setBackgroundImage(imageForFilters, forState: UIControlState.Normal)
   
    } else {
        // Create filters for the other buttons
        let context = CIContext(options: nil)
        let coreImage = CIImage(image: imageForFilters)
        let filter = CIFilter(name: "\(filtersArray[itemCount])" )
        filter!.setDefaults()
        
        if filter!.name == "CIColorMonochrome" {
            filter!.setValue(CIColor(red: 44.0/255.0, green: 127.0/255.0, blue: 205.0/255.0), forKey: kCIInputColorKey)
        }
        
        
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        let filteredImageData = filter!.valueForKey(kCIOutputImageKey) as! CIImage
        let filteredImageRef = context.createCGImage(filteredImageData, fromRect: filteredImageData.extent)
        var imageForButton = UIImage(CGImage: filteredImageRef);
    
        // Flip the image taken from Back Camera
        if imgFromCamera  &&  !FrontCamera {
            imageForButton = UIImage(CGImage: imageForButton.CGImage!, scale: 1.0, orientation: UIImageOrientation.Right)
        
        // Flip image taken with Front Camera
        } else if imgFromCamera &&  FrontCamera {
            imageForButton = UIImage(CGImage: imageForButton.CGImage!, scale: 1.0, orientation: UIImageOrientation.LeftMirrored)
        }
        
        // Assign a filtered image to the button
        filterButton.setBackgroundImage(imageForButton, forState: UIControlState.Normal)
    }
    
        
    // Add Buttons in the Scroll View
    xCoord +=  buttonWidth + gapBetweenButtons
    filtersScrollView.addSubview(filterButton)
    } // end FOR loop
    
    
    // Resize Scroll View
    filtersScrollView.contentSize = CGSizeMake(buttonWidth * CGFloat(itemCount+1), yCoord)
}


// FILTER BUTTON
func filterButtonTapped(sender: UIButton) {
    let button = sender as UIButton
    imageToFilter.image = button.backgroundImageForState(UIControlState.Normal)
}




    
// MARK - COLLECTION VIEW DELEGATES
func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
}

func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return overlaysArray.count
}

func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("OverlayCell", forIndexPath: indexPath) as! OverlayCell
    
    cell.oImage.image = UIImage(named: "\(indexPath.row).png")
    
return cell
}

func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    return CGSizeMake(view.frame.size.width/3.2, view.frame.size.width/3.2)
}

// MARK: - SELECT OVERLAY CELL
func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    overlayImage.image = UIImage(named: "\(overlaysArray[indexPath.row])")
    // hideOverlaysTableView()
}
   

    
    

// MARK: - OPEN IAP CONTROLLER BUTTON
@IBAction func moreButt(sender: AnyObject) {
    let iapVC = self.storyboard?.instantiateViewControllerWithIdentifier("IAPController") as! IAPController
    presentViewController(iapVC, animated: true, completion: nil)
}
    
    
    
    
// MARK: - LOCATION BUTTON
@IBAction func locationButt(sender: AnyObject) {
    let button = sender as! UIButton
    isLocation = !isLocation
    
    if isLocation {
        button.setBackgroundImage(UIImage(named: "locationOFF"), forState: UIControlState.Normal)
        
        // Init LocationManager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        if locationManager.respondsToSelector("requestWhenInUseAuthorization") {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startUpdatingLocation()
   
    } else {
        button.setBackgroundImage(UIImage(named: "locationON"), forState: UIControlState.Normal)
        locationLabel.hidden = true
    }
}
    
    
    
// MARK: - SHARE BUTTON
@IBAction func shareButtTapped(sender: AnyObject) {
    print("\(sender.tag)")
    
    switch sender.tag {
        case 0:  shareFacebook();  break
        case 1:  shareTwitter();  break
        case 2:  shareInstagram();  break
        case 3:  saveToLibrary();  break
        case 4:  shareMail();  break
        case 5:  shareWhatsApp();  break
        case 6:  shareOtherApps();  break
    default:break  }
}
    
// MARK: - DISMISS SHARE VIEW
@IBAction func dismissButt(sender: AnyObject) {
    hideSharingView()
}
    
    
    
// MARK: - FACEBOOK SHARE
func shareFacebook() {
    if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
        let fbSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        fbSheet.setInitialText(SHARING_MESSAGE)
        fbSheet.addImage(imageToBeSaved)
        self.presentViewController(fbSheet, animated: true, completion: nil)
    } else {
        let alert = UIAlertView(title: "Facebook", message: "Please login to your Facebook account in Settings", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
}

    
// MARK: -  TWITTER SHARE
func shareTwitter() {
    if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
        let twSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        twSheet.setInitialText(SHARING_MESSAGE)
        twSheet.addImage(imageToBeSaved)
        self.presentViewController(twSheet, animated: true, completion: nil)
    } else {
        let alert = UIAlertView(title: "Twitter", message: "Please login to your Twitter account in Settings", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
}


// MARK: - INSTAGRAM SHARE
func shareInstagram() {
    print("This code works only on REAL DEVICE. Please test it on iPhone!")

    let instagramURL = NSURL(string: "instagram://app")!
    if UIApplication.sharedApplication().canOpenURL(instagramURL) {
        
        //Save the Image to default device Directory
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let savedImagePath:String = paths.stringByAppendingString("/image.igo")
        let imageData: NSData = UIImageJPEGRepresentation(imageToBeSaved, 1.0)!
        imageData.writeToFile(savedImagePath, atomically: false)
        
        //Load the Image Path
        let getImagePath = paths.stringByAppendingString("/image.igo")
        let fileURL: NSURL = NSURL.fileURLWithPath(getImagePath)
        
        
        docIntController = UIDocumentInteractionController(URL: fileURL)
        docIntController.UTI = "com.instagram.exclusivegram"
        docIntController.delegate = self
        docIntController.presentOpenInMenuFromRect(CGRectZero, inView: self.view, animated: true)
        
    } else {
        let alert:UIAlertView = UIAlertView(title: APP_NAME,
            message: "Instagram not found, please download it on the App Store",
            delegate: nil,
            cancelButtonTitle: "OK")
        alert.show()
    }
    

}
    
    
    
// MARK: - SAVE PICTURE TO PHOTO LIBRARY
func saveToLibrary() {
    UIImageWriteToSavedPhotosAlbum(imageToBeSaved, nil, nil, nil)
    
    let alert = UIAlertView(title: APP_NAME,
    message: "Your picture has been saved into Photo library",
    delegate: nil,
    cancelButtonTitle: "OK")
    alert.show()
}
    
    
// MAKR: - SHARE BY EMAIL
func    shareMail() {
    let mailComposer = MFMailComposeViewController()
    mailComposer.mailComposeDelegate = self
    mailComposer.setSubject(APP_NAME)
    mailComposer.setMessageBody(SHARING_MESSAGE, isHTML: true)
    let imageData = UIImageJPEGRepresentation(imageToBeSaved, 1.0)
    mailComposer.addAttachmentData(imageData!, mimeType: "image/png", fileName: "\(APP_NAME).png")
    presentViewController(mailComposer, animated: true, completion: nil)
}
    
// Email delegate
func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?) {
    var outputMessage = ""
    switch result.rawValue {
    case MFMailComposeResultCancelled.rawValue:  outputMessage = "Mail cancelled"
    case MFMailComposeResultSaved.rawValue:  outputMessage = "Mail saved"
    case MFMailComposeResultSent.rawValue:  outputMessage = "Mail sent"
    case MFMailComposeResultFailed.rawValue: outputMessage = "Something went wrong with sending Mail, try again later."
    default:break  }
    
    let alert = UIAlertView(title: APP_NAME,
    message: outputMessage,
    delegate: nil,
    cancelButtonTitle: "Ok" )
    alert.show()
    
    self.dismissViewControllerAnimated(false, completion: nil)
}

    
// MARK: - WHATSAPP SHARE
func shareWhatsApp() {
    // NOTE: The following method works only on a Real device, not on iOS Simulator
    
    let whatsappURL = NSURL(string: "whatsapp://app")!
    if UIApplication.sharedApplication().canOpenURL(whatsappURL) {
        
        //Save the Image to default device Directory
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let savedImagePath:String = paths.stringByAppendingString("/image.wai")
        let imageData: NSData = UIImageJPEGRepresentation(imageToBeSaved, 0.6)!
        imageData.writeToFile(savedImagePath, atomically: false)
        
        //Load the Image Path
        let getImagePath = paths.stringByAppendingString("/image.wai")
        let fileURL: NSURL = NSURL.fileURLWithPath(getImagePath)
        
        // Open the Document Interaction controller for Sharing options
        docIntController.delegate = self
        docIntController.UTI = "net.whatsapp.image"
        docIntController = UIDocumentInteractionController(URL: fileURL)
        docIntController.presentOpenInMenuFromRect(CGRectZero, inView: self.view, animated: true)
        
    } else {
        let alert = UIAlertView(title: APP_NAME,
            message: "WhatsApp not found. Please install it on your device",
            delegate: nil,
            cancelButtonTitle: "OK")
        alert.show()
    }

}

    
    
// MARK: - SHARE TO OTHER APPS
func shareOtherApps() {
    // NOTE: The following method works only on a Real device, not on iOS Simulator, + You should have apps like Instagram, iPhoto, etc. already installed into your device!
    
    //Save the Image to default device Directory
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    let savedImagePath:String = paths.stringByAppendingString("/image.jpg")
    let imageData: NSData = UIImageJPEGRepresentation(imageToBeSaved, 1.0)!
    imageData.writeToFile(savedImagePath, atomically: false)
    
    //Load the Image Path
    let getImagePath = paths.stringByAppendingString("/image.jpg")
    let fileURL: NSURL = NSURL.fileURLWithPath(getImagePath)
    
    // Open the Document Interaction controller for Sharing options
    docIntController.delegate = self
    docIntController = UIDocumentInteractionController(URL: fileURL)
    docIntController.presentOpenInMenuFromRect(CGRectZero, inView: self.view, animated: true)
}

    
    
    
    

// MARK: - HIDE/SHOW SHARING VIEW
func showSharingView() {
    UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.sharingView.frame.origin.y = -12
    }, completion: { (finished: Bool) in
        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.sharingView.frame.origin.y = 0
            }, completion: { (finished: Bool) in  })
    })
}
func hideSharingView() {
    UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
        self.sharingView.frame.origin.y = self.view.frame.size.height
    }, completion: { (finished: Bool) in  })
}

    
    
    
// MARK: - SHOW/HIDE OVERLAY TABLEVIEW
func showOverlaysTableView() {
    UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
        self.collViewContainer.frame.origin.y = self.view.frame.size.height-280
        }, completion: {
        (finished: Bool) in
    })
}
    
func hideOverlaysTableView() {
    UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
        self.collViewContainer.frame.origin.y = self.view.frame.size.height
        }, completion: {
            (finished: Bool) in
    })
}
    


// MARK: - SHOW/HIDE FILTERS VIEW
func showFiltersView() {
    UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
    self.filtersView.frame.origin.y = self.photoBar.frame.origin.y - 80;
    }, completion: { (finished: Bool) in  })

}
    
func hideFiltersView() {
    UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
    self.filtersView.frame.origin.y = self.photoBar.frame.origin.y;
    }, completion: { (finished: Bool) in
        for var i = 0;  i < filtersArray.count;  i++ {
            self.view.viewWithTag(i + 1000)?.removeFromSuperview()
        }
    })
}
    
    
    
// MARK: - MOVE THE OVERLAY AROUND THE SCREEN
func moveImage(sender: UIPanGestureRecognizer) {
    
    let translation: CGPoint =  sender.translationInView(self.view)
    sender.view?.center = CGPointMake(sender.view!.center.x +  translation.x, sender.view!.center.y + translation.y)
    sender.setTranslation(CGPointMake(0, 0), inView: self.view)
    
}
    

    
// MARK: - ZOOM IMAGE ON PINCH
func zoomImage(sender: UIPinchGestureRecognizer) {

    if sender.state == UIGestureRecognizerState.Ended ||
       sender.state == UIGestureRecognizerState.Changed {
   
  //  println("SIZE: \(overlayImage.frame.size.width) - \(overlayImage.frame.size.height)")
    
    let currentScale = overlayImage.frame.size.width/overlayImage.bounds.size.width
    var newScale:CGFloat = currentScale * sender.scale

    if newScale < 1.0 {  newScale = 1.0  }
    if newScale > 1.6 {  newScale = 1.6  }
    
    let transform: CGAffineTransform = CGAffineTransformMakeScale(newScale, newScale)
    overlayImage.transform = transform
    sender.scale = 1
    }
    
}




// MARK: - IMAGE PICKER DELEGATE
func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
    let outputImage = info[UIImagePickerControllerEditedImage] as! UIImage
    
    // set CaptureImage & ImageToFilter
    captureImage.hidden = false
    captureImage.image = outputImage
    imageToFilter.image = outputImage
    imageForFilters = outputImage
    
    // Enable bottom bar Buttons
    filtersButtOutlet.enabled = true
    flashOutlet.enabled = false
    switchCameraOutlet.enabled = false
    
    // Set BOOL for image from camera or Library
    imgFromLibrary = true
    imgFromCamera = false
    // print("IMAGE FROM CAMERA 3: \(imgFromCamera)")
    // print("IMAGE FROM LIBRARY 2: \(imgFromLibrary)")
    
    // Change Snap Pic button's image
    snapPicButt.setBackgroundImage(UIImage (named: "savePicButt"), forState: UIControlState.Normal)
    libraryOutlet.setBackgroundImage(UIImage (named: "snapPicButt"), forState: UIControlState.Normal)
        
    dismissViewControllerAnimated(true, completion: nil)
}
    
func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    initializeCam = true
    picker.dismissViewControllerAnimated(true, completion: nil)
}

    

    
    
    
    
    
// MARK: - AdMob BANNERS
func initAdMobBanner() {
        adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSizeMake(320, 50))
        adMobBannerView.frame = CGRectMake(0, 0, 320, 50)
        adMobBannerView.adUnitID = ADMOB_BANNER_UNIT_ID
        adMobBannerView.rootViewController = self
        adMobBannerView.delegate = self
        view.addSubview(adMobBannerView)
        
        let request = GADRequest()
        adMobBannerView.loadRequest(request)
}
    
// Hide the banner
func hideBanner(banner: UIView) {
        UIView.beginAnimations("hideBanner", context: nil)
        banner.frame = CGRectMake(view.frame.size.width/2 - banner.frame.size.width/2, view.frame.size.height - banner.frame.size.height, banner.frame.size.width, banner.frame.size.height)
        UIView.commitAnimations()
        banner.hidden = true
}
    
// Show the banner
func showBanner(banner: UIView) {
        UIView.beginAnimations("showBanner", context: nil)
        banner.frame = CGRectMake(view.frame.size.width/2 - banner.frame.size.width/2, 64, banner.frame.size.width, banner.frame.size.height)
        UIView.commitAnimations()
        banner.hidden = false
}
    
    // AdMob banner available
    func adViewDidReceiveAd(view: GADBannerView!) {
        showBanner(adMobBannerView)
    }
    
    // NO AdMob banner available
    func adView(view: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        hideBanner(adMobBannerView)
    }
    

    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}
}
