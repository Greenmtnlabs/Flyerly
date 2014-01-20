//
//  FlyerUser.m
//  Flyr
//
//  Created by Khurram on 21/01/2014.
//
//

#import "FlyerUser.h"

@implementation FlyerUser

- (id)init
{
    return nil;
}


/*
 * This will Update folder structure On Device
 * for 3.0 version
 */
+(void)UpdateFolderStructure:(NSString *)usr{


}




/*
 * This will Fixed Old Purchases and Old Flyer Issue
 */
+(void)migrateUserto3dot0:(PFObject *)oldUserobj{
    
    
    //Update fields of newly created user from old user
    PFUser *user = [PFUser currentUser];
    user[@"contact"] = [oldUserobj objectForKey:@"contact"];
    user[@"name"] = [oldUserobj objectForKey:@"name"];
    user[@"fbinvited"] = [oldUserobj objectForKey:@"fbinvited"];
    user[@"tweetinvited"] = [oldUserobj objectForKey:@"tweetinvited"];
    [user saveInBackground];
    
    //Rename Old directory Name from New Username on device
	NSString *homeDirectoryPath = NSHomeDirectory();
    NSString *NewUIDFolderName = [user objectForKey:@"username"];
	NSString *OldUIDPath = [homeDirectoryPath stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@/",[oldUserobj objectForKey:@"username"]]];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:OldUIDPath isDirectory:NULL]) {
        NSLog(@"");
	}else{
        
        NSString *newDirectoryName = NewUIDFolderName;
        NSString *oldPath = OldUIDPath;
        NSString *newPath = [[oldPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:newDirectoryName];
        NSError *error = nil;
        [[NSFileManager defaultManager] moveItemAtPath:oldPath toPath:newPath error:&error];
        
        if (error) {
            NSLog(@"%@",error.localizedDescription);
        }
    }
    
    // For Merging User info on Parse .Parse not allow here update Other User Info
    // So Now we run Server side script from here and passing user names
    // For transfer Purchases and Old Flyers Info
    NSString  *NewUID = user.objectId;
    NSString  *OldUID = oldUserobj.objectId;
    
    [PFCloud callFunctionInBackground:@"mergeUser"
                       withParameters:@{@"oldUser":OldUID,@"newUser":NewUID}
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        NSLog(@"Cloud Success");
                                    }
                                }];


}

@end
