/*
 *  Common.h
 *  Flyer
 *
 *  Created by Krunal on 10/17/09.
 *  Copyright 2009 iauro. All rights reserved.
 *
 */

#import "MyCustomCell.h"

#define ALPHA0 0
#define ALPHA1 1

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)
#define GROW_ANIMATION_DURATION_SECONDS 0.15
#define SHRINK_ANIMATION_DURATION_SECONDS 0.15
#define SOURCETYPE UIImagePickerControllerSourceTypePhotoLibrary
#define DOCSFOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#define COLOR_ARRAY [NSArray arrayWithObjects: [UIColor whiteColor], [UIColor darkGrayColor], [UIColor grayColor], [UIColor orangeColor], [UIColor blackColor], [UIColor blueColor], [UIColor redColor], [UIColor greenColor], [UIColor purpleColor], [UIColor yellowColor], [UIColor brownColor], [UIColor cyanColor], [UIColor magentaColor],nil]

/*
#define TEMPLATE_ARRAY [NSArray arrayWithObjects: @"T1.jpg",@"T2.jpg",@"T3.jpg",@"T4.jpg",@"T5.jpg",@"T6.jpg",@"T7.jpg",@"T8.jpg",@"T9.jpg",@"T10.jpg",@"T11.jpg",@"T12.jpg",@"T13.jpg",@"T14.jpg",@"T15.jpg",@"T16.jpg",@"T17.jpg",@"T18.jpg",@"T19.jpg",@"T20.jpg",@"T21.jpg",@"T22.jpg",@"T23.jpg",@"T24.jpg",@"T25.jpg",@"T26.jpg",@"T27.jpg",@"T28.jpg",@"T29.jpg",@"T30.jpg",@"T31.jpg",@"T32.jpg",@"T33.jpg",nil]
*/

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

/*
#define ICON_ARRAY [NSArray arrayWithObjects:\
[UIImage imageNamed:@"l0.jpg"],\
[UIImage imageNamed:@"I1.jpg"],\
[UIImage imageNamed:@"I2.jpg"],\
[UIImage imageNamed:@"I3.jpg"],\
[UIImage imageNamed:@"I4.jpg"],\
[UIImage imageNamed:@"I5.jpg"],\
[UIImage imageNamed:@"I6.jpg"],\
[UIImage imageNamed:@"I7.jpg"],\
[UIImage imageNamed:@"I8.jpg"],\
[UIImage imageNamed:@"I9.jpg"],\
[UIImage imageNamed:@"I10.jpg"],\
[UIImage imageNamed:@"I11.jpg"],\
[UIImage imageNamed:@"I12.jpg"],\
[UIImage imageNamed:@"I13.jpg"],\
[UIImage imageNamed:@"I14.jpg"],\
[UIImage imageNamed:@"I15.jpg"],\
[UIImage imageNamed:@"I16.jpg"],\
[UIImage imageNamed:@"I17.jpg"],\
[UIImage imageNamed:@"I18.jpg"],\
[UIImage imageNamed:@"I19.jpg"],\
[UIImage imageNamed:@"I20.jpg"],\
[UIImage imageNamed:@"I21.jpg"],\
[UIImage imageNamed:@"I22.jpg"],\
[UIImage imageNamed:@"I23.jpg"],\
[UIImage imageNamed:@"I24.jpg"],\
[UIImage imageNamed:@"I25.jpg"],\
[UIImage imageNamed:@"I26.jpg"],\
[UIImage imageNamed:@"I27.jpg"],\
[UIImage imageNamed:@"I28.jpg"],\
[UIImage imageNamed:@"I29.jpg"],\
[UIImage imageNamed:@"I30.jpg"],\
[UIImage imageNamed:@"I31.jpg"],\
[UIImage imageNamed:@"I32.jpg"],\
[UIImage imageNamed:@"I33.jpg"],\
[UIImage imageNamed:@"I34.jpg"],\
[UIImage imageNamed:@"I35.jpg"],\
[UIImage imageNamed:@"I36.jpg"],\
[UIImage imageNamed:@"I37.jpg"],\
[UIImage imageNamed:@"I38.jpg"],\
[UIImage imageNamed:@"I39.jpg"],\
[UIImage imageNamed:@"I40.jpg"],\
[UIImage imageNamed:@"I41.jpg"],\
[UIImage imageNamed:@"I42.jpg"],\
[UIImage imageNamed:@"I43.jpg"],\
[UIImage imageNamed:@"I44.jpg"],\
[UIImage imageNamed:@"I45.jpg"],\
[UIImage imageNamed:@"I46.jpg"],\
[UIImage imageNamed:@"I47.jpg"],\
[UIImage imageNamed:@"I48.jpg"],\
nil]
*/

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

