//
//  RKLeyyeArticle.m
//  Leader
//
//  Created by leyye on 14-11-5.
//  Copyright (c) 2014年 leyye. All rights reserved.
//
#import "RKLeyyeArticle.h"
#import "RKFileManager.h"
#import "RKDBHelper.h"
#import "RKLeyyeUtilKit.h"

@implementation RKLeyyeArticle

@synthesize aid;
@synthesize domainId;
@synthesize domain;
@synthesize author;
@synthesize authorId;
@synthesize authorNick;
@synthesize authorIcon;
@synthesize dAuthorIcon;
@synthesize authorLevel;
@synthesize authorRank;
@synthesize authorNo;
@synthesize pubDate;

@synthesize title;
@synthesize score;
@synthesize remark;
@synthesize commentNo;
@synthesize awayFromFirst;
@synthesize articleImgAddr;
@synthesize content;
@synthesize intro;
@synthesize hasGet;
@synthesize hasSign;


//- (id) initWithCoder:(NSCoder *)aDecoder{
//    if (self = [super init]) {
//        self.title = [aDecoder decodeObjectForKey:@"title"];
//        self.content = [aDecoder decodeObjectForKey:@"content"];
//        self.intro = [aDecoder decodeObjectForKey:@"intro"];
//        self.score = [aDecoder decodeFloatForKey:@"score"];
//    }
//    return self;
//}

//- (void) encodeWithCoder:(NSCoder *)aCoder{
//    [aCoder encodeObject:self.title forKey:@"title"];
//    [aCoder encodeObject:self.content forKey:@"content"];
//    [aCoder encodeObject:self.intro forKey:@"intro"];
//    [aCoder encodeFloat:self.score forKey:@"score"];
//}

- (id) initWithParameters:(NSString *)mDomain
               andAuthor:(NSString *)mAuthor
                   andAuthorId:(long) mAuthorId
            andAuthorNick:(NSString *) mAuthorNick
            andAuthorIcon:(NSString *)mAuthorIcon
        andAuthorIconData:(NSData *)aDAuthorIcon
                 andAuthorRank:(int) mAuthorRank
            /*andAuthorScoreRank:(int) mScoreRank*/
                    andPubDate:(long) mPubDate
                      andTitle:(NSString *) mTitle
               andContent:(NSString *) mContent
         andArticleImages:(NSString *)aArticleImgAddr
                  /*andCommentNo:(int) mCommentNo*/
                      andScore:(long) mScore
         andAwayFromFirst:(int)mAwayFromFirst
             andArticleId:(int) articleId
{
    RKLeyyeArticle *article = [[RKLeyyeArticle alloc] init];
    article.domain = mDomain;
    article.authorId = mAuthorId;
    article.author = mAuthor;
    article.authorNick = mAuthorNick;
    article.authorIcon = mAuthorIcon;
    article.dAuthorIcon = aDAuthorIcon;
//    article.authorLevel = mScoreRank;
    article.pubDate = mPubDate;
    article.title = mTitle;
    article.content = mContent;
    article.articleImgAddr = aArticleImgAddr;
//    article.commentNo = mCommentNo;
    article.score = mScore;
    article.awayFromFirst = mAwayFromFirst;
    article.aid = articleId;
    return article;
}


+ (void) parserAndSaveLeyyeArticle:(NSString *) str{
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    NSMutableDictionary * mutableDict = json[@"data"][@"articles"];
    RKDBHelper * dbHelper = [[RKDBHelper alloc] init];
    for (NSDictionary * dict in mutableDict) {
        NSString * authorIcon = dict[@"authorIcon"];
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_IMG_BASE,authorIcon]];
        NSData  * dAuthorIcon = [[NSData alloc] initWithContentsOfURL:url];
        
        NSString * authorID = dict[@"id"];
        int authorId = authorID == nil ? 0 : [authorID intValue];
        
        NSString * authorRank = dict[@"authorRank"];
        int rank = authorRank == nil ? 0 : [authorRank intValue];
        
//        NSString * scoreRank = dict[@"authorScoreRank"];
//        int authorScoreRank = scoreRank == nil ? 0 : [scoreRank intValue];
        // 可能为空
//        NSString * mCommentCount = dict[@"commentCount"];
//        int commentNo = mCommentCount == nil ? 0 : [mCommentCount intValue];
        
        NSString * scoreStr = dict[@"score"];
        float score = scoreStr == nil ? 0 : [scoreStr floatValue];
        
        NSString * pubDate = dict[@"publishTime"];
        long  pubTime = pubDate == NULL ? 0 :[pubDate longLongValue];
        RKLeyyeArticle * article = [[RKLeyyeArticle alloc] initWithParameters:dict[@"circleName"] andAuthor:dict[@"author"] andAuthorId:authorId andAuthorNick:dict[@"authorNickname"] andAuthorIcon:authorIcon andAuthorIconData:dAuthorIcon andAuthorRank:rank /*andAuthorScoreRank:authorScoreRank*/ andPubDate:pubTime andTitle:dict[@"title"] andContent:dict[@"brief"] andArticleImages:dict[@"image"] /*andCommentNo:commentNo*/ andScore:score andAwayFromFirst:[dict[@"awayFromFirst"] intValue] andArticleId:[dict[@"id"] intValue]];
        [dbHelper insertLeyyeArticle:article];
    }
}

