//
//  RKLoginViewController.m
//  Leader
//
//  Created by leyye on 14-11-5.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKLoginViewController.h"
#import "CustomNavigationController.h"
#import "CustomViewController.h"
#import "RKConstants.h"
#import "RKRootViewController.h"
#import "RKRegisterViewController.h"
#import "RKForgetPwdViewController.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
#import "QCCHex.h"
#import "QCCPBKDF2SHA1KeyDerivation.h"
#import "QCCMD5Digest.h"
#import "RKDBHelper.h"
#import "RKLeyyeUtilKit.h"
#import "ASIFormDataRequest.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "RKLeyyeAboutViewController.h"
#import "RKLeyyeUser.h"
#import "RKLeyyeDomain.h"
#import "RKLeyyeArticle.h"
#import "RKLeyyeClub.h"
#import "DOPDropDownMenu.h"
#import "MHTextField.h"

#define STR @"dengyulong.leyye.com"

@interface RKLoginViewController ()

@end

@implementation RKLoginViewController

@synthesize isFirstLogin = _isFirstLogin;
@synthesize mutableArrayDomains = _mutableArrayDomains;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    defaults = [NSUserDefaults standardUserDefaults];
    isTest = [defaults objectForKey:@"isTest"];
    _isFirstLogin = [defaults objectForKey:@"isFirstLogin"];
    sUserName1 = [defaults objectForKey:@"leyye_username1"];
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:YES];
  //    [self setNaviBarLeftBtn:nil];
}

- (void)initDropDownView {
  DOPDropDownMenu *menu =
      [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:40];
  //    menu.dataSource = self;
  //    menu.delegate = self;
  [self.view addSubview:menu];
}

- (void)initNibWithAccount {
  // 背景图
  UIImage *image = [UIImage imageNamed:kImageNameUserInputTop];
  ivAccount = [[UIImageView alloc] initWithImage:image];
  ivAccount.frame = CGRectMake(kAPPMargin, kAPPMargin * 2, image.size.width,
                               image.size.height);
  [self.view addSubview:ivAccount];
  // 标签
  lTipAccount = [[UILabel alloc]
      initWithFrame:CGRectMake(kAPPMargin, kAPPMargin + kNavigationHeight + 20,
                               100, 50)];
  lTipAccount.backgroundColor = [UIColor clearColor];
  lTipAccount.textAlignment = NSTextAlignmentRight;
  lTipAccount.text = NSLocalizedString(kStringUserViewTipAccount, @"Account:");
  [self.view addSubview:lTipAccount];

  tfAccount = [[MHTextField alloc]
      initWithFrame:CGRectMake(lTipAccount.frame.origin.x +
                                   lTipAccount.frame.size.width,
                               lTipAccount.frame.origin.y + 10,
                               ivAccount.frame.size.width -
                                   lTipAccount.frame.size.width -
                                   lTipAccount.frame.origin.x,
                               ivAccount.frame.size.height - 10 - 5)];
  tfAccount.keyboardType = UIKeyboardTypeNumberPad;
  tfAccount.delegate = self;
  tfAccount.placeholder =
      NSLocalizedString(kStringUserViewPlaceholderAccount, @"Mobile Phone");
  tfAccount.autocapitalizationType = UITextAutocapitalizationTypeNone;
  tfAccount.autocorrectionType = UITextAutocorrectionTypeNo;
  [self.view addSubview:tfAccount];
}

- (void)initNibWithPassword {
  // 标签
  lTipPassword = [[UILabel alloc]
      initWithFrame:CGRectMake(lTipAccount.frame.origin.x,
                               lTipAccount.frame.origin.y +
                                   ivAccount.frame.size.height + 50,
                               lTipAccount.frame.size.width,
                               lTipAccount.frame.size.height)];
  lTipPassword.backgroundColor = [UIColor clearColor];
  lTipPassword.textAlignment = NSTextAlignmentRight;
  lTipPassword.text =
      NSLocalizedString(kStringUserViewTipPassword, @"Password:");
  [self.view addSubview:lTipPassword];

  tfPassword = [[MHTextField alloc]
      initWithFrame:CGRectMake(lTipAccount.frame.origin.x +
                                   lTipAccount.frame.size.width,
                               lTipAccount.frame.origin.y + 10,
                               ivAccount.frame.size.width -
                                   lTipAccount.frame.size.width -
                                   lTipAccount.frame.origin.x,
                               ivAccount.frame.size.height - 10 - 5)];
  tfPassword.keyboardType = UIKeyboardTypeNumberPad;
  tfPassword.delegate = self;
  tfPassword.placeholder =
      NSLocalizedString(kStringUserViewPlaceholderAccount, @"Mobile Phone");
  tfPassword.autocapitalizationType = UITextAutocapitalizationTypeNone;
  tfPassword.autocorrectionType = UITextAutocorrectionTypeNo;
  [self.view addSubview:tfPassword];
}

