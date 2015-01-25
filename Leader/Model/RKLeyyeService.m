//
//  RKViewController.m
//  Leader
//
//  Created by leyye on 14-11-28.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKLeyyeService.h"

@implementation RKLeyyeService

@synthesize title;
@synthesize icon;
@synthesize intro;
@synthesize charge;

- (id)initWithParameters:(int)mId
                andTitle:(NSString *) mTitle
                 andIcon:(NSString *) mIcon
                andIntro:(NSString *) mIntro
                andCharge:(int) mCharge{
    RKLeyyeService * service = [[RKLeyyeService alloc] init];
    service.sId = mId;
    service.title = mTitle;
    service.icon = mIcon;
    service.intro = mIntro;
    service.charge = mCharge;
    return service;
}

+ (void) parserLeyyeService:(NSString *) str{
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
//    NSMutableDictionary * mutableDict = json[@"data"][@"articles"];
}

@end
