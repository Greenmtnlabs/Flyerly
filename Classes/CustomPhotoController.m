//
//  CustomPhotoController.m
//  Flyr
//
//  Created by Rizwan Ahmad on 4/24/13.
//
//

#import "CustomPhotoController.h"
#import "CustomGalleryItem.h"
#import "Common.h"
#import "PhotoController.h"

//#define IMAGE_HEIGHT 204
//#define IMAGE_WIDTH  204
#define IMAGE_HEIGHT 309
#define IMAGE_WIDTH  320
@implementation CustomPhotoController
@synthesize scrollView, imageView, image, callbackObject, callbackOnComplete, galleryTable, moveUpButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Set the size of the scrollview.
        
    }
    return self;
}

- (void)dealloc {
    //[deviceContactItems release];
    [galleryTable release];
    [scrollView release];
    [imageView release];
    //[image release];
    [moveUpButton release];
    [callbackObject release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Image Preparation

// Code from: http://discussions.apple.com/thread.jspa?messageID=7949889
- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    int kMaxResolution = 640; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
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

#pragma mark - Process Image Crop

- (IBAction)onSelectImage:(UIButton *)sender{
    
    //NSLog(@"Width: %f",image.size.width);
    //NSLog(@"Height: %f",image.size.height);
    //NSLog(@"Scroll Height: %f",scrollView.frame.size.height);

    /*if(IS_IPHONE_5){
        //image = [PhotoController imageWithImage:image scaledToSize:CGSizeMake(IMAGE_WIDTH - 135, IMAGE_HEIGHT+50)];
        //image = [PhotoController imageWithImage:image scaledToSize:CGSizeMake(240, 340)];
    }else{
        //image = [PhotoController imageWithImage:image scaledToSize:CGSizeMake(480, 480)];
    }*/
    
    // Get the content offset in scroll view.
    CGPoint scrollOffset = CGPointMake(
                                       scrollView.contentOffset.x + ((320 - IMAGE_WIDTH) / 2),
                                       scrollView.contentOffset.y + ((scrollView.frame.size.height - IMAGE_HEIGHT) /2));
    
    // Get the offset of the image.
    CGPoint imageOffset = CGPointMake( imageView.frame.origin.x,
                                      imageView.frame.origin.y);
    
    // Create rectangle that represents a cropped image
    // from the middle of the current view.
    float deltaX = ( scrollOffset.x - imageOffset.x ) / scrollView.zoomScale;
    float deltaY = ( scrollOffset.y - imageOffset.y ) / scrollView.zoomScale;
    float imageWidth = ( IMAGE_WIDTH + (( deltaX < 0 ) ? deltaX : 0 ) ) / scrollView.zoomScale;
    float imageHeight = ( IMAGE_HEIGHT + (( deltaY < 0 ) ? deltaY : 0) ) / scrollView.zoomScale;
    
    // If the delta is negative, then make it zero, we have already adjusted
    // the width and height above.
    deltaX = (deltaX < 0) ? 0 : deltaX;
    deltaY = (deltaY < 0) ? 0 : deltaY;
    
    //NSLog(@"Delta X: %f",deltaX);
    //NSLog(@"Delta Y: %f",deltaY);
    //NSLog(@"Image Width 2: %f",imageWidth);
    //NSLog(@"Image Height 2: %f",imageHeight);
    //NSLog(@"Scroll Zoom: %f",scrollView.zoomScale);

    CGRect rect = CGRectMake(deltaX,
                             deltaY,
                             imageWidth, imageHeight);
    
    // Create bitmap image from original image data,
    // using rectangle to specify desired crop area
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *img = [UIImage imageWithCGImage:imageRef
                                       scale:scrollView.zoomScale
                                 orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    
    // Pass the image to callback function.
    [callbackObject performSelector:callbackOnComplete withObject:img];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //UIGestureRecognizer *gesture = [[[UIGestureRecognizer alloc] initWithTarget:self action:@selector(increaseHeight:)] autorelease];
    //gesture.delegate = self;
    //[moveUpButton addGestureRecognizer:gesture];
    
    // Do any additional setup after loading the view from its nib.
    UIImage *tmpImage = [self scaleAndRotateImage:image];
    [image release];
    image = [tmpImage retain];
    
    // Get the size of the image.
    CGSize imageSize = [image size];
    
    // Content size for scrollview needs to be twice this size.
    CGSize contentSize = CGSizeMake(imageSize.width, imageSize.height);
    [scrollView setContentSize:contentSize];
    
    // Center on the scroll view.
    [scrollView setContentOffset:CGPointMake((contentSize.width - self.view.frame.size.width) / 2,
                                             (contentSize.height - self.view.frame.size.height) / 2)];
    
    // Set the image and frame of image view so that the image is centered in
    // the scroll view.
    [imageView setImage:self.image];
    [imageView setFrame:CGRectMake((contentSize.width - imageSize.width)/2,
                                   (contentSize.height - imageSize.height)/2,
                                   imageSize.width, imageSize.height)];
    
    //[self loadAllGalleryPhotos];
    [self imageCount];
}

BOOL galleryExpanded = NO;

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *anyTouch = [touches anyObject];
    
    if ((anyTouch.view == moveUpButton)){
        
        if(!galleryExpanded){

            CGPoint location = [anyTouch locationInView:self.view];
            CGPoint prevLocation = [anyTouch previousLocationInView:self.view];
            
            if (prevLocation.y > location.y){
                moveUpButton.frame = CGRectMake(moveUpButton.frame.origin.x, 133, moveUpButton.frame.size.width, moveUpButton.frame.size.height);
                
                galleryTable.frame = CGRectMake(galleryTable.frame.origin.x, 176, galleryTable.frame.size.width, 384);
                
            }
            galleryExpanded = YES;
            
        } else {
            
            CGPoint location = [anyTouch locationInView:self.view];
            CGPoint prevLocation = [anyTouch previousLocationInView:self.view];
            
            if (prevLocation.y < location.y){
                moveUpButton.frame = CGRectMake(moveUpButton.frame.origin.x, 333, moveUpButton.frame.size.width, moveUpButton.frame.size.height);
                
                galleryTable.frame = CGRectMake(galleryTable.frame.origin.x, 376, galleryTable.frame.size.width, 184);
                
            }            
            galleryExpanded = NO;    
        }
    }
}

/*
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch locationInView:self.view].y - [touch previousLocationInView:self.view].y > 0){
        moveUpButton.frame = CGRectMake(moveUpButton.frame.origin.x, 133, moveUpButton.frame.size.width, moveUpButton.frame.size.height);
        
        galleryTable.frame = CGRectMake(galleryTable.frame.origin.x, 176, galleryTable.frame.size.width, galleryTable.frame.size.height + 200);
        return YES;
    }
    
    // Disallow recognition of tap gestures in the segmented control.
    //if ((touch.view == moveUpButton)) {//change it to your condition
    //
    //}
    return YES;
}
*/

- (void)viewWillAppear:(BOOL)animated {
    // Remember the state so that we may revert once we leave this screen.
    //previosNavigationBarState = self.navigationController.navigationBarHidden;
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Crop" style:UIBarButtonItemStyleDone target:self action:@selector(onSelectImage:)];
    
    [self.navigationItem setRightBarButtonItem:rightBarButton];

    self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"SCALE & CROP"];
}

- (void)viewWillDisappear:(BOOL)animated {
    // Revert to how the navigation bar was before we showed up.
    //self.navigationController.navigationBarHidden = previosNavigationBarState;
    [super viewWillDisappear:animated];
}

#pragma mark UIScrollViewDelegate

/**
 * Support for zooming.
 */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    
    // Get the size of the image.
    CGSize imageSize = [image size];
    
    // Content size for scrollview needs to be twice this size.
    CGSize contentSize = CGSizeMake(self.view.frame.size.width + (imageSize.width * scale), self.view.frame.size.height + ( imageSize.height * scale));
    [self.scrollView setContentSize:contentSize];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // since we have four images in single row we have to divide it by 4
    int count = counter/4;
    counter =  0;

    return count;
}

