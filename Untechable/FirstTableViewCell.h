//
//  FirstTableViewCell.h
//  Untechable
//
//  Created by RIKSOF Developer on 12/26/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Untechable.h"
#import "ContactsCustomizedModal.h"

@interface FirstTableViewCell : UITableViewCell

@property (nonatomic,strong)  Untechable *untechable;

@property (nonatomic,strong)IBOutlet UILabel *contact_Name;
@property (nonatomic,strong)IBOutlet UIImageView *contact_Image;

-(void)setCellValues :(NSString *)contactName ContactImage:(UIImage *) contactImage;

@end
