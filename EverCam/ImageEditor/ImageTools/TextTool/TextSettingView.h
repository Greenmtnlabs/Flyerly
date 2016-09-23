

#import <UIKit/UIKit.h>

@protocol TextSettingViewDelegate;

@interface TextSettingView : UIView

@property (nonatomic, weak) id<TextSettingViewDelegate> delegate;
@property (nonatomic, strong) NSString *selectedText;
@property (nonatomic, strong) UIColor *selectedFillColor;
@property (nonatomic, strong) UIColor *selectedBorderColor;
@property (nonatomic, assign) CGFloat selectedBorderWidth;
@property (nonatomic, strong) UIFont *selectedFont;


- (void)setTextColor:(UIColor*)textColor;
- (void)setFontPickerForegroundColor:(UIColor*)foregroundColor;

- (void)showSettingMenuWithIndex:(NSInteger)index animated:(BOOL)animated;

@end



@protocol TextSettingViewDelegate <NSObject>
@optional
- (void)textSettingView:(TextSettingView*)settingView didChangeText:(NSString*)text;
- (void)textSettingView:(TextSettingView*)settingView didChangeFillColor:(UIColor*)fillColor;
- (void)textSettingView:(TextSettingView*)settingView didChangeBorderColor:(UIColor*)borderColor;
- (void)textSettingView:(TextSettingView*)settingView didChangeBorderWidth:(CGFloat)borderWidth;
- (void)textSettingView:(TextSettingView*)settingView didChangeFont:(UIFont*)font;

@end