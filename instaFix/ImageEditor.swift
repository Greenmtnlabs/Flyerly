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
    
    var filtersArray : NSArray = []
    var filterTitleArray : NSArray = []
    var filterTitleArray2 : NSArray = []
    var filterTitleArray3 : NSArray = []
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

    
    
    
    
    
    
override var prefersStatusBarHidden : Bool {
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
    containerView.frame = CGRect(x: 0, y: 44, width: view.frame.size.width, height: view.frame.size.width)
    filteredImagesScrollView.frame = CGRect(x: 0, y: 44, width: view.frame.size.width, height: view.frame.size.width)
    toolbarView.frame = CGRect(x: 0, y: containerView.frame.size.height+44, width: view.frame.size.width, height: 44)
    bordersContainerView.frame = CGRect(x: view.frame.size.width, y: containerView.frame.size.height+44, width: view.frame.size.width, height: 44);
    pageFilter.center = CGPoint(x: containerView.frame.size.width/2, y: view.frame.size.width+37)
        
    
    
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
    
    let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
    UIGraphicsBeginImageContext(rect.size)
    originalImage.image?.draw(in: rect)
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
    filterPackOut1.setTitleColor(UIColor(red: 201.0/255.20, green: 91.0/255.0, blue: 96.0/255.0, alpha: 1), for: UIControlState())
    
    
    // Setup FilterPack Buttons
    filterPackOut1.layer.cornerRadius = 5
    filterPackOut1.layer.borderColor = UIColor.white.cgColor
    filterPackOut1.layer.borderWidth = 1
    filterPackOut2.layer.cornerRadius = 5
    filterPackOut2.layer.borderColor = UIColor.white.cgColor
    filterPackOut2.layer.borderWidth = 1
    filterPackOut3.layer.cornerRadius = 5
    filterPackOut3.layer.borderColor = UIColor.white.cgColor
    filterPackOut3.layer.borderWidth = 1
    
    
    // For Borders Buttons
    buttonTag = 0
    setupBordersToolbar()
}
    
    
    
// MARK: - FILTERS SCROLLVIEW METHODS
func scrollViewDidScroll(_ scrollView: UIScrollView) {

    let pageWidth = filteredImagesScrollView.frame.size.width
    filterNr = Int(floor((filteredImagesScrollView.contentOffset.x * 2 + pageWidth) / (pageWidth * 2)))
    pageFilter.currentPage = filterNr
}
  
