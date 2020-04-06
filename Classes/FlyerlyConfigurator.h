//
//  MySHKConfigurator.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd on 27/12/2013.
//
//

#import "DefaultSHKConfigurator.h"

@interface FlyerlyConfigurator: DefaultSHKConfigurator


- (NSString*)appName;
- (NSString*)appURL;
- (NSString*)referralURL;
- (NSString*)appLinkURL;
- (NSString*)appInvitePreviewImageURL;
- (NSArray*)defaultFavoriteURLSharers;
- (NSArray*)defaultFavoriteImageSharers;
- (NSArray*)defaultFavoriteTextSharers;
- (NSArray*)defaultFavoriteFileSharers __attribute__((deprecated("use defaultFavoriteSharersForFile: instead")));
- (NSArray*)defaultFavoriteSharersForMimeType:(NSString *)mimeType __attribute__((deprecated("use defaultFavoriteSharersForFile: instead")));
- (NSArray*)defaultFavoriteSharersForFile:(SHKFile *)file;

- (NSString*)crittercismAppId;
- (NSString*)parseOnlineAppId;
- (NSString*)parseOnlineClientKey;
- (NSString*)parseOfflineAppId;
- (NSString*)parseOfflineClientKey;
- (NSString*)flurrySessionId;
- (NSString*)interstitialAdID;
- (NSString*)bannerAdID;
- (BOOL)currentDebugMood;

- (NSString*)lobAppId;
- (NSString *const)paypalEnvironment;
- (NSString*)paypalEnvironmentId;
- (NSString*)bigstockSecretKey;
- (NSString*)bigstockAccountId;

- (NSString*)vkontakteAppId;
- (NSString*)facebookAppId;
- (NSString*)facebookLocalAppId;
- (NSArray*)facebookWritePermissions;
- (NSArray*)facebookReadPermissions;
- (NSNumber*)forcePreIOS6FacebookPosting;
- (NSString *)pocketConsumerKey;
- (NSString*)diigoKey;
- (NSNumber*)forcePreIOS5TwitterAccess;
- (NSString*)googlePlusClientId;
- (NSString*)twitterConsumerKey;
- (NSString*)twitterSecret;
- (NSString*)twitterCallbackUrl;
- (NSNumber*)twitterUseXAuth;
- (NSString*)twitterUsername;
- (NSString*)evernoteHost;
- (NSString*)evernoteConsumerKey;
- (NSString*)evernoteSecret;
- (NSString*)flickrConsumerKey;
- (NSString*)flickrSecretKey;
- (NSString*)flickrCallbackUrl;
- (NSString*)bitLyLogin;
- (NSString*)bitLyKey;
- (NSString*)linkedInConsumerKey;
- (NSString*)linkedInSecret;
- (NSString*)linkedInCallbackUrl;
- (NSString*)readabilityConsumerKey;
- (NSString*)readabilitySecret;
- (NSNumber*)readabilityUseXAuth;
- (NSString*)foursquareV2ClientId;
- (NSString*)foursquareV2RedirectURI;
- (NSString*)tumblrConsumerKey;
- (NSString*)tumblrSecret;
- (NSString*)tumblrCallbackUrl;
- (NSString*)hatenaConsumerKey;
- (NSString*)hatenaSecret;
- (NSString*)hatenaScope;
- (NSString *)plurkAppKey;
- (NSString *)plurkAppSecret;
- (NSString *)plurkCallbackURL;
- (NSNumber *)instagramLetterBoxImages;
- (UIColor *)instagramLetterBoxColor;
- (NSNumber *)instagramOnly;
- (NSString*)youTubeConsumerKey;
- (NSString*)youTubeSecret;
- (NSNumber *)useAppleShareUI;
- (NSNumber*)shareMenuAlphabeticalOrder;
- (NSString*)barStyle;
- (UIColor*)barTintForView:(UIViewController*)vc;
- (UIColor*)formFontColor;
- (UIColor*)formBackgroundColor;
- (NSString*)modalPresentationStyleForController:(UIViewController *)controller;
- (NSString*)modalTransitionStyleForController:(UIViewController *)controller;
- (NSNumber*)maxFavCount;
- (NSNumber*)autoOrderFavoriteSharers;
- (NSString*)favsPrefixKey;
- (NSString*)authPrefix;
- (NSString*)sharersPlistName;
- (NSNumber*)showActionSheetMoreButton;
- (NSNumber*)allowOffline;
- (NSNumber*)allowAutoShare;
- (Class)SHKShareMenuSubclass;
- (Class)SHKShareMenuCellSubclass;
- (Class)SHKFormControllerSubclass;

//SHKPrint
- (NSNumber*)printOutputType;
//SHKMail
- (NSArray *)mailToRecipients;
- (NSNumber*)isMailHTML;
- (NSNumber*)mailJPGQuality;
- (NSNumber*)sharedWithSignature;
//SHKFacebook
- (NSString *)facebookURLSharePictureURI;
- (NSString *)facebookURLShareDescription;
//SHKTextMessage
- (NSArray *)textMessageToRecipients;
//SHKInstagram and future others
-(NSString*) popOverSourceRect;
//SHKDropbox
-(NSString *)dropboxAppKey;
-(NSString *)dropboxAppSecret;
-(NSString *)dropboxRootFolder;
-(NSNumber *)dropboxShouldOverwriteExistedFile;
//SHKBuffer
- (NSNumber *)bufferShouldShortenURLS;
- (NSString*)giphyApiKey;
@end
