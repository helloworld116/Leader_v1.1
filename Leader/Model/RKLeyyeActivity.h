//
//  RKLeyyeActivity.h
//  Leader
//
//  Created by leyye on 14-12-2.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKLeyyeActivity : NSObject

@property (nonatomic, assign) int aid;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * activityIcon;
@property (nonatomic, strong) NSString * lDescription;
@property (nonatomic, assign) int contribution;
@property (nonatomic, assign) int coins;
@property (nonatomic, strong) NSString * acDate;

- (id)initWithParameters:(int)mId
                andTitle:(NSString *) mTitle
                 andSponsors :(NSString *) mDescription
         andContribution:(int)aContribution
               andConin:(int) mConins
                 andDate:(NSString *)aDate;
+ (NSMutableArray *) parserLeyyeActivity:(NSMutableDictionary *) mDict;
@end
