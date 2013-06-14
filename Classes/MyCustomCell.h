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
	UIButton *cellImage;
	UIImageView *indicator;
    NSString *filePath;
    UILabel *createLabel;
    
    int flyerNumber;
}

@property(nonatomic, retain) UILabel *createLabel;
@property(nonatomic, retain) UILabel * nameLabel;
@property(nonatomic, retain) UILabel * descriptionLabel;
@property(nonatomic, retain) UILabel * dateLabel;
@property(nonatomic, retain) UIButton *cellImage;
@property(nonatomic, retain) UIImageView *indicator;
@property(nonatomic, retain) NSString *filePath;
@property int flyerNumber;

- (void) addToCell: (NSString *)title:  (NSString *)description: (NSString *)created: (UIImage *)image: (NSString*)imagePath:  (int)flyerNumberParam;
+(UIColor*)colorWithHexString:(NSString*)hex;

@end
