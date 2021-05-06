//
//  YouTubeUploadVideo.m
//  YouTube Direct Lite for iOS
//
//  Created by Ibrahim Ulukaya on 10/29/13.
//  Copyright (c) 2013 Google. All rights reserved.
//

#import "YouTubeUploadVideo.h"
#import "VideoData.h"
#import "Utils.h"

// Thumbnail image size.
//static const CGFloat kCropDimension = 44;

@implementation YouTubeUploadVideo


//- (void)uploadYouTubeVideoWithService:(GTLServiceYouTube *)service
//                             fileData:(NSData*)fileData
//                                title:(NSString *)title
//                          description:(NSString *)description
//                        privacyStatus:(NSString *)privacyStatus
//                        tags:(NSArray *)tags {
//    
//    GTLYouTubeVideo *video = [GTLYouTubeVideo object];
//    GTLYouTubeVideoSnippet *snippet = [GTLYouTubeVideoSnippet alloc];
//    GTLYouTubeVideoStatus *status = [GTLYouTubeVideoStatus alloc];
//    status.privacyStatus = privacyStatus;
//    snippet.title = title;
//    snippet.descriptionProperty = description;
//    snippet.tags = tags;
//    video.snippet = snippet;
//    video.status = status;
//    
//    GTLUploadParameters *uploadParameters = [GTLUploadParameters uploadParametersWithData:fileData MIMEType:@"video/*"];
//    GTLQueryYouTube *query = [GTLQueryYouTube queryForVideosInsertWithObject:video part:@"snippet,status" uploadParameters:uploadParameters];
//    
//    UIAlertView *waitIndicator = [Utils showWaitIndicator:@"Uploading to YouTube"];
//    
//    [service executeQuery:query
//                completionHandler:^(GTLServiceTicket *ticket,
//                                    GTLYouTubeVideo *insertedVideo, NSError *error) {
//                    [waitIndicator dismissWithClickedButtonIndex:0 animated:YES];
//                    if (error == nil)
//                    {
//                        [self.delegate uploadYouTubeVideo:self didFinishWithResults:insertedVideo];
//                        return;
//                    }
//                    else
//                    {
//                        [self.delegate uploadYouTubeVideo:self didFinishWithResults:nil];
//                        return;
//                    }
//                }];
//}

@end
