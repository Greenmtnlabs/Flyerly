//
//  Home.swift
//  PhotoFixx
//
//  Created by FV iMAGINATION on 24/03/16.
//  Copyright © 2016 FV iMAGINATION. All rights reserved.
//

import UIKit


/* GLOBAL VARIABLES */
var cameraPic = Bool()
let ADMOB_UNIT_ID = "ca-app-pub-3218409375181552/4113023427"



class Home: UIViewController,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
{

    /* Views */
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var bkgImage: UIImageView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var camOutlet: UIButton!
    @IBOutlet weak var libraryOutlet: UIButton!
    
        
    
    
    
override func prefersStatusBarHidden() -> Bool {
    return true
}
// Prevent the StatusBar from showing up after picking an image
func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
    UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)
}
    
override func viewDidLoad() {
        super.viewDidLoad()
    
    
    // Round buttons corners
    camOutlet.layer.cornerRadius = 10
    libraryOutlet.layer.cornerRadius = 10
    logoImage.layer.cornerRadius = 10
    
    
    // Set a random Image everytime you get to this screen
    let randomBkg = arc4random()%3+1
    bkgImage.image = UIImage(named: "bkg\(randomBkg)")
}
    
    

   
@IBAction func cameraButt(sender: AnyObject) {
    cameraPic = true;
    
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
        imagePicker.allowsEditing = false
        presentViewController(imagePicker, animated: true, completion: nil)
    }

}
    
    
@IBAction func libraryButt(sender: AnyObject) {
    cameraPic = false;
    
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        imagePicker.allowsEditing = false
        presentViewController(imagePicker, animated: true, completion: nil)
    }

}
    
func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    myImage.image = image
    dismissViewControllerAnimated(true, completion: nil)
    
    openImageEditor()
}

    

// MARK: - OPEN IKMAGE EDITOR the image Editor screen
func openImageEditor() {
    let myVC = storyboard?.instantiateViewControllerWithIdentifier("ImageEditor") as! ImageEditor
    myVC.imagePassed = myImage.image!
    navigationController?.pushViewController(myVC, animated: true)
}
    
    
    
    
    
    
 
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
