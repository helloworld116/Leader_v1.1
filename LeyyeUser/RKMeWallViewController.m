//
//  RKMeWallViewController.m
//  Leader
//
//  Created by leyye on 14-12-17.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKMeWallViewController.h"

#import "ASIFormDataRequest.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "RKLeyyeUtilKit.h"
#import "RKLeyyeArticle.h"
#import "RKArticleCell.h"

@interface RKMeWallViewController ()

@end

@implementation RKMeWallViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        defaults = [NSUserDefaults standardUserDefaults];
        cookieValue = [defaults objectForKey:@"app-cookie"];
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
}

- (void) initialize{
    [self initTableView];
    
}

- (void) initTableView{
    [_mTableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [_mTableView headerBeginRefreshing];
    
    // 2.集成刷新控件
    [self setupRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void)headerRereshing
{
    pagerIndex = 1;
    [self getMeWallInfo];
}

- (void)footerRereshing
{
    pagerIndex ++;
//    [self getMeWallInfo:pagerIndex];
}
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
- (void) getMeWallInfo{
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_MY_WALL]];
    request.tag = 88;
    request.delegate = self;
    [request addPostValue:@"0" forKey:@"offset"];
    [request addPostValue:@"20" forKey:@"count"];
    if (![RKLeyyeUtilKit isBlankString:cookieValue]) {
        [request addRequestHeader:@"Cookie" value:cookieValue];
    }
    [request startSynchronous];
}

- (void) requestFailed:(ASIHTTPRequest *)request{
    
}

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
                NSMutableArray * mArrayWall = json[@"data"][@"walls"];
                for (NSMutableDictionary * mDict in mArrayWall) {
                    mArrayArticles = [RKLeyyeArticle parserLeyyeArticle:mDict[@"cotent"]];
                    debugLog(@"mDict:%@",mDict[@"cotent"]);
//                    for (NSDictionary * dict in mDict[@"cotent"]) {
//                        int type = [dict[@"type"]intValue]; // 0=发文，1=赞文，2=评文，3=转文，4=收文
//                        if (type == 0) {
//                            mPublishArticles = [RKLeyyeArticle parserLeyyeArticle:dict[@"content"]];
//                        }else if (type == 1) {
//                            mPraiseArticles = [RKLeyyeArticle parserLeyyeArticle:dict[@"content"]];
//                        }else if(type == 2){
//                            
//                        }
//                    }
                }
                [_mTableView reloadData];
                [_mTableView headerEndRefreshing];
                [_mTableView footerEndRefreshing];
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

- (void) handleMeWall{
    
}

//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mArrayArticles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"article";
    RKArticleCell * articleCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (articleCell == nil) {
        articleCell = [[RKArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    articleCell.index = indexPath.row;
    RKLeyyeArticle * article = [mArrayArticles objectAtIndex:indexPath.row];
    if (article != nil) {
        //        debugLog(@"%sdAuthorIcon:%@",__FUNCTION__,article.dAuthorIcon);
        [articleCell setArticle:article];
    }
    return articleCell;
}

@end
