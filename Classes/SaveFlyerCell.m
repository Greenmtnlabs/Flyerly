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
@synthesize nameLabel, description, dateLabel, createLabel,cellImage,backgroundImage,filePath,flyerNumber;
@synthesize fbImage,twtImage,emailImage,instaImage,flickImage,tumbImage;



- (void)renderCell :(Flyer *)flyer {
    
    self.backgroundImage.image =  [UIImage imageNamed:@"cell_bg_first"];

    // HERE WE SET FLYER INFORMATION FORM .TXT FILE
    [self.nameLabel setText: [flyer getFlyerTitle]];
    [self.description setText:[flyer getFlyerDescription]];
    [self.dateLabel setText:[flyer getFlyerDate]];
    
    // HERE WE SET FLYER IMAGE
    UIImage *flyerImage =  [UIImage imageWithContentsOfFile:[flyer getFlyerImage]];
    self.cellImage.image = flyerImage;
    
    
    // HERE WE SET SOCIAL NETWORK STATUS OF FLYER
    if([[flyer getFacebookStatus] isEqualToString:@"1"]){
        fbImage.image = [UIImage imageNamed:@"facebook_share_saved"];
        [createLabel setText:@"Shared:"];
    } else {
        fbImage.image = [UIImage imageNamed:@"facebook_disabled_saved"];
    }
    
	
    
    if([[flyer getTwitterStatus] isEqualToString:@"1"]){
        twtImage.image = [UIImage imageNamed:@"twitter_share_saved"];
        [createLabel setText:@"Shared:"];
    } else {
        twtImage.image = [UIImage imageNamed:@"twitter_disabled_saved"];
    }
	
    
    if([[flyer getEmailStatus] isEqualToString:@"1"]){
        emailImage.image = [UIImage imageNamed:@"email_share_saved"];
        [createLabel setText:@"Shared:"];
    } else {
        emailImage.image = [UIImage imageNamed:@"email_disabled_saved"];
    }
    
    
    if([[flyer getInstagaramStatus] isEqualToString:@"1"]){
        instaImage.image = [UIImage imageNamed:@"instagram_share_saved"];
        [createLabel setText:@"Shared:"];
    } else {
        instaImage.image = [UIImage imageNamed:@"instagram_disabled_saved"];
    }
    
    
    if([[flyer getFlickerStatus] isEqualToString:@"1"]){
        flickImage.image = [UIImage imageNamed:@"flickr_share_saved"];
        [createLabel setText:@"Shared:"];
    } else {
        flickImage.image = [UIImage imageNamed:@"flickr_disabled_saved"];
    }
    
    
    if([[flyer getThumblerStatus] isEqualToString:@"1"]){
        tumbImage.image = [UIImage imageNamed:@"tumblr_share_saved"];
        [createLabel setText:@"Shared:"];
    } else {
        tumbImage.image = [UIImage imageNamed:@"tumblr_disabled_saved"];
    }


}


- (void)addToCell :(NSString *)tit :(NSString *)des :(NSString *)crted :(UIImage *)img :(NSString*)imgpath :  (int)flyerparam{
    
    self.backgroundImage.image =  [UIImage imageNamed:@"cell_bg_first"];
	[self.nameLabel setText: tit];
    [self.description setText:des];
    [self.dateLabel setText:crted];
  
    self.filePath = imgpath;
    flyerNumber = flyerparam;
    
    PFUser *user = [PFUser currentUser];
    
    NSString *socialFlyerPath = [self.filePath stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/Flyr/",user.username] withString:[NSString stringWithFormat:@"%@/Flyr/Social/", user.username]];
	NSString *finalImgWritePath = [socialFlyerPath stringByReplacingOccurrencesOfString:@".jpg" withString:@".soc"];
    
    NSArray *arr = [[NSArray alloc] initWithContentsOfFile:finalImgWritePath];
    // NSLog(@"%@", arr);
    
    self.cellImage.image = img;
    
    
    
}


@end
