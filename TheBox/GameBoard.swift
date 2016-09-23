/*-----------------------------------------

- The Box -

Game created by FV iMAGINATION ©2016
All Rights reserved

-----------------------------------------*/

import UIKit
import AudioToolbox
import GoogleMobileAds
import MediaPlayer


var objectsArray = NSMutableArray()
var gameIsPaused = false


class GameBoard: UIViewController,
GADInterstitialDelegate
{

    /* Views */
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var hintLabel: UILabel!

    @IBOutlet weak var touchView: UIView!
    @IBOutlet weak var touchView2: UIView!
    
    @IBOutlet weak var hudView: UIView!
    @IBOutlet var hudButtons: [UIButton]!
    
    @IBOutlet weak var gameOverFlames: UIImageView!
    
    var adMobInterstitial: GADInterstitial!

    var moviePlayer = MPMoviePlayerController()
    
    
    
    
// Hide StatusBar
override func prefersStatusBarHidden() -> Bool {
    return true
}
  
override func viewDidLoad() {
        super.viewDidLoad()

    /*TEST
    sceneSaved = "b105"
    objectsArray.removeAllObjects()
    defaults.setObject(objectsArray, forKey: "objectsArray")
    TEST*/
    
    
    
    // Hide views
    touchView.backgroundColor = UIColor.clearColor()
    touchView2.backgroundColor = UIColor.clearColor()
    
    touchView2.frame = CGRectMake(0, 0, 0, 0)
    touchView.hidden = false
    touchView2.hidden = false
    
    hudView.layer.cornerRadius = 5
    gameOverFlames.frame.origin.y = view.frame.size.height
    gameOverFlames.alpha = 0
    
    
    
    
    // Load first scene image
    if sceneSaved == nil {  setTheScene("b0")
       
    // Get saved image from last game
    } else { setTheScene(sceneSaved!) }


    
    // Load Objects Array
    let tempArr: AnyObject? = defaults.objectForKey("objectsArray")?.mutableCopy()
    if tempArr != nil  &&  sceneSaved != "b0" {
        objectsArray = tempArr as! NSMutableArray
        setupHUD()
    } else if sceneSaved == "b0" { objectsArray.removeAllObjects() }
    print("OBJECTS AT VIEW DID LOAD: \(objectsArray)")

    

    
    // Call AdMob Interstitial
    callAdMobInterstitial()

    
  
}
    
override func viewWillAppear(animated: Bool) {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkVideoState", name: MPMoviePlayerPlaybackStateDidChangeNotification, object: nil)
}
override func viewWillDisappear(animated: Bool) {
    NSNotificationCenter.defaultCenter().removeObserver(self)
}

    

    
    
// MARK: - SET SCENE WITH IMAGE
func setTheScene(name:String) {
    sceneSaved = name
    gameImage.image = UIImage(named: name)
    defaults.setObject(sceneSaved, forKey: "sceneSaved")
    print("CURRENT SCENE: \(sceneSaved!)")
    
    touchView2.frame = CGRectMake(0, 0, 0, 0)

    
    // Set Scene accordingly to the sceneSaved
    switch sceneSaved! {
    case "b0":
        touchView.frame = CGRectMake(243, 391, 112, 127)
        hintLabel.text = ""
    case "b1":
        touchView.frame = CGRectMake(280, 370, 128, 188)
        hintLabel.text = "What if I turn that key?"
    case "b2":
        touchView.frame = CGRectMake(214, 132, 170, 70)
        hintLabel.text = "I guess I've unlocked something..."
    case "b3":
        touchView.frame = CGRectMake(258, 513, 124, 116)
        hintLabel.text = ""
    case "b4":
        touchView.frame = CGRectMake(306, 377, 124, 124)
        hintLabel.text = ""
    case "b5":
        touchView.frame = CGRectMake(328, 55, 662, 169)
        hintLabel.text = ""
    case "b6":
        touchView.frame = CGRectMake(895, 139, 129, 147)
        hintLabel.text = ""
    case "b7":
        touchView.frame = CGRectMake(244, 395, 260, 297)
        hintLabel.text = ""
    case "b8":
        touchView.frame = CGRectMake(322, 266, 530, 272)
        hintLabel.text = ""
    case "b9":
        touchView.frame = CGRectMake(718, 354, 72, 69)
        touchView2.frame = CGRectMake(380, 355, 312, 64)
        hintLabel.text = "Those words sound clear, what if I tap the wrong number..?"
    case "b10":
        touchView.frame = CGRectMake(185, 400, 148, 156)
        hintLabel.text = "Great, that was the right number! Now let me keep exploring this box."
    case "b11":
        touchView.frame = CGRectMake(264, 351, 148, 156)
        hintLabel.text = ""
    case "b12":
        touchView.frame = CGRectMake(447, 0, 470, 146)
        hintLabel.text = ""
    case "b13":
        touchView.frame = CGRectMake(584, 460, 274, 182)
        hintLabel.text = ""
    case "b14":
        touchView.frame = CGRectMake(584, 60, 180, 150)
        hintLabel.text = "What a strange hole, what should I insert in it?"
    case "b15":
        touchView.frame = CGRectMake(541, 238, 230, 230)
        hintLabel.text = ""
    case "b16":
        touchView.frame = CGRectMake(541, 238, 230, 230)
        hintLabel.text = "The compass has just turned..."
    case "b17":
        touchView.frame = CGRectMake(924, 66, 100, 552)
        hintLabel.text = ""
    case "b18":
        touchView.frame = CGRectMake(340, 0, 546, 105)
        touchView2.frame = CGRectMake(462, 314, 133, 152)
        hintLabel.text = ""
    case "b19":
        touchView.frame = CGRectMake(588, 210, 184, 188)
        hintLabel.text = ""
    case "b20":
        touchView.frame = CGRectMake(851, 448, 173, 320)
        hintLabel.text = ""
    case "b21":
        touchView.frame = CGRectMake(370, 283, 594, 256)
        hintLabel.text = ""
    case "b22":
        touchView.frame = CGRectMake(680, 394, 185, 180)
        hintLabel.text = ""
    case "b23":
        touchView.frame = CGRectMake(476, 0, 191, 130)
        hintLabel.text = "I've got a gold key. I think I may use it somewhere."
    case "b24":
        touchView.frame = CGRectMake(588, 211, 200, 200)
        hintLabel.text = ""
    case "b25":
        touchView.frame = CGRectMake(221, 566, 319, 202)
        hintLabel.text = ""
    case "b26":
        touchView.frame = CGRectMake(484, 315, 132, 161)
        hintLabel.text = ""
    case "b27":
        touchView.frame = CGRectMake(455, 367, 116, 135)
        hintLabel.text = ""
    case "b28":
        touchView.frame = CGRectMake(375, 0, 552, 67)
        hintLabel.text = "I have unlocked something! I must find out what it is"
    case "b29":
        touchView.frame = CGRectMake(583, 202, 200, 200)
        hintLabel.text = ""
    case "b30":
        touchView.frame = CGRectMake(163, 0, 407, 202)
        hintLabel.text = ""
    case "b31":
        touchView.frame = CGRectMake(298, 253, 558, 314)
        hintLabel.text = ""
    case "b32":
        touchView.frame = CGRectMake(197, 253, 641, 102)
        hintLabel.text = "This drawer must contain something..."
    case "b33":
        touchView.frame = CGRectMake(401, 480, 59, 64)
        touchView2.frame = CGRectMake(520, 502, 305, 65)
        hintLabel.text = "I can pick up only one diamond. I'm taking a deep breath..."
    case "b34":
        touchView.frame = CGRectMake(208, 333, 125, 107)
        hintLabel.text = "I've got a red diamond!"
    case "b35":
        touchView.frame = CGRectMake(600, 140, 189, 202)
        hintLabel.text = ""
    case "b36":
        touchView.frame = CGRectMake(193, 0, 208, 289)
        hintLabel.text = ""
    case "b37":
        touchView.frame = CGRectMake(272, 356, 124, 150)
        hintLabel.text = ""
    case "b38":
        touchView.frame = CGRectMake(339, 0, 588, 82)
        hintLabel.text = ""
    case "b39":
        touchView.frame = CGRectMake(682, 30, 199, 133)
        hintLabel.text = ""
    case "b40":
        touchView.frame = CGRectMake(797, 283, 227, 437)
        hintLabel.text = "Another number..."
    case "b41":
        touchView.frame = CGRectMake(290, 288, 587, 206)
        hintLabel.text = ""
    case "b42":
        touchView.frame = CGRectMake(338, 460, 79, 93)
        touchView2.frame = CGRectMake(431, 351, 324, 204)
        hintLabel.text = "Again, one chance only to survive..."
    case "b43":
        touchView.frame = CGRectMake(281, 0, 644, 186)
        hintLabel.text = "I've got an Octagon. It's pretty heavy!"
    case "b44":
        touchView.frame = CGRectMake(560, 100, 179, 168)
        hintLabel.text = ""
    case "b45":
        touchView.frame = CGRectMake(560, 113, 179, 155)
        hintLabel.text = ""
    case "b46":
        touchView.frame = CGRectMake(536, 0, 401, 90)
        hintLabel.text = ""
    case "b47":
        touchView.frame = CGRectMake(603, 374, 119, 90)
        hintLabel.text = ""
    case "b48":
        touchView.frame = CGRectMake(603, 374, 119, 90)
        hintLabel.text = ""
    case "b49":
        touchView.frame = CGRectMake(615, 247, 119, 97)
        touchView2.frame = CGRectMake(119, 0, 814, 86)
        hintLabel.text = "Let me check that lens..."
    case "b50":
        touchView.frame = CGRectMake(514, 93, 159, 148)
        hintLabel.text = "The compass fell down and lost its glass!"
    case "b51":
        touchView.frame = CGRectMake(419, 132, 378, 378)
        hintLabel.text = ""
    case "b52":
        touchView.frame = CGRectMake(419, 132, 378, 378)
        hintLabel.text = "That's a gear, maybe it's useful..."
    case "b53":
        touchView.frame = CGRectMake(84, 91, 260, 552)
        hintLabel.text = ""
    case "b54":
        touchView.frame = CGRectMake(608, 328, 207, 217)
        hintLabel.text = ""
    case "b55":
        touchView.frame = CGRectMake(434, 605, 140, 140)
        hintLabel.text = "That compass is not useful at this point."
    case "b56":
        touchView.frame = CGRectMake(535, 189, 300, 250)
        hintLabel.text = ""
    case "b57":
        touchView.frame = CGRectMake(489, 180, 372, 398)
        hintLabel.text = "An old clock..."
    case "b58":
        touchView.frame = CGRectMake(489, 180, 372, 398)
        touchView2.frame = CGRectMake(963, 263, 45, 50)
        hintLabel.text = "I should now be able to rotate the clock and then press that button!"
    case "b59", "b60", "b61", "b62", "b63", "b64", "b65", "b66", "b67", "b68", "b69" :
        touchView.frame = CGRectMake(489, 180, 372, 398)
        touchView2.frame = CGRectMake(963, 263, 45, 50)
        hintLabel.text = ""
    case "b70":
        touchView.frame = CGRectMake(482, 273, 144, 138)
        hintLabel.text = "This box has mutated again, how can I escape from here!?"
    case "b71":
        touchView.frame = CGRectMake(216, 40, 157, 386)
        hintLabel.text = "These numbers mean something, I gotta think about this."
    case "b72":
        touchView.frame = CGRectMake(417, 278, 116, 119)
        hintLabel.text = "I cannot make mistakes, or the box will burn out again!"
    case "b73":
        touchView.frame = CGRectMake(53, 658, 898, 110)
        hintLabel.text = "I guess something just fell down..."
    case "b74":
        touchView.frame = CGRectMake(319, 523, 108, 110)
        hintLabel.text = ""
    case "b75":
        touchView.frame = CGRectMake(531, 0, 419, 111)
        hintLabel.text = "I've got that wired key, I though I could never use it, obviously I was wrong..."
    case "b76":
        touchView.frame = CGRectMake(627, 131, 184, 145)
        hintLabel.text = ""
    case "b77":
        touchView.frame = CGRectMake(322, 109, 530, 530)
        touchView2.frame = CGRectMake(58, 669, 909, 99)
        hintLabel.text = ""
    case "b78":
        touchView.frame = CGRectMake(322, 109, 530, 530)
        touchView2.frame = CGRectMake(58, 669, 909, 99)
        hintLabel.text = ""
    case "b79":
        touchView.frame = CGRectMake(322, 109, 530, 530)
        touchView2.frame = CGRectMake(58, 669, 909, 99)
        hintLabel.text = ""
    case "b80":
        touchView.frame = CGRectMake(322, 109, 530, 530)
        touchView2.frame = CGRectMake(58, 669, 909, 99)
        hintLabel.text = ""
    case "b81":
        touchView.frame = CGRectMake(629, 134, 143, 110)
        hintLabel.text = "Four different dragons have just appeared..."
    case "b82":
        touchView.frame = CGRectMake(680, 457,  102, 100)
        hintLabel.text = "What symbol should I touch..?"
    case "b83":
        touchView.frame = CGRectMake(798, 477,  129, 124)
        hintLabel.text = ""
    case "b84":
        touchView.frame = CGRectMake(907, 253,  117, 495)
        hintLabel.text = "I've picked up the Light Dragon."
    case "b85":
        touchView.frame = CGRectMake(573, 308,  203, 175)
        hintLabel.text = ""
    case "b86":
        touchView.frame = CGRectMake(470, 181,  203, 175)
        hintLabel.text = ""
    case "b87":
        touchView.frame = CGRectMake(464, 463, 224, 207)
        hintLabel.text = ""
    case "b88":
        touchView.frame = CGRectMake(493, 237, 126, 130)
        touchView2.frame = CGRectMake(168, 0, 762, 104)
        hintLabel.text = ""
    case "watchLens":
        touchView.frame = CGRectMake(225, 113, 552, 542)
        hintLabel.text = "I believe I must memorize this sequence..."
    case "b89":
        touchView.frame = CGRectMake(556, 95, 129, 126)
        touchView2.frame = CGRectMake(293, 253, 378, 434)
        hintLabel.text = ""
    case "b90":
        touchView.frame = CGRectMake(639, 387, 89, 82)
        hintLabel.text = ""
    case "b91":
        touchView.frame = CGRectMake(639, 328, 139, 220)
        hintLabel.text = ""
    case "b92":
        touchView.frame = CGRectMake(510, 126, 383, 124)
        hintLabel.text = "Wow..."
    case "b93":
        touchView.frame = CGRectMake(421, 163, 419, 442)
        hintLabel.text = "Blue sky, I'm missing it so much, I wanna escape from here!"
    case "b94":
        touchView.frame = CGRectMake(527, 207, 60, 60)
        touchView2.frame = CGRectMake(458, 314, 140, 140)
        hintLabel.text = ""
    case "b95":
        touchView.frame = CGRectMake(642, 275, 60, 60)
        touchView2.frame = CGRectMake(458, 314, 140, 140)
        hintLabel.text = ""
    case "b96":
        touchView.frame = CGRectMake(665, 387, 60, 60)
        touchView2.frame = CGRectMake(458, 314, 140, 140)
        hintLabel.text = ""
    case "b97":
        touchView.frame = CGRectMake(609, 498, 60, 60)
        touchView2.frame = CGRectMake(458, 314, 140, 140)
        hintLabel.text = ""
    case "b98":
        touchView.frame = CGRectMake(477, 540, 60, 60)
        touchView2.frame = CGRectMake(458, 314, 140, 140)
        hintLabel.text = ""
    case "b99":
        touchView.frame = CGRectMake(352, 452, 60, 60)
        touchView2.frame = CGRectMake(458, 314, 140, 140)
        hintLabel.text = ""
    case "b100":
        touchView.frame = CGRectMake(334, 328, 60, 60)
        touchView2.frame = CGRectMake(458, 314, 140, 140)
        hintLabel.text = ""
    case "b101":
        touchView.frame = CGRectMake(407, 222, 60, 60)
        touchView2.frame = CGRectMake(458, 314, 140, 140)
        hintLabel.text = ""
    case "b102":
        touchView.frame = CGRectMake(593, 229, 60, 60)
        hintLabel.text = ""
    case "b103":
        touchView.frame = CGRectMake(619, 332, 60, 60)
        hintLabel.text = ""
    case "b104":
        touchView.frame = CGRectMake(619, 332, 60, 60)
        hintLabel.text = ""
    case "b105":
        touchView.frame = CGRectMake(594, 315, 134, 272)
        hintLabel.text = "A door..."
        


        
            
    default:break }
        
}
    

    

// MARK: - TOUCH THE VIEWS
override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    let touch = touches.first
    let touchLocation = touch!.locationInView(view)

    
    // TOUCH VIEW ----------------------------------------------------------
    if CGRectContainsPoint(touchView.frame, touchLocation) {
        switch sceneSaved! {
        case "b0":
            setTheScene("b1")
        case "b1":
            playSound("click", type: "wav")
            setTheScene("b2")
        case "b2":
            playSound("lock", type: "wav")
            setTheScene("b3")
        case "b3":
            setTheScene("b4")
        case "b4":
            playSound("click", type: "wav")
            setTheScene("b5")
        case "b5":
            setTheScene("b6")
        case "b6":
            playSound("lock", type: "wav")
            setTheScene("b7")
        case "b7":
            setTheScene("b8")
        case "b8":
            playSound("drawer", type: "wav")
            setTheScene("b9")
        case "b9":
            playSound("lock", type: "wav")
            setTheScene("b10")
        case "b10":
            callAdMobInterstitial()
            setTheScene("b11")
        case "b11":
            playSound("click", type: "wav")
            setTheScene("b12")
        case "b12":
            setTheScene("b13")
        case "b13":
            playSound("lock", type: "wav")
            setTheScene("b14")
        case "b14":
            setTheScene("b15")
        case "b15":
            playSound("lock", type: "wav")
            setTheScene("b16")
        case "b16":
            playSound("lock", type: "wav")
            setTheScene("b17")
        case "b17":
            setTheScene("b18")
        case "b18":
            setTheScene("b19")
        case "b19":
            playSound("lock", type: "wav")
            setTheScene("b20")
        case "b20":
            callAdMobInterstitial()
            setTheScene("b21")
        case "b21":
            playSound("drawer", type: "wav")
            setTheScene("b22")
        case "b22":
            playSound("gotObject", type: "wav")
            saveObjectsArray("goldKey")
            setupHUD()
            setTheScene("b23")
        case "b23":
            setTheScene("b24")
        case "b24":
            playSound("lock", type: "wav")
            setTheScene("b25")
        case "b25":
            setTheScene("b26")
        case "b26":
            playSound("bump", type: "wav")
            hintLabel.text = "This lock needs a key..."
        case "b27":
            playSound("click", type: "wav")
            setTheScene("b28")
        case "b28":
            setTheScene("b29")
        case "b29":
            playSound("lock", type: "wav")
            setTheScene("b30")
        case "b30":
            callAdMobInterstitial()
            setTheScene("b31")
        case "b31":
            playSound("drawer", type: "wav")
            setTheScene("b32")
        case "b32":
            setTheScene("b33")
        case "b33":
            playSound("gotObject", type: "wav")
            saveObjectsArray("redDiamond")
            setupHUD()
            setTheScene("b34")
        case "b34":
            playSound("bump", type: "wav")
            hintLabel.text = "I must place an object here..."
        case "b35":
            playSound("lock", type: "wav")
            setTheScene("b36")
        case "b36":
            setTheScene("b37")
        case "b37":
            playSound("click", type: "wav")
            setTheScene("b38")
        case "b38":
            setTheScene("b39")
        case "b39":
            playSound("lock", type: "wav")
            setTheScene("b40")
        case "b40":
            callAdMobInterstitial()
            setTheScene("b41")
        case "b41":
            playSound("drawer", type: "wav")
            setTheScene("b42")
        case "b42":
            playSound("gotObject", type: "wav")
            saveObjectsArray("octagon")
            setupHUD()
            setTheScene("b43")
        case "b43":
            setTheScene("b44")
        case "b44":
            playSound("lock", type: "wav")
            setTheScene("b45")
        case "b45":
            playSound("lock", type: "wav")
            setTheScene("b46")
        case "b46":
            setTheScene("b47")
        case "b47":
            playSound("bump", type: "wav")
            hintLabel.text = "I must place an object over there..."
        case "b48":
            playSound("click", type: "wav")
            setTheScene("b49")
        case "b49":
            touchView.hidden = true
            touchView2.hidden = true
            playSound("whuiip", type: "wav")
            playVideo("clockVideo", type: "mov")
            hintLabel.text = "I can watch that video again if I tap the lens, or I can just keep exploring this box..."
        case "b50":
            callAdMobInterstitial()
            setTheScene("b51")
        case "b51":
            playSound("lock", type: "wav")
            setTheScene("b52")
        case "b52":
            playSound("gotObject", type: "wav")
            saveObjectsArray("gear")
            setupHUD()
            setTheScene("b53")
        case "b53":
            setTheScene("b54")
        case "b54":
            playSound("lock", type: "wav")
            setTheScene("b55")
        case "b55":
            playSound("lock", type: "wav")
            setTheScene("b56")
        case "b56":
            setTheScene("b57")
        case "b57":
            playSound("bump", type: "wav")
            hintLabel.text = "I cannot rotate the clock..."
        case "b58":
            playSound("click", type: "wav")
            setTheScene("b59")
        case "b59":
            playSound("click", type: "wav")
            setTheScene("b60")
        case "b60":
            callAdMobInterstitial()
            playSound("click", type: "wav")
            setTheScene("b61")
        case "b61":
            playSound("click", type: "wav")
            setTheScene("b62")
        case "b62":
            playSound("click", type: "wav")
            setTheScene("b63")
        case "b62":
            playSound("click", type: "wav")
            setTheScene("b63")
        case "b63":
            playSound("click", type: "wav")
            setTheScene("b64")
        case "b64":
            playSound("click", type: "wav")
            setTheScene("b65")
        case "b65":
            playSound("click", type: "wav")
            setTheScene("b66")
        case "b66":
            playSound("click", type: "wav")
            setTheScene("b67")
        case "b67":
            playSound("click", type: "wav")
            setTheScene("b68")
        case "b68":
            playSound("click", type: "wav")
            setTheScene("b69")
        case "b69":
            playSound("click", type: "wav")
            setTheScene("b58")
        case "b70":
            callAdMobInterstitial()
            setTheScene("b71")
        case "b71":
            setTheScene("b72")
        case "b72":
            playSound("keyFell", type: "wav")
            setTheScene("b73")
        case "b73":
            setTheScene("b74")
        case "b74":
            playSound("gotObject", type: "wav")
            saveObjectsArray("firstKey")
            setupHUD()
            setTheScene("b75")
        case "b75":
            setTheScene("b76")
        case "b76":
            playSound("lock", type: "wav")
            setTheScene("b77")
        case "b77":
            playSound("lock", type: "wav")
            setTheScene("b78")
        case "b78":
            playSound("lock", type: "wav")
            setTheScene("b79")
        case "b79":
            playSound("lock", type: "wav")
            setTheScene("b80")
        case "b80":
            callAdMobInterstitial()
            playSound("lock", type: "wav")
            setTheScene("b77")
        case "b81":
            setTheScene("b82")
        case "b82":
            playSound("lock", type: "wav")
            setTheScene("b83")
        case "b83":
            playSound("gotObject", type: "wav")
            saveObjectsArray("lightDragon")
            setupHUD()
            setTheScene("b84")
        case "b84":
            setTheScene("b85")
        case "b85":
            playSound("lock", type: "wav")
            setTheScene("b86")
        case "b86":
            playSound("bump", type: "wav")
            hintLabel.text = "An exagonal hole..."
        case "b87":
            playSound("lock", type: "wav")
            setTheScene("b88")
        case "b88":
            playSound("click", type: "wav")
            setTheScene("watchLens")
        case "watchLens":
            setTheScene("b89")
        case "b89":
            callAdMobInterstitial()
            playSound("click", type: "wav")
            setTheScene("b90")
        case "b90":
            playSound("bump", type: "wav")
            hintLabel.text = "Something must go here..."
        case "b91":
            playSound("click", type: "wav")
            setTheScene("b92")
        case "b92":
            setTheScene("b93")
        case "b93":
            playSound("click", type: "wav")
            setTheScene("b94")
        case "b94":
            playSound("click", type: "wav")
            setTheScene("b95")
        case "b95":
            playSound("click", type: "wav")
            setTheScene("b96")
        case "b96":
            playSound("click", type: "wav")
            setTheScene("b97")
        case "b97":
            playSound("click", type: "wav")
            setTheScene("b98")
        case "b98":
            playSound("click", type: "wav")
            setTheScene("b99")
        case "b99":
            playSound("click", type: "wav")
            setTheScene("b100")
        case "b100":
            playSound("click", type: "wav")
            setTheScene("b101")
        case "b101":
            playSound("click", type: "wav")
            setTheScene("b94")
        case "b102":
            playSound("gotObject", type: "wav")
            saveObjectsArray("sphere")
            setupHUD()
            setTheScene("b103")
        case "b103":
            playSound("bump", type: "wav")
            hintLabel.text = "Maybe I should place something on there..."
        case "b104":
            playSound("lock", type: "wav")
            setTheScene("b105")
        case "b105":
            touchView.hidden = true
            touchView2.hidden = true
            playSound("wind", type: "wav")
            playVideo("finalVideo", type: "mp4")
            
        default:break }
    
        
        
        
        
        
    // TOUCH VIEW 2 --------------------------------------------------------
    } else if CGRectContainsPoint(touchView2.frame, touchLocation) {
        switch sceneSaved! {
        case "b9":
            gameOver()
        case "b18":
            playSound("bump", type: "wav")
            hintLabel.text = "I need to find a key!"
        case "b33":
            gameOver()
        case "b42":
            gameOver()
        case "b49":
            playSound("breakingGlass", type: "wav")
            setTheScene("b50")
        case "b58", "b59", "b60", "b61", "b62", "b63", "b64", "b65", "b66", "b67", "b67", "b68":
            gameOver()
        case "b69":
            playSound("lock", type: "wav")
            setTheScene("b70")
        case "b77":
            playSound("lock", type: "wav")
            setTheScene("b76")
        case "b78":
            playSound("lock", type: "wav")
            setTheScene("b76")
        case "b79":
            setTheScene("b81")
        case "b80":
            playSound("lock", type: "wav")
            setTheScene("b76")
        case "b89", "b94", "b95", "b96", "b97", "b98", "b100", "b101":
            gameOver()
        case "b99":
            playSound("lock", type: "wav")
            setTheScene("b102")
            
            
        default:break }
        
        
        
    // TOUCH NO VIEWS
    } else {
        playSound("bump", type: "wav")
        
        switch sceneSaved! {
            case "b72", "b82":
            gameOver()
        
        default:break }
    }
    
}


    
    

