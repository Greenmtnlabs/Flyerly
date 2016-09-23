/*-----------------------------------------

- The Box -

Game created by FV iMAGINATION ©2016
All Rights reserved

-----------------------------------------*/

import UIKit

class GameOver: UIViewController {
    
    /* Views */
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    
    

override func prefersStatusBarHidden() -> Bool {
    return true
}
    
   
override func viewWillAppear(animated: Bool) {
   
}
    
override func viewDidLoad() {
        super.viewDidLoad()

    if sceneSaved == "b105" {
        titleLabel.text = "You've escaped!"
        descriptionLabel.text = "You've opened the Box and destroyed it, you can finally enjoy your freedom!\nThanks for playing The Box, we hope it was a chilling experience."
        
        sceneSaved = "b0"
        defaults.setObject(sceneSaved, forKey: "sceneSaved")

        // Reset objectsArray
        objectsArray.removeAllObjects()
        defaults.setObject(objectsArray, forKey: "objectsArray")
        print("OBJECTS ON GAME OVER: \(objectsArray)")
        
    } else {
    
    // Reset sceneSaved to the first image
    sceneSaved = "b0"
    defaults.setObject(sceneSaved, forKey: "sceneSaved")
    print("SCENE ON GAME OVER: \(sceneSaved)")
    
    // Reset objectsArray
    objectsArray.removeAllObjects()
    defaults.setObject(objectsArray, forKey: "objectsArray")
    print("OBJECTS ON GAME OVER: \(objectsArray)")

    }
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
