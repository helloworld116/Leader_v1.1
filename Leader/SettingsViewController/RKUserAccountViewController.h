//
//  RKUserAccountViewController.h
//  Leader
//
//  Created by leyye on 14-11-17.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
@class EGOImageView;

@interface RKUserAccountViewController : UIViewController<ASIHTTPRequestDelegate>{
    NSUserDefaults * defaults;
    NSMutableDictionary * userInfo;
    NSString * coins;
    NSString * userNick;
    EGOImageView * imageIcon;
    NSString * userIcon;
    UIImageView * ivUserBackView;
    UIImageView * ivUserIcon;
    UILabel * labUserNick;
    UILabel * labConinsTag; // 金钱
    UILabel * labCoins;
    UILabel * labContributionTag;
    UILabel * labContribution;
    UILabel * labLeyyNo;
    
    
    UIImageView * ivToolbar;
    UILabel * labWowMsg;  // 哇
    UILabel * labPrestige; // 威望
    UILabel * labPlus; // 加
    UILabel * labDatum; // 资料
    
}

@end
