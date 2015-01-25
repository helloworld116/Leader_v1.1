//
//  ViewController.m
//  Leader
//
//  Created by leyye on 14-11-1.
//  Copyright (c) 2014年 leyye. All rights reserved.
#import "RkLoadingViewController.h"
#import "RKConstants.h"
#import "RKMainViewController.h"
#import "RKDomainUserViewController.h"
#import "RKLeyyeRewardViewController.h"
#import "RKLeyyeServiceViewController.h"

#import "NTSlidingViewController.h"
#import "GCDiscreetNotificationView.h"
#import "RKRootViewController.h"
#import "ICETutorialPage.h"
#import "ICETutorialController.h"
#import "RKFileManager.h"
#import "RKDBHelper.h"
#import "RKLoginViewController.h"
#import "RKLoginAndRegisterViewController.h"
#import "CustomNavigationController.h"

@interface RKLoadingViewController ()

@end

@implementation RKLoadingViewController

@synthesize isFirstSetup = _isFirstSetup;
@synthesize isFirstLogin = _isFirstLogin;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        defaults = [NSUserDefaults standardUserDefaults];
        _isFirstLogin = [defaults boolForKey:@"isFirstLogin"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
}

- (BOOL) prefersStatusBarHidden{
    return YES;
}

- (void) initialize{
    if (IOS_VERSION_7_OR_ABOVE) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    UIImageView *loadImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    loadImgView.image = [UIImage imageNamed:kAPPLoadingPic];
    [self.view addSubview:loadImgView];
    // 一个动画过度效果 动画维持1秒 之后进入主视图控制器
    [UIView animateWithDuration:4.0 animations:^{
        loadImgView.alpha = 1.0;
    }completion:^(BOOL finished){
        if (finished) {
            [UIApplication sharedApplication].statusBarHidden = YES;
            [loadImgView removeFromSuperview];
            // 默认进入主页面的时候 当前视图为“主页”
            if (!_isFirstSetup) {
                [self createLeyyeFile];
                [self createLeyyeDB];
            }
            _isFirstSetup = !_isFirstSetup;
            if (_isFirstLogin) {
                RKRootViewController * rootCtrl = [[RKRootViewController alloc] init];
                [self.navigationController pushViewController:rootCtrl animated:YES];
            }else{
                [self jumpToLoginView];
            }
        }
    }];
}

/**
 * 实现底部TabBar效果 
 */
- (void) initUITabBar{
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor yellowColor] forKey:UITextAttributeTextColor];
    self.mainViewController = [[RKMainViewController alloc] init];
    self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
    self.mainNavigationController.visibleViewController.title = @"主城";
    self.mainNavigationController.wantsFullScreenLayout = YES;
    self.mainViewController.navigationController.navigationBar.titleTextAttributes = dict;
    
    self.domainViewController = [[RKDomainUserViewController alloc] init];
    self.domainNavigationController = [[UINavigationController alloc] initWithRootViewController:self.domainViewController];
    self.domainNavigationController.topViewController.title = @"朋友";
    
    self.rewardViewController = [[RKLeyyeRewardViewController alloc] init];
    self.rewardNavigationController = [[UINavigationController alloc] initWithRootViewController:self.rewardViewController];
    self.rewardNavigationController.topViewController.title = @"天马奖";
    
    self.serviceViewController = [[RKLeyyeServiceViewController alloc] init];
    self.serviceNavigationController = [[UINavigationController alloc] initWithRootViewController:self.serviceViewController];
    self.serviceNavigationController.visibleViewController.title = @"领域";
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:self.mainNavigationController,self.domainNavigationController,self.rewardNavigationController,self.serviceNavigationController,nil];
    self.tabBarController.delegate = self;
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:self.tabBarController];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.tabBarController.view];
}

