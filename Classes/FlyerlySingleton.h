//
//  Singleton.h
//  SecondProject
//
//  Created by Basit on 7/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileViewController.h"

@interface FlyerlySingleton : NSObject
{
    
}

@property (nonatomic, strong) NSMutableArray *accounts;
@property (nonatomic, strong) NSString *twitterUser;
@property (nonatomic, strong) NSString *inputValue;
@property (nonatomic, strong) NSString *sharelink;
@property (nonatomic, strong) NSString *FlyerName;
@property (nonatomic, strong) NSString *iosVersion;

@property (nonatomic, strong) NSString *CheckHelpOpen;
@property (nonatomic, strong) NSString *appOpenFirstTime;
@property (nonatomic, strong) UIImage *NBUimage;
@property (nonatomic, strong) NSString *gallerComesFromCamera;
+(FlyerlySingleton *)RetrieveSingleton;
-(UIColor*)colorWithHexString:(NSString*)hex;

@end
