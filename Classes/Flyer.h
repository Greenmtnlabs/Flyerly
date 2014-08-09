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

-(void)saveInGallery :(NSData *)imgData;

-(void)addToHistory;
-(void)addToGallery :(NSData *)snapShotData;

-(void)replaceFromHistory;

-(void)createFlyerlyAlbum;

-(void)createImageToFlyerlyAlbum :(NSURL *)groupURL ImageData :(NSData *)imgData;

-(BOOL)compareFilesForMakeHistory :(NSString *)curPath LastHistoryPath:(NSString *)hisPath;

-(void)deleteLayer :(NSString *)uid;
-(void)updateLayerKey:(NSString *)old newKey:(NSString *)key;

-(NSArray *)allKeys;

-(NSString *)addText;
-(NSString *)addImage;
-(NSString *)addClipArt;

-(void)setVideoCover :(UIImage *)snapShot;

-(void)setImageFrame :(NSString *)uid :(CGRect )photoFrame;

-(void)setImageRotationAngle:(NSString *)uid :(CGFloat )rotationAngle;

-(void)setImageTag :(NSString *)uid Tag :(NSString *)tag;

-(void)setFlyerText :(NSString *)uid text:(NSString *)txt;

-(void)setFlyerTextFont :(NSString *)uid FontName:(NSString *)ftn;

-(void)setFlyerTextColor :(NSString *)uid RGBColor:(id)rgb;

-(void)setFlyerTextSize :(NSString *)uid Size:(UIFont *)sz;

-(void)setFlyerTextBorderColor :(NSString *)uid Color:(id)rgb;

-(void)setImagePath :(NSString *)uid ImgPath:(NSString *)imgPath;

-(void)setFlyerBorder :(NSString *)uid RGBColor:(id)rgb;

-(void)setFlyerTypeVideo;
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
-(void)setFlickerStatus :(int)status;
-(void)setThumblerStatus :(int)status;
-(void)setEmailStatus :(int)status;
-(void)setSmsStatus :(int)status;
-(void)setClipboardStatus :(int)status;
-(void)setYouTubeStatus :(int)status;

-(NSMutableDictionary *)getLayerFromMaster :(NSString *)uid;
-(NSString *)getImageTag :(NSString *)uid;
-(NSString *)getYouTubeStatus;
-(NSString *)getFacebookStatus;
-(NSString *)getTwitterStatus;
-(NSString *)getInstagaramStatus;
-(NSString *)getFlickerStatus;
-(NSString *)getThumblerStatus;
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

-(NSString *)getShareType;
-(NSString *)getFlyerUpdateDate;
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
-(BOOL)isVideoMergeProcessRequired;
+(NSString *)getUniqueId;

+(NSString *)newFlyerPath;
+(NSMutableArray *)recentFlyerPreview:(NSInteger)flyCount;
+(BOOL) compareColor:(UIColor*)color1 withColor:(UIColor*)color2;


@property (strong, readonly) NSMutableDictionary *masterLayers;
@property (strong, nonatomic) NSMutableArray *socialArray;
@property (strong, nonatomic) NSMutableArray *textFileArray;
@property (strong, nonatomic) ALAssetsLibrary *library;

@end
