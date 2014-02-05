//
//  FlyerClass.m
//  Flyr
//
//  Created by Khurram on 27/01/2014.
//
//

#import "Flyer.h"

@implementation Flyer

NSString * const TEXT = @"Defualt";
NSString * const TEXTFONTNAME = @".HelveticaNeueInterface-M3";
NSString * const TEXTFONTSIZE = @"17.000000";
NSString * const TEXTCOLOR = @"0.000000, 0.000000, 0.000000";
NSString * const TEXTWHITECOLOR = @"0.000000, 1.000000";
NSString * const TEXTBORDERWHITE = @"0.000000, 0.000000";
NSString * const TEXTBORDERCOLOR = @"0.000000, 0.000000, 0.000000";
NSString * const TEXTxPOS = @"20.000000";
NSString * const TEXTyPOS = @"50.000000";
NSString * const TEXTWIDTH = @"280.000000";
NSString * const TEXTHEIGHT = @"280.000000";


@synthesize masterLayers;

/*
 * This method will be used to initiate the Flyer class
 * set Flyer Path to Open In create Screen
 * it will create a directory structure for 3.0 Version if not Exist
 */
-(id)initWithPath:(NSString *)flyPath{
    
      self = [super init];
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:flyPath isDirectory:NULL] ) {
        
        //Create New Directory
        [self createFlyerPath:flyPath];
        
    }
    
    //set Current Path of File Manager
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:flyPath];
    
    //Load flyer
    [self loadFlyer:flyPath];
    return self;
}



/*
 *load the dictionary from .peices file
 */
-(void)loadFlyer :(NSString *)flyPath {

    //Getting Dictionary
    piecesFile = [flyPath stringByAppendingString:[NSString stringWithFormat:@"/flyer.pieces"]];
    
    masterLayers = [[NSMutableDictionary alloc] initWithContentsOfFile:piecesFile];
}




/*
 * Here we save the dictionary to .peices files
 */
-(void)saveFlyer :(NSString *)uid{
    
    
    [masterLayers writeToFile:piecesFile atomically:YES];

}


/*
 * Here we Delete One Layer from dictionary of Flyer
 * and Front View also..
 */
-(void)deleteLayer :(NSString *)uid{
    
    //Delete From Dictionary
    [masterLayers removeObjectForKey:uid];

}


-(NSArray *)allKeys{
    
    return [masterLayers allKeys];
}

/*
 *Here we sort Array for Exact Render of Flyer
 * as last saved.
 */
-(NSMutableArray *)sortbyTimeStamp :(NSArray *)flyKeys {
    
    NSMutableArray *sortedAry = [[NSMutableArray alloc ]init];
    NSString *timstring =@"";
    NSString *sortedValue =@"";
    int tmpStamp = 0;
    int shortest = 0;

    for (int i = 0; i < flyKeys.count; i++) {
        
        timstring = [flyKeys objectAtIndex:i];
        
        if (![timstring isEqualToString:@"Template"]) {
            
            shortest = [timstring integerValue];
            sortedValue = [ NSString stringWithFormat:@"%d",shortest];
            for (int ii = i ; ii < flyKeys.count; ii++) {
                
                timstring = [flyKeys objectAtIndex:ii];
                tmpStamp = [timstring integerValue];
                
                NSLog(@"%d < %d",tmpStamp,shortest);
                
                if (tmpStamp < shortest && tmpStamp != 0) {
                    sortedValue = [ NSString stringWithFormat:@"%d",tmpStamp];
                    shortest = tmpStamp;
                }
            }
            
            [sortedAry addObject:sortedValue];
            
        }

    }
    
    [sortedAry addObject:@"Template"];
    
    NSLog(@"%@",sortedAry);
    return sortedAry;
}



/*
 * Here we get Selected Dictionary From MasterLayers
 */
-(NSMutableDictionary *)getLayerFromMaster :(NSString *)uid {
    return [masterLayers objectForKey:uid];
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
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    
    NSString *uniqueId = [NSString stringWithFormat:@"%d",timestamp];
    
    
    //Create Dictionary for Symbol
    NSMutableDictionary *symbolDetailDictionary = [[NSMutableDictionary alloc] init];
    symbolDetailDictionary[@"image"] = @"";
    symbolDetailDictionary[@"x"] = @"10";
    symbolDetailDictionary[@"y"] = @"10";
    symbolDetailDictionary[@"width"] = @"90";
    symbolDetailDictionary[@"height"] = @"70";
    
    [masterLayers setValue:symbolDetailDictionary forKey:uniqueId];
    return uniqueId;
}

