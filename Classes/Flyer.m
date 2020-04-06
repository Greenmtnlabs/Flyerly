 //
//  FlyerClass.m
//  Flyr
//
//  Created by Khurram on 27/01/2014.
//
//

#import "Flyer.h"
#import "Common.h"
#import <Photos/Photos.h>

NSString * const TEXT = @"";
NSString * const TEXTFONTNAME = @".HelveticaNeueInterface-M3";
NSString * const TEXTFONTSIZE = @"18.000000";
NSString * const TEXTCOLOR = @"0.000000, 0.000000, 0.000000";
NSString * const TEXTWHITECOLOR = @"0.000000, 1.000000";
NSString * const TEXTBORDERWHITE = @"0.000000, 0.000000";
NSString * const TEXTBORDERCOLOR = @"0.000000, 0.000000, 0.000000";

// We change these values later for iPhone6 and iPhone 6 plus
NSString * TEXTxPOS = @"15.000000";
NSString * TEXTyPOS = @"15.000000";

NSString * TEXTWIDTH = @"280.000000";
NSString * TEXTHEIGHT = @"280.000000";

NSString * const CLIPARTFONTSIZE = @"60.000000";
NSString * const CLIPARTxPOS = @"5.000000";
NSString * const CLIPARTyPOS = @"5.000000";
NSString * const CLIPARTWIDTH = @"160.000000";
NSString * const CLIPARTHEIGHT = @"100.000000";

NSString * const LINECOLOR = @"0.000000, 0.000000, 0.000000";

@implementation Flyer

@synthesize masterLayers;
@synthesize textFileArray;
@synthesize socialArray;
@synthesize saveInGallaryAfterNumberOfTasks,saveInGallaryRequired;

/*
 * This method will be used to initiate the Flyer class
 * set Flyer Path to Open In create Screen
 * it will create a directory structure for 3.0 Version if not Exist
 */
-(id)initWithPath:(NSString *)flyPath setDirectory:(BOOL)setDirectory {
    
    //Change size and position of textview
    if ( IS_IPHONE_6 ){
        TEXTxPOS = @"10.000000";
        TEXTWIDTH = @"345.000000";
        TEXTHEIGHT = @"315.000000";
        
    } else if ( IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS){
        TEXTxPOS = @"5.000000";
        TEXTWIDTH = @"390.000000";
        TEXTHEIGHT = @"360.000000";
    }
    
    self = [super init];
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:flyPath isDirectory:NULL] ) {
        
        //Create New Directory
        [self createFlyerPath:flyPath];
        [Flurry logEvent:@"Create Flyer"];
        
        // set Current Path of File Manager
        [[NSFileManager defaultManager] changeCurrentDirectoryPath:flyPath];

        //its Use Current Path
        //For Future Undo Request
        [self addToHistory];
        
    }
    
    _setDirectory = setDirectory;
    
    // Set Current Path of File Manager. Do not do this if we have been
    // asked not to do it.
    if ( _setDirectory ) {
        [[NSFileManager defaultManager] changeCurrentDirectoryPath:flyPath];
    }
    
    //Load flyer
    [self loadFlyer:flyPath];
    [self resetSaveGallaryTasks];

    return self;
}

/**
 * Set up the paths.
 */
- (void)setupPaths:(NSString *)flyPath {
    curFlyerPath = flyPath;
    //set Pieces Dictionary File for Update
    piecesFile = [curFlyerPath stringByAppendingString:[NSString stringWithFormat:@"/flyer.pieces"]];
    
    //set Text File for Update
    textFile = [curFlyerPath stringByAppendingString:[NSString stringWithFormat:@"/flyer.txt"]];
    
    //set Share Status File for Update
    socialFile = [curFlyerPath stringByAppendingString:[NSString stringWithFormat:@"/Social/flyer.soc"]];
    
    //set Flyer Image for Future Update
    flyerImageFile = [curFlyerPath stringByAppendingString:[NSString stringWithFormat:@"/flyer.%@",IMAGETYPE]];
}


/*
 *load the dictionary from .peices file
 */
-(void)loadFlyer :(NSString *)flyPath {

    [self setupPaths:flyPath];
    
    masterLayers = [[NSMutableDictionary alloc] initWithContentsOfFile:piecesFile];
    
    textFileArray = [[NSMutableArray alloc] initWithContentsOfFile:textFile];

    socialArray = [[NSMutableArray alloc] initWithContentsOfFile:socialFile];
}

/*
 * Here we Update Current Flyer Snapshot
 */
-(void)setUpdatedSnapshotWithImage :(UIImage *)snapShot {
    
    //Getting Current Path
    NSString* currentPath  =   [[NSFileManager defaultManager] currentDirectoryPath];
    
    //set Flyer Image for Future Update
    flyerImageFile = [currentPath stringByAppendingString:[NSString stringWithFormat:@"/flyer.%@",IMAGETYPE]];

    
    //Convert Imgae into Data
    NSData *snapShotData = UIImagePNGRepresentation(snapShot);
    
    //Here we Update Flyer File from Current Snapshot
    [snapShotData writeToFile:flyerImageFile atomically:YES];

}



/*
 * Here we save the dictionary to .peices files
 */
-(void)saveFlyer{
    
    //Here we write the dictionary of .peices files
    [masterLayers writeToFile:piecesFile atomically:YES];
    
    //Here we Update Flyer Date in Text File
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
//    NSDate *startDate = [dateFormat dateFromString:dateString];

    NSString *createdDate = [self getFlyerDate];

    if ([createdDate isEqualToString:@""]) {
        [self setFlyerDate:dateString];
    }else {
        [self setFlyerUpdatedDate:dateString];
    }
}

/**
 * Get flyer updated date in ago format: 3Mi ( 3minutes ) or 3Y
 */
-(NSString *)getFlyerUpdateDateInAgoFormat{
   NSString *updatedDate = [self getFlyerUpdateDate];
    if ([updatedDate isEqualToString:@""] == NO) {
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        if( [updatedDate rangeOfString:@":"].location != NSNotFound )
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"]; //this is we are using new format
        else
            [dateFormat setDateFormat:@"MM/dd/yyyy"]; //for old flyer
        
        NSDate *startDate = [dateFormat dateFromString:updatedDate];
        
        NSDate *endDate = [NSDate date];
        NSTimeInterval secondsBetween = [endDate timeIntervalSinceDate:startDate];
        int minute  = floor(secondsBetween/(60));
        int hour  = secondsBetween/(60*60);

        if( hour > 23 ){
            NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
            [dateformate setDateFormat:@"yyyy-MM-dd"];
            NSString *date = [dateformate stringFromDate:startDate];
            updatedDate = [NSString stringWithFormat:@"%@",date];
        } else if( hour > 0 ){
            updatedDate = [NSString stringWithFormat:@"%ih",hour];
        } else {
            updatedDate = [NSString stringWithFormat:@"%im",minute];
        }
    }
    return updatedDate;
}


/*
 * Here we Update Image for Video Overlay Image
 */
-(void)setVideoCover :(UIImage *)snapShot {
    
    NSString* currentPath  =   [[NSFileManager defaultManager] currentDirectoryPath];
    
    //set Flyer Image for Future Update
    flyerImageFile = [currentPath stringByAppendingString:[NSString stringWithFormat:@"/flyer.%@",IMAGETYPE]];


    NSData *snapShotData = UIImagePNGRepresentation(snapShot);
    [snapShotData writeToFile:flyerImageFile atomically:YES];
}

