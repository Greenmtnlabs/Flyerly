 //
//  UntechableClass.m
//  Untechable
//
//  Created by Abdul Rauf on 23/sep/2014
//  Copyright (c) 2014 RIKSOF (Pvt) Ltd. All rights reserved.
//
//

#import "CommonFunctions.h"



@implementation CommonFunctions


-(void)sortDic:inputDic {
    NSMutableDictionary *sortedDic = [[NSMutableDictionary alloc] init];
    NSArray *sortedKeys = [[inputDic allKeys] sortedArrayUsingSelector: @selector(compare:)];
    
    for (NSString *key in sortedKeys) {
        [sortedDic setObject:[inputDic objectForKey: key]  forKey:key];
    }
    
    inputDic = sortedDic;
    
    //return sortedDic;
}

-(void)deleteKeyFromDic:dic delKeyAtIndex:(int)rowNumber {
    NSArray *arrayOfKeys = [[dic allKeys] sortedArrayUsingSelector: @selector(compare:)];
    NSString *key   = [arrayOfKeys objectAtIndex:rowNumber];
    
    //NSLog(@"dic before delete rowNumber: %i, key: %@, dic: %@", rowNumber, key, dic);
    
    [dic removeObjectForKey:key];

   // NSLog(@"dic after delete rowNumber: %i, key: %@, dic: %@", rowNumber, key, dic);

    //return dic;
}


//[commonFunctions showAlert:@"Please select any contact to invite !" message:@""];
-(void)showAlert:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
@end

	