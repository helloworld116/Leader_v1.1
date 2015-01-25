//
//  RKCommonCell.m
//  Leader
//
//  Created by leyye on 14-11-7.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKCommonCell.h"
#import "RKLeyyeDomain.h"
#import "RKFileManager.h"
#import "RKLeyyeUtilKit.h"

#import "SDWebImageManager.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

@implementation RKCommonCell

@synthesize leyyeDomain = _leyyeDomain;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubview];
    }
    return self;
}

- (void) initSubview{
    ivDomainIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 74, 74)];
    [self.contentView addSubview:ivDomainIcon];
    
    lDomainTitle = [[UILabel alloc] init];
    lDomainTitle.font = [UIFont systemFontOfSize:15.0f];
    [self.contentView addSubview:lDomainTitle];
    
    ivIcon1 = [[UIImageView alloc] init];
    [self.contentView addSubview:ivIcon1];
    
    ivIcon2 = [[UIImageView alloc] initWithFrame:CGRectMake(94, 35, 16, 16)];
    ivIcon2.image = [UIImage imageNamed:@"sign7"];
    [self.contentView addSubview:ivIcon2];
    
    ivIcon3 = [[UIImageView alloc] initWithFrame:CGRectMake(94, 35 + 20, 16, 16)];
    ivIcon3.image = [UIImage imageNamed:@"sign10"];
    [self.contentView addSubview:ivIcon3];
    
    ivIcon4 = [[UIImageView alloc] initWithFrame:CGRectMake(94, 35 + 20 * 2, 16, 16)];
    ivIcon4.image = [UIImage imageNamed:@"sign9"];
    [self.contentView addSubview:ivIcon4];
    
    label1 = [[UILabel alloc] init];
    label1.font = [UIFont systemFontOfSize:12.0f];
//    label1.textColor = [UIColor colorWithRed:253 green:148.0f blue:39.0f alpha:0.0f];
    [self.contentView addSubview:label1];
    
    label2 = [[UILabel alloc] initWithFrame:CGRectMake(94 + 16 + 5, 32, ScreenWidth - 110 -50, 21)];
    label2.font = [UIFont systemFontOfSize:12.0f];
//    label2.textColor = [UIColor colorWithRed:143.0f green:143.0f blue:143.0f alpha:0.5f];
    [self.contentView addSubview:label2];
    
    label3 = [[UILabel alloc] initWithFrame:CGRectMake(94 + 16  + 5, 32 + 20,  ScreenWidth - 110 -50, 21)];
    label3.font = [UIFont systemFontOfSize:12.0f];
//    label2.textColor = [UIColor colorWithRed:143.0f green:143.0f blue:143.0f alpha:0.5f];
    [self.contentView addSubview:label3];
    
    label4 = [[UILabel alloc] initWithFrame:CGRectMake(94 + 16  + 5, 32 + 20 * 2,  ScreenWidth - 110 -50, 21)];
    label4.font = [UIFont systemFontOfSize:12.0f];
//    label4.textColor = [UIColor colorWithRed:143.0f green:143.0f blue:143.0f alpha:0.5f];
    [self.contentView addSubview:label4];
    
    btnFree = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 10 - 45, 38, 45, 25)];
    btnFree.tag = 100;
    [btnFree setImage:[UIImage imageNamed:@"btn_cast"] forState:UIControlStateNormal];
//    [btnFree setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_cast"]]];
    [btnFree setTitle:@"免费" forState:UIControlStateNormal];
    [btnFree addTarget:self action:@selector(addLeyyeDomain) forControlEvents:UIControlEventTouchDragInside];
    [self.contentView addSubview:btnFree];
}

- (void) setLeyyeDomain:(RKLeyyeDomain *)aLeyyeDomain{
    _leyyeDomain = aLeyyeDomain;
    [self setSDWebImage];
    lDomainTitle.text = _leyyeDomain.domainTitle;
    label1.text = [NSString stringWithFormat:@"%i",_leyyeDomain.rank];
    label2.text = [NSString stringWithFormat:@"%i",_leyyeDomain.articleCount];
    label3.text = [NSString stringWithFormat:@"%i",_leyyeDomain.userCount];
    label4.text = [NSString stringWithFormat:@"%i",_leyyeDomain.coins];
    
    [self setSubviewFrame];
}

- (void) setSDWebImage{
//    SDWebImageManager * imageManager = [SDWebImageManager sharedManager];
//    UIImage * cachedImage = [imageManager imageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_IMG_BASE,_leyyeDomain.domainIcon]]];
    [ivDomainIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_IMG_BASE,_leyyeDomain.domainIcon]] placeholderImage:[UIImage imageNamed:@"icon"]];
    
//    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_IMG_BASE,_leyyeDomain.domainIcon]] options:SDWebImageLowPriority progress:^(NSUInteger receivedSize, long long expectedSize) {
//        NSLog(@"%lu %lld",receivedSize,expectedSize);
//    } completed:^(UIImage *aImage, NSError *error, SDImageCacheType cacheType, BOOL finished) {
//        ivDomainIcon.image = aImage;
//        NSLog(@"成功了:%ld",UIImageJPEGRepresentation(aImage, 1).length);
//    }];
//    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_IMG_BASE,_leyyeDomain.domainIcon]] options:SDWebImageDownloaderProgressiveDownload progress:^(NSInteger receivedSize,NSInteger expectedSize) {
//        debugLog(@"%sreceivedSize%li\texpectedSize:%li",__func__,receivedSize,expectedSize);
//    }completed:^(UIImage *aImage, NSData *data, NSError *error, BOOL finished){
//        ivDomainIcon.image = aImage;
//    }];
}

- (void) setIconImage{
    UIImage * netImage = [RKLeyyeUtilKit downloadImage:_leyyeDomain.domainIcon];
    UIImage * localImage = [UIImage imageWithContentsOfFile:[RKFileManager readImageFromFile:_leyyeDomain.domainIcon]];
    if (localImage == nil) {
        if(netImage == nil){
            ivDomainIcon.image = [UIImage imageNamed:@"icon"];
        }else{
            ivDomainIcon.image = netImage;
        }
    }else{
        ivDomainIcon.image = localImage;
    }
}

- (void) setSubviewFrame{
    CGSize  sTitle = [lDomainTitle.text sizeWithFont:lDomainTitle.font constrainedToSize:CGSizeMake(MAXFLOAT, 21)];
    lDomainTitle.frame = CGRectMake(94, 10, sTitle.width, 21);
    
    CGFloat titleMaxX = CGRectGetMaxX(lDomainTitle.frame) + 5;
    ivIcon1.frame = CGRectMake(titleMaxX, 10, 21, 20);
    ivIcon1.image = [UIImage imageNamed:@"domain_lv_bg"];

    label1.frame = CGRectMake(titleMaxX + 7, 8, 10, 20);
}
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
//    UIButton * btn = [touches l]
}

- (void) addLeyyeDomain{
    debugMethod();
}

@end
