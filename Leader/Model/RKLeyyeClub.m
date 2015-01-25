//
//  RKLeyyeClub.m
//  Leader
//
//  Created by leyye on 14-11-7.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKLeyyeClub.h"
#import "RKDBHelper.h"

@implementation RKLeyyeClub

@synthesize sId;
@synthesize title;
@synthesize icon;
@synthesize intro;
@synthesize userCount;

- (id)initWithParameters:(int)mId
                andTitle:(NSString *) mTitle
                 andIcon:(NSString *) mIcon
                andIntro:(NSString *) mIntro
            andUserCount:(int) mUserCount{
    RKLeyyeClub * club = [[RKLeyyeClub alloc] init];
    club.sId = mId;
    club.title = mTitle;
    club.icon = mIcon;
    club.intro = mIntro;
    club.userCount = mUserCount;
    return club;
}

+ (void) parserLeyyeClubs:(NSMutableDictionary *) mutableDict{
    NSMutableArray * mutableArray = [[NSMutableArray alloc] initWithCapacity:10];
    RKDBHelper * dbHelper = [[RKDBHelper alloc] init];
    for (NSDictionary * dict in mutableDict) {
        RKLeyyeClub * club = [[RKLeyyeClub alloc] initWithParameters:[dict[@"id"] intValue] andTitle:dict[@"title"] andIcon:dict[@"image"] andIntro:dict[@"introduction"] andUserCount:[dict[@"userCount"] intValue]];
        [mutableArray addObject:club];
        [dbHelper insertLeyyeClub:club];
    }
}

@end
