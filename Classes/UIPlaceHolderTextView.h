//
//  UIPlaceHolderTextView.h
//  Flyr
//
//  Created by Khurram on 17/03/2014.
//
//

#import <UIKit/UIKit.h>


@interface UIPlaceHolderTextView : UITextView


@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;
@end
