//
//  AddFriendItem.h
//  Flyr
//
//  Created by Rizwan Ahmad on 4/15/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AddFriendItem : UITableViewCell {
	IBOutlet UIButton *leftCheckBox;
	IBOutlet UILabel *leftName;
	IBOutlet UIButton *rightCheckBox;
	IBOutlet UILabel *rightName;
	IBOutlet UIImage *leftImage;
	IBOutlet UIImage *rightImage;
	
}
@property(nonatomic, retain) IBOutlet UIButton *leftCheckBox;
@property(nonatomic, retain) IBOutlet UILabel *leftName;
@property(nonatomic, retain) IBOutlet UIButton *rightCheckBox;
@property(nonatomic, retain) IBOutlet UILabel *rightName;
@property(nonatomic, retain) IBOutlet UIImage *leftImage;
@property(nonatomic, retain) IBOutlet UIImage *rightImage;
-(void)setValues:(NSString *)title1 title2:(NSString *)title2;

@end
