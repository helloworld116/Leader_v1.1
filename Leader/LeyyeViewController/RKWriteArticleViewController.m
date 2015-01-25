//
//  RKWriteArticleViewController.m
//  Leader
//
//  Created by leyye on 14-11-14.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKWriteArticleViewController.h"
#import "ASIFormDataRequest.h"
#import "SVProgressHUD.h"

#import "RKLeyyeUtilKit.h"


@interface RKWriteArticleViewController ()

@end

@implementation RKWriteArticleViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        defaults = [NSUserDefaults standardUserDefaults];
        cookieValue = [defaults objectForKey:@"app-cookie"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviBarTitle:@"发表文章"];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

- (void) initialize{
//    tfArticleTitle = [[UITextField alloc] initWithFrame:CGRectMake(10, 74, ScreenWidth -70, 50)];
//    tfArticleTitle.borderStyle = UITextBorderStyleRoundedRect;
//    tfArticleTitle.placeholder = @"请输入文章标题";
//    [self.view addSubview:tfArticleTitle];
//    
//    btnAlbum = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tfArticleTitle.frame) + 5, 74, 45, 50)];
//    btnAlbum.backgroundColor = [UIColor redColor];
//    [btnAlbum addTarget:self action:@selector(selectAlbum) forControlEvents:UIControlEventTouchDragInside];
//    [self.view addSubview:btnAlbum];
//    
//    debugLog(@"tfArticleTitle:%@",NSStringFromCGRect(tfArticleTitle.frame));
//    tfArticleContent = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(tfArticleTitle.frame) + 15, ScreenWidth - 20, ScreenHeight - 350)];
    //    tfArticleContent.borderStyle = UITextBorderStyleRoundedRect;
    //    tfArticleContent.placeholder = @"请输入内容";
//    [self.view addSubview:tfArticleContent];
//    
//    btnPublish = [[UIButton alloc] initWithFrame:CGRectMake(10, ScreenHeight - 50, ScreenWidth - 20, 40)];
//    btnPublish.backgroundColor = [UIColor redColor];
//    [btnPublish setTitle:@"发表" forState:UIControlStateNormal];
//    [btnPublish addTarget:self action:@selector(publishActicle) forControlEvents:UIControlEventTouchDragInside];
//    [self.view addSubview:btnPublish];
    
}

- (void) selectAlbum {
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册",@"图库", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)selectImage:(id)sender{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [actionSheet showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController * imagePickController = [[UIImagePickerController alloc]init];
    switch (buttonIndex) {
        case 0:{ // 拍照
            imagePickController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickController.delegate = self;
            [self presentViewController:imagePickController animated:YES completion:nil];
        }
            break;
        case 1:{ // 相册
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imagePickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            imagePickController.delegate = self;
            imagePickController.allowsEditing=YES;
            [self presentViewController:imagePickController animated:YES completion:nil];
        }
            break;
        case 2:{
//            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
//                imagePickController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//            }
//            imagePickController.delegate = self;
//            imagePickController.allowsEditing=YES;
//            [self presentViewController:imagePickController animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    debugLog(@"%s%@",__func__,info);
    switch (picker.sourceType) {
        case UIImagePickerControllerSourceTypeCamera:{
            // 如果是 来自照相机的image，那么先保存
            UIImage* originalImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            UIImageWriteToSavedPhotosAlbum(originalImage, self,
                                           @selector(image:didFinishSavingWithError:contextInfo:),
                                           nil);
            [picker dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case UIImagePickerControllerSourceTypePhotoLibrary:{
            
        }
            break;
        default:
            break;
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    debugLog(@"%s%ld",__func__,picker.sourceType);
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 发布文章
- (void) publishActicle:(NSString *)title withContent:(NSString *)content{
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_SEND_ART]];
    request.delegate = self;
    request.tag = 88;
    [request addPostValue:title forKey:@"title"];
    [request addPostValue:content forKey:@"body"];
//    [request addPostValue: forKey:@"imageFile"];
    [request addPostValue:@"0" forKey:@"circleList"];
    [request addRequestHeader:@"cookie" value:cookieValue];
    [request startSynchronous];
}

- (void) requestStarted:(ASIHTTPRequest *)request{
    
}

- (void) requestFinished:(ASIHTTPRequest *)request{
    switch (request.tag) {
        case 88:{
            debugLog(@"%squery leyye domain article response:%@",__FUNCTION__,[request responseString]);
        }
            break;
            
        default:
            break;
    }
}

- (void) requestFailed:(ASIHTTPRequest *)request{
    [SVProgressHUD showErrorWithStatus:@"网络异常"];

}

- (IBAction)publishArticle:(id)sender{
    [self validateContent];
}

- (void) validateContent{
    articleTitle = self.tfArticleTitle.placeholder;
    articelContent = self.tfArticleContent.placeholder;
    if ([RKLeyyeUtilKit isBlankString:articleTitle]) {
        [SVProgressHUD showErrorWithStatus:@"请输入标题"];
        return;
    }
    if ([RKLeyyeUtilKit isBlankString:articelContent]) {
        [SVProgressHUD showErrorWithStatus:@"请输入内容"];
        return;
    }
    [self publishActicle:articleTitle withContent:articelContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
