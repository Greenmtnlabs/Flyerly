//
//  FlyerUser.h
//  Flyr
//
//  Created by Riksof on 21/01/2014.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface FlyerUser : NSObject

+(void)migrateUserto3dot0:(PFObject *)oldUserobj;

+(void)updateFolderStructure:(NSString *)usr;

@end
