//
//  MySHKConfigurator.m
//  Flyr
//
//  Created by Riksof on 27/12/2013.
//
//

#import "FlyerlyConfigurator.h"
//#import "SHKFile.h"
#import "PaypalMobile.h"
#import <Social/Social.h>
#import "Common.h"

@implementation FlyerlyConfigurator

/*
 App Description
 ---------------
 These values are used by any service that shows 'shared from XYZ'
 */
- (NSString*)appName {
	
    return APP_NAME;
}

- (NSString*)appURL {
	
    #if defined(FLYERLY) // Flyerly
        return @"http://www.flyer.ly";
    #else // Flyerly Biz
        return @"http://www.flyerly.com/biz";
    #endif
}

- (NSString*)referralURL{
    
    #if defined(FLYERLY) // Flyerly
        return @"http://app.flyerly.com/cs?i=";
    #else // Flyerly Biz
        return @"http://biz.flyerly.com/cs?i=";
    #endif
}

- (NSString*)appLinkURL{
    
    #if defined(FLYERLY) // Flyerly
        return @"http://app.flyerly.com/cs";
    #else // Flyerly Biz
        return @"http://flyerly.com/biz/";
    #endif
}
- (NSString*)appInvitePreviewImageURL{
    #if defined(FLYERLY) // Flyerly
        return @"http://greenmtnlabs.com/flyerly/images/phones.png";
    #else // Flyerly Biz
        return @"http://greenmtnlabs.com/images/bizphone.png";
    #endif
}


/*
 API Keys
 --------
 This is the longest step to getting set up, it involves filling in API keys for the supported services.
 It should be pretty painless though and should hopefully take no more than a few minutes.
 
 Each key below as a link to a page where you can generate an api key.  Fill in the key for each service below.
 
 A note on services you don't need:
 If, for example, your app only shares URLs then you probably won't need image services like Flickr.
 In these cases it is safe to leave an API key blank.
 
 However, it is STRONGLY recommended that you do your best to support all services for the types of sharing you support.
 The core principle behind ShareKit is to leave the service choices up to the user.  Thus, you should not remove any services,
 leaving that decision up to the user.
 */

//Debug mood
- (BOOL)currentDebugMood {
    
#ifdef DEBUG
    
	return true;
    
#else
    
    return false;
    
#endif
    
}


//BannerAd Id
- (NSString*)bannerAdID {
    
#ifdef DEBUG
    
    //ozair's account
	//return @"ca-app-pub-5409664730066465/8030978831";
    
    //Rehan's a/c
    return @"ca-app-pub-1703558915514520/6691113092";
    
#else
    //Live Jen'account
    #if defined(FLYERLY) // Flyerly
        return @"ca-app-pub-3218409375181552/2458746629";
    #else // Flyerly Biz
        return @"ca-app-pub-3218409375181552/2750207422";
    #endif
#endif

}

//InterstitialAdd Id
- (NSString*)interstitialAdID {
    
#ifdef DEBUG
    
    //ozair's account
	//return @"ca-app-pub-5409664730066465/9926514430";
    
    //Rehan's a/c
    return @"ca-app-pub-1703558915514520/8955078699";
    
#else
    //Live Jen'account
    #if defined(FLYERLY) // Flyerly
        return @"ca-app-pub-3218409375181552/5412213028";
    #else // Flyerly Biz
        return @"ca-app-pub-3218409375181552/7180407024";
    #endif
#endif
    
}


- (NSString*)bigstockAccountId {

#ifdef DEBUG
    
    //ozair.nazir@riksof.com / riksof123
	return @"862265";
    
#else
    
    return @"328312";
    
#endif
    
}

- (NSString*)bigstockSecretKey {
    
#ifdef DEBUG
    
	return @"e84301b7de141bc89517fc708de3285c825bb648";
    
#else
    
    return @"f5d82349baeb5243b61599591536b97d95950d72";
    
#endif
    
}

