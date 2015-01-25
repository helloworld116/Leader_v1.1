//
//  MainViewController.h
//  Leader
//
//  Created by leyye on 14-11-1.
//  Copyright (c) 2014年 leyye. All rights reserved.
#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "DKScrollingTabController.h"
#import "ASIHTTPRequestDelegate.h"
#import "RKFileManager.h"
#import "DOPDropDownMenu.h"
#import "SHViewPager.h"
#import "RNSwipeViewController.h"
#import "MBProgressHUD.h"

@class RKAppDelegate;
@class RKDBHelper, RKLeyyeUser, RKLeyyeDomain, RKLeyyeArticle;
@class RKArticleCell;
@class RKLeftViewController;
@class RKLeyyeAddViewController;
@class RKMeViewController, RKDomainUserViewController,
    RKLeyyeRewardViewController, RKLeyyeServiceViewController;
@class CategorySliderView;
@class EGOImageView;

@interface RKMainViewController
    : UIViewController<UITabBarControllerDelegate, UITableViewDataSource,
                       DOPDropDownMenuDelegate, UITableViewDelegate,
                       MBProgressHUDDelegate, ASIHTTPRequestDelegate,
                       UIScrollViewDelegate> {
  NSUserDefaults *defaults;
  NSString *cookieValue;
  RKLeyyeUser *appUser;
  NSString *sUserName1;
  RKLeyyeUser *curAppUser;
  NSString *curAppUserIcon;
  RKAppDelegate *appDelegate;

  /*主城页面的所有视图控制器*/
  RKMeViewController *meCtrl;
  RKDomainUserViewController *userAuthorCtrl;
  RKLeyyeRewardViewController *rewardCtrl;
  RKLeyyeServiceViewController *clubCtrl;

  MBProgressHUD *mBPHud;

  UIButton *rightBtn;

  /**/
  UITableView *mTableView;
  int pagerIndex;

  NSMutableDictionary *articles;
  UIView *topNaviView;
  UIWebView *webView;
  EGOImageView *ivAppUserIcon;
  UIActivityIndicatorView *activityIndicatorView;
  UINavigationController *mNavigationController;
  UIButton *btnWriteArticle;

  RKFileManager *fileManager;
  RKDBHelper *dbHelper;
  NSMutableArray *mArrayArticle;
  NSMutableArray *mutableArrayDomain;
  NSMutableArray *mutableArrayIcon;
  NSString *articleIcon;
  NSMutableArray *mArrayCell;

  NSMutableArray *mutableArrayLeyyeDomain;
  UINavigationController *navigationController;
  NSMutableArray *menuTitles;
  NSMutableArray *mutableArrayCtrl;
}
@property (nonatomic, strong) CategorySliderView *sliderView;
@property (nonatomic, strong) IBOutlet UITableView *mTableView;
@property (nonatomic, retain) IBOutlet EGOImageView *ivAppUserIcon;

@property (nonatomic, strong) RKLeyyeDomain *domain;

@property (strong, nonatomic) UITabBarController *tabBarController;

@property (nonatomic, strong) UITableView *menuTableView;
@property (nonatomic, strong) NSArray *drawerWidths;
//@property (nonatomic,strong) RKLeftViewController
//*leftSideDrawerViewController;
@property (nonatomic, strong) RKLeyyeAddViewController *addLeyyeViewController;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *writeBtn;
@property (nonatomic, strong) UIButton *nextPageBtn;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSMutableArray *menus;
@property (nonatomic, assign) BOOL shouldObserving;

/*页面设计*/
#pragma mark - 头部菜单
//- (void) initMainTopToolsBar;

#pragma mark - 底部菜单
//- (void) initMainBottomToolsBar;

- (void)queryArticleFromDatabase;

/**
 * 后台接口方法
 */
- (void)queryLeyyeArticlesWithIndex:(int)index;

//////////////////////////////////// Xib文件方法
/////////////////////////////////////////
- (IBAction)showRightDomain:(id)sender;
- (IBAction)showMeCtrl:(id)sender;

@end
