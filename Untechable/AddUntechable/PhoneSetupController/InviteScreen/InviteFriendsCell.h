//
//  AddFriendsDetail.h
//  Untechable
//
//  Created by Khurram on 04/12/2013, update on 10/10/2014 by Abdul Rauf
//
//

#import <UIKit/UIKit.h>
#import "ContactsModel.h"

@interface InviteFriendsCell : UITableViewCell < ContactsDelegate >

@property (nonatomic,strong)IBOutlet UIImageView *imgview;
@property (nonatomic,strong)IBOutlet UILabel *dName;
@property (nonatomic,strong)IBOutlet UILabel *description;
@property (nonatomic,strong)IBOutlet UIImageView *checkBtn;

-(void)setCellObjects :(ContactsModel *)model :(int)status :(NSString *)tableName;


@end
