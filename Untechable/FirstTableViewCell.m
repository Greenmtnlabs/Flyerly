//
//  FirstTableViewCell.m
//  Untechable
//
//  Created by RIKSOF Developer on 12/26/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "FirstTableViewCell.h"

@implementation FirstTableViewCell

@synthesize contact_Name,contact_Image,untechable;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellValues :(NSString *)contactName ContactImage:(UIImage *) contactImage;
{
    
    self.contact_Name.text = contactName;
    self.contact_Image.image = contactImage;
    self.contact_Image.layer.cornerRadius = self.contact_Image.frame.size.width / 2;
    self.contact_Image.clipsToBounds = YES;
}

@end
