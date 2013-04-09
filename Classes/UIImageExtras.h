//
//  UIImageExtras.h
//  Flyr
//
//  Created by Nilesh on 26/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImageExtras : NSObject {

}

@end
@interface UIImage (Extras)
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
@end
