//
//  CustomAssets.m
//  Flyr
//
//  Created by Khurram on 07/04/2014.
//
//

#import "CustomAssets.h"

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
    }else {
        videoIcon.alpha = 0;
    }
    
    
}

@end
