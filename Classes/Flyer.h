//
//  FlyerClass.h
//  Flyr
//
//  Created by Khurram on 27/01/2014.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Flyer : NSObject


-(id)initWithPath:(NSString *)flyPath;
-(void)loadFlyer :(NSString *)flyPath;

-(void)saveFlyer :(NSString *)uid;


-(NSString *)addText;
-(NSString *)addPhoto;
-(NSString *)addSymbols;
-(NSString *)addClipArt;

+(NSString *)newFlyerPath;

@property(strong,readonly)NSDictionary *MasterLayers;

@property(strong,nonatomic)NSString *CurrentLayer;

@end
