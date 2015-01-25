//
//  RKLeyyeServiceViewController.m
//  Leader
//
//  Created by leyye on 14-11-25.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKServiceDetailViewController.h"

@interface RKServiceDetailViewController ()

@end

@implementation RKServiceDetailViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    if (self.strTitle != nil) {
    }
    
    
    [self setTitle:@"Scroll View"];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 320, 40)];
    [label setText:@"My content"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    [self.scrollView addSubview:label];
    [self.view setBackgroundColor:[UIColor colorWithRed:80.0/255.0 green:110.0/255.0 blue:130.0/255.0 alpha:1]];
    [self.scrollView setBackgroundColor:[UIColor colorWithRed:80.0/255.0 green:110.0/255.0 blue:130.0/255.0 alpha:1]];
    
    // Let's fake some content
    [self.scrollView setContentSize:CGSizeMake(320, 840)];
    
    // Set the barTintColor. This will determine the overlay that fades in and out upon scrolling.
    [self.navigationController.navigationBar setBarTintColor:[UIColor orangeColor]];
    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    // Just call this line to enable the scrolling navbar
    [self followScrollView:self.scrollView];
    
    [self.scrollView setDelegate:self];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    // This enables the user to scroll down the navbar by tapping the status bar.
    [self showNavbar];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
