//
//  ESTrophyViewController.m
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 2/22/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <Social/Social.h>
#import <FlurrySDK/Flurry.h>
#import "ESTrophyViewController.h"
#import "ESBoard.h"
#import "ESAppDelegate.h"
#import "ESTrophy.h"
#import "ESGameInfo.h"
#import "ESSoundManager.h"
#import "ESPagination.h"
#import "ESBoardViewController.h"
#import "ESStore.h"
#import "UIAlertView+ESShorthand.h"

static const NSInteger kESImageViewTagForTrophyCollectionViewCell = 200;
static const NSInteger kESImageViewTagForBadgeCollectionViewCell = 300;
static const NSInteger kESStarTagForBadgeCollectionViewCell = 301;
static CGFloat kTrophyHorizontalLeftMargin = 40.0;
static CGFloat kTrophyHorizontalPadding = 15.0;
static CGFloat kTrophyVerticalPadding = 148 + 41 + 20;
static CGFloat kTrophyLineSpacing = 20.0;
static CGFloat kTrophyWidth = 85.0;
static CGFloat kTrophyHeight = 100.0;
static const NSInteger kTrophyViewTagBase = 1000;

@interface ESTrophyViewController () <ESPaginationDelegate>

@property (nonatomic, strong) NSArray *boards, *trophies, *gameInfos;
@property (nonatomic, strong) NSMutableDictionary *trophyViewConstraintsMap, *trophyViewInitialPanOffsetMap;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) ESPagination *paginationHelper;
@property (nonatomic, strong) UIButton *leftPagingButton, *rightPagingButton;
@property (assign) BOOL hideLastTrophyCell, trophyWasChosen;
@end

@implementation ESTrophyViewController

- (void)awakeFromNib
{
    self.isReadOnly = YES;
    if (IS_IPHONE) {
        kTrophyHorizontalLeftMargin = 23.0;
        kTrophyHorizontalPadding = 7.0;
        kTrophyVerticalPadding = 87.5;
        kTrophyLineSpacing = 7.0;
        kTrophyWidth = 37.0;
        kTrophyHeight = 45.0;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.managedObjectContext = [[ESAppDelegate sharedAppDelegate] persistingManagedObjectContext];
    [self updateData];
    self.trophyWasChosen = NO;
    self.trophyViewConstraintsMap = [NSMutableDictionary dictionary];
    self.trophyViewInitialPanOffsetMap = [NSMutableDictionary dictionary];

    if (self.isReadOnly) {
        self.backButton.hidden = NO;
        self.selectAnAwardImageView.hidden = YES;
    } else {
        self.backButton.hidden = YES;
        [self renderTrophies];
    }
    
    [self setupPagingButtons];
    NSArray *pagingButtons = @[self.leftPagingButton, self.rightPagingButton];
    self.paginationHelper = [[ESPagination alloc] initWithPagingButtons:pagingButtons
                                                           itemsPerPage:9
                                                              itemCount:[self.gameInfos count]];
    self.paginationHelper.delegate = self;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.facebookButton.enabled = [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook];
    self.twitterButton.enabled = [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers
- (void)updateData
{
    self.boards = [ESBoard allBoards:self.managedObjectContext];
    self.trophies = [ESTrophy allTrophiesWithContext:self.managedObjectContext];
    self.gameInfos = [ESGameInfo allGameInfoObjectsWithContext:self.managedObjectContext];
    self.hideLastTrophyCell = NO;
    self.paginationHelper.itemCount = [self.gameInfos count];
}

- (void)renderTrophies
{
    NSInteger index = 0, splitPoint = (NSInteger)ceil([self.trophies count] / 2);
    for (ESTrophy *trophy in self.trophies) {
        UIImageView *trophyView = [[UIImageView alloc] initWithImage:trophy.image];
        trophyView.translatesAutoresizingMaskIntoConstraints = NO;
        trophyView.tag = kTrophyViewTagBase + index;
        [self.view addSubview:trophyView];
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(handleTrophyDrag:)];
        trophyView.userInteractionEnabled = YES;
        [trophyView addGestureRecognizer:panGestureRecognizer];
        
        BOOL isRightSide = [self isTrophyViewOnRightSide:trophyView];
        NSInteger verticalIndex = (isRightSide) ? index - splitPoint : index;
        
        // add constraints
        NSDictionary *metrics = @{@"width" : @(kTrophyWidth),
                                  @"height" : @(kTrophyHeight),
                                  @"verticalPadding" : @(kTrophyVerticalPadding + verticalIndex * (kTrophyHeight + kTrophyLineSpacing)),
                                  @"horizPadding" : @(kTrophyHorizontalLeftMargin + isRightSide*(kTrophyHorizontalPadding+kTrophyWidth))};
        NSDictionary *views = NSDictionaryOfVariableBindings(trophyView);
        NSArray *horizConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-horizPadding-[trophyView(width)]"
                                                                            options:0
                                                                            metrics:metrics
                                                                              views:views];
        NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalPadding-[trophyView(height)]"
                                                                               options:0
                                                                               metrics:metrics
                                                                                 views:views];
        [self.view addConstraints:horizConstraints];
        [self.view addConstraints:verticalConstraints];
        self.trophyViewConstraintsMap[@(trophyView.tag)] = @[horizConstraints[0], verticalConstraints[0]];
        
        ++index;
    }
    [self.view setNeedsLayout];
}

