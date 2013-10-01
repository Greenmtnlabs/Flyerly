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
    
    // Setup search button
    UIButton *currentLocationButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [currentLocationButton addTarget:self action:@selector(searchNearBy) forControlEvents:UIControlEventTouchUpInside];
    [currentLocationButton setBackgroundImage:[UIImage imageNamed:@"current_location"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:currentLocationButton];
    [self.navigationItem setLeftBarButtonItems:[NSMutableArray arrayWithObjects:leftBarButton,nil]];
    
    [searchField addTarget:self action:@selector(textFieldTapped:) forControlEvents:UIControlEventEditingDidBegin];
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    CostumLocations = [[NSMutableArray alloc] init];
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
    [self showLoadingIndicator];
    
    [self prepareForRequest];

    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"%@,%@", self.latitude, self.longitude], @"ll", nil];
    self.request = [appDelegate.foursquare requestWithPath:@"venues/search" HTTPMethod:@"GET" parameters:parameters delegate:self];
    [request_ start];
    [self updateView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)searchNearBy {
    [self showLoadingIndicator];

    [self prepareForRequest];
    [self updateView];
    
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"%@,%@", self.latitude, self.longitude], @"ll",@"browse",@"intent",@"40000",@"radius",searchField.text,@"query", nil];

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
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(-50, -6, 50, 50)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:TITLE_FONT size:18];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"LOCATIONS";
    self.navigationItem.titleView = label;

    // self.navigationItem.titleView = [PhotoController setTitleViewWithTitle:@"Locations" rect:CGRectMake(-50, -6, 50, 50)];
    
    locationDetails = nil;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(searchMode){
        CostumLocations = [self ReadCustomLocation];
        NSLog(@"%@",CostumLocations);
        return [CostumLocations count] + 2;
        
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
            [cell.imageView setImage:[UIImage imageNamed:@"pencil_icon"]];

        } else if(indexPath.row == 1){
        
            cell.label1.text = [NSString stringWithFormat:@"Find %@", searchField.text];
            cell.label2.text = @"Search more places nearby";
            [cell.imageView setImage:[UIImage imageNamed:@"location_point_selected"]];
        }else{
            if (![searchField.text isEqualToString:@""]) {
            NSRange titleResultsRange = [[CostumLocations objectAtIndex:indexPath.row - 2] rangeOfString:searchField.text options:NSCaseInsensitiveSearch];
            if (titleResultsRange.length > 0){
                cell.label1.text = [NSString stringWithFormat:@"%@", [CostumLocations objectAtIndex:indexPath.row - 2]];
                cell.label2.text = @"Custom Location";
                cell.imageView.image = nil;
               // [cell.imageView setImage:[UIImage imageNamed:@"location_point_selected"]];
            }
            }else{
                cell.label1.text = @"";
                cell.label2.text = @"";
                cell.imageView.image = nil;
            }
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
                locname = [NSString stringWithFormat:@"at %@",[searchField text] ];
                [[LocationController getLocationDetails] setObject:locname forKey:@"name"];
                [self AddCustomLocation:[searchField text]];
                [self onBack];
            }
            
        } else if(indexPath.row == 1){            
            searchMode = NO;
            [self searchNearBy];
        }else{
            locname = [NSString stringWithFormat:@"at %@",[CostumLocations objectAtIndex:indexPath.row -2]];
            [[LocationController getLocationDetails] setObject:locname forKey:@"name"];
             [self onBack];
        }
        
    }else{
    
        // Set data on screen
        NSArray *venues = [self.response objectForKey:@"venues"];
        //NSLog(@"venues: %@", venues);
        NSLog(@"venues count: %d", [venues count]);
        NSLog(@"indexPath.row: %d", indexPath.row);
        
        id venue = [venues objectAtIndex:indexPath.row];
        NSDictionary *location = [venue objectForKey:@"location"];
        
        if([venue objectForKey:@"name"]){
            
            locname = [NSString stringWithFormat:@"at %@",[venue objectForKey:@"name"] ];
            NSLog(@"%@",locname);
            [[LocationController getLocationDetails] setObject:locname forKey:@"name"];
 
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
        [imageFileName release];
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
    [self.uiTableView reloadData];
}

/*
 * Called when clicked on title text field
 */
- (void)textFieldTapped:(id)sender {
   // NSLog(@"%@",searchField.text);
    //enable dark view
    [darkView setHidden:NO];
    searchMode = YES;
}

-(IBAction)updateTextLabelsWithText
{
    if(searchMode){
        
        if([searchField.text isEqualToString:@"\n"]){
            
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
        
        if([searchField.text isEqualToString:@"\n"]){
            
            //disable dark view
            [darkView setHidden:YES];
            searchMode = NO;
            
            if([searchField canResignFirstResponder])
            {
                [searchField resignFirstResponder];
            }
        }
    }
    [self.uiTableView reloadData];
}
/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
    [self.uiTableView reloadData];
    return YES;
}*/

-(void)switchTableMode{
    [self prepareForRequest];
    [self updateView];
}

#pragma mark -
#pragma mark BZFoursquareRequestDelegate

- (void)requestDidFinishLoading:(BZFoursquareRequest *)request {
    
    // Remove loading view
    [self hideLoadingIndicator];

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
    
    // Remove loading view
    [self hideLoadingIndicator];

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

#pragma Custom Locations
-(void)AddCustomLocation:(NSString *)loc{
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    
    NSString *homeDirectoryPath = NSHomeDirectory();
    NSString *usernamePath = [homeDirectoryPath stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@/costumeLocation",appDelegate.loginId]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:usernamePath isDirectory:NULL]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:usernamePath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    NSString *finalImgWritePath = [usernamePath stringByAppendingString:@"/locations.txt"];
    NSLog(@"%@",usernamePath);
    NSLog(@"%@",finalImgWritePath);
    if (![[NSFileManager defaultManager] fileExistsAtPath:finalImgWritePath isDirectory:NULL]) {
       // [[NSFileManager defaultManager] createFileAtPath:finalImgWritePath contents:nil attributes:nil];
    }

    Oldlocation = [[NSMutableArray alloc] initWithContentsOfFile:finalImgWritePath];
    //NSLog(@"%@",Oldlocation);
    if (Oldlocation == nil) {
        NSMutableArray *Addnewlocation = [[NSMutableArray alloc]init];
        [Addnewlocation addObject:loc];
        [Addnewlocation writeToFile:finalImgWritePath atomically:YES];
    }else{    
        [Oldlocation addObject:loc];
        //NSLog(@"%@",Oldlocation);
        [Oldlocation writeToFile:finalImgWritePath atomically:YES];
    }

}

-(NSMutableArray *)ReadCustomLocation{
    FlyrAppDelegate *appDelegate = (FlyrAppDelegate*) [[UIApplication sharedApplication]delegate];
    
    NSString *homeDirectoryPath = NSHomeDirectory();
    NSString *usernamePath = [homeDirectoryPath stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@/costumeLocation",appDelegate.loginId]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:usernamePath isDirectory:NULL]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:usernamePath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    NSString *finalImgWritePath = [usernamePath stringByAppendingString:@"/locations.txt"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:finalImgWritePath isDirectory:NULL]) {
        [[NSFileManager defaultManager] createFileAtPath:finalImgWritePath contents:nil attributes:nil];
    }
    
    Oldlocation = [[NSMutableArray alloc] initWithContentsOfFile:finalImgWritePath];
    NSString *sTemp;
	NSMutableArray *loctemp = [[NSMutableArray alloc]init];
    NSString *searchText = searchField.text;
    [loctemp  removeAllObjects];
    NSLog(@"%@", searchField.text);
    if (![searchField.text isEqualToString:@""]) {
        for (int i =0 ; i < [Oldlocation count] ; i++)
        {
            sTemp = [Oldlocation objectAtIndex:i] ;
            NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (titleResultsRange.length > 0){
                [loctemp addObject:[Oldlocation objectAtIndex:i ]];
            }
        
        }
    }
    
    return loctemp;
}

- (void)dealloc {
    [Oldlocation release];
    [super dealloc];
}

@end
