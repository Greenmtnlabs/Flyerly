//
//  FlyerClass.m
//  Flyr
//
//  Created by Khurram on 27/01/2014.
//
//

#import "Flyer.h"

NSString * const TEXT = @"";
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

@implementation Flyer

@synthesize masterLayers,textFileArray,socialArray;

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
        
        //set Current Path of File Manager
        [[NSFileManager defaultManager] changeCurrentDirectoryPath:flyPath];

        //its Use Current Path
        //For Future Undo Request
        [self addToHistory];
        
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

    //set Pieces Dictionary File for Update
    piecesFile = [flyPath stringByAppendingString:[NSString stringWithFormat:@"/flyer.pieces"]];
    
    //set Text File for Update
    textFile = [flyPath stringByAppendingString:[NSString stringWithFormat:@"/flyer.txt"]];

    //set Share Status File for Update
    socialFile = [flyPath stringByAppendingString:[NSString stringWithFormat:@"/Social/flyer.soc"]];

    
    //set Flyer Image for Update
    flyerImageFile = [flyPath stringByAppendingString:[NSString stringWithFormat:@"/flyer.jpg"]];
    
    masterLayers = [[NSMutableDictionary alloc] initWithContentsOfFile:piecesFile];
    
    textFileArray = [[NSMutableArray alloc] initWithContentsOfFile:textFile];

    socialArray = [[NSMutableArray alloc] initWithContentsOfFile:socialFile];
    

}




/*
 * Here we save the dictionary to .peices files
 * and Update Flyer Image
 */
-(void)saveFlyer :(UIImage *)snapShot{

    NSData *snapShotData = UIImagePNGRepresentation(snapShot);
    [snapShotData writeToFile:flyerImageFile atomically:YES];
    
    //HERE WE WRITE IMAGE IN GALLERY
    [self saveInGallery:snapShotData];
    
    //Here we write the dictionary of .peices files
    [masterLayers writeToFile:piecesFile atomically:YES];
    
    //Here we Update Flyer Date in Text File
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MM/dd/YYYY"];
    NSString *dateString = [dateFormat stringFromDate:date];
    [self setFlyerDate:dateString];
    
    
}

/*** HERE WE SAVE IMAGE INTO GALLERY 
 * AND LINK WITH FLYERLY ALBUM
 *
 */
-(void)saveInGallery :(NSData *)imgData {
    

    // CREATE LIBRARY OBJECT FIRST
    ALAssetsLibrary * library = [[ALAssetsLibrary alloc] init];
    
    // HERE WE GET FLYERLY ALBUM URL
     NSURL *groupUrl  = [[NSURL alloc] initWithString:[[NSUserDefaults standardUserDefaults] stringForKey:@"FlyerlyAlbum"]];

    
    // HERE WE GET GROUP OF IMAGE IN GALLERY
    [library groupForURL:groupUrl resultBlock:^(ALAssetsGroup *group) {
        
       //CHECKING ALBUM EXIST IN DEVICE
        if ( group == nil ) {
            
            //ALBUM NOT FOUND
            [self createFlyerlyAlbum:imgData];
            
        } else {
            
            //ALBUM FOUND
            //GETTING IMAGE URL IF EXIST IN FLYER INFO FILE .TXT
            NSString *currentUrl = [self getFlyerURL];
        
            // CHECKING CRITERIA IMAGE CREATE OR MODIFY
            if ( [currentUrl isEqualToString:@""]) {
            
                [self createImageToFlyerlyAlbum:groupUrl ImageData:imgData];
            
            } else { // URL FOUND WE USE EXISTING URL FOR REPLACE IMAGE

                // CONVERT STRING TO URL
                NSURL *imageUrl = [[NSURL alloc] initWithString:currentUrl];
            
                // GETTING GENERATED IMAGE WITH URL
                [library assetForURL:imageUrl resultBlock:^(ALAsset *asset) {
                
                    if (asset == nil) {
 
                        // URL Exist and Image Not Found
                        // we Create New Image In Gallery
                        [self createImageToFlyerlyAlbum:groupUrl ImageData:imgData];
                    
                    } else {

                        // URL Exist and Image Found
                        //HERE WE UPDATE IMAGE WITH LATEST UPDATE
                        [asset setImageData:imgData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {

                            // FOR FUTURE WORK
                            [self setFlyerURL:assetURL.absoluteString];
                        }];
                    }
                
                } failureBlock:^(NSError *error) {
                
                    NSLog(@"Image Not Link with Album");
                }];

            
            }
        }
        
    }
    failureBlock:^(NSError *error) {
        
        NSLog(@"error adding Image");
        
    }];
    
    
    


}


