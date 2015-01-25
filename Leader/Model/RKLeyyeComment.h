//
//  RKLeyyeComment.h
//  Leader
//
//  Created by leyye on 14-11-5.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKLeyyeComment : NSObject

@property (nonatomic, assign) int cid;
@property (nonatomic, assign) int articleId;
@property (copy,nonatomic) NSString * commentUser; // 评论用户领域号
@property (copy,nonatomic) NSString * commentNickName; // 评论用户昵称
@property (copy,nonatomic) NSString * commentIcon; // 评论人头像
@property (copy,nonatomic) NSString * commentContent; // 评论内容
@property (nonatomic, strong) NSString * commentDate; // 评论时间

- (id)initWithParameters:(int)aId
            andArticleId:(int) aArticleId
      andCommentNickName:(NSString *) aCommentNickName
          andCommentIcon:(NSString *) aCommentIcon
       andCommentContent:(NSString *) aCommentContent
          andCommentDate:(NSString *) aCommentDate;

+ (void) parserArticleComment:(NSString *) str;
@end
