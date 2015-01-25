//
//  RKNavigationController.m
//  Leader
//
//  Created by leyye on 14-11-5.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKNavigationController.h"
#import "UIViewController+MMDrawerController.m"

@interface RKNavigationController ()

@end

@implementation RKNavigationController

-(UIStatusBarStyle)preferredStatusBarStyle{
    if(self.mm_drawerController.showsStatusBarBackgroundView){
        return UIStatusBarStyleLightContent;
    }
    else {
        return UIStatusBarStyleDefault;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
