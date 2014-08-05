//
//  AddFriendsDetail.h
//  Flyr
//
//  Created by Riksof on 04/12/2013.
//
//

#import <UIKit/UIKit.h>
#import "ContactsModel.h"

@interface InviteFriendsCell : UITableViewCell < ContactsDelegate >{

}


@property (nonatomic,strong)IBOutlet UIImageView *imgview;
@property (nonatomic,strong)IBOutlet UILabel *dName;
@property (nonatomic,strong)IBOutlet UILabel *description;
@property (nonatomic,strong)IBOutlet UIImageView *checkBtn;

-(void)setCellObjects :(ContactsModel *)model :(int)status :(NSString *)tableName;


@end
