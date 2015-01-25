//
//  main.m
//  Leader
//
//  Created by leyye on 14-11-1.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKAppDelegate.h"
#import "sys/utsname.h"
int main(int argc, char * argv[]) {
    @autoreleasepool {
//        struct utsname systemInfo;
//        uname(&systemInfo);
//        NSString * platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
//        if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
//        NSLog(@"%@\tdeviceString:%@",[[UIDevice currentDevice] systemName],platform);
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([RKAppDelegate class]));
    }
}
