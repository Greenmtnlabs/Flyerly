//
//  FlyerClass.m
//  Flyr
//
//  Created by Khurram on 27/01/2014.
//
//

#import "Flyer.h"

@implementation Flyer

@synthesize masterLayers,flyImageView;

/*
 * This method will be used to initiate the Flyer class
 * set Flyer Path to Open In create Screen
 * it will create a directory structure for 3.0 Version if not Exist
 */
-(id)initWithPath:(NSString *)flyPath{
    
      self = [super init];

    masterLayers = [[NSMutableDictionary alloc] init];
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:flyPath isDirectory:NULL] ) {
        
        //Create New Directory
        [self CreateFlyerPath:flyPath];
        
    }
    
    //Load flyer
    [self loadFlyer:flyPath];
    return self;
}



/*
 *load the dictionary from .peices file
 ****** LOAD FLYER INFORMATION FILE ******
 */
-(void)loadFlyer :(NSString *)flyPath{


    //Getting Dictionary
    NSString *flyerFilePath = [flyPath stringByAppendingString:[NSString stringWithFormat:@"/flyer.pieces"]];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:flyerFilePath];
    
    masterLayers = dict;
    
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
    NSLog(@"addText");
   
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    
    NSString *uniqueId = (__bridge NSString *)uuidStringRef;
    
    //Add Defaualt dictionary
    NSMutableDictionary *textDetailDictionary = [[NSMutableDictionary alloc] init];
    textDetailDictionary[@"text"] = @"Defualt";
    textDetailDictionary[@"fontname"] = @"HelveticaNeueInterface-M3";
    textDetailDictionary[@"fontsize"] = @"17.000000";
    textDetailDictionary[@"textcolor"] = @"0.000000, 0.000000, 0.000000";
    textDetailDictionary[@"textWhitecolor"] = @"0.000000, 1.000000";
    textDetailDictionary[@"textborderWhite"] = @"0.000000, 0.000000";
    textDetailDictionary[@"textbordercolor"] = @"0.000000, 0.000000, 0.000000";
    textDetailDictionary[@"x"] = @"20.000000";
    textDetailDictionary[@"y"] = @"50.000000";
    textDetailDictionary[@"width"] = @"280.000000";
    textDetailDictionary[@"height"] = @"280.000000";
    
    
    [masterLayers setValue:textDetailDictionary forKey:uniqueId];
    
    return uniqueId;
}


/*
 * Here Set text of Layer
 */
-(void)setFlyerText :(NSString *)uid text:(NSString *)txt {
    
   NSMutableDictionary *textDetailDictionary = [[NSMutableDictionary alloc] init];
    textDetailDictionary = [self getLayerFromMaster:uid];
    [textDetailDictionary setValue:txt forKey:@"text"];
    
    // Set to Master Dictionary
    [masterLayers setValue:textDetailDictionary forKey:uid];
    
    [self.flyImageView renderLayer:uid layerDictionary:textDetailDictionary];

    
}

/*
 * Here we Set Text font
 */
-(void)setFlyerTextFont :(NSString *)uid FontName:(NSString *)ftn{

    NSMutableDictionary *textDetailDictionary = [[NSMutableDictionary alloc] init];
    textDetailDictionary = [self getLayerFromMaster:uid];
    [textDetailDictionary setValue:ftn forKey:@"fontname"];
    
    // Set to Master Dictionary
    [masterLayers setValue:textDetailDictionary forKey:uid];
    
    [self.flyImageView renderLayer:uid layerDictionary:textDetailDictionary];
}


/*
 * Here we Set Text Color
 */
-(void)setFlyerTextColor :(NSString *)uid RGBColor:(id)rgb{

    NSMutableDictionary *textDetailDictionary = [[NSMutableDictionary alloc] init];
    textDetailDictionary = [self getLayerFromMaster:uid];
    
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0,wht = 0.0;
    
    UILabel *labelToStore = [[UILabel alloc]init];
    labelToStore.textColor = rgb;
    
    //Getting RGB Color Code
    [labelToStore.textColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    if (red == 0 && green == 0 && blue ==0) {
        [labelToStore.textColor getWhite:&wht alpha:&alpha];
    }
    
    [textDetailDictionary setValue:[NSString stringWithFormat:@"%f, %f, %f", red, green, blue] forKey:@"textcolor"];
    [textDetailDictionary setValue:[NSString stringWithFormat:@"%f, %f", wht, alpha] forKey:@"textWhitecolor"];
    
    // Set to Master Dictionary
    [masterLayers setValue:textDetailDictionary forKey:uid];
    
    [self.flyImageView renderLayer:uid layerDictionary:textDetailDictionary];


}


-(NSMutableDictionary *)getLayerFromMaster :(NSString *)uid {

    if ([masterLayers objectForKey:uid] != nil) {
        
        return [masterLayers objectForKey:uid];
        
    }

    return nil;
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
    
    //Here we Copy Default Directory From Resource Bundle
    [self copyDirectory:path];
    
}


-(void) copyDirectory:(NSString *)directory {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;

    NSString *documentDBFolderPath = directory;
    NSString *resourceDBFolderPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/flyerbundle"];
    
    if (![fileManager fileExistsAtPath:documentDBFolderPath]) {
        //Create Directory!
        [fileManager createDirectoryAtPath:documentDBFolderPath withIntermediateDirectories:NO attributes:nil error:&error];
    } else {
        NSLog(@"Directory exists! %@", documentDBFolderPath);
    }
    
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:resourceDBFolderPath error:&error];
    
    for (NSString *s in fileList) {
        
        NSString *newFilePath = [documentDBFolderPath stringByAppendingPathComponent:s];
        NSString *oldFilePath = [resourceDBFolderPath stringByAppendingPathComponent:s];
            
        if (![fileManager fileExistsAtPath:newFilePath]) {
            
            //File does not exist, copy it
            [fileManager copyItemAtPath:oldFilePath toPath:newFilePath error:&error];
            
        } else {
            NSLog(@"File exists: %@", newFilePath);
        }
    }
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
	