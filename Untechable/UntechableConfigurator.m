//
//  UntechableConfigurator.m
//  Untechable
//
//  Created by rufi on 06/11/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import "UntechableConfigurator.h"

#import "SHKFile.h"
#import <Social/Social.h>


@implementation UntechableConfigurator

/*
 App Description
 ---------------
 These values are used by any service that shows 'shared from XYZ'
 */
- (NSString*)appName {
    return @"Untech";
}

- (NSString*)appURL {
    return @"http://www.unte.ch";
}

- (NSString*)appLinkURL{
    return @"https://itunes.apple.com/us/app/untechable/id934720123?ls=1&mt=8";
}
- (NSString*)appInvitePreviewImageURL{
    return @"http://greenmtnlabs.com/flyerly/images/phones.png";
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
    return @"988650031150166";
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
    return @"ByW548OF9AiFed5GeBNtVXkL7";
    
}

- (NSString*)twitterSecret {
    return @"tamE3ZQzsdYCoxFVttnSaNygRZedY76LXmefx0ul4ubsJGHNzn";
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
    return @"gountech";
}




@end
