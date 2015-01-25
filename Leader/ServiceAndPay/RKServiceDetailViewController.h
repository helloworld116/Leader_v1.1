//
//  RKLeyyeServiceViewController.h
//  Leader
//
//  Created by leyye on 14-11-25.
//  Copyright (c) 2014年 leyye. All rights reserved.
//
#import "AMScrollingNavbarViewController.h"
#import "CustomViewController.h"

@interface RKServiceDetailViewController : AMScrollingNavbarViewController<UIScrollViewDelegate>{
    
}

@property (nonatomic, strong) NSString * strTitle;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end
