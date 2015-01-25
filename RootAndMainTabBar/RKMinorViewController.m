//
//  RKMinorViewController.m
//  Leader
//
//  Created by leyye on 14-12-6.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKMinorViewController.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@interface RKMinorViewController ()

@end

@implementation RKMinorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initialize{
    mBPHud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:mBPHud];
}

- (void) initTableView{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 90, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:mTableView];
}

- (void) getLeyyyeArticles:(int) circleId{
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_ARTICLES]];
    request.tag = 95;
    request.delegate = self;
    [request addPostValue:[NSString stringWithFormat:@"%i",circleId] forKey:@"circleId"];
    [request addPostValue:@"2" forKey:@"sort"]; // 0 最火，1 最佳，2 最新
    [request addPostValue:@"1" forKey:@"offset"];
    [request addPostValue:@"20" forKey:@"count"];
    [request startAsynchronous];
}

- (void) requestStarted:(ASIHTTPRequest *)request{
    
}

- (void) requestFinished:(ASIHTTPRequest *)request{
    
}

- (void) requestFailed:(ASIHTTPRequest *)request{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (instancetype) initWithView:(UIView *) view viewTitle:(NSString *) title{
    if (self = [super init]) {
        
    }
    return self;
}

@end