/*
 * HERE WE CREATE NEW IMAGE IN GALLERY
 */
-(void)createImageToFlyerlyAlbum :(NSURL *)groupURL ImageData :(NSData *)imgData {
    
    // CREATE LIBRARY OBJECT FIRST
    ALAssetsLibrary * library = [[ALAssetsLibrary alloc] init];
    
    // HERE WE GET GROUP OF IMAGE IN GALLERY
    [library groupForURL:groupURL resultBlock:^(ALAssetsGroup *group) {
        
        //HERE WE CREATE IMAGE IN GALLERY
        [library writeImageDataToSavedPhotosAlbum:imgData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            
            // HERE WE SAVE GENERATED URL IN OVER FLYER INFO FILE .TXT
            // FOR FUTURE WORK
            [self setFlyerURL:assetURL.absoluteString];
            
            // GETTING GENERATED IMAGE WITH URL
            [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                
                //HERE WE LINK IMAGE WITH FLYERLY ALBUM
                [group addAsset:asset];
                
            } failureBlock:^(NSError *error) {
                
                NSLog(@"Image NOT LINKED");
            }];
            
        }];

        
    } failureBlock:^(NSError *error) {
        NSLog(@"Image NOT CREATED IN GALLERY");
    }];


}


/*
 * Here we return Current SnapShot for Sharing
 */
-(NSString *)getFlyerImage {

    NSString* currentPath  =   [[NSFileManager defaultManager] currentDirectoryPath];
    
    NSString *imagePath = [currentPath stringByAppendingString:@"/flyer.jpg"];
    
    return imagePath;

}



/*
 * Here we Copy Current Flyer folder with all related file
 * to History folder name as timestamp for future Undo request
 */
-(void)addToHistory {
    
    NSError *error = nil;
    NSString *lastFileName;
    
    //Getting Current Flyer folder Path
    NSString* currentSourcepath  =   [[NSFileManager defaultManager] currentDirectoryPath];
    
    
    NSString* historyDestinationpath  =  [NSString stringWithFormat:@"%@/History",currentSourcepath];
    
    NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:historyDestinationpath error:nil];
    
    
    //HISTORY CHECK
    if (fileList.count >= 1) {
        
        //HISTORY AVAILABLE
        
        NSArray *sortedFlyersList = [fileList sortedArrayUsingFunction:compareDesc context:NULL];
        
    
        NSString* historyLastFilepath = [NSString stringWithFormat:@"%@/%@",historyDestinationpath,[sortedFlyersList objectAtIndex:0]];
    
        // Here we Compare Both Files One Current Flyer Folder and Second Last flyer Folder from History if
        // its Mached  with each other then we are not create Directory
        // in history Directory other wise we make a one copy.
        if ([self compareFilesForMakeHistory:currentSourcepath LastHistoryPath:historyLastFilepath]) {
    
            //Here we Check Folder Quantity for Memory reserve
            if (sortedFlyersList.count >= 4) {
                
                NSString* historyFirstFilepath = [NSString stringWithFormat:@"%@/%@",historyDestinationpath,[sortedFlyersList objectAtIndex:sortedFlyersList.count -1]];
                [[NSFileManager defaultManager] removeItemAtPath:historyFirstFilepath error:&error];
            }
            
            
            //Create History  folder Path
            int timestamp = [[NSDate date] timeIntervalSince1970];
            NSString* historyDestinationpath  =   [NSString stringWithFormat:@"%@/History/%d",currentSourcepath,timestamp];
    
            //Create Flyer folder
            [[NSFileManager defaultManager] createDirectoryAtPath:historyDestinationpath withIntermediateDirectories:YES attributes:nil error:&error];
    
            NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:currentSourcepath error:nil];
    
            for(int i = 0 ; i < [fileList count];i++)
            {
                lastFileName = fileList[i];
        
                if (![lastFileName isEqualToString:@"History"]) {
                    NSString *source = [NSString stringWithFormat:@"%@/%@",currentSourcepath,lastFileName];
                    NSString *destination = [NSString stringWithFormat:@"%@/%@",historyDestinationpath,lastFileName];
    
                    //Here we Copying that File or Folder
                    [[NSFileManager defaultManager] copyItemAtPath:source toPath:destination error:&error];
                }
            }
        
        }// after Compare
        
    } else {
    
         //HISTORY NOT AVAILABLE
        
        //Delete .gitkeep File if Exist in History Directory
        NSString* gitkeepFilepath = [NSString stringWithFormat:@"%@/History/.gitkeep",currentSourcepath];
        if (![[NSFileManager defaultManager] fileExistsAtPath:gitkeepFilepath isDirectory:NULL]) {
            NSLog(@"gitkeep Not Exist");
        } else {
            [[NSFileManager defaultManager] removeItemAtPath:gitkeepFilepath error:&error];
        }
        
        //Create History  folder Path
        int timestamp = [[NSDate date] timeIntervalSince1970];
        NSString* historyDestinationpath  =   [NSString stringWithFormat:@"%@/History/%d",currentSourcepath,timestamp];
        
        //Create Flyer folder
        [[NSFileManager defaultManager] createDirectoryAtPath:historyDestinationpath withIntermediateDirectories:YES attributes:nil error:&error];
        
        NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:currentSourcepath error:nil];
        
        for(int i = 0 ; i < [fileList count];i++)
        {
            lastFileName = fileList[i];
            
            if (![lastFileName isEqualToString:@"History"]) {
                NSString *source = [NSString stringWithFormat:@"%@/%@",currentSourcepath,lastFileName];
                NSString *destination = [NSString stringWithFormat:@"%@/%@",historyDestinationpath,lastFileName];
                
                //Here we Copying that File or Folder
                [[NSFileManager defaultManager] copyItemAtPath:source toPath:destination error:&error];
            }
        }
        
    }//HISTORY CHECK

}



