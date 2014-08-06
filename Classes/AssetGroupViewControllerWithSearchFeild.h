//
//  AssetGroupViewControllerWithSearchFeild.h
//  Flyr
//
//  Created by RIKSOF Developer on 8/5/14.
//
//

#import <UIKit/UIKit.h>

@class ObjectGridView;

@interface AssetGroupViewControllerWithSearchFeild : UIViewController

//A text feild to search images on shutterstock
@property ( nonatomic, strong ) IBOutlet UITextField *searchTextField;
// An ObjectGridView used to display shutterstock api objects.
@property (weak, nonatomic) IBOutlet ObjectGridView * gridView;

@end
