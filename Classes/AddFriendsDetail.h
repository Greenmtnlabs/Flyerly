//
//  AddFriendsDetail.h
//  Flyr
//
//  Created by Khurram on 04/12/2013.
//
//

#import <UIKit/UIKit.h>

@interface AddFriendsDetail : UITableViewCell


@property (nonatomic,strong)IBOutlet UIImageView *imgview;
@property (nonatomic,strong)IBOutlet UILabel *dName;
@property (nonatomic,strong)IBOutlet UILabel *description;
@property (nonatomic,strong)IBOutlet UIButton *checkBtn;

-(void)setCellObjects :(NSString *)nam Description:(NSString *)desp :(UIImage *)imagename CheckImage :(NSString *)chkimage;


@end
