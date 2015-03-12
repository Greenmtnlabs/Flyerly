//
//  ESBoardBuilderViewController.m
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 2/27/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIImage-Categories/UIImage+Resize.h>
#import <FlurrySDK/Flurry.h>
#import "ESBoardBuilderViewController.h"
#import "ESBoard.h"
#import "ESTile.h"
#import "ESAppDelegate.h"
#import "UICollectionViewController+ESBackgroundView.h"
#import "NSURL+ESUtilities.h"
#import "UIAlertView+ESShorthand.h"
#import "ESPagination.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED == __IPHONE_OS_VERSION_MAX_ALLOWED == __IPHONE_6_0
#import "UIImagePickerController+NonRotatingFor6Point0.h"
#endif

static NSString * const kESBoardValidationErrorDomain = @"com.greenmtnthink.boardvalidation.domain";
static NSString * const kESBoardValidationErrorMessageKey = @"com.greenmtnthink.boardvalidation.key";
static NSString * const kESBoardBuilderTakeAPhotoTitle = @"Take a Photo";
static NSString * const kESBoardBuilderCameraRollTitle = @"Pick from Camera Roll";
static NSInteger kESBoardBuilderChangeCoverImageIndex = -1;

@interface ESBoardBuilderViewController () <UIAlertViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, ESPaginationDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, assign) NSInteger selectedTileIndex;
@property (nonatomic, weak) UIView *selectedViewForImagePopups;
@property (nonatomic, strong) UIPopoverController *imagePickerPopoverController;
@property (nonatomic, strong) ESPagination *paginationHelper;

@end

@implementation ESBoardBuilderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    self.managedObjectContext.parentContext = [[ESAppDelegate sharedAppDelegate] persistingManagedObjectContext];
    NSUInteger existingBoardCount = [[ESBoard allBoards:self.managedObjectContext.parentContext] count];
    if (self.board) {
        // use the new MOC
        self.board = (ESBoard *)[self.managedObjectContext existingObjectWithID:self.board.objectID error:nil];
    } else {
        self.board = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([ESBoard class])
                                                   inManagedObjectContext:self.managedObjectContext];
        self.board.isAvailable = YES;
        self.board.isCustom = YES;
        self.board.index = existingBoardCount;
        self.board.title = nil;
        self.board.thumbnailPath = nil;
        
        for (NSInteger i = 0, n = [self.board maximumNumberOfTiles]; i < n; i++) {
            ESTile *tile = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([ESTile class])
                                                         inManagedObjectContext:self.managedObjectContext];
            tile.index = i;
            tile.imagePath = nil;
            NSMutableOrderedSet *set = [self.board mutableOrderedSetValueForKey:@"tiles"];
            [set addObject:tile];
        }
    }
    [self es_useDefaultBackgroundView];
    [self es_addTitleLabelToBackgroundView];
    [self refreshTitle];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDoSomething:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDoSomething:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    if (IS_IPHONE) {
        [self setupPagingButtons];
        NSArray *pagingButtons = @[self.leftPagingButton, self.rightPagingButton];
        self.paginationHelper = [[ESPagination alloc] initWithPagingButtons:pagingButtons
                                                               itemsPerPage:[ESPagination standardNumberOfItemsPerPage]
                                                                  itemCount:15];
        self.paginationHelper.delegate = self;
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.leftPagingButton.hidden = self.rightPagingButton.hidden = NO;
//    self.paginationHelper.currentPageIndex = 0;
}

