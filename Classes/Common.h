/*
 *  Common.h
 *  Flyer
 *
 *  Created by Riksof Pvt. Ltd. on 22/Jan/2014.
 *
 */


#define ALPHA0 0
#define ALPHA1 1
#define IMAGETYPE @"png"
#define YOUTUBEPREFIX @"https://youtube.com/watch?v="
#define OldFlyerlyWidth 620
#define OldFlyerlyHeight 620
#define flyerlyWidth 1240
#define flyerlyHeight 1240
#define FLYER_ZOOM_MIN_SCALE 1.0
#define FLYER_ZOOM_SET_SCALE 2.0 //THIS MUST BE IN RANGE OF MIN AND MAX
#define FLYER_ZOOM_MAX_SCALE 5.0
#define VIDEOFRAME 30
#define MAX_VIDEO_LENGTH 30
#define FLYER_ALBUM_NAME @"Flyerly"
#define FLYER_PURCHASED_ALBUM_NAME @"Flyerly Purchases"
#define FLYERLY_BIZ_ALBUM_NAME @"FlyerlyBiz"
#define FLYERLY_BIZ_PURCHASED_ALBUM_NAME @"FlyerlyBiz Purchases"


#define RADIANS(degrees) ((degrees * M_PI) / 180.0)
#define GROW_ANIMATION_DURATION_SECONDS 0.15
#define SHRINK_ANIMATION_DURATION_SECONDS 0.15
#define SOURCETYPE UIImagePickerControllerSourceTypePhotoLibrary
#define DOCSFOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#define COLOR_ARRAY [NSArray arrayWithObjects: [UIColor whiteColor], [UIColor darkGrayColor], [UIColor grayColor], [UIColor orangeColor], [UIColor blackColor], [UIColor blueColor], [UIColor redColor], [UIColor greenColor], [UIColor purpleColor], [UIColor yellowColor], [UIColor brownColor], [UIColor cyanColor], [UIColor magentaColor],nil]

#define TEMPLATE_ARRAY [NSArray arrayWithObjects:\
[UIImage imageNamed:@"T0.jpg"],\
[UIImage imageNamed:@"T1.jpg"],\
[UIImage imageNamed:@"T2.jpg"],\
[UIImage imageNamed:@"T3.jpg"],\
[UIImage imageNamed:@"T4.jpg"],\
[UIImage imageNamed:@"T5.jpg"],\
[UIImage imageNamed:@"T6.jpg"],\
[UIImage imageNamed:@"T7.jpg"],\
[UIImage imageNamed:@"T8.jpg"],\
[UIImage imageNamed:@"T9.jpg"],\
[UIImage imageNamed:@"T10.jpg"],\
[UIImage imageNamed:@"T11.jpg"],\
[UIImage imageNamed:@"T12.jpg"],\
[UIImage imageNamed:@"T13.jpg"],\
[UIImage imageNamed:@"T14.jpg"],\
[UIImage imageNamed:@"T15.jpg"],\
[UIImage imageNamed:@"T16.jpg"],\
[UIImage imageNamed:@"T17.jpg"],\
[UIImage imageNamed:@"T18.jpg"],\
[UIImage imageNamed:@"T19.jpg"],\
[UIImage imageNamed:@"T20.jpg"],\
[UIImage imageNamed:@"T21.jpg"],\
[UIImage imageNamed:@"T22.jpg"],\
[UIImage imageNamed:@"T23.jpg"],\
[UIImage imageNamed:@"T24.jpg"],\
[UIImage imageNamed:@"T25.jpg"],\
[UIImage imageNamed:@"T26.jpg"],\
[UIImage imageNamed:@"T27.jpg"],\
[UIImage imageNamed:@"T28.jpg"],\
[UIImage imageNamed:@"T29.jpg"],\
[UIImage imageNamed:@"T30.jpg"],\
[UIImage imageNamed:@"T31.jpg"],\
[UIImage imageNamed:@"T32.jpg"],\
[UIImage imageNamed:@"T33.jpg"],\
[UIImage imageNamed:@"T34.jpg"],\
[UIImage imageNamed:@"T35.jpg"],\
[UIImage imageNamed:@"T36.jpg"],\
[UIImage imageNamed:@"T37.jpg"],\
[UIImage imageNamed:@"T38.jpg"],\
[UIImage imageNamed:@"T39.jpg"],\
[UIImage imageNamed:@"T40.jpg"],\
[UIImage imageNamed:@"T41.jpg"],\
[UIImage imageNamed:@"T42.jpg"],\
[UIImage imageNamed:@"T43.jpg"],\
[UIImage imageNamed:@"T44.jpg"],\
[UIImage imageNamed:@"T45.jpg"],\
[UIImage imageNamed:@"T46.jpg"],\
[UIImage imageNamed:@"T47.jpg"],\
[UIImage imageNamed:@"T48.jpg"],\
nil]

