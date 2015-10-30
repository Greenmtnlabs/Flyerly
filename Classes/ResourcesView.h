//
//  ResourcesView.h
//  Flyr
//
//  Created by RIKSOF Developer on 6/16/14.
//
//

#import <UIKit/UIKit.h>

@interface ResourcesView : UIView {
    
    NSInteger highlightedResourceTag;
    
}


- (void) highlightResource:(NSInteger) tag;
- (UIButton*) getHighlightedResource;
- (void)setHighlightedResourceTag:(NSInteger) tag;
- (void) dehighlightResource;

@end