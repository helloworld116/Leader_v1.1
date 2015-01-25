//
//  RKCustumeCell.m
//  Leader
//
//  Created by leyye on 14-11-4.
//  Copyright (c) 2014年 leyye. All rights reserved.

#import "RKArticleCell.h"
#import "RKConstants.h"
#import "EGOImageView.h"
#import "UIImageView+WebCache.h"
#import "RKLeyyeArticle.h"
#import "RKFileManager.h"
#import "RKLeyyeUtilKit.h"

#define kTitleFont             [UIFont systemFontOfSize:18.0f]

@implementation RKArticleCell

@synthesize article = _article;
@synthesize index = _index;
@synthesize height = _height;

- (void)awakeFromNib {
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubview];
    }
    return self;
}

- (void) initSubview{
    // 序号
    labArticleNo = [[UILabel alloc] init];
    labArticleNo.font = [UIFont systemFontOfSize:15.0f];
    [self.contentView addSubview:labArticleNo];
    
    // 图像ICon
    ivAuthorIcon = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"icon"]];
    ivAuthorIcon.layer.masksToBounds = YES;
    ivAuthorIcon.layer.cornerRadius = 18;
    [self.contentView addSubview:ivAuthorIcon];
    
    // 标题
    labArticleTitle = [[UILabel alloc] init];
    labArticleTitle.numberOfLines = 0;
    labArticleTitle.font = kTitleFont;
    [self.contentView addSubview:labArticleTitle];
    
    // 作者
    labArticleAuthor = [[UILabel alloc] init];
    labArticleAuthor.font = [UIFont systemFontOfSize:12.0f];
    labArticleAuthor.textColor = [UIColor orangeColor];
    [self.contentView addSubview:labArticleAuthor];
    
    // 栏目
    labArticleDomain = [[UILabel alloc] init];
    labArticleDomain.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:labArticleDomain];
    
    // 内容
    labArticleContent = [[UILabel alloc] init];
    labArticleContent.numberOfLines = 3;
    labArticleContent.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:labArticleContent];
    
    // 贡献图标
    ivVitalityIcon = [[UIImageView alloc] init];
    [self.contentView addSubview:ivVitalityIcon];
    // 贡献值
    labArticleVitality = [[UILabel alloc] init];
    labArticleVitality.font = [UIFont systemFontOfSize:10.0f];
    [self.contentView addSubview:labArticleVitality];
}

- (void) setArticle:(RKLeyyeArticle *) aArticle{
    _article = aArticle;
    ivAuthorIcon.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_IMG_BASE,_article.authorIcon]];
    labArticleNo.text = [NSString stringWithFormat:@"%ld",_index + 1];
    labArticleTitle.text = _article.title;
    labArticleContent.text = _article.content;
    labArticleAuthor.text = _article.authorNick;
    labArticleDomain.text = _article.domain;
    labArticleVitality.text = [NSString stringWithFormat:@"%ld",_article.score];
    [self setSubviewFrame];
}

- (void) setSubviewFrame{
    // 序号
    CGSize lNO = [labArticleNo.text sizeWithFont:labArticleNo.font constrainedToSize:CGSizeMake(MAXFLOAT, 15)];
    labArticleNo.frame = CGRectMake(8, 5, lNO.width, 15);
    
    // 图像ICon
    ivAuthorIcon.frame = CGRectMake(15, 25, 36, 36);
    
    // 标题
    CGFloat titleWidth = ScreenWidth - 15 * 2 - 40;
    CGSize titleSize = [labArticleTitle.text sizeWithFont:labArticleTitle.font constrainedToSize:CGSizeMake(titleWidth, MAXFLOAT)];
    labArticleTitle.frame = CGRectMake(70, 10,titleWidth, titleSize.height);
    
    // 作者
    CGFloat authorY = CGRectGetMaxY(labArticleTitle.frame) + 5;
    CGSize authorSize = [labArticleAuthor.text sizeWithFont:labArticleAuthor.font constrainedToSize:CGSizeMake(MAXFLOAT, 18)lineBreakMode:NSLineBreakByWordWrapping];
    labArticleAuthor.frame = CGRectMake(70, authorY, authorSize.width, authorSize.height);
    
    // 栏目
    CGSize domainSize = [labArticleDomain.text sizeWithFont:labArticleDomain.font constrainedToSize:CGSizeMake(MAXFLOAT, 18)];
    labArticleDomain.textColor = [UIColor orangeColor];
    labArticleDomain.frame = CGRectMake(CGRectGetMaxX(labArticleAuthor.frame) + 10, authorY, domainSize.width, 18);
    
    // 内容
//    CGFloat contentY = CGRectGetMaxY(labArticleDomain.frame);
//    CGSize contentSize = [labArticleContent.text sizeWithFont:labArticleContent.font constrainedToSize:CGSizeMake(titleWidth, MAXFLOAT)];
    labArticleContent.frame = CGRectMake(70, authorY + 18, titleWidth, 50);
    
    // 贡献值
    CGFloat contentMaxY = CGRectGetMaxY(labArticleContent.frame);
    ivVitalityIcon.frame = CGRectMake(70,contentMaxY, 12, 12);
    ivVitalityIcon.image = [UIImage imageNamed:@"sign5.png"];
    
    CGFloat vitalityX = CGRectGetMaxX(ivVitalityIcon.frame) + 3;
//    CGFloat vitalityY = CGRectGetMaxX(ivVitalityIcon.frame)
    CGSize vitalitySize = [labArticleVitality.text sizeWithFont:labArticleVitality.font constrainedToSize:CGSizeMake(MAXFLOAT, 22)];
//    debugLog(@"vitalitySize -> width:%.1f",vitalitySize.width);
    labArticleVitality.frame = CGRectMake(vitalityX + 2, contentMaxY -3, vitalitySize.width, 22);
    
    _height = CGRectGetMaxY(ivVitalityIcon.frame) + 5;
//    debugLog(@"%s -> height:%.1f",__FUNCTION__,_height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [[self delegate] performSelector:@selector(showMenu:)
                          withObject:self afterDelay:0.9f];
    [super setHighlighted:highlighted animated:animated];
    
}

- (void)showMenu:(id)cell {
    if ([cell isHighlighted]) {
        [cell becomeFirstResponder];
        UIMenuController * menu = [UIMenuController sharedMenuController];
//        [menu setTargetRect: [cell frame] inView: [self view]];
        [menu setMenuVisible: YES animated: YES];
    }
}


@end