#define ICON_ARRAY [NSArray arrayWithObjects:\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon0"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon1"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon2"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon3"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon4"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon5"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon6"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon7"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon8"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon9"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon10"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon11"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon12"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon13"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon14"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon15"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon16"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon17"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon18"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon19"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon20"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon21"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon22"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon23"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon24"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon25"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon26"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon27"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon28"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon29"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon30"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon31"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon32"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon33"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon34"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon35"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon36"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon37"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon38"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon39"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon40"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon41"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon42"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon43"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon44"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon45"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon46"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon47"] ofType:@"jpg"],\
[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"icon48"] ofType:@"jpg"],\
nil]

#define FONT_ARRAY [NSArray arrayWithObjects:\
[UIFont fontWithName:@"Courier" size:16],\
[UIFont fontWithName:@"Courier-BoldOblique" size:16],\
[UIFont fontWithName:@"Courier-Oblique" size:16],\
[UIFont fontWithName:@"Courier-Bold" size:16],\
[UIFont fontWithName:@"ArialMT" size:16],\
[UIFont fontWithName:@"Arial-BoldMT" size:16],\
[UIFont fontWithName:@"Arial-BoldItalicMT" size:16],\
[UIFont fontWithName:@"Arial-ItalicMT" size:16],\
[UIFont fontWithName:@"STHeitiTC-Light" size:16],\
[UIFont fontWithName:@"AppleGothic" size:16],\
[UIFont fontWithName:@"CourierNewPS-BoldMT" size:16],\
[UIFont fontWithName:@"CourierNewPS-ItalicMT" size:16],\
[UIFont fontWithName:@"Zapfino" size:16],\
[UIFont fontWithName:@"TimesNewRomanPSMT" size:16],\
[UIFont fontWithName:@"Verdana-Italic" size:16],\
[UIFont fontWithName:@"Verdana" size:16],\
[UIFont fontWithName:@"Georgia" size:16],\
[UIFont fontWithName:@"Georgia-BoldItalic" size:16],\
[UIFont fontWithName:@"Georgia-Italic" size:16],\
[UIFont fontWithName:@"TrebuchetMS" size:16],\
[UIFont fontWithName:@"Trebuchet-BoldItalic" size:16],\
[UIFont fontWithName:@"Helvetica" size:16],\
[UIFont fontWithName:@"Helvetica-Oblique" size:16],\
[UIFont fontWithName:@"Helvetica-Bold" size:16],\
[UIFont fontWithName:@"AmericanTypewriter" size:16],\
[UIFont fontWithName:@"AmericanTypewriter-Bold" size:16],\
[UIFont fontWithName:@"ArialUnicodeMS" size:16],\
[UIFont fontWithName:@"HiraKakuProN-W6" size:16],\
nil]


#define REGISTERED @"Registered"
#define ANONYMOUS @"Anonymous"

#define NOT_FOUND_IN_APP @"NOT_FOUND_IN_APP"

