//
//  AppDelegate.m
//  Leader
//
//  Created by leyye on 14-11-1.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKAppDelegate.h"
#import "RKLoadingViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "BPush.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "IQKeyboardManager.h"

@interface RKAppDelegate ()

@end

@implementation RKAppDelegate

@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize hostReachability = _hostReachability;
@synthesize internetReachability = _internetReachability;
@synthesize wifiReachability = _wifiReachability;
@synthesize appId, channelId, userId;

//初始化
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
  defaults = [NSUserDefaults standardUserDefaults];
  cookieValue = [defaults objectForKey:@"app-cookie"];
  //    if (cookieValue) {
  //       [[NSNotificationCenter defaultCenter] addObserver:self
  //       selector:@selector(loginInvalide) name:@"nil" object:nil];
  //    }

  // Enabling keyboard manager
  [[IQKeyboardManager sharedManager] setEnable:YES];
  [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:15];
  // Enabling autoToolbar behaviour. If It is set to NO. You have to manually
  // create UIToolbar for keyboard.
  [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];

  // (Optional)Setting toolbar behavious to IQAutoToolbarBySubviews. Set it to
  // IQAutoToolbarByTag to manage previous/next according to UITextField's tag
  // property in increasing order.
  //    [[IQKeyboardManager sharedManager]
  //    setToolbarManageBehaviour:IQAutoToolbarBySubviews];

  // (Optional)Resign textField if touched outside of UITextField/UITextView.
  //    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];

  // 修改导航样式
  [[UINavigationBar appearance] setTitleTextAttributes:@{
    UITextAttributeTextColor : [UIColor whiteColor]
  }];
  //    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

  // 监测网络情况
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(reachabilityChanged:)
             name:kReachabilityChangedNotification
           object:nil];
  _hostReachability = [Reachability reachabilityWithHostName:URL_BASE];
  [_hostReachability startNotifier];
  [self updateInterfaceWithReachability:_hostReachability];

  _wifiReachability = [Reachability reachabilityForLocalWiFi];
  [_wifiReachability startNotifier];
  [self updateInterfaceWithReachability:_wifiReachability];

  _internetReachability = [Reachability reachabilityForLocalWiFi];
  [_internetReachability startNotifier];
  [self updateInterfaceWithReachability:_internetReachability];

  if (IOS_VERSION_7_OR_ABOVE) {
    self.window = [[UIWindow alloc] initWithFrame:ScreenRect];
    [[UIApplication sharedApplication]
        setStatusBarStyle:UIStatusBarStyleLightContent];
  } else {
    self.window = [[UIWindow alloc]
        initWithFrame:[[UIScreen mainScreen] applicationFrame]];
  }
  self.window.backgroundColor = [UIColor whiteColor];
  self.loadingViewController = [[RKLoadingViewController alloc] init];
  self.navigationController = [[UINavigationController alloc]
      initWithRootViewController:self.loadingViewController];
  [self.navigationController setNavigationBarHidden:YES];
  self.window.rootViewController = self.navigationController;
  [self.window makeKeyAndVisible];
  // 注册百度推送必须
  [BPush setupChannel:launchOptions];
  // 必须。参数对象必须实现(void)onMethod:(NSString*)method
  //    response:(NSDictionary*)data 方法,本示例中为 self
  [BPush setDelegate:self];
  //如果需要支持 iOS8,请加上这些代码并在 iOS6 中编译
  // 注册远程推送通知
  if (IOS_VERSION_8_OR_ABOVE) {
    UIUserNotificationType myTypes = UIRemoteNotificationTypeBadge |
                                     UIRemoteNotificationTypeAlert |
                                     UIRemoteNotificationTypeSound;
    UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
    [[UIApplication sharedApplication]
        registerUserNotificationSettings:settings];
  } else {
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
                                       UIRemoteNotificationTypeAlert |
                                       UIRemoteNotificationTypeSound;
    [[UIApplication sharedApplication]
        registerForRemoteNotificationTypes:myTypes];
  };

  return YES;
}

- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  // 必须
  [BPush registerDeviceToken:deviceToken];
  // 必须。可以在其它时机调用,只有在该方法返回(通过 onMethod:response:
  //回调)绑定成功时,app 才能接收到 Push 消息。一个 app 绑定成功至少一次即可(如
  //果 access token 变更请重新绑定)。
  [BPush bindChannel];
}

