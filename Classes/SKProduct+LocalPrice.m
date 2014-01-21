//
//  SKProduct+LocalPrice.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd Ali on 9/11/13.
//
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
