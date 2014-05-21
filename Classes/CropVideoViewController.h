//
//  CropVideoViewController.h
//  Flyr
//
//  Created by Khurram Ali on 21/05/2014.
//
//

#import <UIKit/UIKit.h>

@interface CropVideoViewController : UIViewController

@property CGSize desiredVideoSize;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, copy) void (^onVideoFinished)(NSURL *);

@end
