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
	UIImageView *cellImage;
	UIImageView *indicator;
	
}
@property(nonatomic, retain) UILabel * nameLabel;
@property(nonatomic, retain) UIImageView *cellImage;
@property(nonatomic, retain) UIImageView *indicator;
- (void) addToCell: (NSString *)nameText:  (UIImage *)imageName ;

@end
