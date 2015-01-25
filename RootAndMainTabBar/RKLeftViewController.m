//
//  RKLeftViewController.m
//  Leader
//
//  Created by leyye on 14-11-4.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKLeftViewController.h"
#import "RKConstants.h"
#import "RKLoginViewController.h"
#import <Foundation/Foundation.h>

@interface RKLeftViewController ()

@end

@implementation RKLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    debugLog(@"RKLeftViewController === viewDidLoad");
    // flash 图片
    self.welcomeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.welcomeImageView setImage:[UIImage imageNamed:kAPPLoadingPic]];
    [self.view addSubview:self.welcomeImageView];
    
//    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
//    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
//    [loginBtn.userInteractionEnabled:YES];
//    [loginBtn addTarget:self action:@selector(goLogin:) forControlEvents:UIControlEventTouchDragInside];
//    [self.view.userInteractionEnabled:YES];
//    [self.view addSubview:loginBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) goLogin:(UIButton *) btn{
    debugLog(@"=== goLogin ===");
    RKLoginViewController *loginViewController = [[RKLoginViewController alloc]init];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

-(void)changedPercentReveal:(NSInteger)percent{
    
}

@end
