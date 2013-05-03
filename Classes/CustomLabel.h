//
//  CustomLabel.h
//  Flyr
//
//  Created by Rizwan Ahmad on 5/3/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomLabel : UILabel{
	int lineWidth;
	UIColor *borderColor;
}

@property int lineWidth;
@property(nonatomic, retain) UIColor *borderColor;

@end
