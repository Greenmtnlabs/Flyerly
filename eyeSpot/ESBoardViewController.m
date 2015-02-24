//
//  ESBoardViewController.m
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 2/21/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <FlurrySDK/Flurry.h>
#import "ESBoardViewController.h"
#import "ESTrophyViewController.h"
#import "ESBoard.h"
#import "ESTile.h"
#import "ESSoundManager.h"
#import "UICollectionViewController+ESBackgroundView.h"
#import "ESPagination.h"
#import <GoogleMobileAds/GADInterstitial.h>
#import <GoogleMobileAds/GADInterstitialDelegate.h>

static const NSInteger ESTileCellTagForTileImageView = 3;
static const NSInteger ESTileCellTagForCheckmarkImageView = 2;
static const NSInteger ESTileCellTagForCompletionMaskView = 4;
static const NSTimeInterval gotoTrophyScreenTimerDuration = 6.0;

@interface ESBoardViewController () <ESPaginationDelegate>

@property (assign, nonatomic) BOOL isGameOver, shouldHideFirstSection;
@property (strong, nonatomic) NSTimer *gotoTrophyScreenTimer;
@property (nonatomic, strong) ESPagination *paginationHelper;

@end

@implementation ESBoardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self es_useDefaultBackgroundView];
    [self es_addTitleLabelToBackgroundView];
    
    // Create a new GADInterstitial each time. A GADInterstitial will only show one request in its
    // lifetime. The property will release the old one and set the new one.
    self.interstitialAdd = [[GADInterstitial alloc] init];
    self.interstitialAdd.delegate = self;
    
    // Note: Edit SampleConstants.h to update kSampleAdUnitId with your interstitial ad unit id.
    self.interstitialAdd.adUnitID = [self interstitialAdID];
    
    [self.interstitialAdd loadRequest:[self request]];
    
    if (IS_IPHONE5) {
        self.goodJobOverlayImageView.image = [UIImage imageNamed:@"GoodJobOverlay-568h"];
        CGRect frame = self.goodJobOverlayImageView.frame;
        frame = CGRectMake(frame.origin.x, frame.origin.y, 568.0f, frame.size.height);
        self.goodJobOverlayImageView.frame = frame;
    }
    [self setupPagingButtons];
    NSArray *pagingButtons = @[self.leftPagingButton, self.rightPagingButton];
    self.paginationHelper = [[ESPagination alloc] initWithPagingButtons:pagingButtons
                                                           itemsPerPage:[ESPagination standardNumberOfItemsPerPage]
                                                              itemCount:15];
    self.paginationHelper.delegate = self;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isGameOver = NO;
    self.shouldHideFirstSection = NO;
    self.goodJobOverlayImageView.alpha = 0.0;
    self.leftPagingButton.hidden = self.rightPagingButton.hidden = NO;
    self.paginationHelper.currentPageIndex = 0;
    [[self es_titleLabel] setText:self.board.title];
    [self.collectionView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.gotoTrophyScreenTimer invalidate];
    
    // Save checked tiles or reset board
    if (self.isGameOver) {
        [self.board.tiles enumerateObjectsUsingBlock:^(ESTile *tile, NSUInteger idx, BOOL *stop) {
            tile.isChecked = NO;
        }];
    }
    __autoreleasing NSError *error = nil;
    [self.board.managedObjectContext save:&error];
    if (error) NSLog(@"Couldn't save board: %@", error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kESGameCompleteSegueIdentifier]) {
        ESTrophyViewController *controller = segue.destinationViewController;
        controller.isReadOnly = NO;
        controller.board = self.board;
    }
}

#pragma mark - Helpers
- (BOOL)hasTileAtIndexPath:(NSIndexPath *)indexPath
{
    int i = [self.paginationHelper adjustedItemIndexForIndexPath:indexPath];
    return (i < [self.board.tiles count]);
}

- (ESTile *)tileAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger i = (IS_IPAD) ? indexPath.item : [self.paginationHelper adjustedItemIndexForIndexPath:indexPath];
    return self.board.tiles[i];
}

- (void)checkGameState
{
    __block BOOL isGameOver = YES;
    [self.board.tiles enumerateObjectsUsingBlock:^(ESTile *tile, NSUInteger idx, BOOL *stop) {
        if (!tile.isChecked) {
            isGameOver = NO;
            *stop = YES;
        }
    }];

    isGameOver = (isGameOver || DBG_ONE_SWIPE_WIN);
    self.isGameOver = isGameOver;
    
    // If game is completed
    if( isGameOver ) {
        // Add screen
        if ( [self.interstitialAdd isReady]  && ![self.interstitialAdd hasBeenUsed] ) {
            [self.interstitialAdd presentFromRootViewController:self];
        }
    }
    
}

/**
 *  Check the game is over SO move to the trophy Screen
 */
- (void)isGameOver:(BOOL)gameOver{
    
        [[ESSoundManager sharedInstance] playSound:ESSoundBoardComplete];
        self.gotoTrophyScreenTimer = [NSTimer scheduledTimerWithTimeInterval:gotoTrophyScreenTimerDuration
                                                                      target:self
                                                                    selector:@selector(goToTrophyScreen:)
                                                                    userInfo:nil
                                                                     repeats:NO];
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             self.shouldHideFirstSection = YES;
                             [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:0]];
                             self.goodJobOverlayImageView.alpha = 1.0;
                             self.leftPagingButton.hidden = self.rightPagingButton.hidden = YES;
                             
                         }];
    
}

- (void)goToTrophyScreen:(NSTimer*)theTimer
{
    if (self.navigationController.topViewController == self) {
        [self goodJobOverlayTapped:nil];
    }
}

