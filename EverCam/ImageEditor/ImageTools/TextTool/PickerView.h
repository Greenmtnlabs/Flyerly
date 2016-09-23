

#import <UIKit/UIKit.h>

@protocol PickerViewDataSource;
@protocol PickerViewDelegate;


@interface PickerView : UIView

@property (nonatomic, weak) id<PickerViewDataSource> dataSource;
@property (nonatomic, weak) id<PickerViewDelegate> delegate;
@property (nonatomic, strong) UIColor *foregroundColor;

- (void)reloadComponent:(NSInteger)component;
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;
- (NSInteger)selectedRowInComponent:(NSInteger)component;

@end




@protocol PickerViewDataSource <NSObject>
@required
- (NSInteger)numberOfComponentsInPickerView:(PickerView *)pickerView;
- (NSInteger)pickerView:(PickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

@end


@protocol PickerViewDelegate <NSObject>
@optional
- (CGFloat)pickerView:(PickerView *)pickerView widthForComponent:(NSInteger)component;
- (NSString *)pickerView:(PickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (UIView *)pickerView:(PickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;
- (CGFloat)pickerView:(PickerView *)pickerView rowHeightForComponent:(NSInteger)component;

- (void)pickerView:(PickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end
