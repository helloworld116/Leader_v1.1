//
//  RKLeyyeAddViewController.h
//  Leader
//
//  Created by leyye on 14-11-6.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"

@class RKUnknownViewController,RKMyLeyyeViewController;

@interface RKLeyyeAddViewController : CustomViewController/*<UITableViewDataSource,UITableViewDelegate>*/{
    NSMutableArray * arrayControllers;
    UITableView * mTableView;
    UIView * topView;
}
@property (nonatomic, strong) RKUnknownViewController * unknownView;
@property (nonatomic, strong) RKMyLeyyeViewController * myLeyye;
@property (nonatomic, strong) IBOutlet UITableView * mTableView;
/*放弃使用*/
@property (nonatomic, strong) IBOutlet UIView * topView;
@property (nonatomic, strong) IBOutlet UISegmentedControl * segmentedControl;
@property (nonatomic, strong) IBOutlet UIButton * myLeyyeBtn;
@end
