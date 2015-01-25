//
//  RKRootViewController.h
//  Leader
//
//  Created by leyye on 14-11-5.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "RNSwipeViewController.h"
#import "SHViewPager.h"

@class CustomNavigationController;
@class RKMainViewController;
@class RKDomainUserViewController;
@class RKLeyyeServiceViewController;
@class RKLeyyeRewardViewController;
@class RKMoreViewController;

@class RKLeftViewController;
@class RKMainViewController;
@class MMDrawerController;
@class NTSlidingViewController;
@class RKDBHelper;

@interface RKRootViewController : RNSwipeViewController<RNSwipeViewControllerDelegate,SHViewPagerDataSource,SHViewPagerDelegate,UITabBarControllerDelegate>{
    RKDBHelper * dbHelper;
    NSArray * mArrayTitle;
    SHViewPager * pager;
}
@property (nonatomic, strong) NSMutableArray * mutableArrayDomains;
@property (nonatomic, strong) MMDrawerController * drawerController;
@property (nonatomic, strong) UITabBarController * tabBarController;
/*v1.3.0*/
@property (nonatomic, strong) RKLeftViewController * leftSideDrawerViewController;
@property (nonatomic, strong) RKMainViewController * mainViewController;

@property (nonatomic, strong) CustomNavigationController * mainNavigationController;
@property (nonatomic, strong) RKDomainUserViewController * domainViewController;

@property (nonatomic, strong) CustomNavigationController * domainNavigationController;
@property (nonatomic, strong) NTSlidingViewController * slidingNavigationController;

@property (nonatomic, strong) RKLeyyeRewardViewController *rewardViewController;
@property (nonatomic, strong) CustomNavigationController * rewardNavigationController;

@property (nonatomic, strong) RKLeyyeServiceViewController * serviceViewController;
@property (nonatomic, strong) CustomNavigationController * serviceNavigationController;

@property (nonatomic, strong) RKMoreViewController * moreViewController;
@property (nonatomic, strong) CustomNavigationController * moreNavigationController;

+ (void) goToMainViewController;

/*实现底部tabbar*/
- (void) initTabBarController;

- (void) initialize;

- (void) initRNSwipeViewController;
@end