/**
 * Here we check following tasks before save
 * if its video flyer then add in gallary after interstiall add hide and merging done
 */
-(BOOL)saveAfterCheck{
    BOOL saved = NO;
    saveInGallaryAfterNumberOfTasks++;
    
    if( saveInGallaryAfterNumberOfTasks > 0 ){
        if ( [self isVideoFlyer] ){
            if( saveInGallaryAfterNumberOfTasks > 1 ){
                [self resetSaveGallaryTasks];
                [self saveIntoGallery];
                saved = YES;
            }
        } else{
                [self resetSaveGallaryTasks];
                [self saveIntoGallery];
                saved = YES;
        }
    }
    return saved;
}
/**
 * Save in gallary after checking userdefaults, without data
 */
-(void)saveIntoGallery{
    
    
    /*
     * These lines of code are commented because it is a requirement of client.
     * Now every flyer (Public/Private) will be saved in Photos
     */
    // If a flyer is Private, it will not be saved in Camera Roll
    //    if ([[self getShareType] isEqualToString:@"Private"]){
    //        return;
    //    }
    
    // HERE WE CHECK USER ALLOWED TO SAVE IN GALLERY FROM SETTING
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"saveToCameraRollSetting"]){
        
        if ( [self isVideoFlyer] ){
            [self saveIntoGalleryWithData:nil];
        }else {
            UIImage *snapShot = [UIImage imageWithContentsOfFile:[self getFlyerImage]];
            //Getting Current Path
            NSString* currentPath  =   [[NSFileManager defaultManager] currentDirectoryPath];
            
            //set Flyer Image for Future Update
            flyerImageFile = [currentPath stringByAppendingString:[NSString stringWithFormat:@"/flyer.%@",IMAGETYPE]];
            
            
            //Convert Imgae into Data
            NSData *snapShotData = UIImagePNGRepresentation(snapShot);
            
            //Here we Update Flyer File from Current Snapshot
            [snapShotData writeToFile:flyerImageFile atomically:YES];
            [self saveIntoGalleryWithData:snapShotData];
        }
    }
}


//HERE WE CHECK USER DID ALLOWED TO ACESS PHOTO library
-(BOOL)canSaveInGallary {
    return !([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted || [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied);
}

-(void)showAllowSaveInGallerySettingAlert{
    
    NSString *msg;
    
    msg = [NSString  stringWithFormat:@"Please allow %@ to add photo in gallery( Settings -> Privacy -> Photos)", APP_NAME] ;

    UIAlertView *permAlert = [[UIAlertView alloc] initWithTitle:@"Settings"
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
    
    [permAlert show];
}

/*** HERE WE SAVE IMAGE INTO GALLERY
 * AND LINK WITH FLYERLY ALBUM
 * Data is required
 */
-(void)saveIntoGalleryWithData :(NSData *)imgData {
    

    // CREATE LIBRARY OBJECT FIRST
    if ( _library == nil ) {
        _library = [[ALAssetsLibrary alloc] init];
    }
    
    __weak ALAssetsLibrary* library = _library;
    
    //Checking Group Path should be not null for Flyer Saving In Gallery
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"FlyerlyAlbum"] == nil) {
        return;
    }

    //if not allow so ignore Flyer saving in Gallery
    if ( [self canSaveInGallary ] == NO ) {
        [self showAllowSaveInGallerySettingAlert];
        return;
    }


    
    // HERE WE GET FLYERLY ALBUM URL
     NSURL *groupUrl  = [[NSURL alloc] initWithString:[[NSUserDefaults standardUserDefaults] stringForKey:@"FlyerlyAlbum"]];
    
    
    // HERE WE GET GROUP OF IMAGE IN GALLERY
    [_library groupForURL:groupUrl resultBlock:^(ALAssetsGroup *group) {
        
       //CHECKING ALBUM EXIST IN DEVICE
        if ( group == nil ) {
            
            //ALBUM NOT FOUND
            [self createFlyerlyAlbum:imgData];
            
        } else {
            
            //ALBUM FOUND
            //GETTING IMAGE OR VIDEO URL IF EXIST IN FLYER INFO FILE .TXT
                NSString *currentUrl;
            
            if ( [self isVideoFlyer] ){
                currentUrl = [self getVideoAssetURL];
            }else {
                currentUrl = [self getFlyerURL];
            }

            [self resetSaveGallaryTasks];
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.3 ) {
                // delete any previous saved flyer
                [self deleteAssetWithURL:currentUrl];
            }

            
            // CHECKING CRITERIA CREATE OR MODIFY
            if ( [currentUrl isEqualToString:@""]) {
            
                if ( [self isVideoFlyer] ){
                    [self createVideoToFlyerlyAlbum:groupUrl VideoData:[NSURL fileURLWithPath:[self getSharingVideoPath]]];
                }else {
                    [self createImageToFlyerlyAlbum:groupUrl ImageData:imgData];
                }
            
            } else { // URL FOUND WE USE EXISTING URL FOR REPLACE IMAGE
                
                // CONVERT STRING TO URL
                NSURL *imageUrl = [[NSURL alloc] initWithString:currentUrl];
            
                // GETTING GENERATED IMAGE WITH URL
                [library assetForURL:imageUrl resultBlock:^(ALAsset *asset) {
                
                    if (asset == nil) {
 
                        // URL Exist and Image Not Found
                        // we Create New Content In Gallery
                        if ( [self isVideoFlyer] ){
                            
                            //For Video
                            [self createVideoToFlyerlyAlbum:groupUrl VideoData:[NSURL fileURLWithPath:[self getSharingVideoPath]]];
                        }else {
                            
                            //For Image
                            [self createImageToFlyerlyAlbum:groupUrl ImageData:imgData];
                        }
                    } else {
                        
                        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.3 ) {
                            
                            
                            if ( [self isVideoFlyer] ){
                                
                                //For Video
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self createVideoToFlyerlyAlbum:groupUrl VideoData:[NSURL fileURLWithPath:[self getSharingVideoPath]]];
                                });
                                
                            }else {
                                
                                //For Image
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self createImageToFlyerlyAlbum:groupUrl ImageData:imgData];
                                });
                                
                            }

                        } else {
                            
                            if ( [self isVideoFlyer] ){
                                
                                //Update Video
                                [asset setVideoAtPath:[NSURL fileURLWithPath:[self getSharingVideoPath]] completionBlock:^(NSURL *assetURL, NSError *error) {
                                }];
                                
                            }else {
                                
                                //Update Image
                                [asset setImageData:imgData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                                }];
                            }

                        }
                        
                        // URL Exist and Image Found
                        //HERE WE UPDATE Content WITH LATEST UPDATE
                                            }
                
                } failureBlock:^(NSError *error) {
                }];

            
            }
        }
        
    }
    failureBlock:^(NSError *error) {
    }];
}

/**
 * Reset vars who helps while saving in gallary
 */
-(void)resetSaveGallaryTasks{
    //Reset gallary saving conditions
    saveInGallaryRequired = 0;
    saveInGallaryAfterNumberOfTasks = 0;
}

