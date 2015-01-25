//
//  RKLeyyeServiceViewController.h
//  Leader
//
//  Created by leyye on 14-11-18.
//  Copyright (c) 2014年 leyye. All rights reserved.
//
#import "CustomViewController.h"
#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "EGORefreshTableHeaderView.h"

@class MBProgressHUD;
@class RKDBHelper;
@class RKLeyyeClub;


@interface RKLeyyeServiceViewController : CustomViewController<ASIHTTPRequestDelegate,UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,UIAlertViewDelegate>{
    UITableView * mTableView;
    MBProgressHUD * mBPHUD;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    RKDBHelper * dbHelper;
    NSMutableArray * mutableArrayService;
    RKLeyyeClub * club;
    NSMutableArray * mutableArrayClubCell;
    
    NSDictionary * dicTitleAndVC;
    NSArray * arrayTitle;
    NSArray * arrayVC;
}


//@property (nonatomic, strong) UITableView * _tableView;

@end
