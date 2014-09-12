//
//  CustomLabel.h
//  Flyr
//
//  Created by Riksof on 5/3/13.
//
//

@interface CustomLabel : UILabel <NSCoding> {
	int lineWidth;
	UIColor *borderColor;
}

@property int lineWidth;
@property(nonatomic, strong) UIColor *borderColor;
@property CGSize originalSize;

// helper to get pre transform frame
-(CGRect)originalFrame;

// helper to get point offset from center
-(CGPoint)centerOffset:(CGPoint)thePoint;

// helper to get point back relative to center
-(CGPoint)pointRelativeToCenter:(CGPoint)thePoint;

// helper to get point relative to transformed coords
-(CGPoint)newPointInView:(CGPoint)thePoint;

// To get corners of a transformed image view
-(CGPoint)newTopLeft;
-(CGPoint)newTopRight;
-(CGPoint)newBottomLeft;
-(CGPoint)newBottomRight;

// To get size of a transformed image view
-(CGSize)newSize;


@end
