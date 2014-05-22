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


-(void)setCellValueswithProductTitle :(NSString *)title ProductPrice:(NSString *)price ProductDescription: (NSString *)description;


@end
