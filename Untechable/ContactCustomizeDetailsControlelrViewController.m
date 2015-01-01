//
//  ContactCustomizeDetailsControlelrViewController.m
//  Untechable
//
//  Created by RIKSOF Developer on 12/26/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import "ContactCustomizeDetailsControlelrViewController.h"
#import "FirstTableViewCell.h"
#import "PhoneNumberCell.h"
#import "EmailCell.h"
#import "CustomTextTableViewCell.h"
#import "Common.h"

@interface ContactCustomizeDetailsControlelrViewController (){

    int rowsInFirstSection,rowsInSecondSection;
    NSArray *phoneNumberTypes;
    //NSMutableDictionary *currContactNumbers;
    //NSMutableArray *customizedContactNumbers;
    NSMutableDictionary *curContactDetails;
    BOOL alreadyExist;
}
@property (weak, nonatomic) IBOutlet UITableView *contactDetailsTable;

@end

@implementation ContactCustomizeDetailsControlelrViewController

@synthesize contactModal,untechable;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationDefaults];
    [self setNavigation:@"viewDidLoad"];

    phoneNumberTypes = [contactModal.allPhoneNumbers allKeys];
    
    NSString *customizedContactsString = untechable.customizedContacts;
    
    NSError *writeError = nil;
    
    NSMutableDictionary *customizedContactsDictionary =
    [NSJSONSerialization JSONObjectWithData: [customizedContactsString dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: &writeError];
    
    if ( ![customizedContactsString isEqualToString:@""] ){
        
        for ( int i = 0; i < customizedContactsDictionary.count; i++ ){
            
            curContactDetails =  [customizedContactsDictionary objectForKey:[NSString stringWithFormat:@"%i",i]];
            
            
            
            if ( [[curContactDetails objectForKey:@"contactName"] isEqualToString:contactModal.name] ){
                
                [curContactDetails setObject:contactModal.customTextForContact forKey:@"customTextForContact"];
                NSString *customText = [curContactDetails objectForKey:@"customTextForContact"];
                [contactModal.customTextForContact isEqualToString:customText];
                
                alreadyExist = YES;
            }else {
                [curContactDetails setObject:contactModal.customTextForContact forKey:@"customTextForContact"];
                [curContactDetails setObject:contactModal.allPhoneNumbers forKey:@"phoneNumbers"];
                [curContactDetails setObject:contactModal.allEmails forKey:@"emailAddresses"];
                [curContactDetails setObject:contactModal.name forKey:@"contactName"];
            }
        }
    }else {
        
        curContactDetails = [[NSMutableDictionary alloc] init];
       
    }
    
    
    /*if ( [contactModal.allPhoneNumbers objectForKey:@"phoneNumbers"] != nil ){
       
        phoneNumberTypes = (NSMutableArray *)[contactModal.allPhoneNumbers allKeys];
        
        [phoneNumberTypes removeObjectAtIndex:0];
        
        for ( int i = 0; i<contactModal.allPhoneNumbers.count; i++){
            
            if ( i != 0 ){
                
                phoneNumberTypes = [contactModal.allPhoneNumbers 
            }
        }
        numberOfRowsInSection = (int)contactModal.allPhoneNumbers.count - 1;
    }else{
        phoneNumberTypes = [contactModal.allPhoneNumbers allKeys];
    }*/
    
    
    _contactDetailsTable.delegate = self;
    _contactDetailsTable.dataSource = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  Navigation functions
- (void)setNavigationDefaults{
    
    /*
     NSDateFormatter *df = [[NSDateFormatter alloc] init];
     [df setDateFormat:@"EEEE, dd MMMM yyyy HH:mm"];
     NSDate *date = [df dateFromString:@"Sep 25, 2014 05:27 PM"];
     NSLog(@"\n\n  DATE: %@ \n\n\n", date);
     */
    
    defGreen = [UIColor colorWithRed:66.0/255.0 green:247.0/255.0 blue:206.0/255.0 alpha:1.0];//GREEN
    defGray = [UIColor colorWithRed:184.0/255.0 green:184.0/255.0 blue:184.0/255.0 alpha:1.0];//GRAY
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES]; //show navigation bar
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

-(void)setNavigation:(NSString *)callFrom
{
    if([callFrom isEqualToString:@"viewDidLoad"])
    {
        self.navigationItem.hidesBackButton = YES;
        
        // Center title __________________________________________________
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];
        
        // Back Navigation button
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        backButton.titleLabel.shadowColor = [UIColor clearColor];
        backButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [backButton setTitle:TITLE_BACK_TXT forState:normal];
        [backButton setTitleColor:defGray forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchDown];
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        backButton.showsTouchWhenHighlighted = YES;
        
        UIBarButtonItem *lefttBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        [self.navigationItem setLeftBarButtonItem:lefttBarButton];//Left button ___________
        
        /*
        // Right Navigation ______________________________________________
        nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        //[nextButton setBackgroundColor:[UIColor redColor]];//for testing
        
        nextButton.titleLabel.shadowColor = [UIColor clearColor];
        //nextButton.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
        
        [nextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        //[nextButton setBackgroundImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
        nextButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [nextButton setTitle:TITLE_NEXT_TXT forState:normal];
        [nextButton setTitleColor:defGray forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(btnNextTouchStart) forControlEvents:UIControlEventTouchDown];
        [nextButton addTarget:self action:@selector(btnNextTouchEnd) forControlEvents:UIControlEventTouchUpInside];
        
        nextButton.showsTouchWhenHighlighted = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,nil];
        
        [self.navigationItem setRightBarButtonItems:rightNavItems];//Right button ___________*/
    }
}

