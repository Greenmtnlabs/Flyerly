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
#import "Common.h"

@interface ContactCustomizeDetailsControlelrViewController (){

    int rowsInFirstSection,rowsInSecondSection;
}
@property (weak, nonatomic) IBOutlet UITableView *contactDetailsTable;

@end

@implementation ContactCustomizeDetailsControlelrViewController

@synthesize contactModal;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _contactDetailsTable.delegate = self;
    _contactDetailsTable.dataSource = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int numberOfRowsInSection;
    if ( section == 0 ){
        numberOfRowsInSection = 1;
    }else if ( section == 1 ){
        numberOfRowsInSection = 1;
    }else if ( section == 2 ){
        numberOfRowsInSection = (int)contactModal.allEmails.count;
    }else if ( section == 3 ){
        numberOfRowsInSection = 0;
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
        
        [cell setCellValues:contactModal.name];
        
        return cell;
    }else if ( indexPath.section == 1 ){
        
        static NSString *cellId = @"PhoneNumberCell";
        PhoneNumberCell *cell = (PhoneNumberCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PhoneNumberCell" owner:self options:nil];
        cell = (PhoneNumberCell *)[nib objectAtIndex:0];
        
        if ( contactModal.mobileNumber != nil ){
            
            [cell setCellValues:@"Mobile" Number:contactModal.mobileNumber];
        }
        
        if( contactModal.iPhoneNumber != nil ){
            
            [cell setCellValues:@"iPhoneNumber" Number:contactModal.iPhoneNumber];
        }
        
        if( contactModal.homeNumber != nil ){
            
            [cell setCellValues:@"homeNumber" Number:contactModal.homeNumber];
        }
        
        if( contactModal.workNumber != nil ){
            
            [cell setCellValues:@"workNumber" Number:contactModal.workNumber];
        }
        
        return cell;
    }else if ( indexPath.section == 2 ){
        
        static NSString *cellId = @"EmailCell";
        EmailCell *cell = (EmailCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EmailCell" owner:self options:nil];
        cell = (EmailCell *)[nib objectAtIndex:0];
        
        NSMutableArray *aar = [[NSMutableArray alloc] initWithArray:contactModal.allEmails];
        
        [cell setCellValues: [aar objectAtIndex:indexPath.row]];
        
        return cell;
    }else if ( indexPath.section == 3 ){
        
        UITableViewCell *cell = nil;
        return cell;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}



@end
