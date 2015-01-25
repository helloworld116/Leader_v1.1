//
//  ViewController.h
//  Leader
//
//  Created by leyye on 14-11-1.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RKMainViewController;
@class RKDomainUserViewController;
@class RKLeyyeServiceViewController;
@class RKLeyyeRewardViewController;
@class ICETutorialController;
@class RKDBHelper;

@interface RKLoadingViewController : UIViewController<UITabBarControllerDelegate>{
    NSUserDefaults * defaults;
}
@property (nonatomic, assign) BOOL isFirstLogin;
@property (nonatomic, assign) BOOL isFirstSetup;
@property (nonatomic, retain) RKDBHelper * dbHelper;

@property (strong, nonatomic) UITabBarController *tabBarController;

@property (nonatomic, strong) RKMainViewController * mainViewController;

@property (nonatomic, strong) UINavigationController * mainNavigationController;

@property (nonatomic, strong) RKDomainUserViewController * domainViewController;

@property (nonatomic, strong) UINavigationController * domainNavigationController;

@property (nonatomic, strong) RKLeyyeRewardViewController *rewardViewController;

@property (nonatomic, strong) UINavigationController * rewardNavigationController;

@property (nonatomic, strong) RKLeyyeServiceViewController * serviceViewController;

@property (nonatomic, strong) UINavigationController * serviceNavigationController;
//
@property (strong, nonatomic) ICETutorialController *loadingViewController;

@end

