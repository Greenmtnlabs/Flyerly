//
//  PrintViewController.m
//  Flyr
//
//  Created by Khurram on 15/07/2014.
//
//

#import "PrintViewController.h"
#import "CreateFlyerController.h"
#import "InviteForPrint.h"

@interface PrintViewController () {
    
    NSArray *printAreaArray,*senPostCardAreaArray;
}

@end

@implementation PrintViewController


@synthesize printButton,startButton,flyer,printAreaTableView,sendPostCardAreaTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    printAreaTableView.dataSource = self;
	printAreaTableView.delegate = self;
    sendPostCardAreaTableView.dataSource = self;
	sendPostCardAreaTableView.delegate = self;
    
    printAreaArray = [NSArray arrayWithObjects: @"Print flyers using AirPrint supported printers.",
                               @"Recommended size is a 4 x 4 inches postcard.",
                               nil];
    senPostCardAreaArray = [NSArray arrayWithObjects: @"Let us print and mail your postcards.",
                                     @"Just select contacts from your address book.",
                                     @"We will print & mail the postcard on a 4 x 6 inches card.",
                                     nil];
    
    // Do any additional setup after loading the view from its nib.
    // setting border for login/restore purchases button
    
    //Setting up border on start button
    startButton.layer.borderWidth=1.0f;
    [startButton.layer setCornerRadius:3.0];
    startButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    
    //Setting up border on print button
    printButton.layer.borderWidth=1.0f;
    [printButton.layer setCornerRadius:3.0];
    printButton.layer.borderColor=[[UIColor colorWithRed:0 green:155.0/255.0 blue:224.0/255.0 alpha:1.0] CGColor];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == printAreaTableView)
        return  printAreaArray.count;
    else {
        return senPostCardAreaArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ( [tableView isEqual:self.printAreaTableView] ){
        
        static NSString *cellId = @"FreeFeatureCell";
        FreeFeatureCell *freeFeatureCell = (FreeFeatureCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        
        NSArray *nib;
        [freeFeatureCell setAccessoryType:UITableViewCellAccessoryNone];
        if (freeFeatureCell == nil) {
            if (IS_IPHONE_5 || IS_IPHONE_4){
            nib = [[NSBundle mainBundle] loadNibNamed:@"FreeFeatureCell" owner:self options:nil];
            }
            
            if ( IS_IPHONE_6 || IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS){
                nib = [[NSBundle mainBundle] loadNibNamed:@"FreeFeatureCell-iPhone6" owner:self options:nil];
            }
            freeFeatureCell = (FreeFeatureCell *)[nib objectAtIndex:0];
        }
        
        // Getting the product against tapped/selected cell
        NSString *text = [printAreaArray objectAtIndex:indexPath.row];
       
        //Setting the packagename,packageprice,packagedesciption values for cell view
        [freeFeatureCell setCellValueswithProductTitle:nil ProductDescription:text];
        [freeFeatureCell setCellValuesSize];
        
        return freeFeatureCell;
        
    }else {
        
        static NSString *cellId = @"FreeFeatureCell";
        FreeFeatureCell *freeFeatureCell = (FreeFeatureCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        [freeFeatureCell setAccessoryType:UITableViewCellAccessoryNone];
        NSArray *nib;
        if (freeFeatureCell == nil) {
            if (IS_IPHONE_5 || IS_IPHONE_4){
                nib = [[NSBundle mainBundle] loadNibNamed:@"FreeFeatureCell" owner:self options:nil];
            }
            
            if ( IS_IPHONE_6 || IS_IPHONE_6_PLUS || IS_IPHONE_XR || IS_IPHONE_XS){
                nib = [[NSBundle mainBundle] loadNibNamed:@"FreeFeatureCell-iPhone6" owner:self options:nil];
            }
            freeFeatureCell = (FreeFeatureCell *)[nib objectAtIndex:0];

        }
        
        NSString *text = [senPostCardAreaArray objectAtIndex:indexPath.row];
        
        [freeFeatureCell setCellValueswithProductTitle:nil ProductDescription:text];
        [freeFeatureCell setCellValuesColourWhite];
        [freeFeatureCell setCellValuesSize];
        
        return freeFeatureCell;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissPrintViewPanel:(UIButton *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onPrintFlyer:(UIButton *)sender {
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
        if (!completed && error) NSLog(@"Print error: %@", error);
    };
    
    NSString *imageToPrintPath = [flyer getFlyerImage];
    UIImage *imageToPrint =  [UIImage imageWithContentsOfFile:imageToPrintPath];
    pic.printingItem = imageToPrint;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //[printController presentFromRect:printButton.frame inView:printButton.superview
                                //animated:YES completionHandler:completionHandler];
    } else {
        [pic presentAnimated:YES completionHandler:completionHandler];
    }
}

- (IBAction)startButton:(UIButton *)sender {
    
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PrintViewControllerDismissed"
                                                        object:nil
                                                      userInfo:nil];
}

@end
