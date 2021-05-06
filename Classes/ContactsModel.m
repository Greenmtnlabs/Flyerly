//
//  ContatcsModel.m
//  Flyr
//
//  Created by Khurram on 27/02/2014.
//
//

#import "ContactsModel.h"


@implementation ContactsModel

@synthesize delegate,name,description,img,checkImageName,status,others,imageUrl,zip;


-(id)init{
    
    self = [super init];
    
    return self;
}

-(void)setInvitedStatus :(int)sts{

    
    status = sts;
    
    if (status == 1) {
        checkImageName = @"checkBlue";
    } else if (status == 2) {
        checkImageName = @"checkDouble";
    }else {
        checkImageName = @"checkgray";
    }
    
    [self.delegate contactInvited:self];
}


@end
