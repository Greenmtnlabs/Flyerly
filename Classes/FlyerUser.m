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
+(void)updateFolderStructure:(NSString *)usr{

 
    NSString *flyerPath =@"";
    NSString *source = @"";
    NSString *destination = @"";
    NSString *lastFileName = @"";
    NSError *error = nil;

    //Getting Home Directory
	NSString *homeDirectoryPath = NSHomeDirectory();
	NSString *usernamePath = [homeDirectoryPath stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@/Flyr",usr]];
    

    if ([[NSFileManager defaultManager] fileExistsAtPath:usernamePath isDirectory:NULL]) {
        
        NSLog(@"Path Found");

        //Getting All Files list
        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:usernamePath error:nil];
       
        
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
                
                //Creating New Path
                flyerPath = [NSString stringWithFormat:@"%@/%d",usernamePath,imgnumber];
                
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
                    
                    //Copy ImageFile
                    source = [NSString stringWithFormat:@"%@/IMG_%d.jpg",usernamePath,imgnumber];
                    destination = [NSString stringWithFormat:@"%@/flyer.jpg",flyerPath];

                    if ( [[NSFileManager defaultManager] isReadableFileAtPath:source] )
                        [[NSFileManager defaultManager] copyItemAtPath:source toPath:destination error:&error];
                    
                    //Delete Old File
                    [[NSFileManager defaultManager] removeItemAtPath:source error:&error];
                    
                    //Copy pieces
                    source = [NSString stringWithFormat:@"%@/IMG_%d.pieces",usernamePath,imgnumber];
                    destination = [NSString stringWithFormat:@"%@/flyer.pieces",flyerPath];
                    
                    
                    if ( [[NSFileManager defaultManager] isReadableFileAtPath:source] )
                        [[NSFileManager defaultManager] copyItemAtPath:source toPath:destination error:&error];

                    //Delete Old File
                    [[NSFileManager defaultManager] removeItemAtPath:source error:&error];
                    
                    //set Pieces Dictionary File for Update
                    NSString *piecesFile = destination;
                    
                    NSMutableDictionary *masterLayers = [[NSMutableDictionary alloc] initWithContentsOfFile:piecesFile];
                    
                    //Copy txt File
                    source = [NSString stringWithFormat:@"%@/IMG_%d.txt",usernamePath,imgnumber];
                    destination = [NSString stringWithFormat:@"%@/flyer.txt",flyerPath];
                    
                    if ( [[NSFileManager defaultManager] isReadableFileAtPath:source] )
                        [[NSFileManager defaultManager] copyItemAtPath:source toPath:destination error:&error];

                    //Delete Old File
                    [[NSFileManager defaultManager] removeItemAtPath:source error:&error];
                    
                    //Here we Copy Icon files related this Flyer
                    source = [NSString stringWithFormat:@"%@/Icon/%d",usernamePath,imgnumber];
                    
                    if ([[NSFileManager defaultManager] fileExistsAtPath:source isDirectory:NULL]) {
                        NSLog(@"Exist");
                        
                        NSArray *Iconfiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:source error:nil];
                        
                        for(int i = 0 ; i < [Iconfiles count];i++)
                        {
                            lastFileName = Iconfiles[i];
                            
                            source = [NSString stringWithFormat:@"%@/Icon/%d/%@",usernamePath,imgnumber,lastFileName];
                            destination = [NSString stringWithFormat:@"%@/Icon/%@",flyerPath,lastFileName];
                            
                            NSMutableDictionary *layDic = [masterLayers objectForKey:[NSString stringWithFormat:@"Icon-%d",i]];

                            [layDic setValue:[NSString stringWithFormat:@"Icon/%@",lastFileName] forKey:@"image"];
                            
                            if ( [[NSFileManager defaultManager] isReadableFileAtPath:source] )
                                [[NSFileManager defaultManager] copyItemAtPath:source toPath:destination error:&error];
                            [masterLayers setValue:layDic forKey:[NSString stringWithFormat:@"Icon-%d",i]];

                        }//Loop
                        
                        //Here we write the dictionary of .peices files
                        [masterLayers writeToFile:piecesFile atomically:YES];

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
                            
                            NSMutableDictionary *layDic = [masterLayers objectForKey:[NSString stringWithFormat:@"Photo-%d",i]];
                            
                            [layDic setValue:[NSString stringWithFormat:@"Photo/%@",lastFileName] forKey:@"image"];
                            
                            if ( [[NSFileManager defaultManager] isReadableFileAtPath:source] )
                                [[NSFileManager defaultManager] copyItemAtPath:source toPath:destination error:&error];
                            
                            [masterLayers setValue:layDic forKey:[NSString stringWithFormat:@"Photo-%d",i]];
                            
                        }//Loop
                        
                        //Here we write the dictionary of .peices files
                        [masterLayers writeToFile:piecesFile atomically:YES];
                        
                    }// End Photo Exist
                    
                    
                    //Here Coping Social related Flyer
                    source = [NSString stringWithFormat:@"%@/Social/IMG_%d.soc",usernamePath,imgnumber];
                    destination = [NSString stringWithFormat:@"%@/Social/flyer.soc",flyerPath];
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
                            
                            NSMutableDictionary *layDic = [masterLayers objectForKey:[NSString stringWithFormat:@"Symbol-%d",i]];
                            
                            [layDic setValue:[NSString stringWithFormat:@"Symbol/%@",lastFileName] forKey:@"image"];
                            
                            if ( [[NSFileManager defaultManager] isReadableFileAtPath:source] )
                                [[NSFileManager defaultManager] copyItemAtPath:source toPath:destination error:&error];
                            [masterLayers setValue:layDic forKey:[NSString stringWithFormat:@"Symbol-%d",i]];

                            
                        }//Loop
                        
                        //Here we write the dictionary of .peices files
                        [masterLayers writeToFile:piecesFile atomically:YES];
                        
                    }// End Symbol Exist
                    
                    //Here Coping Template related Flyer
                    source = [NSString stringWithFormat:@"%@/Template/%d",usernamePath,imgnumber];
                    
                    if ([[NSFileManager defaultManager] fileExistsAtPath:source isDirectory:NULL]) {
                        NSLog(@"Exist");
                        
                        NSArray *templatefiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:source error:nil];
                        
                        for(int i = 0 ; i < [templatefiles count];i++)
                        {
                            lastFileName = templatefiles[i];
                            
                            source = [NSString stringWithFormat:@"%@/Template/%d/%@",usernamePath,imgnumber,lastFileName];
                            destination = [NSString stringWithFormat:@"%@/Template/%@",flyerPath,lastFileName];
                            
                            NSMutableDictionary *layDic = [masterLayers objectForKey:@"Template"];
                            
                            [layDic setValue:[NSString stringWithFormat:@"Template/%@",lastFileName] forKey:@"image"];
                            
                            if ( [[NSFileManager defaultManager] isReadableFileAtPath:source] )
                                [[NSFileManager defaultManager] copyItemAtPath:source toPath:destination error:&error];
                            [masterLayers setValue:layDic forKey:@"Template"];
                            
                        }//Loop
                        
                        //Here we write the dictionary of .peices files
                        [masterLayers writeToFile:piecesFile atomically:YES];
                        
                    }// End Template Exist
                    
                    
                }
            
            }
            
        }// Root Files Loop
        
        //Here we delete old folders list after copy Data

        
        //Delete Icon Folder
        source = [NSString stringWithFormat:@"%@/Icon",usernamePath];
        
        if ([[NSFileManager defaultManager] isReadableFileAtPath:source] )
            [[NSFileManager defaultManager] removeItemAtPath:source error:&error];
        
        //Delete Photo Folder
        source = [NSString stringWithFormat:@"%@/Photo",usernamePath];
        
        if ([[NSFileManager defaultManager] isReadableFileAtPath:source] )
            [[NSFileManager defaultManager] removeItemAtPath:source error:&error];
        
        //Delete Social Folder
        source = [NSString stringWithFormat:@"%@/Social",usernamePath];
        
        if ([[NSFileManager defaultManager] isReadableFileAtPath:source] )
            [[NSFileManager defaultManager] removeItemAtPath:source error:&error];

        //Delete Symbol Folder
        source = [NSString stringWithFormat:@"%@/Symbol",usernamePath];
        
        if ([[NSFileManager defaultManager] isReadableFileAtPath:source] )
            [[NSFileManager defaultManager] removeItemAtPath:source error:&error];

        
        //Delete Templates Folder
        source = [NSString stringWithFormat:@"%@/Template",usernamePath];
        
        if ([[NSFileManager defaultManager] isReadableFileAtPath:source] )
            [[NSFileManager defaultManager] removeItemAtPath:source error:&error];

        NSLog(@"Deleted Old Directories");
        
	}


}




