//
//  Animation.m
//  Roboo
//
//  Created by TTgg on 12-12-13.
//  Copyright (c) 2012年 TTgg. All rights reserved.
//

#import "Animation.h"

@implementation UIView (Animation)

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option delegate:(id)delegate callback:(SEL)method{
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         self.frame = CGRectMake(destination.x,destination.y, self.frame.size.width,self.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (delegate != nil) {
                             [delegate performSelector:method];
                         }
                     }];
}




#pragma mark ~~~~~~~~~~~2.0~~~~~~~~~~
- (void)coverViewScale:(float)secs x:(float)scaleX y:(float)scaleY delegate:(id)delegate callback:(SEL)method yy:(float)scaleyy{
    [UIView animateWithDuration:secs
                          delay:0.0
                        options:UIViewAnimationTransitionCurlDown
                     animations:^{
                         if (scaleY == 1) {
                             self.transform = CGAffineTransformMake(scaleX, 0, 0, scaleY, 0,0);
                             self.alpha = 1;
                         }
                         else
                         {
                             self.transform = CGAffineTransformMake(scaleX, 0, 0, scaleY, 0, scaleyy);
                             self.alpha = 0;
                         }
                     }
                     completion:^(BOOL finished) {
                         if (delegate != nil) {
                             [delegate performSelector:method];
                         }
                     }];
}
#pragma mark ~~~~~~~~~~~~end~~~~~~~~~
@end
