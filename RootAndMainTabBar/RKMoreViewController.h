//
//  RKMoreViewController.h
//  Leader
//
//  Created by leyye on 14-11-24.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"

@interface RKMoreViewController : CustomViewController<UITableViewDataSource,UITableViewDelegate>{
    UITableView * mTableView;
    NSMutableArray * settingArray;
    UIButton * btnConfig;
}

@end
