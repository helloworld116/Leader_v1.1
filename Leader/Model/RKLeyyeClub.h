//
//  RKLeyyeClub.h
//  Leader
//
//  Created by leyye on 14-11-7.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKLeyyeClub : NSObject

@property (nonatomic, assign) int sId; // 服务号ID;
@property (nonatomic, strong) NSString * title; // 标题
@property (nonatomic, strong) NSString * icon; // 图标
@property (nonatomic, strong) NSString * intro; // 介绍
@property (nonatomic, assign) int userCount; // 费用

- (id)initWithParameters:(int)mId
                andTitle:(NSString *) mTitle
                 andIcon:(NSString *) mIcon
                andIntro:(NSString *) mIntro
               andUserCount:(int) mUserCount;

+ (void) parserLeyyeClubs:(NSMutableDictionary *) mutableDict;

@end
