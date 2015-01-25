//
//  RKForgetPwdViewController.h
//  Leader
//
//  Created by leyye on 14-11-21.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKForgetPwdViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic,retain) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIButton *button;

@property (strong,nonatomic) UIActivityIndicatorView *activityIndicatorView;

- (IBAction)buttonPressed:(id)sender;

-(void)loadWebPageWithString:(NSString *)urlString;
@end
