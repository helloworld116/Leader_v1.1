//
//  RKUnknownViewController.m
//  Leader
//
//  Created by leyye on 14-11-7.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKUnknownViewController.h"
#import "RKCommonCell.h"
#import "RKLeyyeDomain.h"
#import "RKDBHelper.h"

#import "UIImageView+WebCache.h"

@interface RKUnknownViewController (){
    NSMutableArray *domainArray;
    
}

@end

@implementation RKUnknownViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self queryDomainFromDatabase];
    [self initTableView];
}

- (void) queryDomainFromDatabase{
    dbHelper = [[RKDBHelper alloc] init];
    mArrayDoamin = [dbHelper queryLeyyeDomain];
}

- (void) initTableView{
    mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 90 , ScreenWidth,ScreenHeight - 90) style:UITableViewStylePlain];
    [mTableView setBackgroundColor:[UIColor whiteColor]];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    [mTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:mTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mArrayDoamin.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"DomainCommon";
    RKCommonCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[RKCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    RKLeyyeDomain * domain = [mArrayDoamin objectAtIndex:indexPath.row];
    if (domain) {
        cell.leyyeDomain = domain;
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    debugMethod();
}

////////////////////////////////////////////////////////////////////////

@end
