//
//  LocationController.m
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 6/28/13.
//
//

#import "LocationController.h"
#import "LocationItem.h"
#import "PhotoController.h"
#import "Common.h"
#import "SearchLocationItem.h"

#define kClientID       FOURSQUARE_CLIENT_ID
#define kCallbackURL    FOURSQUARE_CALLBACK_URL

@interface LocationController ()
@property(nonatomic,strong) BZFoursquareRequest *request;
@property(nonatomic,copy) NSDictionary *meta;
@property(nonatomic,copy) NSArray *notifications;
@property(nonatomic,copy) NSDictionary *response;

@end

enum {
    kAuthenticationSection = 0,
    kEndpointsSection,
    kResponsesSection,
    kSectionCount
};

enum {
    kAccessTokenRow = 0,
    kAuthenticationRowCount
};

@implementation LocationController
@synthesize uiTableView;
@synthesize request = request_;
@synthesize meta = meta_;
@synthesize notifications = notifications_;
@synthesize response = response_;
@synthesize locationManager;
@synthesize latitude;
@synthesize longitude;
@synthesize searchButton;
@synthesize searchField;
@synthesize darkView;
@synthesize loadingView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
        appDelegate.foursquare = [[BZFoursquare alloc] initWithClientID:kClientID callbackURL:kCallbackURL];
        appDelegate.foursquare.version = @"20111119";
        appDelegate.foursquare.locale = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
        appDelegate.foursquare.sessionDelegate = self;
        
        // locationManager update as location
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        [locationManager startUpdatingLocation];
    }
    
    return self;
}

// this delegate is called when the app successfully finds your current location
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    if(!latitude && !longitude){
        
        // Configure the new event with information from the location
        CLLocationCoordinate2D coordinate = [newLocation coordinate];
        
        self.latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
        self.longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
        
        NSLog(@"Latitude : %@", latitude);
        NSLog(@"Longitude : %@",longitude);
        
        FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
        
        if(![[NSUserDefaults standardUserDefaults] objectForKey:@"FoursquareAccessTokenKey"]){
        //if (![appDelegate.foursquare isSessionValid]) {
            [appDelegate.foursquare startAuthorization];
        } else {
            appDelegate.foursquare.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"FoursquareAccessTokenKey"];
            [self searchVenues];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // title background
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bg_without_logo2"] forBarMetrics:UIBarMetricsDefault];
    
    // Setup cancel button
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 30)];
    [cancelButton addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"camera_cancel"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    [self.navigationItem setRightBarButtonItems:[NSMutableArray arrayWithObjects:rightBarButton,nil]];
    
    [searchField addTarget:self action:@selector(textFieldTapped:) forControlEvents:UIControlEventEditingDidBegin];
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    loadingView =[LoadingView loadingViewInView:self.view  text:@"Search nearby..."];

}

