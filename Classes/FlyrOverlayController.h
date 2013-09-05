//
//  FlyrOverlayController.h
//  Flyr
//
//  Created by Khurram on 05/09/2013.
//
//

#import <UIKit/UIKit.h>
#import "FlyrViewController.h"


@class FlyrViewController;

@interface FlyrOverlayController : UIViewController{

    FlyrViewController *rvController;

}

@property (nonatomic, retain) FlyrViewController *rvController;

@end