/**
 Delete Previous Flyer From the Photos
**/
-(void)deleteAssetWithURL:(NSString*)assetURLString
{
    NSURL *assetURL = [NSURL URLWithString:assetURLString];
    if (assetURL == nil)
    {
        return;
    }
    
    PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[assetURL] options:nil];
    if (result.count > 0)
    {
        PHAsset *phAsset = result.firstObject;
        if ((phAsset != nil) && ([phAsset canPerformEditOperation:PHAssetEditOperationDelete]))
        {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^
             {
                 [PHAssetChangeRequest deleteAssets:@[phAsset]];
             }
                                              completionHandler:^(BOOL success, NSError *error)
             {
                 if ((!success) && (error != nil))
                 {
                     NSLog(@"Error deleting asset: %@", [error description]);
                 }
             }];
        }
    }
}


/*
 * HERE WE CREATE NEW IMAGE IN GALLERY
 */
-(void)createImageToFlyerlyAlbum :(NSURL *)groupURL ImageData :(NSData *)imgData {
    
    // CREATE LIBRARY OBJECT FIRST
    if ( _library == nil ) {
        _library = [[ALAssetsLibrary alloc] init];
    }
    
    __weak ALAssetsLibrary* library = _library;
    
    // HERE WE GET GROUP OF IMAGE IN GALLERY
    [_library groupForURL:groupURL resultBlock:^(ALAssetsGroup *group) {
        
        //HERE WE CREATE IMAGE IN GALLERY
        [library  writeImageDataToSavedPhotosAlbum:imgData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            
            // HERE WE SAVE IMAGE GENERATED URL IN OVER FLYER INFO FILE .TXT
            // FOR FUTURE WORK
            __weak Flyer *weakSelf = self;
            dispatch_async( dispatch_get_main_queue(), ^{
                [weakSelf setFlyerURL:assetURL.absoluteString];
            });
            
            // GETTING GENERATED IMAGE WITH URL
            [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                
                //HERE WE LINK IMAGE WITH FLYERLY ALBUM
                [group addAsset:asset];
                
            } failureBlock:^(NSError *error) {
                NSLog( @"Image not linked: %@", error.localizedDescription );
            }];
            
        }];

        
    } failureBlock:^(NSError *error) {
        NSLog( @"Image not created in gallery: %@", error.localizedDescription );
    }];


}

/*
* HERE WE CREATE NEW VIDEO IN GALLERY
*/
-(void)createVideoToFlyerlyAlbum :(NSURL *)groupURL VideoData :(NSURL *)VideoURL {
    
    // CREATE LIBRARY OBJECT FIRST
    if ( _library == nil ) {
        _library = [[ALAssetsLibrary alloc] init];
    }
    
    __weak ALAssetsLibrary* library = _library;
    
    // HERE WE GET GROUP OF IMAGE IN GALLERY
    [_library groupForURL:groupURL resultBlock:^(ALAssetsGroup *group) {
        
        //HERE WE CREATE IMAGE IN GALLERY
        [library  writeVideoAtPathToSavedPhotosAlbum:VideoURL completionBlock:^(NSURL *assetURL, NSError *error) {
            
            // HERE WE SAVE VIDEO GENERATED URL IN OVER FLYER INFO FILE .TXT
            // FOR FUTURE WORK
            __weak Flyer *weakSelf = self;
            dispatch_async( dispatch_get_main_queue(), ^{
                [weakSelf setVideoAsssetURL:assetURL.absoluteString];
            });
            
            // GETTING GENERATED Video WITH URL
            [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                
                //HERE WE LINK IMAGE WITH FLYERLY ALBUM
                [group addAsset:asset];
                
            } failureBlock:^(NSError *error) {
                
                NSLog( @"Image not linked: %@", error.localizedDescription );
            }];
            
        }];
        
        
    } failureBlock:^(NSError *error) {
        NSLog( @"Image not created in gallery: %@", error.localizedDescription );
    }];
    
}


/*
 * Here we return Current SnapShot for Sharing
 */
-(NSString *)getFlyerImage {

    NSString *imagePath;
    
    // If we have the directory set to this flyer.
    if ( _setDirectory ) {
        NSString* currentPath  =   [[NSFileManager defaultManager] currentDirectoryPath];
        imagePath = [currentPath stringByAppendingString:[NSString stringWithFormat:@"/flyer.%@",IMAGETYPE] ];
    } else {
        imagePath = flyerImageFile;
    }
    
    return imagePath;
}

/*
 * Here we check, we need to save flyer in history or not
 */
-(BOOL)isSaveRequired {
    NSMutableDictionary *oldMasterLayers = [[NSMutableDictionary alloc] initWithContentsOfFile:piecesFile];
    BOOL canSave = ( [oldMasterLayers isEqualToDictionary:masterLayers]) ? NO : YES;
    if( canSave == NO ){
        canSave = [self isVideoMergeProcessRequired];
    }
    return  canSave;
}

/*
 * Here we Matching Current Layers File with Last history Layers File
 */
-(BOOL)isVideoMergeProcessRequired {
    
    
    NSString *lastFolderName = [self getVideoMergeAddress];
    
    //Getting Current Flyer folder Path
    NSString* currentSourcepath  =   [[NSFileManager defaultManager] currentDirectoryPath];
    NSString* historyDestinationpath  =  [NSString stringWithFormat:@"%@/History",currentSourcepath];
    
    //Gettin List From Path
    NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:historyDestinationpath error:nil];
    
    
    //HISTORY CHECK
    if (fileList.count >= 1) {
        
        //HISTORY AVAILABLE
        NSArray *sortedFlyersList = [fileList sortedArrayUsingFunction:compareDesc context:NULL];
        
        // Here we handle Flyer First Time Video Merge
        if ([lastFolderName isEqualToString:@""]) {
            
            [self setVideoMergeAddress:[sortedFlyersList objectAtIndex:0]];
            return YES;
        }
        
        // Here we handle Flyer have any Change then Video Merge
        if ([lastFolderName isEqualToString:[sortedFlyersList objectAtIndex:0]]) {
            return NO;
        }else {
            [self setVideoMergeAddress:[sortedFlyersList objectAtIndex:0]];
        }
        
        
    }
    return YES;
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
            NSString *uniqueId = [Flyer getUniqueId];
            NSString* historyDestinationpath  =   [NSString stringWithFormat:@"%@/History/%@", currentSourcepath,
                                                   uniqueId];
    
            //Create Flyer folder
            [[NSFileManager defaultManager] createDirectoryAtPath:historyDestinationpath withIntermediateDirectories:YES attributes:nil error:&error];
    
            NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:currentSourcepath error:nil];
    
            for(int i = 0 ; i < [fileList count];i++)
            {
                lastFileName = fileList[i];
        
                //if (![lastFileName isEqualToString:@"History"] && ![lastFileName isEqualToString:@"FlyerlyMovie.mov"] )
                if ( ![lastFileName isEqualToString:@"History"] ) {
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
        } else {
            [[NSFileManager defaultManager] removeItemAtPath:gitkeepFilepath error:&error];
        }
        
        //Create History  folder Path
        NSString *uniqueId = [Flyer getUniqueId];
        NSString* historyDestinationpath  =   [NSString stringWithFormat:@"%@/History/%@", currentSourcepath,
                                               uniqueId];
        
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
    NSLog(@"Deleting layer");
    //Delete From Dictionary
    if( uid != nil ){
        [masterLayers removeObjectForKey:uid];
    }
}

