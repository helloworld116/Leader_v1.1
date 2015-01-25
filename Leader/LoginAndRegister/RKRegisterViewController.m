//
//  RKRegisterViewController.m
//  Leader
//
//  Created by leyye on 14-11-10.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKRegisterViewController.h"
#import "RKConstants.h"
#import "RKUserAgreementViewController.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
#import "UICustomLineLabel.h"

@interface RKRegisterViewController ()

@end

@implementation RKRegisterViewController

@synthesize xTFUserNickName,xTFUserPasssword,xTFUserConfirmPwd;
@synthesize ivAgreenment = _ivAgreenment;
@synthesize isAgreen = _isAgreen;


- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void) initWithUserNickName{
    ivNickNameBackground = [[UIImageView alloc] initWithFrame:CGRectMake(kAPPMargin, kNavigationHeight + kStatusHeight +kAPPMargin, ScreenWidth - 2*kAPPMargin, 50)];
    [ivNickNameBackground setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:ivNickNameBackground];
    
    lAcount = [[UILabel alloc] initWithFrame:CGRectMake(kAPPMargin, kNavigationHeight + kStatusHeight, 100, 50)];
    lAcount.text = NSLocalizedString(@"kStringUserNickName", nil);
    [self.view addSubview:lAcount];
    
    tfUserNickName = [[UITextField alloc] initWithFrame:CGRectMake(kAPPMargin, kNavigationHeight + kStatusHeight, 100, 50)];
    [self.view addSubview:tfUserNickName];
}

//- (void) loadView{
//    [super loadView];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    
}

- (void) initialize{
    mBPHud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:mBPHud];
    
    self.xTFUserNickName.delegate = self;
    self.xTFUserPasssword.delegate = self;
    self.xTFUserConfirmPwd.delegate = self;
    
    self.xTFUserNickName.tag = 1;
    self.xTFUserPasssword.tag = 2;
    self.xTFUserConfirmPwd.tag = 3;
    
    [self.xTFUserNickName becomeFirstResponder];
    [self.xTFUserPasssword becomeFirstResponder];
    [self.xTFUserConfirmPwd becomeFirstResponder];
    _ivAgreenment.userInteractionEnabled = YES;
}

#pragma mark - UITextFieldDelegate
- (void) textFieldDidBeginEditing:(UITextField *)textField{
    [textField setBackground:[UIImage imageNamed:@"input_bg_2"]];
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    [textField setBackground:[UIImage imageNamed:@"input_bg_1"]];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
//    debugLog(@"%sreturnKeyType:%li\ttag:%li",__FUNCTION__,textField.returnKeyType,textField.tag);
    if (textField.returnKeyType == UIReturnKeyNext && textField.tag == 1) {
        [self.xTFUserPasssword becomeFirstResponder];
    }else if (textField.returnKeyType == UIReturnKeyNext && textField.tag == 2){
        [self.xTFUserConfirmPwd becomeFirstResponder];
    }else if(textField.returnKeyType == UIReturnKeyJoin && self.xTFUserConfirmPwd){
        [self verifyUserInput];
    }/*else if(textField.returnKeyType == UIReturnKeyDone){
        [textField resignFirstResponder];
    }*/
    return YES;
}

- (void) initParameters{
    userNickName = [self.xTFUserNickName.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    password = [self.xTFUserPasssword.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    confirmPwd = [self.xTFUserConfirmPwd.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    self.xTFUserNickName.delegate = self;
    self.xTFUserPasssword.delegate = self;
    self.xTFUserConfirmPwd.delegate = self;
    

    self.labLeyyeAgreement.lineType = LineTypeDown;
    self.labLeyyeAgreement.userInteractionEnabled = YES;
    self.labLeyyeAgreement.tag = 100;
}

- (IBAction) nUserRegisterLeyyeNo:(id)sender {
    [self verifyUserInput];
}

- (void) pushAgreement{
    RKUserAgreementViewController * agreementCtrl = [[RKUserAgreementViewController alloc] init];
    [self.navigationController pushViewController:agreementCtrl animated:YES];
}

- (IBAction)isLeyyeAgreenment:(id)sender {
    if (_isAgreen) {
        [_ivAgreenment setImage:[UIImage imageNamed:@"check2"]];
    } else {
        [_ivAgreenment setImage:[UIImage imageNamed:@"check1"]];
    }
    _isAgreen = !_isAgreen;
}

- (IBAction) nReadLeyyeAgreement:(id)sender{
    [self pushAgreement];
}

- (void) registerLeyyeNo {
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:URL_REG]];
    request.delegate = self;
    request.tag = kLeyyeRegister;
    [request addPostValue:userNickName forKey:@"nickname"];
    [request addPostValue:password forKey:@"password"];
    [request startSynchronous];
}

- (void) verifyUserInput{
    [self initParameters];
    if([userNickName length] == 0){
        [SVProgressHUD showErrorWithStatus:@"用户昵称不能为空"];
        return;
    }
    if ([password length] == 0 || [confirmPwd length] == 0) {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        return;
    }
    if (![password isEqualToString:confirmPwd]) {
        [SVProgressHUD showErrorWithStatus:@"两次密码不一致"];
        return;
    }
    [self registerLeyyeNo];
}

- (void) requestStarted:(ASIHTTPRequest *)request{
    [self.xTFUserNickName resignFirstResponder];
    [self.xTFUserPasssword resignFirstResponder];
    [self.xTFUserConfirmPwd resignFirstResponder];
    mBPHud.labelText = @"数据加载中...";
    [mBPHud show:YES];
}

- (void) requestFinished:(ASIHTTPRequest *)request{
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:[[request responseString] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    int result = [json[@"error"] intValue];
    switch (result) {
        case 0:{
            leyyeNo = json[@"data"][@"username"];
            [defaults setObject:leyyeNo forKey:@"leyyeno"];
            [defaults synchronize];
            [mBPHud hide:YES];
            [self shwowLeyyeNO:leyyeNo];
            debugLog(@"注册用户名：%@",leyyeNo);
        }
            break;
        default:
            break;
    }
}

- (void) requestFailed:(ASIHTTPRequest *)request{
    NSInteger code = request.error.code;
    debugLog(@"%scode:%liresponse:%@",__func__,code,[request responseString]);
    switch (code) {
        case 1:
            [SVProgressHUD showErrorWithStatus:@"当前无网络"];
            break;
        case 2:
            break;
        default:
            [SVProgressHUD showErrorWithStatus:@"服务器出现异常"];
            break;
    }
    [mBPHud hide:YES];
}

- (void) shwowLeyyeNO:(NSString *)aLeyyeNo{
    NSString * prompt = [NSString stringWithFormat:@"您注册的领域号为:%@",aLeyyeNo];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"message:prompt delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
