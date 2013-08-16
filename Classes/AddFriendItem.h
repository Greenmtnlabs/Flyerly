//
//  AddFriendItem.h
//  Flyr
//
//  Created by Rizwan Ahmad on 4/15/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface AddFriendItem : UITableViewCell {
	IBOutlet UIButton *leftCheckBox;
	IBOutlet UILabel *leftName;
	IBOutlet UIButton *rightCheckBox;
	IBOutlet UILabel *rightName;
	IBOutlet AsyncImageView *leftImage;
	IBOutlet AsyncImageView *rightImage;
    
	BOOL leftSelected;
    BOOL rightSelected;
    NSString *identifier1;
    NSString *identifier2;
}
@property(nonatomic, retain) IBOutlet UIButton *leftCheckBox;
@property(nonatomic, retain) IBOutlet UILabel *leftName;
@property(nonatomic, retain) IBOutlet UIButton *rightCheckBox;
@property(nonatomic, retain) IBOutlet UILabel *rightName;
@property(nonatomic, retain) IBOutlet UIImageView *leftImage;
@property(nonatomic, retain) IBOutlet UIImageView *rightImage;
@property(nonatomic, retain) NSString *identifier1;
@property(nonatomic, retain) NSString *identifier2;
@property BOOL leftSelected;
@property BOOL rightSelected;



-(void)setValues:(NSString *)title1 title2:(NSString *)title2;
-(void)setImages:(UIImage *)image1 image2:(UIImage *)image2;
- (IBAction)onLeftCheckBoxClick:(UIButton *)sender;
- (IBAction)onRightCheckBoxClick:(UIButton *)sender;
-(void)setImagesURL:(NSString *)name1 name2:(NSString *)name2;

@end
