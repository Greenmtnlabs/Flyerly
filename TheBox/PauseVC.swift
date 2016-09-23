/*-----------------------------------------

- The Box -

Game created by FV iMAGINATION ©2016
All Rights reserved

-----------------------------------------*/



import UIKit

class PauseVC: UIViewController {

   
    
    
override func prefersStatusBarHidden() -> Bool {
        return true
    }
override func viewDidLoad() {
        super.viewDidLoad()

    
}

    
   
// MARK: - CONTINUE BUTTON
@IBAction func resumeButt(sender: AnyObject) {
    gameIsPaused = false
    dismissViewControllerAnimated(true, completion: nil)
}
    
    
// MARK: - QUIT GAME BUTTON
@IBAction func quitButt(sender: AnyObject) {
    let alert = UIAlertController(title: APP_NAME,
        message: "Are you sure you want to quit the game?\nYour progress will be saved.",
        preferredStyle: UIAlertControllerStyle.Alert)
    // Go back Home
    let ok = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
        let homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("Home") as! Home
        homeVC.modalTransitionStyle = .CrossDissolve
        self.presentViewController(homeVC, animated: true, completion: nil)
    })
    // Cancel
    let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
    })
    alert.addAction(ok);  alert.addAction(cancel)
    showViewController(alert, sender: self)
}
    
    
    
// MARK: - SHARE BUTTON
@IBAction func shareButt(sender: AnyObject) {
    let messageStr  = "Exploring \(APP_NAME). Get it for iPad on https://itunes.apple.com/us/app/box-open-it-to-escape-from/id1068478363?ls=1&mt=8"
    let img = UIImage(named: "logo")!
    
    let shareItems = [messageStr, img]
    
    let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
    activityViewController.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypePostToWeibo, UIActivityTypeCopyToPasteboard, UIActivityTypeAddToReadingList, UIActivityTypePostToVimeo]
    
    if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
        // iPad
        let popOver = UIPopoverController(contentViewController: activityViewController)
        popOver.presentPopoverFromRect(CGRectZero, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection(), animated: true)
    } else {
        // iPhone
        presentViewController(activityViewController, animated: true, completion: nil)
    }
}
    
    
   
    
 
 


    
    
    
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
