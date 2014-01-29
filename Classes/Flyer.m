//
//  FlyerClass.m
//  Flyr
//
//  Created by Khurram on 27/01/2014.
//
//

#import "Flyer.h"

@implementation Flyer

@synthesize MasterLayers;

/*
 * This method will be used to initiate the Flyer class
 * set Flyer Path to Open In create Screen
 * it will create a directory structure for 3.0 Version if not Exist
 */
-(id)initWithPath:(NSString *)flyPath{
    
      self = [super init];

    MasterLayers = [[NSMutableDictionary alloc] init];
    
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
    
    MasterLayers = dict;

    /****** LOAD TEMPLATE *******/
    NSString *templateFolderPath = [flyPath stringByAppendingString:[NSString stringWithFormat:@"/Template/"]];
    NSData *imageData = [[NSData alloc ]initWithContentsOfMappedFile:[NSString stringWithFormat:@"%@/template.jpg",templateFolderPath]];
   // UIImage *flyerImage = [UIImage imageWithData:imageData];
    
    /****** LOAD TEXTS *******/
    NSMutableArray *textArray = [[NSMutableArray alloc] init];
    int index = 0;
    for(NSString *key in dict){
        if([key hasPrefix:@"Text-"]){
            
            NSDictionary *textDict = dict[key];
            // NSLog(@"%@",textDict);
            NSString *text = textDict[@"text"];
            NSString *fontname = textDict[@"fontname"];
            NSString *fontsize = textDict[@"fontsize"];
            NSString *textcolor = textDict[@"textcolor"];
            NSString *textwhitecolor = textDict[@"textWhitecolor"];
            NSString *textbordercolor = textDict[@"textbordercolor"];
            NSString *textborderwhite = textDict[@"textborderWhite"];
            NSString *textX = textDict[@"x"];
            NSString *textY = textDict[@"y"];
            NSString *textWidth = textDict[@"width"];
            NSString *textHeight = textDict[@"height"];
            
            CustomLabel *newMsgLabel = [[CustomLabel alloc]initWithFrame:CGRectMake([textX floatValue], [textY floatValue], [textWidth floatValue], [textHeight floatValue])];
            newMsgLabel.text = text;
            newMsgLabel.font = [UIFont fontWithName:fontname size:[fontsize floatValue]];
            newMsgLabel.backgroundColor = [UIColor clearColor];
            newMsgLabel.textAlignment = UITextAlignmentCenter;
            newMsgLabel.adjustsFontSizeToFitWidth = YES;
            newMsgLabel.lineBreakMode = UILineBreakModeClip;
            
            newMsgLabel.numberOfLines = 80;
            
            if ([textcolor isEqualToString:@"0.000000, 0.000000, 0.000000"]) {
                if (textwhitecolor != nil) {
                    NSArray *rgb = [textwhitecolor componentsSeparatedByString:@","];
                    newMsgLabel.textColor = [UIColor colorWithWhite:[rgb[0] floatValue] alpha:[rgb[1] floatValue]];
                }
            }else{
                NSArray *rgb = [textcolor componentsSeparatedByString:@","];
                
                newMsgLabel.textColor = [UIColor colorWithRed:[rgb[0] floatValue] green:[rgb[1] floatValue] blue:[rgb[2] floatValue] alpha:1];
                
            }
            
            if ([textbordercolor isEqualToString:@"0.000000, 0.000000, 0.000000"]) {
                if (textborderwhite != nil) {
                    NSArray *rgbBorder = [textborderwhite componentsSeparatedByString:@","];
                    newMsgLabel.borderColor = [UIColor colorWithWhite:[rgbBorder[0] floatValue] alpha:[rgbBorder[1] floatValue]];
                    
                }
            }else{
                
                NSArray *rgbBorder = [textbordercolor componentsSeparatedByString:@","];
                newMsgLabel.borderColor = [UIColor colorWithRed:[rgbBorder[0] floatValue] green:[rgbBorder[1] floatValue] blue:[rgbBorder[2] floatValue] alpha:1];
            }
            newMsgLabel.lineWidth = 2;
            [newMsgLabel drawRect:CGRectMake(newMsgLabel.frame.origin.x, newMsgLabel.frame.origin.y, newMsgLabel.frame.size.width, newMsgLabel.frame.size.height)];
            [textArray addObject:newMsgLabel];
        }
    }
    
    /****** LOAD PHOTOS *******/
    NSMutableArray *photoArray = [[NSMutableArray alloc] init];
    index = 0;
    for(NSString *key in dict){
        if([key hasPrefix:@"Photo-"]){
            
            NSDictionary *photoDict = dict[key];
            NSString *photoPath = photoDict[@"image"];
            NSString *photoX = photoDict[@"x"];
            NSString *photoY = photoDict[@"y"];
            NSString *photoWidth = photoDict[@"width"];
            NSString *photoHeight = photoDict[@"height"];
            
            NSData *imageData = [[NSData alloc ]initWithContentsOfMappedFile:photoPath];
            UIImage *currentFlyerImage = [UIImage imageWithData:imageData];
            
            UIImageView *newPhotoImgView = [[UIImageView alloc]initWithFrame:CGRectMake([photoX floatValue], [photoY floatValue], [photoWidth floatValue], [photoHeight floatValue])];
            newPhotoImgView.tag = index++;
            newPhotoImgView.image = currentFlyerImage;
            
            CALayer * l = [newPhotoImgView layer];
            [l setMasksToBounds:YES];
            [l setCornerRadius:10];
            [l setBorderWidth:1.0];
            [l setBorderColor:[[UIColor grayColor] CGColor]];
            
            [photoArray addObject:newPhotoImgView];
        }
    }
    
    /****** LOAD SYMBOLS *******/
    NSMutableArray *symbolArray = [[NSMutableArray alloc] init];
    index = 0;
    for(NSString *key in dict){
        if([key hasPrefix:@"Symbol-"]){
            
            NSDictionary *symbolDict = dict[key];
            NSString *symbolPath = symbolDict[@"image"];
            NSString *symbolX = symbolDict[@"x"];
            NSString *symbolY = symbolDict[@"y"];
            NSString *symbolWidth = symbolDict[@"width"];
            NSString *symbolHeight = symbolDict[@"height"];
            
            NSData *imageData = [[NSData alloc ]initWithContentsOfMappedFile:symbolPath];
            UIImage *currentFlyerImage = [UIImage imageWithData:imageData];
            
            UIImageView *newSymbolImgView = [[UIImageView alloc]initWithFrame:CGRectMake([symbolX floatValue], [symbolY floatValue], [symbolWidth floatValue], [symbolHeight floatValue])];
            newSymbolImgView.tag = index++;
            newSymbolImgView.image = currentFlyerImage;
            
            CALayer * l = [newSymbolImgView layer];
            [l setMasksToBounds:YES];
            [l setCornerRadius:10];
            [l setBorderWidth:1.0];
            [l setBorderColor:[[UIColor grayColor] CGColor]];
            
            [symbolArray addObject:newSymbolImgView];
        }
    }
    
    /****** LOAD ICONS *******/
    NSMutableArray *iconArray = [[NSMutableArray alloc] init];
    index = 0;
    for(NSString *key in dict){
        if([key hasPrefix:@"Icon-"]){
            
            NSDictionary *iconDict = dict[key];
            NSString *iconPath = iconDict[@"image"];
            NSString *iconX = iconDict[@"x"];
            NSString *iconY = iconDict[@"y"];
            NSString *iconWidth = iconDict[@"width"];
            NSString *iconHeight = iconDict[@"height"];
            
            NSData *imageData = [[NSData alloc ]initWithContentsOfMappedFile:iconPath];
            UIImage *currentFlyerImage = [UIImage imageWithData:imageData];
            
            UIImageView *newIconImgView = [[UIImageView alloc]initWithFrame:CGRectMake([iconX floatValue], [iconY floatValue], [iconWidth floatValue], [iconHeight floatValue])];
            newIconImgView.tag = index++;
            newIconImgView.image = currentFlyerImage;
            
            CALayer * l = [newIconImgView layer];
            [l setMasksToBounds:YES];
            [l setCornerRadius:10];
            [l setBorderWidth:1.0];
            [l setBorderColor:[[UIColor grayColor] CGColor]];
            
            [iconArray addObject:newIconImgView];
        }
    }
    
    
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
    textDetailDictionary[@"fontname"] = @".HelveticaNeueInterface-M3";
    textDetailDictionary[@"fontsize"] = @"17.000000";
    textDetailDictionary[@"textcolor"] = @"0.000000, 0.000000, 0.000000";
    textDetailDictionary[@"textWhitecolor"] = @"0.000000, 1.000000";
    textDetailDictionary[@"textborderWhite"] = @"0.000000, 0.000000";
    textDetailDictionary[@"textbordercolor"] = @"0.000000, 0.000000, 0.000000";
    textDetailDictionary[@"x"] = @"20.000000";
    textDetailDictionary[@"y"] = @"50.000000";
    textDetailDictionary[@"width"] = @"280.000000";
    textDetailDictionary[@"height"] = @"280.000000";
    
    [MasterLayers setValue:textDetailDictionary forKey:uniqueId];
    
    return uniqueId;
}


/*
 * Here Set text of Layer
 */
-(void)setFlyerText :(NSString *)txt Uid:(NSString *)uid{
    
   NSMutableDictionary *textDetailDictionary = [[NSMutableDictionary alloc] init];
    textDetailDictionary = [self getLayerFromMaster:uid];
    [textDetailDictionary setValue:txt forKey:@"text"];
    
    // Set to Master Dictionary
    [MasterLayers setValue:textDetailDictionary forKey:uid];
}

-(NSMutableDictionary *)getLayerFromMaster :(NSString *)uid{

    if ([MasterLayers objectForKey:uid] != nil) {
        
        return [MasterLayers objectForKey:uid];
        
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
	