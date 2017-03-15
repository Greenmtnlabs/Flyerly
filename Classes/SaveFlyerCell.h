//
//  SaveFlyerCellViewController.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd on 17/01/2014.
//
//

#import <UIKit/UIKit.h>
#import "Flyer.h"

@interface SaveFlyerCell : UITableViewCell

@property(nonatomic, strong)IBOutlet UILabel *createLabel;
@property(nonatomic, strong)IBOutlet UILabel *updatedLabel;
@property(nonatomic, strong)IBOutlet UILabel * nameLabel;
@property(nonatomic, strong)IBOutlet UITextView * description;
@property(nonatomic, strong)IBOutlet UILabel * dateLabel;
@property(nonatomic, strong)IBOutlet UILabel * updatedDateLabel;

@property(nonatomic, strong)IBOutlet UIImageView *cellImage;
@property(nonatomic, strong)IBOutlet UIImageView *backgroundImage;
@property(nonatomic, strong) NSString *filePath;

@property ( nonatomic, strong ) IBOutletCollection(UIImageView) NSArray *socialStatus;
@property(nonatomic, strong)IBOutlet UIButton *flyerLock;
@property(nonatomic, strong)IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UIButton *btnEdit;


- (void)renderCell :(Flyer *)flyer LockStatus:(BOOL )status;

@end
