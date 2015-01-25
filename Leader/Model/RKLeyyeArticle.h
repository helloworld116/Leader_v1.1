//
//  RKLeyyeArticle.h
//  Leader
//
//  Created by leyye on 14-11-5.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RKFileManager;
@interface RKLeyyeArticle : NSObject/*<NSCoding>*/{
    
}
@property (nonatomic, assign) int aid;
@property (nonatomic, assign) long domainId;
@property (copy,nonatomic) NSString * domain; //领域名称
@property (nonatomic, assign) long authorId; //作者id
@property (nonatomic,copy) NSString * author; // 作者
@property (copy,nonatomic) NSString * authorNick; //作者昵称
@property (copy,nonatomic) NSString * authorIcon; //作者头像
@property (nonatomic, assign) int authorLevel; // 作者等级；
@property (nonatomic, assign) int authorRank;  //
@property (nonatomic, assign) long authorNo; //作者id
@property (nonatomic, assign) long pubDate; // 日期

@property (nonatomic, copy) NSString * title; // 文章标题
@property (nonatomic, assign) long score; //文章得分
@property (nonatomic, assign) int remark;
@property (nonatomic, assign) int commentNo; //评论数量
@property (nonatomic, assign) int awayFromFirst; // ? 排名
@property (copy,nonatomic) NSString * articleImgAddr; //图片地址
@property (copy,nonatomic) NSString * content; //内容
@property (copy,nonatomic) NSString * intro; // 简介

@property BOOL hasGet; // ?
@property BOOL hasSign; // ?

@property (nonatomic, strong) NSData * dAuthorIcon;

//@property (nonatomic, strong) RKFileManager * fileManager;

- (id)initWithParameters:(NSString *)domain
               andAuthor:(NSString *)author
             andAuthorId:(long) authorId
           andAuthorNick:(NSString *) authorNick
           andAuthorIcon:(NSString *)mAuthorIcon
       andAuthorIconData:(NSData *)aDAuthorIcon
             andAuthorRank:(int) authorRank
              /*andAuthorScoreRank:(int) scoreRank*/
              andPubDate:(long )pubDate
                  andTitle:(NSString *)title
              andContent:(NSString *) content
        andArticleImages:(NSString *)aArticleImgAddr
            /*andCommentNo:(int)commentNo*/
                andScore:(long) score
        andAwayFromFirst:(int)awayFromFirst
        andArticleId:(int) articleId;

//+ (RKLeyyeArticle *) initWithArticle:(NSMutableArray *)array;

+ (void) parserAndSaveLeyyeArticle:(NSString *) str;
+ (NSMutableArray *) parserLeyyeArticle:(NSMutableDictionary *) mDict;

+ (BOOL) updateLeyyeArticle:(NSString *) str;

+ (void) downLoadArticleIcon:(NSString *) icon;
@end
