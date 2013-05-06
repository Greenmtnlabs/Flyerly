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

@property(nonatomic, retain) IBOutlet UIImageView *image1;
@property(nonatomic, retain) IBOutlet UIImageView *image2;
@property(nonatomic, retain) IBOutlet UIImageView *image3;
@property(nonatomic, retain) IBOutlet UIImageView *image4;
@property(nonatomic, retain) CustomPhotoController *controller;

@property(nonatomic, retain) NSURL *imageName1;
@property(nonatomic, retain) NSURL *imageName2;
@property(nonatomic, retain) NSURL *imageName3;
@property(nonatomic, retain) NSURL *imageName4;

//-(IBAction)selectImage:(UIButton *)sender;

@end
