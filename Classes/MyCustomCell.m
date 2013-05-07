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

@synthesize nameLabel, descriptionLabel, dateLabel, filePath;
@synthesize cellImage,indicator;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
	
    [self setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bg_first"]]];
    
	CGRect tRect0 = CGRectMake(13, 13, 72, 77);
	cellImage = [[UIImageView alloc] initWithFrame:tRect0];	
	cellImage.backgroundColor = [UIColor clearColor];
	cellImage.opaque = NO;
	[self.contentView addSubview:cellImage];
	
	CGRect tRect2 = CGRectMake(98, 13, 195,10);
	nameLabel = [[UILabel alloc] initWithFrame:tRect2];
    [nameLabel setFont:[UIFont fontWithName:@"Signika-Semibold" size:9]];
    [nameLabel setTextColor:[MyCustomCell colorWithHexString:@"00628f"]];
    nameLabel.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:nameLabel];
	
	CGRect descriptionRect = CGRectMake(98, 18, 195,38.0f);
	descriptionLabel = [[UILabel alloc] initWithFrame:descriptionRect];
    descriptionLabel.numberOfLines = 2;
    [descriptionLabel setFont:[UIFont fontWithName:@"Signika-Regular" size:9]];
    [descriptionLabel setTextColor:[UIColor blackColor]];
    descriptionLabel.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:descriptionLabel];
	
	CGRect createdRect = CGRectMake(98, 50, 35.0f,19);
	UILabel *createLabel = [[UILabel alloc] initWithFrame:createdRect];
    [createLabel setFont:[UIFont fontWithName:@"Signika-Regular" size:8]];
    [createLabel setTextColor:[MyCustomCell colorWithHexString:@"929292"]];
    [createLabel setText:@"Created:"];
    createLabel.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:createLabel];
	
	CGRect dateRect = CGRectMake(130, 50, 195,19);
	dateLabel = [[UILabel alloc] initWithFrame:dateRect];
    [dateLabel setFont:[UIFont fontWithName:@"Signika-Regular" size:8]];
    [dateLabel setTextColor:[MyCustomCell colorWithHexString:@"929292"]];
    dateLabel.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:dateLabel];	
	
	CGRect facebookRect = CGRectMake(95, 70, 22, 22);
	UIButton *facebookButon = [[UIButton alloc] initWithFrame:facebookRect];
    facebookButon.backgroundColor = [UIColor clearColor];
    //[facebookButon addTarget:self action:@selector(changeButtonBackGroundColor:) forControlEvents:UIControlEventTouchDown];
    //[facebookButon addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpInside];
	[self.contentView addSubview:facebookButon];
	
	CGRect twitterRect = CGRectMake(119, 70, 22, 22);
	UIButton *twitterButon = [[UIButton alloc] initWithFrame:twitterRect];
    twitterButon.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:twitterButon];
	
	CGRect inboxRect = CGRectMake(143, 70, 32, 22);
	UIButton *inboxButon = [[UIButton alloc] initWithFrame:inboxRect];
    inboxButon.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:inboxButon];
	
	CGRect cameraRect = CGRectMake(177, 70, 29, 22);
	UIButton *cameraButon = [[UIButton alloc] initWithFrame:cameraRect];
    cameraButon.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:cameraButon];
	
	CGRect flickrRect = CGRectMake(208, 70, 29, 22);
	UIButton *flickrButon = [[UIButton alloc] initWithFrame:flickrRect];
    flickrButon.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:flickrButon];
	
	CGRect tumblrRect = CGRectMake(239, 70, 32, 22);
	UIButton *tumblrButon = [[UIButton alloc] initWithFrame:tumblrRect];
    tumblrButon.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:tumblrButon];
	
    return self;
}

-(void)changeButtonBackGroundColor:(id) sender
{
    [sender setBackgroundColor:[UIColor grayColor]];
}

- (void)resetButtonBackGroundColor: (UIButton*)sender {
    [sender setBackgroundColor:[UIColor clearColor]];
}

- (UIImage *)scale:(UIImage *)image toSize:(CGSize)size
{
	UIGraphicsBeginImageContext(size);
	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return scaledImage;
}


- (void) addToCell: (NSString *)title:  (NSString *)description: (NSString *)created: (UIImage *)image: (NSString*)imagePath{
	
	[self.nameLabel setText: title];
    [self.descriptionLabel setText:description];
    [self.dateLabel setText:created];
    self.filePath = imagePath;

    NSString *socialFlyerPath = [self.filePath stringByReplacingOccurrencesOfString:@"/Flyr/" withString:@"/Flyr/Social/"];
	NSString *finalImgWritePath = [socialFlyerPath stringByReplacingOccurrencesOfString:@".jpg" withString:@".soc"];

    NSArray *arr = [[NSArray alloc] initWithContentsOfFile:finalImgWritePath];
    NSLog(@"%@", arr);    

	//NSData *imageData = [NSData dataWithContentsOfMappedFile:imageName];
	//UIImage *currentFlyerImage = [UIImage imageWithData:imageData];  
	//currentFlyerImage = [currentFlyerImage imageByScalingAndCroppingForSize:CGSizeMake(100, 100)];
	//currentFlyerImage = [self scale:currentFlyerImage toSize:CGSizeMake(100,100)];
	//[self.cellImage setImage:[UIImage imageNamed:@"T0.Your device currently can’t connect to the internet. This may be due to cell signal or you may be in airplane mode."]];
	//NSData *jpegData = UIImageJPEGRepresentation(currentFlyerImage, 0.2);
	[self.cellImage setImage:image];
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

+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (void)dealloc {
    [super dealloc];
}




@end
