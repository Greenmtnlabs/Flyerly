//
//  CustomGalleryItem.m
//  Flyr
//
//  Created by Rizwan Ahmad on 4/25/13.
//
//

#import "CustomGalleryItem.h"
#import "PhotoController.h"
#import "Common.h"

@implementation CustomGalleryItem
@synthesize image1, image2, image3, image4, controller, imageName1, imageName2, imageName3, imageName4;



-(void)findLargeImage:(NSURL *)fileName {
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset) {
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage];
        if (iref) {
            
            UIImage *galleryImage = [UIImage imageWithCGImage:iref scale:[rep scale] orientation:(UIImageOrientation)[rep orientation]];
           // NSLog(@"%f", galleryImage.size.width);
           // NSLog(@"%f", galleryImage.size.height);
            float wid = galleryImage.size.width /2;
            float hgt = galleryImage.size.height /2;
            //NSLog(@"%f", wid);
           // NSLog(@"%f", hgt);
            if (wid <= 320){
                if (wid <= 320) wid = 320;
                galleryImage = [PhotoController imageWithImage:galleryImage scaledToSize:CGSizeMake(wid, hgt)];
            
            }else{
                hgt = 285;
                galleryImage = [PhotoController imageWithImage:galleryImage scaledToSize:CGSizeMake(wid, hgt)];
            }
            /*
            if(IS_IPHONE_5){
                galleryImage = [PhotoController imageWithImage:galleryImage scaledToSize:CGSizeMake(wid, 280)];
            }else{
                galleryImage = [PhotoController imageWithImage:galleryImage scaledToSize:CGSizeMake(480, 480)];
            }
             */
            controller.imageView.image = galleryImage;
            controller.image = controller.imageView.image;
            CGSize imageSize = [galleryImage size];
            galleryImage = [self scaleAndRotateImage:galleryImage size:imageSize];
            
            
            
            controller.scrollView.minimumZoomScale = 1.0;
            /*
            // Center on the scroll view.
            CGFloat offsetX = (imageSize.width - controller.scrollView.frame.size.width) / 2;
            offsetX = ( offsetX > 0 ) ? offsetX : 0;
            
            CGFloat offsetY = (imageSize.height - controller.scrollView.frame.size.height) / 2;
            offsetY = ( offsetY > 0 ) ? offsetY : 0;
            
            [controller.scrollView setContentOffset:CGPointMake( offsetX, offsetY )];
            
            // Set the image and frame of image view so that the image is centered in
            // the scroll view.
            
            */
            
            // Get the size of the image.
            
             // Content size for scrollview needs to be twice this size.
               CGSize contentSize = [galleryImage size];
             [controller.scrollView setContentSize:contentSize];
             
             // Center on the scroll view.
             //[controller.scrollView setContentOffset:CGPointMake((contentSize.width - controller.view.frame.size.width) / 2,
             //(contentSize.height - controller.view.frame.size.height) / 2)];
             
             // Set the image and frame of image view so that the image is centered in
          
            // the scroll view.
           // CGSize contentSize = CGSizeMake(imageSize.width, imageSize.height);
            [controller.imageView setImage:galleryImage];
            [controller.imageView setFrame:CGRectMake((contentSize.width - imageSize.width)/2,
                                                      (contentSize.height - imageSize.height)/2,
                                                      imageSize.width, imageSize.height)];
            
            controller.image = controller.imageView.image;
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
- (UIImage *)scaleAndRotateImage:(UIImage *)img size:(CGSize)size {
    int kMaxWidth = size.width ; // Or whatever
    int kMaxHeight = size.height  ;
    
    CGImageRef imgRef = img.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if ( width > kMaxWidth || height > kMaxHeight ) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxWidth;
            bounds.size.height = roundf( kMaxWidth / ratio);
        }
        else {
            bounds.size.height = kMaxHeight;
            bounds.size.width = roundf( kMaxHeight * ratio );
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = img.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}




/*
- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    int kMaxResolution = 320; // Or whatever
    int kMaxHeight = 290;
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxHeight) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxHeight;
            bounds.size.width = roundf(kMaxHeight * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}
 */



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