- (void)autopageIfNecessary
{
    if (!IS_IPHONE) return;
    if (self.paginationHelper.currentPageIndex != 0) return;
    if (self.isGameOver) return;
    
    NSInteger numberOfTilesPerPage = [ESPagination standardNumberOfItemsPerPage];
    __block BOOL areAllTilesOnFirstPageChecked = YES;
    
    [self.board.tiles enumerateObjectsUsingBlock:^(ESTile *tile, NSUInteger idx, BOOL *stop) {
        if (idx < numberOfTilesPerPage && !tile.isChecked) {
            areAllTilesOnFirstPageChecked = NO;
            *stop = YES;
        }
    }];
    
    if (!areAllTilesOnFirstPageChecked) return;
    
    self.paginationHelper.currentPageIndex++;
    [self.collectionView reloadData];
}

#pragma mark - Actions
- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goodJobOverlayTapped:(UITapGestureRecognizer *)sender
{
    [Flurry logEvent:kESEventTagForBoardCompletion withParameters:@{@"board" : self.board.title}];
    [self performSegueWithIdentifier:kESGameCompleteSegueIdentifier
                              sender:self];
}

- (IBAction)handleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    UICollectionViewCell *cell = (UICollectionViewCell *)gestureRecognizer.view;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if (![self hasTileAtIndexPath:indexPath]) return; /* user tapped a spacer tile */

    ESTile *tile = [self tileAtIndexPath:indexPath];
    BOOL didCheck = !tile.isChecked;
    
    if (didCheck) {
        [Flurry logEvent:kESEventTagForTileSpotted
          withParameters:@{@"board" : self.board.title, @"index" : @(indexPath.item)}];
    }
    UIImageView *checkImageView = (UIImageView *)[cell viewWithTag:ESTileCellTagForCheckmarkImageView];
    UIView *completionMaskView = [cell viewWithTag:ESTileCellTagForCompletionMaskView];
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         if (didCheck) {
                             checkImageView.alpha = 1.0;
                             completionMaskView.alpha = 1.0;
                             completionMaskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
                         } else {
                             completionMaskView.backgroundColor = [UIColor clearColor];
                             completionMaskView.alpha = 0.0;
                             checkImageView.alpha = 0.0;
                         }
                     }
                     completion:^(BOOL finished) {
                         if (didCheck) {
                             tile.isChecked = YES;
                             [self checkGameState];
                             [self autopageIfNecessary];
                         } else {
                             tile.isChecked = NO;
                         }
                     }];
    if (didCheck) {
        [[ESSoundManager sharedInstance] playSound:ESSoundSwoosh];
    } 
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (IS_IPAD) ?  [self.board.tiles count] : [self.paginationHelper itemsPerPage];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return (self.shouldHideFirstSection) ? 0 : 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ESTile *tile = nil;
    if ([self hasTileAtIndexPath:indexPath]) {
        tile = [self tileAtIndexPath:indexPath];
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ESTileCell"
                                                                           forIndexPath:indexPath];
    
    if (0 == [[cell gestureRecognizers] count]) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(handleTap:)];
        [cell addGestureRecognizer:tapGestureRecognizer];
    }

    UIImageView *imageView = (UIImageView *)[cell viewWithTag:ESTileCellTagForTileImageView];
    if (nil == tile) {
        imageView.image = nil;
        imageView.layer.cornerRadius = 0.0;
        imageView.layer.borderWidth = 0.0;
        imageView.layer.masksToBounds = NO;
    } else {
        imageView.image = [UIImage imageWithContentsOfFile:[tile.imageURL path]];
        imageView.layer.cornerRadius = 4.0;
        UIColor *borderColor = [UIColor colorWithRed:0.14 green:0.61 blue:0.79 alpha:1.0];
        imageView.layer.borderColor = [borderColor CGColor];
        imageView.layer.borderWidth = 5.0;
        imageView.layer.masksToBounds = YES;
    }
    
    UIImageView *checkImageView = (UIImageView *)[cell viewWithTag:ESTileCellTagForCheckmarkImageView];
    UIView *completionMaskView = [cell viewWithTag:ESTileCellTagForCompletionMaskView];
    if (nil == tile) {
        checkImageView.alpha = 0.0;
        completionMaskView.alpha = 0.0;
    } else if (tile.isChecked) {
        checkImageView.alpha = 1.0;
        completionMaskView.alpha = 1.0;
        completionMaskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    } else {
        completionMaskView.backgroundColor = [UIColor clearColor];
        completionMaskView.alpha = 0.0;
        checkImageView.alpha = 0.0;
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
    return reuseableView;
}

#pragma mark - ESPaginationDelegate
- (void)currentPageIndexDidChange:(ESPagination *)pagination
{
    [self.collectionView reloadData];
}

#pragma mark - InterstitialAdd

// Request the Ad
- (GADRequest *)request {
    GADRequest *request = [GADRequest request];
    return request;
}

//InterstitialAdd Id
- (NSString*)interstitialAdID {
    
#ifdef DEBUG
    
    //ozair's account
    //return @"ca-app-pub-5409664730066465/9926514430";
    //Rehan's a/c
    return @"ca-app-pub-1703558915514520/8955078699";
    
#else
    
    //Live Jen'account
    return @"ca-app-pub-3218409375181552/5412213028";
    
#endif
    
}


- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    
    self.interstitialAdd.delegate = nil;
    
    // Prepare next interstitial.
    self.interstitialAdd = [[GADInterstitial alloc] init];
    self.interstitialAdd.adUnitID = [self interstitialAdID];
    self.interstitialAdd.delegate = self;
    [self.interstitialAdd loadRequest:[self request]];
    
    // Call the method to check if the game is over
    [self isGameOver:self.isGameOver];
}

@end
