//
//  RKDomainUserCell.m
//  Leader
//
//  Created by leyye on 14-12-10.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKDomainUserCell.h"
#import "RKLeyyeUser.h"
#import "RKLeyyeUtilKit.h"
#import "RKFileManager.h"

#import "EGOImageView.h"

@implementation RKDomainUserCell

@synthesize userAuthor = _userAuthor;
@synthesize height = _height;
@synthesize aIndex = _aIndex;
@synthesize btnAttention = _btnAttention;
@synthesize btnAddFriend = _btnAddFriend;

- (void)awakeFromNib {
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubview];
    }
    return self;
}

- (void) initSubview{
    ivAuthorIcon = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"default_head"]];
    ivAuthorIcon.layer.masksToBounds = YES;
    ivAuthorIcon.layer.cornerRadius = 5;
    [self.contentView addSubview:ivAuthorIcon];
    
    lAuthorNick = [[UILabel alloc] init];
    lAuthorNick.font = [UIFont systemFontOfSize:20.0f];
    [self.contentView addSubview:lAuthorNick];
    
    authorIndex = [[UILabel alloc] init];
    authorIndex.font = [UIFont systemFontOfSize:12.0f];
//    authorIndex.textColor = [UIColor colorWithRed:132.0f green:132.0f blue:132.0f alpha:1.0f];
    [self.contentView addSubview:authorIndex];
    
    lIntroduction = [[UILabel alloc] init];
    lIntroduction.font = [UIFont systemFontOfSize:12.0f];
    lIntroduction.numberOfLines = 3;
    [self.contentView addSubview:lIntroduction];
    
    ivSign7 = [[UIImageView alloc] init];
    ivSign7.image = [UIImage imageNamed:@"sign7"];
    [self.contentView addSubview:ivSign7];
    lAuthorLevel = [[UILabel alloc] init];
    lAuthorLevel.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:lAuthorLevel];
    
    ivSign8 = [[UIImageView alloc] init];
    ivSign8.image = [UIImage imageNamed:@"sign8"];
    [self.contentView addSubview:ivSign8];
    lAuthorContr = [[UILabel alloc] init];
    lAuthorContr.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:lAuthorContr];
    
    _btnAttention = [[UIButton alloc] init];
    [_btnAttention setTitle:@"加关注" forState:UIControlStateNormal];
    _btnAttention.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    _btnAttention.titleLabel.textColor = [UIColor blueColor];
    [_btnAttention setBackgroundImage:[UIImage imageNamed:@"input_blue"] forState:UIControlStateNormal];
    _btnAttention.tag = 100;
    [self.contentView addSubview:_btnAttention];
    
    _btnAddFriend = [[UIButton alloc] init];
    [_btnAddFriend setTitle:@"加好友" forState:UIControlStateNormal];
    _btnAddFriend.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    _btnAddFriend.titleLabel.textColor = [UIColor redColor];
    [_btnAddFriend setBackgroundImage:[UIImage imageNamed:@"input_red"] forState:UIControlStateNormal];
    [self.contentView addSubview:_btnAddFriend];
}

- (void) setUserAuthor:(RKLeyyeUser *)userAuthor{
    _userAuthor = userAuthor;
    ivAuthorIcon.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_IMG_BASE,_userAuthor.userIcon]];
    lAuthorNick.text = _userAuthor.userNick;
    authorIndex.text = [NSString stringWithFormat:@"%ld",_aIndex];
    lIntroduction.text = _userAuthor.introduction;
    lAuthorLevel.text = [NSString stringWithFormat:@"%i",_userAuthor.rank];
    lAuthorContr.text = [NSString stringWithFormat:@"%i",_userAuthor.contribution];
    [self setSubviewFrame];
}

- (void) setSubviewFrame{
    ivAuthorIcon.frame = CGRectMake(10, 10, 64, 64);
    
    CGFloat nickNameX = CGRectGetMaxX(ivAuthorIcon.frame) + 20;
    CGFloat nickNameW = ScreenWidth - nickNameX - 10;
    lAuthorNick.frame = CGRectMake(nickNameX, 10, nickNameW, 18);
    
    CGSize sIndex = [authorIndex.text sizeWithFont:authorIndex.font constrainedToSize:CGSizeMake(MAXFLOAT, 16)];
    authorIndex.frame = CGRectMake(ScreenWidth - 20 - sIndex.width, 10, sIndex.width, 16);
    
    CGFloat introY = CGRectGetMaxY(lAuthorNick.frame) + 5;
    CGSize introSize = [lIntroduction.text sizeWithFont:lIntroduction.font constrainedToSize:CGSizeMake(nickNameW, 60)];
    lIntroduction.frame = CGRectMake(nickNameX, introY, nickNameW, introSize.height);
    
    CGFloat introMaxY = CGRectGetMaxY(lIntroduction.frame);
    ivSign7.frame = CGRectMake(nickNameX,introMaxY,16,16);
    CGFloat sign7MaxX = CGRectGetMaxX(ivSign7.frame);
    CGSize sLevel = [lAuthorLevel.text sizeWithFont:lAuthorLevel.font constrainedToSize:CGSizeMake(MAXFLOAT, 16)];
    lAuthorLevel.frame = CGRectMake(sign7MaxX + 3, introMaxY, sLevel.width, 16);
    
    CGFloat fContr = CGRectGetMaxX(lAuthorLevel.frame) + 15;
    ivSign8.frame = CGRectMake(fContr,introMaxY,16,16);
    CGFloat sign8MaxX = CGRectGetMaxX(ivSign8.frame);
    CGSize sContr = [lAuthorContr.text sizeWithFont:lAuthorContr.font constrainedToSize:CGSizeMake(MAXFLOAT, 16)];
    lAuthorContr.frame = CGRectMake(sign8MaxX, introMaxY, sContr.width, 16);
    
    BOOL isHeight = CGRectGetMaxY(ivSign7.frame) > CGRectGetMaxY(ivAuthorIcon.frame);
    CGFloat buttonY = 90;
    if (isHeight) {
        buttonY = CGRectGetMaxY(ivSign7.frame) + 5;
    }
    _btnAttention.frame = CGRectMake(nickNameX, buttonY, 67, 27);
    CGFloat btnAddFriendX = CGRectGetMaxX(_btnAttention.frame) + 30;
    _btnAddFriend.frame = CGRectMake(btnAddFriendX, buttonY, 67, 27);
    
    _height = CGRectGetMaxY(_btnAddFriend.frame) + 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



@end
