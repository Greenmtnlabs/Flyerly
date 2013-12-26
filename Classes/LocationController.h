//
//  LocationController.h
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 6/28/13.
//
//

#import <UIKit/UIKit.h>
#import "BZFoursquare.h"
#import <CoreLocation/CoreLocation.h>
#import "FlyrAppDelegate.h"
#import "ParentViewController.h"

@interface LocationController : ParentViewController <BZFoursquareRequestDelegate, BZFoursquareSessionDelegate, CLLocationManagerDelegate, UITextFieldDelegate>{

    IBOutlet UITableView *uiTableView;
    IBOutlet UITextField *searchField;
    IBOutlet UIButton *searchButton;
    IBOutlet UIView *darkView;
	NSString *imageFileName;
    BZFoursquareRequest *request_;
    NSDictionary        *meta_;
    NSArray             *notifications_;
    NSDictionary        *response_;
    
    CLLocationManager *locationManager;
    NSString *latitude;
    NSString *longitude;
    NSString *locname;
    BOOL searchMode;
    NSMutableArray *CostumLocations;
    NSMutableArray *Oldlocation;
    
}

@property(nonatomic,strong) IBOutlet UITableView *uiTableView;
@property(nonatomic,strong) IBOutlet UITextField *searchField;
@property(nonatomic,strong) IBOutlet UIButton *searchButton;
@property(nonatomic,strong) IBOutlet UIView *darkView;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;

- (IBAction)onSearchClick:(UIButton *)sender;
+(NSMutableDictionary *)getLocationDetails;
-(void)AddCustomLocation:(NSString *)loc;
-(NSMutableArray *)ReadCustomLocation;
-(IBAction)updateTextLabelsWithText;

@end
