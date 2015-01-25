//
//  MainViewController.h
//  Leader
//
//  Created by leyye on 14-11-1.
//  Copyright (c) 2014年 leyye. All rights reserved.
#import "RKRootViewController.h"
#import "RKMainViewController.h"
#import "RKMinorViewController.h"
#import "RKConstants.h"
#import "UIViewController+TopBarMessage.h"
#import "CustomNavigationController.h"
#import "KKNavigationController.h"
#import "MMDrawerBarButtonItem.h"
#import "MMDrawerController.h"
//////////////////////////////////////////////////////////////////////////
#import "RKMeViewController.h"
#import "RKLeyyeAddViewController.h"
#import "RKDomainUserViewController.h"
#import "RKLeyyeRewardViewController.h"
#import "RKLeyyeServiceViewController.h"
#import "RKReaderArticleViewController.h"
#import "RKWriteArticleViewController.h"
#import "RKLoginAndRegisterViewController.h"
//////////////////////////////////////////////////////////////////////////
#import "ASIFormDataRequest.h"
#import "UIViewController+MMDrawerController.h"
#import "RKLoginViewController.h"
#import "RKFileManager.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
//////////////////////////////////////////////////////////////////////////
#import "RKArticleCell.h"
#import "RKLeyyeDomain.h"
#import "RKLeyyeArticle.h"
#import "RKDBHelper.h"
#import "RKFileManager.h"
#import "RKLeyyeUtilKit.h"

//////////////////////////////////////////////////////////////////////////
#import "EGOImageView.h"
#import "MJRefresh.h"

#import "DKScrollingTabController.h"
#import "RKMyViewController.h"
#import "CategorySliderView.h"
#import "RKAppDelegate.h"

@interface RKMainViewController ()

@end

@implementation RKMainViewController

@synthesize topView;
@synthesize mTableView = _mTableView;
@synthesize bottomView;
@synthesize writeBtn;
@synthesize ivAppUserIcon = _ivAppUserIcon;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    [self loadData];
  }
  return self;
}

- (void)initTopLeyyeMenu {
  DKScrollingTabController *tabController =
      [[DKScrollingTabController alloc] init];
  RKMyViewController *myViewController = [[RKMyViewController alloc] init];
  [tabController addChildViewController:myViewController];
  tabController.delegate = self;
  [self addChildViewController:tabController];
  [tabController didMoveToParentViewController:self];
  [self.view addSubview:tabController.view];
  tabController.view.frame = CGRectMake(45, 105, 320, 40);
  tabController.buttonPadding = 23;
  tabController.underlineIndicator = NO;
  tabController.selection = @[
    @"爱家社区",
    @"移到互联网",
    @"故事",
    @"用户体验",
    @"笑话",
    @"领域意见"
  ];
}

- (void)queryArticleFromDatabase {
  dbHelper = [[RKDBHelper alloc] init];
  mArrayArticle = [dbHelper queryLeyyeArticle];
  mArrayCell = [NSMutableArray array];
  [mArrayArticle
      enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
          RKArticleCell *cell = [[RKArticleCell alloc] init];
          [mArrayCell addObject:cell];
      }];
  mutableArrayDomain = [dbHelper queryLeyyeDomain];
  for (RKLeyyeDomain *domain in mutableArrayDomain) {
    [menuTitles addObject:domain.domainTitle];
  }
  curAppUserIcon = [dbHelper queryLeyyeUserWith:sUserName1];
}

