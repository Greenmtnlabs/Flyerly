//
//  InAppPurchaseCell.m
//  Flyr
//
//  Created by Khurram on 02/05/2014.
//
//

#import "InAppPurchaseCell.h"

@implementation InAppPurchaseCell

@synthesize packageName,packagePrice,packageDescription,packageImage,packageButton;



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellValueswithProductTitle :(NSString *)title ProductPrice:(NSString *)price ProductDescription: (NSString *)description ProductImage : (NSString *) productImage {
    
    packageName.text = title;
    packagePrice.text = price;
    packageDescription.text = description;
    [packageImage setImage:[UIImage imageNamed:productImage] ];
    
}

@end
