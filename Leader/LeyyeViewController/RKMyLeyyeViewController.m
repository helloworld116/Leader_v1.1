//
//  RKMyLeyyeViewController.m
//  Leader
//
//  Created by leyye on 14-11-7.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKMyLeyyeViewController.h"
#import "RKConstants.h"

#import "RKDBHelper.h"
#import "RKLeyyeDomain.h"


@interface RKMyLeyyeViewController ()

@end

@implementation RKMyLeyyeViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self queryDomainFromDatabase];
}

- (void) initTableView{
    mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 90 , ScreenWidth,ScreenHeight) style:UITableViewStylePlain];
    [mTableView setBackgroundColor:[UIColor whiteColor]];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    [mTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:mTableView];
}

- (void) queryDomainFromDatabase{
    dbHelper = [[RKDBHelper alloc] init];
    mArrayDoamin = [dbHelper queryLeyyeDomain];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mArrayDoamin.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Id = @"id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    RKLeyyeDomain * domain = [mArrayDoamin objectAtIndex:indexPath.row];
    cell.textLabel.text = domain.domainTitle;
    return cell;
}

@end
