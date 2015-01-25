//
//  RKMeViewController.m
//  Leader
//
//  Created by leyye on 14-12-12.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKMeViewController.h"
#import "RKLeyyeUtilKit.h"
#import "ASIFormDataRequest.h"
#import "SVProgressHUD.h"

#import "RKLeyyeUser.h"
#import "EGOImageView.h"

@interface RKMeViewController ()

@end

@implementation RKMeViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        defaults = [NSUserDefaults standardUserDefaults];
        cookieValue = [defaults objectForKey:@"app-cookie"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
}

- (void) initialize{
    [self setNaviBarTitle:@"我"];
    [self queryMyLeyyeInfo:0];
    [self getMyLeyyeDatum];
    self.lAppUserNickName.text = curAppUser.userNick;
    self.lAppUserCoin.text = [NSString stringWithFormat:@"%i",curAppUser.coins];
    self.lAppUserContro.text = [NSString stringWithFormat:@"%i",curAppUser.contribution];
    self.lAppUserLeyyeName.text = curAppUser.leyyeName;
    self.ivAppUserIcon = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"default_head"]];
    self.ivAppUserIcon.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_IMG_BASE,curAppUser.userIcon]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL) prefersStatusBarHidden{
    return YES;
}

#pragma mark - 获取用户的基本信息
- (void) queryMyLeyyeInfo:(int)type{
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_MY_INFO]];
    request.tag = 88;
    request.delegate = self;
    [request addPostValue:[NSString stringWithFormat:@"%i",type] forKey:@"type"];
    if (![RKLeyyeUtilKit isBlankString:cookieValue]) {
        [request addRequestHeader:@"Cookie" value:cookieValue];
    }
    [request startSynchronous];
}

- (void) getMyLeyyeDatum{
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_MY_INFO]];
    request.tag = 89;
    request.delegate = self;
    [request addPostValue:@"7" forKey:@"type"];
    if (![RKLeyyeUtilKit isBlankString:cookieValue]) {
        [request addRequestHeader:@"Cookie" value:cookieValue];
    }
    [request startSynchronous];
}

- (void) updateAppUserInfo{
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_MOD_INFO]];
    request.tag = 89;
    request.delegate = self;
    [request addPostValue:@"7" forKey:@"type"];
    if (![RKLeyyeUtilKit isBlankString:cookieValue]) {
        [request addRequestHeader:@"Cookie" value:cookieValue];
    }
    [request startSynchronous];
}

- (void) requestStarted:(ASIHTTPRequest *)request{
    
}

- (void) requestFinished:(ASIHTTPRequest *)request{
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:[[request responseString] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    if ([RKLeyyeUtilKit isBlankString:[json[@"error"] stringValue]]) {
        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
        return;
    }
    int index = [json[@"error"] intValue];
    if (index == 0) {
        switch (request.tag) {
            case 88:{
                curAppUser = [RKLeyyeUser parserAndSaveUserAppLogin:json[@"data"]];
//                debugLog(@"%sid:%@",__func__,json);
            }
                break;
            case 89:{
                debugLog(@"%sid:%@",__func__,json);
            }
                break;
            default:
                break;
        }
    }else if (index == 999){
        [SVProgressHUD showErrorWithStatus:@"参数有误"];
        return;
    }else{
        [SVProgressHUD showErrorWithStatus:@"未知错误"];
        return;
    }
}

- (void) requestFailed:(ASIHTTPRequest *)request{
    [SVProgressHUD showErrorWithStatus:@"网络出现异常"];
}

- (IBAction)selectImage:(id)sender{
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [sheet showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController * imagePickController = [[UIImagePickerController alloc]init];
    switch (buttonIndex) {
        case 0:{ // 拍照
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imagePickController.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            imagePickController.delegate = self;
//            imagePickController.showsCameraControls = NO;
            [self presentViewController:imagePickController animated:YES completion:nil];
        }
            break;
        case 1:{ //  相册
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                imagePickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            imagePickController.delegate = self;
            imagePickController.allowsEditing=YES;
            [self presentViewController:imagePickController animated:YES completion:nil];
        }
            break;
        case 2:{
            
        }
            break;
        default:
            break;
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    self.ivAppUserIcon.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    debugLog(@"%s%@",__func__,info);
    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {
        UIImage * originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        switch (picker.sourceType) {
            case UIImagePickerControllerSourceTypeCamera:{
                // 如果是来自照相机的image，那么先保存
                UIImageWriteToSavedPhotosAlbum(originalImage, self,
                                               @selector(image:didFinishSavingWithError:contextInfo:),
                                               nil);
                [picker dismissViewControllerAnimated:YES completion:nil];
            }
                break;
            case UIImagePickerControllerSourceTypePhotoLibrary:{
                _ivAppUserIcon.image = originalImage;
                [picker dismissViewControllerAnimated:YES completion:nil];
                [SVProgressHUD showErrorWithStatus:@"修改数据中"];
            }
                break;
            default:
                break;
        }
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    debugLog(@"%s%ld",__func__,picker.sourceType);
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
