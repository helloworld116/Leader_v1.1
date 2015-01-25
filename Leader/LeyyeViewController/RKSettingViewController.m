//
//  RKSettingViewController.m
//  Leader
//http://bbs.yusian.com/forum.php?mod=viewthread&tid=1401&highlight=iOS%CA%B5%D5%BD
//  Created by leyye on 14-11-15.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKSettingViewController.h"
#import "RKLeyyeFeedbackViewController.h"
#import "RKLeyyeAboutViewController.h"
#import "RKLoginViewController.h"
#import "RKUserAccountViewController.h"
@interface RKSettingViewController ()

@end

@implementation RKSettingViewController


@synthesize settingTableView = _settingTableView;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:self];
        navigationController.topViewController.title = @"设置";
    }
    return  self;
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.settingTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.settingTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.settingTableView.delegate = self;
    self.settingTableView.dataSource = self;
    [self.view addSubview:self.settingTableView];
    
    btnLogout = [[UIButton alloc] initWithFrame:CGRectMake(10, 300, ScreenWidth - 20, 40)];
    [btnLogout setTitle:@"退出当前帐号" forState:UIControlStateNormal];
    [btnLogout.layer setMasksToBounds:YES];
    [btnLogout.layer setCornerRadius:10.0];
    [btnLogout setBackgroundColor:[UIColor redColor]];
    UIGestureRecognizer * singleClick = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(logout)];
    [btnLogout addGestureRecognizer:singleClick];
    [btnLogout addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchDragInside];
    btnLogout.userInteractionEnabled = YES;
    [self.settingTableView addSubview:btnLogout];
    
    settingArray = [[NSMutableArray alloc] initWithObjects:@"帐号管理",@"扫一扫", nil];
    leyyeArray = [[NSMutableArray alloc] initWithObjects:@"意见反馈",@"关于领域",nil];
    titleArray = [[NSMutableArray alloc] initWithObjects:@"帐号管理",@"扫一扫",@"意见反馈",@"关于领域", nil];
    
    
    RKUserAccountViewController * userAccount = [[RKUserAccountViewController alloc] init];
    
    RKLeyyeAboutViewController * aboutViewController = [[RKLeyyeAboutViewController alloc] init];
    RKLeyyeFeedbackViewController * feedbackViewController = [[RKLeyyeFeedbackViewController alloc] init];
    
    arrayControllers = [[NSMutableArray alloc] initWithObjects:feedbackViewController,aboutViewController, nil];
    userControllers = [[NSMutableArray alloc] initWithObjects:userAccount,feedbackViewController, nil];
}

- (void) logout{
    debugLog(@"＝＝＝ 退出当前帐号 ＝＝＝");
    RKLoginViewController * loginViewController = [[RKLoginViewController alloc] init];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"setting";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [settingArray objectAtIndex:indexPath.row];
            break;
        case 1:
            cell.textLabel.text = [leyyeArray objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return settingArray.count;
    }else if(section == 1){
        return leyyeArray.count;
    }else{
        return 1;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        [self.navigationController pushViewController:[userControllers objectAtIndex:indexPath.row] animated:YES];
    }else if(indexPath.section == 1){
        [self.navigationController pushViewController:[arrayControllers objectAtIndex:indexPath.row] animated:YES];
    }
}

- (void) tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void) performSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController  * controller = segue.destinationViewController;
    NSUInteger index = [self.settingTableView indexPathForSelectedRow].row;
    debugLog(@"titleArray");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