int counter = 0;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellId = @"CustomGalleryItem";
    
    // Get cell
    CustomGalleryItem *cell = (CustomGalleryItem *) [tableView dequeueReusableCellWithIdentifier:cellId];

    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil];
        cell=(CustomGalleryItem *)[nib objectAtIndex:0];
    }
    
    cell.controller = self;
    
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    //    dispatch_async(dispatch_get_main_queue(), ^{
            [self load4ImagesAtaTime:indexPath.row cell:cell];
    //    });
    //});

    // return cell
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 93.0;
}

-(void)imageCount{
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];    
    
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos                                                                   usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        // Within the group enumeration block, filter to enumerate just photos.
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];       
        

        [group enumerateAssetsUsingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
            
            // The end of the enumeration is signaled by asset == nil.
            if (alAsset) {
            
                counter++;
                
            } else {
            
                NSLog(@"photos count:%d", counter);                
                [self.galleryTable reloadData];

            }
        }];
    }
                         failureBlock: ^(NSError *error) {
                             // Typically you should handle an error more gracefully than this.
                             NSLog(@"No groups");
                         }];
}

-(void)load4ImagesAtaTime:(int)rowNumber cell:(CustomGalleryItem *)cell {
    
    ALAssetsLibrary *library = [[[ALAssetsLibrary alloc] init] autorelease];

    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos                                                                   usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        // Within the group enumeration block, filter to enumerate just photos.
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        __block int imageCounter = 0;
        for(int i=(rowNumber * 4); i<(rowNumber * 4) + 4; i++){

            // Chooses the photo at the last index
            //NSLog(@"group.numberOfAssets: %d", group.numberOfAssets);
            
            if(group.numberOfAssets != 0){
                [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:((group.numberOfAssets - 1) - i)] options:0 usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
                    
                    // The end of the enumeration is signaled by asset == nil.
                    if (alAsset) {
                        
                        ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                        
                        if(imageCounter == 0){
                            [cell.image1 setImage:[UIImage imageWithCGImage:[alAsset thumbnail]]];
                            cell.imageName1 = [representation url];
                            //[cell.image1 setImage:[self thumbnailForAsset:alAsset maxPixelSize:90]];
                        } else if(imageCounter == 1){
                            [cell.image2 setImage:[UIImage imageWithCGImage:[alAsset thumbnail]]];
                            cell.imageName2 = [representation url];
                        } else if(imageCounter == 2){
                            [cell.image3 setImage:[UIImage imageWithCGImage:[alAsset thumbnail]]];
                            cell.imageName3 = [representation url];
                        } else if(imageCounter == 3){
                            [cell.image4 setImage:[UIImage imageWithCGImage:[alAsset thumbnail]]];
                            cell.imageName4 = [representation url];
                        }
                        
                        imageCounter++;
                    }
                }];
            }
        }

    } failureBlock: ^(NSError *error) {
        // Typically you should handle an error more gracefully than this.
        NSLog(@"No groups");
    }];
}

