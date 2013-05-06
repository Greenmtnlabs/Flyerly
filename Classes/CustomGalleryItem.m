//
//  CustomGalleryItem.m
//  Flyr
//
//  Created by Rizwan Ahmad on 4/25/13.
//
//

#import "CustomGalleryItem.h"

@implementation CustomGalleryItem
@synthesize image1, image2, image3, image4, controller, imageName1, imageName2, imageName3, imageName4;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if([[touch view] isKindOfClass:[UIImageView class]]){
        
        if([touch view] == image1){
            [self findLargeImage:imageName1];
        } else if([touch view] == image2){
            [self findLargeImage:imageName2];
        } else if([touch view] == image3){
            [self findLargeImage:imageName3];
        } else if([touch view] == image4){
            [self findLargeImage:imageName4];
        }
        
        //UIImageView *imageView = (UIImageView *) [touch view];
        //controller.imageView.image = imageView.image;
        //controller.image = imageView.image;
    }
}

-(void)findLargeImage:(NSURL *)fileName {

    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset) {
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage];
        if (iref) {
            controller.imageView.image = [UIImage imageWithCGImage:iref scale:[rep scale] orientation:(UIImageOrientation)[rep orientation]];
            controller.image = controller.imageView.image;
            //[self.image retain];
        }
    };
    
    
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror) {
        NSLog(@"Cant get image - %@",[myerror localizedDescription]);
    };
    
    ALAssetsLibrary* assetslibrary = [[[ALAssetsLibrary alloc] init] autorelease];
    [assetslibrary assetForURL:fileName
                   resultBlock:resultblock
                  failureBlock:failureblock];
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
