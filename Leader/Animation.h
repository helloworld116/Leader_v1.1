//
//  Animation.h
//  Roboo
//
//  Created by TTgg on 12-12-13.
//  Copyright (c) 2012年 TTgg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animation)
- (void)moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option delegate:(id)delegate callback:(SEL)method;
- (void)coverViewScale:(float)secs x:(float)scaleX y:(float)scaleY delegate:(id)delegate callback:(SEL)method yy:(float)scaleyy;
@end