/**
 * We update the key for this layer to the new key.
 */
-(void)updateLayerKey:(NSString *)old newKey:(NSString *)key {
    id obj = [masterLayers objectForKey:old];
    
    // Sanity check, make sure the object is not nil.
    if ( obj != nil ) {
        [masterLayers removeObjectForKey:old];
        [masterLayers setObject:obj forKey:key];
    }
}

/*
 *Return textbox text
 */
-(NSString *)getText :(NSString *)uid{

    NSMutableDictionary *layerDic = [self getLayerFromMaster:uid];
    return [layerDic objectForKey:@"text"];
}

/*
 * Here we Set Text Size
 */
-(UIFont *)getTextFont :(NSString *)uid {
    
    NSString* fontName = [[self getLayerFromMaster:uid] objectForKey:@"fontname"];
    float fontSize = [[[self getLayerFromMaster:uid] objectForKey:@"fontsize"] floatValue ];
    UIFont* textFont = [UIFont fontWithName:fontName size:fontSize];
    
    return textFont;
}

-(NSString *)getImageName :(NSString *)uid{
    NSMutableDictionary *layerDic = [self getLayerFromMaster:uid];
    return [layerDic objectForKey:@"image"];

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
    
    // Reutrn sorted (by id/timestamp) array of all keys in the layers dictionary
    return [[masterLayers allKeys] sortedArrayUsingFunction:compareTimestamps context:NULL];
}


/*
 *Here we sort Array in Ascending order for Exact Render of Flyer
 * as last saved.
 */