- (NSString *const)paypalEnvironment {
    
#ifdef DEBUG
    
    return PayPalEnvironmentSandbox;//testing send box
    
#else
    /*
    //    return PayPalEnvironmentProduction;
    //only for rehan's testing MUST enable after RELEASING on app store, other wise preston a/c will be sucked...
    return PayPalEnvironmentSandbox;
    */
    return PayPalEnvironmentProduction; //live paypal a/c
    
#endif
    
}


//Lob ApiKey
- (NSString*)lobAppId {
    
#ifdef DEBUG
    
    //return @"test_b5d690f19a73468edc528b5a4c63f9875c8"; //preston a/c test details
    //Key extracted from [https://dashboard.lob.com/account] using [ ozair.nazir@riksof.com] a/c test details
    //return @"test_13fb536c2d9e23b0e25657d9f923261b03b";//test a/c [ ozair.nazir@riksof.com ]
    return @"test_964f662f2e4739cf7e485d85cf3b143052e";//test a/c of [ abdul.rauf@riksof.com ]
    
#else
    return @"live_889eeb7a75372e642ceaece3aa9d2ac0dfc"; //greenmtnlabs@gmail.com a/c live details
    
#endif
    
}


- (NSString*)paypalEnvironmentId {
    
#ifdef DEBUG
    
    return @"AWGYCRB32qMlpNyIY9_kKXXsDIZN7UG5JNM5zjCWwXWvLu66SQP3WjbU9v-A";
    
#else
    
    return @"AYxR7BCKR4RGcyfH0zKMtZFJbMsXSD5SN6tcJ20nu_CQA32DClzD78XvZjXx";
    
#endif
    
}

//Crittercism ApiKey
- (NSString*)crittercismAppId {
    #if defined(FLYERLY) // Flyerly
        return @"519a14f897c8f27969000019";
    #else // Flyerly Biz
        return @"3a4fc035429242a383c9be5d7c032bdd00555300";
    #endif
	
}

//Parse Online Keys
- (NSString*)parseOnlineAppId{
    return @"rrU7ilSR4TZNQD9xlDtH8wFoQNK4st5AaITq6Fan";
}
- (NSString*)parseOnlineClientKey{
    return @"P0FxBvDvw0eDYYT01cx8nhaDQdl90BdHGc22jPLn";
}

//Parse Offline Keys
- (NSString*)parseOfflineAppId{
    return @"1zE9CnuScHj4l7dGFbT8NG15uTNb8VazMpsdoCis"; //zohaib bhai test a/c
}

- (NSString*)parseOfflineClientKey{
    return @"rFdNdJfzWt8YIf66G7twr0D5zp9uVsWuAkMEnkpc"; //zohaib bhai test a/c
}

//Flurry SessionKey
- (NSString*)flurrySessionId{
    #if defined(FLYERLY) // Flyerly
        return @"ZWXZFGSQZ4GMYZBVZYN3";
    #else // Flyerly Biz
        return @"CFNHH68Y7DF4RVG8VVS5";
    #endif
}


// Vkontakte
// SHKVkontakteAppID is the Application ID provided by Vkontakte
- (NSString*)vkontakteAppId {
	return @"";
}

// Facebook - https://developers.facebook.com/apps
// SHKFacebookAppID is the Application ID provided by Facebook
// SHKFacebookLocalAppID is used if you need to differentiate between several iOS apps running against a single Facebook app. Useful, if you have full and lite versions of the same app,
// and wish sharing from both will appear on facebook as sharing from one main app. You have to add different suffix to each version. Do not forget to fill both suffixes on facebook developer ("URL Scheme Suffix"). Leave it blank unless you are sure of what you are doing.
// The CFBundleURLSchemes in your App-Info.plist should be "fb" + the concatenation of these two IDs.
// Example:
//    SHKFacebookAppID = 555
//    SHKFacebookLocalAppID = lite
//
//    Your CFBundleURLSchemes entry: fb555lite
- (NSString*)facebookAppId {
    
    #if defined(FLYERLY) // Flyerly
        return @"136691489852349";
    #else // Flyerly Biz
        return @"1755119231374505";
    #endif
}