func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if filterPackNr == 1 { applyFilter1()
    } else if filterPackNr == 2 { applyFilter2()
    } else if filterPackNr == 3 { applyFilter3() }
}
    
    
    
    
// MARK - INIT 1st FILTERS PACK
func initFilters1() {
    posX = 0
    
    filteredImagesScrollView.contentOffset = CGPoint(x: 0, y: 0)
    filteredImage.image = originalImage.image
    originalImage.isHidden = true
    
    for subview in filteredImagesScrollView.subviews {
        subview.removeFromSuperview()
    }
    
    // LOOP
    for i in 0..<filterTitleArray.count {
        // var posX = CGFloat()
        posX = posX + view.frame.size.width
    
        let titleLabel1 = UILabel()
        titleLabel1.frame = CGRect(x: 0, y: 270, width: view.frame.size.width, height: 30)
        titleLabel1.font = UIFont(name: "Mf Delicate Little Flower", size: 24)
        titleLabel1.textColor = UIColor.white
        titleLabel1.shadowColor = UIColor.darkGray
        titleLabel1.shadowOffset = CGSize(width: 1, height: 1)
        titleLabel1.textAlignment = .center
    	titleLabel1.text = "Original"
        filteredImagesScrollView.addSubview(titleLabel1)
    
    
        // Add a Label that shows the filter's name ===========
        let titleLabel2 = UILabel()
        titleLabel2.frame = CGRect(x: posX, y: 270, width: view.frame.size.width, height: 30)
        titleLabel2.font = UIFont(name: "Mf Delicate Little Flower", size: 24)
        titleLabel2.textColor = UIColor.white
        titleLabel2.shadowColor = UIColor.darkGray
        titleLabel2.shadowOffset = CGSize(width: 1, height: 1)
        titleLabel2.textAlignment = .center
        titleLabel2.text = "\(filterTitleArray[i])"
        filteredImagesScrollView.addSubview(titleLabel2)
    }
    
    // Populate the ScrollView with all the filteres images
    filteredImagesScrollView.contentSize = CGSize(width: filteredImagesScrollView.frame.size.width * (CGFloat(filterTitleArray.count + 1) ), height: 320)
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
        originalImage.isHidden = true
    
    // 1st FILTER
    case 1:
    // PARAMETERS
    r = 255
    g = 128
    b = 128
    intensity = 0.5
    filter!.setValue(CIColor(red:r/255.0, green:g/255.0, blue:b/255.0), forKey: kCIInputColorKey)
    filter!.setValue(NSNumber(value: intensity as Float), forKey:kCIInputIntensityKey)
    
    
    // 2nd FILTER ================
    case 2:
    // PARAMETERS
    r = 255
    g = 128
    b = 236
    intensity = 0.5
    filter!.setValue(CIColor(red:r/255.0, green:g/255.0, blue:b/255.0), forKey: kCIInputColorKey)
    filter!.setValue(NSNumber(value: intensity as Float), forKey:kCIInputIntensityKey)
    
    
    // 3rd FILTER =================
    case 3:
    // PARAMETERS
    r = 128
    g = 152
    b = 255
    intensity = 0.5
    filter!.setValue(CIColor(red:r/255.0, green:g/255.0, blue:b/255.0), forKey: kCIInputColorKey)
    filter!.setValue(NSNumber(value: intensity as Float), forKey:kCIInputIntensityKey)
    
    
    // 4th FILTER =================
    case 4:
    // PARAMETERS
    r = 128
    g = 255
    b = 137
    intensity = 0.5
    filter!.setValue(CIColor(red:r/255.0, green:g/255.0, blue:b/255.0), forKey: kCIInputColorKey)
    filter!.setValue(NSNumber(value: intensity as Float), forKey:kCIInputIntensityKey)
    
    
    // 5th FILTER =================
    case 5:
    // PARAMETERS
    r = 245
    g = 255
    b = 128
    intensity = 0.5
    filter!.setValue(CIColor(red:r/255.0, green:g/255.0, blue:b/255.0), forKey: kCIInputColorKey)
    filter!.setValue(NSNumber(value: intensity as Float), forKey:kCIInputIntensityKey)
    
    default: break }
    
    
    filter!.setValue(coreImage, forKey: kCIInputImageKey)
    let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
    let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
    
    if (filterNr >= 1) { filteredImage.image = UIImage(cgImage: filteredImageRef!) }
    
}
    
    