-(void) goBack {
    
    NSMutableArray *customizedContactsModals = [[NSMutableArray alloc] init];
    
    [customizedContactsModals addObject:contactModal];
    
    untechable.customizedContacts = [untechable.commonFunctions convertCCMArrayIntoJsonString:customizedContactsModals];
    
    [untechable setOrSaveVars:SAVE];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnNextTouchStart{
    [self setNextHighlighted:YES];
}
-(void)btnNextTouchEnd{
    [self setNextHighlighted:NO];
}
- (void)setNextHighlighted:(BOOL)highlighted {
    (highlighted) ? [nextButton setBackgroundColor:defGreen] : [nextButton setBackgroundColor:[UIColor clearColor]];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int numberOfRowsInSection;
    if ( section == 0 ){
        numberOfRowsInSection = 1;
    }else if ( section == 1 ){
    
        numberOfRowsInSection = (int)contactModal.allPhoneNumbers.count;
        
        /*if ( [contactModal.allPhoneNumbers objectForKey:@"phoneNumbers"] != nil ){
            numberOfRowsInSection = (int)contactModal.allPhoneNumbers.count - 1;
        }else{
            numberOfRowsInSection = (int)contactModal.allPhoneNumbers.count;
        }*/
        
    }else if ( section == 2 ){
        numberOfRowsInSection = (int)contactModal.allEmails.count;
    }else if ( section == 3 ){
        numberOfRowsInSection = 1;
    }
    //return sectionHeader;
    return  numberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if ( indexPath.section == 0 ){
        static NSString *cellId = @"FirstTableViewCell";
        FirstTableViewCell *cell = (FirstTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FirstTableViewCell" owner:self options:nil];
        cell = (FirstTableViewCell *)[nib objectAtIndex:0];
        
        [cell setCellValues:contactModal.name ContactModal:contactModal];
        
        return cell;
    }else if ( indexPath.section == 1 ){
        
        static NSString *cellId = @"PhoneNumberCell";
        PhoneNumberCell *cell = (PhoneNumberCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PhoneNumberCell" owner:self options:nil];
        cell = (PhoneNumberCell *)[nib objectAtIndex:0];

        NSMutableArray *numberWithStatus = [contactModal.allPhoneNumbers objectForKey:[phoneNumberTypes objectAtIndex:indexPath.row]];
                                            
        [cell setCellValues:[phoneNumberTypes objectAtIndex:indexPath.row] Number:[numberWithStatus objectAtIndex:0]];
        
        /*if ( [contactModal.allPhoneNumbers objectForKey:@"phoneNumbers"] != nil ){
            [cell setCellValues:[phoneNumberTypes objectAtIndex:indexPath.row + 1] Number:[contactModal.allPhoneNumbers objectForKey:[phoneNumberTypes objectAtIndex:indexPath.row + 1]]];
        }else{
            [cell setCellValues:[phoneNumberTypes objectAtIndex:indexPath.row] Number:[contactModal.allPhoneNumbers objectForKey:[phoneNumberTypes objectAtIndex:indexPath.row]]];
        }*/
        
        
        
        cell.untechable = untechable;
        
        [cell setCellModal:contactModal];
        
        [cell.smsButton addTarget:self
                   action:@selector(smsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

        [cell.callButton addTarget:self
                           action:@selector(callButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
        
    }else if ( indexPath.section == 2 ){
        
        static NSString *cellId = @"EmailCell";
        EmailCell *cell = (EmailCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EmailCell" owner:self options:nil];
        cell = (EmailCell *)[nib objectAtIndex:0];
        
        NSMutableArray *aar = [[NSMutableArray alloc] initWithArray:contactModal.allEmails];
        
        [cell setCellValues: [aar objectAtIndex:indexPath.row]];
        
        cell.untechable = untechable;
        
        [cell setCellModal:contactModal];
        
        return cell;
        
    }else if ( indexPath.section == 3 ){
        
        static NSString *cellId = @"CustomText";
        CustomTextTableViewCell *cell = (CustomTextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomTextTableViewCell" owner:self options:nil];
        cell = (CustomTextTableViewCell *)[nib objectAtIndex:0];
        
        [cell.customText setDelegate:self];
        
        [cell.customText setReturnKeyType:UIReturnKeyDone];
        
        if ( [curContactDetails objectForKey:@"customTextForContact"] != nil )
        {
            if ( ![[curContactDetails objectForKey:@"customTextForContact"] isEqualToString:untechable.spendingTimeTxt] ){
                
                cell.customText.text = [curContactDetails objectForKey:@"customTextForContact"];
                
            }else{
                
                [cell setCellValues: untechable.spendingTimeTxt];
                
            }
        }else{
            
            [cell setCellValues: untechable.spendingTimeTxt];
            
        }
        
        [cell setCellModal:contactModal];
        
        return cell;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(IBAction)smsButtonTapped:(id) sender
{
    PhoneNumberCell *cell = (PhoneNumberCell *)[[sender superview] superview];
    
    BOOL alreadyExist = NO;
    
    NSString *customizedContactsString = untechable.customizedContacts;
    
    NSError *writeError = nil;
    
    NSMutableDictionary *customizedContactsDictionary =
    [NSJSONSerialization JSONObjectWithData: [customizedContactsString dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: &writeError];
    
    if ( ![customizedContactsString isEqualToString:@""] ){
        
        for ( int i = 0; i < customizedContactsDictionary.count; i++ ){
            
            curContactDetails =  [customizedContactsDictionary objectForKey:[NSString stringWithFormat:@"%i",i]];
            
            if ( [[curContactDetails objectForKey:@"contactName"] isEqualToString:contactModal.name] ){
                
                
                alreadyExist = YES;
            }
            
            /*NSMutableDictionary *curContactDetails = [[NSMutableDictionary alloc] init];
             
             curContactDetails = [JSON objectForKey:[@"%i",i]];
             
             ContactsCustomizedModal *curObj =  [value_ objectAtIndex:i];
             [curContactDetails setValue:curObj.name forKey:@"contactName"];
             [curContactDetails setValue:curObj.allPhoneNumbers forKey:@"phoneNumbers"];
             [curContactDetails setValue:curObj.allEmails forKey:@"emailAddresses"];
             
             
             //tempModal = [untechable.customizedContacts objectAtIndex:i];
             
             if ( [tempModal.name isEqualToString:contactModal.name] ){
             
             alreadyExist = YES;
             }*/
        }
    }
    
    if ( alreadyExist ){
        
        NSMutableDictionary *currContactNumbers = [curContactDetails objectForKey:@"phoneNumbers"];
        
        NSMutableArray *numberWithStatus =  [contactModal.allPhoneNumbers objectForKey:cell.nubmerType.text];
        
        NSMutableArray *customizedContactNumbers = [currContactNumbers objectForKey:@"phoneNumbers"];
        
        if ( [customizedContactNumbers containsObject:cell.nubmer.text] ){
            
            if ( [[numberWithStatus objectAtIndex:1] isEqualToString:@"1"] ) {
                
                [numberWithStatus setObject:@"0" atIndexedSubscript:1];
                
            }else if ( [[numberWithStatus objectAtIndex:1] isEqualToString:@"0"] ) {
                
                [numberWithStatus setObject:@"1" atIndexedSubscript:1];
            }
            
            /*for ( int k = 0; k<customizedContactNumbers.count; k++ ){
                NSMutableArray *customizedContactNumbersDetails = [customizedContactNumbers objectAtIndex:k];
                
                if ( [[customizedContactNumbersDetails objectAtIndex:1] isEqualToString:@"1"] ) {
                    
                    [customizedContactNumbersDetails setObject:@"0" atIndexedSubscript:1];
                    
                }else if ( [[customizedContactNumbersDetails objectAtIndex:1] isEqualToString:@"0"] ) {
                    
                    [customizedContactNumbersDetails setObject:@"1" atIndexedSubscript:1];
                }
            }*/
        }else if ( ![customizedContactNumbers containsObject:cell.nubmer.text] ){
            
            NSMutableArray *numberWithStatus =  [contactModal.allPhoneNumbers objectForKey:cell.nubmerType.text];
            
            /*NSMutableArray *numberWithStatus = [[NSMutableArray alloc] initWithCapacity:3];
            
            // Phone Number at index 0 of this array
            [numberWithStatus setObject:cell.nubmer.text atIndexedSubscript:0];
            
            // SMS status at index 1 of this array
            [numberWithStatus setObject:@"1" atIndexedSubscript:1];*/
            
            [numberWithStatus setObject:@"1" atIndexedSubscript:1];
            
            [cell.smsButton setSelected:YES];
            
            [customizedContactNumbers addObject:numberWithStatus];
         
            [contactModal.allPhoneNumbers setValue:customizedContactNumbers forKey:@"phoneNumbers"];
            
            [cell.smsButton setSelected:YES];
            
        }
    
    }else {
        
        /*NSMutableArray *numberWithStatus = [[NSMutableArray alloc] initWithCapacity:3];
        
        // Phone Number at index 0 of this array
        [numberWithStatus setObject:cell.nubmer.text atIndexedSubscript:0];
        
        // SMS status at index 1 of this array
        [numberWithStatus setObject:@"1" atIndexedSubscript:1];
        
        NSMutableArray *customizedContactNumbers = [[NSMutableArray alloc] init];
        
        [customizedContactNumbers addObject:numberWithStatus];
        
        [contactModal.allPhoneNumbers setValue:customizedContactNumbers forKey:cell.nubmerType.text];*/
        
        
        NSMutableArray *numberWithStatus =  [contactModal.allPhoneNumbers objectForKey:cell.nubmerType.text];
        
        [numberWithStatus setObject:@"1" atIndexedSubscript:1];
        
        [cell.smsButton setSelected:YES];
        
        NSMutableArray *customizedContactsModals = [[NSMutableArray alloc] init];
        
        [customizedContactsModals addObject:contactModal];
        
        untechable.customizedContacts = [untechable.commonFunctions convertCCMArrayIntoJsonString:customizedContactsModals];
        
        //-(NSArray *)convertJsonStringIntoArray:(NSString *)value
        
        //[untechable.customizedContacts addObject:contactDict];
        /*
        
        NSMutableArray *temp = [[NSMutableArray alloc] init];
    
        NSMutableArray *contactArray = [[NSMutableArray alloc] init];
        
        NSMutableDictionary *contactDict = [[NSMutableDictionary alloc] init];
        
        [contactDict setObject:contactModal forKey:contactModal.name];
        
        NSMutableDictionary *status = [[NSMutableDictionary alloc] init];
        
        NSMutableArray *allStatus = [[ NSMutableArray alloc] initWithCapacity:2];
        
        [allStatus insertObject:@"YES" atIndex:0];
        
        [status setObject:allStatus forKey:cell.nubmerType.text];
        
        [temp addObject:status];
        
        [temp_ addObject:contactModal];
        
        contactModal.phoneNumbersStatus  = temp;
        
        //-(NSArray *)convertJsonStringIntoArray:(NSString *)value
        untechable.customizedContacts = [untechable.commonFunctions convertArrayIntoJsonString:temp_];
        //[untechable.customizedContacts addObject:contactDict];*/
    }
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    
    CustomTextTableViewCell *cell = (CustomTextTableViewCell *)[[textView superview] superview];
    
    NSIndexPath *indexPath = [_contactDetailsTable indexPathForCell:cell];
    
    _contactDetailsTable.frame= CGRectMake(_contactDetailsTable.frame.origin.x, _contactDetailsTable.frame.origin.y, _contactDetailsTable.frame.size.width, _contactDetailsTable.frame.size.height - 190);
    [_contactDetailsTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        CustomTextTableViewCell *cell = (CustomTextTableViewCell *)[[textView superview] superview];
        
        //contactModal.customTextForContact = cell.customText.text;
        
        [curContactDetails setObject:cell.customText.text forKey:@"customTextForContact"];
        contactModal.customTextForContact = [curContactDetails objectForKey:@"customTextForContact"];
        
        [textView resignFirstResponder];
        NSIndexPath *myIP = [NSIndexPath indexPathForRow:0 inSection:0] ;
        _contactDetailsTable.frame= CGRectMake(_contactDetailsTable.frame.origin.x, _contactDetailsTable.frame.origin.y, _contactDetailsTable.frame.size.width, _contactDetailsTable.frame.size.height + 190);
        [_contactDetailsTable scrollToRowAtIndexPath:myIP atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    return YES;
}



- (IBAction)dismissKeyboard:(id)sender;
{
    NSLog(@"asdfasfda");
    //[textField becomeFirstResponder];
    //[textField resignFirstResponder];
}



-(IBAction)callButtonTapped:(id) sender
{
    
}


@end