- (NSString*)facebookLocalAppId {
	return nil;
}

//Change if your app needs some special Facebook permissions only. In most cases you can leave it as it is.

// new with the 3.1 SDK facebook wants you to request read and publish permissions separatly. If you don't
// you won't get a smooth login/auth flow. Since ShareKit does not require any read permissions.
- (NSArray*)facebookWritePermissions {
    return [NSArray arrayWithObjects:@"publish_actions", nil];
}
- (NSArray*)facebookReadPermissions {
    return nil;	// this is the defaul value for the SDK and will afford basic read permissions
}

/*
 If you want to force use of old-style, posting path that does not use the native sheet. One of the troubles
 with the native sheet is that it gives IOS6 props on facebook instead of your app. This flag has no effect
 on the auth path. It will try to use native auth if availible.
 */
- (NSNumber*)forcePreIOS6FacebookPosting {
    
    BOOL result = NO;
    //if they have an account on their device, then use it, but don't force a device level login
    if (NSClassFromString(@"SLComposeViewController")) {
        result = ![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook];
    }
    return [NSNumber numberWithBool:result];

}

/*
 Create a project on Google APIs console,
 https://code.google.com/apis/console . Under "API Access", create a
 client ID as "Installed application" with the type "iOS", and
 register the bundle ID of your application.
 */
- (NSString*)googlePlusClientId {
    
    return @"144370279359-lsst3ttqhr7nrj1krv21hk3urfsou6ic.apps.googleusercontent.com";
}

//Pocket v3 consumer key. http://getpocket.com/developer/apps/. If you have old read it later app, you should obtain new key.
- (NSString *)pocketConsumerKey {
    
    return @"";
}

// Diigo - http://www.diigo.com/api_keys/new/
- (NSString*)diigoKey {
    return @"";
}

// Twitter

/*
 If you want to force use of old-style, pre-IOS5 twitter authentication, set this to true. This way user will have to enter credentials to the OAuthWebView presented by your app. These credentials will not end up in the device account store. If set to false, sharekit takes user credentials from the builtin device store on iOS6 or later and utilizes social.framework to share content. Much easier, and thus recommended is to leave this false and use iOS builtin authentication.
 */
- (NSNumber*)forcePreIOS5TwitterAccess {
	return [NSNumber numberWithBool:false];
}

/* YOU CAN SKIP THIS SECTION unless you set forcePreIOS5TwitterAccess to true, or if you support iOS 4 or older.
 
 Register your app here - http://dev.twitter.com/apps/new
 
 Differences between OAuth and xAuth
 --
 There are two types of authentication provided for Twitter, OAuth and xAuth.  OAuth is the default and will
 present a web view to log the user in.  xAuth presents a native entry form but requires Twitter to add xAuth to your app (you have to request it from them).
 If your app has been approved for xAuth, set SHKTwitterUseXAuth to 1.
 
 Callback URL (important to get right for OAuth users)
 --
 1. Open your application settings at http://dev.twitter.com/apps/
 2. 'Application Type' should be set to BROWSER (not client)
 3. 'Callback URL' should match whatever you enter in SHKTwitterCallbackUrl.  The callback url doesn't have to be an actual existing url.  The user will never get to it because ShareKit intercepts it before the user is redirected.  It just needs to match.
 */

- (NSString*)twitterConsumerKey {
    
    #if defined(FLYERLY) // Flyerly
        return @"mPqVFHnEHVGj2v1xjnW2WnryF";
        //return @"xYlRtbesxU0Qrxulx5kjdA";
    #else // Flyerly Biz
        return @"JlAwXVRkwu0HvGwVmrPq8dAgz";
    #endif
}

