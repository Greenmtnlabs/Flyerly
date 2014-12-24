//
//  ContactsModal.h
//  Untechable
//
//  Created by RIKSOF Developer on 12/24/14.
//  Copyright (c) 2014 Green MTN Labs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ContactsCustomizedModal;

@protocol ContactsCustomizedModalDelegate <NSObject>

-(void)contactInvited :(ContactsCustomizedModal *)model;
@end


@interface ContactsCustomizedModal : NSObject

-(void)setInvitedStatus :(int)status;

@property (nonatomic,weak) id <ContactsCustomizedModalDelegate>delegate;

@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *description;
@property (nonatomic,strong)NSString *others;
@property (nonatomic,strong)UIImage *img;
@property (nonatomic,strong)NSString *imageUrl;
@property (nonatomic,strong) NSString *checkImageName;
@property (nonatomic,assign)int status;
//--- Address
@property (nonatomic,strong)NSString *streetAddress;
@property (nonatomic,strong)NSString *state;
@property (nonatomic,strong)NSString *city;
@property (nonatomic,strong)NSString *country;
@property (nonatomic,strong)NSString *zip;

@end
