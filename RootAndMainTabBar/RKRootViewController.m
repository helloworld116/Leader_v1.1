//
//  RKRootViewController.m
//  Leader
//
//  Created by leyye on 14-11-5.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKRootViewController.h"
#import "CustomNavigationController.h"
#import "RKMainViewController.h"
#import "RKMinorViewController.h"
#import "RKDomainUserViewController.h"
#import "RKLeyyeRewardViewController.h"
#import "RKLeyyeServiceViewController.h"
#import "RKMoreViewController.h"
//////////////////////////////////////////////////////////////////////////////
#import "RKLeftViewController.h"
#import "RKRightViewController.h"
#import "RKLeyyeAddViewController.h"

#import "RKDomainUserViewController.h"
#import "RKWriteArticleViewController.h"
#import "RKMeWallViewController.h"
//////////////////////////////////////////////////////////////////////////////
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "RKDBHelper.h"
#import "RKLeyyeDomain.h"
@interface RKRootViewController ()

@end

@implementation RKRootViewController

@synthesize mutableArrayDomains = _mutableArrayDomains;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        debugMethod();
        mArrayTitle = @[@"爱家社区",@"主诚"];
    }
    return self;
}

- (void) loadView{
    [super loadView];
    debugMethod();
}

- (void) viewDidAppear:(BOOL)animated{
    debugMethod();
    [super viewDidAppear:animated];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    debugMethod();
    if (mArrayTitle.count){
        [pager pagerWillLayoutSubviews];
    }
}

- (void)viewDidLoad {
    debugMethod();
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor underPageBackgroundColor];
    [self initialize];
}

- (BOOL) prefersStatusBarHidden{
    return YES;
}

- (void) initialize{
    [self initRNSwipeViewController];
}

- (void) initRNSwipeViewController{
    // 通过UIStoryboard配置页面
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"RKRootViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController presentViewController:[storyBoard instantiateViewControllerWithIdentifier:@"RootViewController"] animated:YES completion:nil];
    self.centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"centerViewController"];
    self.leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"];
    self.rightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];//  rightViewController
    
    // 通过代码加载页面
//    self.leftViewController = [[RKLeftViewController alloc] init];
//    self.centerViewController = [[RKMainViewController alloc] initWithNibName:@"RKMainViewController" bundle:nil];
//    RKMainViewController * mainCtrl = [[RKMainViewController alloc] init];
//    pager = [[SHViewPager alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//    pager.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_navi_bg@2x.png"]];
//    pager.delegate = self;
//    pager.dataSource = self;
//    [mainCtrl.view addSubview:pager];
//    self.centerViewController = [[RKMainViewController alloc] init];
//    self.rightViewController = [[RKMeWallViewController alloc] init];
    self.leftVisibleWidth = 320;
    self.rightVisibleWidth = 320;
    self.swipeDelegate = self;
}

- (void) initSHViewPager{
    pager = [[SHViewPager alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    pager.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_navi_bg@2x.png"]];
//    pager.delegate = self;
//    pager.dataSource = self;
    [self.view addSubview:pager];
}

- (void) initTabBarController{
    self.leftSideDrawerViewController = [[RKLeftViewController alloc] init];
    
    self.mainViewController = [[RKMainViewController alloc] init];
    self.mainNavigationController = [[CustomNavigationController alloc] initWithRootViewController:self.mainViewController];
    self.mainNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"主城" image:[UIImage imageNamed:@"domain_list_1@2x.png"] selectedImage:[UIImage imageNamed:@"domain_list_2@2x.png"]];
    self.mainNavigationController.navigationItem.title = @"主城";
    
    self.domainViewController = [[RKDomainUserViewController alloc] init];
    self.domainNavigationController = [[CustomNavigationController alloc] initWithRootViewController:self.domainViewController];
    self.domainNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"朋友" image:[UIImage imageNamed:@"domain_author_1@2x.png"] selectedImage:[UIImage imageNamed:@"domain_author_2@2x.png"]];
    
    self.rewardViewController = [[RKLeyyeRewardViewController alloc] init];
    self.rewardNavigationController = [[CustomNavigationController alloc] initWithRootViewController:self.rewardViewController];
    self.rewardNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"奖励" image:[UIImage imageNamed:@"domain_miss_1@2x.png"] selectedImage:[UIImage imageNamed:@"domain_miss_2@2x.png"]];
    
    self.serviceViewController = [[RKLeyyeServiceViewController alloc] init];
    self.serviceNavigationController = [[CustomNavigationController alloc] initWithRootViewController:self.serviceViewController];
    self.serviceNavigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.serviceNavigationController setToolbarHidden:YES];
    self.serviceNavigationController.navigationBar.topItem.title = @"服务号";
    self.serviceNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"服务号" image:[UIImage imageNamed:@"domain_club_1@2x.png"] selectedImage:[UIImage imageNamed:@"domain_club_2@2x.png"]];
    
    self.moreViewController = [[RKMoreViewController alloc] init];
    self.moreNavigationController = [[CustomNavigationController alloc] initWithRootViewController:self.moreViewController];
    self.moreNavigationController.navigationBar.topItem.title = @"更多";
    self.moreNavigationController.navigationBar.tintColor = [UIColor blackColor];
    self.moreNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"更多" image:[UIImage imageNamed:@"domain_list_1@2x.png"] selectedImage:[UIImage imageNamed:@"domain_list_2@2x.png"]];
    
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.tabBar.selectedImageTintColor = [UIColor orangeColor];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:self.mainNavigationController,self.domainNavigationController,self.rewardNavigationController,self.serviceNavigationController,self.moreNavigationController,nil];
    self.tabBarController.delegate = self;
    
    self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:self.tabBarController leftDrawerViewController:self.leftSideDrawerViewController];
    [self.drawerController setShowsShadow:NO];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:self.drawerController];
}

