//
//  RKLeyyeActivity.m
//  Leader
//
//  Created by leyye on 14-12-2.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKLeyyeActivity.h"

@implementation RKLeyyeActivity

@synthesize aid;
@synthesize title;
@synthesize activityIcon;
@synthesize lDescription;
@synthesize contribution;
@synthesize coins;
@synthesize acDate;

- (id)initWithParameters:(int)mId
                andTitle:(NSString *) mTitle
            andSponsors:(NSString *) mDescription
         andContribution:(int)aContribution
                andConin:(int) mConins
                 andDate:(NSString *)aDate{
    RKLeyyeActivity * activity = [[RKLeyyeActivity alloc] init];
    activity.aid = mId;
    activity.title = mTitle;
    activity.lDescription = mDescription;
    activity.contribution = aContribution;
    activity.coins = mConins;
    activity.acDate = aDate;
    return activity;
}

+ (NSMutableArray *) parserLeyyeActivity:(NSMutableDictionary *) mDict{
    NSMutableArray * mArray = [[NSMutableArray alloc] initWithCapacity:10];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    for (NSDictionary * dict in mDict) {
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate * date = [dateFormatter dateFromString:dict[@"startTimeString"]];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSString * result = [dateFormatter stringFromDate:date];
        RKLeyyeActivity * activity = [[RKLeyyeActivity alloc] initWithParameters:[dict[@"id"] intValue] andTitle:dict[@"title"] andSponsors:dict[@"description"] andContribution:[dict[@"contribution"] intValue]andConin:[dict[@"coins"] intValue]andDate:result];
        [mArray addObject:activity];
    }
    return mArray;
}


@end
