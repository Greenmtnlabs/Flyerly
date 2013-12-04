//
//  AddFriendsDetail.m
//  Flyr
//
//  Created by Khurram on 04/12/2013.
//
//

#import "AddFriendsDetail.h"

@interface AddFriendsDetail ()

@end

@implementation AddFriendsDetail

@synthesize imgview,description,dName,checkBtn;

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame ]) {
        // Initialization code
    }
	
    // Create Imageview for image
    self.imgview = [[UIImageView alloc]init];
    [self.imgview setFrame:CGRectMake(9, 7, 72, 72)];
    [self.contentView addSubview:self.imgview];
    
    // Create Labels for text
    
    self.dName = [[UILabel alloc]initWithFrame:CGRectMake(90, 14, 228, 21)];
    [self.dName setBackgroundColor:[UIColor clearColor]];
    [self.dName setTextColor:[UIColor darkTextColor]];
	[self.dName setFont:[UIFont fontWithName:@"AvenirNext-Bold" size:16]];
	[self.dName setTextAlignment:UITextAlignmentLeft];
    [self.contentView addSubview:self.dName];

    
    self.description = [[UILabel alloc]initWithFrame:CGRectMake(90, 35, 198, 25)];
    [self.description setBackgroundColor:[UIColor clearColor]];
    [self.description setTextColor:[UIColor lightGrayColor]];
	[self.description setFont:[UIFont fontWithName:@"Symbol" size:12]];
	[self.description setTextAlignment:UITextAlignmentLeft];
    [self.contentView addSubview:self.description];
    
    
    self.checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(284,48 , 28, 28)];
    [self.contentView addSubview:self.checkBtn];
    
    return self;
}


/*
 * Set CellObjects
 * @param text as Description
 * @param image Name
 */
-(void)setCellObjects :(NSString *)nam Description:(NSString *)desp :(UIImage *)imagename CheckImage :(NSString *)chkimage{
    
    // Set Values
    [dName setText:nam];
    [description setText:desp];
    [imgview setImage:imagename];
    [checkBtn setBackgroundImage:[UIImage imageNamed:chkimage] forState:UIControlStateNormal];
}




@end
