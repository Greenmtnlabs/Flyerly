//
//  ContatcsModel.m
//  Untechable
//
//  Created by Khurram on 27/02/2014, update on 10/10/2014 by Abdul Rauf
//
//

#import "ContactsModel.h"
#import "Common.h"


@implementation ContactsModel

@synthesize delegate,name,description,img,checkImageName,status,others,imageUrl,zip;


-(id)init{
    
    self = [super init];
    
    return self;
}

-(void)setInvitedStatus :(int)sts{

    
    status = sts;
    
    if (status == CHECKBOX_FILLED ) {
        checkImageName = @"CHECKBOX_FILLED";
    } else if (status == CHECKBOX_TICK) {
        checkImageName = @"CHECKBOX_TICK";
    }else {
        checkImageName = @"CHECKBOX_EMPTY";
    }
    
    [self.delegate contactInvited:self];
}


@end
