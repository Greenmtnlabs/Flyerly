//
//  CustomLabel.m
//  Flyr
//
//  Created by Rizwan Ahmad on 5/3/13.
//
//

#import "CustomLabel.h"

@implementation CustomLabel
@synthesize lineWidth, borderColor;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    lineWidth = 0;
    borderColor = [UIColor blackColor];
    return self;
}

-(void)drawRect:(CGRect)rect{

    CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, lineWidth);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = borderColor;
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    
    self.shadowOffset = shadowOffset;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject: borderColor];
    [aCoder encodeObject: @(lineWidth)];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    self.borderColor = [aDecoder decodeObject];
    self.lineWidth = [[aDecoder decodeObject] intValue];
    
    return self;
}

@end
