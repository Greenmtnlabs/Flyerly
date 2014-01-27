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
 *, it will create a directory structure for 3.0 Version
 */
-(id)initWithPath{

    MasterLayers = [[NSDictionary alloc] init];
    int flyernumber = [self GetMaxFlyerNumber];
    return nil;
}


/*
 *load the dictionary from .peices file
 */
-(void)loadFlyer :(NSString *)uid{


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
 *Here we Getting Flyer Number for New Flyer
 */
-(int)GetMaxFlyerNumber{
    
    PFUser *user = [PFUser currentUser];
    
    //Getting Home Directory
	NSString *homeDirectoryPath = NSHomeDirectory();
	NSString *usernamePath = [homeDirectoryPath stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@/Flyr",[user objectForKey:@"username"]]];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:usernamePath isDirectory:NULL]) {
        
        NSLog(@"Path Found");
        
        //Getting All Files list
        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:usernamePath error:nil];
        NSString *lastFileName = nil;
        
        for(int i = 0 ; i < [files count];i++)
        {
            lastFileName = files[i];
            
            NSString *path = [usernamePath stringByAppendingPathComponent:lastFileName];
            BOOL isDir = NO;
            [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:(&isDir)];
            
            if( isDir ) {
                
                NSLog(@"%@",lastFileName);
            }
        }
    }
    

    return 0;
}

@end
	