- (void)initMainNaviBarMenu {
  if (![self isKindOfClass:[CustomViewController class]]) {
    UINavigationBar *naviBar = [[UINavigationBar alloc]
        initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
    naviBar.userInteractionEnabled = YES;
    [naviBar setBackgroundImage:[UIImage imageNamed:@"home_navi_bg@2x.png"]
                  forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:naviBar];
    UINavigationItem *naviItem =
        [[UINavigationItem alloc] initWithTitle:@"主城"];
    [naviBar pushNavigationItem:naviItem animated:YES];

    ivAppUserIcon =
        [[EGOImageView alloc] initWithFrame:CGRectMake(5, 0, 38, 38)];
    ivAppUserIcon.placeholderImage = [UIImage imageNamed:@"default_head"];
    ivAppUserIcon.imageURL =
        [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_IMG_BASE,
                                                        curAppUserIcon]];
    [naviBar addSubview:ivAppUserIcon];

    UIButton *btnIcon =
        [[UIButton alloc] initWithFrame:CGRectMake(5, 2, 38, 38)];
    //        [btnIcon addTarget:self action:@selector(presentMeCtrl)
    //        forControlEvents:<#(UIControlEvents)#>]
    [self.view addSubview:btnIcon];

    rightBtn = [[UIButton alloc]
        initWithFrame:CGRectMake(ScreenWidth - 45, 2, 45, 45)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"title_btn2_1@2x.png"]
                        forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"title_btn2_2@2x.png"]
                        forState:UIControlStateHighlighted];
    [naviBar addSubview:rightBtn];
  } else {
    rightBtn = [[UIButton alloc]
        initWithFrame:CGRectMake(ScreenWidth - 45, 5, 45, 45)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"title_btn2_1@2x.png"]
                        forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"title_btn2_2@2x.png"]
                        forState:UIControlStateHighlighted];
    [rightBtn addTarget:self
                  action:@selector(pushLeyyeDomain)
        forControlEvents:UIControlEventTouchDragInside];
    //        [self setNaviBarRightBtn:rightBtn];
  }
}

- (void)initCategorySliderView {
  self.sliderView = [[CategorySliderView alloc]
        initWithSliderHeight:45
            andCategoryViews:@[
              [self labelWithText:@"主城"],
              [self labelWithText:@"爱家社区"]
            ]
      categorySelectionBlock:^(UIView *categoryView, NSInteger categoryIndex) {
          UILabel *selectedView = (UILabel *)categoryView;
          NSLog(@"\"%@\" cateogry selected at index %ld", selectedView.text,
                categoryIndex);
      }];
  [self.sliderView setY:0];
  [self.sliderView moveY:0 duration:0.5 complation:nil];
  [self.view addSubview:self.sliderView];
}

- (UILabel *)labelWithText:(NSString *)text {
  float w = [text sizeWithAttributes:@{
               NSFontAttributeName : [UIFont systemFontOfSize:17]
             }].width;

  UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w, 60)];
  [lbl setFont:[UIFont systemFontOfSize:15]];
  [lbl setText:text];
  lbl.textColor = [UIColor whiteColor];
  [lbl setTextAlignment:NSTextAlignmentCenter];
  return lbl;
}

- (void)initMainBottomToolsBar {
  UIToolbar *bottomToolBar = [[UIToolbar alloc]
      initWithFrame:CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44)];
  [bottomToolBar setBackgroundImage:[UIImage imageNamed:@"toolbar"]
                 forToolbarPosition:UIBarPositionAny
                         barMetrics:UIBarMetricsDefault];
  [self.view addSubview:bottomToolBar];

  UIBarButtonItem *btnMission = [[UIBarButtonItem alloc]
      initWithImage:[UIImage imageNamed:@"domain_miss_1"]
              style:UIBarButtonItemStyleBordered
             target:self
             action:@selector(pushLeyyeDomain)];
  UIBarButtonItem *btnClub = [[UIBarButtonItem alloc]
      initWithImage:[UIImage imageNamed:@"domain_club_1"]
              style:UIBarButtonItemStyleBordered
             target:self
             action:@selector(pushLeyyeDomain)];
  bottomToolBar.items = [NSArray arrayWithObjects:btnMission, btnClub, nil];

  UIButton *btnAuthor =
      [[UIButton alloc] initWithFrame:CGRectMake(15, 2, 40, 40)];
  [btnAuthor setImage:[UIImage imageNamed:@"domain_author_1"]
             forState:UIControlStateHighlighted];
  [btnAuthor setImage:[UIImage imageNamed:@"domain_author_2"]
             forState:UIControlStateHighlighted];
  [bottomToolBar addSubview:btnAuthor];
}

