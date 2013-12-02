//
//  FlyerOverlayController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 6/10/13.
//
//

#import "FlyerOverlayController.h"
#import <QuartzCore/QuartzCore.h>
#import "FlyrAppDelegate.h"

@implementation FlyerOverlayController
@synthesize flyerOverlayImage,editButton,crossButton,overlayRoundedView,flyerNumber;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil image:(UIImage *)image modalView:(UIView *)modalView{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        tempImage = image;
        tempModalView = modalView;
    }
    return self;
}

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Set flyer image
    self.flyerOverlayImage.image = tempImage;

    // Add rounded border to flyer view
    CALayer * l = [overlayRoundedView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:7];
    [l setBorderWidth:1.0];
    [l setBorderColor:[[UIColor grayColor] CGColor]];
}

-(IBAction)goBack{
    // Remove views from superview
    [self.view removeFromSuperview];
    [tempModalView removeFromSuperview];
    
    // Set alpha back to 1
    parentViewController.navigationController.navigationBar.alpha = 1;
}

-(void)viewWillDisappear:(BOOL)animated{
    parentViewController.navigationController.navigationBar.alpha = 1;
}

-(void)showAlert:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

/*
 * open flyer in editable mode
 * this is required on sharing screen as well so defining it as class member +
 */
+(void)openFlyerInEditableMode:(int)flyerNumber parentViewController:(UIViewController *)parentViewController{
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];

    /****** LOAD FLYER INFORMATION FILE *******/
	NSString *flyerFolderPath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@/Flyr",appDelegate.loginId]];
	NSString *flyerFilePath = [flyerFolderPath stringByAppendingString:[NSString stringWithFormat:@"/IMG_%d.pieces", flyerNumber]];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:flyerFilePath];
    
    /****** LOAD TEMPLATE *******/
	NSString *templateFolderPath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@/Flyr/Template/%d",appDelegate.loginId, flyerNumber]];
    NSData *imageData = [[NSData alloc ]initWithContentsOfMappedFile:[NSString stringWithFormat:@"%@/template.jpg",templateFolderPath]];
    UIImage *flyerImage = [UIImage imageWithData:imageData];
    
    /****** LOAD TEXTS *******/
    NSMutableArray *textArray = [[NSMutableArray alloc] init];
    int index = 0;
    for(NSString *key in dict){
        if([key hasPrefix:@"Text-"]){
            
            NSDictionary *textDict = dict[key];
           // NSLog(@"%@",textDict);
            NSString *text = textDict[@"text"];
            NSString *fontname = textDict[@"fontname"];
            NSString *fontsize = textDict[@"fontsize"];
            NSString *textcolor = textDict[@"textcolor"];
            NSString *textwhitecolor = textDict[@"textWhitecolor"];
            NSString *textbordercolor = textDict[@"textbordercolor"];
            NSString *textborderwhite = textDict[@"textborderWhite"];
            NSString *textX = textDict[@"x"];
            NSString *textY = textDict[@"y"];
            NSString *textWidth = textDict[@"width"];
            NSString *textHeight = textDict[@"height"];
            
            CustomLabel *newMsgLabel = [[CustomLabel alloc]initWithFrame:CGRectMake([textX floatValue], [textY floatValue], [textWidth floatValue], [textHeight floatValue])];
            newMsgLabel.text = text;
            newMsgLabel.font = [UIFont fontWithName:fontname size:[fontsize floatValue]];
            newMsgLabel.backgroundColor = [UIColor clearColor];
            newMsgLabel.textAlignment = UITextAlignmentCenter;
            newMsgLabel.adjustsFontSizeToFitWidth = YES;
            newMsgLabel.lineBreakMode = UILineBreakModeClip;

           newMsgLabel.numberOfLines = 80;
            
            if ([textcolor isEqualToString:@"0.000000, 0.000000, 0.000000"]) {
                if (textwhitecolor != nil) {
                    NSArray *rgb = [textwhitecolor componentsSeparatedByString:@","];
                    newMsgLabel.textColor = [UIColor colorWithWhite:[rgb[0] floatValue] alpha:[rgb[1] floatValue]];
                }
            }else{
                NSArray *rgb = [textcolor componentsSeparatedByString:@","];
                
                newMsgLabel.textColor = [UIColor colorWithRed:[rgb[0] floatValue] green:[rgb[1] floatValue] blue:[rgb[2] floatValue] alpha:1];

            }
 
            if ([textbordercolor isEqualToString:@"0.000000, 0.000000, 0.000000"]) {
                if (textborderwhite != nil) {
                    NSArray *rgbBorder = [textborderwhite componentsSeparatedByString:@","];
                    newMsgLabel.borderColor = [UIColor colorWithWhite:[rgbBorder[0] floatValue] alpha:[rgbBorder[1] floatValue]];

                }
            }else{
                
            NSArray *rgbBorder = [textbordercolor componentsSeparatedByString:@","];
            newMsgLabel.borderColor = [UIColor colorWithRed:[rgbBorder[0] floatValue] green:[rgbBorder[1] floatValue] blue:[rgbBorder[2] floatValue] alpha:1];
            }
            newMsgLabel.lineWidth = 2;
            [newMsgLabel drawRect:CGRectMake(newMsgLabel.frame.origin.x, newMsgLabel.frame.origin.y, newMsgLabel.frame.size.width, newMsgLabel.frame.size.height)];
            [textArray addObject:newMsgLabel];
        }
    }
    
    /****** LOAD PHOTOS *******/
    NSMutableArray *photoArray = [[NSMutableArray alloc] init];
    index = 0;
    for(NSString *key in dict){
        if([key hasPrefix:@"Photo-"]){
            
            NSDictionary *photoDict = dict[key];
            NSString *photoPath = photoDict[@"image"];
            NSString *photoX = photoDict[@"x"];
            NSString *photoY = photoDict[@"y"];
            NSString *photoWidth = photoDict[@"width"];
            NSString *photoHeight = photoDict[@"height"];
            
            NSData *imageData = [[NSData alloc ]initWithContentsOfMappedFile:photoPath];
            UIImage *currentFlyerImage = [UIImage imageWithData:imageData];
            
            UIImageView *newPhotoImgView = [[UIImageView alloc]initWithFrame:CGRectMake([photoX floatValue], [photoY floatValue], [photoWidth floatValue], [photoHeight floatValue])];
            newPhotoImgView.tag = index++;
            newPhotoImgView.image = currentFlyerImage;
            
            CALayer * l = [newPhotoImgView layer];
            [l setMasksToBounds:YES];
            [l setCornerRadius:10];
            [l setBorderWidth:1.0];
            [l setBorderColor:[[UIColor grayColor] CGColor]];
            
            [photoArray addObject:newPhotoImgView];
        }
    }
    
    /****** LOAD SYMBOLS *******/
    NSMutableArray *symbolArray = [[NSMutableArray alloc] init];
    index = 0;
    for(NSString *key in dict){
        if([key hasPrefix:@"Symbol-"]){
            
            NSDictionary *symbolDict = dict[key];
            NSString *symbolPath = symbolDict[@"image"];
            NSString *symbolX = symbolDict[@"x"];
            NSString *symbolY = symbolDict[@"y"];
            NSString *symbolWidth = symbolDict[@"width"];
            NSString *symbolHeight = symbolDict[@"height"];
            
            NSData *imageData = [[NSData alloc ]initWithContentsOfMappedFile:symbolPath];
            UIImage *currentFlyerImage = [UIImage imageWithData:imageData];
            
            UIImageView *newSymbolImgView = [[UIImageView alloc]initWithFrame:CGRectMake([symbolX floatValue], [symbolY floatValue], [symbolWidth floatValue], [symbolHeight floatValue])];
            newSymbolImgView.tag = index++;
            newSymbolImgView.image = currentFlyerImage;
            
            CALayer * l = [newSymbolImgView layer];
            [l setMasksToBounds:YES];
            [l setCornerRadius:10];
            [l setBorderWidth:1.0];
            [l setBorderColor:[[UIColor grayColor] CGColor]];
            
            [symbolArray addObject:newSymbolImgView];
        }
    }
    
    /****** LOAD ICONS *******/
    NSMutableArray *iconArray = [[NSMutableArray alloc] init];
    index = 0;
    for(NSString *key in dict){
        if([key hasPrefix:@"Icon-"]){
            
            NSDictionary *iconDict = dict[key];
            NSString *iconPath = iconDict[@"image"];
            NSString *iconX = iconDict[@"x"];
            NSString *iconY = iconDict[@"y"];
            NSString *iconWidth = iconDict[@"width"];
            NSString *iconHeight = iconDict[@"height"];
            
            NSData *imageData = [[NSData alloc ]initWithContentsOfMappedFile:iconPath];
            UIImage *currentFlyerImage = [UIImage imageWithData:imageData];
            
            UIImageView *newIconImgView = [[UIImageView alloc]initWithFrame:CGRectMake([iconX floatValue], [iconY floatValue], [iconWidth floatValue], [iconHeight floatValue])];
            newIconImgView.tag = index++;
            newIconImgView.image = currentFlyerImage;
            
            CALayer * l = [newIconImgView layer];
            [l setMasksToBounds:YES];
            [l setCornerRadius:10];
            [l setBorderWidth:1.0];
            [l setBorderColor:[[UIColor grayColor] CGColor]];
            
            [iconArray addObject:newIconImgView];
        }
    }
    
    PhotoController *ptController = [[PhotoController alloc]initWithNibName:@"PhotoController" bundle:nil templateParam:flyerImage symbolArrayParam:symbolArray iconArrayParam:iconArray photoArrayParam:photoArray textArrayParam:textArray flyerNumberParam:flyerNumber];
	[parentViewController.navigationController pushViewController:ptController animated:YES];
}

/*
 * Called when edit button is pressed
 */
-(IBAction)onEdit{

    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];

    /****** LOAD FLYER INFORMATION FILE *******/
	NSString *flyerFolderPath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@/Flyr",appDelegate.loginId]];
	NSString *flyerFilePath = [flyerFolderPath stringByAppendingString:[NSString stringWithFormat:@"/IMG_%d.pieces", flyerNumber]];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:flyerFilePath];
    
    if(!dict){
        
        [self showAlert:@"Warning!" message:@"Flyers created with older versions of Flyerly cannot be edited."];

    } else {
        
        [self goBack];
        
        [FlyerOverlayController openFlyerInEditableMode:flyerNumber parentViewController:parentViewController];
    }
}

/*
 * Set a parent view on which this view will be added
 */
-(void)setViews:(UIViewController *)controller{
    parentViewController = controller;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [flyerOverlayImage release];
    [crossButton release];
    [editButton release];
    [overlayRoundedView release];
    
}
@end