- (NSString*)twitterSecret {

    #if defined(FLYERLY) // Flyerly
        return @"jRB6zK2mHYlbvddLJyMDXattHtqyKna6x1p64d6nve23IYZJT0";
        //return @"v8j6WWLoRDBCIkUQtapbhuOoYOZ4sWjMJovJLIPgO0";
    #else // Flyerly Biz
        return @"5DoqmMkYaK7V4SqRITDCfDGBcgLWo2vDg5DAXcCNV0mPasWGSS";
    #endif
	
}
// You need to set this if using OAuth, see note above (xAuth users can skip it)
- (NSString*)twitterCallbackUrl {
	return @"https://www.google.com.pk";
}
// To use xAuth, set to 1
- (NSNumber*)twitterUseXAuth {
	return [NSNumber numberWithInt:0];
}
// Enter your app's twitter account if you'd like to ask the user to follow it when logging in. (Only for xAuth)
- (NSString*)twitterUsername {
    
    #if defined(FLYERLY)
        return @"flyerlyapp";
    #else
        return @"flyerlybiz";
    #endif
}

// Evernote - http://www.evernote.com/about/developer/api/
/*	You need to set to sandbox until you get approved by evernote. If you use sandbox, you can use it with special sandbox user account only. You can create it here: https://sandbox.evernote.com/Registration.action
 If you already have a consumer-key and secret which have been created with the old username/password authentication system
 (created before May 2012) you have to get a new consumer-key and secret, as the old one is not accepted by the new authentication
 system.
 // Sandbox
 #define SHKEvernoteHost    @"sandbox.evernote.com"
 
 // Or production
 #define SHKEvernoteHost    @"www.evernote.com"
 */

- (NSString*)evernoteHost {
	return @"";
}

- (NSString*)evernoteConsumerKey {
	return @"";
}

- (NSString*)evernoteSecret {
	return @"";
}
// Flickr - http://www.flickr.com/services/apps/create/
/*
 1 - This requires the CFNetwork.framework
 2 - One needs to setup the flickr app as a "web service" on the flickr authentication flow settings, and enter in your app's custom callback URL scheme.
 3 - make sure you define and create the same URL scheme in your app description on Flickr. It can be as simple as yourapp://flickr
 4 - do not override this, unless you subclass the sharer and need more privileges for custom added functionality.*/
- (NSString*)flickrConsumerKey {
    return @"e5ddcf40695fd20da9286b2ad059a315";
}

- (NSString*)flickrSecretKey {
    return @"7143d033fedaff2f";
}
// The user defined callback url
- (NSString*)flickrCallbackUrl{
    return @"https://www.google.com.pk/";
}

- (NSString *)flickrPermissions {
    return @"write";
}

// Bit.ly for shortening URLs, used by some sharers (e.g. Buffer). http://bit.ly/account/register - after signup: http://bit.ly/a/your_api_key If you do not enter bit.ly credentials, URL will be shared unshortened.
- (NSString*)bitLyLogin {
    return @"flyerly";
}

- (NSString*)bitLyKey {
	return @"R_3bdc6f8e82d260965325510421c980a0";
}

// LinkedIn - https://www.linkedin.com/secure/developer
- (NSString*)linkedInConsumerKey {
	return @"";
}

- (NSString*)linkedInSecret {
	return @"";
}

- (NSString*)linkedInCallbackUrl {
	return @"";
}

// Readability - http://www.readability.com/publishers/api/
- (NSString*)readabilityConsumerKey {
	return @"";
}

- (NSString*)readabilitySecret {
	return @"";
}
// To use xAuth, set to 1, Currently ONLY supports XAuth
- (NSNumber*)readabilityUseXAuth {
	return [NSNumber numberWithInt:1];
}

// Foursquare V2 - https://developer.foursquare.com
- (NSString*)foursquareV2ClientId {
    return @"";
}

- (NSString*)foursquareV2RedirectURI {
    return @"";
}

// Tumblr - http://www.tumblr.com/docs/en/api/v2
- (NSString*)tumblrConsumerKey {
	return @"02d5PRV1F7FBSC8gTFzMzrnv8fwuIfFBVcrvCDVMtaV0fk7ZmN";
    //return @"7g8ugn9opLIb2oKLQBlnbDjBoYKQHbVd9TgtVZRMz5NK1GXgXS";

}

