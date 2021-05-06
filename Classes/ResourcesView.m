//
//  ResourcesView.m
//  Flyr
//
//  Created by RIKSOF Developer on 6/16/14.
//
//

#import "ResourcesView.h"

@implementation ResourcesView

- (id) init
{
    highlightedResourceTag = -1;
    return [super init];
}

- (void) highlightResource:(NSInteger) tag {
    
    // Add border to selected layer thumbnail
    UIButton *selectedResource = (UIButton*)[self viewWithTag:tag];
    
    // We are not going to do anything if the selected resource is the same as previously selected resource
    if ( tag != highlightedResourceTag ) {
        
        // We are going to dehhighlight the previously selected resource
        if ( highlightedResourceTag != -1 ) {
            [self dehighlightResource];
        }
        
        // Now highlight the resource
        if ( selectedResource != nil ) {
            // Draw border around this button
            [selectedResource.layer setCornerRadius:8];
            [selectedResource.layer setBorderWidth:3.0];
            UIColor * c = [UIColor colorWithRed:1/255.0 green:151/255.0 blue:221/255.0 alpha:1];
            [selectedResource.layer setBorderColor:c.CGColor];
            highlightedResourceTag = tag;
        }
    }
}

- (UIButton*) getHighlightedResource {
    
    return (UIButton*)[self viewWithTag:highlightedResourceTag];
    
}

- (void) dehighlightResource {
    
    // Add border to selected layer thumbnail
    UIButton *deselectResource = (UIButton*)[self viewWithTag:highlightedResourceTag];
    
    if ( deselectResource != nil ) {
        UIColor * c = [UIColor clearColor];
        [deselectResource.layer setBorderColor:c.CGColor];
        [deselectResource.layer setCornerRadius:0];
        highlightedResourceTag = -1;
    }
}

-(void)setHighlightedResourceTag:(NSInteger) tag{
    highlightedResourceTag = tag;
}

@end