- (void)keyboardWillDoSomething:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGRect myFrame = self.collectionView.frame;
    CGRect keyboardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    BOOL isLandscape = UIInterfaceOrientationIsLandscape([[UIDevice currentDevice] orientation]);
    BOOL isLandscape = UIDeviceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
    BOOL keyboardIsShowing = [notification.name isEqualToString:UIKeyboardWillShowNotification];
    
    CGFloat  yDelta = (keyboardFrame.size.width == 568) ? keyboardFrame.size.height : keyboardFrame.size.width;
    
    yDelta *= (keyboardIsShowing) ? -1 : 1;
    myFrame.origin.y += yDelta;
    
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = (UIViewAnimationCurve)[[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:(UIViewAnimationOptions)animationCurve
                     animations:^{
                         self.collectionView.frame = myFrame;
                     }
                     completion:nil];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers
- (BOOL)validateAndInformUser:(BOOL)showErrorsToUser
{
    NSError __autoreleasing *error;
    BOOL isValid = [self validateBoard:&error];
    if (isValid) {
        return YES;
    } else {
        if (showErrorsToUser) {
            NSString *msg = [[error userInfo] objectForKey:kESBoardValidationErrorMessageKey];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Can't save board"
                                                                message:msg
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        return NO;
    }
}

- (BOOL)validateBoard:(NSError __autoreleasing **)error
{
    NSString *msg = nil;
    
    if (!self.board.title) {
        msg = @"Enter a title for your board."; goto invalidboard;
    } else if (!self.board.thumbnailURL) {
        msg = @"Select a cover image for your board."; goto invalidboard;
    }
    
    NSInteger tileIndex = 0;
    for (ESTile *tile in self.board.tiles) {
        if (!tile.imageURL) {
            msg = [NSString stringWithFormat:@"Tile #%d needs an image.", tileIndex+1];
            goto invalidboard;
        }
        tileIndex++;
    }
    return YES;
    
invalidboard:
    *error = [NSError errorWithDomain:kESBoardValidationErrorDomain
                                 code:-1
                             userInfo:@{kESBoardValidationErrorMessageKey: msg}];
    return NO;
    
}

- (void)refreshTitle
{
    NSString *title = (self.board.title && [self.board.title length] > 0) ? self.board.title : @"New Board";
    self.es_titleLabel.text = title;
}

- (void)refreshThumbnail
{
    [self.collectionView reloadData];
}

- (void)saveWithCompletionBlock:(ESCompletionBlock)completion
{
    NSManagedObjectContext *childContext = self.managedObjectContext, *parentContext = childContext.parentContext;
    if (NULL == completion) {
        completion = ^(BOOL success, id result) {};
    }
    
    [childContext performBlock:^{
        NSError *error = nil;
        BOOL childSuccess = [childContext save:&error];
        
        if (!childSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(NO, error);
            });
        } else {
            [parentContext performBlock:^{
                NSError *parentError = nil;
                BOOL parentSuccess = [parentContext save:&parentError];
                completion(parentSuccess, parentError);
            }];
        }
    }];
}

- (ESTile *)tileAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger i = (IS_IPAD) ? indexPath.item : [self.paginationHelper adjustedItemIndexForIndexPath:indexPath];
    return self.board.tiles[i];
}

- (BOOL)hasTileAtIndexPath:(NSIndexPath *)indexPath
{
    int i = [self.paginationHelper adjustedItemIndexForIndexPath:indexPath];
    return (i < [self.board.tiles count]);
}

- (void)adjustFooter:(UICollectionReusableView *)footerView
{
    if (!IS_IPHONE) return;
    
    for (NSLayoutConstraint *constraint in [footerView constraints]) {
        /* I'd use an outlet if I could, but I can't because footer is a reuseable view.
         * This is a gigantic hack. :( */
        if (17 == constraint.constant && IS_IPHONE5) { // space between back button and save button background
            constraint.constant = 65.0;
        }
    }
}

#pragma mark - Actions

- (IBAction)editTitle:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Rename Title"
                                                        message:@"Enter the board's new title below."
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.text = self.board.title;
    [alertView show];
}

- (IBAction)editThumbnail:(id)sender
{
    self.selectedTileIndex = kESBoardBuilderChangeCoverImageIndex;
    self.selectedViewForImagePopups = sender;
    [self showImagePickerActionSheet];
}

- (IBAction)saveBoard:(id)sender {
    BOOL isFirstSave = [self.board.objectID isTemporaryID];
    __weak ESBoardBuilderViewController *weakSelf = self;

    if ([self validateAndInformUser:YES]) {
        [self saveWithCompletionBlock:^(BOOL success, id result) {
            if (success && isFirstSave) {
                [Flurry logEvent:kESEventTagForBoardCreation
                  withParameters:@{@"board" : weakSelf.board.title}];
            }
            
            if (success)  {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"Your board has been saved!"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Couldn't save board"
                                                                    message:@"We had a problem saving the board."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
                if (result && [result isKindOfClass:[NSError class]]) {
                    [Flurry logError:kESEventTagForCoreDataError
                             message:@"Error saving board"
                               error:result];
                }
            }

        }];
    }
}

