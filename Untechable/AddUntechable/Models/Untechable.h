//
//  UntechableClass.h
//  Untechable
//
//  Created by Abdul Rauf on 23/sep/2014
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface Untechable : NSObject{
    
}


//vars for screen1
@property (strong, nonatomic)  NSString *startDate, *endDate, *test1;

//vars for screen2
@property (strong, nonatomic)  NSString *forwardingNumber, *emergencyNumbers;
@property (strong, nonatomic)  NSDictionary *emergencyContacts;


@end
