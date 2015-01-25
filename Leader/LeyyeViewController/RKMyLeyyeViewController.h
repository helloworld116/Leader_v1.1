//
//  RKMyLeyyeViewController.h
//  Leader
//
//  Created by leyye on 14-11-7.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RKLeyyeDomain,RKDBHelper;

@interface RKMyLeyyeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UITableView * mTableView;
    NSMutableArray * mArrayDoamin;
    RKDBHelper * dbHelper;
//    RKLeyyeDomain * domain;
    
}
@property (nonatomic,retain) IBOutlet UITableView *myTableView;
@end
