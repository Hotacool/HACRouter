//
//  HACRouterCenter.m
//  Pods
//
//  Created by macbook on 17/1/16.
//
//

#import "HACRouterCenter.h"
#import "HACHelp.h"
#import "HACRouteNode.h"
#import "HACRouteTree.h"

NSString *const HACRouteDefaultScheme = @"HACRouter";
@implementation HACRouterCenter {
    HACRouteTree *routeTree;
}

HAC_SINGLETON_IMPLEMENT(HACRouterCenter)

+ (instancetype)defautRouterCenter {
    return [self sharedHACRouterCenter];
}

- (instancetype)init {
    if (HACObjectIsNull(HACRouteDefaultScheme)) {
        NSLog(@"HACRouteDefaultScheme not set!");
        return nil;
    }
    if (self = [super init]) {
        routeTree = [[HACRouteTree alloc] initWithOrigin:[[HACRouteNode alloc] initWithName:@"origin" handler:nil paramRules:nil]];
    }
    return self;
}

- (BOOL)registerUrl:(NSURL*)url {
    BOOL __block ret;
    if (HACObjectIsEmpty(url)) {
        NSLog(@"url is nil");
        return ret;
    }
    HACRouteURL *routeUrl = [[HACRouteURL alloc] initWithURL:url];
    [routeTree addTreeNodeByRouteURL:routeUrl];
    return ret;
}

- (BOOL)registerUrlWithJsonFile:(NSString*)fileName {
    return YES;
}

- (BOOL)registerUrl:(NSURL*)url withHandler:(NSString*)handlerName {
    BOOL __block ret;
    if (HACObjectIsEmpty(url)) {
        NSLog(@"url is nil");
        return ret;
    }
    HACRouteURL *routeUrl = [[HACRouteURL alloc] initWithURL:url];
    [routeTree addTreeNodeByRouteURL:routeUrl withHandler:handlerName paramRules:nil];
    return YES;
}

- (BOOL)canHandleWithURL:(NSURL*)url {
    return YES;
}

- (BOOL)handleUrl:(NSURL *)url withCallback:(HACRouterRet)callback {
    HACRouteURL *routeUrl = [[HACRouteURL alloc] initWithURL:url];
    HACRouteNode *node = [routeTree queryTreeByRouteURL:routeUrl];
    NSString *handleName = node.handler;
    Class handleClass = NSClassFromString(handleName);
    if (handleClass) {
        id<HACRouterHandlerProtocol> handler = [[handleClass alloc] init];
        if (handler && [handler respondsToSelector:@selector(handleRouteUrl:withCallback:)]) {
            HACBackground(^{
                [handler handleRouteUrl:routeUrl.url withCallback:callback];
            });
            return YES;
        }
    }
    
    return NO;
}
@end
