//
//  AssetGroupViewControllerWithSearchFeild.h
//  Flyr
//
//  Created by RIKSOF Developer on 8/5/14.
//
//

#import <UIKit/UIKit.h>
#import "NBUImagePickerPrivate.h"

@class ObjectGridView, NBUAssetsGroup;

@interface AssetGroupViewControllerWithSearchFeild : UIViewController

// The maximum number of assets that can be selected. Default `0` which means no limit.
@property (nonatomic) NSUInteger selectionCountLimit;
//A text feild to search images on shutterstock
@property ( nonatomic, strong ) IBOutlet UITextField *searchTextField;
// An ObjectGridView used to display shutterstock api objects.
@property (weak, nonatomic) IBOutlet ObjectGridView * gridView;
@property (nonatomic, assign, getter=isLoading)   BOOL loading;
/// The number of assets to be incrementally loaded. Default `100`, set to `0` to load all at once;
@property (nonatomic) NSUInteger loadSize;

@end
