//
//  FlyerImageView.h
//  Flyr
//
//  Created by Khurram on 27/01/2014.
//
//

#import <Foundation/Foundation.h>
#import "CustomLabel.h"
#import "Common.h"

@class Flyer;

@protocol FlyerImageViewDelegate <NSObject>

- (void)layerTransformedforKey:(NSString *)uid :(CGAffineTransform *) transform;
- (void)layerResizedForKey:(NSString *)uid : (CGFloat) scale;
- (void)frameChangedForLayer:(NSString *)uid frame:(CGRect)frame;
- (void)rotationAngleChangedForLayer:(NSString *)uid rotationAngle:(CGFloat)rotationAngle;
- (void)previuosrotationAngle:(NSString *)uid;
- (void)bringLayerToFront:(NSString *)oldUid new:(NSString *)uid;
- (void)sendLayerToEditMode:(NSString *)uid;
- (void)toggleImageViewInteraction;
- (void)addVideo :(NSString *)url;



@end

@interface FlyerImageView : UIImageView <UIGestureRecognizerDelegate> {
    
    CGFloat _firstX;
	CGFloat _firstY;
    CGFloat _lastScale;
    
    CAShapeLayer *_marque;    
    
}


//---------
-(void)configureLabelSize :(NSString *)uid labelDictionary:(NSMutableDictionary *)detail;
-(void)configureLabelFont :(NSString *)uid labelDictionary:(NSMutableDictionary *)detail;
-(void)configureLabelColor :(NSString *)uid labelDictionary:(NSMutableDictionary *)detail;
-(void)configureLabelBorder :(NSString *)uid labelDictionary:(NSMutableDictionary *)detail;
-(void)configureImageViewSize :(NSString *)uid;

-(void)configureClipartFont :(NSString *)uid labelDictionary:(NSMutableDictionary *)detail;
-(void)configureClipartDimensions :(NSString *)uid labelDictionary:(NSMutableDictionary *)detail;
//---------

-(void)renderLayer :(NSString *)uid layerDictionary:(NSMutableDictionary *)layDic;
-(void)deleteLayer :(NSString *)uid;
-(void)setTemplate :(NSString *)imgPath;
-(void)setTemplateBorder :(NSMutableDictionary *)layDic;
-(void)layerIsBeingEdited:(NSString *)uid;
-(void)layerStoppedEditing:(NSString *)uid;
-(void)removeAllLayers;


//-----
@property (nonatomic, assign) BOOL heightIsSelected;
@property (nonatomic, assign) BOOL widthIsSelected;
//-----
@property (strong, readonly) NSMutableDictionary *layers;
@property (strong, nonatomic)UITapGestureRecognizer *flyerTapGesture;
@property BOOL *addUiImgForDrawingLayer;
@property BOOL *zoomedIn;

@property (weak, nonatomic) id<FlyerImageViewDelegate> IBOutlet delegate;

@end