- (NSString*)tumblrSecret {
	return @"fvCuTzmDPClRuhGCYLsfevDebgwFKYZy0wDJOvNQr2ngKYjHZ2";
    //return @"7g8ugn9opLIb2oKLQBlnbDjBoYKQHbVd9TgtVZRMz5NK1GXgXS";

}

//you can put whatever here. It must be the same you entered in tumblr app registration, eg tumblr.sharekit.com
- (NSString*)tumblrCallbackUrl {
	return @"http://www.google.com";
}

// Hatena - https://www.hatena.com/yours12345/config/auth/develop
- (NSString*)hatenaConsumerKey {
	return @"";
}

- (NSString*)hatenaSecret {
	return @"";
}

//required permissions. You do not need change these - but it must correspond with what you set during app registration on Hatena.
- (NSString *)hatenaScope {
    return @"write_public,read_public";
}

// Plurk - http://www.plurk.com/API
- (NSString *)plurkAppKey {
    return @"";
}

- (NSString *)plurkAppSecret {
    return @"";
}

- (NSString *)plurkCallbackURL {
    return @"";
}

// Instagram

// Instagram crops images by default
- (NSNumber*)instagramLetterBoxImages {
    return [NSNumber numberWithBool:YES];
}

- (UIColor *)instagramLetterBoxColor
{
    return [UIColor whiteColor];
}

///only show instagram in the application list (instead of Instagram plus any other public/jpeg-conforming apps)
- (NSNumber *)instagramOnly {
    return [NSNumber numberWithBool:YES];
}

//clientid
// YouTube - https://developers.google.com/youtube/v3/guides/authentication#OAuth2_Register
- (NSString*)youTubeConsumerKey {
    #if defined(FLYERLY) // Flyerly
        return @"688107532507-7nm1v37klc2vtfgcaer206k338ub9jqs.apps.googleusercontent.com";
    #else // Flyerly Biz
        return @"487252497579-jptpajrrht0lfaq0ig7h7mkkvfrh5eku.apps.googleusercontent.com"; // using id: abdulrauf618@gmail.com
    #endif
}

//API key
- (NSString*)youTubeSecret {
	
    #if defined(FLYERLY)
        return @"lSn4qPwH3FOytNsqMkeZNYTP";
    #else
        return @"wZCbdJC0fyonfizeoB_aNv_6"; // using id: abdulrauf618@gmail.com
    #endif
}

// Dropbox - https://www.dropbox.com/developers/apps
- (NSString *) dropboxAppKey {
    return @"";
}
- (NSString *) dropboxAppSecret {
    return @"";
}
/*
 This setting should correspond with permission type set during your app registration with Dropbox. You can choose from these two values:
 @"sandbox" (set if you chose permission type "App folder" == kDBRootAppFolder. You will have access only to the app folder you set in  https://www.dropbox.com/developers/apps)
 @"dropbox" (set if you chose permission type "Full dropbox" == kDBRootDropbox)
 */
- (NSString *) dropboxRootFolder {
    return @"sandbox";
}

// if you set NO, a dialogue will appear where user can choose different filename, otherwise the file is silently overwritten.
- (NSNumber *)dropboxShouldOverwriteExistedFile {
    return [NSNumber numberWithBool:YES];
}

// Buffer
/*
 1 - Set up an app at https://bufferapp.com/developers/apps/create
 2 - Once the app is set up this requires a URL Scheme to be set up within your apps info.plist. bufferXXXX where XXXX is your client ID, this will enable Buffer authentication.
 3 - Set bufferShouldShortenURLS. NO will use ShareKit's shortening (if available). YES will use Buffer's shortener once the sheet is autheorised and presented.
 */

- (NSString*)bufferClientID
{
	return @"";
}

- (NSString*)bufferClientSecret
{
	return @"";
}

- (NSNumber *)bufferShouldShortenURLS {
    return [NSNumber numberWithBool:YES];
}