NSInteger compareTimestamps(id stringLeft, id stringRight, void *context) {
    
    // Convert both strings to integers
    long long intLeft = [stringLeft longLongValue];
    long long intRight = [stringRight longLongValue];
    
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
    long long intLeft = [stringLeft longLongValue];
    long long intRight = [stringRight longLongValue];
    
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
    
    NSString *uniqueId = [Flyer getUniqueId];
    
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

-(void)deleteGiphyWatermarkLayerIfExist{
    //Add giphy water mark only if we haven't giphyWatermark layer
    if( [self getLayerFromMaster:FLYER_LAYER_GIPHY_LOGO] != nil ){
        [self deleteLayer:FLYER_LAYER_GIPHY_LOGO];
    }
}

-(void)addGiphyWatermark{
    
    [self deleteGiphyWatermarkLayerIfExist];
    
    //Create Dictionary for Symbol
    NSMutableDictionary *imageDetailDictionary = [[NSMutableDictionary alloc] init];

    NSString *uniqueId = FLYER_LAYER_GIPHY_LOGO;
    imageDetailDictionary[@"type"] = FLYER_LAYER_GIPHY_LOGO;
    imageDetailDictionary[@"isEditable"] = @"NO";
    imageDetailDictionary[@"image"] = @"Photo/powerdByGiphyLogo.png";
    imageDetailDictionary[@"imageTag"] = @"";
    imageDetailDictionary[@"x"] = @"5";
    imageDetailDictionary[@"y"] = @"10";
    imageDetailDictionary[@"width"] = @"50";
    imageDetailDictionary[@"height"] = @"18";

    if( IS_IPHONE_4 || IS_IPHONE_5 ) {
        [imageDetailDictionary setObject:@"0" forKey:@"tx"];
        [imageDetailDictionary setObject:@"282.5" forKey:@"ty"];
    }
    else if( IS_IPHONE_6 ) {
        [imageDetailDictionary setObject:@"0.0" forKey:@"tx"];
        [imageDetailDictionary setObject:@"337.5" forKey:@"ty"];
    }
    else if( IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS) {
        [imageDetailDictionary setObject:@"0.0" forKey:@"tx"];
        [imageDetailDictionary setObject:@"376.5" forKey:@"ty"];
    }
    imageDetailDictionary[@"a"] = @"1.00";
    imageDetailDictionary[@"b"] = @"0.00";
    imageDetailDictionary[@"c"] = @"0.00";
    imageDetailDictionary[@"d"] = @"1.00";
    
    [masterLayers setValue:imageDetailDictionary forKey:uniqueId];
}

/*
 * When New Drawing layer Add on Flyer
 * its will call and Add one Content in MasterLayers Dictionary
 * return
 *      UniqueID
 */
-(NSString *)addDrawingImage: (BOOL)isMainLayer{
    
    NSString *uniqueId = [Flyer getUniqueId];
    
    //Create Dictionary for Symbol
    NSMutableDictionary *imageDetailDictionary = [[NSMutableDictionary alloc] init];
    
    if( isMainLayer )
    imageDetailDictionary[@"image"] = @"DrawingImgLayer.png";
    else
    imageDetailDictionary[@"image"] = @"";
    
    imageDetailDictionary[@"imageTag"] = @"";
    imageDetailDictionary[@"type"] = FLYER_LAYER_DRAWING;
    imageDetailDictionary[@"x"] = @"0";
    imageDetailDictionary[@"y"] = @"0";
    imageDetailDictionary[@"width"] = @"612"; //DRAWING_LAYER_W
    imageDetailDictionary[@"height"] = @"612"; //DRAWING_LAYER_H


    imageDetailDictionary[@"textcolor"] = LINECOLOR;
    imageDetailDictionary[@"line_type"] = DRAWING_PLANE_LINE; //Line style( 1=plane, 2=doted, 3=dashed )
    imageDetailDictionary[@"brush"] = @"10.0"; //thikness of brush
    imageDetailDictionary[@"opacity"] = @"1.0"; //opacity of line
    
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
-(void)setLayerDicXYInModel :(NSString *)layerId :(CGRect)rect
{
    NSMutableDictionary *imageDetailDictionary = [self getLayerFromMaster:layerId];
    imageDetailDictionary[@"x"] = [NSString stringWithFormat:@"%f",rect.origin.x];
    imageDetailDictionary[@"y"] = [NSString stringWithFormat:@"%f",rect.origin.y];
    [masterLayers setValue:imageDetailDictionary forKey:layerId];
}




-(void)setImageTransform :(NSString *)uid :(CGAffineTransform *) transform {
    
    NSMutableDictionary *imageDetailDictionary = [self getLayerFromMaster:uid];

    imageDetailDictionary[@"a"] = [NSString stringWithFormat:@"%f", transform->a ];
    imageDetailDictionary[@"b"] = [NSString stringWithFormat:@"%f", transform->b ];
    imageDetailDictionary[@"c"] = [NSString stringWithFormat:@"%f", transform->c ];
    imageDetailDictionary[@"d"] = [NSString stringWithFormat:@"%f", transform->d ];
    imageDetailDictionary[@"tx"] = [NSString stringWithFormat:@"%f", transform->tx ];
    imageDetailDictionary[@"ty"] = [NSString stringWithFormat:@"%f", transform->ty ];
    
    [masterLayers setValue:imageDetailDictionary forKey:uid];
}

-(void) addImageRotationAngle :(NSString *)uid :(CGFloat) rotation {
    
    NSMutableDictionary *imageDetailDictionary = [self getLayerFromMaster:uid];
    
    // First get the previous rotation angle
    CGFloat currentAngle = [[imageDetailDictionary valueForKey:@"rotation"] floatValue];
    
    // Now add it to current rotation
    rotation = rotation + currentAngle;
    
    imageDetailDictionary[@"rotation"] = [NSString stringWithFormat:@"%f",rotation];
    
    [masterLayers setValue:imageDetailDictionary forKey:uid];
}

-(CGFloat) getImageRotationAngle : (NSString *)uid {
    
    NSMutableDictionary *detail = [self getLayerFromMaster:uid];
    return ([[detail valueForKey:@"rotation"] floatValue]);

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
    return [imageDetailDictionary valueForKey:@"imageTag"];
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
        NSLog(@"Directory already exists: %@", documentDBFolderPath);
    }
    
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:resourceDBFolderPath error:&error];
    
    for (NSString *s in fileList) {
        
        NSString *newFilePath = [documentDBFolderPath stringByAppendingPathComponent:s];
        NSString *oldFilePath = [resourceDBFolderPath stringByAppendingPathComponent:s];
            
        if (![fileManager fileExistsAtPath:newFilePath]) {
            
            //File does not exist, copy it
            [fileManager copyItemAtPath:oldFilePath toPath:newFilePath error:&error];
            
        } else {
            NSLog(@"File already exists: %@", newFilePath);
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
        
    NSString *uniqueId = [Flyer getUniqueId];
    NSString *flyerPath = [usernamePath stringByAppendingString:[NSString stringWithFormat:@"/%@", uniqueId]];
    
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
	NSString *usernamePath = [homeDirectoryPath stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@/Flyr", [user objectForKey:@"username"]]];
    
    NSArray *flyersList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:usernamePath error:nil];
    
    NSArray *sortedFlyersList = [flyersList sortedArrayUsingFunction:compareDesc context:NULL];
    
    NSString *lastFileName;
    NSMutableArray *recentFlyers = [[NSMutableArray alloc] init];
    
        
    for(int i = 0 ; i < sortedFlyersList.count ;i++)
    {
        lastFileName = sortedFlyersList[i];
            
        //Checking For Integer Dir Names Only
        if ([[NSScanner scannerWithString:lastFileName] scanInt:nil]) {
              
            NSString *recentflyPath = [NSString stringWithFormat:@"%@/%@/flyer.%@",usernamePath,lastFileName,IMAGETYPE];
            [recentFlyers addObject:recentflyPath];
            
            // Only get the number of previews that we need.
            if ( flyCount != 0 && flyCount == i - 1 ) {
                break;
            }

        }

    }
    
    return recentFlyers;
}




/*
 * Here We Change Flyer Directory Name to Current Time Stamp
 */
-(void)setRecentFlyer {
    NSString* currentpath  =   [[NSFileManager defaultManager] currentDirectoryPath];
    
    NSString *uniqueId = [Flyer getUniqueId];
    NSString *replaceDirName = uniqueId;
    
    // Here we Rename the Directory Name
    NSString *newPath = [[currentpath stringByDeletingLastPathComponent] stringByAppendingPathComponent:replaceDirName];
    
    NSError *error = nil;
    [[NSFileManager defaultManager] moveItemAtPath:currentpath toPath:newPath error:&error];
    
    if (error) {
        NSLog( @"Recent flyer error: %@", error.localizedDescription );
    }
    
    // Make sure we update the flyer paths.
    [self setupPaths:newPath];
}


/*** HERE WE CREATE FLYERLY SEPERATE ALBUM
 * FOR FLYER SAVING
 *
 */
-(void)createFlyerlyAlbum {
    
    NSString *albumName;
    
    #if defined(FLYERLY)
        albumName = FLYER_ALBUM_NAME;
    #else
        albumName = FLYERLY_BIZ_ALBUM_NAME;
    #endif
    
    if ( _library == nil ) {
        _library = [[ALAssetsLibrary alloc] init];
    }
    
    __weak ALAssetsLibrary* library = _library;
    
    //HERE WE SEN REQUEST FOR CREATE ALBUM
    [_library addAssetsGroupAlbumWithName:albumName
                             resultBlock:^(ALAssetsGroup *group) {
                                 
                                 //CHECKING ALBUM FOUND IN LIBRARY
                        if (group == nil) {
                                     
                                     //ALBUM NAME ALREADY EXIST IN LIBRARY
                                     [library enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                         
                                        NSString *existAlbumName = [group valueForProperty: ALAssetsGroupPropertyName];
                                         
                                         if ([existAlbumName isEqualToString:albumName]) {
                                             *stop = YES;
                                             
                                             // GETTING CREATED URL OF ALBUM
                                             NSURL *groupURL = [group valueForProperty:ALAssetsGroupPropertyURL];
                                             
                                             //SAVING IN PREFERENCES .PLIST FOR FUTURE USE
                                             [[NSUserDefaults standardUserDefaults]   setObject:groupURL.absoluteString forKey:@"FlyerlyAlbum"];
                                             
                                            
                                         }
                                         
                                     } failureBlock:^(NSError *error) {
                                          NSLog( @"Error adding album: %@", error.localizedDescription );
                                     }];
                                     
                        }else {
                                 
                                     //CREATE NEW ALBUM IN LIBRARY
                                     // GETTING CREATED URL OF ALBUM
                                     NSURL *groupURL = [group valueForProperty:ALAssetsGroupPropertyURL];

                                     //SAVING IN PREFERENCES .PLIST FOR FUTURE USE
                                     [[NSUserDefaults standardUserDefaults]   setObject:groupURL.absoluteString forKey:@"FlyerlyAlbum"];
                        }
                    }
     
                    failureBlock:^(NSError *error) {
                        NSLog( @"Error adding album: %@", error.localizedDescription );
            }];
    
}


/* APPLY OVER LOADING HERE
 * THIS METHOD CREATE ALBUM ON DEVICE AFTER IT SAVING IMAGE IN LIBRARY
 */
-(void)createFlyerlyAlbum :(NSData *)imgdata {
    
    NSString *albumName;
    
    #if defined(FLYERLY)
        albumName = FLYER_ALBUM_NAME;
    #else
        albumName = FLYERLY_BIZ_ALBUM_NAME;
    #endif
    
    if ( _library == nil ) {
        _library = [[ALAssetsLibrary alloc] init];
    }
    __weak Flyer *weakSelf = self;
    
    
    //HERE WE SEN REQUEST FOR CREATE ALBUM
    [_library addAssetsGroupAlbumWithName:albumName
                             resultBlock:^(ALAssetsGroup *group) {
                                 
                                 // GETTING CREATED URL OF ALBUM
                                 NSURL *groupURL = [group valueForProperty:ALAssetsGroupPropertyURL];
                                 
                                 //SAVING IN PREFERENCES .PLIST FOR FUTURE USE
                                 [[NSUserDefaults standardUserDefaults]   setObject:groupURL.absoluteString forKey:@"FlyerlyAlbum"];
                                 
                                 //Checking Content Type
                                 if ([weakSelf isVideoFlyer]) {
                                     
                                     //Create Video
                                     [weakSelf createVideoToFlyerlyAlbum:groupURL VideoData:[NSURL fileURLWithPath:[weakSelf getSharingVideoPath]]];
                                 }else {
                                     
                                     //Create Image
                                     [weakSelf createImageToFlyerlyAlbum:groupURL ImageData:imgdata];
                                 }
                             }
     
                            failureBlock:^(NSError *error) {
                                NSLog( @"Error adding album: %@", error.localizedDescription );
                            }];


}



#pragma TEXT METHODS

/*
 * When New text layer Add on Flyer
 * its will call and Add one Content in MasterLayers Dictionary
 * return
 *      UniqueID
 */
-(NSString *)addText {
    NSString *uniqueId = [Flyer getUniqueId];
    
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
 * When New text layer Add on Flyer
 * its will call and Add one Content in MasterLayers Dictionary
 * return
 *      UniqueID
 */
-(NSString *)addClipArt {
    NSString *uniqueId = [Flyer getUniqueId];
    
    //Add Defaualt dictionary
    NSMutableDictionary *textDetailDictionary = [[NSMutableDictionary alloc] init];
    textDetailDictionary[@"text"] = TEXT;
    textDetailDictionary[@"fontname"] = TEXTFONTNAME;
    textDetailDictionary[@"fontsize"] = CLIPARTFONTSIZE;
    textDetailDictionary[@"textcolor"] = TEXTCOLOR;
    textDetailDictionary[@"textWhitecolor"] = TEXTWHITECOLOR;
    textDetailDictionary[@"textborderWhite"] = TEXTBORDERWHITE;
    textDetailDictionary[@"textbordercolor"] = TEXTBORDERCOLOR;
    textDetailDictionary[@"x"] = CLIPARTxPOS;
    textDetailDictionary[@"y"] = CLIPARTyPOS;
    textDetailDictionary[@"width"] = CLIPARTWIDTH;
    textDetailDictionary[@"height"] = CLIPARTHEIGHT;
    
    
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
    
    NSString *type = [textDetailDictionary objectForKey:@"type"];
    if ( type != nil && [type isEqual:FLYER_LAYER_DRAWING]) {
        [textDetailDictionary setValue:[NSString stringWithFormat:@"%f, %f, %f", red, green, blue] forKey:@"textcolor"];
    } else{
        [textDetailDictionary setValue:[NSString stringWithFormat:@"%f, %f, %f", red, green, blue] forKey:@"textcolor"];
        [textDetailDictionary setValue:[NSString stringWithFormat:@"%f, %f", wht, alpha] forKey:@"textWhitecolor"];
    }
    
    // Set to Master Dictionary
    [masterLayers setValue:textDetailDictionary forKey:uid];
    
}

/*
 * Here we Set Text Sizein dictionary
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

    //When picture flyer border
    if( [rgb isKindOfClass:[NSString class]] ){
        [templateDictionary setValue:rgb forKey:@"bordercolor"];
    }
    //Colored flyer border
    else{
        UILabel *labelToStore = [[UILabel alloc]init];
        labelToStore.textColor = rgb;
        
        //Getting RGB Color Code
        [labelToStore.textColor getRed:&red green:&green blue:&blue alpha:&alpha];
        
        if (red == 0 && green == 0 && blue ==0) {
            [labelToStore.textColor getWhite:&wht alpha:&alpha];
        }
        
        [templateDictionary setValue:[NSString stringWithFormat:@"%f, %f, %f", red, green, blue] forKey:@"bordercolor"];
    }
    
    [templateDictionary setValue:[NSString stringWithFormat:@"%f, %f", wht, alpha] forKey:@"bordercolorWhite"];
    
    // Set to Master Dictionary
    [masterLayers setValue:templateDictionary forKey:uid];
    
}


/*
 * Here we Set Flyer Type to Video Flyer
 */
-(void)setFlyerTypeVideo {
    [self deleteGiphyWatermarkLayerIfExist];
    [self setFlyerTypeVideoWithSize:flyerlyWidth height:flyerlyHeight videoSoure:@"flyerly"];
}
/*
 * Here we Set Flyer Type to Video Flyer with size
  @return: void
  @parms:
   @width: integer value
   @height: integer value
   @videoSoure: String type ( Possible values would be @"giphy" / @"flyerly"
 */
-(void)setFlyerTypeVideoWithSize:(int)width height:(int)height videoSoure:(NSString *)videoSoure {

    NSMutableDictionary *templateDictionary = [self getLayerFromMaster:@"Template"];
    
    [templateDictionary setValue:@"video" forKey:@"FlyerType"];
    [templateDictionary setValue:[NSString stringWithFormat:@"%i",width] forKey:@"videoWidth"];
    [templateDictionary setValue:[NSString stringWithFormat:@"%i",height] forKey:@"videoHeight"];
    [templateDictionary setValue:videoSoure forKey:@"videoSoure"];
    
    
    // Set timeStamp
    [templateDictionary setValue:[Flyer getUniqueId] forKey:@"Timestamp"];

    // Set to Master Dictionary
    [masterLayers setValue:templateDictionary forKey:@"Template"];
    
}

/**
 * Basically this is the supportive function for old video flyers, new flyers have double size(1240x1240)
 */
-(CGSize)getSizeOfFlyer {
    CGSize size = CGSizeMake(OldFlyerlyWidth, OldFlyerlyHeight);
    
    NSMutableDictionary *templateDictionary = [self getLayerFromMaster:@"Template"];
    BOOL flyerTypeIsVide = ([[templateDictionary objectForKey:@"FlyerType"] isEqualToString:@"video"]);
    
    if( flyerTypeIsVide == NO ){
        size = CGSizeMake(flyerlyWidth, flyerlyHeight);
    }
    else if( flyerTypeIsVide && [templateDictionary objectForKey:@"videoWidth"] != nil ){
        int videoWidth = [[templateDictionary objectForKey:@"videoWidth"] intValue];
        int videoHeight = [[templateDictionary objectForKey:@"videoHeight"] intValue];
        size = CGSizeMake(videoWidth, videoHeight);
    }
    
    return size;
}



/*
 * Here we Get Flyer Type for Video Flyer
 */
-(NSString *)getFlyerTypeVideo {
    
    NSMutableDictionary *templateDictionary = [self getLayerFromMaster:@"Template"];
    return [templateDictionary objectForKey:@"FlyerType"];
    
}

/*
 * Here we Set Flyer Type to Image Flyer
 */
-(void)setFlyerTypeImage {
   [self deleteGiphyWatermarkLayerIfExist];
    NSMutableDictionary *templateDictionary = [self getLayerFromMaster:@"Template"];
    
    [templateDictionary setValue:@"image" forKey:@"FlyerType"];
    
    // Set timeStamp
    [templateDictionary setValue:[Flyer getUniqueId] forKey:@"Timestamp"];
    
    // Set to Master Dictionary
    [masterLayers setValue:templateDictionary forKey:@"Template"];
    
    //Checking if Video Exists then Delete it
    NSString* currentpath  =   [[NSFileManager defaultManager] currentDirectoryPath];
    NSString *videoPath = [NSString stringWithFormat:@"%@/Template/template.mov",currentpath];
    NSError *error = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:videoPath isDirectory:NULL]) {
        //Delete File
        [[NSFileManager defaultManager] removeItemAtPath:videoPath error:&error];
    
    }
}


