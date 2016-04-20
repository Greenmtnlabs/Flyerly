
//
//  CustomAssets.m
//  Flyr
//
//  Created by Khurram on 07/04/2014.
//
//

#import "FlyrAppDelegate.h"
#import "CustomAssets.h"
#import "Common.h"

@implementation CustomAssets

@synthesize videoIcon;
/*
// Only override setObject: if you perform custom drawing.
// Here we Add Video Icon On Video files of User Library
*/
- (void)setObject:(NBUAsset *)asset
{
    
    [super setObject:asset];
    
    //Here we Check Content is Video Or Image
    if ( asset.type == NBUAssetTypeVideo) {
        videoIcon.alpha = 1;
        
        UserPurchases *userPurchases_ = [UserPurchases getInstance];
        if ([[PFUser currentUser] sessionToken].length != 0) {
            
            if ( [userPurchases_ checkKeyExistsInPurchases: IN_APP_ID_ALL_DESIGN] ||
                 [userPurchases_ checkKeyExistsInPurchases: IN_APP_ID_UNLOCK_VIDEO] ) {
                
                UIImage *image = [UIImage imageNamed: @"ModeVideo.png"];
                videoIcon.image = image;
            }
            
        }
    }else {
        videoIcon.alpha = 0;
    }
}

@end
