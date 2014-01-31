//
//  FlyerImageView.h
//  Flyr
//
//  Created by Khurram on 27/01/2014.
//
//

#import <Foundation/Foundation.h>
#import "CustomLabel.h"

@interface FlyerImageView : UIImageView


-(void)renderLayer :(NSString *)uid layerDictionary:(NSMutableDictionary *)layDic;

-(void)deleteLayer :(NSString *)uid;

@property(strong,nonatomic) NSMutableDictionary *layers;



@end
