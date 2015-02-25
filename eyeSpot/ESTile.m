//
//  ESTile.m
//  eyeSPOT
//
//  Created by Vladimir Fleurima on 2/20/13.
//  Copyright (c) 2013 Green Mtn Think. All rights reserved.
//

#import "ESTile.h"


@implementation ESTile

@dynamic imagePath;
@dynamic index;
@dynamic isChecked;
@dynamic associatedGames;
@dynamic board;

- (NSURL *)imageURL
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *defaultBoardsURL = [mainBundle URLForResource:@"Default Boards" withExtension:@"plist"];
    
    //NSURL *homeURL = [NSURL fileURLWithPath:NSHomeDirectory() isDirectory:YES];
    NSURL *aUrl = [defaultBoardsURL URLByDeletingLastPathComponent];
    NSURL *url = [aUrl URLByDeletingLastPathComponent];

    //NSURL *homeURL = [NSURL fileURLWithPath:NSHomeDirectory() isDirectory:YES];
    return [NSURL URLWithString:self.imagePath relativeToURL:url];
}
@end
