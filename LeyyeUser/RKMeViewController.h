//
//  RKMeViewController.h
//  Leader
//
//  Created by leyye on 14-12-12.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"

#import "ASIHTTPRequest.h"
@class EGOImageView;
@class RKLeyyeUser;

@interface RKMeViewController : CustomViewController<ASIHTTPRequestDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSUserDefaults * defaults;
    NSString * cookieValue;
    RKLeyyeUser * curAppUser;
}
@property (nonatomic, retain) IBOutlet UILabel * lAppUserNickName;
@property (nonatomic, retain) IBOutlet UILabel * lAppUserLeyyeName;
@property (nonatomic, retain) IBOutlet UILabel * lAppUserCoin;
@property (nonatomic, retain) IBOutlet UILabel * lAppUserContro;
@property (nonatomic, retain) IBOutlet EGOImageView * ivAppUserIcon;

- (IBAction)selectImage:(id)sender;

@end