// MARK: - OBJECT BUTTONS FROM HUD
@IBAction func objectButt(sender: UIButton) {
    print("\(sender.tag)")
    switch sceneSaved! {
    case "b26":
            if sender.tag == 0 {
                playSound("lock", type: "wav")
                objectsArray.removeObjectAtIndex(0)
                defaults.setObject(objectsArray, forKey: "objectsArray")
                setupHUD()
                sender.setBackgroundImage(UIImage(named: ""), forState: .Normal)
                setTheScene("b27")
            }
        
    case "b34":
            if sender.tag == 0 {
                playSound("lock", type: "wav")
                objectsArray.removeObjectAtIndex(0)
                defaults.setObject(objectsArray, forKey: "objectsArray")
                setupHUD()
                sender.setBackgroundImage(UIImage(named: ""), forState: .Normal)
                setTheScene("b35")
            }
    
    case "b47":
            if sender.tag == 0 {
                playSound("lock", type: "wav")
                objectsArray.removeObjectAtIndex(0)
                defaults.setObject(objectsArray, forKey: "objectsArray")
                setupHUD()
                sender.setBackgroundImage(UIImage(named: ""), forState: .Normal)
                setTheScene("b48")
            }
        
    case "b57":
        if sender.tag == 0 {
            playSound("lock", type: "wav")
            objectsArray.removeObjectAtIndex(0)
            defaults.setObject(objectsArray, forKey: "objectsArray")
            setupHUD()
            sender.setBackgroundImage(UIImage(named: ""), forState: .Normal)
            setTheScene("b58")
        }
        
    case "b86":
        if sender.tag == 1 {
            playSound("lock", type: "wav")
            objectsArray.removeObjectAtIndex(1)
            defaults.setObject(objectsArray, forKey: "objectsArray")
            setupHUD()
            sender.setBackgroundImage(UIImage(named: ""), forState: .Normal)
            setTheScene("b87")
        }
        
    case "b90":
        if sender.tag == 0 {
            playSound("lock", type: "wav")
            objectsArray.removeObjectAtIndex(0)
            defaults.setObject(objectsArray, forKey: "objectsArray")
            setupHUD()
            sender.setBackgroundImage(UIImage(named: ""), forState: .Normal)
            setTheScene("b91")
        }
        
    case "b103":
        if sender.tag == 0 {
            playSound("lock", type: "wav")
            objectsArray.removeObjectAtIndex(0)
            defaults.setObject(objectsArray, forKey: "objectsArray")
            setupHUD()
            sender.setBackgroundImage(UIImage(named: ""), forState: .Normal)
            setTheScene("b104")
        }
        
        
    default:break }
}
    
    
    
    

    
    
    
    