+ (BOOL) updateLeyyeArticle:(NSString *) str{
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    NSMutableDictionary * mutableDict = json[@"data"][@"articles"];
    RKDBHelper * dbHelper = [[RKDBHelper alloc] init];
    for (NSDictionary * dict in mutableDict) {
        NSString * authorIcon = dict[@"authorIcon"];
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_IMG_BASE,authorIcon]];
        NSData  * dAuthorIcon = [[NSData alloc] initWithContentsOfURL:url];
        
        NSString * authorID = dict[@"id"];
        int authorId = authorID == nil ? 0 : [authorID intValue];
        
        NSString * authorRank = dict[@"authorRank"];
        int rank = authorRank == nil ? 0 : [authorRank intValue];
        
//        NSString * scoreRank = dict[@"authorScoreRank"];
//        int authorScoreRank = scoreRank == nil ? 0 : [scoreRank intValue];
          // 可能为空
//        NSString * mCommentCount = dict[@"commentCount"];
//        int commentNo = mCommentCount == nil ? 0 : [mCommentCount intValue];
        
        NSString * scoreStr = dict[@"score"];
        float score = scoreStr == nil ? 0 : [scoreStr floatValue];
        
        NSString * pubDate = dict[@"publishTime"];
        long  pubTime = pubDate == NULL ? 0 :[pubDate longLongValue];
        RKLeyyeArticle * article = [[RKLeyyeArticle alloc] initWithParameters:dict[@"circleName"] andAuthor:dict[@"author"] andAuthorId:authorId andAuthorNick:dict[@"authorNickname"] andAuthorIcon:authorIcon andAuthorIconData:dAuthorIcon andAuthorRank:rank /*andAuthorScoreRank:authorScoreRank*/ andPubDate:pubTime andTitle:dict[@"title"] andContent:dict[@"brief"] andArticleImages:dict[@"image"] /*andCommentNo:commentNo*/ andScore:score andAwayFromFirst:[dict[@"awayFromFirst"] intValue] andArticleId:[dict[@"id"] intValue]];
        [dbHelper updateLeyyeArticle:article];
    }
    return NO;
}

+ (NSMutableArray *) parserLeyyeArticle:(NSMutableDictionary *) mDict;{
    NSMutableArray * mArray = [[NSMutableArray alloc] initWithCapacity:10];
    for (NSDictionary * dict in mDict) {
        NSString * authorIcon = dict[@"authorIcon"];
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_IMG_BASE,authorIcon]];
        NSData  * dAuthorIcon = [[NSData alloc] initWithContentsOfURL:url];
        NSString * domain = NULL;
        if (![RKLeyyeUtilKit isBlankString:dict[@"circleName"]]) {
            domain = dict[@"circleName"];
        }else{
           domain =  @"主城";
        }
        NSString * authorID = dict[@"id"];
        int authorId = authorID == nil ? 0 : [authorID intValue];
        
        NSString * authorRank = dict[@"authorRank"];
        int rank = authorRank == nil ? 0 : [authorRank intValue];
        
        //        NSString * scoreRank = dict[@"authorScoreRank"];
        //        int authorScoreRank = scoreRank == nil ? 0 : [scoreRank intValue];
        // 可能为空
        //        NSString * mCommentCount = dict[@"commentCount"];
        //        int commentNo = mCommentCount == nil ? 0 : [mCommentCount intValue];
        
        NSString * scoreStr = dict[@"score"];
        float score = scoreStr == nil ? 0 : [scoreStr floatValue];
        
        NSString * pubDate = dict[@"publishTime"];
        long  pubTime = pubDate == NULL ? 0 :[pubDate longLongValue];
        RKLeyyeArticle * article = [[RKLeyyeArticle alloc] initWithParameters:domain andAuthor:dict[@"author"] andAuthorId:authorId andAuthorNick:dict[@"authorNickname"] andAuthorIcon:authorIcon andAuthorIconData:dAuthorIcon andAuthorRank:rank /*andAuthorScoreRank:authorScoreRank*/ andPubDate:pubTime andTitle:dict[@"title"] andContent:dict[@"brief"] andArticleImages:dict[@"image"] /*andCommentNo:commentNo*/ andScore:score andAwayFromFirst:[dict[@"awayFromFirst"] intValue] andArticleId:[dict[@"id"] intValue]];
        [mArray addObject:article];
    }
    return  mArray;
}

+ (void) downLoadArticleIcon:(NSString *) icon{
    
}

@end
