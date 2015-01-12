//
//  ESAppDelegate.h
//  eyeSpot
//
//  Created by Vladimir Fleurima on 2/20/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ESAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *persistingManagedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (ESAppDelegate *) sharedAppDelegate;
@end