- (void)initMainTopMenuView {
  UIView *topMenuView =
      [[UIView alloc] initWithFrame:CGRectMake(0, 45, ScreenWidth, 45)];
  topMenuView.backgroundColor =
      [UIColor colorWithPatternImage:[UIImage imageNamed:@"toolbar"]];
  [self.view addSubview:topMenuView];
  UIButton *btnDomain =
      [[UIButton alloc] initWithFrame:CGRectMake(5, 3, 42, 42)];
  [btnDomain setImage:[UIImage imageNamed:@"domain_list_1"]
             forState:UIControlStateNormal];
  [btnDomain setImage:[UIImage imageNamed:@"domain_list_2"]
             forState:UIControlStateHighlighted];
  [btnDomain addTarget:self
                action:@selector(addDomainCtrl)
      forControlEvents:UIControlEventTouchDragInside];
  [topMenuView addSubview:btnDomain];

  UIButton *btnAuthor =
      [[UIButton alloc] initWithFrame:CGRectMake(10 + 42, 3, 42, 42)];
  [btnAuthor setImage:[UIImage imageNamed:@"domain_author_1"]
             forState:UIControlStateNormal];
  [btnAuthor setImage:[UIImage imageNamed:@"domain_author_2"]
             forState:UIControlStateHighlighted];
  [btnDomain addTarget:self
                action:@selector(addAuthorCtrl)
      forControlEvents:UIControlEventTouchDragInside];
  [topMenuView addSubview:btnAuthor];

  UIButton *btnActivity =
      [[UIButton alloc] initWithFrame:CGRectMake(15 + 42 * 2, 3, 42, 42)];
  [btnActivity setImage:[UIImage imageNamed:@"domain_miss_1"]
               forState:UIControlStateNormal];
  [btnActivity setImage:[UIImage imageNamed:@"domain_miss_2"]
               forState:UIControlStateHighlighted];
  [btnDomain addTarget:self
                action:@selector(addAuthorCtrl)
      forControlEvents:UIControlEventTouchDragInside];
  [topMenuView addSubview:btnActivity];

  UIButton *btnClub =
      [[UIButton alloc] initWithFrame:CGRectMake(20 + 42 * 3, 3, 42, 42)];
  [btnClub setImage:[UIImage imageNamed:@"domain_club_1"]
           forState:UIControlStateNormal];
  [btnClub setImage:[UIImage imageNamed:@"domain_club_2"]
           forState:UIControlStateHighlighted];
  [topMenuView addSubview:btnClub];
}

- (void)addDomainCtrl {
  //    [self addChildViewController:[[RKMainViewController alloc] init]];
  //    [self.view addSubview:self.view];
}

- (void)addAuthorCtrl {
  RKDomainUserViewController *userCtrl =
      [[RKDomainUserViewController alloc] init];
  [self.view addSubview:userCtrl.view];
}

- (void)loadData {
  defaults = [NSUserDefaults standardUserDefaults];
  sUserName1 = [defaults objectForKey:@"leyye_username1"];
  cookieValue = [defaults objectForKey:@"app-cookie"];
}

- (void)initMainBottomMenu {
  UIView *bottomMenuView = [[UIView alloc]
      initWithFrame:CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44)];
  bottomMenuView.backgroundColor =
      [UIColor colorWithPatternImage:[UIImage imageNamed:@"toolbar"]];
  [self.view addSubview:bottomMenuView];
}

- (void)pushLeyyeDomain {
  //    [self.navigationController
  //    pushViewController:[[RKAddDomainViewController alloc] init]
  //    animated:YES];
}