/*
 * Here we Replace Current Flyer Folder From History of Last Generated
 */
-(void)replaceFromHistory{
    
    NSError *error = nil;
    NSString *lastFileName;
    
    //Getting Current Flyer folder Path
    NSString* currentPath  =   [[NSFileManager defaultManager] currentDirectoryPath];
    
    NSString* historyDestinationpath  =  [NSString stringWithFormat:@"%@/History",currentPath];
    
    NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:historyDestinationpath error:nil];
    
    NSArray *sortedFlyersList = [fileList sortedArrayUsingFunction:compareDesc context:NULL];
    
    if (sortedFlyersList.count < 1)return;
    int idx = 0;
    
   NSString *historyLastFilepath = [NSString stringWithFormat:@"%@/%@",historyDestinationpath,[sortedFlyersList objectAtIndex:idx]];
    
    
    // Here we Compare Both Files One Current Flyer Folder and Second Last flyer Folder from History if
    // its Mached  with each other then we get previous Directory for Undo if Exists
    if (![self compareFilesForMakeHistory:currentPath LastHistoryPath:historyLastFilepath]) {
        
        idx++;
        
        //Here we Delete Last History Folder if Only One copy Exist it will be not delete
        if (sortedFlyersList.count > 1) {
            [[NSFileManager defaultManager] removeItemAtPath:historyLastFilepath error:&error];
        }
        if (sortedFlyersList.count > idx) {
            historyDestinationpath = [NSString stringWithFormat:@"%@/%@",historyDestinationpath,[sortedFlyersList objectAtIndex:idx]];
        }else {
            historyDestinationpath = [NSString stringWithFormat:@"%@/%@",historyDestinationpath,[sortedFlyersList objectAtIndex:idx -1]];
        }
        
        //Here we set Replace Current Folder From History recommended
        NSArray *historyLastFolderList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:historyDestinationpath error:nil];
        
        
        for(int i = 0 ; i < [historyLastFolderList count];i++)
        {
            lastFileName = historyLastFolderList[i];
            
            if (![lastFileName isEqualToString:@"History"]) {
                NSString *source = [NSString stringWithFormat:@"%@/%@",historyDestinationpath,lastFileName];
                NSString *destination = [NSString stringWithFormat:@"%@/%@",currentPath,lastFileName];
                
                //First we Delete that File or Folder after we copy from History
                //Here we Delete that File or Folder From Current Folder
                [[NSFileManager defaultManager] removeItemAtPath:destination error:&error];
                
                //Here we Copy that File or Folder From History
                [[NSFileManager defaultManager] copyItemAtPath:source toPath:destination error:&error];
            }
        }

        
    }
    
    
    
 
}


