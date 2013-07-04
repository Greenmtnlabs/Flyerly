//
//  SearchLocationItem.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 7/3/13.
//
//

#import <UIKit/UIKit.h>

@interface SearchLocationItem : UITableViewCell{
    
	IBOutlet UILabel *label1;
	IBOutlet UILabel *label2;
	IBOutlet UIImageView *imageView;
}

@property(nonatomic, retain) IBOutlet UILabel *label1;
@property(nonatomic, retain) IBOutlet UILabel *label2;
@property(nonatomic, retain) IBOutlet UIImageView *imageView;

@end