// MARK: - GAME OVER!
func gameOver() {
    touchView2.frame = CGRectMake(0, 0, 0, 0)
    touchView.frame = CGRectMake(0, 0, 0, 0)
    playSound("flame", type: "wav")
    
    gameOverFlames.frame.origin.y = 0
    var images : [UIImage] = []
    for i in 0..<9 { images.append(UIImage(named: "f\(i)")!) }
    gameOverFlames.animationImages = images
    gameOverFlames.animationDuration = 0.8
    gameOverFlames.startAnimating()
        
    UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
        self.gameOverFlames.alpha = 1
    }, completion: { (finished: Bool) in
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "goToGameOver", userInfo: nil, repeats: false)
    })
}
func goToGameOver() {
    let goVC = storyboard?.instantiateViewControllerWithIdentifier("GameOver") as! GameOver
    goVC.modalTransitionStyle = .CrossDissolve
    presentViewController(goVC, animated: true, completion: nil)
}
    
    
    
    
    
// PLAY SOUND CLIPS
func playSound(name:String, type:String) {
    let filePath = NSBundle.mainBundle().pathForResource(name, ofType: type)
    soundURL = NSURL(fileURLWithPath: filePath!)
    AudioServicesCreateSystemSoundID(soundURL!, &soundID)
    AudioServicesPlaySystemSound(soundID)
}
    
    
// MARK: - PLAY VIDEOS
func playVideo(name:String, type:String) {
    let videoPath = NSBundle.mainBundle().pathForResource(name, ofType: type)
    let url = NSURL(fileURLWithPath: videoPath!)
    moviePlayer = MPMoviePlayerController(contentURL: url)
    moviePlayer.view.frame = self.view.bounds
    moviePlayer.prepareToPlay()
    moviePlayer.scalingMode = .AspectFit
    moviePlayer.controlStyle = .None
    view.addSubview(moviePlayer.view)
}
// REMOVE MOVIE PLAYER WHEN STOPPED
func checkVideoState() {
    if moviePlayer.playbackState == .Paused {
        moviePlayer.view.removeFromSuperview()
        touchView.hidden = false
        touchView2.hidden = false
        
        // End game
        if sceneSaved == "b105" {
            let goVC = storyboard?.instantiateViewControllerWithIdentifier("GameOver") as! GameOver
            goVC.modalTransitionStyle = .CrossDissolve
            // sceneSaved = "b0"
            // defaults.setObject(sceneSaved, forKey: "sceneSaved")
            presentViewController(goVC, animated: true, completion: nil)
        }
    }
}


    
    
