//
//  CustomLabel.h
//  Flyr
//
//  Created by Riksof on 5/3/13.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomLabel : UILabel<NSCoding>{
	int lineWidth;
	UIColor *borderColor;
}

@property int lineWidth;
@property(nonatomic, strong) UIColor *borderColor;

@end
