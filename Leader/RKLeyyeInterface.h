//
//  RKLeyyeInterface.h
//  Leader
//
//  Created by leyye on 14-11-1.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequestDelegate.h"
@class ASIFormDataRequest;

@interface RKLeyyeInterface : NSObject <ASIHTTPRequestDelegate>{
    ASIFormDataRequest *request;
}

- (void) loginWithUserNameAndPassword:(NSString *) userName password:(NSString *) password;

@end
