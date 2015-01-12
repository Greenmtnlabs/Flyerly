//
//  ESBoardSelectionViewController.m
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 2/20/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <FlurrySDK/Flurry.h>
#import "ESBoardSelectionViewController.h"
#import "ESBoard.h"
#import "ESAppDelegate.h"
#import "ESBoardCell.h"
#import "ESBoardViewController.h"
#import "ESStore.h"
#import "UICollectionViewController+ESBackgroundView.h"
#import "ESPagination.h"
#import "ESBoardBuilderViewController.h"

static NSString * const KESBoardBuilderSegueIdentifier = @"ESBoardBuilderSegue";
static NSString * const KESBoardSelectionSegueIdentifier = @"ESBoardSelectionSegue";

@interface ESBoardSelectionViewController () <ESPaginationDelegate, ESBoardBuilderDelegate>

@property (nonatomic, strong) NSArray *boards;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) ESPagination *paginationHelper;
@property (nonatomic, strong) ESBoard *freshlySavedCustomBoard;

@end

@implementation ESBoardSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.managedObjectContext = [[ESAppDelegate sharedAppDelegate] persistingManagedObjectContext];
    self.boards = [ESBoard allBoards:self.managedObjectContext];
//    self.boards = [self.boards arrayByAddingObjectsFromArray:self.boards];
    
    [self es_useDefaultBackgroundView];
    [self setupPagingButtons];
    NSArray *pagingButtons = @[self.leftPagingButton, self.rightPagingButton];
    self.paginationHelper = [[ESPagination alloc] initWithPagingButtons:pagingButtons
                                                           itemsPerPage:[ESPagination standardNumberOfItemsPerPage]
                                                              itemCount:1 + [self.boards count]];
    self.paginationHelper.delegate = self;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self resetData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[ESBoardViewController class]]) {
        ESBoardViewController *controller = (ESBoardViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        controller.board = [self boardAtIndexPath:indexPath];
        [Flurry logEvent:kESEventTagForBoardSelection withParameters:@{@"board" : controller.board.title}];
    } else if ([segue.destinationViewController isKindOfClass:[ESBoardBuilderViewController class]]) {
        ESBoardBuilderViewController *controller = (ESBoardBuilderViewController *)segue.destinationViewController;
        controller.delegate = self;
    }
}

#pragma mark - Actions
- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Helpers
- (void)resetData
{
    self.boards = [ESBoard allBoards:self.managedObjectContext];
    self.paginationHelper.itemCount = [self.boards count] + 1;
    if (self.freshlySavedCustomBoard) {
        // Change page index to new board;
        NSInteger boardIndex = [self.boards indexOfObjectPassingTest:^BOOL(ESBoard *board, NSUInteger idx, BOOL *stop) {
            return (board.index == self.freshlySavedCustomBoard.index);
        }];
        NSInteger pageIndexForNewBoard = (boardIndex / self.paginationHelper.itemsPerPage);
        if (pageIndexForNewBoard != self.paginationHelper.currentPageIndex) {
            self.paginationHelper.currentPageIndex = pageIndexForNewBoard;
        }
        self.freshlySavedCustomBoard = nil;
    }
    
    [self.collectionView reloadData];
}

- (UIImage *)boardThumbnail:(NSIndexPath *)indexPath
{
    BOOL isAvailable;
    NSString *suffix;
    if ([self isIndexPathForDesignABoard:indexPath]) {
        suffix = @"DesignABoard";
        isAvailable = [[ESStore sharedStore] isDesignABoardFeatureAvailable] || DBG_ALL_BOARDS_AVAILABLE;
    } else {
        ESBoard *board = [self boardAtIndexPath:indexPath];
        if (board.isCustom) {
            // short-circuit all this logic
            return [UIImage imageWithContentsOfFile:[board.thumbnailURL path]];
        }
        suffix = [board.productID stringByReplacingOccurrencesOfString:kESBoardProductIDPrefix withString:@""];
        isAvailable = board.isAvailable || DBG_ALL_BOARDS_AVAILABLE;
    }
    NSString *format = (isAvailable) ? @"BoardSelection_Available-%@" : @"BoardSelection_Unavailable-%@";
    NSString *imageName = [NSString stringWithFormat:format, suffix];
    return [UIImage imageNamed:imageName];
}

