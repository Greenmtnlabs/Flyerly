//
//  FlyerUser.m
//  Flyr
//
//  Created by Riksof on 21/01/2014.
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

 
    //Getting Home Directory
	NSString *homeDirectoryPath = NSHomeDirectory();
	NSString *usernamePath = [homeDirectoryPath stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@/Flyr",usr]];
    

    if ([[NSFileManager defaultManager] fileExistsAtPath:usernamePath isDirectory:NULL]) {
        
        NSLog(@"Path Found");

        //Getting All Files list
        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:usernamePath error:nil];
        NSString *lastFileName = nil;
        
        for(int i = 0 ; i < [files count];i++)
        {
            lastFileName = files[i];
            
            //Checking Any flyer contain
            if ([lastFileName rangeOfString:@".jpg"].location == NSNotFound) {
                
                  NSLog(@"Flyer does not contain in this Index");
                
            } else {
                
                //Getting Image Number
                lastFileName = [lastFileName stringByReplacingOccurrencesOfString:@".jpg" withString:@""];
                lastFileName = [lastFileName stringByReplacingOccurrencesOfString:@"IMG_" withString:@""];
                int imgnumber = [lastFileName intValue];
                
                NSString *flyerPath;
                
                //Creating New Path
                flyerPath = [NSString stringWithFormat:@"%@/%d",usernamePath,imgnumber];
                NSError *error = nil;
                
                if (![[NSFileManager defaultManager] fileExistsAtPath:flyerPath isDirectory:NULL]) {
                    
                    //This Is Unique Flyer Folder
                    [[NSFileManager defaultManager] createDirectoryAtPath:flyerPath withIntermediateDirectories:YES attributes:nil error:&error];

                    //This Is Sub Flyer Folder of Icons
                    [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/Icon",flyerPath] withIntermediateDirectories:YES attributes:nil error:&error];

                    //This Is Sub Flyer Folder of Photo
                    [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/Photo",flyerPath] withIntermediateDirectories:YES attributes:nil error:&error];

                    //This Is Sub Flyer Folder of Social
                    [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/Social",flyerPath] withIntermediateDirectories:YES attributes:nil error:&error];

                    //This Is Sub Flyer Folder of Symbol
                    [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/Symbol",flyerPath] withIntermediateDirectories:YES attributes:nil error:&error];

                    //This Is Sub Flyer Folder of Template
                    [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/Template",flyerPath] withIntermediateDirectories:YES attributes:nil error:&error];
                    
                //Here we start Coping SOURCE Files into New structure
                    NSString *source = nil;
                    NSString *destination = nil;
                    
                    //Copy ImageFile
                    source = [NSString stringWithFormat:@"%@/IMG_%d.jpg",usernamePath,imgnumber];
                    destination = [NSString stringWithFormat:@"%@/IMG_%d.jpg",flyerPath,imgnumber];

                    if ( [[NSFileManager defaultManager] isReadableFileAtPath:source] )
                        [[NSFileManager defaultManager] copyItemAtPath:source toPath:destination error:&error];
                    
                    //Copy pieces
                    source = [NSString stringWithFormat:@"%@/IMG_%d.pieces",usernamePath,imgnumber];
                    destination = [NSString stringWithFormat:@"%@/IMG_%d.pieces",flyerPath,imgnumber];

                    
                    if ( [[NSFileManager defaultManager] isReadableFileAtPath:source] )
                        [[NSFileManager defaultManager] copyItemAtPath:source toPath:destination error:&error];
                    
                    //Copy txt
                    source = [NSString stringWithFormat:@"%@/IMG_%d.txt",usernamePath,imgnumber];
                    destination = [NSString stringWithFormat:@"%@/IMG_%d.txt",flyerPath,imgnumber];
                    
                    
                    if ( [[NSFileManager defaultManager] isReadableFileAtPath:source] )
                        [[NSFileManager defaultManager] copyItemAtPath:source toPath:destination error:&error];
                    
                    
                    //Here Coping Icon related Flyer
                    source = [NSString stringWithFormat:@"%@/Icon/%d",usernamePath,imgnumber];
                    
                    if ([[NSFileManager defaultManager] fileExistsAtPath:source isDirectory:NULL]) {
                        NSLog(@"Exist");
                        
                        NSArray *Iconfiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:source error:nil];
                        
                        for(int i = 0 ; i < [Iconfiles count];i++)
                        {
                            lastFileName = Iconfiles[i];
                            
                            source = [NSString stringWithFormat:@"%@/Icon/%d/%@",usernamePath,imgnumber,lastFileName];
                            destination = [NSString stringWithFormat:@"%@/Icon/%@",flyerPath,lastFileName];
                            
                            if ( [[NSFileManager defaultManager] isReadableFileAtPath:source] )
                                [[NSFileManager defaultManager] copyItemAtPath:source toPath:destination error:&error];

                        }//Loop

                    }// End Icon Exist

                    
                    //Here Coping Photos related Flyer
                    source = [NSString stringWithFormat:@"%@/Photo/%d",usernamePath,imgnumber];
                    
                    if ([[NSFileManager defaultManager] fileExistsAtPath:source isDirectory:NULL]) {
                        NSLog(@"Exist");
                        
                        NSArray *Photofiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:source error:nil];
                        
                        for(int i = 0 ; i < [Photofiles count];i++)
                        {
                            lastFileName = Photofiles[i];
                            
                            source = [NSString stringWithFormat:@"%@/Photo/%d/%@",usernamePath,imgnumber,lastFileName];
                            destination = [NSString stringWithFormat:@"%@/Photo/%@",flyerPath,lastFileName];
                            
                            if ( [[NSFileManager defaultManager] isReadableFileAtPath:source] )
                                [[NSFileManager defaultManager] copyItemAtPath:source toPath:destination error:&error];
                            
                        }//Loop
                        
                    }// End Photo Exist
                    
                    
                    //Here Coping Social related Flyer
                    source = [NSString stringWithFormat:@"%@/Social/IMG_%d.soc",usernamePath,imgnumber];
                    destination = [NSString stringWithFormat:@"%@/Social/IMG_%d.soc",flyerPath,imgnumber];
                    if ( [[NSFileManager defaultManager] isReadableFileAtPath:source] )
                        [[NSFileManager defaultManager] copyItemAtPath:source toPath:destination error:&error];
                    
                    //END Social
                    
                    //Here Coping Symbol related Flyer
                    source = [NSString stringWithFormat:@"%@/Symbol/%d",usernamePath,imgnumber];
                    
                    if ([[NSFileManager defaultManager] fileExistsAtPath:source isDirectory:NULL]) {
                        NSLog(@"Exist");
                        
                        NSArray *Symbolfiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:source error:nil];
                        
                        for(int i = 0 ; i < [Symbolfiles count];i++)
                        {
                            lastFileName = Symbolfiles[i];
                            
                            source = [NSString stringWithFormat:@"%@/Symbol/%d/%@",usernamePath,imgnumber,lastFileName];
                            destination = [NSString stringWithFormat:@"%@/Symbol/%@",flyerPath,lastFileName];
                            
                            if ( [[NSFileManager defaultManager] isReadableFileAtPath:source] )
                                [[NSFileManager defaultManager] copyItemAtPath:source toPath:destination error:&error];
                            
                        }//Loop
                        
                    }// End Symbol Exist
                    
                    //Here Coping Template related Flyer
                    source = [NSString stringWithFormat:@"%@/Template/%d",usernamePath,imgnumber];
                    
                    if ([[NSFileManager defaultManager] fileExistsAtPath:source isDirectory:NULL]) {
                        NSLog(@"Exist");
                        
                        NSArray *Symbolfiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:source error:nil];
                        
                        for(int i = 0 ; i < [Symbolfiles count];i++)
                        {
                            lastFileName = Symbolfiles[i];
                            
                            source = [NSString stringWithFormat:@"%@/Template/%d/%@",usernamePath,imgnumber,lastFileName];
                            destination = [NSString stringWithFormat:@"%@/Template/%@",flyerPath,lastFileName];
                            
                            if ( [[NSFileManager defaultManager] isReadableFileAtPath:source] )
                                [[NSFileManager defaultManager] copyItemAtPath:source toPath:destination error:&error];
                            
                        }//Loop
                        
                    }// End Template Exist
                    
                    
                }
            
            }
            
        }
	}


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

    //Also Check for New folder Structure
    [self UpdateFolderStructure:[user objectForKey:@"username"]];

}

@end
