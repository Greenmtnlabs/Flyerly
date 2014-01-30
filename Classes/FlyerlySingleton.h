
//  Created by Riksof Pvt. Ltd. on 22/Jan/2014.
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
@property (nonatomic, strong) NSString *flyerName;
@property (nonatomic, strong) NSString *iosVersion;

@property (nonatomic, strong) NSString *appOpenFirstTime;
@property (nonatomic, strong) UIImage *NBUimage;
@property (nonatomic, strong) NSString *gallerComesFromCamera;
+(FlyerlySingleton *)RetrieveSingleton;
-(UIColor*)colorWithHexString:(NSString*)hex;

@end
