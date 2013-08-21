//
//  MyNavigationBar.m
//  Flyr
//
//  Created by Krunal on 10/26/09.
//  Copyright 2009 iauro. All rights reserved.
//

#import "MyNavigationBar.h"


@implementation MyNavigationBar
@synthesize leftButton,title,rightButton;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
		//self.frame = CGRectMake(-5,0, 330,44);
		//self.backgroundColor = [UIColor redColor];
		self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navBar.png"]];
		title = [[UILabel alloc]initWithFrame:CGRectMake(100,2,130,40)];
		title.textAlignment = UITextAlignmentCenter;
		title.textColor = [UIColor blackColor];
		title.backgroundColor = [UIColor clearColor];
		title.font =[UIFont fontWithName:@"Avenir-Heavy" size:16];
		title.numberOfLines =2;
		
		leftButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 7, 29, 25)];
		[leftButton.titleLabel setFont:[UIFont fontWithName:@"Symbol" size:12]];
		[leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[leftButton setBackgroundImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
		[leftButton.titleLabel setTextAlignment:UITextAlignmentCenter];
		[leftButton.titleLabel setNumberOfLines:2];
		
		rightButton = [[UIButton alloc]initWithFrame:CGRectMake(239, 7, 80, 30)];
		[rightButton.titleLabel setFont:[UIFont fontWithName:@"Symbol" size:12]];
		[rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[rightButton setBackgroundImage:[UIImage imageNamed:@"forword"] forState:UIControlStateNormal];
		[rightButton.titleLabel setTextAlignment:UITextAlignmentCenter];		  
		[rightButton.titleLabel setNumberOfLines:2];
		
		[self addSubview:title];
		[self addSubview:leftButton];
		[self addSubview:rightButton];
    }
    return self;
}

-(void)show:(NSString*)str left:(NSString*)lButton right:(NSString*)rButton
{

	if([lButton isEqualToString:@""]){
		[leftButton setBackgroundImage:[UIImage imageNamed:@"unknown.png"] forState:UIControlStateNormal];
	}
	else{
		[leftButton setTitle:lButton forState:UIControlStateNormal];
	}
	
	if([rButton isEqualToString:@""]){
		[rightButton setBackgroundImage:[UIImage imageNamed:@"unknown.png"] forState:UIControlStateNormal];
		title.frame =CGRectMake(100,2,160,40);
	}	
	else{
		[rightButton setTitle:rButton forState:UIControlStateNormal];
	}
	
	title.text = str;
}

- (void)dealloc {
	[leftButton release];
	[rightButton release];
	[title release];
    [super dealloc];
}


@end