- (void)application:(UIApplication *)application
    didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  debugLog(@"注册失败：%@", error);
}

#pragma mark - 需要支持 iOS8
#ifdef IOS_VERSION_8_OR_ABOVE
- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo {
  [application registerForRemoteNotifications];
  // 可选
  [BPush handleNotification:userInfo];
  debugLog(@"收到的消息：%@", userInfo);
}
#endif

- (void)onMethod:(NSString *)method response:(NSDictionary *)data {
  NSLog(@"On method:%@", method);
  NSLog(@"data:%@", [data description]);
  NSDictionary *res = [[NSDictionary alloc] initWithDictionary:data];
  if ([BPushRequestMethod_Bind isEqualToString:method]) {
    NSString *appid = [res valueForKey:BPushRequestAppIdKey];
    NSString *userid = [res valueForKey:BPushRequestUserIdKey];
    NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
    // NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
    int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];

    if (returnCode == BPushErrorCode_Success) {
      //            self.loadingViewController.appidText.text = appid;
      //            self.loadingViewController.useridText.text = userid;
      //            self.loadingViewController.channelidText.text = channelid;

      // 在内存中备份，以便短时间内进入可以看到这些值，而不需要重新bind
      self.appId = appid;
      self.channelId = channelid;
      self.userId = userid;
    }
  } else if ([BPushRequestMethod_Unbind isEqualToString:method]) {
    int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
    if (returnCode == BPushErrorCode_Success) {
      //            self.loadingViewController.appidText.text = nil;
      //            self.loadingViewController.useridText.text = nil;
      //            self.loadingViewController.channelidText.text = nil;
    }
  }
  //    self.loadingViewController.textView.text = [[NSString alloc]
  //    initWithFormat: @"%@ return: \n%@", method, [data description]] ;
}

- (BOOL)application:(UIApplication *)application
    shouldSaveApplicationState:(NSCoder *)coder {
  return YES;
}

- (BOOL)application:(UIApplication *)application
    shouldRestoreApplicationState:(NSCoder *)coder {
  return YES;
}

- (UIViewController *)application:(UIApplication *)application
    viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents
                                          coder:(NSCoder *)coder {
  NSString *key = [identifierComponents lastObject];
  if ([key isEqualToString:@"MMDrawer"]) {
    return self.window.rootViewController;
  }
  /*else if ([key
  isEqualToString:@"MMExampleCenterNavigationControllerRestorationKey"]) {
      return ((MMDrawerController
  *)self.window.rootViewController).centerViewController;
  }
  else if ([key
  isEqualToString:@"MMExampleRightNavigationControllerRestorationKey"]) {
      return ((MMDrawerController
  *)self.window.rootViewController).rightDrawerViewController;
  }
  else if ([key
  isEqualToString:@"MMExampleLeftNavigationControllerRestorationKey"]) {
      return ((MMDrawerController
  *)self.window.rootViewController).leftDrawerViewController;
  }
  else if ([key isEqualToString:@"MMExampleLeftSideDrawerController"]){
      UIViewController * leftVC = ((MMDrawerController
  *)self.window.rootViewController).leftDrawerViewController;
      if([leftVC isKindOfClass:[UINavigationController class]]){
          return [(UINavigationController*)leftVC topViewController];
      }
      else {
          return leftVC;
      }

  }
  else if ([key isEqualToString:@"MMExampleRightSideDrawerController"]){
      UIViewController * rightVC = ((MMDrawerController
  *)self.window.rootViewController).rightDrawerViewController;
      if([rightVC isKindOfClass:[UINavigationController class]]){
          return [(UINavigationController*)rightVC topViewController];
      }
      else {
          return rightVC;
      }
  }*/
  return nil;
}

- (NSUInteger)application:(UIApplication *)application
    supportedInterfaceOrientationsForWindow:(UIWindow *)window {
  return (UIInterfaceOrientationMaskPortrait);
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
  [self saveManagedObjectContext];
}

- (void)dealloc {
  //    [_window release];
  //    [super dealloc];
  [[NSNotificationCenter defaultCenter]
      removeObserver:self
                name:kReachabilityChangedNotification
              object:nil];
}