/*
 * Here we Set Flyer Video Path
 */
-(void)setOriginalVideoUrl :(NSString *)url {
    
    NSMutableDictionary *templateDictionary = [self getLayerFromMaster:@"Template"];
    
    [templateDictionary setValue:url forKey:@"VideoURL"];
    
    // Set to Master Dictionary
    [masterLayers setValue:templateDictionary forKey:@"Template"];


}

/*
 * HERE WE RETURN VIDEO FILE PATH
 */
-(NSString *)getOriginalVideoURL {
    NSMutableDictionary *templateDictionary = [self getLayerFromMaster:@"Template"];
    
    NSString* currentPath  =   [[NSFileManager defaultManager] currentDirectoryPath];
    
    NSString *videoPath = [currentPath stringByAppendingString:[NSString stringWithFormat:@"/%@",[templateDictionary valueForKey:@"VideoURL"]] ];
   
    return videoPath;
}


/*
 * Here we Return Sharing Video( merged video ) Path
 */
-(NSString *)getSharingVideoPath{
    NSString* currentpath  =   [[NSFileManager defaultManager] currentDirectoryPath];
    if ([currentpath isEqualToString:@"/"]) {
        currentpath = [NSString stringWithFormat:@"/private%@",curFlyerPath];
    }
    NSString *destination = [NSString stringWithFormat:@"%@/FlyerlyMovie.mov",currentpath];
    return destination;
}