- (BOOL)isIndexPathForDesignABoard:(NSIndexPath *)indexPath
{
    return ([self.paginationHelper adjustedItemIndexForIndexPath:indexPath]
            == [self.boards count]);
}

- (ESBoard *)boardAtIndexPath:(NSIndexPath *)indexPath
{
    return self.boards[[self.paginationHelper adjustedItemIndexForIndexPath:indexPath]];
}

- (BOOL)hasBoardAtIndexPath:(NSIndexPath *)indexPath
{
    int i = [self.paginationHelper adjustedItemIndexForIndexPath:indexPath];
    return (i < [self.boards count]);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.paginationHelper itemsPerPage];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier;
    if ([self hasBoardAtIndexPath:indexPath] && [[self boardAtIndexPath:indexPath] isCustom]) {
        reuseIdentifier = @"ESBoardCellCustom";
    } else {
        reuseIdentifier = @"ESBoardCellAlpha";
    }
    
    ESBoardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                  forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    UILabel *label = (UILabel *)[cell viewWithTag:2];

    if ([self isIndexPathForDesignABoard:indexPath]) {
        imageView.image = [self boardThumbnail:indexPath];
        label.text = @"Design a Board";
    } else if ([self hasBoardAtIndexPath:indexPath]) {
        ESBoard *board = [self boardAtIndexPath:indexPath];
        imageView.image = [self boardThumbnail:indexPath];
        label.text = board.title;
        if ([board.title isEqualToString:@"Soccer"]) {
            label.text = @"Soccer/Futbol";
        }
    } else {
        imageView.image = nil;
        label.text = nil;
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier;
    if (kind == UICollectionElementKindSectionHeader ) {
        reuseIdentifier = @"ESBoardSelectionHeaderView";
    } else if (kind == UICollectionElementKindSectionFooter) {
        reuseIdentifier = @"ESBoardSelectionFooterView";
    }
    
    return [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                              withReuseIdentifier:reuseIdentifier
                                                     forIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ESStore *store = [ESStore sharedStore];
    BOOL isDesignABoard = [self isIndexPathForDesignABoard:indexPath];
    
    if (!isDesignABoard && ![self hasBoardAtIndexPath:indexPath])
        return; //This is an empty 'board' we're using for spacing.
    
    ESBoard *board = (isDesignABoard) ? nil : [self boardAtIndexPath:indexPath];
    NSString *segueId = (isDesignABoard) ? KESBoardBuilderSegueIdentifier : KESBoardSelectionSegueIdentifier;
    NSString *productID = (isDesignABoard) ? kESDesignABoardProductID : board.productID;
    BOOL isPurchased = (isDesignABoard) ? [store isDesignABoardFeatureAvailable] : board.isAvailable;
    isPurchased = isPurchased || DBG_ALL_BOARDS_AVAILABLE;
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if (isPurchased) {
        [self performSegueWithIdentifier:segueId
                                  sender:cell];
    } else {
        [store purchaseProduct:productID
         withCompletionHandler:^(BOOL wasPurchased, NSString *productID) {
             if (wasPurchased) {
                 [self performSegueWithIdentifier:segueId sender:cell];
                 [collectionView reloadItemsAtIndexPaths:@[indexPath]];
             }
         }];
    }
}

#pragma mark - ESPaginationDelegate
- (void)currentPageIndexDidChange:(ESPagination *)pagination
{
    [self.collectionView reloadData];
}

#pragma mark - ESBoardBuilderDelegate
- (void)boardDidSave:(ESBoard *)board
{
    self.freshlySavedCustomBoard = board;
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 // viewWillAppear has already been called, therefore data is reset                                 
                             }];
}

@end
