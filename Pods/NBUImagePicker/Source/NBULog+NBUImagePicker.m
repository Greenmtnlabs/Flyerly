//
//  NBULog+NBUImagePicker.m
//  NBUImagePicker
//
//  Created by Ernesto Rivera on 2012/12/12.
//  Copyright (c) 2012-2014 CyberAgent Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#if __has_include("NBULog.h")

#import "NBULog+NBUImagePicker.h"
#import <NBULog/NBULogContextDescription.h>

static int _imagePickerLogLevel;

@implementation NBULog (NBUImagePicker)

+ (void)load
{
    // Default levels
    [self setImagePickerLogLevel:LOG_LEVEL_DEFAULT];
    
    // Register the NBUImagePicker log context
    [NBULog registerContextDescription:[NBULogContextDescription descriptionWithName:@"NBUImagePicker"
                                                                             context:NBUIMAGEPICKER_LOG_CONTEXT
                                                                     modulesAndNames:nil
                                                                   contextLevelBlock:^{ return [NBULog imagePickerLogLevel]; }
                                                                setContextLevelBlock:^(int level) { [NBULog setImagePickerLogLevel:level]; }
                                                          contextLevelForModuleBlock:NULL
                                                       setContextLevelForModuleBlock:NULL]];
}

+ (int)imagePickerLogLevel
{
    return _imagePickerLogLevel;
}

+ (void)setImagePickerLogLevel:(int)LOG_LEVEL_XXX
{
#ifdef DEBUG
    _imagePickerLogLevel = LOG_LEVEL_XXX == LOG_LEVEL_DEFAULT ? LOG_LEVEL_INFO : LOG_LEVEL_XXX;
#else
    _imagePickerLogLevel = LOG_LEVEL_XXX == LOG_LEVEL_DEFAULT ? LOG_LEVEL_WARN : LOG_LEVEL_XXX;
#endif
}

@end

#endif

