//
//  CommonFunctions
//  Flyr
//
//  Created by Riksof Pvt. Ltd. on 25/03/2016 By Abdul Rauf
//

#import <Foundation/Foundation.h>

@interface CommonFunctions : NSObject {

}

+(int)videoDuration:(NSURL *)movieUrl;
+(void)showAlert:(NSString *)alertTitle :(NSString *)alertMessage :(NSString *)cancelButtonTitle;

@end
