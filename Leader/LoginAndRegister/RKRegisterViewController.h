 //
//  RKRegisterViewController.h
//  Leader
//
//  Created by leyye on 14-11-10.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "ASIHTTPRequest.h"

@class MHTextField;
@class UICustomLineLabel;
@class MBProgressHUD;

@interface RKRegisterViewController : UIViewController<ASIHTTPRequestDelegate,UITextFieldDelegate>{
    UIImageView *ivNickNameBackground; //
    UILabel *lAcount;
    UITextField *tfUserNickName;
    UITextField *tfPassword;
    UITextField *tfAffirmPassword;
    
    NSString * userNickName;
    NSString * password;
    NSString * confirmPwd;
    NSUserDefaults *defaults;
    NSString * leyyeNo;
    BOOL _isTest;
    MBProgressHUD * mBPHud;
    
   
}
@property (nonatomic, assign) BOOL isAgreen;
@property (nonatomic, retain) IBOutlet UIImageView * ivAgreenment;

@property (nonatomic, strong) IBOutlet UITextField * xTFUserNickName;
@property (nonatomic, strong) IBOutlet UITextField * xTFUserPasssword;
@property (nonatomic, strong) IBOutlet UITextField * xTFUserConfirmPwd;
@property (nonatomic, strong) IBOutlet UIButton * btnRegister;
@property (nonatomic, strong) IBOutlet UICustomLineLabel * labLeyyeAgreement;

- (IBAction) nUserRegisterLeyyeNo:(id)sender;
- (IBAction) nReadLeyyeAgreement:(id)sender;
- (IBAction)isLeyyeAgreenment:(id)sender;
@end
