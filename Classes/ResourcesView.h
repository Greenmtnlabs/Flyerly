//
//  ResourcesView.h
//  Flyr
//
//  Created by RIKSOF Developer on 6/16/14.
//
//

#import <UIKit/UIKit.h>

@interface ResourcesView : UIView


- (void) highlightResource:(NSInteger) tag;
- (UIButton*) getHighlightedResource;
- (void) dehighlightResource;

@end