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

@interface Flyer : NSObject{
    
    NSString *piecesFile;
    NSString *flyerImageFile;

}


-(id)initWithPath:(NSString *)flyPath;
-(void)loadFlyer :(NSString *)flyPath;

-(void)saveFlyer :(UIImage *)snapShot;

-(void)deleteLayer :(NSString *)uid;

-(NSArray *)allKeys;

-(NSString *)getText :(NSString *)uid;

-(NSString *)getImageName :(NSString *)uid;


-(NSMutableDictionary *)getLayerFromMaster :(NSString *)uid;

-(NSString *)addText;

-(void)setImageFrame :(NSString *)uid :(CGRect )photoFrame;


-(void)setFlyerText :(NSString *)uid text:(NSString *)txt;

-(void)setFlyerTextFont :(NSString *)uid FontName:(NSString *)ftn;

-(void)setFlyerTextColor :(NSString *)uid RGBColor:(id)rgb;

-(void)setFlyerTextSize :(NSString *)uid Size:(UIFont *)sz;

-(void)setFlyerTextBorderColor :(NSString *)uid Color:(id)rgb;

-(void)setSymbolImage :(NSString *)uid ImgPath:(NSString *)imgPath;

-(void)setFlyerBorder :(NSString *)uid RGBColor:(id)rgb;

-(NSString *)addPhoto;
-(NSString *)addSymbols;
-(NSString *)addClipArt;



+(NSString *)newFlyerPath;
+ (NSMutableArray *)recentFlyerPreview:(NSInteger)flyCount;

-(void)setRecentFlyer;

@property (strong, readonly) NSMutableDictionary *masterLayers;

@end
