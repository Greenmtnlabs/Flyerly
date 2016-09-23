/*-----------------------------------------

- The Box -

Game created by FV iMAGINATION ©2016
All Rights reserved

-----------------------------------------*/

import UIKit
import AVFoundation
import StoreKit


class Home: UIViewController,
SKProductsRequestDelegate,
SKPaymentTransactionObserver
{

    /* Views */
    @IBOutlet weak var playOutlet: UIButton!
    @IBOutlet weak var removeAdsOutlet: UIButton!
    @IBOutlet weak var shareOutlet: UIButton!
    
    
    /* Variables */
    var productsRequest = SKProductsRequest()
    var validProducts = []

    
    
    
    
override func prefersStatusBarHidden() -> Bool {
        return true
}
override func viewDidLoad() {
        super.viewDidLoad()
    
    print("REMOVE ADS: \(removeAds)")
    
    // Fetch IAP Products available
    fetchAvailableProducts()
    if removeAds { removeAdsOutlet.hidden = true
    } else { removeAdsOutlet.hidden = false }
    
    
    // Set Play button
    if sceneSaved == nil  || sceneSaved == "b0" { playOutlet.setTitle("Explore The Box", forState: .Normal)
    } else { playOutlet.setTitle("Continue...", forState: .Normal)  }
    
    
    // Start background music
    let path = NSBundle.mainBundle().pathForResource("bkg2", ofType: "wav")
    let url = NSURL.fileURLWithPath(path!)
    do { try audioPlayer = AVAudioPlayer(contentsOfURL: url)
    } catch { print("NO AUDIO PLAYER") }
    audioPlayer.numberOfLoops = -1
    audioPlayer.volume = 0.2
    audioPlayer.prepareToPlay()
    audioPlayer.play()
}

   

    
// MARK: - PLAY BUTTON
@IBAction func playButt(sender: AnyObject) {
    let gbVC = storyboard?.instantiateViewControllerWithIdentifier("GameBoard") as! GameBoard
    gbVC.modalTransitionStyle = .CrossDissolve
    presentViewController(gbVC, animated: true, completion: nil)
}
    
    
    
// SHARE BUTTON
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
    }
}
    
    

    
// MARK: - REMOVE ADS BUTTON
@IBAction func removeAdsButt(sender: AnyObject) {
    purchaseMyProduct(validProducts[0] as! SKProduct)
    removeAdsOutlet.enabled = false
}

    
// MARK: - IAP METHODS
func fetchAvailableProducts()  {
        
        // Put here your IAP Products ID's
        let productIdentifiers = NSSet(objects:
            "com.thebox.removeads"
        )
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
}
    
func productsRequest (request:SKProductsRequest, didReceiveResponse response:SKProductsResponse) {
        let count:Int = response.products.count
        
        // Finding IAP Products you've created in iTunes Connect
        if (count > 0) {
            validProducts = response.products
            view.hideHUD()
        }
}
    
func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
func purchaseMyProduct(product: SKProduct) {
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.defaultQueue().addTransactionObserver(self)
            SKPaymentQueue.defaultQueue().addPayment(payment)
            
        // IAP Purchases dsabled on the Device
        } else {
            let alertView = UIAlertView(title: "Purchases are disabled in your device!",
                message: nil,
                delegate: nil,
                cancelButtonTitle: "OK")
            alertView.show()
            view.hideHUD()
        }
}
    
    
func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                    
                case .Purchased:
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    removeAds = true
                    defaults.setBool(removeAds, forKey: "removeAds")
                    
                    let alertView = UIAlertView(title: APP_NAME,
                        message: "You've successfully removed ads.\nEnjoy \(APP_NAME)!",
                        delegate: nil,
                        cancelButtonTitle: "OK")
                    alertView.show()
                    
                    print("REMOVE ADS: \(removeAds)")
                    removeAdsOutlet.hidden = true
                    view.hideHUD()
                    
                    break
                    
                case .Failed:
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                case .Restored:
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                default: break
                } } }
}
    
    


    
   
// MARK: - RESTORE PURCHASE BUTTON
@IBAction func restorePurchase(sender: AnyObject) {
    view.showHUD(view)
    SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
}
func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
    removeAds = true
    defaults.setBool(removeAds, forKey: "removeAds")
    
    let alertView = UIAlertView(title: APP_NAME,
        message: "You've successfully removed ads.\nEnjoy \(APP_NAME)!",
        delegate: nil,
        cancelButtonTitle: "OK")
    alertView.show()
    
    print("REMOVE ADS: \(removeAds)")
    removeAdsOutlet.hidden = true
    view.hideHUD()
}
    
    
    
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
