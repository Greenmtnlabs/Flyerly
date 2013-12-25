//
//  CustomPhotoController.h
//  Flyr
//
//  Created by Rizwan Ahmad on 4/24/13.
//
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>


@interface CustomPhotoController : UIViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource> {
    
    IBOutlet UITableView *galleryTable;
    //NSMutableArray *deviceContactItems;

    // Navigation bar state.
    BOOL    previosNavigationBarState;
    
    // Scroll view for image.
    UIScrollView *scrollView;
    
    // UIImageView
    UIImageView  *imageView;
    
    // Move up view.
    UIImageView      *moveUpButton;
    
    // Report back the image.
    SEL callbackOnComplete;
    id  callbackObject;
    int counter;
    
    ALAssetsLibrary *library;
    //NBUAsset *library;
}

@property (nonatomic, strong) IBOutlet UITableView *galleryTable;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIImageView *moveUpButton;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) id callbackObject;
@property (nonatomic) SEL callbackOnComplete;


-(IBAction)onSelectImage:(UIButton *)sender;
-(void)goBack;
@end