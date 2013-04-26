//
//  CustomGalleryItem.m
//  Flyr
//
//  Created by Rizwan Ahmad on 4/25/13.
//
//

#import "CustomGalleryItem.h"

@implementation CustomGalleryItem
@synthesize image1, image2, image3, image4, controller;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if([[touch view] isKindOfClass:[UIImageView class]]){
        UIImageView *imageView = (UIImageView *) [touch view];
        controller.imageView.image = imageView.image;
        controller.image = imageView.image;
        //[imageView release];
    }
}

- (void)dealloc
{
    [image1  release];
    [image2  release];
    [image3  release];
    [image4  release];
    [controller release];
    [super dealloc];
}
@end
