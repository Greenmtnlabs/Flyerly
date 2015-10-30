//
//  ContactsModel.h
//  Untechable
//
//  Created by rufi on 30/10/2015.
//  Copyright (c) 2015 Green MTN Labs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ContactsModel;

@protocol ContactsDelegate <NSObject>

-(void)contactInvited :(ContactsModel *)model;
@end



@interface ContactsModel : NSObject

-(void)setInvitedStatus :(int)status;

@property (nonatomic,weak) id <ContactsDelegate>delegate;

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

