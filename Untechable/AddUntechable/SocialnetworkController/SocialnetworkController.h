//
//  SocialnetworkController.h
//  Untechable
//
//  Created by Muhammad Raheel on 29/09/2014.
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"
#import "UIPlaceHolderTextView.h"
@interface SocialnetworkController : UIViewController
{
    UILabel *titleLabel;
    UIButton *helpButton;
    UIButton *backButton;
    UIButton *finishButton;
    UIColor *defGreen;//GREEN
    UIColor *defGray;//GRAY
    
}
//Properties
@property (nonatomic,strong)  Untechable *untechable;
@property(nonatomic,strong) IBOutlet UIPlaceHolderTextView *descriptionView;



@end
