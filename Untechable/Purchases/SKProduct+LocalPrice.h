//
//  SKProduct+LocalPrice.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd Ali on 9/11/13.
//
//

#import <StoreKit/StoreKit.h>

@interface SKProduct (LocalPrice)
@property (nonatomic, readonly) NSString *priceAsString;
@end
