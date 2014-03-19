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
@synthesize fbImage,twtImage,emailImage,instaImage,flickImage,tumbImage,flyerLock,lockImage,updatedDateLabel,updatedLabel;


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
    if([[flyer getFacebookStatus] isEqualToString:@"1"]){
        fbImage.image = [UIImage imageNamed:@"facebook_share_saved"];
    } else {
        fbImage.image = [UIImage imageNamed:@"facebook_disabled_saved"];
    }
    
	
    
    if([[flyer getTwitterStatus] isEqualToString:@"1"]){
        twtImage.image = [UIImage imageNamed:@"twitter_share_saved"];
    } else {
        twtImage.image = [UIImage imageNamed:@"twitter_disabled_saved"];
    }
	
    
    if([[flyer getEmailStatus] isEqualToString:@"1"]){
        emailImage.image = [UIImage imageNamed:@"email_share_saved"];
    } else {
        emailImage.image = [UIImage imageNamed:@"email_disabled_saved"];
    }
    
    
    if([[flyer getInstagaramStatus] isEqualToString:@"1"]){
        instaImage.image = [UIImage imageNamed:@"instagram_share_saved"];
    } else {
        instaImage.image = [UIImage imageNamed:@"instagram_disabled_saved"];
    }
    
    
    if([[flyer getFlickerStatus] isEqualToString:@"1"]){
        flickImage.image = [UIImage imageNamed:@"flickr_share_saved"];
    } else {
        flickImage.image = [UIImage imageNamed:@"flickr_disabled_saved"];
    }
    
    
    if([[flyer getThumblerStatus] isEqualToString:@"1"]){
        tumbImage.image = [UIImage imageNamed:@"tumblr_share_saved"];
    } else {
        tumbImage.image = [UIImage imageNamed:@"tumblr_disabled_saved"];
    }


}

@end
