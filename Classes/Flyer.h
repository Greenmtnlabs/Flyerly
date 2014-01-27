//
//  FlyerClass.h
//  Flyr
//
//  Created by Khurram on 27/01/2014.
//
//

#import <Foundation/Foundation.h>

@interface Flyer : NSObject


-(void)initWithPath;
-(void)loadFlyer :(NSString *)uid;

-(void)saveFlyer :(NSString *)uid;


-(NSString *)addText;
-(NSString *)addPhoto;
-(NSString *)addSymbols;
-(NSString *)addClipArt;


@property(strong,readonly)NSDictionary *MasterLayers;

@property(strong,nonatomic)NSString *CurrentLayer;

@end