// MARK: - INIT 2nd FILTERS PACK
func initFilters2() {
    posX = 0
    filteredImagesScrollView.contentOffset = CGPoint(x: 0, y: 0)
    filteredImage.image = originalImage.image
    originalImage.isHidden = true
    
    
    for subview in filteredImagesScrollView.subviews {
        subview.removeFromSuperview()
    }
    
    
    // LOOP
    // var posX = CGFloat()
    for i in 0..<filterTitleArray2.count {
        posX = posX + view.frame.size.width
        
        let titleLabel1 = UILabel()
        titleLabel1.frame = CGRect(x: 0, y: 270, width: view.frame.size.width, height: 30)
        titleLabel1.font = UIFont(name: "Mf Delicate Little Flower", size: 24)
        titleLabel1.textColor = UIColor.white
        titleLabel1.shadowColor = UIColor.darkGray
        titleLabel1.shadowOffset = CGSize(width: 1, height: 1)
        titleLabel1.textAlignment = .center
        titleLabel1.text = "Original"
        filteredImagesScrollView.addSubview(titleLabel1)
        
        
        // Add a Label that shows the filter's name ===========
        let titleLabel2 = UILabel()
        titleLabel2.frame = CGRect(x: posX, y: 270, width: view.frame.size.width, height: 30)
        titleLabel2.font = UIFont(name: "Mf Delicate Little Flower", size: 24)
        titleLabel2.textColor = UIColor.white
        titleLabel2.shadowColor = UIColor.darkGray
        titleLabel2.shadowOffset = CGSize(width: 1, height: 1)
        titleLabel2.textAlignment = .center
        titleLabel2.text = "\(filterTitleArray2[i])"
        filteredImagesScrollView.addSubview(titleLabel2)
    }

    // Populate the ScrollView with all the filteres images
    filteredImagesScrollView.contentSize = CGSize(width: filteredImagesScrollView.frame.size.width * (CGFloat(filterTitleArray2.count + 1) ), height: 320)
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
        originalImage.isHidden = true
    
    
    
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
    let filteredImageData = filter.value(forKey: kCIOutputImageKey) as! CIImage
    let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
    
    if filterNr >= 1 { filteredImage.image = UIImage(cgImage: filteredImageRef!) }
}
    
    
    
    
// MARK: - INIT 3rd FILTERS PACK
func initFilters3() {
    posX = 0
    filteredImagesScrollView.contentOffset = CGPoint(x: 0, y: 0)
    filteredImage.image = originalImage.image
    originalImage.isHidden = true
    
    for subview in filteredImagesScrollView.subviews {
        subview.removeFromSuperview()
    }
    
    
    // LOOP
    for i in 0..<filterTitleArray.count {
       // var posX = CGFloat()
        posX = posX + view.frame.size.width
        
        let titleLabel1 = UILabel()
        titleLabel1.frame = CGRect(x: 0, y: 270, width: view.frame.size.width, height: 30)
        titleLabel1.font = UIFont(name: "Mf Delicate Little Flower", size: 24)
        titleLabel1.textColor = UIColor.white
        titleLabel1.shadowColor = UIColor.darkGray
        titleLabel1.shadowOffset = CGSize(width: 1, height: 1)
        titleLabel1.textAlignment = .center
        titleLabel1.text = "Original"
        filteredImagesScrollView.addSubview(titleLabel1)
        
        
        // Add a Label that shows the filter's name ===========
        let titleLabel2 = UILabel()
        titleLabel2.frame = CGRect(x: posX, y: 270, width: view.frame.size.width, height: 30)
        titleLabel2.font = UIFont(name: "Mf Delicate Little Flower", size: 24)
        titleLabel2.textColor = UIColor.white
        titleLabel2.shadowColor = UIColor.darkGray
        titleLabel2.shadowOffset = CGSize(width: 1, height: 1)
        titleLabel2.textAlignment = .center
        titleLabel2.text = "\(filterTitleArray[i])"
        filteredImagesScrollView.addSubview(titleLabel2)
    }
    
    // Populate the ScrollView with all the filteres images
    filteredImagesScrollView.contentSize = CGSize(width: filteredImagesScrollView.frame.size.width * (CGFloat(filterTitleArray.count + 1) ), height: 320)
    
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
        originalImage.isHidden = true
    
    
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
    filter.setValue(NSNumber(value: 5 as Float), forKey: kCIInputWidthKey)
    filter.setValue(NSNumber(value: 5 as Float), forKey: kCIInputAngleKey)
    filter.setValue(NSNumber(value: 0.7 as Float), forKey: kCIInputSharpnessKey)
    
    
    case 4:
    filter = CIFilter(name:  "CIColorMonochrome")!
    filter.setDefaults()
    // PARAMETERS
    let r:CGFloat = 5
    let g:CGFloat = 5
    let b:CGFloat = 5
    let intensity:Float = 1.0
    
    filter.setValue(CIColor(red: r/255.0, green: g/255.0, blue:b/255.0), forKey: kCIInputColorKey)
    filter.setValue(NSNumber(value: intensity as Float), forKey: kCIInputIntensityKey)

    
    case 5:
    filter = CIFilter(name: "CIColorMonochrome")!
    filter.setDefaults()
    // PARAMETERS
    let r:CGFloat = 255
    let g:CGFloat = 255
    let b:CGFloat = 255
    let intensity:Float = 0.9
    
    filter.setValue(CIColor(red: r/255.0, green:g/255.0, blue:b/255.0), forKey: kCIInputColorKey)
    filter.setValue(NSNumber(value: intensity as Float), forKey: kCIInputIntensityKey)
    
    default: break}
    
    
    filter.setValue(coreImage, forKey: kCIInputImageKey)
    let filteredImageData = filter.value(forKey: kCIOutputImageKey) as! CIImage
    let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
    
    if filterNr >= 1 { filteredImage.image = UIImage(cgImage: filteredImageRef!) }
    
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
    
        let borderButton = UIButton(type: .custom)
        borderButton.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth,height: buttonHeight);
        borderButton.tag = buttonTag
        borderButton.setBackgroundImage(UIImage(named: imageStr), for: UIControlState())
        borderButton.addTarget(self, action: #selector(bordersButtTapped(_:)), for: .touchUpInside)
        bordersScrollView.addSubview(borderButton)
    
        xCoord += buttonWidth + gapBetweenButtons
    }
    
    bordersScrollView.contentSize = CGSize(width: buttonWidth * (CGFloat(buttonsQty)), height: yCoord)
}

    
func bordersButtTapped(_ sender:UIButton) {
    let butt = sender
    borderImage.image = UIImage(named: "\(butt.tag).png")
}
    
    
// MARK: - GESTURE RECOGNIZERS
func imageDidPinch(_ sender: UIPinchGestureRecognizer) {
    sender.view!.transform = sender.view!.transform.scaledBy(x: sender.scale, y: sender.scale)
    sender.scale = 1
}
 
