/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/


#import <Foundation/Foundation.h>

#import "ImageToolSettings.h"


static const CGFloat kEffectToolAnimationDuration = 0.2;


@protocol EffectDelegate;

@interface EffectBase : NSObject<ImageToolProtocol>

@property (nonatomic, weak) id<EffectDelegate> delegate;
@property (nonatomic, weak) ImageToolInfo *toolInfo;


- (id)initWithSuperView:(UIView*)superview imageViewFrame:(CGRect)frame toolInfo:(ImageToolInfo*)info;
- (void)cleanup;

- (BOOL)needsThumnailPreview;
- (UIImage*)applyEffect:(UIImage*)image;

@end



@protocol EffectDelegate <NSObject>
@required
- (void)effectParameterDidChange:(EffectBase*)effect;
@end
