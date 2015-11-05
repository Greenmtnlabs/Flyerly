//
//  InviteFriendsCell.h
//  Untechable
//
//  Created by M. Arqam Owais on 05/11/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsModel.h"

@interface InviteFriendsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgProfilePic;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet UIImageView *imgCheckBox;


-(void)setCellObjects :(ContactsModel *)contactsModel :(int)status :(NSString *)tableName;

@end
