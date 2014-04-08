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
#import "FlyerImageView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Flurry.h"
#import "Common.h"


@interface Flyer : NSObject{
    
    NSString *piecesFile;
    NSString *textFile;
    NSString *socialFile;
    NSString *flyerImageFile;
    NSString *videoImageFile;


}


-(id)initWithPath:(NSString *)flyPath;

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

-(NSArray *)allKeys;

-(NSString *)addText;
-(NSString *)addImage;

-(void)setVideoCover :(UIImage *)snapShot;
-(UIImage *)getFlyerOverlayImage;

-(void)setImageFrame :(NSString *)uid :(CGRect )photoFrame;

-(void)setImageTag :(NSString *)uid Tag :(NSString *)tag;

-(void)setFlyerText :(NSString *)uid text:(NSString *)txt;

-(void)setFlyerTextFont :(NSString *)uid FontName:(NSString *)ftn;

-(void)setFlyerTextColor :(NSString *)uid RGBColor:(id)rgb;

-(void)setFlyerTextSize :(NSString *)uid Size:(UIFont *)sz;

-(void)setFlyerTextBorderColor :(NSString *)uid Color:(id)rgb;

-(void)setImagePath :(NSString *)uid ImgPath:(NSString *)imgPath;

-(void)setFlyerBorder :(NSString *)uid RGBColor:(id)rgb;
-(void)setFlyerTypeVideo;
-(void)setFlyerTypeImage;

-(void)setOriginalVideoUrl :(NSString *)url;

-(BOOL)isVideoFlyer;

-(void)setFlyerTitle :(NSString *)name;

-(void)setFlyerDescription :(NSString *)desp;

-(void)setFlyerURL :(NSString *)URL;
-(void)setVideoAsssetURL :(NSString *)URL;
-(void)setYoutubeLink :(NSString *)URL;

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
-(UIImage *)getImageForVideo;



-(NSString *)getText :(NSString *)uid;
-(NSString *)getImageName :(NSString *)uid;
-(CGRect)getImageFrame :(NSString *)uid;
-(float)getWidth :(NSString *)uid;
-(float)getHight :(NSString *)uid;
-(NSString *)getFlyerImage;


+(NSString *)newFlyerPath;
+ (NSMutableArray *)recentFlyerPreview:(NSInteger)flyCount;

@property (strong, readonly) NSMutableDictionary *masterLayers;
@property (strong, nonatomic) NSMutableArray *socialArray;
@property (strong, nonatomic) NSMutableArray *textFileArray;

@end
