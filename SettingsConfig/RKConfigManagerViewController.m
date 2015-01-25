//
//  RKConfigManager.m
//  Leader
//
//  Created by leyye on 14-11-4.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKConfigManagerViewController.h"
#import "RKLoginViewController.h"
#import "RKRegisterViewController.h"

@implementation RKConfigManagerViewController

//- (instancetype) init{
//    self = [super init];
//    if (self) {
//    }
//    return self;
//}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        defaults = [NSUserDefaults standardUserDefaults];
        self.hidesBottomBarWhenPushed = YES;
        self.navigationController.visibleViewController.title = @"配置";
//        UILabel * labFinish = [UILabel alloc] initWithFrame:self.navigationController.navigationItem
        self.navigationController.navigationItem.rightBarButtonItem.title = @"完成";
    }
    return self;
}

- (void) viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNaviBarTitle:@"配置"];
    [self setTableView];
    [self modifyConfigPlistFile];
}

- (void) setTableView{
    settingArray = [[NSMutableArray alloc] initWithObjects:@"登录",@"注册",@"退出", nil];
    devArray = [[NSMutableArray alloc] initWithObjects:@"线上",@"线下", nil];
    
    mTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    [self.view addSubview:mTableView];
    self.sectionSelecteds = [NSMutableArray arrayWithCapacity:0];
}

#pragma mark -
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"setting";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if ([self.sectionSelecteds containsObject:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [devArray objectAtIndex:indexPath.row];
            break;
        case 1:
            cell.textLabel.text = [settingArray objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"测试环境";
            break;
        case 1:
            return @"页面切换";
            break;
        default:
            return @"";
            break;
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return devArray.count;
            break;
        case 1:
            return settingArray.count;
            break;
        default:
            return 1;
            break;
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    // 同一个section只能选中一个
    for (NSIndexPath *ip in self.sectionSelecteds) {
        if (ip.section == indexPath.section) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:ip];
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self.sectionSelecteds removeObject:ip];
            break;
        }
    }
    
    [self.sectionSelecteds addObject:indexPath];
    
    switch (indexPath.section) {
        case 0:{
            
        }
            break;
        case 1:{
            RKLoginViewController * loginVC = [[RKLoginViewController alloc] init];
            RKRegisterViewController * registerVC = [[RKRegisterViewController alloc] init];
            switch (indexPath.row) {
                case 0:{
                    [self.navigationController pushViewController:loginVC animated:YES];
                }break;
                case 1:{
                    [self.navigationController pushViewController:registerVC animated:YES];
                }break;
                case 2:{
//                   abort();
                    exit(0);
                }break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

- (void) readConfigPlistFile{
    NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    BOOL test = [dictionary objectForKey: @"Test"];
    [defaults setBool:test forKey:@"test"];
    [defaults synchronize];
}

- (void) appTestPattern{
    [defaults setBool:YES forKey:@"test"];
    [defaults synchronize];
}

- (void) modifyConfigPlistFile{
    NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
    NSMutableDictionary* dicWrite = [[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath] mutableCopy];
//    NSMutableDictionary* dictKey = [dicWrite objectForKey:@"Test"];
//    [dicWrite setValue:@"YES" forKey:@"Test"];
    [dicWrite setObject:@"YES" forKey:@"Test"];
    [dicWrite writeToFile:plistPath atomically:YES];
}


@end