- (void)setMainNaviView {
  topNaviView =
      [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
  topNaviView.backgroundColor = [UIColor blueColor];
  //    [self naviBarAddCoverView:topNaviView];
  //    [self setMainNaviBarRightButton];
}

#pragma mark - 用户菜单
- (void)setLeyyeHomeMenu {
}

- (void)initMainTableView00 {
  appDelegate = (RKAppDelegate *)[UIApplication sharedApplication].delegate;
  if (![appDelegate isNetworkReachability]) {
    [self showTopMessage:@"网络不给力"];
    //        mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 130 ,
    //        ScreenWidth,ScreenHeight - 45 *3) style:UITableViewStylePlain];
  }
  mTableView = [[UITableView alloc]
      initWithFrame:CGRectMake(0, 90, ScreenWidth, ScreenHeight - 135)
              style:UITableViewStylePlain];
  [mTableView setBackgroundColor:[UIColor whiteColor]];
  mTableView.delegate = self;
  mTableView.dataSource = self;
  [mTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth |
                                  UIViewAutoresizingFlexibleHeight];
  [self.view addSubview:mTableView];

  [mTableView addHeaderWithTarget:self
                           action:@selector(headerRereshing)
                          dateKey:@"table"];
  [mTableView headerBeginRefreshing];

  // 2.集成刷新控件
  [self setupRefresh];
}

- (void)initMainTableView01 {
  appDelegate = (RKAppDelegate *)[UIApplication sharedApplication].delegate;
  if (![appDelegate isNetworkReachability]) {
    [self showTopMessage:@"网络不给力"];
  }
  _mTableView.delegate = self;
  _mTableView.dataSource = self;
  [_mTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth |
                                   UIViewAutoresizingFlexibleHeight];

  [_mTableView addHeaderWithTarget:self
                            action:@selector(headerRereshing)
                           dateKey:@"table"];
  [_mTableView headerBeginRefreshing];

  // 2.集成刷新控件
  [self setupRefresh];
}

- (BOOL)canBecomeFirstResponder {
  return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
  if (action == @selector(cut:)) {
    return NO;
  } else if (action == @selector(copy:)) {
    return YES;
  } else if (action == @selector(paste:)) {
    return NO;
  } else if (action == @selector(select:)) {
    return NO;
  } else if (action == @selector(selectAll:)) {
    return NO;
  } else {
    return [super canPerformAction:action withSender:sender];
  }
}

- (void)copy:(id)sender {
  //    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
  //    [pasteboard setString:[[self textLabel]text]];
}

- (void)initialize {
  mBPHud = [[MBProgressHUD alloc] initWithView:self.view];
  mBPHud.delegate = self;
  [self.view addSubview:mBPHud];

  _ivAppUserIcon = [[EGOImageView alloc]
      initWithPlaceholderImage:[UIImage imageNamed:@"default_head"]];
  [self loadData];
}

- (void)initSubview {
  meCtrl = [[RKMeViewController alloc] init];
  userAuthorCtrl = [[RKDomainUserViewController alloc] init];
  rewardCtrl = [[RKLeyyeRewardViewController alloc] init];
  clubCtrl = [[RKLeyyeServiceViewController alloc] init];
  [self.view addSubview:userAuthorCtrl.view];
  [self.view addSubview:rewardCtrl.view];
  [self.view addSubview:clubCtrl.view];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  curAppUserIcon = [[[RKDBHelper alloc] init] queryLeyyeUserWith:sUserName1];
  _ivAppUserIcon.imageURL =
      [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_IMG_BASE,
                                                      curAppUserIcon]];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  if ([self isKindOfClass:[CustomViewController class]]) {
    //        [self setNaviBarTitle:@"主城"];
    //        [self setNaviBarLeftBtn:nil];
  }
  [self initialize];
  [self initMainTableView01];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self loadData];
}