- (void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    viewController.tabBarController.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"domain_club_2@2x.png"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

+ (void) goToMainViewController{
    UIViewController * leftSideDrawerViewController = [[RKLeftViewController alloc] init];
    
    RKMainViewController * centerViewController = [[RKMainViewController alloc] init];
    
    CustomNavigationController *navigationController = [[CustomNavigationController alloc]initWithRootViewController:centerViewController];
    MMDrawerController *drawerController = [[MMDrawerController alloc]
                             initWithCenterViewController:navigationController
                             leftDrawerViewController:leftSideDrawerViewController];
    [drawerController setShowsShadow:NO];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    // 此处设置左边宽度
    [drawerController.mm_drawerController
     setMaximumLeftDrawerWidth:ScreenWidth
     animated:YES
     completion:^(BOOL finished) {
         debugMethod();
     }];
    // 此处设置禁止右滑
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:drawerController];
}

- (void) initMMMainViewPager{
    [[self class] goToMainViewController];
}

//////////////////////////////////////////////////////////////////////////////
#pragma mark - SHViewPagerDataSource stack
- (NSInteger)numberOfPagesInViewPager:(SHViewPager *)viewPager
{
    debugMethod();
    return mArrayTitle.count;
}

- (UIViewController *)containerControllerForViewPager:(SHViewPager *)viewPager
{
    debugMethod();
    return self;
}

- (UIViewController *)viewPager:(SHViewPager *)viewPager controllerForPageAtIndex:(NSInteger)index
{
    debugLog(@"%sindex:%li",__func__,index);
//    if(index == 0){
//        UIViewController * leftSideDrawerViewController = [[RKLeftViewController alloc] init];
//        return leftSideDrawerViewController;
//    }else if(index == 1){
        RKMainViewController * centerViewController = [[RKMainViewController alloc] init];
        return centerViewController;
//    }else if(index == 2){
//        RKMinorViewController * mainCtrl = [[RKMinorViewController alloc] init];
//        return mainCtrl;
//    }else{
//        return self;
//    }
}

- (NSString *)viewPager:(SHViewPager *)viewPager titleForPageMenuAtIndex:(NSInteger)index
{
    debugLog(@"%sTitle:%@",__func__,[mArrayTitle objectAtIndex:index]);
    return [mArrayTitle objectAtIndex:index];
}

- (SHViewPagerMenuWidthType)menuWidthTypeInViewPager:(SHViewPager *)viewPager
{
    return SHViewPagerMenuWidthTypeDefault;
}

#pragma mark - SHViewPagerDelegate stack
- (void)firstContentPageLoadedForViewPager:(SHViewPager *)viewPager
{
    debugLog(@"%sTitle:%@",__func__,viewPager);
//    [self initMMMainViewPager];
}

- (void)viewPager:(SHViewPager *)viewPager willMoveToPageAtIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex
{
    debugMethod();
}

- (void)viewPager:(SHViewPager *)viewPager didMoveToPageAtIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex
{
    debugMethod();
}

//////////////////////////////////////////////////////////////////////////////
#pragma mark - Swipe delegate
- (void)swipeController:(RNSwipeViewController *)swipeController willShowController:(UIViewController *)controller {
    NSLog(@"will show");
}

- (void)swipeController:(RNSwipeViewController *)swipeController didShowController:(UIViewController *)controller {
    NSLog(@"did show");
}
@end
