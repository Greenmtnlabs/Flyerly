//
//  SettingCell.m
//  Flyr
//
//  Created by Khurram on 05/12/2013.
//
//

#import "MainSettingCell.h"

@interface MainSettingCell ()

@end

@implementation MainSettingCell

@synthesize imgview,description,ONOffswitch;

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame ]) {
        // Initialization code
    }
	
    // Create Imageview for image
    self.imgview = [[UIImageView alloc]init];
    [self.imgview setFrame:CGRectMake(15, 7, 21, 21)];
    [self.contentView addSubview:self.imgview];
    
    // Create Labels for text
    self.description = [[UILabel alloc]initWithFrame:CGRectMake(55, 7, 198, 21)];
    [self.description setBackgroundColor:[UIColor clearColor]];
    [self.description setTextColor:[UIColor darkTextColor]];
	[self.description setFont:[UIFont fontWithName:@"AvenirNext-Bold" size:14]];
	[self.description setTextAlignment:UITextAlignmentLeft];
    [self.contentView addSubview:self.description];
    
    
    return self;
}


/*
 * Set CellObjects
 * @param text as Description
 * @param image Name
 */
-(void)setCellObjects :(NSString *)desp leftimage :(NSString *)leftimage{
    
    // Set Values
    [description setText:desp];
    [imgview setImage:[UIImage imageNamed:leftimage]];
}


@end