- (BOOL)isTrophyViewOnRightSide:(UIView *)trophyView
{
    NSInteger index = trophyView.tag - kTrophyViewTagBase, splitPoint = (NSInteger)ceil([self.trophies count] / 2);
    return (index >= splitPoint);
}

- (BOOL)shelfIntersectsTrophyView:(UIView *)trophyView
{
    return CGRectIntersectsRect(trophyView.frame, self.trophyCollectionView.frame);
}

- (UIImage *)boardThumbnail:(NSIndexPath *)indexPath
{
    NSString *suffix;
    ESBoard *board = self.boards[indexPath.item];
    if (board.isCustom) {
        // short-circuit all this logic
        return [UIImage imageWithContentsOfFile:[board.thumbnailURL path]];
    }

    suffix = [board.productID stringByReplacingOccurrencesOfString:kESBoardProductIDPrefix withString:@""];
    BOOL isComplete = ([board.associatedGames count] != 0);

    NSString *format = (isComplete) ? @"Trophy_Completed-%@" : @"Trophy_Incomplete-%@";
    NSString *imageName = [NSString stringWithFormat:format, suffix];
    return [UIImage imageNamed:imageName];
}

- (void)setupPagingButtons
{
    self.leftPagingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftPagingButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.leftPagingButton setImage:[UIImage imageNamed:@"LeftArrow"]
                           forState:UIControlStateNormal];
    [self.leftPagingButton setImage:[UIImage imageNamed:@"LeftArrow_Selected"]
                           forState:UIControlStateHighlighted];
    [self.leftPagingButton setImageEdgeInsets:UIEdgeInsetsMake(-19.0, 0.0, 0.0, 0.0)];
    
    self.rightPagingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightPagingButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.rightPagingButton setImage:[UIImage imageNamed:@"RightArrow"]
                            forState:UIControlStateNormal];
    [self.rightPagingButton setImage:[UIImage imageNamed:@"RightArrow_Selected"]
                            forState:UIControlStateHighlighted];
    [self.rightPagingButton setImageEdgeInsets:UIEdgeInsetsMake(-16.0, 0.0, 0.0, 0.0)];
    
    UIView *superview = self.view;
    [superview addSubview:self.leftPagingButton];
    [superview addSubview:self.rightPagingButton];
    
    NSArray *constraints;
    NSDictionary *views = @{@"leftPagingButton" : self.leftPagingButton,
                            @"rightPagingButton" : self.rightPagingButton,
                            @"trophyCollectionView" : self.trophyCollectionView};
    NSDictionary *metrics = @{@"padding" : @(5)};
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[leftPagingButton]-padding-[trophyCollectionView]"
                                                          options:NSLayoutFormatAlignAllCenterY
                                                          metrics:metrics
                                                            views:views];
    [superview addConstraints:constraints];
//    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[leftPagingButton]-|"
//                                                          options:0
//                                                          metrics:nil
//                                                            views:views];
//    [superview addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[trophyCollectionView]-padding-[rightPagingButton]"
                                                          options:NSLayoutFormatAlignAllCenterY
                                                          metrics:metrics
                                                            views:views];
    [superview addConstraints:constraints];
//    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[rightPagingButton]-|"
//                                                          options:0
//                                                          metrics:nil
//                                                            views:views];
//    [superview addConstraints:constraints];
    
}

