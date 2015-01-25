//
//  RKLeyyeAddViewController.m
//  Leader
//
//  Created by leyye on 14-11-6.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKLeyyeAddViewController.h"
#import "RKConstants.h"
#import "RKUnknownViewController.h"
#import "RKMyLeyyeViewController.h"

@interface RKLeyyeAddViewController ()

@end

@implementation RKLeyyeAddViewController

@synthesize unknownView = _unknownView;
@synthesize myLeyye = _myLeyye;
@synthesize topView;
@synthesize myLeyyeBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviBarTitle:@"加入领域"];
    [self initTopMenu];
    [self initSubview];
//    [self initTableView];
}

- (void) initSubview{
    _unknownView = [[RKUnknownViewController alloc] init];
    _myLeyye = [[RKMyLeyyeViewController alloc] init];
    [self.view addSubview:_unknownView.view];
//    [self.view addSubview:_myLeyye.view];
}

- (void) initTopMenu{
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, ScreenWidth, 45)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"toolbar"]];
    [self.view addSubview:topView];
    
    UIButton * btnMe = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 40 * 2, 3, 40, 21)];
    [btnMe setTitle:@"未知" forState:UIControlStateNormal];
    [topView addSubview:btnMe];
    
    UIButton * btnUnknown = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 40, 3, 40, 21)];
    [btnMe setTitle:@"我的" forState:UIControlStateNormal];
    [topView addSubview:btnUnknown];
}

- (void) initTableView{
    mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 90 , ScreenWidth,ScreenHeight) style:UITableViewStylePlain];
    [mTableView setBackgroundColor:[UIColor whiteColor]];
//    mTableView.delegate = self;
//    mTableView.dataSource = self;
    [mTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:mTableView];
}

- (void) initialize{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

////////////////////////////////////////////////////////////////////////
/*- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}*/
////////////////////////////////////////////////////////////////////////

@end
