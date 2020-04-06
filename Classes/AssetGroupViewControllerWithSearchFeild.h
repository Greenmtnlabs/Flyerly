//
//  AssetGroupViewControllerWithSearchFeild.h
//  Flyr
//
//  Created by RIKSOF Developer on 8/5/14.
//
//

#import <UIKit/UIKit.h>
#import "NBUImagePickerPrivate.h"
#import "NBUGalleryViewController.h"
#import "InAppViewController.h"
#import "RMStore.h"
#import "NBUGalleryViewController.h"

@class ObjectGridView, NBUGalleryViewController,InAppViewController;

@interface AssetGroupViewControllerWithSearchFeild : NBUGalleryViewController <RMStoreObserver,UserPurchasesDelegate,InAppPurchasePanelButtonProtocol> {
    
    InAppViewController *inappviewcontroller;
    SigninController *signInController;
    BOOL cancelRequest;
    UIBarButtonItem  *rightBarButtonItem;
}

@property (strong, nonatomic) ALAssetsLibrary *library;

@property (nonatomic) NSUInteger selectionCountLimit;
//A text feild to search images on shutterstock
@property ( nonatomic, strong ) IBOutlet UISearchBar *searchTextField;

@property CGSize desiredImageSize;

@property (nonatomic, copy) void (^onImageTaken)(UIImage *);

// An ObjectGridView used to display shutterstock api objects.

@property (nonatomic, assign, getter=isLoading)   BOOL loading;

/// The number of assets to be incrementally loaded. Default `100`, set to `0` to load all at once;
@property (nonatomic) NSUInteger loadSize;

@property (nonatomic) BOOL isFromInApp;

@end
