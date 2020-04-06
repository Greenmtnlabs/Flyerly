//
//  ContatcsModel.h
//  Flyr
//
//  Created by Khurram on 27/02/2014.
//
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
