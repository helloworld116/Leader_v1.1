//
//  RKLeyyeAboutViewController.m
//  Leader
//
//  Created by leyye on 14-11-4.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKLeyyeAboutViewController.h"
#import "RKUserAgreementViewController.h"


@interface RKLeyyeAboutViewController ()

@end

@implementation RKLeyyeAboutViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:self];
        self.navigationController.topViewController.title = @"关于我们";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    mTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
//    mTableView.contentSize = CGSizeMake(0, 200);
    mTableView.scrollEnabled = NO;
    mTableView.delegate = self;
    mTableView.dataSource = self;
    [self.view addSubview:mTableView];
    
    tableArray = [[NSMutableArray alloc] initWithObjects:@"用户协议",@"客服电话", nil];
    
    agreementViewController = [[RKUserAgreementViewController alloc] init];
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"about";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [tableArray objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"工作时间：每天9:00-22:00"
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:@"呼叫0755-86966210"
                                                     otherButtonTitles:nil, nil];
    long index = indexPath.row;
    switch (index) {
        case 0:
            [self.navigationController pushViewController:agreementViewController animated:YES];
            break;
        case 1:
            [actionSheet showInView:self.view];
            break;
        default:
            break;
    }
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 ) {
        NSURL *url = [NSURL URLWithString:@"tel://0755-86966210"];
        [[UIApplication sharedApplication] openURL:url];
    }else if(buttonIndex == 1){
        debugLog(@"你是谁呀？");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.view setBackgroundColor:[UIColor redColor]];
    // Dispose of any resources that can be recreated.
}



@end
