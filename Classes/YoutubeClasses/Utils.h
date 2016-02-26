//
//  Utils.h
//  YouTube Direct Lite for iOS
//
//  Created by Ibrahim Ulukaya on 11/6/13.
//  Copyright (c) 2013 Google. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Utils : NSObject

+ (UIAlertView*)showWaitIndicator:(NSString *)title;
+ (void)showAlert:(NSString *)title message:(NSString *)message;


@end
