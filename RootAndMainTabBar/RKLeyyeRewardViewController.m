//
//  RKLeyyeRewardViewController.m
//  Leader
//
//  Created by leyye on 14-11-18.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKLeyyeRewardViewController.h"
#import "RKLeyyeActivity.h"
#import "RKLeyyeRewardCell.h"
#import "SVProgressHUD.h"
#import "RKLeyyeUtilKit.h"
#import "MJRefresh.h"
#import "ASIFormDataRequest.h"
#import "EGOImageView.h"

@interface RKLeyyeRewardViewController ()

@end

@implementation RKLeyyeRewardViewController

@synthesize mTableView = _mTableView;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        defaults = [NSUserDefaults standardUserDefaults];
        cookieValue = [defaults objectForKey:@"app-cookie"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initialize];
    
//    UIImage * tenmaImage = [UIImage imageNamed:@"icon@2x.png"];
//    UIImage * contentImage = [UIImage imageNamed:@"icon@2x.png"];
//    mutableArrayImage = [[NSMutableArray alloc] initWithObjects:tenmaImage,contentImage, nil];
}

- (BOOL) prefersStatusBarHidden{
    return YES;
}

- (void) initialize{
    [self loadData];
    [self initTableView];
}

- (void) initTableView{
    [self setupRefresh];
}


- (void)getLeyyeActivityWithPager:(int)index{
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_MISSIONS]];
    request.tag = 88;
    request.delegate = self;
    [request addPostValue:@"0" forKey:@"circle"];
    [request addPostValue:@"0" forKey:@"offset"];
    [request addPostValue:[NSString stringWithFormat:@"%i",index * 20] forKey:@"count"];
    if (![RKLeyyeUtilKit isBlankString:cookieValue]) {
        [request addRequestHeader:@"Cookie" value:cookieValue];
    }
    [request startAsynchronous];
}

- (void)getLeyyeActivityDetailWithId:(int)aid{
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_MISSIONS]];
    request.tag = 89;
    request.delegate = self;
    [request addPostValue:[NSString stringWithFormat:@"%i",aid] forKey:@"activityId"];
    if (![RKLeyyeUtilKit isBlankString:cookieValue]) {
        [request addRequestHeader:@"Cookie" value:cookieValue];
    }
    [request startAsynchronous];
}

//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //    [mTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [_mTableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [_mTableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_mTableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing{
    pagerIndex = 1;
    [self getLeyyeActivityWithPager:pagerIndex];
}

- (void)footerRereshing{
    pagerIndex ++;
    [self getLeyyeActivityWithPager:pagerIndex];
}
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
- (void) requestStarted:(ASIHTTPRequest *)request{
    
}

- (void) requestFinished:(ASIHTTPRequest *)request{
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:[[request responseString] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    if ([RKLeyyeUtilKit isBlankString:[json[@"error"] stringValue]]) {
        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
        return;
    }
    int index = [json[@"error"] intValue];
    if (index == 0) {
        switch (request.tag) {
            case 88:{
                mArrayActivity = [RKLeyyeActivity parserLeyyeActivity:json[@"data"][@"activities"]];
                [_mTableView headerEndRefreshing];
                [_mTableView footerEndRefreshing];
                [_mTableView reloadData];
            }
                break;
            case 89:{
                debugLog(@"%sjson:%@",__func__,json);
            }
                break;
            default:
                break;
        }
    }else if (index == 999){
        [SVProgressHUD showErrorWithStatus:@"参数有误"];
        return;
    }else{
        [SVProgressHUD showErrorWithStatus:@"未知错误"];
        return;
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    
}
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
- (void) loadData{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"service" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:path];
    NSError * error;
    id  json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSMutableDictionary * mDict = json[@"data"][@"reward"];
    mArraySponsors = [[NSMutableArray alloc] initWithCapacity:10];
    mArrayAuthor = [[NSMutableArray alloc] initWithCapacity:10];
    for (NSDictionary * dict in mDict) {
        [mArraySponsors addObject:dict[@"sponsors"]];
        [mArrayAuthor addObject:dict[@"author"]];
    }
    mArrayImage = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"cup2"],[UIImage imageNamed:@"cup4"],nil];
}

#pragma mark -
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mArrayActivity.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"identifier";
    RKLeyyeRewardCell * cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    if (cell == nil) {
        cell = [[RKLeyyeRewardCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    RKLeyyeActivity * activity = [mArrayActivity objectAtIndex:indexPath.row];
//    [self getLeyyeActivityDetailWithId:activity.aid];
    if (activity) {
        cell.leyyeActivity = activity;
    }
    cell.sponsor = [mArraySponsors objectAtIndex:indexPath.row];
    cell.prizeAuthor = [mArrayAuthor objectAtIndex:indexPath.row];
    cell.ivAwardIcon.image = [mArrayImage objectAtIndex:indexPath.row];
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, ScreenHeight)];
    view.backgroundColor=[UIColor whiteColor];
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
