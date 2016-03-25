//
//  InAppPurchaseRelatedMethods.h
//  Flyr
//
//  Created by RIKSOF Team SQA on 3/22/16.
//
//

#import <Foundation/Foundation.h>
#import "FlyerlySingleton.h"
#import "InAppViewController.h"


@class InAppViewController;
@interface InAppPurchaseRelatedMethods : NSObject <InAppPurchasePanelButtonProtocol>{
    InAppViewController *inappviewcontroller;
}

+(InAppViewController *)openInAppPurchasePanel : (id) viewController;


@end