func imageDidPan(_ recognizer: UIPanGestureRecognizer) {
    let translation = recognizer.translation(in: view)
    recognizer.view!.center = CGPoint(x: recognizer.view!.center.x + translation.x, y: recognizer.view!.center.y + translation.y)
    recognizer.setTranslation(CGPoint(x: 0, y: 0), in: view)
}
    
func imageDidRotate(_ recognizer:UIRotationGestureRecognizer) {
    recognizer.view!.transform = recognizer.view!.transform.rotated(by: recognizer.rotation)
    recognizer.rotation = 0
}
    
    
    
    
    
    
// MARK: - FILTER PACK BUTTONS
@IBAction func filterPackButt1(_ sender: AnyObject) {
    filterPackNr = 1
    initFilters1()
    
    filterPackOut1.setTitleColor(UIColor.black, for: UIControlState())
    filterPackOut2.setTitleColor(UIColor.white, for: UIControlState())
    filterPackOut3.setTitleColor(UIColor.white, for: UIControlState())
}
    
@IBAction func filterPackButt2(_ sender: AnyObject) {
    filterPackNr = 2
    initFilters2()
   
    filterPackOut1.setTitleColor(UIColor.white, for: UIControlState())
    filterPackOut2.setTitleColor(UIColor.black, for: UIControlState())
    filterPackOut3.setTitleColor(UIColor.white, for: UIControlState())
}
    
@IBAction func filterPackButt3(_ sender: AnyObject) {
    filterPackNr = 3
    initFilters3()
        
    filterPackOut1.setTitleColor(UIColor.white, for: UIControlState())
    filterPackOut2.setTitleColor(UIColor.white, for: UIControlState())
    filterPackOut3.setTitleColor(UIColor.black, for: UIControlState())
}
    
    
    
    
// MARK: - OPEN BORDERS TOOLBAR
@IBAction func bordersButt(_ sender: AnyObject) {
    UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
        self.bordersContainerView.frame = CGRect(x: 0, y: self.containerView.frame.size.height + 44, width: self.view.frame.size.width, height: 44)
    }, completion: { (finished: Bool) in })
    
}

// MARK: - CLOSE BORDERS BUTTON
@IBAction func closeBordersButt(_ sender: AnyObject) {
    UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
        self.bordersContainerView.frame = CGRect(x: self.view.frame.size.width, y: self.containerView.frame.size.height + 44, width: self.view.frame.size.width, height: 44)
    }, completion: { (finished: Bool) in })
}
    
    
    
    
// MARK: - MOVE & SCALE BUTTON
@IBAction func moveScaleButt(_ sender: AnyObject) {
    moveScaleON = !moveScaleON;
    
    if moveScaleON {
        filteredImagesScrollView.isHidden = true
        moveScaleOutlet.setBackgroundImage(UIImage(named:"moveScaleButtON"), for: UIControlState())
    } else {
        filteredImagesScrollView.isHidden = false
        moveScaleOutlet.setBackgroundImage(UIImage(named:"moveScaleButt"), for: UIControlState())
    }
}
    
    
    
    
    
