//
//  RKWebViewController.h
//  Leader
//
//  Created by leyye on 14-11-4.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKWebViewController : UIViewController<UIWebViewDelegate>{
    UIWebView * leyyeWebView;
}

@property (nonatomic,retain) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIButton *button;

@property (strong,nonatomic) UIActivityIndicatorView *activityIndicatorView;

- (IBAction)buttonPressed:(id)sender;

-(void)loadWebPageWithString:(NSString *)urlString;
@end
