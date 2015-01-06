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
    NSMutableDictionary *curContactDetails;
    BOOL IsCustomized;
}
@property (weak, nonatomic) IBOutlet UITableView *contactDetailsTable;

@end

@implementation ContactCustomizeDetailsControlelrViewController

@synthesize contactModal,untechable,allEmails,allPhoneNumbers,customTextForContact,customizedContactsDictionary;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationDefaults];
    [self setNavigation:@"viewDidLoad"];
    
    _contactDetailsTable.delegate = self;
    _contactDetailsTable.dataSource = self;
    
    self.contactDetailsTable.contentInset = UIEdgeInsetsMake(-32.0f, 0.0f, 0.0f, 0.0f);
    
    if( contactModal.IsCustomized ){
        IsCustomized = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  Navigation functions
- (void)setNavigationDefaults{
    
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
    
    NSMutableArray *customizedContactsModals;
    
    /*if ( IsCustomized ){
    
        [customizedContactsModals addObject:contactModal ];
    }*/

    //untechable.customizedContacts = [untechable.commonFunctions convertCCMArrayIntoJsonString:customizedContactsModals];
    
    //[untechable setOrSaveVars:SAVE];
    if ( IsCustomized ){
        if ( [untechable.customizedContactsForCurrentSession containsObject:contactModal] ){
            
            if ( [contactModal.customTextForContact isEqualToString:untechable.spendingTimeTxt ]
                 &&
                 [contactModal.cutomizingStatusArray objectAtIndex:0] == 0
                &&
                [contactModal.cutomizingStatusArray objectAtIndex:1] == 0
                &&
                [contactModal.cutomizingStatusArray objectAtIndex:2] == 0)
            {
                [untechable.customizedContactsForCurrentSession removeObject:contactModal];
            
            }else {
                
             [untechable.customizedContactsForCurrentSession replaceObjectAtIndex:[untechable.customizedContactsForCurrentSession indexOfObject:contactModal] withObject:contactModal];
                
            }
        }else {
            [untechable.customizedContactsForCurrentSession addObject:contactModal];
        }
    }
    
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
        numberOfRowsInSection = 1;
    }else if ( section == 2 ){
        numberOfRowsInSection = (int)contactModal.allPhoneNumbers.count;
        
    }else if ( section == 3 ){
        numberOfRowsInSection = (int)contactModal.allEmails.count;
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
        
        [cell setCellValues:contactModal.name ContactImage:contactModal.img];
        
        return cell;
    }else if ( indexPath.section == 1 ){
        
        static NSString *cellId = @"CustomText";
        CustomTextTableViewCell *cell = (CustomTextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomTextTableViewCell" owner:self options:nil];
        cell = (CustomTextTableViewCell *)[nib objectAtIndex:0];
        
        [cell.customText setDelegate:self];
        
        [cell.customText setReturnKeyType:UIReturnKeyDone];
        
        if ( contactModal.customTextForContact != nil ){
            
            cell.customText.text = contactModal.customTextForContact;
        }
        return cell;
        
    }else if ( indexPath.section == 2 ){
        
        static NSString *cellId = @"PhoneNumberCell";
        PhoneNumberCell *cell = (PhoneNumberCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PhoneNumberCell" owner:self options:nil];
        
        cell = (PhoneNumberCell *)[nib objectAtIndex:0];
        
        NSMutableArray *allNumbers = contactModal.allPhoneNumbers;
        
        NSMutableArray *numberWithStatus = [allNumbers objectAtIndex:indexPath.row];
        
        [cell setCellValues:[numberWithStatus objectAtIndex:0] Number:[numberWithStatus objectAtIndex:1]];
        
        if ( [[numberWithStatus objectAtIndex:2] isEqualToString:@"1"] ){
            [cell.smsButton setSelected:YES];
        }
        
        if ( [[numberWithStatus objectAtIndex:3] isEqualToString:@"1"] ){
            [cell.callButton setSelected:YES];
        }
        
        cell.untechable = untechable;
        
        [cell setCellModal:contactModal];
        
        [cell.smsButton addTarget:self
                           action:@selector(smsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.callButton addTarget:self
                            action:@selector(callButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        //NSMutableArray *numberWithStatus = [contactModal.allPhoneNumbers objectForKey:[phoneNumberTypes objectAtIndex:indexPath.row]];
    
        /*if ( [contactModal.allPhoneNumbers objectForKey:@"phoneNumbers"] != nil ){
         [cell setCellValues:[phoneNumberTypes objectAtIndex:indexPath.row + 1] Number:[contactModal.allPhoneNumbers objectForKey:[phoneNumberTypes objectAtIndex:indexPath.row + 1]]];
         }else{
         [cell setCellValues:[phoneNumberTypes objectAtIndex:indexPath.row] Number:[contactModal.allPhoneNumbers objectForKey:[phoneNumberTypes objectAtIndex:indexPath.row]]];
         }*/
        
        /*if ( [curContactDetails objectForKey:@"customTextForContact"] != nil ){
            
        }*/
        
        /*NSMutableDictionary *currContactNumbers = [curContactDetails objectForKey:@"phoneNumbers"];
        
        NSArray *numberTypes = [currContactNumbers allKeys];
        
        for ( int i=0; i<numberTypes.count; i++){
            
            
            if ( [cell.nubmerType.text isEqualToString:[numberTypes objectAtIndex:i]]){
                NSMutableArray *customizedNumArray = [currContactNumbers objectForKey:cell.nubmerType.text];
                
                NSString *smsStatus = [customizedNumArray objectAtIndex:1];
                NSString *callStatus = [customizedNumArray objectAtIndex:2];
                
                if ( [smsStatus isEqualToString:@"1"] ){
                    
                    [cell.smsButton setSelected:YES];
                    
                }else if ( [smsStatus isEqualToString:@"0"] ){
                    
                    [cell.smsButton setSelected:NO];
                }
                
                if ( [callStatus isEqualToString:@"1"] ){
                    [cell.callButton setSelected:YES];
                }else if ( [callStatus isEqualToString:@"0"] ){
                    [cell.callButton setSelected:NO];
                }
                
                [currContactNumbers setObject:customizedNumArray forKey:cell.nubmerType.text];
                
                [curContactDetails setObject:currContactNumbers forKey:@"phoneNumbers"];
                
                break;
            }
        }*/
        
        return cell;
        
    }else if ( indexPath.section == 3 ){
        
        static NSString *cellId = @"EmailCell";
        EmailCell *cell = (EmailCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EmailCell" owner:self options:nil];
        cell = (EmailCell *)[nib objectAtIndex:0];
        
        [cell.emailButton addTarget:self
                            action:@selector(emailButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        NSMutableArray *allEmails = contactModal.allEmails;
        
        NSMutableArray *emailWithStatus = [allEmails objectAtIndex:indexPath.row];
        
        if ( [[emailWithStatus objectAtIndex:1] isEqualToString:@"1"] ){
            [cell.emailButton setSelected:YES];
        }
        [cell setCellValues: [emailWithStatus objectAtIndex:0]];
        
        cell.untechable = untechable;
        
        [cell setCellModal:contactModal];
        
        return cell;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(IBAction)emailButtonTapped:(id) sender
{
    IsCustomized = YES;
    EmailCell *emailCell;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.contactDetailsTable];
    NSIndexPath *indexPath = [self.contactDetailsTable indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        emailCell = (EmailCell*)[_contactDetailsTable cellForRowAtIndexPath:indexPath];
    }
    
    NSMutableArray *emailWithStatus =  [contactModal.allEmails objectAtIndex:indexPath.row];
    if ( [[emailWithStatus objectAtIndex:1] isEqualToString:@"1"] ){
        [emailWithStatus setObject:@"0" atIndexedSubscript:1];
        [emailCell.emailButton setSelected:NO];
        [contactModal setEmailStatus:0];
    }else if ( [[emailWithStatus objectAtIndex:1] isEqualToString:@"0"] ){
        [emailWithStatus setObject:@"1" atIndexedSubscript:1];
        [emailCell.emailButton setSelected:YES];
        [contactModal setEmailStatus:1];
    }
    
    [contactModal.allEmails  replaceObjectAtIndex:indexPath.row withObject:emailWithStatus];
}

-(IBAction)callButtonTapped:(id) sender
{
    IsCustomized = YES;
    PhoneNumberCell *phoneCell;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.contactDetailsTable];
    NSIndexPath *indexPath = [self.contactDetailsTable indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        phoneCell = (PhoneNumberCell*)[_contactDetailsTable cellForRowAtIndexPath:indexPath];
    }
    
    NSMutableArray *phoneWithStatus =  [contactModal.allPhoneNumbers objectAtIndex:indexPath.row];
    
    if ( [[phoneWithStatus objectAtIndex:3] isEqualToString:@"1"] ){
        [phoneWithStatus setObject:@"0" atIndexedSubscript:3];
        [phoneCell.callButton setSelected:NO];
        [contactModal setPhoneStatus:0];
    }else if ( [[phoneWithStatus objectAtIndex:3] isEqualToString:@"0"] ){
        [phoneWithStatus setObject:@"1" atIndexedSubscript:3];
        [phoneCell.callButton setSelected:YES];
        [contactModal setPhoneStatus:1];
    }
    
    [contactModal.allPhoneNumbers  replaceObjectAtIndex:indexPath.row withObject:phoneWithStatus];
    
    /*
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
        }
    }
    
    if ( alreadyExist ){
        
        NSMutableDictionary *currContactNumbers = [curContactDetails objectForKey:@"phoneNumbers"];
        
        NSArray *numberTypes = [currContactNumbers allKeys];
        
        if ( [numberTypes containsObject:phoneCell.nubmerType.text] ){
            
            //----
            /*NSArray *allAvailableNumberTypes = [contactModal.allPhoneNumbers allKeys];
            
            for ( int i = 0; i<allAvailableNumberTypes.count; i++ ){
                
                
                if ( [currContactNumbers objectForKey:[allAvailableNumberTypes objectAtIndex:i]] != nil ){
                    
                    NSMutableArray *customizedNumArray = [currContactNumbers objectForKey:phoneCell.nubmerType.text];
                    
                    NSString *callStatus = [customizedNumArray objectAtIndex:2];
                    
                    if ( [callStatus isEqualToString:@"1"] ){
                        [customizedNumArray setObject:@"0" atIndexedSubscript:2];
                        [phoneCell.callButton setSelected:NO];
                    }else if ( [callStatus isEqualToString:@"0"] ){
                        [customizedNumArray setObject:@"1" atIndexedSubscript:2];
                        [phoneCell.callButton setSelected:YES];
                    }
                    
                    [currContactNumbers setObject:customizedNumArray forKey:phoneCell.nubmerType.text];
                    
                    [curContactDetails setObject:currContactNumbers forKey:@"phoneNumbers"];
                    
                    contactModal.allPhoneNumbers = [curContactDetails objectForKey:@"phoneNumbers"];
                    
                    break;
                    
                }
            }
        }else {
            NSMutableArray *customizedNumArray = [[NSMutableArray alloc] initWithCapacity:3];
            
            [customizedNumArray setObject:phoneCell.nubmer.text atIndexedSubscript:0];
            [customizedNumArray setObject:@"0" atIndexedSubscript:1];
            [customizedNumArray setObject:@"1" atIndexedSubscript:2];
            [phoneCell.callButton setSelected:YES];
            
            [currContactNumbers setObject:customizedNumArray forKey:phoneCell.nubmerType.text];
            
            [curContactDetails setObject:currContactNumbers forKey:@"phoneNumbers"];
            
            contactModal.allPhoneNumbers = [curContactDetails objectForKey:@"phoneNumbers"];
        }
        
        
        /*for ( int i=0; i<numberTypes.count; i++){
            
            if ( [cell.nubmerType.text isEqualToString:[numberTypes objectAtIndex:i]]){
                NSMutableArray *customizedNumArray = [currContactNumbers objectForKey:cell.nubmerType.text];
                
                NSString *callStatus = [customizedNumArray objectAtIndex:2];
                
                if ( [callStatus isEqualToString:@"1"] ){
                    [customizedNumArray setObject:@"0" atIndexedSubscript:1];
                    [cell.callButton setSelected:NO];
                }else if ( [callStatus isEqualToString:@"0"] ){
                    [customizedNumArray setObject:@"1" atIndexedSubscript:1];
                    [cell.callButton setSelected:YES];
                }
                
                [currContactNumbers setObject:customizedNumArray forKey:cell.nubmerType.text];
                
                [curContactDetails setObject:currContactNumbers forKey:@"phoneNumbers"];
                
                contactModal.allPhoneNumbers = [curContactDetails objectForKey:@"phoneNumbers"];
                
                break;
            }
        }
        
    }else {
        
        NSMutableDictionary *newCurContactDetails = [[NSMutableDictionary alloc] init];
        
        [newCurContactDetails setObject:contactModal.name forKey:@"contactName"];
        
        NSMutableDictionary *phoneNumbers = [[NSMutableDictionary alloc] init];
        
        NSMutableArray *numberWithStatus = [[NSMutableArray alloc] initWithCapacity:3];
        [numberWithStatus setObject:phoneCell.nubmer.text atIndexedSubscript:0];
        [numberWithStatus setObject:@"0" atIndexedSubscript:1];
        [numberWithStatus setObject:@"1" atIndexedSubscript:2];
        [phoneCell.callButton setSelected:YES];
        
        [phoneNumbers setObject:numberWithStatus forKey:phoneCell.nubmerType.text];
        
        contactModal.allPhoneNumbers = phoneNumbers;
        
        [newCurContactDetails setObject:contactModal.allPhoneNumbers forKey:@"phoneNumbers"];
        
        [newCurContactDetails setObject:contactModal.allEmails forKey:@"emailAddresses"];
        
        [newCurContactDetails setObject:untechable.spendingTimeTxt forKey:@"customTextForContact"];
        
        
        NSMutableArray *customizedContactsModals = [[NSMutableArray alloc] init];
        
        [customizedContactsModals addObject:contactModal];
        
        untechable.customizedContacts = [untechable.commonFunctions convertCCMArrayIntoJsonString:customizedContactsModals];
    }*/
}


-(IBAction)smsButtonTapped:(id) sender
{
    IsCustomized = YES;
    PhoneNumberCell *phoneCell;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.contactDetailsTable];
    NSIndexPath *indexPath = [self.contactDetailsTable indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        phoneCell = (PhoneNumberCell*)[_contactDetailsTable cellForRowAtIndexPath:indexPath];
    }
    
    NSMutableArray *phoneWithStatus =  [contactModal.allPhoneNumbers objectAtIndex:indexPath.row];
    
    if ( [[phoneWithStatus objectAtIndex:2] isEqualToString:@"1"] ){
        [phoneWithStatus setObject:@"0" atIndexedSubscript:2];
        [phoneCell.smsButton setSelected:NO];
        [contactModal setSmsStatus:0];
    }else if ( [[phoneWithStatus objectAtIndex:2] isEqualToString:@"0"] ){
        [phoneWithStatus setObject:@"1" atIndexedSubscript:2];
        [phoneCell.smsButton setSelected:YES];
        [contactModal setSmsStatus:1];
    }
    
    [contactModal.allPhoneNumbers  replaceObjectAtIndex:indexPath.row withObject:phoneWithStatus];
    
    /*
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
             }
        }
    }
    
    if ( alreadyExist ){
    
        NSMutableDictionary *currContactNumbers = [curContactDetails objectForKey:@"phoneNumbers"];
        
        NSArray *numberTypes = [currContactNumbers allKeys];
        
        if ( [numberTypes containsObject:cell.nubmerType.text] ){
        
            //----
            /*NSArray *allAvailableNumberTypes = [contactModal.allPhoneNumbers allKeys];
            
            for ( int i = 0; i<allAvailableNumberTypes.count; i++ ){
            
                if ( [currContactNumbers objectForKey:[allAvailableNumberTypes objectAtIndex:i]] != nil ){
                    
                    NSMutableArray *customizedNumArray = [currContactNumbers objectForKey:cell.nubmerType.text];
                    
                    NSString *smsStatus = [customizedNumArray objectAtIndex:1];
                    
                    if ( [smsStatus isEqualToString:@"1"] ){
                        [customizedNumArray setObject:@"0" atIndexedSubscript:1];
                        [cell.smsButton setSelected:NO];
                    }else if ( [smsStatus isEqualToString:@"0"] ){
                        [customizedNumArray setObject:@"1" atIndexedSubscript:1];
                        [cell.smsButton setSelected:YES];
                    }
                    
                    [currContactNumbers setObject:customizedNumArray forKey:cell.nubmerType.text];
                    
                    [curContactDetails setObject:currContactNumbers forKey:@"phoneNumbers"];
                    
                    contactModal.allPhoneNumbers = [curContactDetails objectForKey:@"phoneNumbers"];
                    
                    break;
                    
                }
            }
            
            //---
            
        }else {
            NSMutableArray *customizedNumArray = [[NSMutableArray alloc] initWithCapacity:3];
            
            [customizedNumArray setObject:cell.nubmer.text atIndexedSubscript:0];
            [customizedNumArray setObject:@"1" atIndexedSubscript:1];
            [cell.smsButton setSelected:YES];
            [customizedNumArray setObject:@"0" atIndexedSubscript:2];
            
            [currContactNumbers setObject:customizedNumArray forKey:cell.nubmerType.text];
            
            [curContactDetails setObject:currContactNumbers forKey:@"phoneNumbers"];
            
            contactModal.allPhoneNumbers = [curContactDetails objectForKey:@"phoneNumbers"];
        }
        
        
        for ( int i=0; i<numberTypes.count; i++){
            
            
            if ( [cell.nubmerType.text isEqualToString:[numberTypes objectAtIndex:i]]){
                NSMutableArray *customizedNumArray = [currContactNumbers objectForKey:cell.nubmerType.text];
                
                NSString *smsStatus = [customizedNumArray objectAtIndex:1];
                
                if ( [smsStatus isEqualToString:@"1"] ){
                    [customizedNumArray setObject:@"0" atIndexedSubscript:1];
                    [cell.smsButton setSelected:NO];
                }else if ( [smsStatus isEqualToString:@"0"] ){
                    [customizedNumArray setObject:@"1" atIndexedSubscript:1];
                    [cell.smsButton setSelected:YES];
                }
                
                [currContactNumbers setObject:customizedNumArray forKey:cell.nubmerType.text];
                
                [curContactDetails setObject:currContactNumbers forKey:@"phoneNumbers"];
                
                contactModal.allPhoneNumbers = [curContactDetails objectForKey:@"phoneNumbers"];
                
                break;
            }
        }
        
        /*NSMutableArray *numberWithStatus =  [contactModal.allPhoneNumbers objectForKey:cell.nubmerType.text];
        
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
        /*}else if ( ![customizedContactNumbers containsObject:cell.nubmer.text] ){
            
            NSMutableArray *numberWithStatus =  [contactModal.allPhoneNumbers objectForKey:cell.nubmerType.text];
            
            /*NSMutableArray *numberWithStatus = [[NSMutableArray alloc] initWithCapacity:3];
            
            // Phone Number at index 0 of this array
            [numberWithStatus setObject:cell.nubmer.text atIndexedSubscript:0];
            
            // SMS status at index 1 of this array
            [numberWithStatus setObject:@"1" atIndexedSubscript:1];
            
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
        
        [contactModal.allPhoneNumbers setValue:customizedContactNumbers forKey:cell.nubmerType.text];
        
        
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
        //[untechable.customizedContacts addObject:contactDict];
    }else {
        
        NSMutableDictionary *newCurContactDetails = [[NSMutableDictionary alloc] init];
        
        [newCurContactDetails setObject:contactModal.name forKey:@"contactName"];
        
        NSMutableDictionary *phoneNumbers = [[NSMutableDictionary alloc] init];
        
        NSMutableArray *numberWithStatus;
        
        /*for ( int i = 0; i< [contactModal.allPhoneNumbers allKeys].count; i++){
        
            
            if ( [cell.nubmerType.text isEqualToString:[[contactModal.allPhoneNumbers allKeys] objectAtIndex:i]] ){
            
                numberWithStatus = [[NSMutableArray alloc] initWithCapacity:3];
                [numberWithStatus setObject:cell.nubmer.text atIndexedSubscript:0];
                [numberWithStatus setObject:@"1" atIndexedSubscript:1];
                [cell.smsButton setSelected:YES];
                [numberWithStatus setObject:@"0" atIndexedSubscript:2];
            }else {
                numberWithStatus = [[NSMutableArray alloc] initWithCapacity:3];
                [numberWithStatus setObject:cell.nubmer.text atIndexedSubscript:0];
                [numberWithStatus setObject:@"0" atIndexedSubscript:1];
                [numberWithStatus setObject:@"0" atIndexedSubscript:2];
            }
        }
    
        [phoneNumbers setObject:numberWithStatus forKey:cell.nubmerType.text];
        
        contactModal.allPhoneNumbers = phoneNumbers;
        
        [newCurContactDetails setObject:contactModal.allPhoneNumbers forKey:@"phoneNumbers"];
        
        [newCurContactDetails setObject:contactModal.allEmails forKey:@"emailAddresses"];
        
        [newCurContactDetails setObject:untechable.spendingTimeTxt forKey:@"customTextForContact"];
        
        NSMutableArray *customizedContactsModals = [[NSMutableArray alloc] init];
        
        [customizedContactsModals addObject:contactModal];
        
        untechable.customizedContacts = [untechable.commonFunctions convertCCMArrayIntoJsonString:customizedContactsModals];
        
        /*NSMutableDictionary *currContactNumbers = [curContactDetails objectForKey:@"phoneNumbers"];
        
        [newCurContactDetails setObject:contactModal.name forKey:@"phoneNumbers"];
        NSMutableDictionary *currContactNumbers = [curContactDetails objectForKey:@"phoneNumbers"];
        
        NSArray *numberTypes = [currContactNumbers allKeys];
        
        currContactNumbers setObject:<#(id)#> forKey:@"phoneNumbers"
        
        NSMutableDictionary *currContactNumbers = [curContactDetails objectForKey:@"phoneNumbers"];
        
        NSArray *numberTypes = [currContactNumbers allKeys];
        
        for ( int i=0; i<numberTypes.count; i++){
            
            
            if ( [cell.nubmerType.text isEqualToString:[numberTypes objectAtIndex:i]]){
                NSMutableArray *customizedNumArray = [currContactNumbers objectForKey:cell.nubmerType.text];
                
                NSString *smsStatus = [customizedNumArray objectAtIndex:1];
                
                if ( [smsStatus isEqualToString:@"1"] ){
                    [customizedNumArray setObject:@"0" atIndexedSubscript:1];
                    [cell.smsButton setSelected:NO];
                }else if ( [smsStatus isEqualToString:@"0"] ){
                    [customizedNumArray setObject:@"1" atIndexedSubscript:1];
                    [cell.smsButton setSelected:YES];
                }
                
                [currContactNumbers setObject:customizedNumArray forKey:cell.nubmerType.text];
                
                [curContactDetails setObject:currContactNumbers forKey:@"phoneNumbers"];
                
                contactModal.allPhoneNumbers = [curContactDetails objectForKey:@"phoneNumbers"];
                
                break;
            }
        }
        
        
        NSMutableArray *customizedContactsModals = [[NSMutableArray alloc] init];
        
        [customizedContactsModals addObject:contactModal];
        
        untechable.customizedContacts = [untechable.commonFunctions convertCCMArrayIntoJsonString:customizedContactsModals];
        
    }*/
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    
    IsCustomized = YES;
    CustomTextTableViewCell *cell = (CustomTextTableViewCell *)[[textView superview] superview];
    
    NSIndexPath *indexPath = [_contactDetailsTable indexPathForCell:cell];
    
    _contactDetailsTable.frame = CGRectMake(_contactDetailsTable.frame.origin.x, _contactDetailsTable.frame.origin.y, _contactDetailsTable.frame.size.width, _contactDetailsTable.frame.size.height - 190);
    //[_contactDetailsTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        CustomTextTableViewCell *customeTextCell;
        CGPoint buttonPosition = [textView convertPoint:CGPointZero toView:self.contactDetailsTable];
        NSIndexPath *indexPath = [self.contactDetailsTable indexPathForRowAtPoint:buttonPosition];
        if (indexPath != nil)
        {
            customeTextCell = (CustomTextTableViewCell*)[_contactDetailsTable cellForRowAtIndexPath:indexPath];
        }
        contactModal.customTextForContact = customeTextCell.customText.text;
        
        [textView resignFirstResponder];
        NSIndexPath *myIP = [NSIndexPath indexPathForRow:0 inSection:0] ;
        _contactDetailsTable.frame= CGRectMake(_contactDetailsTable.frame.origin.x, _contactDetailsTable.frame.origin.y, _contactDetailsTable.frame.size.width, _contactDetailsTable.frame.size.height + 190);
        [_contactDetailsTable scrollToRowAtIndexPath:myIP atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    return YES;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    defGreen = [UIColor colorWithRed:66.0/255.0 green:247.0/255.0 blue:206.0/255.0 alpha:1.0];//GREEN
    defGray = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0];//GRAY
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0)];
    
    UIColor *untachableGreen = [UIColor colorWithRed:(66/255.0) green:(247/255.0) blue:(206/255.0) alpha:1];
    
    headerView.backgroundColor = untachableGreen;
    
    return headerView;
}

- (IBAction)dismissKeyboard:(id)sender;
{
    NSLog(@"asdfasfda");
    //[textField becomeFirstResponder];
    //[textField resignFirstResponder];
}


@end
