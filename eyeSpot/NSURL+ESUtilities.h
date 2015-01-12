//
//  NSURL+ESUtilities.h
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 3/13/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (ESUtilities)

- (BOOL)es_isEqualToFileURL:(NSURL *)target;
- (NSString *)es_pathRelativeToHomeDirectory;
@end
