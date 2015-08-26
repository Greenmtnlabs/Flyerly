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
    UITextView *textView;
    
    // Temporary variable, to hold the data unless it is saved in model
    NSString *tempCustomTextForContact;
    NSMutableArray *tempAllEmails, *tempAllPhoneNumbers;
}
@property (weak, nonatomic) IBOutlet UITableView *contactDetailsTable;

@end

@implementation ContactCustomizeDetailsControlelrViewController

@synthesize contactModal,untechable;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTampVariables];
    
    [self setNavigationDefaults];
    [self setNavigation:@"viewDidLoad"];
    
    _contactDetailsTable.delegate = self;
    _contactDetailsTable.dataSource = self;
    
    self.contactDetailsTable.contentInset = UIEdgeInsetsMake(-32.0f, 0.0f, 0.0f, 0.0f);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  Navigation functions
- (void)setNavigationDefaults{
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES]; //show navigation bar
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

-(void)setNavigation:(NSString *)callFrom
{
    if([callFrom isEqualToString:@"viewDidLoad"])
    {
        self.navigationItem.hidesBackButton = YES;
        
        // Center title
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];
        
        // Back Navigation button
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        backButton.titleLabel.shadowColor = [UIColor clearColor];
        backButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [backButton setTitle:NSLocalizedString(TITLE_BACK_TXT, nil) forState:normal];
        [backButton setTitleColor:DEF_GRAY forState:UIControlStateNormal];
        
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        backButton.showsTouchWhenHighlighted = YES;
        
        UIBarButtonItem *lefttBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        // adds Left button to navigation
        [self.navigationItem setLeftBarButtonItem:lefttBarButton];
        
        // Right Navigation
        saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        saveButton.titleLabel.shadowColor = [UIColor clearColor];
        [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        saveButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [saveButton setTitle:TITLE_SAVE_TXT forState:normal];
        [saveButton setTitleColor:DEF_GRAY forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(btnNextTouchStart) forControlEvents:UIControlEventTouchDown];
        [saveButton addTarget:self action:@selector(btnNextTouchEnd) forControlEvents:UIControlEventTouchUpInside];
        
        saveButton.showsTouchWhenHighlighted = YES;
        saveButton.hidden = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,nil];
        
        // adds Right button to navigation
        [self.navigationItem setRightBarButtonItems:rightNavItems];
    }
}


