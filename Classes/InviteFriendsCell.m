//
//  AddFriendsDetail.m
//  Flyr
//
//  Created by Riksof on 04/12/2013.
//
//

#import "InviteFriendsCell.h"

@interface InviteFriendsCell ()

@end

@implementation InviteFriendsCell

@synthesize imgview,description,dName,checkBtn;


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
