//
//  FlyerClass.h
//  Flyr
//
//  Created by Khurram on 27/01/2014.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <Parse/Parse.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "Flurry.h"
#import "Common.h"

@interface Flyer : NSObject{
    
    NSString *curFlyerPath; // This variable is used to store path of video. Because from home screen, sometimes app fails to get path   
    NSString *piecesFile;
    NSString *textFile;
    NSString *socialFile;
    NSString *flyerImageFile;
    BOOL     *_setDirectory;
}


-(id)initWithPath:(NSString *)flyPath setDirectory:(BOOL)setDirectory;

-(void)loadFlyer :(NSString *)flyPath;

-(void)saveFlyer;

-(void)setUpdatedSnapshotWithImage :(UIImage *)snapShot;

-(void)saveIntoGallery;

-(void)addToHistory;

-(void)replaceFromHistory;

-(void)createFlyerlyAlbum;

-(void)createImageToFlyerlyAlbum :(NSURL *)groupURL ImageData :(NSData *)imgData;

-(BOOL)compareFilesForMakeHistory :(NSString *)curPath LastHistoryPath:(NSString *)hisPath;

-(void)deleteLayer :(NSString *)uid;
-(void)updateLayerKey:(NSString *)old newKey:(NSString *)key;

-(NSArray *)allKeys;

-(NSString *)addText;
-(NSString *)addImage;
-(void)addGiphyWatermark;
-(NSString *)addDrawingImage:(BOOL) isMainLayer;
-(NSString *)addClipArt;

-(void)setVideoCover :(UIImage *)snapShot;

-(void)setImageFrame :(NSString *)uid :(CGRect )photoFrame;

-(void)setLayerDicXYInModel :(NSString *)layerId :(CGRect)rect;

-(void)setImageTransform :(NSString *)uid :(CGAffineTransform *) transform;

-(void)addImageRotationAngle:(NSString *)uid :(CGFloat )rotationAngle;

-(void)setImageTag :(NSString *)uid Tag :(NSString *)tag;

-(void)setFlyerText :(NSString *)uid text:(NSString *)txt;

-(void)setFlyerTextFont :(NSString *)uid FontName:(NSString *)ftn;

-(void)setFlyerTextColor :(NSString *)uid RGBColor:(id)rgb;

-(void)setFlyerTextSize :(NSString *)uid Size:(UIFont *)sz;

-(void)setFlyerTextBorderColor :(NSString *)uid Color:(id)rgb;

-(void)setImagePath :(NSString *)uid ImgPath:(NSString *)imgPath;

-(void)setFlyerBorder :(NSString *)uid RGBColor:(id)rgb;

-(void)setFlyerTypeVideo;
-(void)setFlyerTypeVideoWithSize:(int)width height:(int)height videoSoure:(NSString *)videoSoure;
-(NSString *)getFlyerTypeVideo;
-(void)setFlyerTypeImage;

-(void)setOriginalVideoUrl :(NSString *)url;

-(BOOL)isVideoFlyer;

-(void)setFlyerTitle :(NSString *)name;

-(void)setFlyerDescription :(NSString *)desp;

-(void)setFlyerURL :(NSString *)URL;
-(void)setVideoAsssetURL :(NSString *)URL;
-(void)setYoutubeLink :(NSString *)URL;
-(void)setVideoMergeAddress :(NSString *)address;


-(void)setShareType :(NSString *)type;


-(void)setRecentFlyer;

-(void)setFacebookStatus :(int)status;
-(void)setTwitterStatus :(int)status;
-(void)setInstagaramStatus :(int)status;

// Sets status of saveButton
-(void)setSaveButtonStatus :(int)status;
-(void)setMessengerStatus :(int)status;
-(void)setEmailStatus :(int)status;
-(void)setSmsStatus :(int)status;
-(void)setClipboardStatus :(int)status;
-(void)setYouTubeStatus :(int)status;

-(NSMutableDictionary *)getLayerFromMaster :(NSString *)uid;
-(NSString *)getImageTag :(NSString *)uid;
-(CGFloat)getImageRotationAngle:(NSString *)uid;
-(NSString *)getYouTubeStatus;
-(NSString *)getFacebookStatus;
-(NSString *)getTwitterStatus;
-(NSString *)getInstagaramStatus;

// Method to return saveButton Status
-(NSString *)getSaveButtonStatus;
-(NSString *)getMessengerStatus;
-(NSString *)getEmailStatus;
-(NSString *)getSmsStatus;
-(NSString *)getClipboardStatus;
-(NSString *)getFlyerTitle;
-(NSString *)getFlyerDescription;
-(NSString *)getFlyerDate;
-(NSString *)getFlyerURL;
-(NSString *)getOriginalVideoURL;
-(NSString *)getSharingVideoPath;
-(UIImage *)getSharingVideoCover;

-(UIImage *)getVideoWithoutMergeSnapshot;
- (UIImage*)mergeImages:(UIImage*)firstImage withImage:(UIImage*)secondImage width:(CGFloat)width height:(CGFloat)height;



-(NSString *)getShareType;
-(NSString *)getFlyerUpdateDate;
-(NSString *)getFlyerUpdateDateInAgoFormat;
-(NSString *)getVideoAssetURL;
-(NSString *)getYoutubeLink;
-(NSString *)getVideoMergeAddress;

-(UIImage *)getImageForVideo;

-(void)setLayerType:(NSString *)uid type:(NSString *)type;
-(NSString *)getLayerType:(NSString *)uid;
-(UIFont *)getTextFont :(NSString *)uid;


-(NSString *)getText :(NSString *)uid;
-(NSString *)getImageName :(NSString *)uid;
-(CGRect)getImageFrame :(NSString *)uid;
-(float)getWidth :(NSString *)uid;
-(float)getHight :(NSString *)uid;
-(NSString *)getFlyerImage;
-(BOOL)isSaveRequired;
-(BOOL)isVideoMergeProcessRequired;
+(NSString *)getUniqueId;

+(NSString *)newFlyerPath;
+(NSMutableArray *)recentFlyerPreview:(NSInteger)flyCount;
+(BOOL) compareColor:(UIColor*)color1 withColor:(UIColor*)color2;

-(CGFloat)getTvDefPosX;
-(CGFloat)getTvDefPosY;
-(CGSize)getSizeOfFlyer;
-(BOOL)saveAfterCheck;

@property (strong, readonly) NSMutableDictionary *masterLayers;
@property (strong, nonatomic) NSMutableArray *socialArray;
@property (strong, nonatomic) NSMutableArray *textFileArray;
@property (strong, nonatomic) ALAssetsLibrary *library;

//On back save in gallary, after number of tasks
@property (assign) int saveInGallaryAfterNumberOfTasks;

//Tap on share button, merge video, dont save in gallary because it prompts delete dialoag
//so this flag will help when sharing pannel gone hide, we check if its ture we call the saveInGallary at that time
@property (assign) int saveInGallaryRequired; //0 not required, 1 required, -1 video mergin is in progress
-(BOOL)canSaveInGallary;
-(void)showAllowSaveInGallerySettingAlert;

-(void)resetAllButtonStatus;

-(NSString *)dateFormatter: (NSString *) dateString;
@end
