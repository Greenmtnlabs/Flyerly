//
//  ImageEditor.swift
//  PhotoFixx
//
//  Created by FV iMAGINATION on 24/03/16.
//  Copyright © 2016 FV iMAGINATION. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AudioToolbox


class ImageEditor: UIViewController,
UIScrollViewDelegate,
UIDocumentInteractionControllerDelegate,
GADBannerViewDelegate,
UIGestureRecognizerDelegate,
UIAlertViewDelegate
{

    /* Views */
    let adMobBannerView = GADBannerView()

    @IBOutlet weak var moveScaleOutlet: UIButton!
    
    @IBOutlet weak var filterPackOut1: UIButton!
    @IBOutlet weak var filterPackOut2: UIButton!
    @IBOutlet weak var filterPackOut3: UIButton!
    @IBOutlet weak var bordersContainerView: UIView!
    @IBOutlet weak var bordersScrollView: UIScrollView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var borderImage: UIImageView!
    @IBOutlet weak var originalImage: UIImageView!
    @IBOutlet weak var filteredImage: UIImageView!
    
    @IBOutlet weak var filteredImagesScrollView: UIScrollView!
    @IBOutlet weak var pageFilter: UIPageControl!
    
    @IBOutlet weak var toolbarView: UIView!
    
    
    
    
    
    /* Variables */
    var imagePassed = UIImage()
    
    var filtersArray = []
    var filterTitleArray = []
    var filterTitleArray2 = []
    var filterTitleArray3 = []
    var posX = CGFloat()
    let titleLabel2 = UILabel()
    
    let borderButton = UIButton()
    var buttonTag = Int()
    
    var combinedImage = UIImage()
    
    // For Filter Packs
    var filterPackNr = Int()
    var filterNr = Int()
    
    // Gestures to move and scale the edited Image
    var panGest = UIPanGestureRecognizer()
    var pinchGest = UIPinchGestureRecognizer()
    var rotateGest = UIRotationGestureRecognizer()
    
    // BOOLEANS
    var moveScaleON = Bool()
    var textButtON = Bool()

    
    
    
    
    
    
override func prefersStatusBarHidden() -> Bool {
    return true
}
    
override func viewDidLoad() {
        super.viewDidLoad()


    // Initializes AdMob banners
    initAdMobBanner()
    
    
    // Get the Image from Main Screen
    originalImage.image = imagePassed
    
    filterPackNr = 1
    
    
    // Resize Container View accordingly to the device used
    containerView.frame = CGRectMake(0, 44, view.frame.size.width, view.frame.size.width)
    filteredImagesScrollView.frame = CGRectMake(0, 44, view.frame.size.width, view.frame.size.width)
    toolbarView.frame = CGRectMake(0, containerView.frame.size.height+44, view.frame.size.width, 44)
    bordersContainerView.frame = CGRectMake(view.frame.size.width, containerView.frame.size.height+44, view.frame.size.width, 44);
    pageFilter.center = CGPointMake(containerView.frame.size.width/2, view.frame.size.width+37)
        
    
    
    // RESIZE AND SET THE IMAGE PASSED FROM MAIN SCREEN ================
    var actualHeight = Double(originalImage.image!.size.height)
    var actualWidth = Double(originalImage.image!.size.width)
    var imgRatio = actualWidth/actualHeight
    let maxRatio = 640.0/1136.0
    
    if imgRatio != maxRatio {
        if imgRatio < maxRatio {
            imgRatio = 1136.0 / actualHeight
            actualWidth = imgRatio * actualWidth
            actualHeight = 1136.0
        } else {
            imgRatio = 640.0 / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = 640.0;
        }
    }
    
    let rect = CGRectMake(0.0, 0.0, CGFloat(actualWidth), CGFloat(actualHeight))
    UIGraphicsBeginImageContext(rect.size)
    originalImage.image?.drawInRect(rect)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    originalImage.image = img
    
    
    
    // Add PAN & PINCH Gesture Recogn. to the Image =======
    pinchGest = UIPinchGestureRecognizer(target: self, action: #selector(imageDidPinch(_:)))
    panGest = UIPanGestureRecognizer(target: self, action: #selector(imageDidPan(_:)))
    rotateGest = UIRotationGestureRecognizer(target: self, action: #selector(imageDidRotate(_:)))
    filteredImage.addGestureRecognizer(pinchGest)
    filteredImage.addGestureRecognizer(panGest)
    filteredImage.addGestureRecognizer(rotateGest)
    
    
    
    // 1st Filter Pack Names Array ====================
    filterTitleArray = [
    "C1",
    "C2",
    "C3",
    "C4",
    "C5",
    ]
    // 2nd Filter Pack Names Array ===============
    filterTitleArray2 = [
    "Instant",
    "Process",
    "Transfer",
    "Sepia",
    "Fade",
    ]
    // 3nd Filter Pack Names Array ===============
    filterTitleArray3 = [
    "Noir",
    "Mono",
    "Dot",
    "Black",
    "White",
    ]
    //============================================================
    
    
    
    
    // Call 1st Filters Pack (Default)
    initFilters1()
    
    // Set number of pages for PageControl
    pageFilter.numberOfPages = filterTitleArray.count+1
    
    // Set the color of the 1st FilterPack button (since it's active)
    filterPackOut1.setTitleColor(UIColor(red: 201.0/255.20, green: 91.0/255.0, blue: 96.0/255.0, alpha: 1), forState: .Normal)
    
    
    // Setup FilterPack Buttons
    filterPackOut1.layer.cornerRadius = 5
    filterPackOut1.layer.borderColor = UIColor.whiteColor().CGColor
    filterPackOut1.layer.borderWidth = 1
    filterPackOut2.layer.cornerRadius = 5
    filterPackOut2.layer.borderColor = UIColor.whiteColor().CGColor
    filterPackOut2.layer.borderWidth = 1
    filterPackOut3.layer.cornerRadius = 5
    filterPackOut3.layer.borderColor = UIColor.whiteColor().CGColor
    filterPackOut3.layer.borderWidth = 1
    
    
    // For Borders Buttons
    buttonTag = 0
    setupBordersToolbar()
}
    
    
    
// MARK: - FILTERS SCROLLVIEW METHODS
func scrollViewDidScroll(scrollView: UIScrollView) {

    let pageWidth = filteredImagesScrollView.frame.size.width
    filterNr = Int(floor((filteredImagesScrollView.contentOffset.x * 2 + pageWidth) / (pageWidth * 2)))
    pageFilter.currentPage = filterNr
}
  
func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    if filterPackNr == 1 { applyFilter1()
    } else if filterPackNr == 2 { applyFilter2()
    } else if filterPackNr == 3 { applyFilter3() }
}
    
    
    
    
// MARK - INIT 1st FILTERS PACK
func initFilters1() {
    posX = 0
    
    filteredImagesScrollView.contentOffset = CGPointMake(0, 0)
    filteredImage.image = originalImage.image
    originalImage.hidden = true
    
    for subview in filteredImagesScrollView.subviews {
        subview.removeFromSuperview()
    }
    
    // LOOP
    for i in 0..<filterTitleArray.count {
        // var posX = CGFloat()
        posX = posX + view.frame.size.width
    
        let titleLabel1 = UILabel()
        titleLabel1.frame = CGRectMake(0, 270, view.frame.size.width, 30)
        titleLabel1.font = UIFont(name: "Mf Delicate Little Flower", size: 24)
        titleLabel1.textColor = UIColor.whiteColor()
        titleLabel1.shadowColor = UIColor.darkGrayColor()
        titleLabel1.shadowOffset = CGSizeMake(1, 1)
        titleLabel1.textAlignment = .Center
    	titleLabel1.text = "Original"
        filteredImagesScrollView.addSubview(titleLabel1)
    
    
        // Add a Label that shows the filter's name ===========
        let titleLabel2 = UILabel()
        titleLabel2.frame = CGRectMake(posX, 270, view.frame.size.width, 30)
        titleLabel2.font = UIFont(name: "Mf Delicate Little Flower", size: 24)
        titleLabel2.textColor = UIColor.whiteColor()
        titleLabel2.shadowColor = UIColor.darkGrayColor()
        titleLabel2.shadowOffset = CGSizeMake(1, 1)
        titleLabel2.textAlignment = .Center
        titleLabel2.text = "\(filterTitleArray[i])"
        filteredImagesScrollView.addSubview(titleLabel2)
    }
    
    // Populate the ScrollView with all the filteres images
    filteredImagesScrollView.contentSize = CGSizeMake(filteredImagesScrollView.frame.size.width * (CGFloat(filterTitleArray.count + 1) ), 320)
}
    
// MARK: - APPLY FILTER1
func applyFilter1() {
    // Load orignal image
    filteredImage.image = originalImage.image
    
    // Create filter
    let ciContext = CIContext(options: nil)
    let coreImage = CIImage(image: filteredImage.image!)
    let filter = CIFilter(name: "CIColorMonochrome")
    filter!.setDefaults()
    
    var r = CGFloat()
    var g = CGFloat ()
    var b = CGFloat ()
    var intensity = Float()
    
    
    switch (filterNr) {
    // NO Filter
    case 0:
        filteredImage.image = originalImage.image
        originalImage.hidden = true
    
    // 1st FILTER
    case 1:
    // PARAMETERS
    r = 255
    g = 128
    b = 128
    intensity = 0.5
    filter!.setValue(CIColor(red:r/255.0, green:g/255.0, blue:b/255.0), forKey: kCIInputColorKey)
    filter!.setValue(NSNumber(float: intensity), forKey:kCIInputIntensityKey)
    
    
    // 2nd FILTER ================
    case 2:
    // PARAMETERS
    r = 255
    g = 128
    b = 236
    intensity = 0.5
    filter!.setValue(CIColor(red:r/255.0, green:g/255.0, blue:b/255.0), forKey: kCIInputColorKey)
    filter!.setValue(NSNumber(float: intensity), forKey:kCIInputIntensityKey)
    
    
    // 3rd FILTER =================
    case 3:
    // PARAMETERS
    r = 128
    g = 152
    b = 255
    intensity = 0.5
    filter!.setValue(CIColor(red:r/255.0, green:g/255.0, blue:b/255.0), forKey: kCIInputColorKey)
    filter!.setValue(NSNumber(float: intensity), forKey:kCIInputIntensityKey)
    
    
    // 4th FILTER =================
    case 4:
    // PARAMETERS
    r = 128
    g = 255
    b = 137
    intensity = 0.5
    filter!.setValue(CIColor(red:r/255.0, green:g/255.0, blue:b/255.0), forKey: kCIInputColorKey)
    filter!.setValue(NSNumber(float: intensity), forKey:kCIInputIntensityKey)
    
    
    // 5th FILTER =================
    case 5:
    // PARAMETERS
    r = 245
    g = 255
    b = 128
    intensity = 0.5
    filter!.setValue(CIColor(red:r/255.0, green:g/255.0, blue:b/255.0), forKey: kCIInputColorKey)
    filter!.setValue(NSNumber(float: intensity), forKey:kCIInputIntensityKey)
    
    default: break }
    
    
    filter!.setValue(coreImage, forKey: kCIInputImageKey)
    let filteredImageData = filter!.valueForKey(kCIOutputImageKey) as! CIImage
    let filteredImageRef = ciContext.createCGImage(filteredImageData, fromRect: filteredImageData.extent)
    
    if (filterNr >= 1) { filteredImage.image = UIImage(CGImage: filteredImageRef!) }
    
}
    
    

// MARK: - INIT 2nd FILTERS PACK
func initFilters2() {
    posX = 0
    filteredImagesScrollView.contentOffset = CGPointMake(0, 0)
    filteredImage.image = originalImage.image
    originalImage.hidden = true
    
    
    for subview in filteredImagesScrollView.subviews {
        subview.removeFromSuperview()
    }
    
    
    // LOOP
    // var posX = CGFloat()
    for i in 0..<filterTitleArray2.count {
        posX = posX + view.frame.size.width
        
        let titleLabel1 = UILabel()
        titleLabel1.frame = CGRectMake(0, 270, view.frame.size.width, 30)
        titleLabel1.font = UIFont(name: "Mf Delicate Little Flower", size: 24)
        titleLabel1.textColor = UIColor.whiteColor()
        titleLabel1.shadowColor = UIColor.darkGrayColor()
        titleLabel1.shadowOffset = CGSizeMake(1, 1)
        titleLabel1.textAlignment = .Center
        titleLabel1.text = "Original"
        filteredImagesScrollView.addSubview(titleLabel1)
        
        
        // Add a Label that shows the filter's name ===========
        let titleLabel2 = UILabel()
        titleLabel2.frame = CGRectMake(posX, 270, view.frame.size.width, 30)
        titleLabel2.font = UIFont(name: "Mf Delicate Little Flower", size: 24)
        titleLabel2.textColor = UIColor.whiteColor()
        titleLabel2.shadowColor = UIColor.darkGrayColor()
        titleLabel2.shadowOffset = CGSizeMake(1, 1)
        titleLabel2.textAlignment = .Center
        titleLabel2.text = "\(filterTitleArray2[i])"
        filteredImagesScrollView.addSubview(titleLabel2)
    }

    // Populate the ScrollView with all the filteres images
    filteredImagesScrollView.contentSize = CGSizeMake(filteredImagesScrollView.frame.size.width * (CGFloat(filterTitleArray2.count + 1) ), 320)
}
    

// MARK: - APPLY FILTER2 METHOD
func applyFilter2() {
    // Load orignal image
    filteredImage.image = originalImage.image
    
    // Create filter
    let ciContext = CIContext(options: nil)
    let coreImage = CIImage(image: filteredImage.image!)
    var filter = CIFilter()
    
    
    switch (filterNr) {
    // NO Filter
    case 0:
        filteredImage.image = originalImage.image
        originalImage.hidden = true
    
    
    
    // 1st FILTER =============
    case 1:
    // PARAMETERS
    filter = CIFilter(name: "CIPhotoEffectInstant")!
    filter.setDefaults()
    
        
    // 2nd FILTER ================
    case 2:
    // PARAMETERS
    filter = CIFilter(name: "CIPhotoEffectProcess")!
    filter.setDefaults()
    
    // 3rd FILTER =================
    case 3:
    // PARAMETERS
    filter = CIFilter(name: "CIPhotoEffectTransfer")!
    filter.setDefaults()
    
    // 4th FILTER =================
    case 4:
    // PARAMETERS
    filter = CIFilter(name: "CISepiaTone")!
    filter.setDefaults()
    
    // 5th FILTER =================
    case 5:
    // PARAMETERS
    filter = CIFilter(name: "CIPhotoEffectFade")!
    filter.setDefaults()
    
    default: break }
    
    
    filter.setValue(coreImage, forKey: kCIInputImageKey)
    let filteredImageData = filter.valueForKey(kCIOutputImageKey) as! CIImage
    let filteredImageRef = ciContext.createCGImage(filteredImageData, fromRect: filteredImageData.extent)
    
    if filterNr >= 1 { filteredImage.image = UIImage(CGImage: filteredImageRef!) }
}
    
    
    
    
// MARK: - INIT 3rd FILTERS PACK
func initFilters3() {
    posX = 0
    filteredImagesScrollView.contentOffset = CGPointMake(0, 0)
    filteredImage.image = originalImage.image
    originalImage.hidden = true
    
    for subview in filteredImagesScrollView.subviews {
        subview.removeFromSuperview()
    }
    
    
    // LOOP
    for i in 0..<filterTitleArray.count {
       // var posX = CGFloat()
        posX = posX + view.frame.size.width
        
        let titleLabel1 = UILabel()
        titleLabel1.frame = CGRectMake(0, 270, view.frame.size.width, 30)
        titleLabel1.font = UIFont(name: "Mf Delicate Little Flower", size: 24)
        titleLabel1.textColor = UIColor.whiteColor()
        titleLabel1.shadowColor = UIColor.darkGrayColor()
        titleLabel1.shadowOffset = CGSizeMake(1, 1)
        titleLabel1.textAlignment = .Center
        titleLabel1.text = "Original"
        filteredImagesScrollView.addSubview(titleLabel1)
        
        
        // Add a Label that shows the filter's name ===========
        let titleLabel2 = UILabel()
        titleLabel2.frame = CGRectMake(posX, 270, view.frame.size.width, 30)
        titleLabel2.font = UIFont(name: "Mf Delicate Little Flower", size: 24)
        titleLabel2.textColor = UIColor.whiteColor()
        titleLabel2.shadowColor = UIColor.darkGrayColor()
        titleLabel2.shadowOffset = CGSizeMake(1, 1)
        titleLabel2.textAlignment = .Center
        titleLabel2.text = "\(filterTitleArray[i])"
        filteredImagesScrollView.addSubview(titleLabel2)
    }
    
    // Populate the ScrollView with all the filteres images
    filteredImagesScrollView.contentSize = CGSizeMake(filteredImagesScrollView.frame.size.width * (CGFloat(filterTitleArray.count + 1) ), 320)
    
}

    
// MARK: - APPLY FILTER3 METHOD
func applyFilter3()  {
    // Load orignal image
    filteredImage.image = originalImage.image
    
    // Create filter
    let ciContext = CIContext(options: nil)
    let coreImage = CIImage(image: filteredImage.image!)
    var filter = CIFilter()
    
    
    switch filterNr {
    // NO Filter
    case 0:
        filteredImage.image = originalImage.image
        originalImage.hidden = true
    
    
    // 1st FILTER =============
    case 1:
    // PARAMETERS
    filter = CIFilter(name: "CIPhotoEffectNoir")!
    filter.setDefaults()
    
    
    // 2nd FILTER =================
    case 2:
    // PARAMETERS
    filter = CIFilter(name: "CIPhotoEffectMono")!
    filter.setDefaults()
    
    
    // 2rd FILTER ================
    case 3:
    // PARAMETERS
    filter = CIFilter(name:  "CIDotScreen")!
    filter.setDefaults()
    let vct = CIVector(x: filteredImage.image!.size.width/2, y:filteredImage.image!.size.height/2)
    filter.setValue(vct, forKey: kCIInputCenterKey)
    filter.setValue(NSNumber(float: 5), forKey: kCIInputWidthKey)
    filter.setValue(NSNumber(float: 5), forKey: kCIInputAngleKey)
    filter.setValue(NSNumber(float: 0.7), forKey: kCIInputSharpnessKey)
    
    
    case 4:
    filter = CIFilter(name:  "CIColorMonochrome")!
    filter.setDefaults()
    // PARAMETERS
    let r:CGFloat = 5
    let g:CGFloat = 5
    let b:CGFloat = 5
    let intensity:Float = 1.0
    
    filter.setValue(CIColor(red: r/255.0, green: g/255.0, blue:b/255.0), forKey: kCIInputColorKey)
    filter.setValue(NSNumber(float: intensity), forKey: kCIInputIntensityKey)

    
    case 5:
    filter = CIFilter(name: "CIColorMonochrome")!
    filter.setDefaults()
    // PARAMETERS
    let r:CGFloat = 255
    let g:CGFloat = 255
    let b:CGFloat = 255
    let intensity:Float = 0.9
    
    filter.setValue(CIColor(red: r/255.0, green:g/255.0, blue:b/255.0), forKey: kCIInputColorKey)
    filter.setValue(NSNumber(float: intensity), forKey: kCIInputIntensityKey)
    
    default: break}
    
    
    filter.setValue(coreImage, forKey: kCIInputImageKey)
    let filteredImageData = filter.valueForKey(kCIOutputImageKey) as! CIImage
    let filteredImageRef = ciContext.createCGImage(filteredImageData, fromRect: filteredImageData.extent)
    
    if filterNr >= 1 { filteredImage.image = UIImage(CGImage: filteredImageRef!) }
    
}
    
    
    
    
    
// MARK: - SETUP BORDERS TOOLBAR
func setupBordersToolbar() {
    
    let buttonsQty = 20
    var xCoord:CGFloat = 0
    let yCoord:CGFloat = 0
    let buttonWidth:CGFloat = 44
    let buttonHeight:CGFloat = 44
    let gapBetweenButtons:CGFloat = 0
    
    // Loop for creating buttons
    for i in 1..<buttonsQty {
        buttonTag += 1
        let imageStr = "\(i)"
    
        let borderButton = UIButton(type: .Custom)
        borderButton.frame = CGRectMake(xCoord, yCoord, buttonWidth,buttonHeight);
        borderButton.tag = buttonTag
        borderButton.setBackgroundImage(UIImage(named: imageStr), forState: .Normal)
        borderButton.addTarget(self, action: #selector(bordersButtTapped(_:)), forControlEvents: .TouchUpInside)
        bordersScrollView.addSubview(borderButton)
    
        xCoord += buttonWidth + gapBetweenButtons
    }
    
    bordersScrollView.contentSize = CGSizeMake(buttonWidth * (CGFloat(buttonsQty)), yCoord)
}

    
func bordersButtTapped(sender:UIButton) {
    let butt = sender
    borderImage.image = UIImage(named: "\(butt.tag).png")
}
    
    
// MARK: - GESTURE RECOGNIZERS
func imageDidPinch(sender: UIPinchGestureRecognizer) {
    sender.view!.transform = CGAffineTransformScale(sender.view!.transform, sender.scale, sender.scale)
    sender.scale = 1
}
 
func imageDidPan(recognizer: UIPanGestureRecognizer) {
    let translation = recognizer.translationInView(view)
    recognizer.view!.center = CGPointMake(recognizer.view!.center.x + translation.x, recognizer.view!.center.y + translation.y)
    recognizer.setTranslation(CGPointMake(0, 0), inView: view)
}
    
func imageDidRotate(recognizer:UIRotationGestureRecognizer) {
    recognizer.view!.transform = CGAffineTransformRotate(recognizer.view!.transform, recognizer.rotation)
    recognizer.rotation = 0
}
    
    
    
    
    
    
// MARK: - FILTER PACK BUTTONS
@IBAction func filterPackButt1(sender: AnyObject) {
    filterPackNr = 1
    initFilters1()
    
    filterPackOut1.setTitleColor(UIColor.blackColor(), forState: .Normal)
    filterPackOut2.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    filterPackOut3.setTitleColor(UIColor.whiteColor(), forState: .Normal)
}
    
@IBAction func filterPackButt2(sender: AnyObject) {
    filterPackNr = 2
    initFilters2()
   
    filterPackOut1.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    filterPackOut2.setTitleColor(UIColor.blackColor(), forState: .Normal)
    filterPackOut3.setTitleColor(UIColor.whiteColor(), forState: .Normal)
}
    
@IBAction func filterPackButt3(sender: AnyObject) {
    filterPackNr = 3
    initFilters3()
        
    filterPackOut1.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    filterPackOut2.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    filterPackOut3.setTitleColor(UIColor.blackColor(), forState: .Normal)
}
    
    
    
    
// MARK: - OPEN BORDERS TOOLBAR
@IBAction func bordersButt(sender: AnyObject) {
    UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveLinear, animations: {
        self.bordersContainerView.frame = CGRectMake(0, self.containerView.frame.size.height + 44, self.view.frame.size.width, 44)
    }, completion: { (finished: Bool) in })
    
}

// MARK: - CLOSE BORDERS BUTTON
@IBAction func closeBordersButt(sender: AnyObject) {
    UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveLinear, animations: {
        self.bordersContainerView.frame = CGRectMake(self.view.frame.size.width, self.containerView.frame.size.height + 44, self.view.frame.size.width, 44)
    }, completion: { (finished: Bool) in })
}
    
    
    
    
// MARK: - MOVE & SCALE BUTTON
@IBAction func moveScaleButt(sender: AnyObject) {
    moveScaleON = !moveScaleON;
    
    if moveScaleON {
        filteredImagesScrollView.hidden = true
        moveScaleOutlet.setBackgroundImage(UIImage(named:"moveScaleButtON"), forState: .Normal)
    } else {
        filteredImagesScrollView.hidden = false
        moveScaleOutlet.setBackgroundImage(UIImage(named:"moveScaleButt"), forState: .Normal)
    }
}
    
    
    
    
    
// MARK: - SHARE IMAGE BUTTON
@IBAction func shareButt(sender: AnyObject) {
    // Crop a Combined Image from the edited picture
    let rect = containerView.bounds
    UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
    containerView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
    combinedImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    
    let messageStr = "Picture edited with #PhotoFixx - https://itunes.apple.com/us/app/instafixx/id903396250?l=it&ls=1&mt=8";
    let shareItems = [combinedImage , messageStr]
    
    let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
    activityViewController.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypePostToWeibo, UIActivityTypeCopyToPasteboard, UIActivityTypeAddToReadingList, UIActivityTypePostToVimeo]
    
    if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
        // iPad
        let popOver = UIPopoverController(contentViewController: activityViewController)
        popOver.presentPopoverFromRect(CGRectZero, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
    } else {
        // iPhone
        presentViewController(activityViewController, animated: true, completion: nil)
    }
}
    
    
   
    
// MARK: - INSTAGRAM BUTTON
@IBAction func instagramButt(sender: AnyObject) {
    // Crop a Combined Image from the edited picture
    let rect = containerView.bounds
    UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
    containerView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
    combinedImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    // Call function
    shareToInstagram()
}

    
var docIntController: UIDocumentInteractionController!
func shareToInstagram() {
    let instagramURL = NSURL(string: "instagram://app")!
    if UIApplication.sharedApplication().canOpenURL(instagramURL) {
            
            //Save the Image to default device Directory
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            let savedImagePath:String = paths.stringByAppendingString("/image.igo")
            let imageData: NSData = UIImageJPEGRepresentation(combinedImage, 1.0)!
            imageData.writeToFile(savedImagePath, atomically: false)
            
            //Load the Image Path
            let getImagePath = paths.stringByAppendingString("/image.igo")
            let fileURL: NSURL = NSURL.fileURLWithPath(getImagePath)
            
            
            docIntController = UIDocumentInteractionController(URL: fileURL)
            docIntController.UTI = "com.instagram.exclusivegram"
            docIntController.delegate = self
            docIntController.presentOpenInMenuFromRect(CGRectZero, inView: self.view, animated: true)
            
    } else {
        let alert = UIAlertView(title: "PhotoFixx",
        message: "Instagram not found, please download it on the App Store",
        delegate: nil,
        cancelButtonTitle: "OK")
        alert.show()
    }
}
        

    
// MARK: - ALERT VIEW DELEGATE
func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
    if alertView.buttonTitleAtIndex(buttonIndex) == "Exit" {
        filtersArray = []
        imagePassed = UIImage()
    
        navigationController?.popViewControllerAnimated(true)
    }
}
    
    
    
    
// MARK: - BACK BUTTON
@IBAction func backButt(sender: AnyObject) {
    UIAlertView(title: "PhotoFixx",
        message: "Are you sure you want to exit?",
        delegate: self,
        cancelButtonTitle: "Cancel",
        otherButtonTitles: "Exit").show()
}

    
    
    
    
    
    
    
    
// MARK: - AdMob BANNERS
    func initAdMobBanner() {
        adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSizeMake(320, 50))
        adMobBannerView.frame = CGRectMake(0, view.frame.size.height, view.frame.size.width, 50)
        adMobBannerView.adUnitID = ADMOB_UNIT_ID
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
        banner.frame = CGRectMake(view.frame.size.width/2 - banner.frame.size.width/2, view.frame.size.height - banner.frame.size.height, banner.frame.size.width, banner.frame.size.height)
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
}
}
