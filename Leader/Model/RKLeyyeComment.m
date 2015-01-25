//
//  RKLeyyeComment.m
//  Leader
//
//  Created by leyye on 14-11-5.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKLeyyeComment.h"
#import "RKDBHelper.h"

@implementation RKLeyyeComment

@synthesize cid;
@synthesize articleId;
@synthesize commentUser; // 评论用户领域号
@synthesize commentNickName; // 评论用户昵称
@synthesize commentIcon; // 评论人头像
@synthesize commentContent; // 评论内容
@synthesize commentDate; // 评论时间

- (id)initWithParameters:(int)aId
            andArticleId:(int) aArticleId
      andCommentNickName:(NSString *) aCommentNickName
          andCommentIcon:(NSString *) aCommentIcon
       andCommentContent:(NSString *) aCommentContent
          andCommentDate:(NSString *) aCommentDate{
    RKLeyyeComment * comment = [[RKLeyyeComment alloc] init];
    comment.cid = aId;
    comment.articleId = aArticleId;
    comment.commentNickName = aCommentNickName;
    comment.commentIcon = aCommentIcon;
    comment.commentContent = aCommentContent;
    comment.commentDate = aCommentDate;
    return comment;
}

+ (void) parserArticleComment:(NSString *) str{
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    NSMutableDictionary * mutableDict = json[@"data"][@"comments"];
    RKDBHelper * dbHelper = [[RKDBHelper alloc] init];
    for (NSDictionary * dict in mutableDict) {
        RKLeyyeComment * comment = [[RKLeyyeComment alloc] initWithParameters:[dict[@"id"] intValue] andArticleId:[dict[@"id"] intValue] andCommentNickName:dict[@"nickname"] andCommentIcon:dict[@"icon"] andCommentContent:dict[@"content"] andCommentDate:dict[@"strCommentTime"]];
        [dbHelper insertArticleComment:comment];
    }
}

@end
