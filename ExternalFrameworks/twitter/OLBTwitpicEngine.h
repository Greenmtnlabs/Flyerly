//
//
//  Created by Krunal on 05/10/09.
//  Copyright 2009 iauro. All rights reserved.
//


#import <UIKit/UIKit.h>
//#import "RegexKitLite.h"

@protocol OLBTwitpicEngineDelegate;

@interface OLBTwitpicEngine : NSObject 
{
	@private
	id<OLBTwitpicEngineDelegate> delegate;
}

- (id)initWithDelegate:(id)theDelegate;
- (BOOL)uploadImageToTwitpic:(UIImage *)image withMessage:(NSString *)theMessage username:(NSString *)username password:(NSString *)password;

@end


@protocol OLBTwitpicEngineDelegate <NSObject>
- (void)twitpicEngine:(OLBTwitpicEngine *)engine didUploadImageWithResponse:(NSString *)response;
@end

