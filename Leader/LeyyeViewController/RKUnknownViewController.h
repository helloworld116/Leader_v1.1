//
//  RKUnknownViewController.h
//  Leader
//
//  Created by leyye on 14-11-7.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RKDBHelper;

@interface RKUnknownViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView * mTableView;
    NSMutableArray * mArrayDoamin;
    RKDBHelper * dbHelper;
}

//@property (nonatomic,retain) IBOutlet UITableView *unKnowTableView;

//@property (nonatomic, strong) NSMutableArray *domains;
@end
