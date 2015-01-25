//
//  RKReaderArticleViewController.m
//  Leader
//
//  Created by leyye on 14-11-14.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKReaderArticleViewController.h"
#import "RKConstants.h"
#import "RKLeyyeWallViewController.h"
#import "CustomNavigationController.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "RKDBHelper.h"
#import "RKLeyyeArticle.h"
#import "RKLeyyeComment.h"


#import "KKNavigationController.h"

@interface RKReaderArticleViewController (){
//
}

@end

@implementation RKReaderArticleViewController

@synthesize article = _article;
//@synthesize aid = _aid;
//@synthesize articleTitle = _articleTitle;


- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        debugMethod();
//        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void) loadView{
    [super loadView];
    debugMethod();
}

- (void) initTopSysNaviBar{
    UINavigationBar * topNavi = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
    [topNavi setBackgroundImage:[UIImage imageNamed:@"title_bg@2x.png"] forBarMetrics:UIBarMetricsDefault];
    UINavigationItem * naviItem = [[UINavigationItem alloc] initWithTitle:@"领域"];
    UIButton * btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 2, 28, 28)];
    btnBack.imageView.image = [UIImage imageNamed:@"title_btn5_2@2x.png"];
    [btnBack addTarget:self action:@selector(pushWallCtrl) forControlEvents:UIControlEventTouchDragInside];
    UIBarButtonItem * leftBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    [naviItem setLeftBarButtonItem:leftBarBtnItem];
    [topNavi pushNavigationItem:naviItem animated:YES];
    [self.view addSubview:topNavi];
    
    UIButton * btnRightAddWall = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 25, 10, 20, 20)];
    [btnRightAddWall setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [btnRightAddWall setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    [btnRightAddWall addTarget:self action:@selector(pushWallCtrl) forControlEvents:UIControlEventTouchDragInside];
    [topNavi addSubview:btnRightAddWall];
}

- (void) initTopCustomNaviBar{
    
}

- (void) initContentView{
    mBPHud = [[MBProgressHUD alloc] initWithView:self.view];
    contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, ScreenWidth, ScreenHeight - 45 -44)];
    contentView.scrollEnabled = YES;
    contentView.pagingEnabled = YES;
    contentView.bounces = NO;
//    contentView.canCancelContentTouches=NO;
    contentView.delegate = self;
    contentView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:contentView];
    
    ivArticleImg = [[UIImageView alloc] init];
    [contentView addSubview:ivArticleImg];
    
    labContent = [[UILabel alloc] init];
    labContent.numberOfLines = 0;
    [contentView addSubview:labContent];
    
    labComment = [[UILabel alloc] init];
    labComment.text = @"网友评论:";
    [contentView addSubview:labContent];
    
    leyyeIcon = [[UIImageView alloc] init];
    [contentView addSubview:leyyeIcon];
    
    tvComment = [[UITextView alloc] init];
    [contentView addSubview:tvComment];
    
    commentTableView = [[UITableView alloc] init];
    [contentView addSubview:commentTableView];
    
    ivAdvertise = [[UIImageView alloc] init];
    [contentView addSubview:ivAdvertise];
    
}

- (void) initBottomView{
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44)];
    bottomView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"toolbar"]];
    [self.view addSubview:bottomView];
    
    CGFloat btnX = self.view.center.x - 30;
    btnWriteArticle = [[UIButton alloc]initWithFrame:CGRectMake(btnX, 4, 43, 43)];
    btnWriteArticle.imageView.image = [UIImage imageNamed:@"btn_del_1@2x.png"];
    [bottomView addSubview:btnDeleteArticle];
}

- (void) initBackButton{
    
}

- (void) pushWallCtrl{
    RKLeyyeWallViewController * wallCtrl = [[RKLeyyeWallViewController alloc] init];
//    wallCtrl.modalPresentationStyle = UIModalTransitionStyleCoverVertical;
//    CustomNavigationController * cNaviCtrl = [[CustomNavigationController alloc] initWithRootViewController:wallCtrl];
//    [self presentViewController:cNaviCtrl animated:YES completion:nil];
    [self.navigationController pushViewController:wallCtrl animated:YES];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    debugMethod();
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self isKindOfClass:[CustomViewController class]]) {
        [self initTopCustomNaviBar];
    }else{
        [self initTopSysNaviBar];
    }
    [self initContentView];
    [self initBottomView];
    
}

