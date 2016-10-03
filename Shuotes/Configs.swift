/*------------------------------------------

- Shoutes -

©2015 FV iMAGINATION
All Rights reserved

--------------------------------------------*/


import Foundation
import UIKit


/* GLOBAL VARIABLES */

var overlaysArray = NSMutableArray()
var defaults = NSUserDefaults.standardUserDefaults()
var IAP_MADE = defaults.boolForKey("IAP_MADE")



// ARRAY OF CORE IMAGE FILTERS
var filtersArray = [
    "None",
    "CIPhotoEffectInstant",
    "CIPhotoEffectProcess",
    "CIPhotoEffectTransfer",
    "CISepiaTone",
    "CIPhotoEffectFade",
    "CIPhotoEffectTonal",
    "CIPhotoEffectNoir",
    "CIDotScreen",
    "CIColorMonochrome"
]



// HUD View (Customizable)
let hudView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
let indicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
extension UIView {
    func showHUD(view: UIView) {
        hudView.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2)
        hudView.backgroundColor = UIColor.darkGrayColor()
        hudView.alpha = 0.9
        hudView.layer.cornerRadius = hudView.bounds.size.width/2

        indicatorView.center = CGPointMake(hudView.frame.size.width/2, hudView.frame.size.height/2)
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        hudView.addSubview(indicatorView)
        view.addSubview(hudView)
        indicatorView.startAnimating()
    }
}




/* VARIABLES TO BE EDITED */
let ADMOB_BANNER_UNIT_ID = "ca-app-pub-3218409375181552/9266736629"


// Edit the red string below accordinglu to the new name you'll give to this app before publishing it to the App Store
let APP_NAME = "Shuotes"

// Edit this value based on the overlays you want to offer for free (without IAP)
let FREE_OVERLAYS = 15

// IMPORTANT: SET HERE THE TOTAL AMOUNT OF OVERLAY .png IMAGES YOU'VE PUT INTO "Overlays" FOLDER
let ALL_OVERLAYS = 84

// EDIT THE RED STRING BELOW WITH YOUR OWN IAP PRODUCT ID
var IAP_PRODUCT_IDENTIFIER = "com.shoutes.iap"

// COLORS
let aqua = UIColor(red: 35.0/255.0, green: 160.0/255.0, blue: 241.0/255.0, alpha: 1.0)

// SHARING MESSAGE (Edit the red string below as you wish)
let SHARING_MESSAGE = "Hey, check out my picture | made with #\(APP_NAME)"