- (void)initNibWithLoginBtn {
  CGFloat btnX = self.view.center.x - 45;
  btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
  btnLogin.frame = CGRectMake(btnX, 3, 30, 40);
  [btnLogin setTitle:@"登录" forState:UIControlStateNormal];
  //    [loginBtn setBackgroundImage:image forState:UIControlStateNormal];
  //    [loginBtn setBackgroundImage:imageSelected
  //    forState:UIControlStateHighlighted];
  [btnLogin addTarget:self
                action:@selector(buttonClicked:)
      forControlEvents:UIControlEventTouchUpInside];
  //    [self.view addSubview:btnLogin];
  [self.view addSubview:btnLogin];
}

- (void)initNibWithRegisterBtn {
  CGFloat btnX = self.view.center.x + 45;
  btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
  btnRegister.frame = CGRectMake(btnX, 3, 30, 40);
  [btnLogin setTitle:@"注册" forState:UIControlStateNormal];
  [self.view addSubview:btnRegister];
}

- (void)initialize {
  mBPHud = [[MBProgressHUD alloc] initWithView:self.view];
  mBPHud.delegate = self;
  [self.view addSubview:mBPHud];
  dbHelper = [[RKDBHelper alloc] init];

  self.xleyyeNOTF.delegate = self;
  self.xpasswordTF.delegate = self;
  [self.xleyyeNOTF becomeFirstResponder];
  self.ivSavePwd.userInteractionEnabled = YES;
  self.xleyyeNOTF.userInteractionEnabled = YES;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self initialize];
  [self initParameters];
}

- (void)initParameters {
  //    isTest = TRUE;
  //    NSMutableArray * array = [dbHelper queryLeyyeUserAndPwd];
  //    leyyeUser = [array lastObject];
  if (![RKLeyyeUtilKit isBlankString:sUserName1]) {
    self.xleyyeNOTF.text = sUserName1;
  }
  if (isTest) {
    userName = @"20117";
    password = @"123456";
    self.xleyyeNOTF.placeholder = userName;
    self.xpasswordTF.placeholder = password;
  } else {
    userName = [self.xleyyeNOTF.text stringByReplacingOccurrencesOfString:@" "
                                                               withString:@""];
    password =
        [self.xpasswordTF.text stringByReplacingOccurrencesOfString:@" "
                                                         withString:@""];
  }
  //    if ([userName length] == 0 || userName == nil || [password length] == 0
  //    || password == nil) {
  //        _xloginBtn.userInteractionEnabled = NO;
  //        _xloginBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage
  //        imageNamed:@"btnNotPress"]];
  //        return;
  //    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
  [textField setBackground:[UIImage imageNamed:@"input_bg_2"]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  [textField setBackground:[UIImage imageNamed:@"input_bg_1"]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField.returnKeyType == UIReturnKeyNext) {
    [self.xpasswordTF becomeFirstResponder];
  } else if (textField.returnKeyType == UIReturnKeyJoin && !isTest) {
    [self.xleyyeNOTF becomeFirstResponder];
    [self initParameters];
    [self checkUserNameWith:userName password:password];
  } else if (isTest) {
    RKRootViewController *rootCtrl = [[RKRootViewController alloc] init];
    [self.navigationController pushViewController:rootCtrl animated:YES];
    [defaults setBool:YES forKey:@"isFirstLogin"];
  }
  return YES;
}

- (void)buttonClicked:(UIButton *)button {
  RKRootViewController *rootVC = [[RKRootViewController alloc] init];
  [self.navigationController pushViewController:rootVC animated:YES];
}

- (void)getBackendSalt {
  //    [ASIHTTPRequest isNetworkReachableViaWWAN];
  ASIFormDataRequest *request =
      [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_SALT]];
  request.delegate = self;
  request.tag = 100;
  if (isTest) {
    [request addPostValue:@"20117" forKey:@"username"];
  } else {
    [request addPostValue:userName forKey:@"username"];
  }
  [request setUseCookiePersistence:YES];
  [request startSynchronous];
}

