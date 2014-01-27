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


-(id)initWithPath;
-(void)loadFlyer :(NSString *)uid;

-(void)saveFlyer :(NSString *)uid;


-(NSString *)addText;
-(NSString *)addPhoto;
-(NSString *)addSymbols;
-(NSString *)addClipArt;


@property(strong,readonly)NSDictionary *MasterLayers;

@property(strong,nonatomic)NSString *CurrentLayer;

@end
