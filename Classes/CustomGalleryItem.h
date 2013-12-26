//
//  CustomGalleryItem.h
//  Flyr
//
//  Created by Rizwan Ahmad on 4/25/13.
//
//

#import <Foundation/Foundation.h>
#import "CustomPhotoController.h"

@interface CustomGalleryItem : UITableViewCell {
	IBOutlet UIImageView *image1;
	IBOutlet UIImageView *image2;
	IBOutlet UIImageView *image3;
	IBOutlet UIImageView *image4;
    
    NSURL *imageName1;
    NSURL *imageName2;
    NSURL *imageName3;
    NSURL *imageName4;
    
    CustomPhotoController *controller;
}

@property(nonatomic, strong) IBOutlet UIImageView *image1;
@property(nonatomic, strong) IBOutlet UIImageView *image2;
@property(nonatomic, strong) IBOutlet UIImageView *image3;
@property(nonatomic, strong) IBOutlet UIImageView *image4;
@property(nonatomic, strong) CustomPhotoController *controller;

@property(nonatomic, strong) NSURL *imageName1;
@property(nonatomic, strong) NSURL *imageName2;
@property(nonatomic, strong) NSURL *imageName3;
@property(nonatomic, strong) NSURL *imageName4;

//-(IBAction)selectImage:(UIButton *)sender;

@end