#if defined(FLYERLY)

    #define TARGET_NAME @"FLYERLY"
    #define APP_NAME @"Flyerly"

    //Packages for purchase
    #define BUNDLE_IDENTIFIER_ALL_DESIGN @"com.flyerly.CompleteBundle"
    #define BUNDLE_IDENTIFIER_UNLOCK_VIDEO @"com.flyerly.UnlockCreateVideoFlyerOption"
    #define BUNDLE_IDENTIFIER_MONTHLY_SUBSCRIPTION @"com.flyerly.MonthlyBundle"
    #define BUNDLE_IDENTIFIER_YEARLY_SUBSCRIPTION @"com.flyerly.YearlyBundle"
    #define BUNDLE_IDENTIFIER_AD_REMOVAL @"com.flyelry.AdsRemovalMonthly"

    // bundle ids was expired by apple, thats why we need to check first user have product with old name ?
    #define BUNDLE_IDENTIFIER_OLD_ALL_DESIGN @"com.flyerly.AllDesignBundle"
    #define BUNDLE_IDENTIFIER_OLD_MONTHLY_SUBSCRIPTION @"com.flyerly.MonthlyGold"
    #define BUNDLE_IDENTIFIER_OLD_YEARLY_SUBSCRIPTION @"com.flyerly.YearlyPlatinum1"
    #define BUNDLE_IDENTIFIER_OLD_AD_REMOVAL @"com.flyerly.AdRemovalMonthly"


    //purchased bundles
    #define IN_APP_ID_ALL_DESIGN @"comflyerlyAllDesignBundle"
    #define IN_APP_ID_UNLOCK_VIDEO @"comflyerlyUnlockCreateVideoFlyerOption"
    #define IN_APP_ID_MONTHLY_SUBSCRIPTION @"comflyerlyMonthlyGold"
    #define IN_APP_ID_YEARLY_SUBSCRIPTION @"comflyerlyYearlyPlatinum1"
    #define IN_APP_ID_AD_REMOVAL @"comflyerlyAdRemovalMonthly"

    #define IN_APP_ID_SAVED_FLYERS @"comflyerlyUnlockSavedFlyers"
    #define IN_APP_ID_ICON_BUNDLE @"comflyerlyIconsBundle"

#else

    #define TARGET_NAME @"FLYERLY_BIZ"
    #define APP_NAME @"FlyerlyBiz"

    //Packages for purchase
    #define BUNDLE_IDENTIFIER_ALL_DESIGN @"com.flyerlybiz.AllDesignBundle"
    #define BUNDLE_IDENTIFIER_UNLOCK_VIDEO @"com.flyerlybiz.VideoFlyers"
    #define BUNDLE_IDENTIFIER_MONTHLY_SUBSCRIPTION @"com.flyerlybiz.MonthlyGold"
    #define BUNDLE_IDENTIFIER_YEARLY_SUBSCRIPTION @"com.flyerlybiz.YearlyPlatinum1"
    #define BUNDLE_IDENTIFIER_AD_REMOVAL @"com.flyerlybiz.AdsRemoval"

    // bundle ids was expired by apple, thats why we need to check first user have product with old name ?
    #define BUNDLE_IDENTIFIER_OLD_ALL_DESIGN @"com.flyerlybiz.AllDesignBundle"
    #define BUNDLE_IDENTIFIER_OLD_MONTHLY_SUBSCRIPTION @"com.flyerlybiz.MonthlyGold"
    #define BUNDLE_IDENTIFIER_OLD_YEARLY_SUBSCRIPTION @"com.flyerlybiz.YearlyPlatinum1"
    #define BUNDLE_IDENTIFIER_OLD_AD_REMOVAL @"com.flyerlybiz.AdsRemoval"

    //purchased bundles
    #define IN_APP_ID_ALL_DESIGN @"comflyerlybizAllDesignBundle"
    #define IN_APP_ID_UNLOCK_VIDEO @"comflyerlybizVideoFlyers"
    #define IN_APP_ID_MONTHLY_SUBSCRIPTION @"comflyerlybizMonthlyGold"
    #define IN_APP_ID_YEARLY_SUBSCRIPTION @"comflyerlybizYearlyPlatinum1"
    #define IN_APP_ID_AD_REMOVAL @"comflyerlybizAdsRemoval"

    #define IN_APP_ID_SAVED_FLYERS NOT_FOUND_IN_APP
    #define IN_APP_ID_ICON_BUNDLE NOT_FOUND_IN_APP

