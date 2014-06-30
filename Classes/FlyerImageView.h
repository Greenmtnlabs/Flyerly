//
//  FlyerImageView.h
//  Flyr
//
//  Created by Khurram on 27/01/2014.
//
//

#import <Foundation/Foundation.h>
#import "CustomLabel.h"

@class Flyer;

@protocol FlyerImageViewDelegate <NSObject>

- (void)frameChangedForLayer:(NSString *)uid frame:(CGRect)frame;
- (void)bringLayerToFront:(NSString *)oldUid new:(NSString *)uid;
- (void)sendLayerToEditMode:(NSString *)uid;
- (void)toggleImageViewInteraction;
- (void)addVideo :(NSString *)url;



@end

@interface FlyerImageView : UIImageView <UIGestureRecognizerDelegate>


-(void)renderLayer :(NSString *)uid layerDictionary:(NSMutableDictionary *)layDic;
-(void)deleteLayer :(NSString *)uid;
-(void)setTemplate :(NSString *)imgPath;
-(void)setTemplateBorder :(NSMutableDictionary *)layDic;
-(void)layerIsBeingEdited:(NSString *)uid;
-(void)layerStoppedEditing:(NSString *)uid;
-(void)removeAllLayers;

@property (strong, readonly) NSMutableDictionary *layers;
@property (strong, nonatomic)UITapGestureRecognizer *flyerTapGesture;
@property (nonatomic,strong) Flyer *flyer;

@property (weak, nonatomic) id<FlyerImageViewDelegate> IBOutlet delegate;

@end
