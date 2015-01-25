//
//  RKLeyyeJSONKit.m
//  Leader
//
//  Created by leyye on 14-11-7.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKLeyyeUtilKit.h"
#import "RKFileManager.h"

@implementation RKLeyyeUtilKit


+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+ (UIImage *) downloadImage:(NSString *) aIcon{
    if(aIcon == nil) return nil;
    NSString * fileName = [aIcon lastPathComponent];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_IMG_BASE,aIcon]];
    NSData  * data = [[NSData alloc] initWithContentsOfURL:url];
    [RKFileManager writeToFile:fileName withData:data];
    return [UIImage imageWithData:data];
}

/*
 *
 */
- (CGFloat)calculateTextHeight:(CGFloat)widthInput andFont:(UIFont *) font Content:(NSString *)strContent{
    CGSize constraint = CGSizeMake(widthInput, 20000.0f);
    CGSize size = [strContent sizeWithFont:font constrainedToSize:constraint];
    CGFloat height = MAX(size.height, 44.0f);
    //    debugLog(@"height:%.1f",height);
    return height;
}

-(CGFloat)calculateTextWidth:(NSString *)strContent{
    //    CGSize constraint = CGSizeMake(heightInput, heightInput);
    CGFloat constrainedSize = 26500.0f; //其他大小也行
    CGSize size = [strContent sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(constrainedSize, CGFLOAT_MAX)];
    return size.width;
}



@end
