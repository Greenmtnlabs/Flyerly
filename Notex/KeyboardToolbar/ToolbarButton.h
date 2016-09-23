//////////////////////////////////////
//
//   Notex
//   created by FV iMAGINATION
//   ©2014
//
//////////////////////////////////////


#import <UIKit/UIKit.h>

typedef void (^eventHandlerBlock)();

@interface ToolbarButton : UIButton

+ (instancetype)buttonWithTitle:(NSString *)title;

- (void)addEventHandler:(eventHandlerBlock)eventHandler forControlEvents:(UIControlEvents)controlEvent;

@end
