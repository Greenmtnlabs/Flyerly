//
//  FreeFeaturesTableViewCell.h
//  Flyr
//
//  Created by RIKSOF Developer on 5/21/14.
//
//

#import <UIKit/UIKit.h>

@interface FreeFeatureCell : UITableViewCell

@property(nonatomic, retain)IBOutlet UILabel *featureName;
@property(nonatomic, retain)IBOutlet UILabel *featureDesc;

-(void)setCellValueswithProductTitle :(NSString *)title ProductDescription: (NSString *)description;

@end
