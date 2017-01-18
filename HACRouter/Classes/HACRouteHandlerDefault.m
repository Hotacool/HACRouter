//
//  HACRouteHandlerDefault.m
//  Pods
//
//  Created by macbook on 17/1/18.
//
//

#import "HACRouteHandlerDefault.h"
#import "HACRouteURL.h"
#import "HACHelp.h"
#import <objc/message.h>

@implementation HACRouteHandlerDefault

+ (void)handleRouteUrl:(HACRouteURL*)url withCallback:(HACRouterRet)callback {
    NSLog(@"current thread: %@", [NSThread currentThread]);
    [url.queryParameters enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"key: %@, value: %@", key, obj);
    }];
    // try to dispatch to target class
    BOOL __block dispSuc;
    HACBackground(^{
        if (url.routeParameters.count>=2) {
            int count = url.routeParameters.count;
            NSString *className = url.routeParameters[count-2];
            NSString *funcName = url.routeParameters[count-1];
            Class cla = NSClassFromString(className);
            SEL sel = NSSelectorFromString(funcName);
            if (cla&&[cla respondsToSelector:sel]) {
                objc_msgSend(cla, sel);
                dispSuc = YES;
            }
        }
        if (dispSuc) {
            callback(@{@"info": @"dispatch success."}, nil);
        } else {
            callback(@{@"info": @"dispatch failed."}, [NSError errorWithDomain:NSURLErrorDomain code:400 userInfo:nil]);
        }
    });
}
@end
