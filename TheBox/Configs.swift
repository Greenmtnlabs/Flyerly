/*-----------------------------------------

- The Box -

Game created by FV iMAGINATION ©2016
All Rights reserved

-----------------------------------------*/

import Foundation
import UIKit
import AudioToolbox
import AVFoundation




let APP_NAME = "The Box"


let ADMOB_UNIT_ID = "ca-app-pub-3218409375181552/7929604228"


var audioPlayer = AVAudioPlayer()
var soundURL: NSURL?
var soundID:SystemSoundID = 0

var removeAds = defaults.boolForKey("removeAds")



// HUD View
let hudView = UIView(frame: CGRectMake(0, 0, 80, 80))
let indicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 80, 80))
extension UIView {
    func showHUD(view: UIView) {
        hudView.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2)
        hudView.backgroundColor = UIColor.whiteColor()
        hudView.alpha = 0.9
        hudView.layer.cornerRadius = hudView.bounds.size.width/2
        
        indicatorView.center = CGPointMake(hudView.frame.size.width/2, hudView.frame.size.height/2)
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        indicatorView.color = UIColor.blackColor()
        hudView.addSubview(indicatorView)
        indicatorView.startAnimating()
        view.addSubview(hudView)
    }
   func hideHUD() {
        hudView.removeFromSuperview()
    }
}
