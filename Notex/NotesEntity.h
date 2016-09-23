//////////////////////////////////////
//
//   Notex
//   created by FV iMAGINATION
//   ©2014
//
//////////////////////////////////////

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NotesEntity : NSManagedObject

@property (nonatomic, retain) NSString * noteText;
@property (nonatomic, retain) NSString * noteTitle;
@property (nonatomic, retain) NSString * noteColor;

@end
