//
//  YouTubeSubClass.h
//  Flyr
//
//  Created by Khurram on 04/04/2014.
//
//

#import "SHKYouTube.h"
#import "SharersCommonHeaders.h"

#import "GTLYouTube.h"
#import "GTLUtilities.h"
#import "GTMHTTPUploadFetcher.h"
#import "GTMOAuth2ViewControllerTouch.h"

@interface YouTubeSubClass : SHKYouTube

// Accessor for the app's single instance of the service object.
@property (nonatomic, readonly) GTLServiceYouTube *youTubeService;

@property (nonatomic, strong) NSURL *uploadLocationURL;
@property (nonatomic, strong) GTLServiceTicket *uploadTicket;
@end
