

#import <UIKit/UIKit.h>

@interface TextViewEdit : UITextField
<
UITextFieldDelegate,
UITextViewDelegate
>


@property (nonatomic, strong) UIColor *outlineColor;
@property (nonatomic, assign) CGFloat outlineWidth;

@end
