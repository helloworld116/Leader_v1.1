//
//  RKLeyyeAboutViewController.h
//  Leader
//
//  Created by leyye on 14-11-4.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RKUserAgreementViewController;

@interface RKLeyyeAboutViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>{
	UITableView * mTableView;
    NSMutableArray * tableArray;
    RKUserAgreementViewController * agreementViewController;
}

@end
