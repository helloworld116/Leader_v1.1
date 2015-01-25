//
//  RKDomainUserCell.h
//  Leader
//
//  Created by leyye on 14-12-10.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RKLeyyeUser;
@class EGOImageView;

@interface RKDomainUserCell : UITableViewCell{
    EGOImageView * ivAuthorIcon;
    UILabel * lAuthorNick;
    UILabel * lIntroduction;
    UILabel * authorIndex;
    UIImageView * ivSign7;
    UIImageView * ivSign8;
    UILabel * lAuthorLevel;
    UILabel * lAuthorContr;
//    UIButton * btnAttention;
//    UIButton * btnAddFriend;
}

@property (nonatomic,retain) RKLeyyeUser * userAuthor;
@property (nonatomic ,assign) CGFloat height;
@property (nonatomic, assign) NSInteger  aIndex;

@property (nonatomic, strong) UIButton * btnAttention;
@property (nonatomic, strong) UIButton * btnAddFriend;

@end
