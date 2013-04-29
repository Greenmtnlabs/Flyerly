//
//  AddFriendItem.m
//  Flyr
//
//  Created by Rizwan Ahmad on 4/15/13.
//
//

#import "AddFriendItem.h"

@implementation AddFriendItem
@synthesize leftCheckBox, leftName, rightCheckBox, rightName, leftImage, rightImage, identifier1, identifier2, leftSelected, rightSelected;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    
    return self;
}

-(void)setValues:(NSString *)title1 title2:(NSString *)title2{
    
    [leftName setText:title1];
    [rightName setText:title2];
    
    if([title2 isEqualToString:@""]){
        [rightCheckBox setHidden:true];
    }
}

-(void)setImages:(UIImage *)image1 image2:(UIImage *)image2{
    [leftImage setImage:image1];
    [rightImage setImage:image2];
}

/**
 * This is called when left check box is pressed
 */
- (IBAction)onLeftCheckBoxClick:(UIButton *)sender{
    
    BOOL isSelected = [sender isSelected];
    [leftCheckBox setSelected:!isSelected];
    leftSelected = !isSelected;
    
}

/**
 * This is called when right check box is pressed
 */
- (IBAction)onRightCheckBoxClick:(UIButton *)sender{
    
    BOOL isSelected = [sender isSelected];
    [rightCheckBox setSelected:!isSelected];
    rightSelected = !isSelected;
    
}

@end
