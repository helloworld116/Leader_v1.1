//
//  RKMyWallViewController.m
//  Leader
//
//  Created by leyye on 14-12-17.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKMyWallViewController.h"

@interface RKMyWallViewController ()

@end

@implementation RKMyWallViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        arrayTitles = @[@"未看",@"我的墙",@"已删除"];
    }
    return self;
}
    

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - SHViewPagerDataSource stack
- (NSInteger)numberOfPagesInViewPager:(SHViewPager *)viewPager
{
    return arrayTitles.count;
}

- (UIViewController *)containerControllerForViewPager:(SHViewPager *)viewPager
{
    return self;
}

- (UIViewController *)viewPager:(SHViewPager *)viewPager controllerForPageAtIndex:(NSInteger)index
{
    debugMethod();
//    if (index == 0) {
//        RKLoginViewController * loginCtrl = [[RKLoginViewController alloc] init];
//        return loginCtrl;
//    }else {
//        RKRegisterViewController  * registerCtrl = [[RKRegisterViewController alloc] init];
//        return registerCtrl;
//    }
    return self;
}

- (NSString *)viewPager:(SHViewPager *)viewPager titleForPageMenuAtIndex:(NSInteger)index
{
    debugMethod();
    return [arrayTitles objectAtIndex:index];
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
//    switch (toIndex) {
//        case 0:{
//            RKLoginViewController * loginCtrl = [[RKLoginViewController alloc] init];
//            [loginCtrl.xleyyeNOTF becomeFirstResponder];
//        }
//            break;
//        case 1:{
//            RKRegisterViewController * registerCtrl = [[RKRegisterViewController alloc] init];
//            [registerCtrl.xTFUserNickName becomeFirstResponder];
//        }
//            break;
//        default:
//            break;
//    }
}

- (void)viewPager:(SHViewPager *)viewPager didMoveToPageAtIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex
{
    debugMethod();
    NSLog(@"content moved to page %ld from page: %ld", toIndex, fromIndex);
}


@end
