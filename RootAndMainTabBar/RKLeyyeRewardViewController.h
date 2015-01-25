//
//  RKLeyyeRewardViewController.h
//  Leader
//
//  Created by leyye on 14-11-18.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "ASIHTTPRequest.h"


@interface RKLeyyeRewardViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>{
    NSUserDefaults * defaults;
    NSString * cookieValue;
    int pagerIndex;
    UITableView * rewardTableView;
    NSMutableArray * mArrayImage;
    NSMutableArray * mArrayActivity;
    NSMutableArray * mArrayAuthor;
    NSMutableArray * mArraySponsors;
    NSMutableArray * mutableArrayDate;
    
}

@property (nonatomic, retain) IBOutlet UITableView * mTableView;

@end
