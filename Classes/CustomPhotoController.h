//
//  CustomPhotoController.h
//  Flyr
//
//  Created by Rizwan Ahmad on 4/24/13.
//
//

#import <Foundation/Foundation.h>

@interface CustomPhotoController : UIViewController<UIScrollViewDelegate> {
    
    // Navigation bar state.
    BOOL    previosNavigationBarState;
    
    // Scroll view for image.
    UIScrollView *scrollView;
    
    // UIImageView
    UIImageView  *imageView;
    
    // The image to be cropped.
    UIImage      *image;
    
    // Report back the image.
    SEL callbackOnComplete;
    id  callbackObject;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) id callbackObject;
@property (nonatomic) SEL callbackOnComplete;

- (IBAction)onSelectImage:(UIButton *)sender;

@end