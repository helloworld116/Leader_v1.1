//
//  RKDomainUserViewController.h
//  Leader
//
//  Created by leyye on 14-11-18.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "CustomNaviBarSearchController.h"
#import "RNSwipeViewController.h"
#import "ASIHTTPRequest.h"
#import "CNPPopupController.h"

@class RKDBHelper,RKLeyyeUser;

@interface RKDomainUserViewController : UIViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,ASIHTTPRequestDelegate,CustomNaviBarSearchControllerDelegate,CNPPopupControllerDelegate>{
    NSUserDefaults * defaults;
    NSString * cookieValue;
    UITableView * mTableView;
    BOOL _reloading;
    RKDBHelper * dbHelper;
    
    int pagerIndex;
    NSMutableArray * mArrayUser;
    NSMutableArray * mArrayCell;
    
    NSDictionary * dicTitleAndVC;
    NSArray * arrayTitle;
    NSArray * arrayVC;
}
@property (nonatomic, readonly) UIButton *m_btnNaviRightSearch;
@property (nonatomic, readonly) CustomNaviBarSearchController *m_ctrlSearchBar;
@property (nonatomic, strong) IBOutlet UILabel *m_labelKeyword;

@property (nonatomic, strong) IBOutlet UITableView *mTableView;


@property (nonatomic, strong) CNPPopupController *popupController;

@end