-(BOOL)compareFilesForMakeHistory :(NSString *)curPath LastHistoryPath:(NSString *)hisPath {
    
    BOOL status = YES;
    
    //set Current Pieces Dictionary File
    NSString *curPiecesFile = [curPath stringByAppendingString:[NSString stringWithFormat:@"/flyer.pieces"]];
    
    //set History Pieces Dictionary File
    NSString *historyPiecesFile = [hisPath stringByAppendingString:[NSString stringWithFormat:@"/flyer.pieces"]];

    NSError *error = nil;
    
    NSString *curStr = [[NSString alloc] initWithContentsOfFile:curPiecesFile encoding:NSUTF8StringEncoding error:&error];
    NSString *hisStr =  [[NSString alloc] initWithContentsOfFile:historyPiecesFile encoding:NSUTF8StringEncoding error:&error];
    
    if ([curStr isEqualToString:hisStr]) {
        status = NO;
    }

    return status;
}


/*
 * Here we Delete One Layer from dictionary of Flyer
 * and Front View also..
 */
-(void)deleteLayer :(NSString *)uid{
    
    //Delete From Dictionary
    [masterLayers removeObjectForKey:uid];

}

/*
 *Return textbox text
 */
-(NSString *)getText :(NSString *)uid{

    NSMutableDictionary *textDic = [self getLayerFromMaster:uid];
    return [textDic objectForKey:@"text"];
}

-(NSString *)getImageName :(NSString *)uid{
    NSMutableDictionary *layDic = [self getLayerFromMaster:uid];
    return [layDic objectForKey:@"image"];

}

-(CGRect)getImageFrame :(NSString *)uid{
    NSMutableDictionary *detail = [self getLayerFromMaster:uid];
    return CGRectMake([[detail valueForKey:@"x"] floatValue], [[detail valueForKey:@"y"] floatValue], [[detail valueForKey:@"width"] floatValue], [[detail valueForKey:@"height"] floatValue]);
}


-(float)getHight :(NSString *)uid {
    NSMutableDictionary *textDic = [self getLayerFromMaster:uid];
    return [[textDic objectForKey:@"height"] floatValue];
}


-(float)getWidth :(NSString *)uid {
    NSMutableDictionary *textDic = [self getLayerFromMaster:uid];
    return [[textDic objectForKey:@"width"] floatValue];
}


/*
 * Here we return All Unique Keys of layers
 */
-(NSArray *)allKeys{
    NSLog(@"%@", masterLayers);
    
    // Reutrn sorted (by id/timestamp) array of all keys in the layers dictionary
    return [[masterLayers allKeys] sortedArrayUsingFunction:compareTimestamps context:NULL];
}


/*
 *Here we sort Array in Ascending order for Exact Render of Flyer
 * as last saved.
 */
NSInteger compareTimestamps(id stringLeft, id stringRight, void *context) {
    
    // Convert both strings to integers
    int intLeft = [stringLeft intValue];
    int intRight = [stringRight intValue];
    
    if (intLeft < intRight)
        return NSOrderedAscending;
    else if (intLeft > intRight)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}


/*
 *Here we sort Array in Desending order for Exact Render of Flyer
 * as last saved.
 */
NSInteger compareDesc(id stringLeft, id stringRight, void *context) {
    
    // Convert both strings to integers
    int intLeft = [stringLeft intValue];
    int intRight = [stringRight intValue];
    
    if (intLeft < intRight)
        return NSOrderedDescending;
    else if (intLeft > intRight)
        return NSOrderedAscending;
    else
        return NSOrderedSame;
}

/*
 * Here we get Selected Dictionary From MasterLayers
 */
-(NSMutableDictionary *)getLayerFromMaster :(NSString *)uid {
    return [masterLayers objectForKey:uid];
}




/*
 * When New Symbol layer Add on Flyer
 * its will call and Add one Content in MasterLayers Dictionary
 * return
 *      UniqueID
 */