//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
- (BOOL)prefersStatusBarHidden {
  return YES;
}

- (BOOL)shouldAutorotate {
  return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
  return (UIInterfaceOrientationMaskPortrait);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
            (UIInterfaceOrientation)toInterfaceOrientation {
  return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
/**
 *  集成刷新控件
 */
- (void)setupRefresh {
  // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
  //    [mTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
  // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
  [_mTableView addHeaderWithTarget:self
                            action:@selector(headerRereshing)
                           dateKey:@"table"];
  [_mTableView headerBeginRefreshing];

  // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
  [_mTableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing {
  pagerIndex = 1;
  [self queryLeyyeArticlesWithIndex:pagerIndex];
}

- (void)footerRereshing {
  pagerIndex++;
  [self queryLeyyeArticlesWithIndex:pagerIndex];
}
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
- (void)dealloc {
}

//////////////////////////////////////////////////////////////////////////
#pragma mark - 自定义接口方法
#pragma mark 查询所有文章
- (void)queryLeyyeArticlesWithIndex:(int)index {
  ASIFormDataRequest *request =
      [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_ARTICLES]];
  request.tag = 88;
  request.delegate = self;
  [request setTimeOutSeconds:60];
  [request setNumberOfTimesToRetryOnTimeout:2];
  [request setPersistentConnectionTimeoutSeconds:120];
  [request setShouldContinueWhenAppEntersBackground:YES];
  [request addPostValue:@"0" forKey:@"circleId"];
  [request addPostValue:@"2" forKey:@"sort"]; // 0 最火，1 最佳，2 最新
  [request addPostValue:@"0" forKey:@"offset"];
  [request addPostValue:[NSString stringWithFormat:@"%i", 20 * index]
                 forKey:@"count"];
  if (![RKLeyyeUtilKit isBlankString:cookieValue]) {
    [request addRequestHeader:@"Cookie" value:cookieValue];
  }
  [request startAsynchronous];
}

#pragma mark 查询所有的圈子
- (void)queryLeyyeCircles {
  ASIFormDataRequest *circleRequest =
      [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_DOMAINS]];
  circleRequest.tag = kLeyyeCircles;
  circleRequest.delegate = self;
  //    [circleRequest addPostValue:@"主城" forKey:@"key"];
  [circleRequest addPostValue:@"0" forKey:@"offset"];
  [circleRequest addPostValue:@"10" forKey:@"count"];
  [circleRequest startAsynchronous];
}

#pragma mark - 查询我的圈子
- (void)queryMyCircles {
  ASIFormDataRequest *request =
      [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_MY_DOMAINS]];
  request.tag = kMyCircles;
  request.delegate = self;
  [request addPostValue:@"1" forKey:@"offset"];
  [request addPostValue:@"10" forKey:@"count"];
  [request startAsynchronous];
}

#pragma mark - 查询俱乐部
- (void)queryLeyyeClubs {
  ASIFormDataRequest *request =
      [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_CLUBS]];
  request.tag = kLeyyeClubs;
  request.delegate = self;
  [request addPostValue:@"0" forKey:@"offset"];
  [request addPostValue:@"10" forKey:@"count"];
  [request startAsynchronous];
}

#pragma mark - 查询我的俱乐部
- (void)queryMyClub {
  ASIFormDataRequest *request =
      [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_CLUB_INTRO]];
  request.tag = kLeyyeClubs;
  request.delegate = self;
  [request addPostValue:@"1" forKey:@"offset"];
  [request addPostValue:@"10" forKey:@"count"];
  [request startAsynchronous];
}

