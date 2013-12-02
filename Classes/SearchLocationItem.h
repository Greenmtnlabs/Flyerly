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

@property(nonatomic, strong) IBOutlet UILabel *label1;
@property(nonatomic, strong) IBOutlet UILabel *label2;
@property(nonatomic, strong) IBOutlet UIImageView *imageView;

@end
