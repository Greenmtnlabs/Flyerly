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
    
    
    if([arr[0] isEqualToString:@"1"]){
        fbImage.image = [UIImage imageNamed:@"facebook_share_saved"];
        [createLabel setText:@"Shared:"];
    } else {
        fbImage.image = [UIImage imageNamed:@"facebook_disabled_saved"];
    }
    
	
    
    if([arr[1] isEqualToString:@"1"]){
        twtImage.image = [UIImage imageNamed:@"twitter_share_saved"];
        [createLabel setText:@"Shared:"];
    } else {
        twtImage.image = [UIImage imageNamed:@"twitter_disabled_saved"];
    }
	
    
    if([arr[2] isEqualToString:@"1"]){
        emailImage.image = [UIImage imageNamed:@"email_share_saved"];
        [createLabel setText:@"Shared:"];
    } else {
        emailImage.image = [UIImage imageNamed:@"email_disabled_saved"];
    }
    
	   
    if([arr[5] isEqualToString:@"1"]){
        instaImage.image = [UIImage imageNamed:@"instagram_share_saved"];
        [createLabel setText:@"Shared:"];
    } else {
        instaImage.image = [UIImage imageNamed:@"instagram_disabled_saved"];
    }
    
    
    if([arr[4] isEqualToString:@"1"]){
        flickImage.image = [UIImage imageNamed:@"flickr_share_saved"];
        [createLabel setText:@"Shared:"];
    } else {
        flickImage.image = [UIImage imageNamed:@"flickr_disabled_saved"];
    }
    
    
    if([arr[3] isEqualToString:@"1"]){
        tumbImage.image = [UIImage imageNamed:@"tumblr_share_saved"];
        [createLabel setText:@"Shared:"];
    } else {
        tumbImage.image = [UIImage imageNamed:@"tumblr_disabled_saved"];
    }
    
}


@end