// MARK: - SAVE OBJECTS ARRAY
func saveObjectsArray(objectName:String) {
    objectsArray.addObject(objectName)
    defaults.setObject(objectsArray, forKey: "objectsArray")
    print("OBJECTS: \(objectsArray)")
}
    

// MARK: - SETUP HUD
func setupHUD() {
    for i in 0..<objectsArray.count {
        hudButtons[i].setBackgroundImage(UIImage(named: "\(objectsArray[i])"), forState: .Normal)
    }
}
    
    
    
    
// MARK: - PAUSE BUTTON
@IBAction func pauseButt(sender: AnyObject) {
    let pVC = storyboard?.instantiateViewControllerWithIdentifier("PauseVC") as! PauseVC
    pVC.modalTransitionStyle = .CrossDissolve
    presentViewController(pVC, animated: true, completion: nil)
}
    
    
    
    
    
    

// MARK: - ADMOB INTERSTITIAL
func callAdMobInterstitial() {
    if !removeAds {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        adMobInterstitial = GADInterstitial(adUnitID: ADMOB_UNIT_ID)
        adMobInterstitial.loadRequest(GADRequest())
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.showInterstitial()
        }
    } else { print("NO ADS - IAP PURCHASED") }
}
    
func showInterstitial() {
    if adMobInterstitial.isReady {
        adMobInterstitial.presentFromRootViewController(self)
        print("AdMob Interstitial is showing!")
    }
}

    
    
    
    
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

