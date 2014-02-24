//
//  FlyerClass.h
//  Flyr
//
//  Created by Khurram on 27/01/2014.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "FlyerImageView.h"

#define IMAGETYPE @"flyer.jpg"

@interface Flyer : NSObject{
    
    NSString *piecesFile;
    NSString *textFile;
    NSString *socialFile;

    NSString *flyerImageFile;

}


-(id)initWithPath:(NSString *)flyPath;

-(void)loadFlyer :(NSString *)flyPath;

-(void)saveFlyer :(UIImage *)snapShot;

-(void)addToHistory;

-(void)replaceFromHistory;

-(BOOL)compareFilesForMakeHistory :(NSString *)curPath LastHistoryPath:(NSString *)hisPath;

-(void)deleteLayer :(NSString *)uid;

-(NSArray *)allKeys;

-(NSString *)addText;
-(NSString *)addImage;

-(void)setImageFrame :(NSString *)uid :(CGRect )photoFrame;

-(void)setImageTag :(NSString *)uid Tag :(NSString *)tag;

-(void)setFlyerText :(NSString *)uid text:(NSString *)txt;

-(void)setFlyerTextFont :(NSString *)uid FontName:(NSString *)ftn;

-(void)setFlyerTextColor :(NSString *)uid RGBColor:(id)rgb;

-(void)setFlyerTextSize :(NSString *)uid Size:(UIFont *)sz;

-(void)setFlyerTextBorderColor :(NSString *)uid Color:(id)rgb;

-(void)setImagePath :(NSString *)uid ImgPath:(NSString *)imgPath;

-(void)setFlyerBorder :(NSString *)uid RGBColor:(id)rgb;

-(void)setFlyerTitle :(NSString *)name;

-(void)setFlyerDescription :(NSString *)desp;

-(void)setRecentFlyer;

-(void)setFacebookStatus :(int)status;
-(void)setTwitterStatus :(int)status;
-(void)setInstagaramStatus :(int)status;
-(void)setFlickerStatus :(int)status;
-(void)setThumblerStatus :(int)status;
-(void)setEmailStatus :(int)status;
-(void)setSmsStatus :(int)status;
-(void)setClipboardStatus :(int)status;

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
-(NSString *)getFlyerDescription;
-(NSString *)getFlyerDate;
-(NSString *)getFlyerTitle;
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