- (void)queryLoginInfo {
  ASIFormDataRequest *request =
      [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_LOGIN]];
  request.delegate = self;
  request.tag = 200;
  [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
  [request setUseSessionPersistence:YES];
  [request setUseCookiePersistence:YES];
    [request addPostValue:userName forKey:@"username"];
  NSString *arg = [self formatInput];
  debugLog(@"%sarg:%@", __FUNCTION__, arg);
  if (isTest) {
    [request addPostValue:@"123456" forKey:@"password"];
  } else {
    [request addPostValue:arg forKey:@"password"];
  }
  cookieValue = [defaults objectForKey:@"app-cookie"];
  if (![RKLeyyeUtilKit isBlankString:cookieValue]) {
    debugLog(@"cookieValue:%@", cookieValue);
    [request addRequestHeader:@"Cookies" value:cookieValue];
  }
  [request addPostValue:@"10" forKey:@"chennelId"];
  [request addPostValue:@"10" forKey:@"userId"];
  [request startAsynchronous];
}

#pragma mark - 查询领域
- (void)queryLeyyeCircles {
  ASIFormDataRequest *circleRequest =
      [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_DOMAINS]];
  circleRequest.tag = 300;
  circleRequest.delegate = self;
  [circleRequest addPostValue:@"0" forKey:@"offset"];
  [circleRequest addPostValue:@"10" forKey:@"count"];
  [circleRequest startSynchronous];
}

#pragma mark - 查询用户列表
- (void)queryLeyyeUserInfo {
  ASIFormDataRequest *request =
      [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_MY_INFO]];
  request.tag = 600;
  request.delegate = self;
  [request addPostValue:@"0" forKey:@"type"];
  if (![RKLeyyeUtilKit isBlankString:cookieValue]) {
    [request addRequestHeader:@"Cookies" value:cookieValue];
  }
  [request startSynchronous];
}

#pragma mark - 查询作者列表
- (void)queryLeyyeAuthor {
  ASIFormDataRequest *request =
      [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_AUTHORS]];
  request.tag = 800;
  request.delegate = self;
  [request addPostValue:@"0" forKey:@"circle"];
  [request addPostValue:@"0" forKey:@"sort"];
  [request addPostValue:@"0" forKey:@"offset"];
  [request addPostValue:@"20" forKey:@"count"];
  [request startSynchronous];
}

#pragma mark - 查询主城文章列表
- (void)queryLeyyeArticles {
  ASIFormDataRequest *request =
      [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_ARTICLES]];
  request.tag = 400;
  request.delegate = self;
  [request addPostValue:@"0" forKey:@"circleId"];
  [request addPostValue:@"1" forKey:@"sort"]; // 0 最火，1 最佳，2 最新
  [request addPostValue:@"1" forKey:@"offset"];
  [request addPostValue:@"20" forKey:@"count"];
  [request startSynchronous];
}

#pragma mark - 查询领域活动
- (void)queryLeyyeActivity {
  ASIFormDataRequest *request =
      [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_MISSIONS]];
  request.tag = 700;
  request.delegate = self;
  [request addPostValue:@"0" forKey:@"circle"];
  [request addPostValue:@"1" forKey:@"offset"];
  [request addPostValue:@"20" forKey:@"count"];
  [request startSynchronous];
}

#pragma mark - 查询俱乐部
- (void)queryLeyyeClubs {
  ASIFormDataRequest *request =
      [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_CLUBS]];
  request.tag = 500;
  request.delegate = self;
  [request addPostValue:@"0" forKey:@"circleId"];
  [request addPostValue:@"2" forKey:@"searchType"];
  [request addPostValue:@"0" forKey:@"offset"];
  [request addPostValue:@"20" forKey:@"count"];
  [request startSynchronous];
}

- (IBAction)goToLeyyeMainView:(id)sender {
  [RKRootViewController goToMainViewController];
}

- (void)requestStarted:(ASIHTTPRequest *)request {
  [self.xleyyeNOTF resignFirstResponder];
  [self.xpasswordTF resignFirstResponder];
  mBPHud.labelText = @"数据加载中...";
  [mBPHud show:YES];
}

- (void)responseDidReceived:(APIResponse *)response
                 forMessage:(NSString *)message {
}