//////////////////////////////////////////////////////////////////////////
- (void)requestStarted:(ASIHTTPRequest *)request {
  //    mBPHud = [[MBProgressHUD alloc] initWithView:self.view];
  //    mBPHud.delegate = self;
  //    mBPHud.labelText = @"正在加载中...";
  //    [self.view addSubview:mBPHud];
  //    [mBPHud show:YES];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
  NSError *error;
  id json = [NSJSONSerialization
      JSONObjectWithData:[[request responseString]
                             dataUsingEncoding:NSUTF8StringEncoding]
                 options:NSJSONReadingAllowFragments
                   error:&error];
  //    NSString * errorInfo = [error userInfo][@"NSDebugDescription"];
  if ([RKLeyyeUtilKit isBlankString:[json[@"error"] stringValue]]) {
    [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
    [mBPHud hide:YES];
    return;
  }
  int index = [json[@"error"] intValue];
  if (index == 0) {
    switch (request.tag) {
      case 88: {
        mArrayArticle =
            [RKLeyyeArticle parserLeyyeArticle:json[@"data"][@"articles"]];
        mArrayCell = [NSMutableArray array];
        [mArrayArticle
            enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                RKArticleCell *cell = [[RKArticleCell alloc] init];
                [mArrayCell addObject:cell];
            }];
        [_mTableView headerEndRefreshing];
        [_mTableView footerEndRefreshing];
        [_mTableView reloadData];
      } break;
      default:
        break;
    }
  } else if (index == 999) {
    [SVProgressHUD showErrorWithStatus:@"参数有误"];
    [mBPHud hide:YES];
    return;
  } else {
    [SVProgressHUD showErrorWithStatus:@"未知错误"];
    [mBPHud hide:YES];
    return;
  }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
  [mTableView headerEndRefreshing];
  [mTableView footerEndRefreshing];
  [SVProgressHUD showErrorWithStatus:@"网络出现问题"];
}

#pragma mark 导航栏事件
- (void)setupLeftMenuButton {
  MMDrawerBarButtonItem *leftDrawerButton = [[MMDrawerBarButtonItem alloc]
      initWithTarget:self
              action:@selector(leftDrawerButtonPress:)];
  [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

- (void)setupRightMenuButton {
  MMDrawerBarButtonItem *rightDrawerButton = [[MMDrawerBarButtonItem alloc]
      initWithTarget:self
              action:@selector(rightDrawerButtonPress:)];
  [self.navigationItem setRightBarButtonItem:rightDrawerButton animated:YES];
}

#pragma mark - Button Handlers
- (void)leftDrawerButtonPress:(id)sender {
  [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft
                                    animated:YES
                                  completion:nil];
}

- (void)rightDrawerButtonPress:(id)sender {
  RKLeyyeAddViewController *addLeyyeViewController =
      [[RKLeyyeAddViewController alloc] init];
  //    mNavigationController = [[UINavigationController alloc]
  //    initWithRootViewController:addLeyyeViewController];
  //    [[UIApplication sharedApplication].keyWindow
  //    setRootViewController:mNavigationController];
  [self.navigationController pushViewController:addLeyyeViewController
                                       animated:YES];
}

- (void)doubleTap:(UITapGestureRecognizer *)gesture {
  [self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideLeft
                                            completion:nil];
}

- (void)twoFingerDoubleTap:(UITapGestureRecognizer *)gesture {
  [self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideRight
                                            completion:nil];
}

//////////////////////////////////////////////////////////////////////////
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  RKArticleCell *cell = [mArrayCell objectAtIndex:indexPath.row];
  if (cell == nil) {
    return 100;
  } else {
    //        debugLog(@"%s -> height:%.1f",__FUNCTION__,cell.height);
    cell.article = [mArrayArticle objectAtIndex:indexPath.row];
    return cell.height;
  }
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return mArrayArticle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *identifier = @"article";
  RKArticleCell *articleCell =
      [tableView dequeueReusableCellWithIdentifier:identifier];
  if (articleCell == nil) {
    articleCell =
        [[RKArticleCell alloc] initWithStyle:UITableViewCellStyleDefault
                             reuseIdentifier:identifier];
  }
  articleCell.index = indexPath.row;
  RKLeyyeArticle *article = [mArrayArticle objectAtIndex:indexPath.row];
  if (article != nil) {
    //        debugLog(@"%sdAuthorIcon:%@",__FUNCTION__,article.dAuthorIcon);
    [articleCell setArticle:article];
  }
  UILongPressGestureRecognizer *longPress =
      [[UILongPressGestureRecognizer alloc]
          initWithTarget:self
                  action:@selector(handleLongPress:)];
  [articleCell addGestureRecognizer:longPress];
  return articleCell;
}

- (BOOL)tableView:(UITableView *)tableView
    shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
  debugMethod();
  return NO;
}

