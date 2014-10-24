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

@interface CommonFunctions: NSObject{
    
}

-(void)sortDic:inputDic;

-(void)deleteKeyFromDic:dic delKeyAtIndex:(int)rowNumber;
-(void)showAlert:(NSString *)title message:(NSString *)message;
-(NSString *)convertDicIntoJsonString:(NSMutableDictionary *)value;
-(float)getTimeZoneOffset;
@end