- (void) setContentView{
    articleContent = _article.content;
    CGSize contentSize = [articleContent sizeWithFont:labContent.font constrainedToSize:CGSizeMake(ScreenWidth - 20, MAXFLOAT)];
    if (_article.articleImgAddr != nil) {
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_IMG_BASE,_article.articleImgAddr]];
        NSData  * data = [[NSData alloc] initWithContentsOfURL:url];
        UIImage * articleImage = [UIImage imageWithData:data];
        CGFloat height = articleImage.size.height;
        
        ivArticleImg.frame = CGRectMake(10, 30, ScreenWidth - 20, height);
        ivArticleImg.image = articleImage;
        [contentView addSubview:ivArticleImg];
        labContent.frame = CGRectMake(10, height + 10, ScreenWidth - 10, contentSize.height);
    }else{
        labContent.frame = CGRectMake(10, 40, ScreenWidth - 10, contentSize.height);
    }
    labContent.text = articleContent;
    
    CGFloat commentY = CGRectGetMaxY(labContent.frame) + 10;
//    CGSize commentSize = [labComment.text sizeWithFont:labComment.font constrainedToSize:CGSizeMake(MAXFLOAT, 22)];
    labComment.frame = CGRectMake(10, commentY, 100, 22);
    
    CGFloat leyyeIconY = CGRectGetMaxY(labComment.frame) + 3;
    leyyeIcon.frame = CGRectMake(10, leyyeIconY, 35, 35);
    
    CGFloat commentTVY = CGRectGetMaxY(leyyeIcon.frame) + 10;
    commentTableView.frame = CGRectMake(0, commentTVY, ScreenWidth, 100);
    
    CGFloat advY = CGRectGetMaxY(leyyeIcon.frame) + 10;
    ivAdvertise.frame = CGRectMake(10, advY, 300, 195);
    ivAdvertise.image = [UIImage imageNamed:@"ad@2x.jpg"];
    
    contentView.contentSize = CGSizeMake(ScreenWidth,CGRectGetMaxY(ivAdvertise.frame) + 10);
}

- (void) viewDidAppear:(BOOL)animated{
    debugMethod();
    [super viewDidAppear:animated];
    if ([self isKindOfClass:[CustomViewController class]]) {
        [self setTopCustomNaviBar];
    }
    [self setContentView];
//    [self queryArticleComment];
//    [self queryArticleCommentFromeDatabase];
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

- (void) setTopCustomNaviBar{
    articleTitle = _article.title;
    if (articleTitle != nil) {
        [self setNaviBarTitle:articleTitle];
    }else{
        [self setNaviBarTitle:@"领域"];
    }
}

- (void) setTableView{
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    // This enables the user to scroll down the navbar by tapping the status bar.
//    [self showNavbar];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) queryLeyyeArticleDetail{
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_MY_ARTICLE]];
    request.tag = 100;
    request.delegate = self;
    [request addPostValue:@"1" forKey:@"offset"];
    [request addPostValue:@"10" forKey:@"count"];
    [request startAsynchronous];
}

- (void) queryArticleCommentFromeDatabase{
    dbHelper = [[RKDBHelper alloc] init];
    mArraycomment = [dbHelper queryArticleComment:_article.aid];
}

#pragma mark - 查询评论列表
- (void) queryArticleComment{
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_COMMENTS]];
    request.tag = 200;
    request.delegate = self;
    [request addPostValue:[NSString stringWithFormat:@"%i", _article.aid] forKey:@"article"];
    [request addPostValue:@"0" forKey:@"offset"];
    [request addPostValue:@"20" forKey:@"count"];
    [request startAsynchronous];
}

#pragma mark - 发表评论
- (void) publishArticleComment{
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_SEND_COMMENT]];
    request.tag = 300;
    request.delegate = self;
    [request addPostValue:[NSString stringWithFormat:@"%i", _article.aid] forKey:@"article"];
    [request addPostValue:@"0" forKey:@"offset"];
    [request addPostValue:@"20" forKey:@"count"];
    [request startAsynchronous];
}

- (void) requestStarted:(ASIHTTPRequest *)request{
    mBPHud.labelText = @"数据加载中...";
    [mBPHud show:YES];
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    switch (request.tag) {
        case 100:{
            debugLog(@"response:%@",[request responseString]);
        }
            break;
        case 200:{
            debugLog(@"%sresponse:%@",__FUNCTION__,[request responseString]);
            [RKLeyyeComment parserArticleComment:[request responseString]];
        }
            break;
        case 300:{
            debugLog(@"%sresponse:%@",__FUNCTION__,[request responseString]);
        }
            break;
        default:
            debugLog(@"%sresponse:%@",__FUNCTION__,[request responseString]);
            break;
    }
}

- (void) requestFailed:(ASIHTTPRequest *)request{
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

@end
