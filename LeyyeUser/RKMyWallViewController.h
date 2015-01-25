//
//  RKMyWallViewController.h
//  Leader
//
//  Created by leyye on 14-12-17.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHViewPager.h"

@interface RKMyWallViewController : UIViewController<UIScrollViewDelegate,SHViewPagerDataSource, SHViewPagerDelegate>{
    NSArray * arrayTitles;
}

@end
