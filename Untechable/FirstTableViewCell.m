//
//  FirstTableViewCell.m
//  Untechable
//
//  Created by RIKSOF Developer on 12/26/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "FirstTableViewCell.h"

@implementation FirstTableViewCell

@synthesize contactName,contactImage,untechable;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellValues :(NSString *)contactName ContactModal:(ContactsCustomizedModal *) contactModal;
{
    
    self.contactName.text = contactName;
    self.contactImage.image = contactModal.img;
    self.contactImage.layer.cornerRadius = self.contactImage.frame.size.width / 2;
    self.contactImage.clipsToBounds = YES;
}

@end
