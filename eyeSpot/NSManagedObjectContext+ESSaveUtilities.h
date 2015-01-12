//
//  NSManagedObjectContext+ESSaveUtilities.h
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 3/13/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (ESSaveUtilities)

- (BOOL)es_saveAndAutomaticallyReportErrors:(__autoreleasing NSError **)error;

@end