NSMutableArray *photoArray;
-(void)loadAllGalleryPhotos{

    ALAssetsLibrary *al = [[ALAssetsLibrary alloc] init];
    photoArray = [[NSMutableArray alloc] init];
    
    [al enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
         [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
             
             if (asset) {
                 [photoArray addObject:[UIImage imageWithCGImage:[asset aspectRatioThumbnail]]];
                 NSLog(@"%d",photoArray.count);
              }
          }];
     }failureBlock:^(NSError *error) {
     }] ;
}

- (UIImage *)thumbnailForAsset:(ALAsset *)asset maxPixelSize:(NSUInteger)size {
    NSParameterAssert(asset != nil);
    NSParameterAssert(size > 0);
    
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    
    CGDataProviderDirectCallbacks callbacks = {
        .version = 0,
        .getBytePointer = NULL,
        .releaseBytePointer = NULL,
        .getBytesAtPosition = getAssetBytesCallback,
        .releaseInfo = releaseAssetCallback,
    };
    
    CGDataProviderRef provider = CGDataProviderCreateDirect((void *)CFBridgingRetain(rep), [rep size], &callbacks);
    CGImageSourceRef source = CGImageSourceCreateWithDataProvider(provider, NULL);
    
    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(source, 0, (__bridge CFDictionaryRef) @{
                                                              (NSString *)kCGImageSourceCreateThumbnailFromImageAlways : @YES,
                                                              (NSString *)kCGImageSourceThumbnailMaxPixelSize : [NSNumber numberWithInt:size],
                                                              (NSString *)kCGImageSourceCreateThumbnailWithTransform : @YES,
                                                              });
    CFRelease(source);
    CFRelease(provider);
    
    if (!imageRef) {
        return nil;
    }
    
    UIImage *toReturn = [UIImage imageWithCGImage:imageRef];
    
    CFRelease(imageRef);
    
    return toReturn;
}

// Helper methods for thumbnailForAsset:maxPixelSize:
static size_t getAssetBytesCallback(void *info, void *buffer, off_t position, size_t count) {
    ALAssetRepresentation *rep = (__bridge id)info;
    
    NSError *error = nil;
    size_t countRead = [rep getBytes:(uint8_t *)buffer fromOffset:position length:count error:&error];
    
    if (countRead == 0 && error) {
        // We have no way of passing this info back to the caller, so we log it, at least.
        NSLog(@"thumbnailForAsset:maxPixelSize: got an error reading an asset: %@", error);
    }
    
    return countRead;
}

static void releaseAssetCallback(void *info) {
    // The info here is an ALAssetRepresentation which we CFRetain in thumbnailForAsset:maxPixelSize:.
    // This release balances that retain.
    CFRelease(info);
}

@end