-(NSString *)addImage{
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    
    NSString *uniqueId = [NSString stringWithFormat:@"%d",timestamp];
    
    
    //Create Dictionary for Symbol
    NSMutableDictionary *imageDetailDictionary = [[NSMutableDictionary alloc] init];
    imageDetailDictionary[@"image"] = @"";
    imageDetailDictionary[@"imageTag"] = @"";
    imageDetailDictionary[@"x"] = @"10";
    imageDetailDictionary[@"y"] = @"10";
    imageDetailDictionary[@"width"] = @"90";
    imageDetailDictionary[@"height"] = @"70";
    
    [masterLayers setValue:imageDetailDictionary forKey:uniqueId];
    return uniqueId;
}

-(void)setImageFrame :(NSString *)uid :(CGRect)photoFrame {

    NSMutableDictionary *imageDetailDictionary = [self getLayerFromMaster:uid];
    imageDetailDictionary[@"x"] = [NSString stringWithFormat:@"%f",photoFrame.origin.x];
    imageDetailDictionary[@"y"] = [NSString stringWithFormat:@"%f",photoFrame.origin.y];
    imageDetailDictionary[@"width"] = [NSString stringWithFormat:@"%f",photoFrame.size.width];
    imageDetailDictionary[@"height"] = [NSString stringWithFormat:@"%f",photoFrame.size.height];
    
    [masterLayers setValue:imageDetailDictionary forKey:uid];
}


/*
 * Set Image Tag For Highlight Last image
 */
-(void)setImageTag :(NSString *)uid Tag :(NSString *)tag {
    
    NSMutableDictionary *imageDetailDictionary = [self getLayerFromMaster:uid];
        
    [imageDetailDictionary setValue:tag forKey:@"imageTag"];
    
    // Set to Master Dictionary
    [masterLayers setValue:imageDetailDictionary forKey:uid];

}


/*
 * Return Image Tag
 */
-(NSString *)getImageTag :(NSString *)uid {
    
    NSMutableDictionary *imageDetailDictionary = [self getLayerFromMaster:uid];
    return [imageDetailDictionary valueForKey:@"imageTag"] ;
}



-(void)setImagePath :(NSString *)uid ImgPath:(NSString *)imgPath{

    NSMutableDictionary *imageDetailDictionary = [self getLayerFromMaster:uid];
    
    //Here We Delete Old Map File if Exist
    if (![[imageDetailDictionary objectForKey:@"image"] isEqualToString:@""]) {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:[imageDetailDictionary objectForKey:@"image"] error:&error];
    }
    
    [imageDetailDictionary setValue:imgPath forKey:@"image"];
    
    // Set to Master Dictionary
    [masterLayers setValue:imageDetailDictionary forKey:uid];
    
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
        
        int timestamp = [[NSDate date] timeIntervalSince1970];
        
        NSString *flyerPath = [usernamePath stringByAppendingString:[NSString stringWithFormat:@"/%d",timestamp]];
        
    return flyerPath;

}

/*
 * Here we Getting flyer directories which name are timestamp
 * return
 *      Decending Sorted Array
 */
+ (NSMutableArray *)recentFlyerPreview:(NSInteger)flyCount{

    PFUser *user = [PFUser currentUser];
    
    //Getting Home Directory
	NSString *homeDirectoryPath = NSHomeDirectory();
	NSString *usernamePath = [homeDirectoryPath stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@/Flyr",[user objectForKey:@"username"]]];
    
     NSArray *flyersList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:usernamePath error:nil];
    
    NSArray *sortedFlyersList = [flyersList sortedArrayUsingFunction:compareDesc context:NULL];
    
    NSString *lastFileName;
    NSMutableArray *recentFlyers = [[NSMutableArray alloc] init];
    
        
    for(int i = 0 ; i < sortedFlyersList.count ;i++)
    {
        lastFileName = sortedFlyersList[i];
            
        //Checking For Integer Dir Names Only
        if ([[NSScanner scannerWithString:lastFileName] scanInt:nil]) {
              
            NSString *recentflyPath = [NSString stringWithFormat:@"%@/%@/flyer.jpg",usernamePath,lastFileName];
            [recentFlyers addObject:recentflyPath];

        }

    }
    
    return recentFlyers;
}




/*
 * Here We Change Flyer Directory Name to Current Time Stamp
 */