/*
 * Here we Return Over merged Video Snap Shot For Main screen
 */
-(UIImage *)getSharingVideoCover {

    NSString* filePath = [self getSharingVideoPath];//merged video
   return [self getSnapShotOfVideoPath:filePath];
}

/*
 * Here we return orignal video screenshot without merge
 */
-(UIImage *)getVideoWithoutMergeSnapshot {
    
    NSString* filePath = [self getOriginalVideoURL];
    return [self getSnapShotOfVideoPath:filePath];
}

/**
 * Get first frame from the video
 */
-(UIImage *)getSnapShotOfVideoPath:(NSString *) filePath {
    UIImage *img;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:NULL]) {
        
        //Getting One frame from Video For Video Cover on Main Screen
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:filePath] options:nil];
        AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        generator.appliesPreferredTrackTransform = YES;
        
        NSError *err = NULL;
        
        //  Get thumbnail at the very start of the video
        CMTime thumbnailTime = [asset duration];
        thumbnailTime.value = 0;
        
        CGImageRef imgRef = [generator copyCGImageAtTime: thumbnailTime  actualTime:NULL error:&err];
        
        img = [[UIImage alloc] initWithCGImage:imgRef];
        
        CGImageRelease(imgRef);
    } else {
        NSLog( @"Video cover not found" );
    }

    return img;
}

- (UIImage*)mergeImages:(UIImage*)firstImage withImage:(UIImage*)secondImage width:(CGFloat)width height:(CGFloat)height {
    
    
        UIImage *mergedImg = nil;

        CGSize newImageSize = CGSizeMake(width, height);
        if (&UIGraphicsBeginImageContextWithOptions != NULL) {
            UIGraphicsBeginImageContextWithOptions(newImageSize, NO, [[UIScreen mainScreen] scale]);
        } else {
            UIGraphicsBeginImageContext(newImageSize);
        }
        [firstImage drawInRect:CGRectMake(0, 0, width, height)];
        [secondImage drawInRect:CGRectMake(0, 0, width, height)];
    
    
        mergedImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        return mergedImg;
    }
    
/*
 * HERE WE ADD VIDEO ICON WITH VIDEO IMAGE
 */
