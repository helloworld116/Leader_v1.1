//
//  AppDelegate.h
//  Leader
//
//  Created by leyye on 14-11-1.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BPush.h"
@class RKLoadingViewController;
@class Reachability;
@class MBProgressHUD;

@interface RKAppDelegate : UIResponder<UIApplicationDelegate, BPushDelegate> {
  NSUserDefaults *defaults;
  NSString *cookieValue;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) Reachability *hostReachability;
@property (nonatomic, strong) Reachability *wifiReachability;
@property (nonatomic, strong) Reachability *internetReachability;
@property (nonatomic, strong) MBProgressHUD *mBPHud;

@property (nonatomic, strong) UINavigationController *navigationController;
@property (strong, nonatomic) RKLoadingViewController *loadingViewController;

@property (strong, nonatomic) NSString *appId;
@property (strong, nonatomic) NSString *channelId;
@property (strong, nonatomic) NSString *userId;

@property (strong, nonatomic, readonly)
    NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic, readonly)
    NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic, readonly)
    NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSManagedObjectModel *)managedObjectModel;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSManagedObjectContext *)managedObjectContext;
- (void)saveManagedObjectContext;
- (NSURL *)applicationDocumentsDirectory;

- (BOOL)isNetworkReachability;
@end
