//
//  AddFriendItem.m
//  Flyr
//
//  Created by Rizwan Ahmad on 4/15/13.
//
//

#import "AddFriendItem.h"

@implementation AddFriendItem
@synthesize leftCheckBox, leftName, rightCheckBox, rightName, leftImage, rightImage;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    
    return self;
}


-(void)setValues:(NSString *)title1 title2:(NSString *)title2{
    
    [leftName setText:title1];
    [rightName setText:title2];
    
}

@end
