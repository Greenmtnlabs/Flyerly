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
    NSMutableDictionary *editingEmailsWithStatus;
    NSMutableDictionary *editingPhonesWithStatus;
    
}
@property (weak, nonatomic) IBOutlet UITableView *contactDetailsTable;

@end

@implementation ContactCustomizeDetailsControlelrViewController

@synthesize contactModal,untechable;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationDefaults];
    [self setNavigation:@"viewDidLoad"];
    
    _contactDetailsTable.delegate = self;
    _contactDetailsTable.dataSource = self;
    
    self.contactDetailsTable.contentInset = UIEdgeInsetsMake(-32.0f, 0.0f, 0.0f, 0.0f);
    
    editingEmailsWithStatus = [[NSMutableDictionary alloc] init];
    editingPhonesWithStatus = [[NSMutableDictionary alloc] init];
    for ( int i = 0; i<contactModal.allPhoneNumbers.count; i++ ){
        NSMutableArray * phoneWithStatus = [[NSMutableArray alloc] initWithArray:[contactModal.allPhoneNumbers objectAtIndex:i]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:2];
        [editingPhonesWithStatus setObject:phoneWithStatus forKey:indexPath];
    }
    
    for ( int i = 0; i<contactModal.allEmails.count; i++ ){
        NSMutableArray *emailWithStatus = [[NSMutableArray alloc] initWithArray:[contactModal.allEmails objectAtIndex:i]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:3] ;
        [editingEmailsWithStatus setObject:emailWithStatus forKey:indexPath];
    }
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
        
        // Center title __________________________________________________
        self.navigationItem.titleView = [untechable.commonFunctions navigationGetTitleView];
        
        // Back Navigation button
        backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        backButton.titleLabel.shadowColor = [UIColor clearColor];
        backButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [backButton setTitle:TITLE_BACK_TXT forState:normal];
        [backButton setTitleColor:DEF_GRAY forState:UIControlStateNormal];
        
        [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        backButton.showsTouchWhenHighlighted = YES;
        
        UIBarButtonItem *lefttBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        [self.navigationItem setLeftBarButtonItem:lefttBarButton];//Left button ___________
        
        // Right Navigation ______________________________________________
        saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 42)];
        //[saveButton setBackgroundColor:[UIColor redColor]];//for testing
        
        saveButton.titleLabel.shadowColor = [UIColor clearColor];
        //saveButton.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
        
        [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        //[saveButton setBackgroundImage:[UIImage imageNamed:@"next_button"] forState:UIControlStateNormal];
        saveButton.titleLabel.font = [UIFont fontWithName:TITLE_FONT size:TITLE_RIGHT_SIZE];
        [saveButton setTitle:TITLE_SAVE_TXT forState:normal];
        [saveButton setTitleColor:DEF_GRAY forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(btnNextTouchStart) forControlEvents:UIControlEventTouchDown];
        [saveButton addTarget:self action:@selector(btnNextTouchEnd) forControlEvents:UIControlEventTouchUpInside];
        
        saveButton.showsTouchWhenHighlighted = YES;
        saveButton.hidden = YES;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
        NSMutableArray  *rightNavItems  = [NSMutableArray arrayWithObjects:rightBarButton,nil];
        
        [self.navigationItem setRightBarButtonItems:rightNavItems];//Right button ___________
    }
}