// MARK: - SHARE IMAGE BUTTON
@IBAction func shareButt(_ sender: AnyObject) {
    // Crop a Combined Image from the edited picture
    let rect = containerView.bounds
    UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
    containerView.layer.render(in: UIGraphicsGetCurrentContext()!)
    combinedImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    
    let messageStr = "Picture edited with #PhotoFixx - https://itunes.apple.com/us/app/instafixx/id903396250?l=it&ls=1&mt=8";
    let shareItems = [combinedImage , messageStr] as [Any]
    
    let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
    activityViewController.excludedActivityTypes = [UIActivityType.print, UIActivityType.postToWeibo, UIActivityType.copyToPasteboard, UIActivityType.addToReadingList, UIActivityType.postToVimeo]
    
    if UIDevice.current.userInterfaceIdiom == .pad {
        // iPad
        let popOver = UIPopoverController(contentViewController: activityViewController)
        popOver.present(from: CGRect.zero, in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
    } else {
        // iPhone
        present(activityViewController, animated: true, completion: nil)
    }
}
    
    
   
    
// MARK: - INSTAGRAM BUTTON
@IBAction func instagramButt(_ sender: AnyObject) {
    // Crop a Combined Image from the edited picture
    let rect = containerView.bounds
    UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
    containerView.layer.render(in: UIGraphicsGetCurrentContext()!)
    combinedImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    // Call function
    shareToInstagram()
}

    
var docIntController: UIDocumentInteractionController!
func shareToInstagram() {
    let instagramURL = URL(string: "instagram://app")!
    if UIApplication.shared.canOpenURL(instagramURL) {
            
            //Save the Image to default device Directory
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let savedImagePath:String = paths + "/image.igo"
            let imageData: Data = UIImageJPEGRepresentation(combinedImage, 1.0)!
            try? imageData.write(to: URL(fileURLWithPath: savedImagePath), options: [])
            
            //Load the Image Path
            let getImagePath = paths + "/image.igo"
            let fileURL: URL = URL(fileURLWithPath: getImagePath)
            
            
            docIntController = UIDocumentInteractionController(url: fileURL)
            docIntController.uti = "com.instagram.exclusivegram"
            docIntController.delegate = self
            docIntController.presentOpenInMenu(from: CGRect.zero, in: self.view, animated: true)
            
    } else {
        let alert = UIAlertView(title: "PhotoFixx",
        message: "Instagram not found, please download it on the App Store",
        delegate: nil,
        cancelButtonTitle: "OK")
        alert.show()
    }
}
        

    
// MARK: - ALERT VIEW DELEGATE
func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
    if alertView.buttonTitle(at: buttonIndex) == "Exit" {
        filtersArray = []
        imagePassed = UIImage()
    
        navigationController?.popViewController(animated: true)
    }
}
    
    
    
    
// MARK: - BACK BUTTON
@IBAction func backButt(_ sender: AnyObject) {
    UIAlertView(title: "PhotoFixx",
        message: "Are you sure you want to exit?",
        delegate: self,
        cancelButtonTitle: "Cancel",
        otherButtonTitles: "Exit").show()
}

    
    
    
    
    
    
    
    
// MARK: - AdMob BANNERS
    func initAdMobBanner() {
        adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 320, height: 50))
        adMobBannerView.frame = CGRect(x: 0, y: view.frame.size.height, width: view.frame.size.width, height: 50)
        adMobBannerView.adUnitID = ADMOB_UNIT_ID
        adMobBannerView.rootViewController = self
        adMobBannerView.delegate = self
        view.addSubview(adMobBannerView)
        
        let request = GADRequest()
        adMobBannerView.load(request)
    }
    
    // Hide the banner
    func hideBanner(_ banner: UIView) {
        UIView.beginAnimations("hideBanner", context: nil)
        banner.frame = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2, y: view.frame.size.height - banner.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
        UIView.commitAnimations()
        banner.isHidden = true
    }
    
    // Show the banner
    func showBanner(_ banner: UIView) {
        UIView.beginAnimations("showBanner", context: nil)
        banner.frame = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2, y: view.frame.size.height - banner.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
        UIView.commitAnimations()
        banner.isHidden = false
    }
    
    // AdMob banner available
    func adViewDidReceiveAd(_ view: GADBannerView!) {
        showBanner(adMobBannerView)
    }
    
    // NO AdMob banner available
    func adView(_ view: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        hideBanner(adMobBannerView)
    }
    

    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
}
}
