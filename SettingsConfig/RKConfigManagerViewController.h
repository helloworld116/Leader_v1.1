//
//  RKConfigManager.h
//  Leader
//
//  Created by leyye on 14-11-4.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"

@interface RKConfigManagerViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource>{
    NSUserDefaults * defaults;
    NSDictionary * dictionary;
    UITableView * mTableView;
    NSMutableArray * settingArray;
    NSMutableArray * devArray;
}
@property (nonatomic, strong) NSMutableArray *sectionSelecteds;

- (void) readConfigPlistFile;

- (void) modifyConfigPlistFile;

@end