-(void)setSymbolImage :(NSString *)uid ImgPath:(NSString *)imgPath{

    NSMutableDictionary *symbolDetailDictionary = [self getLayerFromMaster:uid];
    
    //Here We Delete Old Map File if Exist
    if (![[symbolDetailDictionary objectForKey:@"image"] isEqualToString:@""]) {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:[symbolDetailDictionary objectForKey:@"image"] error:&error];
    }
    
    [symbolDetailDictionary setValue:imgPath forKey:@"image"];
    
    // Set to Master Dictionary
    [masterLayers setValue:symbolDetailDictionary forKey:uid];
    
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
-(void)createFlyerPath:(NSString *)path{
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
    NSError *error;
    
    //Getting Home Directory
	NSString *homeDirectoryPath = NSHomeDirectory();
	NSString *usernamePath = [homeDirectoryPath stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@/Flyr",[user objectForKey:@"username"]]];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:usernamePath isDirectory:NULL])
            [[NSFileManager defaultManager] createDirectoryAtPath:usernamePath withIntermediateDirectories:YES attributes:nil error:&error];
        
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

#pragma TEXT METHODS

/*
 * When New text layer Add on Flyer
 * its will call and Add one Content in MasterLayers Dictionary
 * return
 *      UniqueID
 */
-(NSString *)addText{
    NSLog(@"addText");
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    
    NSString *uniqueId = [NSString stringWithFormat:@"%d",timestamp];
    
    //Add Defaualt dictionary
    NSMutableDictionary *textDetailDictionary = [[NSMutableDictionary alloc] init];
    textDetailDictionary[@"text"] = TEXT;
    textDetailDictionary[@"fontname"] = TEXTFONTNAME;
    textDetailDictionary[@"fontsize"] = TEXTFONTSIZE;
    textDetailDictionary[@"textcolor"] = TEXTCOLOR;
    textDetailDictionary[@"textWhitecolor"] = TEXTWHITECOLOR;
    textDetailDictionary[@"textborderWhite"] = TEXTBORDERWHITE;
    textDetailDictionary[@"textbordercolor"] = TEXTBORDERCOLOR;
    textDetailDictionary[@"x"] = TEXTxPOS;
    textDetailDictionary[@"y"] = TEXTyPOS;
    textDetailDictionary[@"width"] = TEXTWIDTH;
    textDetailDictionary[@"height"] = TEXTHEIGHT;
    
    
    [masterLayers setValue:textDetailDictionary forKey:uniqueId];
    
    return uniqueId;
}


/*
 * Here Set text of Layer
 */
-(void)setFlyerText :(NSString *)uid text:(NSString *)txt {
    
    NSMutableDictionary *textDetailDictionary = [self getLayerFromMaster:uid];
    [textDetailDictionary setValue:txt forKey:@"text"];
    
    // Set to Master Dictionary
    [masterLayers setValue:textDetailDictionary forKey:uid];
    
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
    
}


/*
 * Here we Set Text Color
 */
-(void)setFlyerTextColor :(NSString *)uid RGBColor:(id)rgb{
    
    NSMutableDictionary *textDetailDictionary = [self getLayerFromMaster:uid];
    
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
    
}

/*
 * Here we Set Text Size
 */
-(void)setFlyerTextSize :(NSString *)uid Size:(UIFont *)sz{
    
    NSMutableDictionary *textDetailDictionary = [self getLayerFromMaster:uid];
    
    
    UILabel *labelToStore = [[UILabel alloc]init];
    labelToStore.font = sz;
    
    [textDetailDictionary setValue:[NSString stringWithFormat:@"%f", labelToStore.font.pointSize] forKey:@"fontsize"];
    
    // Set to Master Dictionary
    [masterLayers setValue:textDetailDictionary forKey:uid];
    
}


/*
 * Here we Set Text Border Color
 */
-(void)setFlyerTextBorderColor :(NSString *)uid Color:(id)rgb{
    
    NSMutableDictionary *textDetailDictionary = [self getLayerFromMaster:uid];
    
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0,wht = 0.0;
    
    UILabel *labelToStore = [[UILabel alloc]init];
    labelToStore.textColor = rgb;
    
    //Getting RGB Color Code
    [labelToStore.textColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    if (red == 0 && green == 0 && blue ==0) {
        [labelToStore.textColor getWhite:&wht alpha:&alpha];
    }
    
    [textDetailDictionary setValue:[NSString stringWithFormat:@"%f, %f, %f", red, green, blue] forKey:@"textbordercolor"];
    [textDetailDictionary setValue:[NSString stringWithFormat:@"%f, %f", wht, alpha] forKey:@"textborderWhite"];
    
    // Set to Master Dictionary
    [masterLayers setValue:textDetailDictionary forKey:uid];
    
}



@end

	