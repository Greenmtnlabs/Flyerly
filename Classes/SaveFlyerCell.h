//
//  SaveFlyerCellViewController.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd on 17/01/2014.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Flyer.h"
@interface SaveFlyerCell : UITableViewCell

@property(nonatomic, strong)IBOutlet UIImageView *cellImage;
@property ( nonatomic, strong ) IBOutletCollection(UIImageView) NSArray *socialStatus;
@property(nonatomic, strong)IBOutlet UIButton *flyerLock;
@property(nonatomic, strong)IBOutlet UIButton *shareBtn;

- (void)renderCell :(Flyer *)flyer LockStatus:(BOOL )status;
@end
