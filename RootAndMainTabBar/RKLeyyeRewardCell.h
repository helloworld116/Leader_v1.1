//
//  RKLeyyeRewardCell.h
//  Leader
//
//  Created by leyye on 14-11-18.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RKLeyyeActivity;
@class EGOImageView;

@interface RKLeyyeRewardCell : UITableViewCell{
    UIImageView * titleImageView;
//    UILabel * labTitle;
}

@property (nonatomic, retain) EGOImageView * ivAwardIcon;
@property (nonatomic, retain) UILabel * labTitle;
@property (nonatomic, retain) UILabel * labDate;
@property (nonatomic, retain) UIImageView * ivCoinsSmallIcon;
@property (nonatomic, retain) UILabel * labCoins;
@property (nonatomic, retain) UIImageView * ivContributionSmallIcon;
@property (nonatomic, retain) UILabel * labContribution;
@property (nonatomic, retain) UIImageView * iconImageView;
@property (nonatomic, retain) UILabel * labSponsor;
@property (nonatomic, retain) UILabel * labAward;

@property (nonatomic, retain) RKLeyyeActivity * leyyeActivity;
@property (nonatomic, strong) NSString * sponsor;
@property (nonatomic, strong) NSString * prizeAuthor;
@end
