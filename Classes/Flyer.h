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


@interface Flyer : NSObject


-(id)initWithPath:(NSString *)flyPath;
-(void)loadFlyer :(NSString *)flyPath;

-(void)saveFlyer :(NSString *)uid;



-(NSMutableDictionary *)getLayerFromMaster :(NSString *)uid;

-(NSString *)addText;

-(void)setFlyerText :(NSString *)uid text:(NSString *)txt;

-(void)setFlyerTextFont :(NSString *)uid FontName:(NSString *)ftn;

-(void)setFlyerTextColor :(NSString *)uid RGBColor:(id)rgb;

-(void)setFlyerTextSize :(NSString *)uid Size:(UIFont *)sz;

-(void)setFlyerTextBorderColor :(NSString *)uid Color:(id)rgb;



-(NSString *)addPhoto;
-(NSString *)addSymbols;
-(NSString *)addClipArt;

+(NSString *)newFlyerPath;

@property (strong, readonly) NSMutableDictionary *masterLayers;


@property (retain, nonatomic) FlyerImageView *flyImageView;

@end
