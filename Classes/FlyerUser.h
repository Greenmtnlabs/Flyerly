//
//  FlyerUser.h
//  Flyr
//
//  Created by Khurram on 21/01/2014.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface FlyerUser : NSObject

+(void)migrateUserto3dot0:(PFObject *)oldUserobj;

+(void)UpdateFolderStructure:(NSString *)usr;
@end