- (NSManagedObjectModel *)managedObjectModel {
  if (_managedObjectModel != nil) {
    return _managedObjectModel;
  }
  NSURL *modelURL =
      [[NSBundle mainBundle] URLForResource:@"RKLeyye" withExtension:@"momd"];
  _managedObjectModel =
      [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
  return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  if (_persistentStoreCoordinator != nil) {
    return _persistentStoreCoordinator;
  }
  NSString *docs = [NSSearchPathForDirectoriesInDomains(
      NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
  NSURL *storeURL = [NSURL
      fileURLWithPath:[docs stringByAppendingPathComponent:@"CoreData.sqlite"]];
  NSError *error = nil;
  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
      initWithManagedObjectModel:[self managedObjectModel]];
  if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil
                                                           URL:storeURL
                                                       options:nil
                                                         error:&error]) {
    NSLog(@"Error: %@,%@", error, [error userInfo]);
  }
  return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
  if (_managedObjectContext != nil) {
    return _managedObjectContext;
  }
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (coordinator != nil) {
    _managedObjectContext = [[NSManagedObjectContext alloc]
        initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
  }
  return _managedObjectContext;
}

- (void)saveManagedObjectContext {
  NSError *error = nil;
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  if (managedObjectContext != nil) {
    if (![managedObjectContext hasChanges] &&
        [managedObjectContext save:&error]) {
      debugLog(@"保存出错：%@,%@", error, [error userInfo]);
      //            abort();
    }
  }
}

- (NSURL *)applicationDocumentsDirectory {
  return [[[NSFileManager defaultManager]
      URLsForDirectory:NSDocumentDirectory
             inDomains:NSUserDomainMask] lastObject];
}

//-(void) onResp:(BaseResp*)resp
//{
//    if([resp isKindOfClass:[SendMessageToWXResp class]])
//    {
//        NSString *strTitle = [NSString stringWithFormat:@"分享到微信"];
//
//        NSString *strMsg = @"";
//        if(resp.errCode == WXSuccess){
//            strMsg = @"分享成功";
//        }else if(resp.errCode == WXErrCodeUserCancel){
//            strMsg = @"分享取消";
//        }else{
//            strMsg = [NSString
//            stringWithFormat:@"分享失败，微信错误码：%d",resp.errCode];
//        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
//        message:strMsg delegate:self cancelButtonTitle:@"OK"
//        otherButtonTitles:nil, nil];
//        [alert show];
//    }

//    if ([resp isKindOfClass:[PayResp class]]) {
//        PayResp *response = (PayResp *)resp;
//        switch (response.errCode) {
//            case WXSuccess: {
//                if (_delegate && [_delegate
//                respondsToSelector:@selector(PaySuccess)]) {
//                    [_delegate PaySuccess]; }
//            }
//                break;
//            default: {
//                if (_delegate && [_delegate
//                                  respondsToSelector:@selector(PayFail:)]) {
//                    [_delegate PayFail:response.errCode];
//                } }
//            break;
//        }
//    }
//}

- (void)reachabilityChanged:(NSNotification *)note {
  Reachability *curReach = [note object];
  NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
  [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability {
  NetworkStatus netStatus = [reachability currentReachabilityStatus];
  BOOL connectionRequired = [reachability connectionRequired];
  debugLog(@"%snetStatus:%li\tconnectionRequired:%i", __func__, netStatus,
           connectionRequired);
  if (reachability == self.hostReachability) {
  }
  if (reachability == self.internetReachability) {
  }
  if (reachability == self.wifiReachability) {
    switch (netStatus) {
      case NotReachable:
        connectionRequired = NO;
        break;
      case ReachableViaWiFi:
        break;
      case ReachableViaWWAN:
        break;
      default:
        break;
    }
  }
}

- (BOOL)isNetworkReachability {
  Reachability *reachability = _wifiReachability;
  NetworkStatus netStatus = [reachability currentReachabilityStatus];
  if (netStatus == 0) {
    return NO;
  } else if (netStatus == ReachableViaWWAN || netStatus == ReachableViaWiFi) {
    return YES;
  }
  return NO;
}

- (void)loginInvalide {
  debugMethod();
}

@end