-(void) goBack {
    [self restoreOldStateFromTemp];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnNextTouchStart{
    [self setNextHighlighted:YES];
}
-(void)btnNextTouchEnd{
    [self setNextHighlighted:NO];
}
- (void)setNextHighlighted:(BOOL)highlighted {
    (highlighted) ? [saveButton setBackgroundColor:DEF_GREEN] : [saveButton setBackgroundColor:[UIColor clearColor]];
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
    return  numberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if ( indexPath.section == 0 ){
        static NSString *cellId = @"FirstTableViewCell";
        FirstTableViewCell *cell = (FirstTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        
        if ( cell == nil ) {
            
            if( IS_IPHONE_5 ){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FirstTableViewCell" owner:self options:nil];
                cell = (FirstTableViewCell *)[nib objectAtIndex:0];
            } else if ( IS_IPHONE_6 ){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FirstTableViewCell-iPhone6" owner:self options:nil];
                cell = (FirstTableViewCell *)[nib objectAtIndex:0];
            } else if ( IS_IPHONE_6_PLUS ) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FirstTableViewCell-iPhone6-Plus" owner:self options:nil];
                cell = (FirstTableViewCell *)[nib objectAtIndex:0];
            } else if (IS_IPHONE_4){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FirstTableViewCell" owner:self options:nil];
                cell = (FirstTableViewCell *)[nib objectAtIndex:0];
            }
        }
        
        NSString *valueToBeShown =[ NSString stringWithFormat:NSLocalizedString(@"Message to %@\n", nil),contactModal.contactName];
        [cell setCellValues:valueToBeShown ContactImage:contactModal.img];
        
        cell.contact_Name.numberOfLines = 0;
        [cell.contact_Name sizeToFit];
        
        return cell;
    }else if ( indexPath.section == 1 ){
        
        static NSString *cellId = @"CustomText";
        CustomTextTableViewCell *cell = (CustomTextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    
        if ( cell == nil ) {
            
            if( IS_IPHONE_5 ){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomTextTableViewCell" owner:self options:nil];
                cell = (CustomTextTableViewCell *)[nib objectAtIndex:0];
            } else if ( IS_IPHONE_6 ){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomTextTableViewCell-iPhone6" owner:self options:nil];
                cell = (CustomTextTableViewCell *)[nib objectAtIndex:0];
            } else if ( IS_IPHONE_6_PLUS ) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomTextTableViewCell-iPhone6-Plus" owner:self options:nil];
                cell = (CustomTextTableViewCell *)[nib objectAtIndex:0];
            } else if (IS_IPHONE_4){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomTextTableViewCell" owner:self options:nil];
                cell = (CustomTextTableViewCell *)[nib objectAtIndex:0];
            }
        }
        
        [cell.customText setDelegate:self];
        cell.customText.textColor = DEF_GREEN;
        textView = cell.customText;
        
        [cell.customText setReturnKeyType:UIReturnKeyDone];
        
        if ( contactModal.customTextForContact != nil ){
            
            cell.customText.text = contactModal.customTextForContact;
        }
        
        [cell setCellValuesWithDeleg:contactModal.customTextForContact deleg:self];
        
        return cell;
        
    }else if ( indexPath.section == 2 ){
        
        static NSString *cellId = @"PhoneNumberCell";
        PhoneNumberCell *cell = (PhoneNumberCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        
        if ( cell == nil ) {
            
            if( IS_IPHONE_5 ){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PhoneNumberCell" owner:self options:nil];
                cell = (PhoneNumberCell *)[nib objectAtIndex:0];
            } else if ( IS_IPHONE_6 ){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PhoneNumberCell-iPhone6" owner:self options:nil];
                cell = (PhoneNumberCell *)[nib objectAtIndex:0];
            } else if ( IS_IPHONE_6_PLUS ) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PhoneNumberCell-iPhone6-Plus" owner:self options:nil];
                cell = (PhoneNumberCell *)[nib objectAtIndex:0];
            } else if (IS_IPHONE_4) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PhoneNumberCell" owner:self options:nil];
                cell = (PhoneNumberCell *)[nib objectAtIndex:0];

            }
        }
        
        NSMutableArray *numberWithStatus = contactModal.allPhoneNumbers[indexPath.row];
        BOOL smsBtnStatus = NO;
        BOOL callButton = NO;
        if ( [numberWithStatus[2] isEqualToString:@"1"] ){
            smsBtnStatus = YES;
        }
        if ( [numberWithStatus[3] isEqualToString:@"1"] ){
            callButton = YES;
        }

        [cell setCellValues:numberWithStatus[0] Number:numberWithStatus[1]];
        [cell.smsButton setSelected:smsBtnStatus];
        [cell.callButton setSelected:callButton];
        [cell.smsButton addTarget:self
                           action:@selector(smsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.callButton addTarget:self
                            action:@selector(callButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
        
    }else if ( indexPath.section == 3 ){
        
        static NSString *cellId = @"EmailCell";
        EmailCell *cell = (EmailCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        
        if ( cell == nil ) {
            
            if( IS_IPHONE_5 ){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EmailCell" owner:self options:nil];
                cell = (EmailCell *)[nib objectAtIndex:0];
            } else if ( IS_IPHONE_6 ){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EmailCell-iPhone6" owner:self options:nil];
                cell = (EmailCell *)[nib objectAtIndex:0];
            } else if ( IS_IPHONE_6_PLUS ) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EmailCell-iPhone6-Plus" owner:self options:nil];
                cell = (EmailCell *)[nib objectAtIndex:0];
            } else if (IS_IPHONE_4){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EmailCell" owner:self options:nil];
                cell = (EmailCell *)[nib objectAtIndex:0];
            }
        }
        
        NSMutableArray *emailWithStatus = contactModal.allEmails[indexPath.row];
        BOOL emailButtonStatus = NO;
        if ( [emailWithStatus[1] isEqualToString:@"1"] ){
            emailButtonStatus = YES;
        }
        
        [cell.emailButton addTarget:self
                           action:@selector(emailButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [cell setCellValues: [emailWithStatus objectAtIndex:0]];
        [cell.emailButton setSelected:emailButtonStatus];

        
        return cell;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(void) save{
    
    [textView resignFirstResponder];
    
    CustomTextTableViewCell *customeTextCell;
    CGPoint buttonPosition = [textView convertPoint:CGPointZero toView:self.contactDetailsTable];
    NSIndexPath *indexPath = [self.contactDetailsTable indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil) {
        customeTextCell = (CustomTextTableViewCell*)[_contactDetailsTable cellForRowAtIndexPath:indexPath];
    }
    contactModal.customTextForContact = customeTextCell.customText.text;

    BOOL alreadyExist = NO;
    int indexToBeChanged = 0;
    Boolean  tempStatusArray[3] = { [contactModal getEmailStatus], [contactModal getSmsStatus], [contactModal getPhoneStatus] };
    BOOL canAddOrUpdate = ( tempStatusArray[0] || tempStatusArray[1] || tempStatusArray[2] );
    
    for ( int i = 0 ;i<untechable.customizedContactsForCurrentSession.count;i++){
        ContactsCustomizedModal *tempModal = [untechable.customizedContactsForCurrentSession objectAtIndex:i];
        if ( [tempModal.contactName isEqualToString:contactModal.contactName] ){
                alreadyExist = YES;
                indexToBeChanged = i;
                break;
        }
    }

    if ( alreadyExist ) {
        if ( canAddOrUpdate ) {
            [untechable.customizedContactsForCurrentSession replaceObjectAtIndex:indexToBeChanged withObject:contactModal];
        }else {
            [untechable.customizedContactsForCurrentSession removeObjectAtIndex:indexToBeChanged];
        }
    }else if( canAddOrUpdate ) {
        [untechable.customizedContactsForCurrentSession addObject:contactModal];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 * Create a backup of all variables which are changeable on this screen, so when user wants to
 * go back without saving then replace all with them
 */
-(void)setTampVariables {
    tempCustomTextForContact = [[NSString alloc] initWithString:contactModal.customTextForContact];
    tempAllPhoneNumbers = [[NSMutableArray alloc] init];
    for( int j=0; j < contactModal.allPhoneNumbers.count; j++){
        [tempAllPhoneNumbers addObject:[[NSMutableArray alloc] initWithArray:@[contactModal.allPhoneNumbers[j][0],contactModal.allPhoneNumbers[j][1],contactModal.allPhoneNumbers[j][2],contactModal.allPhoneNumbers[j][3]]]];
    }

    tempAllEmails = [[NSMutableArray alloc] init];
    for( int j=0; j < contactModal.allEmails.count; j++){
        [tempAllEmails addObject:[[NSMutableArray alloc] initWithArray:@[contactModal.allEmails[j][0],contactModal.allEmails[j][1]]]];
    }
}

-(void)restoreOldStateFromTemp {
    contactModal.customTextForContact = tempCustomTextForContact;
    contactModal.allPhoneNumbers = tempAllPhoneNumbers;
    contactModal.allEmails = tempAllEmails;
}

-(IBAction)emailButtonTapped:(id) sender {

    saveButton.hidden = NO;
    EmailCell *emailCell;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.contactDetailsTable];
    NSIndexPath *indexPath = [self.contactDetailsTable indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil) {
        emailCell = (EmailCell*)[_contactDetailsTable cellForRowAtIndexPath:indexPath];
    }
    
    NSMutableArray *tempEmailWithStatus = contactModal.allEmails[indexPath.row];
    if ( [[tempEmailWithStatus objectAtIndex:1] isEqualToString:@"1"] ) {
        [tempEmailWithStatus setObject:@"0" atIndexedSubscript:1];
        [emailCell.emailButton setSelected:NO];
    } else if ( [[tempEmailWithStatus objectAtIndex:1] isEqualToString:@"0"] ) {
        [tempEmailWithStatus setObject:@"1" atIndexedSubscript:1];
        [emailCell.emailButton setSelected:YES];
    }
    
    contactModal.allEmails[indexPath.row] = tempEmailWithStatus;
}

-(void)onCallSmsTap:(int)aryIndex sender:(id) sender {
    
    saveButton.hidden = NO;
    PhoneNumberCell *phoneCell;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.contactDetailsTable];
    NSIndexPath *indexPath = [self.contactDetailsTable indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil) {
        phoneCell = (PhoneNumberCell*)[_contactDetailsTable cellForRowAtIndexPath:indexPath];
    }
    
    NSMutableArray *tempPhoneWithStatus = contactModal.allPhoneNumbers[indexPath.row];
    BOOL btnStatus = NO;
    
    // aryIndex = 2 for sms
    // aryIndex = 3 for call
    
    if ( [[tempPhoneWithStatus objectAtIndex:aryIndex] isEqualToString:@"1"] ) {
        [tempPhoneWithStatus setObject:@"0" atIndexedSubscript:aryIndex];
        btnStatus = NO;
    } else if ( [[tempPhoneWithStatus objectAtIndex:aryIndex] isEqualToString:@"0"] ) {
        [tempPhoneWithStatus setObject:@"1" atIndexedSubscript:aryIndex];
        btnStatus = YES;
    }
    
    if(aryIndex == 2 )
        [phoneCell.smsButton setSelected:btnStatus];
    
    if(aryIndex == 3 )
        [phoneCell.callButton setSelected:btnStatus];
    
    contactModal.allPhoneNumbers[indexPath.row] = tempPhoneWithStatus;
}

-(IBAction)callButtonTapped:(id) sender {
    [self onCallSmsTap:3 sender:sender];
}


-(IBAction)smsButtonTapped:(id) sender {
    [self onCallSmsTap:2 sender:sender];
}

- (void) saveSpendingTimeText {
    saveButton.hidden = NO;
    contactModal.customTextForContact = textView.text;
}

- (BOOL)textView:(UITextView *)_textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        [_textView resignFirstResponder];
        NSIndexPath *myIP = [NSIndexPath indexPathForRow:0 inSection:0] ;
        _contactDetailsTable.frame= CGRectMake(_contactDetailsTable.frame.origin.x, _contactDetailsTable.frame.origin.y, _contactDetailsTable.frame.size.width, _contactDetailsTable.frame.size.height + 190);
        [_contactDetailsTable scrollToRowAtIndexPath:myIP atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    return YES;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0)];
    
    UIColor *untechableGreen = [UIColor colorWithRed:(66/255.0) green:(247/255.0) blue:(206/255.0) alpha:1];
    
    headerView.backgroundColor = untechableGreen;
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
            return 120.f;
    } else {
        return 80.f;
    }
    return 0;
}

@end
