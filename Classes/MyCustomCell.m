//
//  MyCustomCell.m
//  Flyr
//
//  Created by Nilesh on 22/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MyCustomCell.h"
#import "FlyrAppDelegate.h"

@implementation MyCustomCell



#define LEFT_COLUMN_OFFSET		10
#define LEFT_COLUMN_WIDTH		220

#define UPPER_ROW_TOP			0

#define CELL_HEIGHT				100

@synthesize nameLabel, descriptionLabel, dateLabel, filePath, createLabel;
@synthesize cellImage,indicator;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
	
    [self setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bg_first"]]];
    
	CGRect tRect0 = CGRectMake(9, 12, 72, 77);
	cellImage = [[[UIButton alloc] initWithFrame:tRect0] autorelease];
	//cellImage.backgroundColor = [UIColor clearColor];
	//cellImage.opaque = NO;
	[self.contentView addSubview:cellImage];
	
	CGRect tRect2 = CGRectMake(98, 12, 195,10);
	nameLabel = [[UILabel alloc] initWithFrame:tRect2];
    [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11]];
    [nameLabel setTextColor:[MyCustomCell colorWithHexString:@"00628f"]];
    nameLabel.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:nameLabel];
	
	CGRect descriptionRect = CGRectMake(99, 17, 195,38.0f);
	descriptionLabel = [[UILabel alloc] initWithFrame:descriptionRect];
    descriptionLabel.numberOfLines = 2;
    [descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:9]];
    [descriptionLabel setTextColor:[UIColor darkTextColor]];
    descriptionLabel.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:descriptionLabel];
	
	CGRect createdRect = CGRectMake(100, 47, 35.0f,19);
	createLabel = [[UILabel alloc] initWithFrame:createdRect];
    [createLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:8]];
    [createLabel setTextColor:[UIColor darkTextColor]];
    [createLabel setText:@"Saved :"];
    createLabel.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:createLabel];
	
	CGRect dateRect = CGRectMake(133, 47, 195,19);
	dateLabel = [[UILabel alloc] initWithFrame:dateRect];
    [dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:8]];
    [dateLabel setTextColor:[UIColor darkTextColor]];
    dateLabel.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:dateLabel];	
	
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

- (void) addToCell: (NSString *)title:  (NSString *)description: (NSString *)created: (UIImage *)image: (NSString*)imagePath:  (int)flyerNumberParam{
	
	[self.nameLabel setText: title];
    [self.descriptionLabel setText:description];
    [self.dateLabel setText:created];
    self.filePath = imagePath;
    flyerNumber = flyerNumberParam;

    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];

    NSString *socialFlyerPath = [self.filePath stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/Flyr/",appDelegate.loginId] withString:[NSString stringWithFormat:@"%@/Flyr/Social/",appDelegate.loginId]];
	NSString *finalImgWritePath = [socialFlyerPath stringByReplacingOccurrencesOfString:@".jpg" withString:@".soc"];

    NSArray *arr = [[NSArray alloc] initWithContentsOfFile:finalImgWritePath];
   // NSLog(@"%@", arr);

    [self.cellImage setImage:image forState:UIControlStateNormal];
    
    CGRect facebookRect = CGRectMake(95, 68, 22, 22);
	UIButton *facebookButon = [[UIButton alloc] initWithFrame:facebookRect];
    facebookButon.backgroundColor = [UIColor clearColor];
    
    if([arr[0] isEqualToString:@"1"]){
        [facebookButon setImage:[UIImage imageNamed:@"facebook_share_saved"] forState:UIControlStateNormal];
        [createLabel setText:@"Shared:"];
    } else {
        [facebookButon setImage:[UIImage imageNamed:@"facebook_disabled_saved"] forState:UIControlStateNormal];
    }
    
    facebookButon.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	[self.contentView addSubview:facebookButon];
	
	CGRect twitterRect = CGRectMake(119, 68, 22, 22);
	UIButton *twitterButon = [[UIButton alloc] initWithFrame:twitterRect];
    twitterButon.backgroundColor = [UIColor clearColor];
    
    if([arr[1] isEqualToString:@"1"]){
        [twitterButon setImage:[UIImage imageNamed:@"twitter_share_saved"] forState:UIControlStateNormal];
        [createLabel setText:@"Shared:"];
    } else {
        [twitterButon setImage:[UIImage imageNamed:@"twitter_disabled_saved"] forState:UIControlStateNormal];
    }
    
    twitterButon.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	[self.contentView addSubview:twitterButon];
	
	CGRect inboxRect = CGRectMake(143, 68, 32, 22);
	UIButton *inboxButon = [[UIButton alloc] initWithFrame:inboxRect];
    inboxButon.backgroundColor = [UIColor clearColor];
    
    if([arr[2] isEqualToString:@"1"]){
        [inboxButon setImage:[UIImage imageNamed:@"email_share_saved"] forState:UIControlStateNormal];
        [createLabel setText:@"Shared:"];
    } else {
        [inboxButon setImage:[UIImage imageNamed:@"email_disabled_saved"] forState:UIControlStateNormal];
    }
    
    inboxButon.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	[self.contentView addSubview:inboxButon];
	
	CGRect cameraRect = CGRectMake(177, 68, 29, 22);
	UIButton *cameraButon = [[UIButton alloc] initWithFrame:cameraRect];
    cameraButon.backgroundColor = [UIColor clearColor];
    
    if([arr[5] isEqualToString:@"1"]){
        [cameraButon setImage:[UIImage imageNamed:@"instagram_share_saved"] forState:UIControlStateNormal];
        [createLabel setText:@"Shared:"];
    } else {
        [cameraButon setImage:[UIImage imageNamed:@"instagram_disabled_saved"] forState:UIControlStateNormal];
    }
    
    cameraButon.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	[self.contentView addSubview:cameraButon];
	
	CGRect flickrRect = CGRectMake(208, 68, 29, 22);
	UIButton *flickrButon = [[UIButton alloc] initWithFrame:flickrRect];
    flickrButon.backgroundColor = [UIColor clearColor];
    
    if([arr[4] isEqualToString:@"1"]){
        [flickrButon setImage:[UIImage imageNamed:@"flickr_share_saved"] forState:UIControlStateNormal];
        [createLabel setText:@"Shared:"];
    } else {
        [flickrButon setImage:[UIImage imageNamed:@"flickr_disabled_saved"] forState:UIControlStateNormal];
    }
    
    flickrButon.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	[self.contentView addSubview:flickrButon];
	
	CGRect tumblrRect = CGRectMake(239, 68, 32, 22);
	UIButton *tumblrButon = [[UIButton alloc] initWithFrame:tumblrRect];
    tumblrButon.backgroundColor = [UIColor clearColor];
    
    if([arr[3] isEqualToString:@"1"]){
        [tumblrButon setImage:[UIImage imageNamed:@"tumblr_share_saved"] forState:UIControlStateNormal];
        [createLabel setText:@"Shared:"];
    } else {
        [tumblrButon setImage:[UIImage imageNamed:@"tumblr_disabled_saved"] forState:UIControlStateNormal];
    }
    
    tumblrButon.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	[self.contentView addSubview:tumblrButon];
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





@end
