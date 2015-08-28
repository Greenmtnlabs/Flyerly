//
//  SKProduct+LocalPrice.m
//  Untechable
//
//  Created by RIKSOF Developer on on 9/11/13.
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//

#import "SKProduct+LocalPrice.h"

@implementation SKProduct (LocalPrice)

- (NSString *) priceAsString {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[self priceLocale]];
    
    NSString *str = [formatter stringFromNumber:[self price]];
    return str;
}

@end
