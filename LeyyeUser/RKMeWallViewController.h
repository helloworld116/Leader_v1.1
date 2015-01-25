//
//  RKMeWallViewController.h
//  Leader
//
//  Created by leyye on 14-12-17.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface RKMeWallViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ASIHTTPRequestDelegate>{
    NSUserDefaults * defaults;
    NSString * cookieValue;
    int pagerIndex;
    NSMutableArray * mArrayArticles;
    NSMutableArray * mPublishArticles;
    NSMutableArray * mPraiseArticles;
}
@property (nonatomic, retain) IBOutlet UITableView * mTableView;

@end
