//
//  RKLeyyeSysNotice.h
//  Leader
//
//  Created by leyye on 14-11-5.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKLeyyeSysNotice : NSObject

@property long id;
@property long typeId; // 通知类型
@property long date; // 接收日期
@property (copy,nonatomic) NSString * noticeTitle; // 标题
@property (copy,nonatomic) NSString * receiveUser; // 接收人领域号
@property (copy,nonatomic) NSString * user; //
@property BOOL isRead; // 是否已读

@end
