//
//  SettingCell.h
//  Flyr
//
//  Created by Khurram on 05/12/2013.
//
//

#import <UIKit/UIKit.h>

@interface MainSettingCell : UITableViewCell


@property (nonatomic,strong)IBOutlet UIImageView *imgview;
@property (nonatomic,strong)IBOutlet UILabel *description;
@property (nonatomic,strong)IBOutlet UISwitch *ONOffswitch;
-(void)setCellObjects :(NSString *)desp leftimage :(NSString *)leftimage;

@end
