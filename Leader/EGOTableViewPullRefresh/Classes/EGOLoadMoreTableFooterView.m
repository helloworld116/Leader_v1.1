//
//  EGOLoadMoreTableHeaderView.m
//  Demo
//
//


#import "EGOLoadMoreTableFooterView.h"

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface EGOLoadMoreTableFooterView (Private)

- (void)setState:(EGOPullLoadingMoreState)aState;

@end

@implementation EGOLoadMoreTableFooterView

@synthesize delegate=_delegate;


- (id)initWithFrame:(CGRect)frame 
{
    if(self = [super initWithFrame:frame]) 
    {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor clearColor];//;[UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
		
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 33, self.frame.size.width, 20.0f)];
		_statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		_statusLabel.textColor = [UIColor blackColor];//;TEXT_COLOR;
		_statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		_statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		_statusLabel.backgroundColor = [UIColor clearColor];
		_statusLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:_statusLabel];
		
        CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(55.0f, 13.0f, 30.0f, 55.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"blueArrowLoadMore.png"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
        
		_activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.frame = CGRectMake((self.frame.size.width-20)/2, 10, 20.0f, 20.0f);
		[self addSubview:_activityView];
				
		[self setState:EGOPullLoadMoreNormal];		
    }
	
    return self;	
}


#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate
{
	if (_delegate && _delegate!=nil && [_delegate respondsToSelector:@selector(egoLoadMoreTableFooterViewDataSourceLastUpdated:)])
    {
		NSDate *date = [_delegate egoLoadMoreTableFooterViewDataSourceLastUpdated:self];

		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setAMSymbol:@"上午"];
		[formatter setPMSymbol:@"下午"];
		[formatter setDateFormat:@"yyyy/MM/dd hh:mm:a"];
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"最后更新: %@", [formatter stringFromDate:date]];
        
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[formatter release];
		
	} 
    else 
    {
		_lastUpdatedLabel.text = nil;
	}

}

- (void)setState:(EGOPullLoadingMoreState)aState
{
	switch (aState) 
    {
		case EGOPullLoadMorePulling:
			
			_statusLabel.text = NSLocalizedString(@"上拉加载更多...", nil);
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case EGOPullLoadMoreNormal:
			
			if (_state == EGOPullLoadMorePulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				//_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = NSLocalizedString(@"上拉可以加载更多...", nil);
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case EGOPullLoadMoreLoading:
			
			_statusLabel.text = NSLocalizedString(@"正在加载...", nil);
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

//手指屏幕上不断拖动调用此方法
- (void)egoLoadMoreScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (_state == EGOPullLoadMoreLoading)
    {
		scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0f, HeightOfLoadMoreView, 0.0f);
        
        
//		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
//		offset = MIN(offset, 60);
//        scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0f, offset, 0.0f);
        
	}
    else if (scrollView.isDragging)
    {
		
		BOOL _loading = NO;
		if (_delegate && _delegate!=nil && [_delegate respondsToSelector:@selector(egoLoadMoreTableFooterViewDataSourceIsLoading:)])
        {
			_loading = [_delegate egoLoadMoreTableFooterViewDataSourceIsLoading:self];
		}
		
		if (_state == EGOPullLoadMorePulling 
            && scrollView.contentOffset.y + (scrollView.frame.size.height) < scrollView.contentSize.height + HeightOfLoadMoreView 
            && scrollView.contentOffset.y > 0.0f 
            && !_loading)
        {
			[self setState:EGOPullLoadMoreNormal];
		}
        else if (_state == EGOPullLoadMoreNormal 
                 && scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + HeightOfLoadMoreView  
                 && !_loading)
        {
			[self setState:EGOPullLoadMorePulling];
		}
		
		if (scrollView.contentInset.bottom != 0)
        {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}

//当用户停止拖动，并且手指从屏幕中拿开的的时候调用此方法
- (void)egoLoadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if (_delegate && _delegate!=nil && [_delegate respondsToSelector:@selector(egoLoadMoreTableFooterViewDataSourceIsLoading:)])
    {
		_loading = [_delegate egoLoadMoreTableFooterViewDataSourceIsLoading:self];
	}

	if (scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + HeightOfLoadMoreView 
        && !_loading) 
    {
		if (_delegate && _delegate!=nil && [_delegate respondsToSelector:@selector(egoLoadMoreTableFooterViewDidTriggerLoadMore:)])
        {
			[_delegate egoLoadMoreTableFooterViewDidTriggerLoadMore:self];
		}
		
		[self setState:EGOPullLoadMoreLoading];
        
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, HeightOfLoadMoreView, 0.0f);
		[UIView commitAnimations];
	}
}

//当开发者页面刷新完毕调用此方法
- (void)egoLoadMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:EGOPullLoadMoreNormal];

}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	[_activityView release];         _activityView = nil;
	[_statusLabel release];          _statusLabel = nil;
	//_arrowImage = nil;
	[_lastUpdatedLabel release];     _lastUpdatedLabel = nil;
    
    [super dealloc];
}


@end
