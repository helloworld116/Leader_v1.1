//
//  RKLeyyeServiceCell.h
//  Leader
//
//  Created by leyye on 14-11-24.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RKLeyyeClub;
@class EGOImageView;


@interface RKLeyyeClubCell : UITableViewCell{
    UIImageView * icon;
    UILabel * labTitle;
    UILabel * labContent;
}

@property (nonatomic, strong) RKLeyyeClub * leyyeClub;
@property (nonatomic, assign) CGFloat height;

@end
