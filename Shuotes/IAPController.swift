/*------------------------------------------

- Shoutes -

©2015 FV iMAGINATION
All Rights reserved

--------------------------------------------*/


import UIKit
import StoreKit


// MARK: - CUSTOM PREVIEW CELL
class PreviewCell: UICollectionViewCell {
    /* Views */
    @IBOutlet weak var prevImage: UIImageView!
    
}



// MAKR: - IAP CONTROLLER CLASS
class IAPController: UIViewController,
SKProductsRequestDelegate,
SKPaymentTransactionObserver
{
    
    /* Views */
    @IBOutlet var iapDescriptionLabel: UILabel!

    @IBOutlet weak var buyOutlet: UIButton!
    @IBOutlet var restoreOutlet: UIButton!
    
    @IBOutlet weak var previewCollView: UICollectionView!
    
    
    /* Variables */
    var productsRequest = SKProductsRequest()
    var validProducts = []
    var paidOverlaysArray = [Int]()

    

    
    
    
override func prefersStatusBarHidden() -> Bool {
        return true
}
override func viewDidLoad() {
        super.viewDidLoad()
    
    view.showHUD(view)
    
    // Round buttons corners
    buyOutlet.layer.cornerRadius = 6
    restoreOutlet.layer.cornerRadius = 6
    
    if IAP_MADE {  buyOutlet.hidden = true }
    
    // Fetch available IAP Products
    fetchAvailableProducts()
    
    
    // Prepare the array of Paid Overlays
    let paidOverlaysQty = ALL_OVERLAYS - FREE_OVERLAYS
    for i in 0..<paidOverlaysQty { paidOverlaysArray.append(i + FREE_OVERLAYS) }
    previewCollView.reloadData()
}

    
    
    
// MARK: - COLLECTION VIEW DELEGATES 
func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
}
    
func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return paidOverlaysArray.count
}
    
func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PreviewCell", forIndexPath: indexPath) as! PreviewCell
        
    cell.prevImage.image = UIImage(named: "\(paidOverlaysArray[indexPath.row]).png")
    
return cell
}
    
func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    return CGSizeMake(92, 92)
}
    

    
    
    

// MARK: - BUY OVERLAYS BUTTON
@IBAction func buyButt(sender: AnyObject) {
    purchaseMyProduct(validProducts[0] as! SKProduct)
    buyOutlet.enabled = false
    view.showHUD(view)
}
    
    
    
    
// MARK: - IAP METHODS -----------------------------------------------
func fetchAvailableProducts()  {
    let productIdentifiers = NSSet(objects:
            IAP_PRODUCT_IDENTIFIER
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
            
            // IAP Product
            let iapProduct: SKProduct = response.products[0] 
            iapDescriptionLabel.text = "\(iapProduct.localizedDescription)\nFor just \(iapProduct.price)"
            buyOutlet.hidden = false
            hudView.removeFromSuperview()
        }
}
func canMakePurchases() -> Bool {
    return SKPaymentQueue.canMakePayments()
}
func purchaseMyProduct(product: SKProduct) {
    if self.canMakePurchases() {
        let payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().addPayment(payment)
            
    // IAP Purchases dsabled on the Device
    } else {
        let alert = UIAlertView(title: "Purchases are disabled in your device!",
        message: nil,
        delegate: nil,
        cancelButtonTitle: "OK")
        alert.show()
    }
    
}
func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])    {
        for transaction:AnyObject in transactions {
            
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                    
                case .Purchased:
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    IAP_MADE = true
                    defaults.setBool(IAP_MADE, forKey: "IAP_MADE"); defaults.synchronize()
                    buyOutlet.hidden = true
                    hudView.removeFromSuperview()
                    break
                case .Failed:
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    hudView.removeFromSuperview()
                    break
                case .Restored:
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    hudView.removeFromSuperview()
                    break
                default: break  }
            }
        }
}
    
    
// RESTORE PURCHASE BUTTON
@IBAction func restorePurchaseButt(sender: AnyObject) {
    view.showHUD(view)
    SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
}
    
func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
    IAP_MADE = true
    defaults.setBool(IAP_MADE, forKey: "IAP_MADE"); defaults.synchronize()
    buyOutlet.hidden = true
    hudView.removeFromSuperview()
}
    
    
    
// DISMISS BUTTON
@IBAction func dismissButt(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
}
    

    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
