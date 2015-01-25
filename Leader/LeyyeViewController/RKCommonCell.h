//
//  RKCommonCell.h
//  Leader
//
//  Created by leyye on 14-11-7.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@class RKLeyyeDomain;

@interface RKCommonCell : UITableViewCell{
    UIImageView * ivDomainIcon;
    UILabel * lDomainTitle;
    UIImageView * ivIcon1;
    UIImageView * ivIcon2;
    UIImageView * ivIcon3;
    UIImageView * ivIcon4;
    UILabel * label1;
    UILabel * label2;
    UILabel * label3;
    UILabel * label4;
    UIButton * btnFree;
}

@property (nonatomic, retain) RKLeyyeDomain * leyyeDomain;

@end