#endif


#define SIZE_ARRAY [NSArray arrayWithObjects: @"10", @"11" ,@"12",@"14",@"16",@"18",@"20",@"22",@"24",  @"26", @"28", @"30",@"36",@"42",@"48",@"52",@"60",@"72",@"74",@"80",@"90",nil]

#define DRAWING_PATTERNS_ARRAY [NSArray arrayWithObjects: DRAWING_PLANE_LINE, DRAWING_DASHED_LINE ,DRAWING_DOTTED_LINE,nil]


#define WIDTH_ARRAY [NSArray arrayWithObjects: @"50", @"75" ,@"100",@"120",@"140",@"160",@"175",@"200",@"220",@"240",@"260",nil]

#define HEIGHT_ARRAY [NSArray arrayWithObjects: @"50", @"75" ,@"100",@"120",@"140",@"160",@"175",@"200",@"220",@"240",@"260",@"300",@"320",nil]

#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)

#define LAYER_ATTRIBUTE_SIZE @"Size"
#define LAYER_ATTRIBUTE_COLOR @"Color"
#define LAYER_ATTRIBUTE_BORDER @"Border"
#define LAYER_ATTRIBUTE_IMAGE @"Image"
#define LAYER_ATTRIBUTE_FONT @"Font"
#define LAYER_ATTRIBUTE_DRAWING_PATTERN @"DRAWING_PATTERN"


#define FlickrAPIKey @"b2ea05c41f53e1dc4d6e6edee9e6ee06"
#define FlickrSecretKey @"d4af50fe93325de3"
#define kStoredAuthTokenKeyName @"FlickrOAuthToken"
#define kStoredAuthTokenSecretKeyName @"FlickrOAuthTokenSecret"
#define kTryObtainAuthToken @"TryAuth"
#define kGetAccessTokenStep @"kGetAccessTokenStep";
#define kFetchRequestTokenStep @"kFetchRequestTokenStep"
#define kCallbackURLBaseString @"oatransdemo://www.google.com"
#define kCallbackURLBaseStringPrefix @"oatransdemo"

#define kStoredTumblrAuthTokenKeyName @"TumblrOAuthToken"
#define kStoredTumblrAuthTokenSecretKeyName @"TumblrOAuthTokenSecret"
#define TumblrAPIKey @"7g8ugn9opLIb2oKLQBlnbDjBoYKQHbVd9TgtVZRMz5NK1GXgXS"
#define TumblrSecretKey @"4uAmyM6YOL0UyGykUPaRpkCVVELLze9Nu1I2bNWXRWYOuDQA6u"

#define FOURSQUARE_CLIENT_ID @"N2UKFTKALD4UBCB0ADNF30O5KIRV03X4UVG0S5Q5V43EDLPN"
#define FOURSQUARE_CALLBACK_URL @"fsqapi://foursquare"

#define AddCaptionText @"Add caption here"
#define NameYourFlyerText @"Name your Flyer"
#define FlyerDateFormat @"MM/dd/YYYY"

#define COLUMN_REMINING_FONT_COUNT @"remainingFontCount"
#define COLUMN_USER @"user"
#define COLUMN_JSON @"json"
#define TABLE_JSON @"InApp"

#define IN_APP_DICTIONARY_KEY @"inAppDictionaryKey"

