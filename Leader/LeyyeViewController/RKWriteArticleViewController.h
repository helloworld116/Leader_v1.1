//
//  RKWriteArticleViewController.h
//  Leader
//
//  Created by leyye on 14-11-14.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "ASIHTTPRequest.h"

@interface RKWriteArticleViewController : CustomViewController<ASIHTTPRequestDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>{
    NSUserDefaults * defaults;
    NSString * cookieValue;
    NSString * articleTitle;
    NSString * articelContent;
    
//    UITextField * tfArticleTitle;
//    UITextView * tfArticleContent;
    UIButton * btnAlbum;
    UIButton * btnPublish;
}
@property (nonatomic, retain) IBOutlet UITextField * tfArticleTitle;
@property (nonatomic, retain) IBOutlet UITextField * tfArticleContent;

@end
