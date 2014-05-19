//
//  InAppPurchaseCell.h
//  Flyr
//
//  Created by Khurram on 02/05/2014.
//
//

#import <UIKit/UIKit.h>

@interface InAppPurchaseCell : UITableViewCell

@property(nonatomic, strong)IBOutlet UILabel *packageName;
@property(nonatomic, strong)IBOutlet UILabel *packagePrice;
@property(nonatomic, strong)IBOutlet UILabel *packageDescription;

@property(nonatomic, strong)IBOutlet UIImageView *packageImage;

@property(nonatomic, strong)IBOutlet UIButton *packageButton;



-(void)setCellValueswithProductTitle :(NSString *)title ProductPrice:(NSString *)price ProductDescription: (NSString *)description ProductImage : (NSString *) productImage;
@end