-(void) goBack {
    
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
    //return sectionHeader;
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
        
        //cell.contact_Name.frame = CGRectMake(20,20,200,800);

        NSString *valueToBeShown =[ NSString stringWithFormat:@"Message to %@\n",contactModal.name];
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
        
//        int len = contactModal_.customTextForContact.length;
//        _char_limit.text=[NSString stringWithFormat:@"%i",124-len];

        
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
        
        NSMutableArray *numberWithStatus = [editingPhonesWithStatus objectForKey:indexPath];
        
        [cell setCellValues:[numberWithStatus objectAtIndex:0] Number:[numberWithStatus objectAtIndex:1]];
        
        if ( [[numberWithStatus objectAtIndex:2] isEqualToString:@"1"] ){
            [cell.smsButton setSelected:YES];
        }else {
            [cell.smsButton setSelected:NO];
        }
        
        if ( [[numberWithStatus objectAtIndex:3] isEqualToString:@"1"] ){
            [cell.callButton setSelected:YES];
        }else {
            [cell.callButton setSelected:NO];
        }
        
        cell.untechable = untechable;
        
        [cell setCellModal:contactModal];
        
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
        
        [cell.emailButton addTarget:self
                            action:@selector(emailButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        NSMutableArray *emailWithStatus = [editingEmailsWithStatus objectForKey:indexPath];
        
        if ( [[emailWithStatus objectAtIndex:1] isEqualToString:@"1"] ){
            [cell.emailButton setSelected:YES];
        }else {
            [cell.emailButton setSelected:NO];
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

-(void) save{
    
    [textView resignFirstResponder];
    
    CustomTextTableViewCell *customeTextCell;
    CGPoint buttonPosition = [textView convertPoint:CGPointZero toView:self.contactDetailsTable];
    NSIndexPath *indexPath = [self.contactDetailsTable indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        customeTextCell = (CustomTextTableViewCell*)[_contactDetailsTable cellForRowAtIndexPath:indexPath];
    }
    contactModal.customTextForContact = customeTextCell.customText.text;
    
    if ( editingPhonesWithStatus.count > 0 ) {
        for( int j=0; j < editingPhonesWithStatus.count; j++){
            NSArray *allKeys = [editingPhonesWithStatus allKeys];
            NSArray *allObjects = [editingPhonesWithStatus allValues];
            NSIndexPath *indexPath =  [allKeys objectAtIndex:j];
            [contactModal.allPhoneNumbers  replaceObjectAtIndex:indexPath.row withObject:[allObjects objectAtIndex:j]];
        }
    }
    
    
    
    
    if ( editingEmailsWithStatus.count > 0 ) {
        for( int j=0; j < editingEmailsWithStatus.count; j++){
            NSArray *allKeys = [editingEmailsWithStatus allKeys];
            NSArray *allObjects = [editingEmailsWithStatus allValues];
            NSIndexPath *indexPath =  [allKeys objectAtIndex:j];
            [contactModal.allEmails  replaceObjectAtIndex:indexPath.row withObject:[allObjects objectAtIndex:j]];
        }
    }
    
    BOOL alreadyExist = NO;
    int indexToBeChanged = 0;
    Boolean  tempStatusArray[3] = { [contactModal getEmailStatus], [contactModal getSmsStatus], [contactModal getPhoneStatus] };
    BOOL canAddOrUpdate = ( tempStatusArray[0] || tempStatusArray[1] || tempStatusArray[2] );
    
    for ( int i = 0 ;i<untechable.customizedContactsForCurrentSession.count;i++){
        ContactsCustomizedModal *tempModal = [untechable.customizedContactsForCurrentSession objectAtIndex:i];
        if ( [tempModal.name isEqualToString:contactModal.name] && canAddOrUpdate ){
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

-(IBAction)emailButtonTapped:(id) sender {

    saveButton.hidden = NO;
    EmailCell *emailCell;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.contactDetailsTable];
    NSIndexPath *indexPath = [self.contactDetailsTable indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        emailCell = (EmailCell*)[_contactDetailsTable cellForRowAtIndexPath:indexPath];
    }
    
    NSMutableArray *tempEmailWithStatus = [editingEmailsWithStatus objectForKey:indexPath];
    if ( [[tempEmailWithStatus objectAtIndex:1] isEqualToString:@"1"] ){
        [tempEmailWithStatus setObject:@"0" atIndexedSubscript:1];
        [emailCell.emailButton setSelected:NO];
    }else if ( [[tempEmailWithStatus objectAtIndex:1] isEqualToString:@"0"] ){
        [tempEmailWithStatus setObject:@"1" atIndexedSubscript:1];
        [emailCell.emailButton setSelected:YES];
    }
    
    [editingEmailsWithStatus setObject:tempEmailWithStatus forKey:indexPath];
}


-(IBAction)callButtonTapped:(id) sender {
    saveButton.hidden = NO;
    PhoneNumberCell *phoneCell;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.contactDetailsTable];
    NSIndexPath *indexPath = [self.contactDetailsTable indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        phoneCell = (PhoneNumberCell*)[_contactDetailsTable cellForRowAtIndexPath:indexPath];
    }
    
    NSMutableArray *tempPhoneWithStatus = [editingPhonesWithStatus objectForKey:indexPath];
    
    if ( [[tempPhoneWithStatus objectAtIndex:3] isEqualToString:@"1"] ){
        [tempPhoneWithStatus setObject:@"0" atIndexedSubscript:3];
        [phoneCell.callButton setSelected:NO];
    }else if ( [[tempPhoneWithStatus objectAtIndex:3] isEqualToString:@"0"] ){
        [tempPhoneWithStatus setObject:@"1" atIndexedSubscript:3];
        [phoneCell.callButton setSelected:YES];
    }
    
    [editingPhonesWithStatus setObject:tempPhoneWithStatus forKey:indexPath];
}


-(IBAction)smsButtonTapped:(id) sender {

    saveButton.hidden = NO;
    PhoneNumberCell *phoneCell;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.contactDetailsTable];
    NSIndexPath *indexPath = [self.contactDetailsTable indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        phoneCell = (PhoneNumberCell*)[_contactDetailsTable cellForRowAtIndexPath:indexPath];
    }
    
    NSMutableArray *tempPhoneWithStatus = [editingPhonesWithStatus objectForKey:indexPath];
    
    if ( [[tempPhoneWithStatus objectAtIndex:2] isEqualToString:@"1"] ){
        [tempPhoneWithStatus setObject:@"0" atIndexedSubscript:2];
        [phoneCell.smsButton setSelected:NO];
    }else if ( [[tempPhoneWithStatus objectAtIndex:2] isEqualToString:@"0"] ){
        [tempPhoneWithStatus setObject:@"1" atIndexedSubscript:2];
        [phoneCell.smsButton setSelected:YES];
    }
    
    [editingPhonesWithStatus setObject:tempPhoneWithStatus forKey:indexPath];
}

- (void) saveSpendingTimeText {
    saveButton.hidden = NO;
    contactModal.customTextForContact = textView.text;
}

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
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
    if (indexPath.section == 1)
    {
            return 120.f;
    }
    else
    {
        return 80.f;
    }
    return 0;
}

@end
