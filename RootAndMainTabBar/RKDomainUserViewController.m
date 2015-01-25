//
//  RKDomainUserViewController.m
//  Leader
//
//  Created by leyye on 14-11-18.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKDomainUserViewController.h"
#import "CustomViewController.h"
#import "CustomNaviBarView.h"
#import "RKDomainUserCell.h"
#import "RKLeyyeUser.h"
#import "RKDBHelper.h"
#import "RKLeyyeUtilKit.h"
#import "RKFileManager.h"
#import "RKMyViewController.h"

#import "ASIFormDataRequest.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "RKLeyyeUtilKit.h"

@interface RKDomainUserViewController ()

@end

@implementation RKDomainUserViewController

@synthesize m_btnNaviRightSearch = _btnNaviRightSearch;
@synthesize m_ctrlSearchBar = _ctrlSearchBar;
@synthesize m_labelKeyword = _labelKeyword;
@synthesize mTableView = _mTableView;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        defaults = [NSUserDefaults standardUserDefaults];
        cookieValue = [defaults objectForKey:@"app-cookie"];
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void) initialize{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
//    [self setNaviBarTitle:@"作者"];
//    [self setNaviBarLeftBtn:nil];
//    [self setNaviBarRightBtn:nil];
    [self initTableView];
    [self initialize];
}

- (BOOL) prefersStatusBarHidden{
    return YES;
}

- (void) initLeyyeAuthor{
    dbHelper = [[RKDBHelper alloc] init];
    mArrayUser = [dbHelper queryLeyyeUser];
    [mArrayUser enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        RKDomainUserCell * cell = [[RKDomainUserCell alloc] init];
        [mArrayCell addObject:cell];
    }];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - CustomNaviBar UI 可以实现点击搜索功能
- (void)initUI
{
    _btnNaviRightSearch = [CustomNaviBarView createImgNaviBarBtnByImgNormal:@"NaviBtn_Search" imgHighlight:@"NaviBtn_Search_H"  target:self action:@selector(btnSearch:)];
//    [self setNaviBarRightBtn:_btnNaviRightSearch];
}

- (void)btnSearch:(id)sender
{
    if (!_ctrlSearchBar)
    {
//        _ctrlSearchBar = [[CustomNaviBarSearchController alloc] initWithParentViewCtrl:self];
//        _ctrlSearchBar.delegate = self;
    }else{}
    [_ctrlSearchBar showTempSearchCtrl];
}

#pragma mark - CustomNaviBarSearchControllerDelegate
- (void)naviBarSearchCtrl:(CustomNaviBarSearchController *)ctrl searchKeyword:(NSString *)strKeyword
{
    [_ctrlSearchBar removeSearchCtrl];
    if (strKeyword && strKeyword.length > 0)
    {
        _labelKeyword.text = strKeyword;
    }
    else
    {
        _labelKeyword.text = @"";
    }
}

- (void)naviBarSearchCtrlCancel:(CustomNaviBarSearchController *)ctrl
{
    [_ctrlSearchBar removeSearchCtrl];
    _labelKeyword.text = @"";
}
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) getLeyyeUserWithCount:(int)count{
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_AUTHORS]];
    request.tag = 100;
    request.delegate = self;
    [request addPostValue:@"0" forKey:@"circle"];
    [request addPostValue:@"0" forKey:@"sort"];
    [request addPostValue:@"0" forKey:@"offset"];
    if (![RKLeyyeUtilKit isBlankString:cookieValue]) {
        [request addRequestHeader:@"Cookie" value:cookieValue];
    }
    [request addPostValue:[NSString stringWithFormat:@"%i",20 * count] forKey:@"count"];
    [request startSynchronous];
}

- (void) addLeyyeAttention{
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_AUTHORS]];
    request.tag = 200;
    request.delegate = self;
    [request addPostValue:@"0" forKey:@"circle"];
    [request addPostValue:@"0" forKey:@"sort"];
    [request addPostValue:@"0" forKey:@"offset"];
    [request addPostValue:@"20" forKey:@"count"];
    [request startSynchronous];
}

- (void) addLeyyeFriend{
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_APPLY_FRIEND]];
    request.tag = 300;
    request.delegate = self;
    [request addPostValue:@"0" forKey:@"friend"];
    [request addPostValue:@"0" forKey:@"remark"];
    [request addPostValue:@"20" forKey:@"reason"];
    [request startSynchronous];
}

- (void) agreenLeyyeFriend{
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_AGREE_FRIEND]];
    request.tag = 400;
    request.delegate = self;
    [request addPostValue:@"0" forKey:@"friend"];
    [request addPostValue:@"0" forKey:@"remark"];
    [request addPostValue:@"20" forKey:@"reason"];
    [request startSynchronous];
}

