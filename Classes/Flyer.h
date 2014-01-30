//
//  FlyerClass.h
//  Flyr
//
//  Created by Khurram on 27/01/2014.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "CustomLabel.h"


@interface Flyer : NSObject


-(id)initWithPath:(NSString *)flyPath;
-(void)loadFlyer :(NSString *)flyPath;

-(void)saveFlyer :(NSString *)uid;



-(NSMutableDictionary *)getLayerFromMaster :(NSString *)uid;

-(NSString *)addText;
-(void)setFlyerText :(NSString *)txt Uid:(NSString *)uid;

-(NSString *)addPhoto;
-(NSString *)addSymbols;
-(NSString *)addClipArt;

+(NSString *)newFlyerPath;

@property(strong,readonly)NSMutableDictionary *MasterLayers;



@end
