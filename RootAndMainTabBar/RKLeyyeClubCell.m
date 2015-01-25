//
//  RKLeyyeServiceCell.m
//  Leader
//
//  Created by leyye on 14-11-24.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKLeyyeClubCell.h"
#import "RKLeyyeClub.h"

@implementation RKLeyyeClubCell

@synthesize leyyeClub = _leyyeClub;
@synthesize height = _height;

- (void)awakeFromNib {
    // Initialization code
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubview];
    }
    return self;
}

- (void) initSubview{
    icon = [[UIImageView alloc] init];
    [self.contentView addSubview:icon];
    
    labTitle = [[UILabel alloc] init];
    labTitle.numberOfLines = 0;
    labTitle.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:labTitle];
    
    labContent = [[UILabel alloc] init];
    labContent.numberOfLines = 3;
    labContent.font = [UIFont systemFontOfSize:10.0f];
    [self.contentView addSubview:labContent];
}

- (void) setLeyyeClub:(RKLeyyeClub *) leyyeClub{
    _leyyeClub = leyyeClub;
    icon.image = [self downloadClubIcon:_leyyeClub.icon];
    labTitle.text = _leyyeClub.title;
    labContent.text = _leyyeClub.intro;
    [self setSubviewFrame];
    
}

- (void) setSubviewFrame{
    icon.frame = CGRectMake(10, 10, 45, 45);
    
    CGFloat titleX = CGRectGetMaxX(icon.frame) + 10;
//    CGFloat titleY = CGRectGetMaxY(icon.frame);
    labTitle.frame = CGRectMake(titleX, 10, ScreenWidth - titleX - 10, 20);
    
    CGFloat contentY = CGRectGetMaxY(labTitle.frame) + 5;
    labContent.frame = CGRectMake(titleX, contentY, ScreenWidth - titleX - 10, 50);
    
    _height = CGRectGetMaxY(labContent.frame) + 3;
}

- (UIImage *) downloadClubIcon:(NSString *) aIcon{
//    NSString * fileName = [aIcon lastPathComponent];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_IMG_BASE,aIcon]];
    NSData  * data = [[NSData alloc] initWithContentsOfURL:url];
//    RKFileManager * mFileManager = [[RKFileManager alloc] init];
//    [mFileManager writeToFile:fileName withData:data];
    return [UIImage imageWithData:data];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
