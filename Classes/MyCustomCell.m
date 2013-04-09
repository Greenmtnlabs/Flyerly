//
//  MyCustomCell.m
//  Flyr
//
//  Created by Nilesh on 22/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MyCustomCell.h"
#import "UIImageExtras.h"

@implementation MyCustomCell



#define LEFT_COLUMN_OFFSET		10
#define LEFT_COLUMN_WIDTH		220

#define UPPER_ROW_TOP			0

#define CELL_HEIGHT				100

@synthesize nameLabel;
@synthesize cellImage,indicator;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
	/*CGRect tRect = CGRectMake(0, 0,320 ,100);
	UIImageView *cell = [[UIImageView alloc] initWithFrame:tRect];	
	//cell.backgroundColor = [UIColor grayColor];
	cell.opaque = NO;
	[self.contentView addSubview:cell];
	//[cell setImage:[UIImage imageNamed:@"cell.png"]];
	[self.contentView addSubview:cellImage];
	*/
	
	CGRect tRect0 = CGRectMake(15, 2.0f, 100,96);
	cellImage = [[UIImageView alloc] initWithFrame:tRect0];	
	cellImage.backgroundColor = [UIColor clearColor];
	cellImage.opaque = NO;
	//cellImage.transform = CGAffineTransformMakeRotation(M_PI);
	[self.contentView addSubview:cellImage];
	
	CGRect tRect1 = CGRectMake(280, 40.0f,18 ,16);
	indicator = [[UIImageView alloc] initWithFrame:tRect1];	
	indicator.backgroundColor = [UIColor clearColor];
	indicator.opaque = NO;
	[self.contentView addSubview:indicator];
	[indicator setImage:[UIImage imageNamed:@"cellindicator.png"]];
	
	CGRect tRect2 = CGRectMake(80, 2.0f, 135.0f,38.0f);
	nameLabel = [[UILabel alloc] initWithFrame:tRect2];	
	nameLabel.backgroundColor = [UIColor clearColor];
	nameLabel.opaque = NO;
	nameLabel.textColor = [UIColor blackColor];
	nameLabel.numberOfLines = 2;
	[nameLabel setFont: [UIFont fontWithName:@"Verdana" size:15]];
	
	[self.contentView addSubview:nameLabel];
	
	
	
    return self;
}


- (UIImage *)scale:(UIImage *)image toSize:(CGSize)size
{
	UIGraphicsBeginImageContext(size);
	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return scaledImage;
}


- (void) addToCell: (NSString *)nameText:  (UIImage *)imageName{
	
	[self.nameLabel setText: nameText];
	//NSData *imageData = [NSData dataWithContentsOfMappedFile:imageName];
	//UIImage *currentFlyerImage = [UIImage imageWithData:imageData];  
	//currentFlyerImage = [currentFlyerImage imageByScalingAndCroppingForSize:CGSizeMake(100, 100)];
	//currentFlyerImage = [self scale:currentFlyerImage toSize:CGSizeMake(100,100)];
	//[self.cellImage setImage:[UIImage imageNamed:@"T0.Your device currently can’t connect to the internet. This may be due to cell signal or you may be in airplane mode."]];
	//NSData *jpegData = UIImageJPEGRepresentation(currentFlyerImage, 0.2);
	[self.cellImage setImage:imageName];
	//[currentFlyerImage release];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	//CGRect contentRect = [self.contentView bounds];
	
	//   CGRect frame = CGRectMake(contentRect.origin.x + LEFT_COLUMN_OFFSET, UPPER_ROW_TOP, LEFT_COLUMN_WIDTH, 40);
	//	nameLabel.frame = frame;
	
	//	frame = CGRectMake(contentRect.origin.x + LEFT_COLUMN_OFFSET, UPPER_ROW_TOP, LEFT_COLUMN_WIDTH, 70);
	//descriptionLabel.frame = frame;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}




@end