- (void) jumpToLoginView{
//    RKLoginViewController *loginViewController = [[RKLoginViewController alloc] initWithNibName:@"RKLoginViewController" bundle:nil];
    RKLoginAndRegisterViewController * loginAndRegisterCtrl = [[RKLoginAndRegisterViewController alloc] init];
//    RKLoginViewController * loginViewController = [[RKLoginViewController alloc] init];
//    loginViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    CustomNavigationController * navigationController = [[CustomNavigationController alloc] initWithRootViewController:loginAndRegisterCtrl];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 创建数据库
- (void) createLeyyeDB{
    self.dbHelper = [[RKDBHelper alloc] init];
    [self.dbHelper createLeyyeTable];
}

- (void) createLeyyeFile{
    RKFileManager * fileManager = [[RKFileManager alloc] init];
    [fileManager createDirectory:@"leyye"];
    [fileManager createDirectory:@"domain"];
    [fileManager createDirectory:@"me"];
    [fileManager createDirectory:@"pic"];
}

-(void) downloadDataFromNet{
    
}

- (void) nextFlashPager{
    // Init the pages texts, and pictures.
    ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithSubTitle:@"Picture 1"
                                                            description:@"Champs-Elysées by night"
                                                            pictureName:@"com_leaflets00@2x.jpg"];
    ICETutorialPage *layer2 = [[ICETutorialPage alloc] initWithSubTitle:@"Picture 2"
                                                            description:@"The Eiffel Tower with\n cloudy weather"
                                                            pictureName:@"com_leaflets01@2x.jpg"];
    ICETutorialPage *layer3 = [[ICETutorialPage alloc] initWithSubTitle:@"Picture 3"
                                                            description:@"An other famous street of Paris"
                                                            pictureName:@"com_leaflets02@2x.jpg"];
    ICETutorialPage *layer4 = [[ICETutorialPage alloc] initWithSubTitle:@"Picture 4"
                                                            description:@"The Eiffel Tower with a better weather"
                                                            pictureName:@"com_leaflets03@2x.jpg"];
    ICETutorialPage *layer5 = [[ICETutorialPage alloc] initWithSubTitle:@"Picture 5"
                                                            description:@"The Louvre's Museum Pyramide"
                                                            pictureName:@"com_leaflets04@2x.jpg"];
    
    // Set the common style for SubTitles and Description (can be overrided on each page).
    ICETutorialLabelStyle *subStyle = [[ICETutorialLabelStyle alloc] init];
    [subStyle setFont:TUTORIAL_SUB_TITLE_FONT];
    [subStyle setTextColor:TUTORIAL_LABEL_TEXT_COLOR];
    [subStyle setLinesNumber:TUTORIAL_SUB_TITLE_LINES_NUMBER];
    [subStyle setOffset:TUTORIAL_SUB_TITLE_OFFSET];
    
    ICETutorialLabelStyle *descStyle = [[ICETutorialLabelStyle alloc] init];
    [descStyle setFont:TUTORIAL_DESC_FONT];
    [descStyle setTextColor:TUTORIAL_LABEL_TEXT_COLOR];
    [descStyle setLinesNumber:TUTORIAL_DESC_LINES_NUMBER];
    [descStyle setOffset:TUTORIAL_DESC_OFFSET];
    
    // Load into an array.
    NSArray *tutorialLayers = @[layer1,layer2,layer3,layer4,layer5];
    
    // Override point for customization after application launch.
    self.loadingViewController = [[ICETutorialController alloc] initWithNibName:@"ICETutorialController"
                                                                         bundle:nil
                                                                       andPages:tutorialLayers];
    
    // Set the common styles, and start scrolling (auto scroll, and looping enabled by default)
    [self.loadingViewController setCommonPageSubTitleStyle:subStyle];
    [self.loadingViewController setCommonPageDescriptionStyle:descStyle];
    [self.loadingViewController setButton1Block:^(UIButton *button){
//        RKLoginViewController *loginViewController = [[RKLoginViewController alloc] init];
//        [self presentViewController:loginViewController animated:YES completion:nil];
//        [self.navigationController pushViewController:loginViewController animated:YES];
    }];
    
    // Run it.
    [self.loadingViewController startScrolling];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.loadingViewController];
    [navigationController setHidesBottomBarWhenPushed:YES];
    [self.view addSubview:navigationController.view];
}


@end
