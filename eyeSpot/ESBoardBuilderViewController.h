//
//  ESBoardBuilderViewController.h
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 2/27/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESCollectionViewController.h"

@class ESBoard;

@protocol ESBoardBuilderDelegate <NSObject>

- (void)boardDidSave:(ESBoard *)board;

@end

@interface ESBoardBuilderViewController : ESCollectionViewController <UITextFieldDelegate>

@property (nonatomic, strong) ESBoard *board;
@property (nonatomic, weak) id<ESBoardBuilderDelegate> delegate;

- (IBAction)editTitle:(id)sender;
- (IBAction)editThumbnail:(id)sender;
- (IBAction)saveBoard:(id)sender;
- (IBAction)back:(id)sender;

@end
