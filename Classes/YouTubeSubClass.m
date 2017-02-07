//
//  YouTubeSubClass.m
//  Flyr
//
//  Created by Khurram on 04/04/2014.
//
//

#import "YouTubeSubClass.h"

@interface YouTubeSubClass ()

@end

@implementation YouTubeSubClass

@dynamic uploadLocationURL; //,uploadTicket, youTubeService;
@synthesize youTubeVideoURL;



//- (void)uploadVideoWithVideoObject:(GTLYouTubeVideo *)video resumeUploadLocationURL:(NSURL *)locationURL {
//    
//    // Get a file handle for the upload data.
//    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:self.item.file.path];
//    
//    // Could not read file data.
//    if (fileHandle == nil) {
//        [self sendDidFailWithError:[SHK error:SHKLocalizedString(@"Error.")] shouldRelogin:NO];
//        return;
//    }
//    
//    // Our callback blocks ----
//    
//    // Completion
//    void (^uploadComplete)(GTLServiceTicket *ticket, GTLYouTubeVideo *uploadedVideo, NSError *error) =
//    ^(GTLServiceTicket *ticket, GTLYouTubeVideo *uploadedVideo, NSError *error){
//        
//        self.uploadTicket = nil;
//        if (error == nil) {
//            
//            //Here we Get Uploaded Video ID from Youtube
//            
//            
//            youTubeVideoURL = [NSString stringWithFormat:@"%@%@",YOUTUBEPREFIX,uploadedVideo.identifier];
//            
//            [self sendDidFinish];
//        } else {
//            [self sendDidFailWithError:[SHK error:SHKLocalizedString(@"The service encountered an error. Please try again later.")] shouldRelogin:NO];
//        }
//        self.uploadLocationURL = nil;
//    };
//    
//    // Progress
//    void (^uploadProgress)(GTLServiceTicket *ticket, unsigned long long numberOfBytesRead, unsigned long long dataLength) =
//    ^(GTLServiceTicket *ticket, unsigned long long numberOfBytesRead, unsigned long long dataLength){
//        float progress = (double)numberOfBytesRead / (double)dataLength;
//        if(progress < 1) {
//            //[self showProgress:progress];
//        } else {
//            [self displayActivity:SHKLocalizedString(@"Processing Video...")];
//        }
//        
//    };
//    
//    // URL Change - allows for upload resume
//    void (^locationChangeBlock)(NSURL *url) = ^(NSURL *url){
//        self.uploadLocationURL = url;
//    };
//    
//    // Parameters
//    GTLUploadParameters *uploadParameters = [GTLUploadParameters uploadParametersWithFileHandle:fileHandle MIMEType:self.item.file.mimeType];
//    uploadParameters.uploadLocationURL = locationURL;
//    
//    // Setup the upload
//    GTLQueryYouTube *query = [GTLQueryYouTube queryForVideosInsertWithObject:video part:@"snippet,status" uploadParameters:uploadParameters];
//    
//    // Start the upload
//    self.uploadTicket = [self.youTubeService executeQuery:query completionHandler:uploadComplete];
//    self.uploadTicket.uploadProgressBlock = uploadProgress;
//    //((GTMHTTPUploadFetcher *)self.uploadTicket.objectFetcher).locationChangeBlock = locationChangeBlock;
//    
//    // TODO: Monitor application going to background/foreground to pause and resume uploads. Possibly tie into offline upload, as we may go offline mid upload
//}

- (void)authorizationCanceled:(id)sender
{
    /*
     GTMOAuth2ViewControllerTouch *controller = self.viewControllers[0];
     [controller cancelSigningIn];
     */
//    [[SHK currentHelper] hideCurrentViewControllerAnimated:YES];
//    [self authDidFinish:NO];
//    [[SHK currentHelper] removeSharerReference:self];
}
@end