-(UIImage *)getImageForVideo {
    
    UIImage *bottomImage = [self  getSharingVideoCover];//this is merged video first frame
    
    UIImage *imgPlayIcon = [UIImage imageNamed:@"play_icon"];

    CGSize size = [self getSizeOfFlyer];
    int vWidth = size.width;
    int vHeight = size.height;
    
    // play icon width and height
    CGFloat playIconWidth = floor(vWidth/3.5); //in 620 flyer height of expected height for icon 177
    CGFloat playIconHeight = floor(vWidth/3.5); //in 1240 flyer height of expected height for icon 354
    
    CGSize newSize = CGSizeMake( vWidth, vHeight );
    UIGraphicsBeginImageContext( newSize );
    
    // setting play icon coordinates
    CGFloat x_playIcon = (vWidth/2)-(playIconWidth/2);
    CGFloat y_playIcon = (vHeight/2)-(playIconHeight/2);
    
    // Use existing opacity as is
    [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Apply supplied opacity

    [imgPlayIcon drawInRect:CGRectMake( x_playIcon, y_playIcon , playIconWidth, playIconHeight ) blendMode:kCGBlendModeNormal alpha:1];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}
    
    
/* Checking here Video Flyer or Image Flyer
 *
 */
-(BOOL)isVideoFlyer {
    
    NSMutableDictionary *templateDictionary = [self getLayerFromMaster:@"Template"];
    
    NSString *typ = [templateDictionary valueForKey:@"FlyerType"];
    
    if ([typ isEqualToString:@"video"]) {
        return YES;
    }
    return NO;
}

#pragma mark - Layer Types

/**
 * Set the type of layer.
 *
 * @param uid
 *            ID of the layer.
 * @param type
 *            Type of the layer.
 */
-(void)setLayerType:(NSString *)uid type:(NSString *)type {
    NSMutableDictionary *layerDic = [self getLayerFromMaster:uid];
    [layerDic setValue:type forKey:@"type"];
}

/**
 * Get the type of layer.
 *
 * @param uid
 *            ID of the layer.
 */
-(NSString *)getLayerType:(NSString *)uid {
    NSMutableDictionary *layerDic = [self getLayerFromMaster:uid];
    NSString *type = [layerDic objectForKey:@"type"];
    
    // For legacy flyers, this value will not exist. We set the value
    // according to the data present.
    if ( type == nil ) {
        // If image is not set, then this is a flyer text layer.
        if ( [self getImageName:uid] == nil ) {
            type = FLYER_LAYER_TEXT;
        } else {
            type = FLYER_LAYER_IMAGE;
        }
    }
    
    return type;
}

#pragma mark - Flyer Social File SET

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

-(void)setMessengerStatus :(int)status {
    
    [socialArray replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%d",status]];
    
    //Here we write the Array of Text files .txt
    [socialArray writeToFile:socialFile atomically:YES];
    
}

/*
 * This method sets status of saveButton (used in ShareViewController)
 * @params:
 *      status: int
 * @return:
 *      void
 */
-(void)setSaveButtonStatus :(int)status {
    
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

//Set Youtube Share Info
-(void)setYouTubeStatus :(int)status {
    
    if (socialArray.count > 8) {
        [socialArray replaceObjectAtIndex:8 withObject:[NSString stringWithFormat:@"%d",status]];
    }else {
        [socialArray addObject:@""];
        [self setYouTubeStatus:status];
    }
    //Here we write the Array of Text files .txt
    [socialArray writeToFile:socialFile atomically:YES];
}

#pragma mark  Flyer Social File GET

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
-(NSString *)getMessengerStatus {
    return [socialArray objectAtIndex:3];
    
}

/*
 * This method tells if the flyer saved or not
 * @params:
 *      void
 * @return:
 *      NSString containing status (0 or 1)
 */
-(NSString *)getSaveButtonStatus {
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
 * Here we Return YouTube Share Status of Flyer
 */
-(NSString *)getYouTubeStatus {
    
    if (socialArray.count > 8) {
        return [socialArray objectAtIndex:8];
    }
    return nil;
}

#pragma mark  Flyer Text File GET


/*
 * Here we Return Flyer Title From .txt File
 */
-(NSString *)getFlyerTitle{
    
    return [textFileArray objectAtIndex:0];
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
    
    if (textFileArray.count > 3) {
        return [textFileArray objectAtIndex:3];
    } else {
        [textFileArray addObject:@""];
        [textFileArray writeToFile:textFile atomically:YES];
        return @"";
    }
}

/*
 * HERE WE GET FLYER SHARE TYPE
 */
-(NSString *)getShareType {
    
    if (textFileArray.count > 4) {
        return [textFileArray objectAtIndex:4];
    } else {
        [textFileArray addObject:@"Public"];
        [textFileArray writeToFile:textFile atomically:YES];
        return @"";
    }

}

/*
 * HERE WE GET Updated Date of Flyer For Save screen
 */
-(NSString *)getFlyerUpdateDate {
    
    if (textFileArray.count > 5) {
        return [textFileArray objectAtIndex:5];
    } else {
        [textFileArray addObject:@""];
        [textFileArray writeToFile:textFile atomically:YES];
        return @"";
    }


}

/*
 * HERE WE GET VIDEO URL
 */
-(NSString *)getVideoAssetURL {
    
    if (textFileArray.count > 6) {
        return [textFileArray objectAtIndex:6];
    } else {
        [textFileArray addObject:@""];
        [textFileArray writeToFile:textFile atomically:YES];
        return @"";
    }
    
    
}

/*
 * HERE WE GET YOUTUBE URL
 */
-(NSString *)getYoutubeLink {
    
    if (textFileArray.count > 7) {
        return [textFileArray objectAtIndex:7];
    } else {
        [textFileArray addObject:@""];
        [textFileArray writeToFile:textFile atomically:YES];
        return @"";
    }
    
}

/*
 * HERE WE GET History Folder Name for Video Merge Process
 */
-(NSString *)getVideoMergeAddress {
    
    if (textFileArray.count > 8) {
        return [textFileArray objectAtIndex:8];
    } else {
        [textFileArray addObject:@""];
        [textFileArray writeToFile:textFile atomically:YES];
        return @"";
    }

}

#pragma mark Date Formating Methods

/*
 * Formats Date
 * @params:
 *      dateString: NSString
 * @return:
 *      date: NString
 */


-(NSString *)dateFormatter: (NSString *) dateString{

    NSDateFormatter* dateFormatter, *formatter;
    NSDate *newDate;
    NSString *date;
    // To format date
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    newDate = [dateFormatter dateFromString:dateString];
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    date = [formatter stringFromDate:newDate];
    return date;
}





#pragma mark  Flyer Text File SET


/*
 * Here we Set Flyer Title
 */
-(void)setFlyerTitle :(NSString *)name {
    
    [textFileArray replaceObjectAtIndex:0 withObject:name];
    
    //Here we write the Array of Text files .txt
    [textFileArray writeToFile:textFile atomically:YES];
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

    if (URL != nil) {
        [textFileArray replaceObjectAtIndex:3 withObject:URL];
    
        //Here we write the Array of Text files .txt
        [textFileArray writeToFile:textFile atomically:YES];
    }
    
}

/*
 * HERE WE SAVE FLYER SHARE TYPE
 */
-(void)setShareType :(NSString *)type {
    if (textFileArray.count > 4) {
        [textFileArray replaceObjectAtIndex:4 withObject:type];
    }else {
        [textFileArray addObject:type];
    }
    
    //Here we write the Array of Text files .txt
    [textFileArray writeToFile:textFile atomically:YES];
    
}

/*
 * Here we Set Flyer Date
 */
-(void)setFlyerUpdatedDate :(NSString *)dt {
    
    if (textFileArray.count > 5) {
        [textFileArray replaceObjectAtIndex:5 withObject:dt];
    }else {
        [textFileArray addObject:dt];
    }
    //Here we write the Array of Text files .txt
    [textFileArray writeToFile:textFile atomically:YES];
}


/*
 * Here we Set Flyer Video Asset URL
 */
-(void)setVideoAsssetURL :(NSString *)URL {
    
    if ( URL != nil ) {
        if (textFileArray.count > 6) {
            [textFileArray replaceObjectAtIndex:6 withObject:URL];
        } else {
            [textFileArray addObject:@""];
            [self setVideoAsssetURL:URL];
        }
        
        // Here we write the Array of Text files .txt
        [textFileArray writeToFile:textFile atomically:YES];
    }
}


/*
 * Here we Set Flyer Youtube URL
 */
-(void)setYoutubeLink :(NSString *)URL {
    
    if (URL != nil) {
        if (textFileArray.count > 7) {
            
            [textFileArray replaceObjectAtIndex:7 withObject:URL];
        }else {
            [textFileArray addObject:@""];
            [self setYoutubeLink:URL];
        }
        //Here we write the Array of Text files .txt
        [textFileArray writeToFile:textFile atomically:YES];
    }
}

/*
 * Here we Set Flyer History Folder Name for Video Merge Process
 */
-(void)setVideoMergeAddress :(NSString *)address {
    
    if ( address != nil ) {
        if (textFileArray.count > 8) {
            [textFileArray replaceObjectAtIndex:8 withObject:[NSString stringWithString:address]];
        } else {
            [textFileArray addObject:@""];
            [self setVideoMergeAddress:address];
        }
        
        // Here we write the Array of Text files .txt
        [textFileArray writeToFile:textFile atomically:YES];
    }
}

/**
 * UIColor isEqual:color doesn't work in all cases. The float values need to be dealt with differently for
 * different color models. See: http://stackoverflow.com/questions/970475/how-to-compare-uicolors
 * Hence this function
 */
+(BOOL) compareColor:(UIColor*)color1 withColor:(UIColor*)color2 {
    
    BOOL equal = YES;
    
    CGFloat red1, green1, blue1, alpha1;
    CGFloat red2, green2, blue2, alpha2;
    
    [color1 getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    [color2 getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
    
    // Multiply all components by 255, then ceil them to convert them to integers
    red1 = round(red1 * 255.0);
    green1 = round(green1 * 255.0);
    blue1 = round(blue1 * 255.0);
    
    red2 = round(red2 * 255.0);
    green2 = round(green2 * 255.0);
    blue2 = round(blue2 * 255.0);
    
    if ( red1 != red2 ) {
        equal = NO;
    } else if ( green1 != green2 ) {
        equal = NO;
    } else if ( blue1 != blue2 ) {
        equal = NO;
    }
    
    return equal;
}

/**
 * getUniqueId
 *
 * This method ensures a unique ID is assigned to each element.
 */
+ (NSString *)getUniqueId {
    static int randomNumber = 0;
    
    // Create Unique ID even within a second
    int timestamp = [[NSDate date] timeIntervalSince1970];
    randomNumber = (randomNumber + 1) % 100;
    
    NSString *uniqueId = [NSString stringWithFormat:@"%u%02u", timestamp, randomNumber];
    return uniqueId;
}

-(CGFloat)getTvDefPosX { return [TEXTxPOS floatValue]; }
-(CGFloat)getTvDefPosY { return [TEXTyPOS floatValue]; }


/*
 * When video is edited
 * set as unselected
 */
-(void)resetAllButtonStatus{
    
    [self setFacebookStatus:0];
    [self setYouTubeStatus:0];
    [self setMessengerStatus:0];
    [self setEmailStatus:0];
    [self setSmsStatus:0];
    [self setTwitterStatus:0];
    [self setClipboardStatus:0];
}

@end

	
