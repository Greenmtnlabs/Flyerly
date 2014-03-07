//
//  FlyerImageView.h
//  Flyr
//
//  Created by Khurram on 27/01/2014.
//
//

#import <Foundation/Foundation.h>
#import "CustomLabel.h"

@protocol FlyerImageViewDelegate <NSObject>

- (void)frameChangedForLayer:(NSString *)uid frame:(CGRect)frame;
- (void)sendLayerToEditMode:(NSString *)uid;

@end

@interface FlyerImageView : UIImageView{

   
}


-(void)renderLayer :(NSString *)uid layerDictionary:(NSMutableDictionary *)layDic;
-(void)deleteLayer :(NSString *)uid;
-(void)setTemplate :(NSString *)imgPath;
-(void)setTemplateBorder :(NSMutableDictionary *)layDic;
-(void)layerIsBeingEdited:(NSString *)uid;
-(void)layerStoppedEditing:(NSString *)uid;

@property (strong, readonly) NSMutableDictionary *layers;
@property (weak, nonatomic) id<FlyerImageViewDelegate> IBOutlet delegate;

@end