#define SIZE_ARRAY [NSArray arrayWithObjects: @"10", @"11" ,@"12",@"14",@"16",@"18",@"20",@"22",@"24",  @"26", @"28", @"30",@"36",@"42",@"48",@"52",@"60",@"72",@"74",@"80",@"90",nil]

#define WIDTH_ARRAY [NSArray arrayWithObjects: @"50", @"75" ,@"100",@"120",@"140",@"160",@"175",@"200",@"220",@"240",@"260",nil]

#define HEIGHT_ARRAY [NSArray arrayWithObjects: @"50", @"75" ,@"100",@"120",@"140",@"160",@"175",@"200",@"220",@"240",@"260",@"300",@"320",nil]



#define SET_GLOBAL_CUSTOM_CELL_PROPERTIES(title,description,created,img,imagePath){\
static NSString *cellId = @"Cell";\
MyCustomCell *cell = (MyCustomCell *)[tableView dequeueReusableCellWithIdentifier:cellId];\
if (cell == nil) {\
cell = [[[MyCustomCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellId] autorelease];\
}\
[cell setAccessoryType:UITableViewCellAccessoryNone]; \
[cell addToCell: title :description :created :img :imagePath];\
return cell;\
}

#define HEIGHT_IPHONE_5 568
#define IS_IPHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds ].size.height == HEIGHT_IPHONE_5 )

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

#define PREFIX_FONT_PRODUCT @"com.flyerly.font"
#define PREFIX_FONT_COLOR_PRODUCT @"com.flyerly.color"
#define PREFIX_TEXT_BORDER_PRODUCT @"com.flyerly.textborder"
#define PREFIX_FLYER_BORDER_PRODUCT @"com.flyerly.flyerborder"
#define PREFIX_BACKGROUND_PRODUCT @"com.flyerly.background"

#define ADD_MORE_TEXTTAB 0
#define ADD_MORE_PHOTOTAB 1
#define ADD_MORE_SYMBOLTAB 2
#define ADD_MORE_ICONTAB 3
#define ARRANGE_LAYERTAB 4

//
//#define FONT6_PRODUCT_ID @"com.flyerly.font6"
//#define FONT7_PRODUCT_ID @"com.flyerly.font7"

/*#define FONT_ARRAY [NSArray arrayWithObjects:@"Courier",@"Courier-BoldOblique",@"Courier-Oblique",@"Courier-Bold",@"ArialMT",@"Arial-BoldMT",@"Arial-BoldItalicMT",@"Arial-ItalicMT",@"STHeitiTC-Light",@"STHeitiTC-Medium",@"AppleGothic",@"CourierNewPS-BoldMT",@"CourierNewPS-ItalicMT",@"CourierNewPS-BoldItalicMT",@"CourierNewPSMT",@"Zapfino",@"HiraKakuProN-W6",@"ArialUnicodeMS",@"STHeitiSC-Medium",@"STHeitiSC-Light",@"AmericanTypewriter",@"AmericanTypewriter-Bold",@"Helvetica-Oblique",@"Helvetica-BoldOblique",@"Helvetica",@"Helvetica-Bold",@"MarkerFelt-Thin",@"HelveticaNeue",@"HelveticaNeue-Bold",@"DBLCDTempBlack",@"Verdana-Bold",@"Verdana-BoldItalic",@"Verdana",@"Verdana-Italic",@"TimesNewRomanPSMT",@"TimesNewRomanPS-BoldMT",@"TimesNewRomanPS-BoldItalicMT",@"TimesNewRomanPS-ItalicMT",@"Georgia-Bold",@"Georgia",@"Georgia-BoldItalic",@"Georgia-Italic",@"STHeitiJ-Medium",@"STHeitiJ-Light",@"ArialRoundedMTBold",@"TrebuchetMS-Italic",@"TrebuchetMS",@"Trebuchet-BoldItalic",@"TrebuchetMS-Bold",@"STHeitiK-Medium",@"STHeitiK-Light",nil]
 */

// Button font
#define BUTTON_FONT @"Symbol"
// Title font
#define TITLE_FONT @"AvenirNext-Bold"
// Other font
#define OTHER_FONT @"HelveticaNeue-UltraLight"