- (IBAction)back:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (IS_IPAD) ?  [self.board.tiles count] : [self.paginationHelper itemsPerPage];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ESTile *tile = nil;
    if ([self hasTileAtIndexPath:indexPath]) {
        tile = [self tileAtIndexPath:indexPath];
    }
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ESTileCell"
                                                                           forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:3];
    if (nil == tile) {
        imageView.image = nil;
        imageView.layer.cornerRadius = 0.0;
        imageView.layer.borderWidth = 0.0;
        imageView.layer.masksToBounds = NO;
    } else if (nil == tile.imageURL) {
        imageView.image = [UIImage imageNamed:@"Design your own_with kid_icon"];
        imageView.layer.cornerRadius = 0.0;
        imageView.layer.borderWidth = 0.0;
        imageView.layer.masksToBounds = NO;
    } else {
        UIColor *borderColor = [UIColor colorWithRed:0.14 green:0.61 blue:0.79 alpha:1.0];
        imageView.image = [UIImage imageWithContentsOfFile:[tile.imageURL path]];
        imageView.layer.cornerRadius = 4.0;
        imageView.layer.borderColor = [borderColor CGColor];
        imageView.layer.borderWidth = 5.0;
        imageView.layer.masksToBounds = YES;
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier;
    if (kind == UICollectionElementKindSectionHeader ) {
        reuseIdentifier = @"ESBoardHeaderView";
    } else if (kind == UICollectionElementKindSectionFooter) {
        reuseIdentifier = @"ESBoardFooterView";
    }
    
    UICollectionReusableView *reuseableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                 withReuseIdentifier:reuseIdentifier
                                                                                        forIndexPath:indexPath];
    if (kind == UICollectionElementKindSectionFooter ) {
        [self adjustFooter:reuseableView];
        UIImageView *thumbnailImageView = (UIImageView *)[reuseableView viewWithTag:100];
        if (self.board.thumbnailURL) {
            thumbnailImageView.image = [UIImage imageWithContentsOfFile:[self.board.thumbnailURL path]];
        } else {
            thumbnailImageView.image = nil;
        }
        
        UITextField *titleTextField = (UITextField *)[reuseableView viewWithTag:101];
        titleTextField.text = self.board.title;
    }
    
    return reuseableView;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self hasTileAtIndexPath:indexPath]) return; /* user tapped a spacer tile */
    self.selectedTileIndex = (IS_IPAD) ? indexPath.item : [self.paginationHelper adjustedItemIndexForIndexPath:indexPath];
    self.selectedViewForImagePopups = [collectionView cellForItemAtIndexPath:indexPath];;
    [self showImagePickerActionSheet];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.delegate) {
        [self.delegate boardDidSave:self.board];
    } else {
        [self.presentingViewController dismissViewControllerAnimated:YES
                                                          completion:NULL];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return;
    } else {
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        [self showImagePickerControllerUsingActionSheetTitle:title];
    }
}

//#pragma mark - UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == [alertView cancelButtonIndex]) {
//        return;
//    } else {
//        UITextField *textField = [alertView textFieldAtIndex:0];
//        self.board.title = textField.text;
//        [self refreshTitle];
//    }
//}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    BOOL isFromCameraRoll = !![info objectForKey:UIImagePickerControllerReferenceURL];
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    UIImage *image = (editedImage) ? editedImage : originalImage;
//    UIImage *croppedImage = [image thumbnailImage:200
//                                transparentBorder:0
//                                     cornerRadius:0
//                             interpolationQuality:kCGInterpolationHigh];
    
    /* First we make the image square by cropping it around the center. */
    NSLog(@"%f" , image.size.width);
    NSLog(@"%f" , image.size.height);
    CGFloat largeImageSize = MIN(image.size.width, image.size.height);
    CGRect cropRect = CGRectMake(round((image.size.width - largeImageSize) / 2),
                                 round((image.size.height - largeImageSize) / 2),
                                 largeImageSize,
                                 largeImageSize);
    UIImage *croppedImage = [image croppedImage:cropRect];

    /* Then we shrink it. */
    CGFloat thumbnailSize = 200;
    UIImage *resizedImage = [croppedImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                                        bounds:CGSizeMake(thumbnailSize, thumbnailSize)
                                          interpolationQuality:kCGInterpolationHigh];
    UIImage *imageToSave = resizedImage;

    [self dismissImagePickerController:picker];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        /* All this rigamole is for saving the picture. */
        NSData *imageData = UIImageJPEGRepresentation(imageToSave, 0.7);
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentDirectoryURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSString *imageFilename = [NSString stringWithFormat:@"%@.jpg", [[NSUUID UUID] UUIDString]];
        NSURL *imageURL = [documentDirectoryURL URLByAppendingPathComponent:imageFilename];
        NSError *saveError;
        BOOL success = [imageData writeToURL:imageURL options:0 error:&saveError];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                if (!isFromCameraRoll) {
                    UIImageWriteToSavedPhotosAlbum(image, nil, NULL, NULL);
                }
                if (kESBoardBuilderChangeCoverImageIndex != self.selectedTileIndex) {
                    ESTile *tile = self.board.tiles[self.selectedTileIndex];
                    tile.imagePath = [imageURL es_pathRelativeToHomeDirectory];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.selectedTileIndex inSection:0];
                    if (IS_IPHONE) {
                        NSInteger item = (self.selectedTileIndex % self.paginationHelper.itemsPerPage);
                        indexPath = [NSIndexPath indexPathForItem:item inSection:0];
                    }
                    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                } else {
                    self.board.thumbnailPath = [imageURL es_pathRelativeToHomeDirectory];
                    [self refreshThumbnail];
                }
            } else {
                [UIAlertView es_showStandardAlertDialogWithTitle:@"Can't save image"
                                                      andMessage:@"Couldn't save the image to your iOS device."];
                [Flurry logError:kESEventTagForApplicationError
                         message:@"Can't save image"
                           error:saveError];
            }

        });
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissImagePickerController:picker];
}