- (void) initTableView{
//    _mTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
//    _mTableView.delegate = self;
//    _mTableView.dataSource = self;
    _mTableView.showsVerticalScrollIndicator = NO;
    [_mTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
//    [self.view addSubview:_mTableView];
    
    [self setupRefresh];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //    [_mTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [_mTableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [_mTableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_mTableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    pagerIndex = 1;
    [self getLeyyeUserWithCount:pagerIndex];
}

- (void)footerRereshing
{
    pagerIndex ++;
    [self getLeyyeUserWithCount:pagerIndex];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"setting";
    RKDomainUserCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[RKDomainUserCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.aIndex = indexPath.row + 1;
    RKLeyyeUser * userAuthor = [mArrayUser objectAtIndex:indexPath.row];
    if (userAuthor != nil) {
        cell.userAuthor = userAuthor;
    }
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mArrayUser.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    RKDomainUserCell * cell = [mArrayCell objectAtIndex:indexPath.row];
    if (cell != nil) {
        cell.userAuthor = [mArrayUser objectAtIndex:indexPath.row];
        return cell.height;
    }
    return 155;
}

- (void) attentionLeyyeAuthor{
    debugMethod();
    debugLog(@"我来了");
}

- (void) addLeyyeAuthor{
    debugMethod();
    debugLog(@"我来了");
//    [self showPopupWithStyle:CNPPopupStyleCentered];
//    UIAlertView * alertView = [[UIAlertView alloc] initWithFrame:CGRectMake(20, 300, 260, 300)];
//    [alertView show];
}

#pragma mark - CNPPopupController Delegate
- (void)popupController:(CNPPopupController *)controller didDismissWithButtonTitle:(NSString *)title {
    NSLog(@"Dismissed with button title: %@", title);
}

- (void)popupControllerDidPresent:(CNPPopupController *)controller {
    NSLog(@"Popup controller presented.");
}

- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle {
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"It's A Popup!" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
    NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:@"You can add text and images" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle}];
    UIImage *icon = [UIImage imageNamed:@"icon"];
    //    NSAttributedString *lineTwo = [[NSAttributedString alloc] initWithString:@"With style, using NSAttributedString" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSForegroundColorAttributeName : [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0], NSParagraphStyleAttributeName : paragraphStyle}];
    
    NSAttributedString *buttonTitle = [[NSAttributedString alloc] initWithString:@"申请加为好友" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName : [UIColor whiteColor], NSParagraphStyleAttributeName : paragraphStyle}];
    
    CNPPopupButtonItem *buttonItem = [CNPPopupButtonItem defaultButtonItemWithTitle:buttonTitle backgroundColor:[UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0]];
    buttonItem.selectionHandler = ^(CNPPopupButtonItem *item){
        NSLog(@"Block for button: %@", item.buttonTitle.string);
    };
    
    self.popupController = [[CNPPopupController alloc] initWithTitle:title contents:@[lineOne, icon/*, lineTwo*/] buttonItems:@[buttonItem] destructiveButtonItem:nil];
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = popupStyle;
    self.popupController.delegate = self;
    self.popupController.theme.presentationStyle = CNPPopupPresentationStyleSlideInFromBottom;
    [self.popupController presentPopupControllerAnimated:YES];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RKDomainUserCell * cell = (RKDomainUserCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.btnAttention addTarget:self action:@selector(attentionLeyyeAuthor) forControlEvents:UIControlEventTouchDragInside];
    [cell.btnAddFriend addTarget:self action:@selector(addLeyyeAuthor) forControlEvents:UIControlEventTouchDragInside];
    [self.navigationController pushViewController:[[RKMyViewController alloc] init] animated:YES];
}

- (void) tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    debugMethod();
}
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
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
    if (index == 0 ) {
        switch (request.tag) {
            case 100:{
                mArrayUser = [RKLeyyeUser parserLeyyeAuthorInfo:json[@"data"][@"users"]];
                [mArrayUser enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                    RKDomainUserCell * cell = [[RKDomainUserCell alloc] init];
                    [mArrayCell addObject:cell];
                }];
                [_mTableView headerEndRefreshing];
                [_mTableView footerEndRefreshing];
                [_mTableView reloadData];
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

- (void) requestFailed:(ASIHTTPRequest *)request{
    [SVProgressHUD showErrorWithStatus:@"网络出现异常"];
    [_mTableView headerEndRefreshing];
    [_mTableView footerEndRefreshing];
}
////////////////////////////////////////////////////////////////////////////////////////////////////


@end
