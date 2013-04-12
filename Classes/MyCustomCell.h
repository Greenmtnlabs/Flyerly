//
//  MyCustomCell.h
//  Flyr
//
//  Created by Nilesh on 22/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyCustomCell : UITableViewCell {
	UILabel * nameLabel;
	UILabel * descriptionLabel;
	UILabel * dateLabel;
	UIImageView *cellImage;
	UIImageView *indicator;
	
}
@property(nonatomic, retain) UILabel * nameLabel;
@property(nonatomic, retain) UILabel * descriptionLabel;
@property(nonatomic, retain) UILabel * dateLabel;
@property(nonatomic, retain) UIImageView *cellImage;
@property(nonatomic, retain) UIImageView *indicator;
- (void) addToCell: (NSString *)title:  (NSString *)description: (NSString *)created: (UIImage *)imageName;
+(UIColor*)colorWithHexString:(NSString*)hex;

@end
