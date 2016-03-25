//
//  InAppPurchaseCell.m
//  Flyr
//
//  Created by Khurram on 02/05/2014.
//
//

#import "InAppPurchaseCell.h"

@implementation InAppPurchaseCell

@synthesize packageName,packagePrice,packageDescription,discount,star;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellValueswithProductTitle :(NSString *)productIdentifier Title:(NSString *)title ProductPrice:(NSString *)price ProductDescription: (NSString *)description{
    
    if ( ![title isEqualToString:@"Complete Bundle"] ){
        [discount removeFromSuperview];
    }
    
    if ( ![title isEqualToString:@"Monthly Subscription"] ){
        [star removeFromSuperview];
    }
    
    if([productIdentifier isEqualToString:@"com.flyerly.MonthlyGold"]){
        packageName.textColor = [UIColor redColor];
    }

    
    packageName.text = title;
    packagePrice.text = price;
    packageDescription.text = description;
    [self setTextInTopCenter:packageDescription];
}

//set text vertically top and center
-(void)setTextInTopCenter:(UILabel *)lbl{
    lbl.textAlignment = NSTextAlignmentCenter;
    CGRect oldFrame = lbl.frame;
    [lbl setNumberOfLines:0];
    [lbl sizeToFit];
    lbl.frame = CGRectMake(lbl.frame.origin.x, lbl.frame.origin.y, oldFrame.size.width, lbl.frame.size.height);
}

@end