/*
 UI Configuration : Basic
 ------------------------
 These provide controls for basic UI settings.  For more advanced configuration see below.
 */

/*
 For sharers supported by Social.framework you can choose to present Apple's UI (SLComposeViewController) or ShareKit's UI (you can customize ShareKit's UI). Note that SLComposeViewController has only limited sharing capabilities, e.g. for file sharing on Twitter (photo files, video files, large UIImages) ShareKit's UI will be used anyway.
 */
- (NSNumber *)useAppleShareUI {
    return @YES;
}

// Toolbars
- (NSString*)barStyle {
	return @"UIBarStyleDefault";// See: http://developer.apple.com/iphone/library/documentation/UIKit/Reference/UIKitDataTypesReference/Reference/reference.html#//apple_ref/c/econst/UIBarStyleDefault
}

- (UIColor*)barTintForView:(UIViewController*)vc {
    return nil;
}

// Forms
- (UIColor *)formFontColor {
    return nil;
}

- (UIColor*)formBackgroundColor {
    return nil;
}

// iPad views. You can change presentation style for different sharers
- (NSString *)modalPresentationStyleForController:(UIViewController *)controller {
	return @"UIModalPresentationFormSheet";// See: http://developer.apple.com/iphone/library/documentation/UIKit/Reference/UIViewController_Class/Reference/Reference.html#//apple_ref/occ/instp/UIViewController/modalPresentationStyle
}

- (NSString*)modalTransitionStyleForController:(UIViewController *)controller {
	return @"UIModalTransitionStyleCoverVertical";// See: http://developer.apple.com/iphone/library/documentation/UIKit/Reference/UIViewController_Class/Reference/Reference.html#//apple_ref/occ/instp/UIViewController/modalTransitionStyle
}
// ShareMenu Ordering
- (NSNumber*)shareMenuAlphabeticalOrder {
	return [NSNumber numberWithInt:0];// Setting this to 1 will show list in Alphabetical Order, setting to 0 will follow the order in SHKShares.plist
}

/* Name of the plist file that defines the class names of the sharers to use. Usually should not be changed, but this allows you to subclass a sharer and have the subclass be used. Also helps, if you want to exclude some sharers - you can create your own plist, and add it to your project. This way you do not need to change original SHKSharers.plist, which is a part of subproject - this allows you upgrade easily as you did not change ShareKit itself
 
 You can specify also your own bundle here, if needed. For example:
 return [[[NSBundle mainBundle] pathForResource:@"Vito" ofType:@"bundle"] stringByAppendingPathComponent:@"VKRSTestSharers.plist"]
 */
- (NSString*)sharersPlistName {
	return @"SHKSharers.plist";
}

// SHKActionSheet settings
- (NSNumber*)showActionSheetMoreButton {
	return [NSNumber numberWithBool:true];// Setting this to true will show More... button in SHKActionSheet, setting to false will leave the button out.
}

/*
 Favorite Sharers
 ----------------
 These values are used to define the default favorite sharers appearing on ShareKit's action sheet.
 */
- (NSArray*)defaultFavoriteURLSharers {
    return [NSArray arrayWithObjects:@"SHKTwitter",@"SHKFacebook", @"SHKPocket", nil];
}
- (NSArray*)defaultFavoriteImageSharers {
    return [NSArray arrayWithObjects:@"SHKMail",@"SHKFacebook", @"SHKCopy", nil];
}
- (NSArray*)defaultFavoriteTextSharers {
    return [NSArray arrayWithObjects:@"SHKMail",@"SHKTwitter",@"SHKFacebook", nil];
}

//ShareKit will remember last used sharers for each particular mime type.

//- (NSArray *)defaultFavoriteSharersForFile:(SHKFile *)file {
//    
//    NSMutableArray *result = [NSMutableArray arrayWithObjects:@"SHKMail",@"SHKEvernote", nil];
//    if ([file.mimeType hasPrefix:@"video/"] || [file.mimeType hasPrefix:@"audio/"] || [file.mimeType hasPrefix:@"image/"]) {
//        [result addObject:@"SHKTumblr"];
//    }
//    return result;
//}

