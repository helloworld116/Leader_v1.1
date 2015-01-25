//
//  RKReaderArticleViewController.h
//  Leader
//
//  Created by leyye on 14-11-14.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "AMScrollingNavbarViewController.h"
#import "ASIHTTPRequest.h"


@class RKLeyyeArticle;
@class RKLeyyeComment;
@class RKDBHelper;
@class MBProgressHUD;

@interface RKReaderArticleViewController : CustomViewController<ASIHTTPRequestDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    UIView * topView;
    UIButton * btnRightNaviBar;
    UIView * backView;
    UIButton * btnDeleteArticle;
    UIScrollView * contentView;
    NSString * articleTitle;
    UILabel * labTitle;
    UILabel * articleDate;
    UIImageView * ivArticleImg;
    UILabel * labContent;
    NSString * articleContent;
    UILabel * labComment;
    UIImageView * leyyeIcon;
    UITextView * tvComment;
    UIImageView * ivAdvertise;
    UIView * bottomView;
    UIButton * btnWriteArticle;
    MBProgressHUD * mBPHud;
    RKDBHelper * dbHelper;
    NSMutableArray * mArraycomment;
    UITableView * commentTableView;
}

@property (nonatomic, strong) RKLeyyeArticle * article;

- (void) setArticle:(RKLeyyeArticle *)aArticle;

- (void) queryLeyyeArticleDetail;

@end