#define PRODUCT_ICON_SELETED @"com.flyerly.SelectedSymbol"
#define PRODUCT_ICON_ALL @"com.flyerly.AllSymbolsBundle"

#define PRODUCT_SYMBOL_SELETED @"com.flyerly.SelectedIcon"
#define PRODUCT_SYMBOL_ALL @"com.flyerly.IconsBundle"

#define PRODUCT_FONT @"com.flyerly.font"
#define PRODUCT_FOUR_PACK_FONT @"com.flyerly.4FontsPack"
#define PRODUCT_FULL_FONT @"com.flyerly.FontBundle"

#define PRODUCT_FONT_COLOR @"com.flyerly.Fontcolor"
#define PRODUCT_FOUR_FONT_COLOR @"com.flyerly.4FontColors"
#define PRODUCT_FULL_FONT_COLOR @"com.flyerly.AllFontsColors"

#define PRODUCT_FONT_BORDER_COLOR @"com.flyerly.FontBorderColor"
#define PRODUCT_FOUR_FONT_BORDER_COLOR @"com.flyerly.4FontBorderColors"
#define PRODUCT_FULL_FONT_BORDER_COLOR @"com.flyerly.AllFontBordersColors"

#define PRODUCT_FLYER_BORDER_COLOR @"com.flyerly.FlyerBorderColor"
#define PRODUCT_FULL_FLYER_BORDER_COLOR @"com.flyerly.AllFlyersBorders"

#define PRODUCT_TEMPLATE @"com.flyerly.FlyerBackground"
#define PRODUCT_FULL_TEMPLATE @"com.flyerly.AllFlyerBackground"

#define PRODUCT_ALL_BUNDLE @"com.flyerly.AllDesignBundle"

#define PREFIX_FONT_PRODUCT @"com.flyerly.font"
#define PREFIX_FONT_COLOR_PRODUCT @"com.flyerly.color"
#define PREFIX_TEXT_BORDER_PRODUCT @"com.flyerly.textborder"
#define PREFIX_FLYER_BORDER_PRODUCT @"com.flyerly.flyerborder"
#define PREFIX_BACKGROUND_PRODUCT @"com.flyerly.background"
#define PREFIX_ICON_PRODUCT @"com.flyerly.Symbol"
#define PREFIX_SYMBOL_PRODUCT @"com.flyerly.Icon"


#define ADD_MORE_TEXTTAB 0
#define ADD_MORE_PHOTOTAB 1
#define ADD_MORE_SYMBOLTAB 2
#define ADD_MORE_ICONTAB 3
#define ARRANGE_LAYERTAB 4

// Button font
#define BUTTON_FONT @"Symbol"
// Title font
#define TITLE_FONT @"AvenirNext-Bold"
// Other font
#define OTHER_FONT @"HelveticaNeue"

// Layer Types
#define FLYER_LAYER_TEXT      @"0"
#define FLYER_LAYER_IMAGE     @"1"
#define FLYER_LAYER_CLIP_ART  @"2"
#define FLYER_LAYER_EMOTICON  @"3"
#define FLYER_LAYER_DRAWING  @"DrawingImgLayer"
#define FLYER_LAYER_WATER_MARK  @"WATER_MARK"
#define FLYER_LAYER_GIPHY_LOGO  @"GIPHY_LOGO"
#define DRAWING_LAYER_H  612
#define DRAWING_LAYER_W  612
#define DRAWING_PLANE_LINE @"line_plane"
#define DRAWING_DASHED_LINE @"line_dashed"
#define DRAWING_DOTTED_LINE @"line_dotted"

#define DRAWING_LAYER_MODE_NORMAL @"DRAWING_LAYER_MODE_NORMAL"
#define DRAWING_LAYER_MODE_ERASER @"DRAWING_LAYER_MODE_ERASER"


#define WARNING @"WARNING"
#define PLEASE_CREATE_M_T_3_VIDEO @"Please create more then 3 seconds video"
#define Ok @"Ok"
