//
//  LobSettingModel.h
//  lob-ios
//
//  Created by Zealous Amoeba on 1/3/14.
//  www.zealousamoeba.org
//  Copyright (c) 2014 Lob. All rights reserved.
//

#import "LobAbstractModel.h"

@interface LobSettingModel : LobAbstractModel
@property(nonatomic, strong) NSString *settingId;
@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *paper;
@property(nonatomic, strong) NSString *width;
@property(nonatomic, strong) NSString *length;
@property(nonatomic, strong) NSString *color;
@property(nonatomic, strong) NSString *notes;

- (instancetype)initSettingWithId:(NSString*)settingId;

- (instancetype)initSettingWithType:(NSString*)type
                              paper:(NSString*)paper
                              witdh:(NSString*)width
                             length:(NSString*)length
                              color:(NSString*)color
                              notes:(NSString*)notes;

@end