-(void)setRecentFlyer {

    NSString* currentpath  =   [[NSFileManager defaultManager] currentDirectoryPath];
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *replaceDirName = [NSString stringWithFormat: @"%d",timestamp];
    
    //Here we Rename the Directory Name
    NSString *newPath = [[currentpath stringByDeletingLastPathComponent] stringByAppendingPathComponent:replaceDirName];
    NSError *error = nil;
    [[NSFileManager defaultManager] moveItemAtPath:currentpath toPath:newPath error:&error];
    
    if (error) {
        NSLog(@"%@",error.localizedDescription);
    }


}


/*** HERE WE CREATE FLYERLY SEPERATE ALBUM
 * FOR FLYER SAVING
 *
 */
-(void)createFlyerlyAlbum {
    
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    
    NSString *albumName = @"Flyerly";
    
    //HERE WE SEN REQUEST FOR CREATE ALBUM
    [library addAssetsGroupAlbumWithName:albumName
                             resultBlock:^(ALAssetsGroup *group) {
                                 
                                // GETTING CREATED URL OF ALBUM
                                NSURL *groupURL = [group valueForProperty:ALAssetsGroupPropertyURL];
                                 
                                //SAVING IN PREFERENCES .PLIST FOR FUTURE USE
                                [[NSUserDefaults standardUserDefaults]   setObject:groupURL.absoluteString forKey:@"FlyerlyAlbum"];
                             }
     
                            failureBlock:^(NSError *error) {
                                NSLog(@"error adding album");
                        }];
    
}


/*
 * THIS METHOD CREATE ALBUM ON DEVICE AFTER IT SAVING IMAGE IN LIBRARY
 */