- (void)cancelRequest {
    if (request_) {
        request_.delegate = nil;
        [request_ cancel];
        self.request = nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (void)updateView {
    if ([self isViewLoaded]) {
        NSIndexPath *indexPath = [self.uiTableView indexPathForSelectedRow];
        [self.uiTableView reloadData];
        if (indexPath) {
            [self.uiTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

- (void)prepareForRequest {
    [self cancelRequest];
    self.meta = nil;
    self.notifications = nil;
    self.response = nil;
}

- (void)searchVenues {
    [self prepareForRequest];

    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"%@,%@", self.latitude, self.longitude], @"ll", nil];
    self.request = [appDelegate.foursquare requestWithPath:@"venues/search" HTTPMethod:@"GET" parameters:parameters delegate:self];
    [request_ start];
    [self updateView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)searchNearBy {
    [self prepareForRequest];
    [self updateView];
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"%@,%@", self.latitude, self.longitude], @"ll",@"browse",@"intent",@"5000",@"radius",searchField.text,@"query", nil];

    //NSString *queryString = [NSString stringWithFormat:@"?ll=%@,%@&intent=browse&radius=1000&query=%@",latitude,longitude,@"kara"];
    self.request = [appDelegate.foursquare requestWithPath:[NSString stringWithFormat:@"venues/search"] HTTPMethod:@"GET" parameters:parameters delegate:self];

    [request_ start];
    [self updateView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (IBAction)onBack{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    // set title
    self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Locations" rect:CGRectMake(-50, -6, 50, 50)];
    
    locationDetails = nil;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(searchMode){

        return 2;
        
    } else {
        if(self.response){
            NSDictionary *venues = [self.response objectForKey:@"venues"];
            
            if(venues){
                return [venues count];
            } else {
                return 0;
            }
        }
        
    }

    // return count
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(searchMode){
        
        // Get cell
        static NSString *cellId = @"SearchLocationItem";
        SearchLocationItem *cell = (SearchLocationItem *) [uiTableView dequeueReusableCellWithIdentifier:cellId];
        
        if (cell == nil) {
            NSArray *nib=[[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        
        if(indexPath.row == 0){
        
            cell.label1.text = [NSString stringWithFormat:@"Create %@", searchField.text];
            cell.label2.text = @"Create a custom location";

        } else if(indexPath.row == 1){
        
            cell.label1.text = [NSString stringWithFormat:@"Find %@", searchField.text];
            cell.label2.text = @"Search more places nearby";
        }
        
        // return cell
        return cell;

    } else {
    
        // Get cell
        static NSString *cellId = @"LocationItem";
        LocationItem *cell = (LocationItem *) [uiTableView dequeueReusableCellWithIdentifier:cellId];
        
        if (cell == nil) {
            NSArray *nib=[[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil];
            cell=[nib objectAtIndex:0];
        }
        
        // Set data on screen
        NSArray *venues = [self.response objectForKey:@"venues"];
        id venue = [venues objectAtIndex:indexPath.row];
        // NSLog(@"venues %@", venues);
        
        NSString *name = [venue objectForKey:@"name"];
        cell.name.text = name;
        
        NSDictionary *location = [venue objectForKey:@"location"];
        NSString *address = [location objectForKey:@"address"];
        cell.address.text = address;
        
        // return cell
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"Row selected");
    if(searchMode){
    
        if(indexPath.row == 0){
        
            NSLog(@"Create Location");
            if([searchField text]){
                [[LocationController getLocationDetails] setObject:[searchField text] forKey:@"name"];
                [self onBack];
            }else{
            }
            
        } else if(indexPath.row == 1){            
            searchMode = NO;
            [self searchNearBy];
        }
        
    }else{
    
        // Set data on screen
        NSArray *venues = [self.response objectForKey:@"venues"];
        //NSLog(@"venues: %@", venues);
        NSLog(@"venues count: %d", [venues count]);
        NSLog(@"indexPath.row: %d", indexPath.row);
        
        id venue = [venues objectAtIndex:indexPath.row];
        //NSLog(@"venue: %@", venue);
        
        
        NSDictionary *location = [venue objectForKey:@"location"];
        if([venue objectForKey:@"name"]){
            [[LocationController getLocationDetails] setObject:[venue objectForKey:@"name"] forKey:@"name"];
        }else{
            [[LocationController getLocationDetails] setObject:@"" forKey:@"name"];
        }
        if([location objectForKey:@"address"]){
            [[LocationController getLocationDetails] setObject:[location objectForKey:@"address"] forKey:@"address"];
        }else{
            [[LocationController getLocationDetails] setObject:@"" forKey:@"address"];
        }
        if([location objectForKey:@"lat"]){
            [[LocationController getLocationDetails] setObject:[location objectForKey:@"lat"] forKey:@"lat"];
        }else{
            [[LocationController getLocationDetails] setObject:@"" forKey:@"lat"];
        }
        if([location objectForKey:@"lng"]){
            [[LocationController getLocationDetails] setObject:[location objectForKey:@"lng"] forKey:@"lng"];
        }else{
            [[LocationController getLocationDetails] setObject:@"" forKey:@"lng"];
        }
        
        //NSLog(@"locationDetails after: %@", locationDetails);
        
        NSLog(@"Before onBack");
        [self onBack];
    }
}

NSMutableDictionary *locationDetails;
+(NSMutableDictionary *)getLocationDetails{
    
    if(!locationDetails){
        locationDetails = [[NSMutableDictionary alloc] init];
    }
    
    return locationDetails;
}

- (IBAction)onSearchClick:(UIButton *)sender{
    
    if([searchField canResignFirstResponder])
    {
        [searchField resignFirstResponder];
    }
    
    // search near by
    [self searchNearBy];
}

/*
 * Called when clicked on title text field
 */
- (void)textFieldTapped:(id)sender {
    //enable dark view
    [darkView setHidden:NO];
    searchMode = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(searchMode){

        if([string isEqualToString:@"\n"]){

            if([searchField canResignFirstResponder])
            {
                [searchField resignFirstResponder];
            }

            //disable dark view
            [darkView setHidden:YES];
            searchMode = NO;
            [self searchVenues];
            
        } else {
        
            [darkView setHidden:YES];
            [self switchTableMode];
        }

    }else{
    
        if([string isEqualToString:@"\n"]){
            
            //disable dark view
            [darkView setHidden:YES];
            searchMode = NO;
            
            if([searchField canResignFirstResponder])
            {
                [searchField resignFirstResponder];
            }
            return NO;
        }
    }
    
    return YES;
}

-(void)switchTableMode{
    [self prepareForRequest];
    [self updateView];
}

#pragma mark -
#pragma mark BZFoursquareRequestDelegate

- (void)requestDidFinishLoading:(BZFoursquareRequest *)request {
    
    // Remove loading view
    for (UIView *subview in self.view.subviews) {
        if([subview isKindOfClass:[LoadingView class]]){
            [subview removeFromSuperview];
        }
    }

    self.meta = request.meta;
    self.notifications = request.notifications;
    self.response = request.response;
    self.request = nil;
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.foursquare.accessToken forKey:@"FoursquareAccessTokenKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self updateView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)request:(BZFoursquareRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[[error userInfo] objectForKey:@"errorDetail"] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
    [alertView show];
    self.meta = request.meta;
    self.notifications = request.notifications;
    self.response = request.response;
    self.request = nil;
    [self updateView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark -
#pragma mark BZFoursquareSessionDelegate

- (void)foursquareDidAuthorize:(BZFoursquare *)foursquare {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:kAccessTokenRow inSection:kAuthenticationSection];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    
    [self searchVenues];

    //[self.uiTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void)foursquareDidNotAuthorize:(BZFoursquare *)foursquare error:(NSDictionary *)errorInfo {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, errorInfo);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