/*
 * This will Fixed Old Purchases and Old Flyer Issue
 */
+(void)migrateUserto3dot0:(PFObject *)oldUserobj{
    
    
    //Update fields of newly created user from old user
    PFUser *user = [PFUser currentUser];
    
    if ([oldUserobj objectForKey:@"name"])
        user[@"name"] = [oldUserobj objectForKey:@"name"];

    if ([oldUserobj objectForKey:@"contact"])
        user[@"contact"] = [oldUserobj objectForKey:@"contact"];
    
    if ([oldUserobj objectForKey:@"fbinvited"])
        user[@"fbinvited"] = [oldUserobj objectForKey:@"fbinvited"];
   
    if ([oldUserobj objectForKey:@"tweetinvited"])
        user[@"tweetinvited"] = [oldUserobj objectForKey:@"tweetinvited"];
    
    if ([oldUserobj objectForKey:@"iphoneinvited"])
        user[@"iphoneinvited"] = [oldUserobj objectForKey:@"iphoneinvited"];
    
    [user saveInBackground];
    
    //Rename Old directory Name from New Username on device
	NSString *homeDirectoryPath = NSHomeDirectory();
    NSString *NewUIDFolderName = [user objectForKey:@"username"];
	NSString *OldUIDPath = [homeDirectoryPath stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",[oldUserobj objectForKey:@"username"]]];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:OldUIDPath isDirectory:NULL]) {
        NSLog(@"");
	}else{
        
        NSString *newDirectoryName = NewUIDFolderName;
        NSString *oldPath = OldUIDPath;
        
        //Here we Rename the Directory Name
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
    [self updateFolderStructure:[user objectForKey:@"username"]];

}

@end