-(void)createFlyerlyAlbum :(NSData *)imgdata {
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    
    NSString *albumName = @"Flyerly";
    
    //HERE WE SEN REQUEST FOR CREATE ALBUM
    [library addAssetsGroupAlbumWithName:albumName
                             resultBlock:^(ALAssetsGroup *group) {
                                 
                                 // GETTING CREATED URL OF ALBUM
                                 NSURL *groupURL = [group valueForProperty:ALAssetsGroupPropertyURL];
                                 
                                 //SAVING IN PREFERENCES .PLIST FOR FUTURE USE
                                 [[NSUserDefaults standardUserDefaults]   setObject:groupURL.absoluteString forKey:@"FlyerlyAlbum"];
                                 
                                 [self createImageToFlyerlyAlbum:groupURL ImageData:imgdata];
                             }
     
                            failureBlock:^(NSError *error) {
                                NSLog(@"error adding album");
                            }];


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



/*
 * Here we Set Flyer Color
 */
-(void)setFlyerBorder :(NSString *)uid RGBColor:(id)rgb{
    
    NSMutableDictionary *templateDictionary = [self getLayerFromMaster:uid];
    
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0,wht = 0.0;
    
    UILabel *labelToStore = [[UILabel alloc]init];
    labelToStore.textColor = rgb;
    
    //Getting RGB Color Code
    [labelToStore.textColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    if (red == 0 && green == 0 && blue ==0) {
        [labelToStore.textColor getWhite:&wht alpha:&alpha];
    }
    
    [templateDictionary setValue:[NSString stringWithFormat:@"%f, %f, %f", red, green, blue] forKey:@"bordercolor"];
    [templateDictionary setValue:[NSString stringWithFormat:@"%f, %f", wht, alpha] forKey:@"bordercolorWhite"];
    
    // Set to Master Dictionary
    [masterLayers setValue:templateDictionary forKey:uid];
    
}


#pragma mark  Social File Methods

-(void)setFacebookStatus :(int)status {

    [socialArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%d",status]];

    //Here we write the Array of Text files .txt
    [socialArray writeToFile:socialFile atomically:YES];
    
}


-(void)setTwitterStatus :(int)status {
    
    [socialArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%d",status]];
    
    //Here we write the Array of Text files .txt
    [socialArray writeToFile:socialFile atomically:YES];
    
}

-(void)setEmailStatus :(int)status {
    
    [socialArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%d",status]];
    
    //Here we write the Array of Text files .txt
    [socialArray writeToFile:socialFile atomically:YES];
    
}

-(void)setThumblerStatus :(int)status {
    
    [socialArray replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%d",status]];
    
    //Here we write the Array of Text files .txt
    [socialArray writeToFile:socialFile atomically:YES];
    
}


-(void)setFlickerStatus :(int)status {
    
    [socialArray replaceObjectAtIndex:4 withObject:[NSString stringWithFormat:@"%d",status]];
    
    //Here we write the Array of Text files .txt
    [socialArray writeToFile:socialFile atomically:YES];
    
}


-(void)setInstagaramStatus :(int)status {
    
    [socialArray replaceObjectAtIndex:5 withObject:[NSString stringWithFormat:@"%d",status]];
    
    //Here we write the Array of Text files .txt
    [socialArray writeToFile:socialFile atomically:YES];
    
}


-(void)setSmsStatus :(int)status {
    
    [socialArray replaceObjectAtIndex:6 withObject:[NSString stringWithFormat:@"%d",status]];
    
    //Here we write the Array of Text files .txt
    [socialArray writeToFile:socialFile atomically:YES];
    
}

-(void)setClipboardStatus :(int)status {

    [socialArray replaceObjectAtIndex:7 withObject:[NSString stringWithFormat:@"%d",status]];
    
    //Here we write the Array of Text files .txt
    [socialArray writeToFile:socialFile atomically:YES];
}


/*
 * Here we Return Facebook Share Status of Flyer
 */
-(NSString *)getFacebookStatus {
    return [socialArray objectAtIndex:0];
}


/*
 * Here we Return Twitter Share Status of Flyer
 */
-(NSString *)getTwitterStatus {
    return [socialArray objectAtIndex:1];

}


/*
 * Here we Return Email Share Status of Flyer
 */

-(NSString *)getEmailStatus {
    return [socialArray objectAtIndex:2];
    
}


/*
 * Here we Return Thumbler Share Status of Flyer
 */
-(NSString *)getThumblerStatus {
    return [socialArray objectAtIndex:3];
    
}

/*
 * Here we Return Flicker Share Status of Flyer
 */
-(NSString *)getFlickerStatus {
    return [socialArray objectAtIndex:4];
    
}

/*
 * Here we Return Instagram Share Status of Flyer
 */
-(NSString *)getInstagaramStatus {
    return [socialArray objectAtIndex:5];

}


/*
 * Here we Return Sms Share Status of Flyer
 */
-(NSString *)getSmsStatus {
    return [socialArray objectAtIndex:6];

}

/*
 * Here we Return Clipboard Share Status of Flyer
 */
-(NSString *)getClipboardStatus {
    return [socialArray objectAtIndex:7];

}


/*
 * Here we Return Flyer Title From .txt File
 */
-(NSString *)getFlyerTitle{
    
    return [textFileArray objectAtIndex:0];
}



/*
 * Here we Set Flyer Title
 */
-(void)setFlyerTitle :(NSString *)name {
    
    [textFileArray replaceObjectAtIndex:0 withObject:name];
    
    //Here we write the Array of Text files .txt
    [textFileArray writeToFile:textFile atomically:YES];
}


/*
 * Here we Return Flyer Description From .txt File
 */
-(NSString *)getFlyerDescription{
    
    return [textFileArray objectAtIndex:1];
}


/*
 * Here we Return Flyer Date From .txt File
 */

-(NSString *)getFlyerDate{
    return [textFileArray objectAtIndex:2];
}

/*
 * Here we Return Flyer URL OF LINK IMAGE OF GALLERY From .txt File
 */

-(NSString *)getFlyerURL {
    return [textFileArray objectAtIndex:3];
}


/*
 * Here we Set Flyer Description
 */
-(void)setFlyerDescription :(NSString *)desp {

    [textFileArray replaceObjectAtIndex:1 withObject:desp];
    
    //Here we write the Array of Text files .txt
    [textFileArray writeToFile:textFile atomically:YES];


}



/*
 * Here we Set Flyer Date
 */
-(void)setFlyerDate :(NSString *)dt {
    
    [textFileArray replaceObjectAtIndex:2 withObject:dt];
    
    //Here we write the Array of Text files .txt
    [textFileArray writeToFile:textFile atomically:YES];
}


/*
 * HERE WE SAVE FLYER PATH OF GALLERY LINK IMAGE
 */
-(void)setFlyerURL :(NSString *)URL {

    [textFileArray replaceObjectAtIndex:3 withObject:URL];
    
    //Here we write the Array of Text files .txt
    [textFileArray writeToFile:textFile atomically:YES];

    
}

@end

	