#pragma mark - Actions
- (IBAction)handleTrophyDrag:(UIPanGestureRecognizer *)panGestureRecognizer
{
    static UIColor *originalBackgroundColorForTrophyCollectionView = nil;
    if (!originalBackgroundColorForTrophyCollectionView) {
        originalBackgroundColorForTrophyCollectionView = self.trophyCollectionView.backgroundColor;
    }
    
    if (self.trophyWasChosen && !DBG_MULTIPLE_TROPHY_DRAG)
        return;
    
    if (self.paginationHelper.currentPageIndex != self.paginationHelper.lastPageIndex) {
        self.paginationHelper.currentPageIndex = self.paginationHelper.lastPageIndex;
        [self.trophyCollectionView reloadData];
    }

    UIView *trophyView = panGestureRecognizer.view;
    CGPoint translation = [panGestureRecognizer translationInView:trophyView.superview];
    NSArray *constraints = self.trophyViewConstraintsMap[@(trophyView.tag)];
    NSLayoutConstraint *horizontalConstraint = constraints[0];
    NSLayoutConstraint *veritcalConsraint = constraints[1];

    UIGestureRecognizerState state = panGestureRecognizer.state;
    if (UIGestureRecognizerStateBegan == state) {
        CGPoint initialOffset = CGPointMake(horizontalConstraint.constant, veritcalConsraint.constant);
        self.trophyViewInitialPanOffsetMap[@(trophyView.tag)] = [NSValue valueWithCGPoint:initialOffset];
    } else if (UIGestureRecognizerStateChanged == state){
        CGPoint initialOffset = [self.trophyViewInitialPanOffsetMap[@(trophyView.tag)] CGPointValue];
        horizontalConstraint.constant = translation.x + initialOffset.x;
        veritcalConsraint.constant = translation.y + initialOffset.y;
        [trophyView setNeedsLayout];
        
        if ([self shelfIntersectsTrophyView:trophyView]) {
            self.trophyCollectionView.backgroundColor = [UIColor colorWithRed:0.6 green:0.8 blue:1.0 alpha:0.2];
        } else {
            self.trophyCollectionView.backgroundColor = originalBackgroundColorForTrophyCollectionView;
        }
    } else if (UIGestureRecognizerStateEnded == state || UIGestureRecognizerStateCancelled == state) {
        BOOL didIntersect = [self shelfIntersectsTrophyView:trophyView];
        CGPoint initialOffset = [self.trophyViewInitialPanOffsetMap[@(trophyView.tag)] CGPointValue];
        horizontalConstraint.constant = initialOffset.x;
        veritcalConsraint.constant = initialOffset.y;
        [UIView animateWithDuration:0.25 animations:^{
            [trophyView layoutIfNeeded];
        }];
        self.trophyCollectionView.backgroundColor = originalBackgroundColorForTrophyCollectionView;
        
        // create record and update UI
        if (didIntersect) {
        ESGameInfo *newGameInfo = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([ESGameInfo class])
                                                                    inManagedObjectContext:self.managedObjectContext];
            newGameInfo.selectedTrophy = self.trophies[trophyView.tag - kTrophyViewTagBase];
            newGameInfo.board = self.board;
            __autoreleasing NSError *saveError;
            BOOL didSave = [self.managedObjectContext save:&saveError];
            if (didSave) {
                [self updateData];
                int newIndex = [self.gameInfos count] - 1;
                BOOL shouldStartNewPage = (newIndex > 0) &&
                                          (0 == newIndex % self.paginationHelper.itemsPerPage);
                if (shouldStartNewPage) {
                    self.paginationHelper.currentPageIndex++;
                    newIndex = 0;
                    [self.trophyCollectionView reloadData];
                } else {
                    newIndex = newIndex % self.paginationHelper.itemsPerPage;
                }
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:(newIndex)
                                                                inSection:0];
                if (shouldStartNewPage) {
                    [self.trophyCollectionView reloadItemsAtIndexPaths:@[newIndexPath]];
                 } else {
                    [self.trophyCollectionView insertItemsAtIndexPaths:@[newIndexPath]];
                 }
                [[ESSoundManager sharedInstance] playSound:ESSoundTrophyPlaced];
                NSIndexPath *boardIndexPath = [NSIndexPath indexPathForItem:newGameInfo.board.index inSection:0];
                [self.boardCollectionView reloadItemsAtIndexPaths:@[boardIndexPath]];
                [self.boardCollectionView scrollToItemAtIndexPath:boardIndexPath
                                                 atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
                self.homeButton.hidden = NO;
                self.trophyWasChosen = YES;
                [Flurry logEvent:kESEventTagForTrophyChosen
                  withParameters:@{@"board" : [self.boards[boardIndexPath.item] title],
                                   @"trophy" : @(newGameInfo.selectedTrophy.index)}];
            } else {
                NSLog(@"WTF: %@", saveError);
                [Flurry logError:kESEventTagForCoreDataError message:[saveError localizedDescription] error:saveError];
            }
        }
    }
}