- (NSArray*)defaultFavoriteSharersForMimeType:(NSString *)mimeType {
    return nil; //[self defaultFavoriteSharersForFile:nil];
}

- (NSArray *)defaultFavoriteFileSharers {
    return nil; //[self defaultFavoriteSharersForFile:nil];
}

//by default, user can see last used sharer on top of the SHKActionSheet. You can switch this off here, so that user is always presented the same sharers for each SHKShareType.
- (NSNumber*)autoOrderFavoriteSharers {
    return [NSNumber numberWithBool:true];
}

/*
 UI Configuration : Advanced
 ---------------------------
 If you'd like to do more advanced customization of the ShareKit UI, like background images and more,
 check out http://getsharekit.com/customize. To use a subclass, you can create your own, and let ShareKit know about it in your configurator, overriding one (or more) of these methods.
 */

- (Class)SHKShareMenuSubclass {
    return NSClassFromString(@"SHKShareMenu");
}

- (Class)SHKShareMenuCellSubclass {
    return NSClassFromString(@"UITableViewCell");
}

///You can override methods from Configuration section (see SHKFormController.h) to use your own cell subclasses.
- (Class)SHKFormControllerSubclass {
    return NSClassFromString(@"SHKFormController");
}

/*
 Advanced Configuration
 ----------------------
 These settings can be left as is.  This only need to be changed for uber custom installs.
 */

- (NSNumber*)maxFavCount {
	return [NSNumber numberWithInt:3];
}

- (NSString*)favsPrefixKey {
	return @"SHK_FAVS_";
}

- (NSString*)authPrefix {
	return @"SHK_AUTH_";
}

- (NSNumber*)allowOffline {
	return [NSNumber numberWithBool:true];
}

- (NSNumber*)allowAutoShare {
	return [NSNumber numberWithBool:true];
}

/*
 Debugging settings
 ------------------
 see Debug.h
 */

/*
 SHKItem sharer specific values defaults
 -------------------------------------
 These settings can be left as is. SHKItem is what you put your data in and inject to ShareKit to actually share. Some sharers might be instructed to share the item in specific ways, e.g. SHKPrint's print quality, SHKMail's send to specified recipients etc. Sometimes you need to change the default behaviour - you can do it here globally, or per share during share item (SHKItem) composing. Example is in the demo app - ExampleShareLink.m - share method */

/* SHKPrint */

- (NSNumber*)printOutputType {
    return [NSNumber numberWithInt:UIPrintInfoOutputPhoto];
}

/* SHKMail */

//You can use this to prefill recipients. User enters them in MFMailComposeViewController by default. Should be array of NSStrings.
- (NSArray *)mailToRecipients {
	return nil;
}

- (NSNumber*)isMailHTML {
    return [NSNumber numberWithInt:1];
}

//used only if you share image. Values from 1.0 to 0.0 (maximum compression).
- (NSNumber*)mailJPGQuality {
    return [NSNumber numberWithFloat:1];
}

// append 'Sent from <appName>' signature to Email
- (NSNumber*)sharedWithSignature {
	return [NSNumber numberWithInt:0];
}

/* SHKFacebook */

//when you share URL on Facebook, FBDialog scans the page and fills picture and description automagically by default. Use these item properties to set your own.
- (NSString *)facebookURLSharePictureURI {
    return nil;
}

- (NSString *)facebookURLShareDescription {
    return nil;
}

/* SHKTextMessage */

//You can use this to prefill recipients. User enters them in MFMessageComposeViewController by default. Should be array of NSStrings.
- (NSArray *)textMessageToRecipients {
    return nil;
}

-(NSString*) popOverSourceRect;
{
    return NSStringFromCGRect(CGRectZero);
}


//Giphy Api Key
- (NSString*)giphyApiKey{    
#ifdef DEBUG
    return @"dc6zaTOxFJmzC"; //testing key
    
#else
    return @"PPOlBY3exNJQI"; //live key
#endif
}
@end
