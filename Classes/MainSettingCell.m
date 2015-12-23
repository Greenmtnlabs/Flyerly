//
//  SettingCell.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd on 05/12/2013.
//
//

#import "MainSettingCell.h"

@interface MainSettingCell ()

@end

@implementation MainSettingCell

@synthesize imgview,description;


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
