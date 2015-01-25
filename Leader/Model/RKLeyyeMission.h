//
//  RKLeyyeMission.h
//  Leader
//
//  Created by leyye on 14-11-5.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKLeyyeMission : NSObject

@property long id; // ?
@property long articleId;
@property (copy,nonatomic) NSString * commentUser; // 评论用户领域号
@property (copy,nonatomic) NSString * commentNick; // 评论用户昵称
@property (copy,nonatomic) NSString * commentIcon; // 评论人头像
@property (copy,nonatomic) NSString * commentContent; // 评论内容
@property long commentDate; // 评论时间
//public long mId;
//public long mDate;
//public int[] mAwardType;
//public int[] mAward;
//public String mName;
//public String mSponsor;
//public String mWinner;
@end
