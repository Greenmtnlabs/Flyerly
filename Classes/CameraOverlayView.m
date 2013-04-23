//
//  CameraOverlayView.m
//  Flyr
//
//  Created by Rizwan Ahmad on 4/22/13.
//
//

#import "CameraOverlayView.h"

@implementation CameraOverlayView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //clear the background color of the overlay
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
        //show flash button
        UIImageView *gridImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_area_bg"]];
        [gridImage setFrame:frame];
        [self addSubview:gridImage];

        //show flash button
        UIButton *flashButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [flashButton setBackgroundImage:[UIImage imageNamed:@"menu_button"] forState:UIControlStateNormal];
        [flashButton addTarget:self action:@selector(toggleFlash) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:flashButton];
        [flashButton release];

        //show flash button
        UIButton *gridButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 10, 30, 30)];
        [gridButton setBackgroundImage:[UIImage imageNamed:@"menu_button"] forState:UIControlStateNormal];
        [gridButton addTarget:self action:@selector(toggleGrid) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:gridButton];
        [gridButton release];
        
    }
    return self;
}

-(void)toggleFlash {
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    int torchMode = [device torchMode];
    
    if([device isTorchModeSupported:torchMode]){
        [device lockForConfiguration:nil];
        
        if(torchMode == AVCaptureTorchModeOn){
            [device setTorchMode:AVCaptureTorchModeOff];
            [device setFlashMode:AVCaptureTorchModeOff];
        } else {
            [device setTorchMode:AVCaptureTorchModeOn];
            [device setFlashMode:AVCaptureTorchModeOn];
        }
        [device unlockForConfiguration];
    }
}



-(void)toggleGrid {

    NSLog(@"Toggle Grid");
    
    //show flash button
    UIImageView *gridImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_area_bg"]];
    [gridImage setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:gridImage];

}

@end