- (IBAction)back:(id)sender
{
    if (sender == self.backButton) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    } else if (sender == self.homeButton) {
        UIViewController *boardSelectionController = [self.navigationController viewControllers][1];
        [self.navigationController popToViewController:boardSelectionController animated:YES];
        [[ESSoundManager sharedInstance] playSound:ESSoundSwoosh];
    }
}

- (IBAction)share:(id)sender
{
    NSString *serviceType = (sender == self.twitterButton) ? SLServiceTypeTwitter : SLServiceTypeFacebook;
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:serviceType];
    NSString *device = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"iPad" : @"iPhone";
    NSString *initialTextTemplate = (sender == self.twitterButton) ? kESTwitterPostTemplate : kESFacebookPostTemplate;
    [controller setInitialText:[NSString stringWithFormat:initialTextTemplate, device]];
    [controller addURL:[NSURL URLWithString:kESGameURLString]];
    controller.completionHandler = ^(SLComposeViewControllerResult result) {
        if (result == SLComposeViewControllerResultDone) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                message:@"Message successfully posted."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    };
    [self presentViewController:controller animated:YES completion:NULL];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (collectionView == self.boardCollectionView) {
        count = [self.boards count];
    } else if (collectionView == self.trophyCollectionView) {
        count = [self.paginationHelper numberOfItemsOnCurrentPage];
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    if (collectionView == self.boardCollectionView) {
        NSString *reuseIdentifier;
        ESBoard *board = self.boards[indexPath.item];
        reuseIdentifier = (board.isCustom) ? @"ESTrophyViewControllerBoardCellCustom" : @"ESTrophyViewControllerBoardCell";
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                         forIndexPath:indexPath];
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:kESImageViewTagForBadgeCollectionViewCell];
        imageView.image = [self boardThumbnail:indexPath];
        if (board.isCustom) {
            UIView *starView = [cell viewWithTag:kESStarTagForBadgeCollectionViewCell];
            starView.hidden = ([board.associatedGames count] == 0);
        }

    } else if (collectionView == self.trophyCollectionView) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ESTrophyViewControllerTrophyCell"
                                                         forIndexPath:indexPath];
        ESGameInfo *gameInfo = self.gameInfos[[self.paginationHelper adjustedItemIndexForIndexPath:indexPath]];
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:kESImageViewTagForTrophyCollectionViewCell];
        imageView.image = gameInfo.selectedTrophy.image;
        
        cell.hidden = (self.hideLastTrophyCell && [self.gameInfos lastObject] == gameInfo);
    }
    
    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.boardCollectionView && self.trophyWasChosen && !self.isReadOnly) {
        ESBoard *board = self.boards[indexPath.item];
        ESStore *store = [ESStore sharedStore];
        
        if (board.isAvailable || DBG_ALL_BOARDS_AVAILABLE) {
            [self transitionToBoardScreen:board];
        } else {
            [store purchaseProduct:board.productID
             withCompletionHandler:^(BOOL wasPurchased, NSString *productID) {
                 if (wasPurchased) {
                     [collectionView reloadItemsAtIndexPaths:@[indexPath]];
                     [self transitionToBoardScreen:board];
                 }
             }];
        }        
    }
}

- (void)transitionToBoardScreen:(ESBoard *)board
{
    NSArray *viewControllerStack = [self.navigationController viewControllers];
    ESBoardViewController *controller = viewControllerStack[[viewControllerStack count] - 2];
    controller.board = board;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ESPaginationDelegate
- (void)currentPageIndexDidChange:(ESPagination *)pagination
{
    [self.trophyCollectionView reloadData];
}

@end
