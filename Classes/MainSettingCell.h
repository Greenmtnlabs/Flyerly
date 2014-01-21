//
//  SettingCell.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd on 05/12/2013.
//
//

#import <UIKit/UIKit.h>

@interface MainSettingCell : UITableViewCell


@property (nonatomic,strong)IBOutlet UIImageView *imgview;
@property (nonatomic,strong)IBOutlet UILabel *description;


-(void)setCellObjects :(NSString *)desp leftimage :(NSString *)leftimage;

@end
