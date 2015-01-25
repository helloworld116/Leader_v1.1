//
//  RKUserAccountViewController.m
//  Leader
//
//  Created by leyye on 14-11-17.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKUserAccountViewController.h"
#import "RKConstants.h"
#import "RKLeyyeUser.h"
#import "EGOImageView.h"
#import "ASIFormDataRequest.h"

@interface RKUserAccountViewController ()

@end

@implementation RKUserAccountViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        defaults = [NSUserDefaults standardUserDefaults];
        userNick = [defaults objectForKey:@"nickname"];
        userIcon = [defaults objectForKey:@"usericon"];
        debugLog(@"userIcon:%@",userIcon);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    ivUserBackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 118)];
//    ivUserBackView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"me_bg.png"]];
    ivUserBackView.image = [UIImage imageNamed:@"me_bg.png"];
    [self.view addSubview:ivUserBackView];
    
    ivUserIcon = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 15 - 73, 64 + 10, 73, 73)];
//    imageIcon.imageURL = [NSURL URLWithString:userIcon];
    ivUserIcon.backgroundColor = [UIColor redColor];
    [self.view addSubview:ivUserIcon];
//    [self loadUserIcon];
    
    labLeyyNo = [[UILabel alloc] initWithFrame:CGRectMake(ivUserIcon.center.x - 30, CGRectGetMaxY(ivUserIcon.frame) + 10, 50, 22)];
    labLeyyNo.text = @"10086";
    [self.view addSubview:labLeyyNo];
    
    labUserNick = [[UILabel alloc] initWithFrame:CGRectMake(20, 64 +  10,100, 24)];
    labUserNick.text = userNick;
    [self.view addSubview:labUserNick];
    
    labConinsTag = [[UILabel alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(labUserNick.frame) + 10, 48, 22)];
    labConinsTag.text = @"金钱:";
    [self.view addSubview:labConinsTag];
    
    labCoins = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labConinsTag.frame), CGRectGetMaxY(labUserNick.frame) + 10, 38, 22)];
    labCoins.text = @"292";
    [self.view addSubview:labCoins];
    
    labContributionTag = [[UILabel alloc] initWithFrame:CGRectMake(20,CGRectGetMaxY(labCoins.frame) + 10, 48, 22)];
    labContributionTag.text = @"贡献:";
    [self.view addSubview:labContributionTag];
    
    labContribution = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labContributionTag.frame), CGRectGetMaxY(labCoins.frame) + 10, 38, 22)];
    labContribution.text = @"63";
    [self.view addSubview:labContribution];
    
    ivToolbar = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(ivUserBackView.frame), ScreenWidth, 50)];
    ivToolbar.backgroundColor = [UIColor blueColor];
//    ivUserBackView.backgroundColor = [UIColor colorWithRed:236/255.0f green:236/255.0f blue:236/255.0f alpha:1];
    ivToolbar.userInteractionEnabled = YES;
    [self.view addSubview:ivToolbar];
    
    CGFloat toolBarY = CGRectGetMinY(ivToolbar.frame) + 10;
    
    NSString * wow = @"哇";
//    CGSize wowSize = [wow sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(MAXFLOAT,labWowMsg.frame.size.height)];
    labWowMsg = [[UILabel alloc] initWithFrame:CGRectMake(15, toolBarY,15, 22)];
    labWowMsg.text = wow;
    labWowMsg.userInteractionEnabled = YES;
    UIButton * btnWow = [[UIButton alloc] initWithFrame:CGRectMake(15, toolBarY,15, 22)];
    btnWow.backgroundColor = [UIColor clearColor];
    [btnWow addTarget:self action:@selector(clickWow) forControlEvents:UIControlEventTouchDragInside];
    UIGestureRecognizer * singleClick = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(clickWow)];
    [labWowMsg addGestureRecognizer:singleClick];
    [self.view addSubview:labWowMsg];
    
//    CGSize prestigeSize = [wow sizeWithFont:[UIFont systemFontOfSize:12.0f]];
    labPrestige = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labWowMsg.frame) + 15, toolBarY, 40 ,22)];
    labPrestige.text = @"威望";
    UIGestureRecognizer * singleClickPrestige = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(clickPrestige)];
    [labPrestige addGestureRecognizer:singleClickPrestige];
    [self.view addSubview:labPrestige];
    
    labPlus = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labPrestige.frame) + 15,toolBarY , 20, 22)];
    labPlus.text = @"加";
    UIGestureRecognizer * singleClickPlus = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(clickPlus)];
    [labPlus addGestureRecognizer:singleClickPlus];
    [self.view addSubview:labPlus];
    
    
//    CGSize datumSize = [wow sizeWithFont:[UIFont systemFontOfSize:12.0f]];
    labDatum = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labPlus.frame) + 15, toolBarY, 40, 22)];
    labDatum.text = @"资料";
    UIGestureRecognizer * singleClickDatum = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(clickDatum)];
    [labDatum addGestureRecognizer:singleClickDatum];
    [self.view addSubview:labDatum];
    
}

- (void) loadUserIcon{
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_AUTHOR_DETAIL,userIcon]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    [request addPostValue:@"0" forKey:@"type"];
    [request startAsynchronous];
}

- (void) requestFinished:(ASIHTTPRequest *)request{
    debugLog(@"结果：%@",[request responseString]);
    imageIcon.image = [UIImage imageWithData:[request responseData]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) clickWow{
    debugLog(@"clickWow");
}

- (void) clickPrestige{
    debugLog(@"clickPrestige");
    
}

- (void) clickPlus{
    debugLog(@"clickPlus");
    
}

- (void) clickDatum{
    debugLog(@"clickDatum");
    
}

@end
