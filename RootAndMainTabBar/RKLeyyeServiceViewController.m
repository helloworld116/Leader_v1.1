//
//  RKLeyyeServiceViewController.m
//  Leader
//
//  Created by leyye on 14-11-18.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKLeyyeServiceViewController.h"
#import "ASIFormDataRequest.h"
#import "RKServiceDetailViewController.h"
#import "RKConfigManagerViewController.h"
#import "NTSlidingViewController.h"
#import "RKMyViewController.h"
#import "RKRegisterViewController.h"
#import "MBProgressHUD.h"
#import "RKDBHelper.h"
#import "RKLeyyeClub.h"
#import "RKLeyyeClubCell.h"

@interface RKLeyyeServiceViewController ()

@end

@implementation RKLeyyeServiceViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}

- (void) queryLeyyeClub{
    dbHelper = [[RKDBHelper alloc] init];
    mutableArrayService = [dbHelper queryLeyyeClubs];
    mutableArrayClubCell = [NSMutableArray array];
    [mutableArrayService enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        RKLeyyeClubCell * cell = [[RKLeyyeClubCell alloc] init];
        [mutableArrayClubCell addObject:cell];
    }];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self queryLeyyeClub];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNaviBarTitle:@"服务"];
    [self setNaviBarLeftBtn:nil];
    
    [self setTableView];
}

- (void) getLeyyeService{
    ASIFormDataRequest * request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_SHOPCART]];
    request.delegate = self;
    request.tag = 100;
    [request addPostValue:@"" forKey:@""];
    [request startAsynchronous];
}

- (void) requestStarted:(ASIHTTPRequest *)request{
    mBPHUD = [[MBProgressHUD alloc] initWithView:self.view];
    mBPHUD.labelText = @"数据加载中...";
    [self.view addSubview:mBPHUD];
    [mBPHUD show:YES];
}

- (void) requestFinished:(ASIHTTPRequest *)request{
    
}

- (void) requestFailed:(ASIHTTPRequest *)request{
    
}

- (void) setTableView{
//    NSString * path = [[NSBundle mainBundle] pathForResource:@"service" ofType:@"json"];
//    NSData * data = [NSData dataWithContentsOfFile:path];
//    NSError * error;
//    id  json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//    NSMutableDictionary * dict = json[@"data"][@"domain"];
//    mutableArrayService = [[NSMutableArray alloc] initWithCapacity:10];
//    arrayContent = [[NSMutableArray alloc] initWithCapacity:10];
//    for (NSDictionary * array in dict) {
//        [arrayService addObject:array[@"title"]];
//        [arrayContent addObject:array[@"content"]];
//    }
    
    mTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    [self.view addSubview:mTableView];
    
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - mTableView.bounds.size.height, self.view.frame.size.width, mTableView.bounds.size.height)];
        view.delegate = self;
        [mTableView addSubview:view];
        _refreshHeaderView = view;
    }
    
    [_refreshHeaderView refreshLastUpdatedDate];
    
}
- (UIImage *) downloadAuthorIcon:(NSString *) icon{
//    NSString * fileName = [icon lastPathComponent];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_IMG_BASE,icon]];
    NSData  * data = [[NSData alloc] initWithContentsOfURL:url];
    return [UIImage imageWithData:data];
}

#pragma mark -
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"setting";
    RKLeyyeClubCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[RKLeyyeClubCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    club = [mutableArrayService objectAtIndex:indexPath.row];
    NSParameterAssert(club != nil);
    cell.leyyeClub = club;
    return cell;
}

- (void) initSystemTableViewCell:(UITableViewCell *) tableViewCell withLeyyeClub:(RKLeyyeClub *) leyyeClub{
    NSString * icon = leyyeClub.icon;
    tableViewCell.imageView.frame = CGRectMake(0, 0, 50, 50);
    if (icon != nil) {
        tableViewCell.imageView.image = [self downloadAuthorIcon:club.icon];
    }else{
        tableViewCell.imageView.image = [UIImage imageNamed:@"default_head.png"];
    }
    tableViewCell.textLabel.numberOfLines = 0;
    tableViewCell.textLabel.text = leyyeClub.title;
    tableViewCell.detailTextLabel.numberOfLines = 5;
    tableViewCell.detailTextLabel.text = leyyeClub.intro;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mutableArrayService.count;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    RKLeyyeClub * leyyeClub = [mutableArrayService objectAtIndex:indexPath.row];
    RKLeyyeClubCell * clubCell = [mutableArrayClubCell objectAtIndex:indexPath.row];
    clubCell.leyyeClub = leyyeClub;
    return clubCell.height;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertView * promt = [[UIAlertView alloc] initWithTitle:@"请选择缴费类型：" message:@"￥1.0(元/天)" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [promt show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        RKServiceDetailViewController * serviceDetailVC = [[RKServiceDetailViewController alloc] init];
        serviceDetailVC.strTitle = @"爱家社区";
        serviceDetailVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:serviceDetailVC animated:YES completion:nil];
//        [self.navigationController pushViewController:serviceDetailVC animated:YES];
    }else{
        NSLog(@"=== 取消 ===");
    }
}

#pragma mark - 查询俱乐部
- (void) queryLeyyeClubs{
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_CLUBS]];
    request.tag = 500;
    request.delegate = self;
    [request addPostValue:@"0" forKey:@"circleId"];
    [request addPostValue:@"2" forKey:@"searchType"];
    [request addPostValue:@"0" forKey:@"offset"];
    [request addPostValue:@"10" forKey:@"count"];
    [request startAsynchronous];
}

#pragma mark - 领域俱乐部信息
- (void) queryLeyyeClubInfo{
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_CLUB_GOODS]];
    //    request.tag = kLeyyeClubs;
    request.delegate = self;
    [request addPostValue:@"1" forKey:@"offset"];
    [request addPostValue:@"10" forKey:@"count"];
    [request startAsynchronous];
}

- (void) reloadTableViewDataSource{
    [self queryLeyyeClubs];
}

#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [self reloadTableViewDataSource];
//    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return [NSDate date]; // should return date data source was last changed
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
