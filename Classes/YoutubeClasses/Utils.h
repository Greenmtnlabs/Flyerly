//
//  Utils.h
//  YouTube Direct Lite for iOS
//
//  Created by Ibrahim Ulukaya on 11/6/13.
//  Copyright (c) 2013 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const DEFAULT_KEYWORD = @"Flyerly";
static NSString *const UPLOAD_PLAYLIST = @"testing";

static NSString *const kClientID = @"688107532507-7nm1v37klc2vtfgcaer206k338ub9jqs.apps.googleusercontent.com";
static NSString *const kClientSecret = @"lSn4qPwH3FOytNsqMkeZNYTP";

static NSString *const kKeychainItemName = @"Flyerly";

@interface Utils : NSObject

+ (UIAlertView*)showWaitIndicator:(NSString *)title;
+ (void)showAlert:(NSString *)title message:(NSString *)message;


@end
