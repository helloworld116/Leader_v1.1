//
//  RKLoginAndRegisterViewController.h
//  Leader
//
//  Created by leyye on 14-12-5.
//  Copyright (c) 2014年 leyye. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CustomViewController.h"
#import "SHViewPager.h"

@interface RKLoginAndRegisterViewController : UIViewController<UIScrollViewDelegate,SHViewPagerDataSource, SHViewPagerDelegate>{
    UIScrollView * contentScrollView;
    NSArray *menuItems;
}
@property (nonatomic, strong) IBOutlet SHViewPager * pager;
@end
