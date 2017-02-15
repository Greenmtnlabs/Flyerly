//
//  MainFlyerCellViewController.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd on 17/01/2014.
//
//

#import <UIKit/UIKit.h>
#import "Flyer.h"

@interface MainFlyerCell : UITableViewCell

@property(nonatomic, strong)IBOutlet UIImageView *cellImage;
@property(nonatomic, strong)IBOutlet UIView *sideView;
@property ( nonatomic, strong ) IBOutletCollection(UIImageView) NSArray *socialStatus;
@property(nonatomic, strong)IBOutlet UIButton *flyerLock;
@property(nonatomic, strong)IBOutlet UIButton *shareBtn;

@property (nonatomic, strong) IBOutlet UILabel *lblFlyerTitle;
@property (nonatomic, strong) IBOutlet UILabel *lblCreatedAt;

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *imgSeperator;

- (void)renderCell :(Flyer *)flyer LockStatus:(BOOL )status;
@end
