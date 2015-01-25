//
//  RKMinorViewController.h
//  Leader
//
//  Created by leyye on 14-12-6.
//  Copyright (c) 2014年 leyye. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "ASIHTTPRequest.h"
@class MBProgressHUD;

@interface RKMinorViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>{
    UITableView * mTableView;
    MBProgressHUD * mBPHud;
}

- (instancetype) initWithView:(UIView *) view viewTitle:(NSString *) title;

@end
