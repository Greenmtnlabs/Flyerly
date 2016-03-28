//
//  MySHKConfigurator.m
//  Flyr
//
//  Created by Riksof on 27/12/2013.
//
//

#import "CommonFunctions.h"
#import <AVFoundation/AVFoundation.h>


@implementation CommonFunctions


/**
 * Return video duration in integer in seconds
 * @param: movieUrl : NSURL
 * @return: seconds : int
 */
+(int)videoDuration:(NSURL *)movieUrl{
    if ( movieUrl != nil ) {
        AVURLAsset *avUrl = [AVURLAsset assetWithURL:movieUrl];
        CMTime time = [avUrl duration];
        int seconds = ceil(time.value/time.timescale);
        return seconds;
    } else{
        return 0;
    }
}

+(void)showAlert:(NSString *)alertTitle :(NSString *)alertMessage :(NSString *)cancelButtonTitle {
    // Alert when user logged in as anonymous
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                             message:alertMessage
                                            delegate:nil
                                   cancelButtonTitle:cancelButtonTitle
                                   otherButtonTitles:nil,nil];
    
    
    [alert show];
}

@end