//
//  RKLeyyeRewardCell.m
//  Leader
//
//  Created by leyye on 14-11-18.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKLeyyeRewardCell.h"
#import "RKLeyyeActivity.h"
#import "EGOImageView.h"

@implementation RKLeyyeRewardCell

@synthesize leyyeActivity = _leyyeActivity;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubview];
    }
    return self;
}

- (void) initSubview{
    self.ivAwardIcon = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"icon@2x.png"]];
    [self.contentView addSubview:self.ivAwardIcon];
    
    self.labTitle = [[UILabel alloc] init];
    [self.contentView addSubview:self.labTitle];
    
    self.labDate = [[UILabel alloc] init];
    self.labDate.font = [UIFont systemFontOfSize:10.0f];
    [self.contentView addSubview:self.labDate];
    
    self.ivCoinsSmallIcon = [[UIImageView alloc] init];
    [self.contentView addSubview:self.ivCoinsSmallIcon];
    
    self.labCoins = [[UILabel alloc] init];
    self.labCoins.font = [UIFont systemFontOfSize:10.0f];
    self.labCoins.textColor = [UIColor orangeColor];
    [self.contentView addSubview:self.labCoins];
    
    self.ivContributionSmallIcon = [[UIImageView alloc] init];
    [self.contentView addSubview:self.ivContributionSmallIcon];
    
    self.labContribution = [[UILabel alloc] init];
    self.labContribution.font = [UIFont systemFontOfSize:10.0f];
    self.labContribution.textColor = [UIColor orangeColor];
    [self.contentView addSubview:self.labContribution];
    
    self.labSponsor = [[UILabel alloc] init];
    self.labSponsor.numberOfLines = 0;
    self.labSponsor.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:self.labSponsor];
    
    self.labAward = [[UILabel alloc] init];
    self.labAward.font = [UIFont systemFontOfSize:10.0f];
    [self.contentView addSubview:self.labAward];
}

- (void)setSubviewFrame{
    self.ivAwardIcon.frame = CGRectMake(10, 10, 49, 49);
    
    CGFloat titleX = CGRectGetMaxX(self.ivAwardIcon.frame) + 8;
    CGFloat titleY = CGRectGetMaxY(self.labTitle.frame) + 8;
    self.labTitle.frame = CGRectMake(titleX, 10, 100, 24);
    
    CGSize sDate = [_labDate.text sizeWithFont:_labDate.font constrainedToSize:CGSizeMake(MAXFLOAT, 16)];
    self.labDate.frame = CGRectMake(ScreenWidth - sDate.width - 10, 8, sDate.width, 16);
    
    self.ivCoinsSmallIcon.frame = CGRectMake(titleX, titleY, 16, 16);
    self.ivCoinsSmallIcon.image = [UIImage imageNamed:@"sign9.png"];
    
    self.labCoins.frame = CGRectMake(CGRectGetMaxX(self.ivCoinsSmallIcon.frame) + 1, titleY + 2, 10, 10);
    
    self.ivContributionSmallIcon.frame = CGRectMake(CGRectGetMaxX(self.labCoins.frame) + 8, titleY, 16, 16);
    self.ivContributionSmallIcon.image = [UIImage imageNamed:@"sign8.png"];
    
    self.labContribution.frame = CGRectMake(CGRectGetMaxX(self.ivContributionSmallIcon.frame) + 1, titleY + 2, 30, 10);
    
    self.labSponsor.frame = CGRectMake(titleX, 34, ScreenWidth - titleX - 10, 100);
    
    self.labAward .frame = CGRectMake(titleX, 70, ScreenWidth - titleX - 10, 100);
}

- (void)setLeyyeActivity:(RKLeyyeActivity *)leyyeActivity{
    _leyyeActivity = leyyeActivity;
//    self.ivAwardIcon.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_IMG_BASE,_leyyeActivity.activityIcon]];
    
    self.labTitle.text = _leyyeActivity.title;
    self.labDate.text = _leyyeActivity.acDate;
    self.labCoins.text = [NSString stringWithFormat:@"%i",_leyyeActivity.coins];
    self.labContribution.text = [NSString stringWithFormat:@"%i",_leyyeActivity.contribution];
    self.labSponsor.text = _sponsor;
    self.labAward.text = _prizeAuthor;
    [self setSubviewFrame];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
