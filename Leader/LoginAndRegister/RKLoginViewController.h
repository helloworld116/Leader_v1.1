//
//  RKLoginViewController.h
//  Leader
//
//  Created by leyye on 14-11-5.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "ASIHTTPRequest.h"
#import  "MBProgressHUD.h"
#import <TencentOpenAPI/TencentOAuth.h>

@class MHTextField;
@class RKDBHelper;
@class QCCPBKDF2SHA1KeyDerivation,QCCMD5Digest;
@class RKLeyyeUser;
@class RKLeyyeDomain;

@interface RKLoginViewController : UIViewController<UITextFieldDelegate,ASIHTTPRequestDelegate,MBProgressHUDDelegate,TencentSessionDelegate/*,NSCoding*/>{
    NSUserDefaults * defaults;
    NSString * cookieValue;
    RKDBHelper * dbHelper;
    BOOL isTest;
    UIImageView *ivAccount;     //帐号输入框背景
    UILabel *lTipAccount;       //帐号输入框
    MHTextField *tfAccount;     //帐号输入框
    
    UILabel *lTipPassword;      //密码提示标签
    UIImageView *ivPassword;    //密码背景框
    MHTextField *tfPassword;    //密码输入框
    
    UIButton * btnLogin;
    UIButton * btnRegister;
    
    NSString * userName; // 领域号
    NSString * password; // 密码
    NSString * saltpbkdf2;
    NSString * cookie;
    NSData * saltData;
    NSMutableArray *editFieldArray; //存放视图中可编辑的控件
    QCCPBKDF2SHA1KeyDerivation * pbkdf2Sha1Key;
//    QCCMD5Digest * md5Digest;
    NSString * sUserName1; // 保存的领域号
    
    RKLeyyeUser * leyyeUser;
    MBProgressHUD * mBPHud;
    RKLeyyeDomain * leyyeDomainArray;
    TencentOAuth *tencentOAuth;
}
@property (nonatomic, assign) BOOL isFirstLogin;

/*v1.2*/
@property (nonatomic, strong) IBOutlet UIButton * xloginBtn;
@property (nonatomic, retain) IBOutlet UITextField * xleyyeNOTF;
@property (nonatomic, retain) IBOutlet UITextField * xpasswordTF;

@property (nonatomic, retain) IBOutlet UIButton * btnDropLeyyeUserName;

@property (nonatomic, assign) BOOL isSave;
@property (nonatomic, retain) IBOutlet UIButton * btnSavePwd;
@property (nonatomic, retain) IBOutlet UIImageView * ivSavePwd;

@property (nonatomic, strong) NSArray * cookieArray;
@property (nonatomic, strong) NSString * salt;
@property (nonatomic, strong) NSString * code;

/*腾讯QQ*/
@property (nonatomic, retain) UILabel *labelTitle;
@property (nonatomic, retain) UILabel *labelAccessToken;

@property (nonatomic, strong) NSMutableArray * mutableArrayArticle;
@property (nonatomic, strong) NSMutableArray * mutableArrayDomains;

/**
 * 将盐经PBKDF2加密处理返回处理结果
 */
- (NSString *) pbkdf2WithPWd:(NSString *) pwd salt: (NSString *) salt;
- (NSString * ) pwdAndSaltUserPBKDF2;
- (NSString *) md5WithInput: (NSString *) input;
- (NSString *) formatInput;

- (void) handleLeyyeArticle;

@end