//#pragma mark - GKImagePickerDelegate
//
//- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image
//{
//    NSDictionary *info = @{UIImagePickerControllerOriginalImage : image};
//    [self imagePickerController:imagePicker.imagePickerController
//  didFinishPickingMediaWithInfo:info];
//}
//
//- (void)imagePickerDidCancel:(GKImagePicker *)imagePicker
//{
//    [self dismissImagePickerController:imagePicker.imagePickerController];
//}

#pragma mark - Helpers: Image Picking
- (void)showImagePickerControllerUsingActionSheetTitle:(NSString *)title
{
//    GKImagePicker *gkImagePicker = [[GKImagePicker alloc] init];
//    gkImagePicker.cropSize = CGSizeMake(400, 400);
//    gkImagePicker.delegate = self;
//    self.gkImagePicker = gkImagePicker;
//    UIImagePickerController *imagePickerController = gkImagePicker.imagePickerController;
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    
    if ([title isEqualToString:kESBoardBuilderCameraRollTitle]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    } else if ([title isEqualToString:kESBoardBuilderTakeAPhotoTitle]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    BOOL shouldUsePopover = (imagePickerController.sourceType != UIImagePickerControllerSourceTypeCamera)
    && (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    
    if (shouldUsePopover) {
        UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
        popoverController.delegate = self;
        [popoverController presentPopoverFromRect:[self.selectedViewForImagePopups bounds]
                                           inView:self.selectedViewForImagePopups
                         permittedArrowDirections:UIPopoverArrowDirectionAny
                                         animated:YES];
        self.imagePickerPopoverController = popoverController;
    } else {
        [self presentViewController:imagePickerController
                           animated:YES
                         completion:NULL];
    }
}
- (void)dismissImagePickerController:(UIImagePickerController *)picker
{
    if (self.imagePickerPopoverController) {
        [self.imagePickerPopoverController dismissPopoverAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    self.imagePickerPopoverController = nil;
}

- (void)showImagePickerActionSheet
{
    NSString *cancelButtonTitle = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? nil : @"Cancel";
    NSString *takeAPhotoTitle = ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) ? kESBoardBuilderTakeAPhotoTitle : nil;
    NSString *cameraRollTitle = ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) ?
    kESBoardBuilderCameraRollTitle : nil;
    
    if (!takeAPhotoTitle && !cameraRollTitle)
        return;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:cancelButtonTitle
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    if (takeAPhotoTitle) [actionSheet addButtonWithTitle:takeAPhotoTitle];
    if (cameraRollTitle) [actionSheet addButtonWithTitle:cameraRollTitle];
    
    [actionSheet showFromRect:[self.selectedViewForImagePopups bounds]
                       inView:self.selectedViewForImagePopups
                     animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = (textField.text) ? [textField.text stringByReplacingCharactersInRange:range withString:string] : string;
    self.board.title = ([newString length] == 0) ? nil : newString;
    [self refreshTitle];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.board.title = textField.text;
    [self refreshTitle];
}

#pragma mark - UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.selectedTileIndex = NSIntegerMin;
    self.selectedViewForImagePopups = nil;
    self.imagePickerPopoverController = nil;
}

#pragma mark - ESPaginationDelegate
- (void)currentPageIndexDidChange:(ESPagination *)pagination
{
    [self.collectionView reloadData];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

@end
