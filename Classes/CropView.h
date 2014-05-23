//
//  CropView.h
//  Flyr
//
//  Created by Khurram Ali on 22/05/2014.
//
//

#import <UIKit/UIKit.h>

@interface CropView : UIView {
    CAShapeLayer *_border;
}

@property BOOL fixedX;
@property BOOL fixedY;

@end
