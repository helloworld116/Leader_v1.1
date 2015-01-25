//
//  RKLeyyeInterface.m
//  Leader
//
//  Created by leyye on 14-11-1.
//  Copyright (c) 2014年 leyye. All rights reserved.
//

#import "RKLeyyeInterface.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"

@interface RKLeyyeInterface(){
    
}

@end



@implementation RKLeyyeInterface



- (void) loginWithUserNameAndPassword:(NSString *) userName password:(NSString *) password{
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_LOGIN]];
    [request setUseCookiePersistence:YES];
    [request setPostValue:userName forKey:@"username"];
    [request setPostValue:password forKey:@"pwd"];
    [request setPostValue:@"1" forKey:@"keep_login"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
//    [request setDidFinishSelector:@selector(requestLogin:)];
    [request startAsynchronous];
}

- (void) requestFinished:(ASIHTTPRequest *)request{
    /*id object = [[request responseString] JSONValue];
    debugLog(@"%@",object);
    switch (request.tag) {
        case 100:
            debugLog(@"=========  ==========");
            break;
            
        default:
            break;
    }*/
}


@end
