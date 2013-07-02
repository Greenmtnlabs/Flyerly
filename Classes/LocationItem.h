//
//  LocationItem.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 6/28/13.
//
//

#import <UIKit/UIKit.h>

@interface LocationItem : UITableViewCell{

	IBOutlet UILabel *name;
	IBOutlet UILabel *address;

}

@property(nonatomic, retain) IBOutlet UILabel *name;
@property(nonatomic, retain) IBOutlet UILabel *address;

@end
