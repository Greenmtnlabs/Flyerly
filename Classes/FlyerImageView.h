//
//  FlyerImageView.h
//  Flyr
//
//  Created by Khurram on 27/01/2014.
//
//

#import <Foundation/Foundation.h>

@interface FlyerImageView : UIImageView


-(void)renderLayer :(NSString *)uid LayerDictionary:(NSMutableDictionary *)layDic;

@property(strong,nonatomic) NSMutableDictionary *layers;
@end
