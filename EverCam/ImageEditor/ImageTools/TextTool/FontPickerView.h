


#import <UIKit/UIKit.h>

NSArray *_fontList;


@protocol FontPickerViewDelegate;

@interface FontPickerView : UIView


@property (nonatomic, weak) id<FontPickerViewDelegate> delegate;
@property (nonatomic, strong) NSArray *fontSizes;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) BOOL sizeComponentHidden;
@property (nonatomic, strong) UIColor *foregroundColor;
@property (nonatomic, strong) UIColor *textColor;

@end


@protocol FontPickerViewDelegate <NSObject>
@optional
- (void)fontPickerView:(FontPickerView *)pickerView didSelectFont:(UIFont*)font;
- (void)tableView:(UITableView *)tableView didSelectRow:(NSIndexPath *)indexPath inComponent:(NSInteger)component;
@end