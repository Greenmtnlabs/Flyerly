//
//  ContatcsModel.m
//  Flyr
//
//  Created by Khurram on 27/02/2014.
//
//

#import "ContactsModel.h"


@implementation ContactsModel

@synthesize delegate,name,description,img,checkImageName,status,others,imageUrl;


-(id)init{
    
    self = [super init];
    
    return self;
}

-(void)setInvitedStatus :(int)sts{

    status = sts;
    if (status == 0) {
        checkImageName = @"checkwhite";
    } else if (status == 1) {
        checkImageName = @"checkgray";
    } else if (status == 2) {
        checkImageName = @"checkgreen";
    }
    [self.delegate contactInvited:self];
}


@end
