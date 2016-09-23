//////////////////////////////////////
//
//   Notex
//   created by FV iMAGINATION
//   ©2014
//
//////////////////////////////////////


#import <UIKit/UIKit.h>

// Delegate and Datasource **********
@protocol FVLongPressOverlayViewDataSource;
@protocol FVLongPressOverlayViewDelegate;

// Variables ***********
BOOL isShowing, isPaning;
CGPoint longPressLocation, curretnLocation;
NSMutableArray *menuItems, *itemLocations;
UILongPressGestureRecognizer* longPressRecognizer;
CGFloat radius, arcAngle, angleBetweenItems;


@interface FVLongPressMenuView : UIView

@property (nonatomic, assign) id<FVLongPressOverlayViewDataSource> dataSource;
@property (nonatomic, assign) id<FVLongPressOverlayViewDelegate> delegate;

- (void) longPressDetected:(UIGestureRecognizer*) gestureRecognizer;

@end

@protocol FVLongPressOverlayViewDataSource <NSObject>

@required
- (NSInteger) numberOfMenuItems;
- (UIImage*) imageForItemAtIndex:(NSInteger) index;

@optional
-(BOOL) shouldShowMenuAtPoint:(CGPoint) point;

@end

@protocol FVLongPressOverlayViewDelegate <NSObject>

- (void) didSelectItemAtIndex:(NSInteger) selectedIndex forMenuAtPoint:(CGPoint) point;

@end
