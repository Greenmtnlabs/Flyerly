//
//  InAppPurchaseCell.h
//  Flyr
//
//  Created by Khurram on 02/05/2014.
//
//

#import <UIKit/UIKit.h>

@interface InAppPurchaseCell : UITableViewCell

@property(nonatomic, retain)IBOutlet UILabel *packageName;
@property(nonatomic, retain)IBOutlet UILabel *packagePrice;
@property(nonatomic, retain)IBOutlet UILabel *packageDescription;

@property(nonatomic, retain)IBOutlet UIImageView *discount;
@property (strong, nonatomic) IBOutlet UIImageView *star;



-(void)setCellValueswithProductTitle :(NSString *)productIdentifier Title:(NSString *)title ProductPrice:(NSString *)price ProductDescription: (NSString *)description;


@end