- (BOOL)tableView:(UITableView *)tableView
     canPerformAction:(SEL)action
    forRowAtIndexPath:(NSIndexPath *)indexPath
           withSender:(id)sender {
  //    if(action == @selector(copy:)){
  //        return YES;
  //    }else if(action == @selector(select:)){
  //        return YES;
  //    }else if(action == @selector(selectAll:)){
  //        return YES;
  //    }else{
  return NO;
  //    }
}

- (void)tableView:(UITableView *)tableView
        performAction:(SEL)action
    forRowAtIndexPath:(NSIndexPath *)indexPath
           withSender:(id)sender {
  if (action == @selector(copy:)) {
    RKLeyyeArticle *article = [mArrayArticle objectAtIndex:indexPath.row];
    [UIPasteboard generalPasteboard].string = article.title;
  } else if (action == @selector(select:)) {
    NSLog(@"select");
  } else if (action == @selector(selectAll:)) {
    NSLog(@"selectAll");
  }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer {
  if (recognizer.state == UIGestureRecognizerStateBegan) {
    RKArticleCell *cell = (RKArticleCell *)recognizer.view;
    [cell becomeFirstResponder];
    UIMenuItem *flag =
        [[UIMenuItem alloc] initWithTitle:@"分享" action:@selector(flag:)];
    UIMenuItem *approve =
        [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(approve:)];
    UIMenuItem *deny =
        [[UIMenuItem alloc] initWithTitle:@"收藏" action:@selector(deny:)];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:[NSArray arrayWithObjects:flag, approve, deny, nil]];
    [menu setTargetRect:cell.frame inView:cell.superview];
    [menu setMenuVisible:YES animated:YES];
  }
}

- (void)flag:(id)sender {
  NSLog(@"Cell was flagged");
}
- (void)approve:(id)sender {
  NSLog(@"Cell was approved");
}

- (void)deny:(id)sender {
  NSLog(@"Cell was denied");
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [[[self mTableView] cellForRowAtIndexPath:indexPath] setSelected:YES
                                                          animated:YES];
  RKReaderArticleViewController *readerArticleVC =
      [[RKReaderArticleViewController alloc] init];
  RKLeyyeArticle *article = [mArrayArticle objectAtIndex:indexPath.row];
  readerArticleVC.article = article;
  //    CustomNavigationController * cuNavigationController =
  //    [[CustomNavigationController alloc]
  //    initWithRootViewController:readerArticleVC];
  //    UINavigationController * sysNavigationController =
  //    [[UINavigationController alloc]
  //    initWithRootViewController:readerArticleVC];
  //    KKNavigationController * kkNavigationController =
  //    [[KKNavigationController alloc]
  //    initWithRootViewController:readerArticleVC];
  //    [self presentViewController:cuNavigationController animated:YES
  //    completion:nil];
  [self.navigationController pushViewController:readerArticleVC animated:YES];
}

//////////////////////////////////// Xib文件方法
/////////////////////////////////////////
- (IBAction)showRightDomain:(id)sender {
  [(RKRootViewController *)self.parentViewController showRight];
}

- (IBAction)showMeCtrl:(id)sender {
  [self.navigationController pushViewController:meCtrl animated:YES];
}

@end
