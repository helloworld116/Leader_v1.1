//
//  RKForgetPwdViewController.m
//  Leader
//
//  Created by leyye on 14-11-21.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKForgetPwdViewController.h"
#import "RKConstants.h"
#import "SVProgressHUD.h"

@implementation RKForgetPwdViewController



- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        [[UIApplication sharedApplication] keyWindow].rootViewController;
        debugLog(@"RKForgetPwdViewController ===> navigationController:%@",self.navigationController);
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationItem.title = @"忘记密码";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    debugLog(@"RKForgetPwdViewController ===> %@",NSStringFromSelector(_cmd));
    //自动缩放页面，以适应屏幕
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    self.webView.backgroundColor=[UIColor blackColor];
    self.webView.alpha=0.6;
    [self.view addSubview:self.webView];
    [self loadWebPageWithString:kFindPassword];
    
    //    指定进度轮大小
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    //    设置进度轮的中心也可以[self.activityIndicatorView setCenter:CGPointMake(30, 30)];
    [self.activityIndicatorView setCenter:self.view.center];
    //  设置activityIndicatorView风格
    [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.webView addSubview:self.activityIndicatorView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)buttonPressed:(id)sender{
    
}


-(void)loadWebPageWithString:(NSString *) urlStr{
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]]];
}

#pragma mark - UIWebView委托方法，开始加载一个url时候调用此方法
-(void) webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicatorView startAnimating];
}

//UIWebView委托方法，url加载完成的时候调用此方法
-(void) webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicatorView stopAnimating];
}

//加载url出错的时候调用此方法
-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.activityIndicatorView stopAnimating];
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}

@end
