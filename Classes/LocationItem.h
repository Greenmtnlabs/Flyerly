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

@property(nonatomic, strong) IBOutlet UILabel *name;
@property(nonatomic, strong) IBOutlet UILabel *address;

@end
