//
//  UIViewController+ESEventTagging.m
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 3/13/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import "UIViewController+ESEventTagging.h"

@implementation UIViewController (ESEventTagging)

- (NSString *)eventTag
{
    NSString *className = NSStringFromClass([self class]);
    className = [className stringByReplacingCharactersInRange:NSMakeRange(0,2)
                                                   withString:@""];
    className = [className stringByReplacingOccurrencesOfString:@"ViewController"
                                                     withString:@""];
    NSMutableString *pageName = [NSMutableString string];
    NSCharacterSet *characterSet = [NSCharacterSet uppercaseLetterCharacterSet];
    for (NSUInteger i = 0, n = [className length]; i < n; i++) {
        unichar c = [className characterAtIndex:i];
        if (i!=0 && [characterSet characterIsMember:c]) {
            [pageName appendString:@" "];
        }
        [pageName appendFormat:@"%C", c];
    }
    return [pageName copy];
}

@end
