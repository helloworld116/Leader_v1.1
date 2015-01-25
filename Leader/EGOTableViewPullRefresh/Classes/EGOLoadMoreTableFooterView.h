//
//  EGOLoadMoreTableFooterView.h
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define  HeightOfLoadMoreView 65.0f

typedef enum{
	EGOPullLoadMorePulling = 0,
	EGOPullLoadMoreNormal,
	EGOPullLoadMoreLoading,	
} EGOPullLoadingMoreState;

@protocol EGOLoadMoreTableFooterViewDelegate;

@interface EGOLoadMoreTableFooterView : UIView {
	
	id _delegate;
	EGOPullLoadingMoreState _state;

	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
}

@property(nonatomic,assign) id <EGOLoadMoreTableFooterViewDelegate> delegate;

- (void)refreshLastUpdatedDate;

- (void)egoLoadMoreScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)egoLoadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView;

- (void)egoLoadMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end


@protocol EGOLoadMoreTableFooterViewDelegate

- (void)egoLoadMoreTableFooterViewDidTriggerLoadMore:(EGOLoadMoreTableFooterView*)view;

- (BOOL)egoLoadMoreTableFooterViewDataSourceIsLoading:(EGOLoadMoreTableFooterView*)view;

- (NSDate*)egoLoadMoreTableFooterViewDataSourceLastUpdated:(EGOLoadMoreTableFooterView*)view;

@end
