//
//  MyNavigationBar.h
//  Flyr
//
//  Created by Krunal on 10/26/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyNavigationBar : UIView {

	UIButton *leftButton;
	UILabel *title;
	UIButton *rightButton;
	
}

@property (nonatomic,retain) UIButton *leftButton;
@property (nonatomic,retain) UILabel *title;
@property (nonatomic,retain) UIButton *rightButton;
-(void)show:(NSString*)str left:(NSString*)lButton right:(NSString*)rButton;
@end
