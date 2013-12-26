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

@property(nonatomic, strong) UILabel *createLabel;
@property(nonatomic, strong) UILabel * nameLabel;
@property(nonatomic, strong) UILabel * descriptionLabel;
@property(nonatomic, strong) UILabel * dateLabel;
@property(nonatomic, strong) UIButton *cellImage;
@property(nonatomic, strong) UIImageView *indicator;
@property(nonatomic, strong) NSString *filePath;
@property int flyerNumber;

- (void) addToCell: (NSString *)title:  (NSString *)description: (NSString *)created: (UIImage *)image: (NSString*)imagePath:  (int)flyerNumberParam;
+(UIColor*)colorWithHexString:(NSString*)hex;

@end
