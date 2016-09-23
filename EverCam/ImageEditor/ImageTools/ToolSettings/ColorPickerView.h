/*============================
 
 EverCam
 
 iOS 7/8 iPhone Photo Editor App template
 created by FV iMAGINATION - 2014
 http://www.fvimagination.com
 
 ==============================*/



#import <UIKit/UIKit.h>

@protocol ColorPickerViewDelegate;

@interface ColorPickerView : UIView

@property (nonatomic, weak) id<ColorPickerViewDelegate> delegate;
@property (nonatomic, strong) UIColor *color;

@end




@protocol ColorPickerViewDelegate <NSObject>
@optional
- (void)colorPickerView:(ColorPickerView*)picker colorDidChange:(UIColor*)color;

@end