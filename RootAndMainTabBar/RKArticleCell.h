//
//  RKCustumeCell.h
//  Leader
//
//  Created by leyye on 14-11-4.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EGOImageView;
@class RKLeyyeArticle;

@interface RKArticleCell : UITableViewCell{
    EGOImageView * ivAuthorIcon;
    UILabel * num ;
    UILabel * labArticleNo;
//    UIImageView *ivAuthorIcon;
    UILabel * labArticleTitle;
    UILabel * labArticleAuthor;
    UILabel * labArticleDomain;
    UILabel * labArticleRank;
    UILabel * labArticleContent;
    UILabel * labArticleVitality;
    UIImageView *ivVitalityIcon;
    UIView * separatorBackgound;
}
@property (nonatomic, retain) id delegate;
@property (nonatomic,retain) RKLeyyeArticle * article;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic ,assign) CGFloat height;

@end
