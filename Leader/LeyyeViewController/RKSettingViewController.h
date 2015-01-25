//
//  RKSettingViewController.h
//  Leader
//
//  Created by leyye on 14-11-15.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKSettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{

    NSMutableArray * settingArray;
    NSMutableArray * leyyeArray;
    NSMutableArray * titleArray;
    NSMutableArray * userControllers;
    NSMutableArray * arrayControllers;
    UIButton * btnLogout;
}

@property (nonatomic, strong) UITableView * settingTableView;

@end
