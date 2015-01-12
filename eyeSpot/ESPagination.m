//
//  ESPagination.m
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 3/7/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

//TODO use KVO to watch all changeable variables & sync buttons
#import "ESPagination.h"

@interface ESPagination ()

//@property (assign, nonatomic) NSUInteger currentPageIndex;

@end

@implementation ESPagination

#pragma mark - Properties
- (NSUInteger)lastPageIndex
{
    if (self.itemCount == 0) {
        return 0;
    } else {
        return (NSUInteger)((self.itemCount-1) / self.itemsPerPage);
    }
}

-(void)setCurrentPageIndex:(NSUInteger)currentPageIndex
{
//    if (currentPageIndex * self.itemsPerPage > self.itemCount) {
//        currentPageIndex++;
//    }
    _currentPageIndex = currentPageIndex;


    [self syncPagingButtons];
}

-(void)setItemCount:(NSUInteger)itemCount
{
    _itemCount = itemCount;
    [self syncPagingButtons];
}

#pragma mark - Public Methods
- (ESPagination *)initWithPagingButtons:(NSArray *)buttons
                           itemsPerPage:(NSUInteger)itemsPerPage
                              itemCount:(NSUInteger)itemCount;
{
    if (self == [super init]) {
        self.itemsPerPage = itemsPerPage;
        self.itemCount = itemCount;
        self.leftPagingButton = buttons[0];
        self.rightPagingButton = buttons[1];
        [self.leftPagingButton addTarget:self
                                  action:@selector(pagingButtonTapped:)
                        forControlEvents:UIControlEventTouchUpInside];
        [self.rightPagingButton addTarget:self
                                   action:@selector(pagingButtonTapped:)
                         forControlEvents:UIControlEventTouchUpInside];
        [self syncPagingButtons];
    }
    return self;
}

- (void)dealloc
{
    [self.leftPagingButton removeTarget:self
                                 action:@selector(pagingButtonTapped:)
                       forControlEvents:UIControlEventTouchUpInside];
    [self.rightPagingButton removeTarget:self
                                  action:@selector(pagingButtonTapped:)
                        forControlEvents:UIControlEventTouchUpInside];
}

- (NSUInteger)numberOfItemsOnCurrentPage
{
	if (self.currentPageIndex == self.lastPageIndex) {
		return self.itemCount - (self.currentPageIndex * self.itemsPerPage);
	} else {
		return self.itemsPerPage;
	}
}

- (NSUInteger)adjustedItemIndexForIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger i = indexPath.item + (self.currentPageIndex * self.itemsPerPage);
	return i;
}

+ (NSUInteger)standardNumberOfItemsPerPage
{
    if (IS_IPAD) return 15;
    if (IS_IPHONE5) return 10;
    if (IS_IPHONE) return 8;
    [NSException raise:NSGenericException format:@"Should never get here."];
    return 0;
}

#pragma mark - Private Methods
- (IBAction)pagingButtonTapped:(UIButton *)pagingButton
{
	_currentPageIndex += (pagingButton == self.leftPagingButton) ? -1 : 1;
	[self syncPagingButtons];
	if (self.delegate) {
        [self.delegate currentPageIndexDidChange:self];
    }
}

- (void)syncPagingButtons
{
    BOOL isOnLastPage = (self.currentPageIndex == self.lastPageIndex);
    BOOL isOnlyOnePage = (self.lastPageIndex == 0);
    BOOL isOnFirstPage = (0 == self.currentPageIndex);
    if (isOnlyOnePage) {
        self.leftPagingButton.hidden = YES;
        self.rightPagingButton.hidden = YES;
    } else if (isOnFirstPage) {
        self.leftPagingButton.hidden = YES;
        self.rightPagingButton.hidden = NO;
    } else if (isOnLastPage) {
        self.leftPagingButton.hidden = NO;
        self.rightPagingButton.hidden = YES;
    } else {
        self.leftPagingButton.hidden = NO;
        self.rightPagingButton.hidden = NO;
    }
}
@end
