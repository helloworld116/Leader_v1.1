//
//  RKLeyyeFeedbackViewController.m
//  Leader
//
//  Created by leyye on 14-11-15.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKLeyyeFeedbackViewController.h"

@interface RKLeyyeFeedbackViewController ()

@end

@implementation RKLeyyeFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    tfFeedbackContent = [[UITextView alloc] initWithFrame:CGRectMake(0, 74, ScreenWidth, 250)];
//    tfFeedbackContent.borderStyle = UITextBorderStyleBezel;
//    tfFeedbackContent.adjustsFontSizeToFitWidth = YES;
    tfFeedbackContent.selectedRange = NSMakeRange(0, 0);
    [self.view addSubview:tfFeedbackContent];
    
    tfTelephone = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tfFeedbackContent.frame) + 10, ScreenWidth, 50)];
    tfTelephone.placeholder = @"请输入电话号码";
    tfTelephone.borderStyle = UITextBorderStyleLine;
    [self.view addSubview:tfTelephone];
    
    btnSender = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.center.y + 100, ScreenWidth - 20, 40)];
    [btnSender setTitle:@"发送" forState:UIControlStateNormal];
    btnSender.backgroundColor = [UIColor redColor];
    [self.view addSubview:btnSender];
}

#pragma mark - 邮箱反馈
//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:778683464@qq.com"]];

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
