//
//  RKUserAgreementViewController.m
//  Leader
//
//  Created by leyye on 14-11-15.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKUserAgreementViewController.h"

@interface RKUserAgreementViewController ()

@end

@implementation RKUserAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNaviBarTitle:@"服务条款"];
    
    backView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    backView.scrollEnabled = YES;
    backView.contentSize = self.view.frame.size;
    [self.view addSubview:backView];
    
    NSError * error;
    NSString * path = [[NSBundle mainBundle] pathForResource:@"rule" ofType:@"txt"];
    NSString * introText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error: &error];
    labLeyyeIntro = [[UILabel alloc] initWithFrame:self.view.frame];
    labLeyyeIntro.numberOfLines = 0;
    labLeyyeIntro.font = [UIFont fontWithName:introText size:14.0f];
    labLeyyeIntro.text = introText;
    [backView addSubview:labLeyyeIntro];
}

//- (void) agreement:(NSString *)

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
