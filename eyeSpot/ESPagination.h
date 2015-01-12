//
//  ESPagination.h
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 3/7/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ESPagination;

@protocol ESPaginationDelegate <NSObject>
- (void)currentPageIndexDidChange:(ESPagination *)pagination;
@end

@interface ESPagination : NSObject

@property (assign, nonatomic) NSUInteger itemCount, itemsPerPage, currentPageIndex;
@property (assign, nonatomic, readonly) NSUInteger lastPageIndex;
@property (weak, nonatomic) UIButton *leftPagingButton, *rightPagingButton;
@property (weak, nonatomic) id<ESPaginationDelegate> delegate;

- (ESPagination *)initWithPagingButtons:(NSArray *)buttons itemsPerPage:(NSUInteger)itemsPerPage itemCount:(NSUInteger)itemCount;
- (NSUInteger)numberOfItemsOnCurrentPage;
- (NSUInteger)adjustedItemIndexForIndexPath:(NSIndexPath *)indexPath;
+ (NSUInteger)standardNumberOfItemsPerPage;
@end
