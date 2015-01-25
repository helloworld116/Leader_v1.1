//
//  RKLoginAndRegisterViewController.m
//  Leader
//
//  Created by leyye on 14-12-5.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKLoginAndRegisterViewController.h"
#import "RKLoginViewController.h"
#import "RKRegisterViewController.h"
@interface RKLoginAndRegisterViewController ()

@end

@implementation RKLoginAndRegisterViewController

@synthesize pager = _pager;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        menuItems = @[@"登录",@"注册"];
    }
    return self;
}

- (void) initTopNaviBar{
    UINavigationBar * naviBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
    [naviBar setBackgroundImage:[UIImage imageNamed:@"title_bg@2x.png"] forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:naviBar];
    UIButton * btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 54, 5, 54, 35)];
    [btnLogin setTitle:@"登录" forState:UIControlStateNormal];
//    [btnLogin setTitleColor:[UIColor colo] forState:UIControlStateNormal]
    [naviBar addSubview:btnLogin];
    
    UIButton * btnRegister = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2 + 20, 5, 54, 35)];
    [btnRegister setTitle:@"注册" forState:UIControlStateNormal];
    [naviBar addSubview:btnRegister];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
//    [self initialize];
//    [self initTopNaviBar];
    [self initSHViewPager];
    [_pager reloadData];
}

- (BOOL) prefersStatusBarHidden{
    return YES;
}

- (void) initialize{
    contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, ScreenWidth, ScreenHeight)];
    contentScrollView.contentSize = CGSizeMake(ScreenWidth * 2, ScreenHeight);
    contentScrollView.pagingEnabled = YES;
    contentScrollView.scrollEnabled = YES;
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentScrollView.showsVerticalScrollIndicator = NO;
    contentScrollView.delegate = self;
    [self.view addSubview:contentScrollView];
}

- (void) initSHViewPager{
    _pager = [[SHViewPager alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _pager.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg@2x.png"]];
    _pager.delegate = self;
    _pager.dataSource = self;
    [self.view addSubview:_pager];
}

#pragma mark - UIScrollViewDelegate 
- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    debugMethod();
    if (scrollView.contentSize.width > ScreenWidth) {
        RKRegisterViewController  * registerCtrl = [[RKRegisterViewController alloc] init];
        [self addChildViewController:registerCtrl];
    }else{
        RKLoginViewController * loginCtrl = [[RKLoginViewController alloc] init];
        [self addChildViewController:loginCtrl];
    }
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if (menuItems.count)
    {
        [_pager pagerWillLayoutSubviews];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SHViewPagerDataSource stack
- (NSInteger)numberOfPagesInViewPager:(SHViewPager *)viewPager
{
    debugMethod();;
    return 2;
}

- (UIViewController *)containerControllerForViewPager:(SHViewPager *)viewPager
{
    debugMethod();;
    return self;
}

- (UIViewController *)viewPager:(SHViewPager *)viewPager controllerForPageAtIndex:(NSInteger)index
{
    debugMethod();;
    if (index == 0) {
        RKLoginViewController * loginCtrl = [[RKLoginViewController alloc] init];
        return loginCtrl;
    }else {
        RKRegisterViewController  * registerCtrl = [[RKRegisterViewController alloc] init];
        return registerCtrl;
    }
}

- (NSString *)viewPager:(SHViewPager *)viewPager titleForPageMenuAtIndex:(NSInteger)index
{
    debugMethod();;
    return [menuItems objectAtIndex:index];
}

- (SHViewPagerMenuWidthType)menuWidthTypeInViewPager:(SHViewPager *)viewPager
{
    debugMethod();;
    return SHViewPagerMenuWidthTypeDefault;
}

#pragma mark - SHViewPagerDelegate stack
- (void)firstContentPageLoadedForViewPager:(SHViewPager *)viewPager
{
    debugMethod();;
}

- (void)viewPager:(SHViewPager *)viewPager willMoveToPageAtIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex
{
    debugMethod();;
    NSLog(@"content will move to page %ld from page: %ld", toIndex, fromIndex);
    switch (toIndex) {
        case 0:{
            RKLoginViewController * loginCtrl = [[RKLoginViewController alloc] init];
            [loginCtrl.xleyyeNOTF becomeFirstResponder];
        }
            break;
        case 1:{
            RKRegisterViewController * registerCtrl = [[RKRegisterViewController alloc] init];
            [registerCtrl.xTFUserNickName becomeFirstResponder];
        }
            break;
        default:
            break;
    }
}

- (void)viewPager:(SHViewPager *)viewPager didMoveToPageAtIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex
{
    debugMethod();;
    NSLog(@"content moved to page %ld from page: %ld", toIndex, fromIndex);
}

@end
