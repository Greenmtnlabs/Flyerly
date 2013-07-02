//
//  LocationItem.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 6/28/13.
//
//

#import "LocationItem.h"

@implementation LocationItem
@synthesize name,address;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
