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
    // try to dispatch to target class
    //The statement returns a value variable
    id returnValue;
    if (url.routeParameters.count>=2) {
        NSUInteger count = url.routeParameters.count;
        NSString *className = url.routeParameters[count-2];
        NSString *funcName = url.routeParameters[count-1];
        Class cla = NSClassFromString(className);
        SEL sel = NSSelectorFromString(funcName);
        // invocation
        NSMethodSignature *signature = [cla methodSignatureForSelector:sel];
        if (signature) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            invocation.target = cla;
            invocation.selector = sel;
            [invocation invoke];
            //To return a value type
            const char *returnType = signature.methodReturnType;
            if (!strcmp(returnType, @encode(void))) {
                returnValue = nil;
            } else if (!strcmp(returnType, @encode(id))){
                [invocation getReturnValue:&returnValue];
            } else {
                NSUInteger length = [signature methodReturnLength];
                void *buffer = (void *)malloc(length);
                [invocation getReturnValue:buffer];
                if( !strcmp(returnType, @encode(BOOL)) ) {
                    returnValue = [NSNumber numberWithBool:*((BOOL*)buffer)];
                } else if ( !strcmp(returnType, @encode(NSInteger)) ){
                    returnValue = [NSNumber numberWithInteger:*((NSInteger*)buffer)];
                } else if (!strcmp(returnType, @encode(int))) {
                    returnValue = [NSNumber numberWithInt:*(int*)buffer];
                } else if (!strcmp(returnType, @encode(double))) {
                    returnValue = [NSNumber numberWithDouble:*(double*)buffer];
                } else {
                    returnValue = [NSValue valueWithBytes:buffer objCType:returnType];
                }
            }
        } else {
            NSLog(@"signature is nil");
        }
    }
    if (returnValue) {
        callback(@{@"info": @"dispatch success.",
                   @"returnValue": returnValue}, nil);
    } else {
        callback(@{@"info": @"dispatch failed."}, [NSError errorWithDomain:NSURLErrorDomain code:400 userInfo:nil]);
    }
}
@end
