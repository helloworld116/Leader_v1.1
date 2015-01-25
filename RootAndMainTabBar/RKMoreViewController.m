//
//  RKMoreViewController.m
//  Leader
//
//  Created by leyye on 14-11-24.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKMoreViewController.h"
#import "RKConfigManagerViewController.h"
#import "CustomNavigationController.h"

@interface RKMoreViewController ()

@end

@implementation RKMoreViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setNaviBarTitle:@"更多"];
        [self setNaviBarLeftBtn:nil];
        btnConfig = [[UIButton alloc] init];
        [btnConfig setTitle:@"配置" forState:UIControlStateNormal];
        [btnConfig addTarget:self action:@selector(pushConfigVC) forControlEvents:UIControlEventTouchDragInside];
        [self setNaviBarRightBtn:btnConfig];
    }
    return self;
}

- (void) loadView{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
    [self setTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) setTableView{
    settingArray = [[NSMutableArray alloc] initWithObjects:@"配置", nil];
    
    mTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    [self.view addSubview:mTableView];
}

#pragma mark -
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"setting";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [settingArray objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return settingArray.count;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
        }
            break;
        case 1:{
        }
            break;
        case 2:{
        }
            break;
            
        default:
            break;
    }
}

- (void) pushConfigVC{
    RKConfigManagerViewController * configVC = [[RKConfigManagerViewController alloc] init];
    CustomNavigationController * navigationController = [[CustomNavigationController alloc] initWithRootViewController:configVC];
    configVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    [self presentViewController:navigationController animated:YES completion:nil];
    [self.navigationController pushViewController:configVC animated:YES];
}


@end
