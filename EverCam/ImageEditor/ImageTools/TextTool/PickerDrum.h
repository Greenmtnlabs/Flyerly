

#import <UIKit/UIKit.h>

@protocol PickerDrumDataSource;
@protocol PickerDrumDelegate;


@interface PickerDrum : UIView

@property (nonatomic, weak) id<PickerDrumDataSource> dataSource;
@property (nonatomic, weak) id<PickerDrumDelegate> delegate;
@property (nonatomic, strong) UIColor *foregroundColor;

- (void)reload;
- (void)selectRow:(NSInteger)row animated:(BOOL)animated;
- (NSInteger)selectedRow;

@end




@protocol PickerDrumDataSource <NSObject>
@required
- (NSInteger)numberOfRowsInPickerDrum:(PickerDrum *)pickerDrum;

@end


@protocol PickerDrumDelegate <NSObject>
@optional
- (CGFloat)rowHeightInPickerDrum:(PickerDrum *)pickerDrum;
- (UIView*)pickerDrum:(PickerDrum *)pickerDrum viewForRow:(NSInteger)row reusingView:(UIView *)view;
- (NSString *)pickerDrum:(PickerDrum *)pickerDrum titleForRow:(NSInteger)row;
- (void)pickerDrum:(PickerDrum *)pickerDrum didSelectRow:(NSInteger)row;

@end
