//
//  Singleton.h
//  SecondProject
//
//  Created by Basit on 7/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountSelecter.h"

@interface Singleton : NSObject
{
    
}

@property (nonatomic, strong) NSMutableArray *accounts;
@property (nonatomic, strong) NSString *twitterUser;
@property (nonatomic, strong) NSString *inputValue;

+(Singleton *)RetrieveSingleton;
-(UIColor*)colorWithHexString:(NSString*)hex;

@end