- (void)requestFinished:(ASIHTTPRequest *)request {
  NSError *error;
  id json = [NSJSONSerialization
      JSONObjectWithData:[[request responseString]
                             dataUsingEncoding:NSUTF8StringEncoding]
                 options:NSJSONReadingAllowFragments
                   error:&error];
  if ([RKLeyyeUtilKit isBlankString:[json[@"error"] stringValue]]) {
    [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
    [mBPHud hide:YES];
    return;
  }
  int index = [json[@"error"] intValue];
  debugLog(@"%srequestFinished:request:index:%i", __func__, index);
  // 返回结果数据分析
  if (index == 0) {
    switch (request.tag) {
      // 加盐
      case 100: {
        self.salt = json[@"data"][@"salt"];
        self.code = json[@"data"][@"code"];
        NSString *firstCookie =
            [[request responseHeaders] objectForKey:@"Set-Cookie"];
        debugLog(@"%ssalt:%@\ncode:%@\tfirstCookie:%@", __FUNCTION__, self.salt,
                 self.code, firstCookie);
        [self queryLoginInfo];
      } break;
      // 登录
      case 200: {
        [RKLeyyeUser parserLoginInfo:json[@"data"]];
        [self handleLoginInfo];
        [defaults setBool:YES forKey:@"isFirstLogin"];
        cookie = [[request responseHeaders] objectForKey:@"Set-Cookie"];
        [defaults setObject:cookie forKey:@"app-cookie"];
        [defaults setObject:userName forKey:@"leyye_username1"];
        debugLog(@"%s登录数据：%@\tcookie:%@", __func__, json[@"data"], cookie);
        [mBPHud hide:YES];
      } break;
      case 300: {
        debugLog(@"领域数据：%@", [request responseString]);
        _mutableArrayDomains =
            [RKLeyyeDomain parserDomain:[request responseString]];
      } break;
      case 400: {
        debugLog(@"主城文章数据：%@", [request responseString]);
        [RKLeyyeArticle parserLeyyeArticle:json[@"data"][@"articles"]];
      } break;
      case 500: {
        debugLog(@"俱乐部数据：%@", [request responseString]);
        [RKLeyyeClub parserLeyyeClubs:json[@"data"][@"clubs"]];
      } break;
      case 600: {
        debugLog(@"作者用户数据：%@", [request responseString]);
        [RKLeyyeUser parserAndSaveUserAppLogin:json[@"data"]];
      } break;
      case 700: {
        debugLog(@"活动列表数据：%@", [request responseString]);
      } break;
      case 800: {
        debugLog(@"主城作者列表数据：%@", [request responseString]);
        [RKLeyyeUser parserLeyyeAuthorInfo:json[@"data"][@"users"]];
      } break;
      default:
        debugLog(@"默认返回的数据：%@", [request responseString]);
        break;
    }
  } else if (index == 999) {
    [SVProgressHUD showErrorWithStatus:@"参数有误"];
    [mBPHud hide:YES];
    return;
  } else {
    [SVProgressHUD showErrorWithStatus:@"未知错误"];
    [mBPHud hide:YES];
    return;
  }
}

- (void)handleLoginInfo {
  if (!_isFirstLogin) {
    [self queryLeyyeUserInfo];
    //        [self queryLeyyeAuthor];
    [self queryLeyyeCircles];
    [self queryLeyyeClubs];
    [self queryLeyyeActivity];
    [self queryLeyyeArticles];
    RKRootViewController *rootCtrl = [[RKRootViewController alloc] init];
    rootCtrl.mutableArrayDomains = _mutableArrayDomains;
    [self.navigationController pushViewController:rootCtrl animated:YES];
    //        [[NSNotificationCenter defaultCenter] addObserver:self
    //        selector:@selector(toLoginCtl) name:@"nil" object:nil];
  } else {
    RKRootViewController *rootCtrl = [[RKRootViewController alloc] init];
    rootCtrl.mutableArrayDomains = _mutableArrayDomains;
    [self.navigationController pushViewController:rootCtrl animated:YES];
    [mBPHud hide:YES];
  }
  _isFirstLogin = !_isFirstLogin;
}

/**
 *无网络状态时code:1
 */
- (void)requestFailed:(ASIHTTPRequest *)request {
  NSInteger code = request.error.code;
  debugLog(@"%scode:%liresponse:%@", __func__, code, [request responseString]);
  switch (request.tag) {
    case 100: {
      if (code == 1) {
        [SVProgressHUD showErrorWithStatus:@"亲，手机无网络"];
      } else if (code == 2) {
        [SVProgressHUD showErrorWithStatus:@"亲，领域帐号不存在,"
                                           @"请先注册"];
        [mBPHud hide:YES];
      }
    } break;
    case 200: {
      [SVProgressHUD showErrorWithStatus:@"登录出错"];
    } break;
    default:
      [SVProgressHUD showErrorWithStatus:@"网络出现异常"];
      break;
  }
  [mBPHud hide:YES];
}

- (NSString *)pbkdf2WithPWd:(NSString *)pwd salt:(NSString *)salt {
  NSParameterAssert(pwd != nil);
  NSParameterAssert(salt != nil);
  saltData = [QCCHex dataWithHexString:salt];
  pbkdf2Sha1Key =
      [[QCCPBKDF2SHA1KeyDerivation alloc] initWithPasswordString:password
                                                        saltData:saltData];
  pbkdf2Sha1Key.derivedKeyLength = 24;
  pbkdf2Sha1Key.rounds = 1000;
  [pbkdf2Sha1Key main];
  NSString *result = [QCCHex hexStringWithData:pbkdf2Sha1Key.derivedKeyData];
  return result;
}

- (NSString *)pwdAndSaltUserPBKDF2 {
  return [self pbkdf2WithPWd:password salt:self.salt];
}

- (NSString *)md5WithInput:(NSString *)input {
  NSParameterAssert(input != nil);
  QCCMD5Digest *md5Digest = [[QCCMD5Digest alloc]
      initWithInputData:[input dataUsingEncoding:NSUTF8StringEncoding]];
  [md5Digest main];
  return [QCCHex hexStringWithData:md5Digest.outputDigest];
}

- (NSString *)formatInput {
    self.salt=@"4c84b222c519da527aec844d8f8f6b6a3e3533fbb8a4df49";
    self.code=@"5900919acdb389f0225e5b8e5685d0be0d9fe33b9e85d2f0";
    password = @"123456";
    userName = @"10086";
  QCCMD5Digest *codeMd5Digest = [[QCCMD5Digest alloc]
      initWithInputData:[self.code dataUsingEncoding:NSUTF8StringEncoding]];
  [codeMd5Digest main];
  NSString *codeMD5 = [QCCHex hexStringWithData:codeMd5Digest.outputDigest];
  //    NSString * codeMD5 =[self md5WithInput:self.code];
  debugLog(@"code:%@\ncodeMD5:\n%@", self.code, codeMD5);

  QCCMD5Digest *userNameMd5Digest = [[QCCMD5Digest alloc]
      initWithInputData:[userName dataUsingEncoding:NSUTF8StringEncoding]];
  [userNameMd5Digest main];
  NSString *userNameMD5 =
      [QCCHex hexStringWithData:userNameMd5Digest.outputDigest];
  //    NSString * userNameMD5 = [self md5WithInput:userName];
  debugLog(@"userName:%@\nuserNameMD5:%@", userName, userNameMD5);

  QCCMD5Digest *strMd5Digest = [[QCCMD5Digest alloc]
      initWithInputData:[STR dataUsingEncoding:NSUTF8StringEncoding]];
  [strMd5Digest main];
  NSString *strMD5 = [QCCHex hexStringWithData:strMd5Digest.outputDigest];
  //    NSString * strMD5 = [self md5WithInput:STR];
  debugLog(@"STR:%@\nSTRMD5:%@", STR, strMD5);

  NSString *pwdAndSalt = [self pwdAndSaltUserPBKDF2];

  QCCMD5Digest *synthesisMd5Digest = [[QCCMD5Digest alloc]
      initWithInputData:[[NSString stringWithFormat:@"%@%@%@", codeMD5,
                                                    userNameMD5, strMD5]
                            dataUsingEncoding:NSUTF8StringEncoding]];
  [synthesisMd5Digest main];
  NSString *synthesis =
      [QCCHex hexStringWithData:synthesisMd5Digest.outputDigest];
  //    NSString * synthesis = [self md5WithInput:[NSString
  //    stringWithFormat:@"%@%@%@",codeMD5,userNameMD5,strMD5]];
  NSLog(@"synthesis:%@", synthesis);
  return [NSString stringWithFormat:@"%@%@", synthesis, pwdAndSalt];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)checkUserNameWith:(NSString *)mUserName password:(NSString *)mPwd {
  if ([mUserName length] == 0 || mUserName == nil) {
    [SVProgressHUD showErrorWithStatus:@"用户名不能为空"];
    return;
  }
  if ([mPwd length] == 0 || mPwd == nil) {
    [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
    return;
  }
  [self getBackendSalt];
}

#pragma mark - xib文件方法
- (IBAction)nUserlogin:(id)sender {
  [self initParameters];
  if (isTest) {
    RKRootViewController *rootCtrl = [[RKRootViewController alloc] init];
    [self.navigationController pushViewController:rootCtrl animated:YES];
  } else {
    [self checkUserNameWith:userName password:password];
  }
}

- (IBAction)isSavePwd:(id)sender {
  if (_isSave) {
    [_ivSavePwd setImage:[UIImage imageNamed:@"check1"]];
  } else {
    [_ivSavePwd setImage:[UIImage imageNamed:@"check2"]];
  }
  _isSave = !_isSave;
}

- (IBAction)nUserForgetPassword:(id)sender {
  [self forgetPassword];
}

- (IBAction)dropLeyyeUserName:(id)sender {
  [_btnDropLeyyeUserName setImage:[UIImage imageNamed:@"input_drop"]
                         forState:UIControlStateSelected];
}

- (void)changeRegisterView {
  RKRegisterViewController *registerViewController =
      [[RKRegisterViewController alloc] init];
  registerViewController.modalPresentationStyle = UIModalPresentationPageSheet;
  //    UINavigationController *navigationController = [[UINavigationController
  //    alloc] initWithRootViewController:registerViewController];
  [(CustomNavigationController *)self.navigationController
      pushViewController:registerViewController
                animated:YES];
}

- (void)forgetPassword {
  RKForgetPwdViewController *forgetPwdVC =
      [[RKForgetPwdViewController alloc] init];
  //    UINavigationController * navigationController = [[UINavigationController
  //    alloc] initWithRootViewController:forgetPwdVC];
  //    [self presentViewController:navigationController animated:YES
  //    completion:nil];
  [self.navigationController pushViewController:forgetPwdVC animated:YES];
}

- (IBAction)aboutLeyye:(id)sender {
  RKLeyyeAboutViewController *aboutViewController =
      [[RKLeyyeAboutViewController alloc] init];
  [self.navigationController pushViewController:aboutViewController
                                       animated:YES];
}

- (IBAction)leyyeTencentDidLogin:(id)sender {
  [self initTencentLogin];
}

#pragma mark - 腾讯授权登录
- (void)initTencentLogin {
  tencentOAuth =
      [[TencentOAuth alloc] initWithAppId:@"1103462475" andDelegate:self];
  tencentOAuth.redirectURI = kOfficialWebsite;
  NSArray *permissions = [NSArray
      arrayWithObjects:
          kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
          kOPEN_PERMISSION_ADD_ALBUM, kOPEN_PERMISSION_ADD_IDOL,
          kOPEN_PERMISSION_ADD_ONE_BLOG, kOPEN_PERMISSION_ADD_PIC_T,
          kOPEN_PERMISSION_ADD_SHARE, kOPEN_PERMISSION_ADD_TOPIC,
          kOPEN_PERMISSION_CHECK_PAGE_FANS, kOPEN_PERMISSION_DEL_IDOL,
          kOPEN_PERMISSION_DEL_T, kOPEN_PERMISSION_GET_FANSLIST,
          kOPEN_PERMISSION_GET_IDOLLIST, kOPEN_PERMISSION_GET_INFO,
          kOPEN_PERMISSION_GET_OTHER_INFO, kOPEN_PERMISSION_GET_REPOST_LIST,
          kOPEN_PERMISSION_LIST_ALBUM, kOPEN_PERMISSION_UPLOAD_PIC,
          kOPEN_PERMISSION_GET_VIP_INFO, kOPEN_PERMISSION_GET_VIP_RICH_INFO,
          kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
          kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO, nil];
  [tencentOAuth authorize:permissions inSafari:NO];
}

#pragma mark - 腾讯QQ登录功能
- (void)tencentDidLogin {
  _labelTitle.text = @"登录完成";
  if (tencentOAuth.accessToken && 0 != [tencentOAuth.accessToken length]) {
    [RKRootViewController goToMainViewController];
  } else {
    _labelAccessToken.text = @"登录不成功 没有获取accesstoken";
  }
}

- (void)tencentDidLogout {
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
  if (cancelled) {
    _labelTitle.text = @"用户取消登录";
  } else {
    _labelTitle.text = @"登录失败";
  }
}

- (void)tencentDidNotNetWork {
  _labelTitle.text = @"无网络连接，请设置网络";
}

@end
