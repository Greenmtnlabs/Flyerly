//
//  FlyerClass.m
//  Flyr
//
//  Created by Khurram on 27/01/2014.
//
//

#import "Flyer.h"

@implementation Flyer

@synthesize MasterLayers,CurrentLayer;

/*
 * This method will be used to initiate the Flyer class
 * set Flyer Path to Open In create Screen
 * it will create a directory structure for 3.0 Version if not Exist
 */
-(id)initWithPath:(NSString *)flyPath{

    MasterLayers = [[NSDictionary alloc] init];
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:flyPath isDirectory:NULL] ) {
        
        //Create New Directory
        [self CreateFlyerPath:flyPath];
        [self loadFlyer:flyPath];
        
    } else {
        
        //Open Editable Mode
        [self loadFlyer:flyPath];
    }
    
    return nil;
}



/*
 *load the dictionary from .peices file
 */
-(void)loadFlyer :(NSString *)flyPath{



}


/*
 * Here we save the dictionary to .peices files
 */
-(void)saveFlyer :(NSString *)uid{


}


/*
 * When New text layer Add on Flyer
 * its will call and Add one Content in MasterLayers Dictionary
 * return
 *      UniqueID
 */
-(NSString *)addText{

    return @"";
}


/*
 * When New Photo layer Add on Flyer
 * its will call and Add one Content in MasterLayers Dictionary
 * return
 *      UniqueID
 */
-(NSString *)addPhoto{

    return @"";
}


/*
 * When New Symbol layer Add on Flyer
 * its will call and Add one Content in MasterLayers Dictionary
 * return
 *      UniqueID
 */
-(NSString *)addSymbols{

    return @"";
}


/*
 * When New ClipArt layer Add on Flyer
 * its will call and Add one Content in MasterLayers Dictionary
 * return
 *      UniqueID
 */
-(NSString *)addClipArt{

    return @"";
}


/*
 * Create New directory for Flyer
 */
-(void)CreateFlyerPath:(NSString *)path{
    NSError *error = nil;
    
    //This Is Unique Flyer Folder
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    
    //This Is Sub Flyer Folder of Icons
    [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/Icon",path] withIntermediateDirectories:YES attributes:nil error:&error];
    
    //This Is Sub Flyer Folder of Photo
    [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/Photo",path] withIntermediateDirectories:YES attributes:nil error:&error];
    
    //This Is Sub Flyer Folder of Social
    [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/Social",path] withIntermediateDirectories:YES attributes:nil error:&error];
    
    //This Is Sub Flyer Folder of Symbol
    [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/Symbol",path] withIntermediateDirectories:YES attributes:nil error:&error];
    
    //This Is Sub Flyer Folder of Template
    [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/Template",path] withIntermediateDirectories:YES attributes:nil error:&error];
}



/*
 *Here we Getting Flyer Number for New Flyer
 */
+(NSString *)newFlyerPath{
    
    PFUser *user = [PFUser currentUser];
    
    //Getting Home Directory
	NSString *homeDirectoryPath = NSHomeDirectory();
	NSString *usernamePath = [homeDirectoryPath stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@/Flyr",[user objectForKey:@"username"]]];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:usernamePath isDirectory:NULL]) {
        
        NSLog(@"Path Found");
        
        //Getting All Files list
        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:usernamePath error:nil];
        
        int num = 0;
        int maxnum = 0;

        for (int i = 0 ; i < files.count; i++) {
            
            num = [files[i] integerValue];

            if(maxnum < num){
                maxnum = num;
            }
        }
        
        
        NSString *flyerPath = [usernamePath stringByAppendingString:[NSString stringWithFormat:@"/%d",maxnum +1]];
        
        return flyerPath;
    }
    

    return @"";
}

@end
	