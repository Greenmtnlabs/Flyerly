//
//  MainFlyerCellViewController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd on 17/01/2014.
//
//

#import "MainFlyerCell.h"

@interface MainFlyerCell ()

@end

@implementation MainFlyerCell
@synthesize  cellImage,sideView;
@synthesize shareBtn,flyerLock, lblCreatedAt, lblFlyerTitle;


/*
 * HERE WE SET FLYER IMAGE ,TITLE,DESCRICPTION,DATE AND SOCIAL NETWORK STATUS
 */
- (void)renderCell :(Flyer *)flyer LockStatus:(BOOL )status {
    
    NSString *flyerTitle = [flyer getFlyerTitle];
    
    // If flyer has no title, set this text
    if([flyerTitle isEqualToString:@""]){
        flyerTitle = @"Add Title";
    }
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [tap setNumberOfTapsRequired:1];
    [self.lblFlyerTitle addGestureRecognizer:tap];
    
    
    [self.lblFlyerTitle setText: flyerTitle];
    NSString *updatedDate = [flyer getFlyerUpdateDateInAgoFormat];
    if ([updatedDate isEqualToString:@""]) {
        self.lblCreatedAt.hidden = YES;
    }else {
        self.lblCreatedAt.text = updatedDate;
    }

    //HERE WE LOCK FLYER CELL
    if (status) {
        flyerLock.hidden = NO;
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
    if ( [[flyer getYouTubeStatus] isEqualToString:@"1"] ) {
        iconImage.image = [UIImage imageNamed:@"youtube_share_saved"];
        sharingCount++;
    }
    
    iconImage = [_socialStatus objectAtIndex:sharingCount];
    if ( [[flyer getMessengerStatus] isEqualToString:@"1"] ) {
        iconImage.image = [UIImage imageNamed:@"messenger_share_saved"];
        sharingCount++;
    }
}

- (void)tapAction {
    NSLog(@"Tap action");
}

@end
