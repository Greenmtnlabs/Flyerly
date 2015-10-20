//
//  GiphyViewController.h
//  Flyr
//
//  Created by Abdul Rauf on 20/10/2015.
//
//

#import <UIKit/UIKit.h>
#import "Flyer.h"

@interface GiphyViewController : UIViewController{
    UIBarButtonItem  *rightBarButtonItem;
    UIBarButtonItem  *leftBarButtonItem;
}

@property (strong, nonatomic) IBOutlet UIScrollView *layerScrollView;
@property (nonatomic,strong) Flyer *flyer;
@property (nonatomic,strong) NSString *tasksAfterGiphySelect;

//A text feild to search images on shutterstock
@property ( nonatomic, strong ) IBOutlet UISearchBar *searchTextField;

@end
