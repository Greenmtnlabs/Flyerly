//
//  ESConstants.h
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 2/21/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#ifndef eyeSPOT_ESConstants_h
#define eyeSPOT_ESConstants_h

typedef void (^ESCompletionBlock)(BOOL success, id result);

#pragma mark - Debugging
#define DBG_RESET_DATA              0
#define DBG_ALL_BOARDS_AVAILABLE    0
#define DBG_ONE_SWIPE_WIN           0
#define DBG_MULTIPLE_TROPHY_DRAG    0

#pragma mark - Misc.
//static NSString * const kES
static NSString * const kESGameURLString = @"http://goo.gl/1EIt8";
static NSString * const kESFacebookPostTemplate = @"I love playing eyeSPOT on my %@!";
static NSString * const kESTwitterPostTemplate = @"I love playing @eyeSPOTapp on my %@!";

#pragma mark - Segue Identifiers
static NSString * const kESGameCompleteSegueIdentifier = @"GameCompleteSegue";

#pragma mark - IAP
static NSString * const kESBoardProductIDPrefix = @"com.greenmtnthink.eyeSPOT.iap.boards.";
static NSString * const kESDesignABoardProductID = @"com.greenmtnthink.eyeSPOT.iap.boards.DesignABoard";

#pragma mark - Analytics
static NSString * const kESEventTagForPageView = @"Screen Viewed";
static NSString * const kESEventTagForBoardSelection = @"Board Selected";
static NSString * const kESEventTagForBoardCreation = @"Board Created";
static NSString * const kESEventTagForTileSpotted = @"Tile Spotted";
static NSString * const kESEventTagForBoardCompletion = @"Board Completed";
static NSString * const kESEventTagForBoardPurchase = @"Board Purchased";
static NSString * const kESEventTagForTrophyChosen = @"Trophy Chosen";
static NSString * const kESEventTagForCoreDataError = @"Core Data Error";
static NSString * const kESEventTagForStoreKitError = @"Store Kit Error";
static NSString * const kESEventTagForApplicationError = @"Application Error";

#pragma mark - Universal
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE6_PLUS (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#endif
