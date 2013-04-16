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
	IBOutlet UIImageView *leftImage;
	IBOutlet UIImageView *rightImage;
	
}
@property(nonatomic, retain) IBOutlet UIButton *leftCheckBox;
@property(nonatomic, retain) IBOutlet UILabel *leftName;
@property(nonatomic, retain) IBOutlet UIButton *rightCheckBox;
@property(nonatomic, retain) IBOutlet UILabel *rightName;
@property(nonatomic, retain) IBOutlet UIImageView *leftImage;
@property(nonatomic, retain) IBOutlet UIImageView *rightImage;
-(void)setValues:(NSString *)title1 title2:(NSString *)title2;
-(void)setImages:(UIImage *)image1 image2:(UIImage *)image2;
- (IBAction)onCheckBoxClick:(UIButton *)sender;

@end
