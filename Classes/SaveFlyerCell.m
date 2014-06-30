//
//  SaveFlyerCellViewController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd on 17/01/2014.
//
//

#import "SaveFlyerCell.h"

@interface SaveFlyerCell ()

@end

@implementation SaveFlyerCell
@synthesize nameLabel, description, dateLabel, createLabel,cellImage,backgroundImage;
@synthesize flyerLock,lockImage,updatedDateLabel,updatedLabel;


/*
 * HERE WE SET FLYER IMAGE ,TITLE,DESCRICPTION,DATE AND SOCIAL NETWORK STATUS
 */
- (void)renderCell :(Flyer *)flyer LockStatus:(BOOL )status {
    

    //HERE WE LOCK FLYER CELL
    if (status) {
        flyerLock.hidden = NO;
        [lockImage setImage:[UIImage imageNamed:@"lock_icon"]];
    }
    
    // HERE WE SET FLYER INFORMATION FORM .TXT FILE
    [self.nameLabel setText: [flyer getFlyerTitle]];
    [self.description setText:[flyer getFlyerDescription]];
    [self.dateLabel setText:[flyer getFlyerDate]];
    NSString *updatedDate = [flyer getFlyerUpdateDate];
    if ([updatedDate isEqualToString:@""]) {
        self.updatedLabel.hidden = YES ;
        self.updatedDateLabel.hidden = YES;
    }else {
        self.updatedDateLabel.text = updatedDate;
    }
    
    
    // HERE WE SET FLYER IMAGE
    UIImage *flyerImage =  [UIImage imageWithContentsOfFile:[flyer getFlyerImage]];
    self.cellImage.image = flyerImage;
    
    
    // HERE WE SET SOCIAL NETWORK STATUS OF FLYER
    NSInteger sharingCount = 0;
    UIImageView *iconImage;
    
    iconImage = [_socialStatus objectAtIndex:sharingCount];
    if ( [[flyer getFacebookStatus] isEqualToString:@"1"] ) {
        iconImage.image = [UIImage imageNamed:@"facebook_share_saved"];
        sharingCount++;
    }
    
	iconImage = [_socialStatus objectAtIndex:sharingCount];
    if ( [[flyer getTwitterStatus] isEqualToString:@"1"] ) {
        iconImage.image = [UIImage imageNamed:@"twitter_share_saved"];
        sharingCount++;
    }
	
    iconImage = [_socialStatus objectAtIndex:sharingCount];
    if ( [[flyer getEmailStatus] isEqualToString:@"1"] ) {
        iconImage.image = [UIImage imageNamed:@"email_share_saved"];
        sharingCount++;
    }
    
    iconImage = [_socialStatus objectAtIndex:sharingCount];
    if ( [[flyer getInstagaramStatus] isEqualToString:@"1"] ) {
        iconImage.image = [UIImage imageNamed:@"instagram_share_saved"];
        sharingCount++;
    }
    
    iconImage = [_socialStatus objectAtIndex:sharingCount];
    if ( [[flyer getFlickerStatus] isEqualToString:@"1"] ) {
        iconImage.image = [UIImage imageNamed:@"flickr_share_saved"];
        sharingCount++;
    }
    
    iconImage = [_socialStatus objectAtIndex:sharingCount];
    if ( [[flyer getThumblerStatus] isEqualToString:@"1"] ) {
        iconImage.image = [UIImage imageNamed:@"tumblr_share_saved"];
        sharingCount++;
    }
}

@end
