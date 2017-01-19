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

static NSString *const HACRouteURLPattern=@"^([\\w-_]+\\:\\/)?\\/([\\w-_]+\\/)+[\\w-_]+(\\?([\\w-_]+\\=[\\w-_]+\\&)*[\\w-_]+\\=[\\w-_]+)?$";
static dispatch_queue_t HACRouterCenterQueue;
@implementation HACRouterCenter
@synthesize routeTree;

HAC_SINGLETON_IMPLEMENT(HACRouterCenter)

+ (instancetype)defautRouterCenter {
    return [self sharedHACRouterCenter];
}

- (instancetype)init {
    if (self = [super init]) {
        routeTree = [[HACRouteTree alloc] initWithOrigin:[[HACRouteNode alloc] initWithName:@"origin" handler:@"HACRouteHandlerDefault"]];
        HACRouterCenterQueue = dispatch_queue_create("HACRouterCenterQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (BOOL)registerUrl:(NSURL*)url {
    return [self registerUrl:url withHandler:nil];
}

- (BOOL)registerUrlWithJsonFile:(NSString*)fileName withCompleteBlk:(void(^)(BOOL))completBlk {
    if (HACObjectIsEmpty(fileName)) {
        return NO;
    }
    NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"json"]];
    if (HACObjectIsNull(jsonData)) {
        return NO;
    }
    dispatch_barrier_async(HACRouterCenterQueue, ^{
        NSError *error;
        id result = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error || HACObjectIsEmpty(result)) {
            completBlk(NO);
            return;
        }
        if ([self insertTreeNodeWithParentNode:routeTree.origin dic:result]) {
            completBlk(YES);
        } else {
            completBlk(NO);
        }
    });

    return YES;
}

- (BOOL)registerUrl:(NSURL*)url withHandler:(NSString*)handlerName {
    if (HACObjectIsEmpty(url)) {
        NSLog(@"url is nil");
        return NO;
    }
    if (![HACRouterCenter checkURLIsValid:url]) {
        return NO;
    }
    dispatch_barrier_async(HACRouterCenterQueue, ^{
        HACRouteURL *routeUrl = [[HACRouteURL alloc] initWithURL:url];
        [routeTree addTreeNodeByRouteURL:routeUrl withHandler:handlerName];
    });
    return YES;
}

- (BOOL)canHandleWithURL:(NSURL*)url strict:(BOOL)strict {
    if (![HACRouterCenter checkURLIsValid:url]) {
        return NO;
    }
    HACRouteNode *__block node;
    dispatch_sync(HACRouterCenterQueue, ^{
        HACRouteURL *routeUrl = [[HACRouteURL alloc] initWithURL:url];
        node = [routeTree queryTreeByRouteURL:routeUrl strict:strict];
    });
    if (HACObjectIsNull(node)) {
        return NO;
    }
    return YES;
}
- (BOOL)handleUrl:(NSURL *)url withCallback:(HACRouterRet)callback {
    return [self handleUrl:url withCallback:callback strict:NO];
}

- (BOOL)handleUrl:(NSURL*)url withCallback:(HACRouterRet)callback strict:(BOOL)strict {
    if (![HACRouterCenter checkURLIsValid:url]) {
        return NO;
    }
    dispatch_async(HACRouterCenterQueue, ^{
        HACRouteURL *routeUrl = [[HACRouteURL alloc] initWithURL:url];
        HACRouteNode *node = [routeTree queryTreeByRouteURL:routeUrl strict:strict];
        if (HACObjectIsNull(node)) {
            callback(@{@"info": @"not registered"}, [NSError errorWithDomain:NSURLErrorDomain code:400 userInfo:nil]);
            return;
        }
        NSString *handleName = node.nearestHandler;
        Class handleClass = NSClassFromString(handleName);
        if (handleClass && [handleClass respondsToSelector:@selector(handleRouteUrl:withCallback:)]) {
            [handleClass handleRouteUrl:routeUrl withCallback:callback];
        } else {
            callback(@{@"info": @"can not runtime-dispatch."}, [NSError errorWithDomain:NSURLErrorDomain code:400 userInfo:nil]);
        }
    });
    return YES;
}

- (void)currentRouteMapWithCallback:(void(^)(NSDictionary*))callback {
    dispatch_async(HACRouterCenterQueue, ^{
        callback([routeTree walkTreeNodes]);
    });
}

+ (BOOL)checkURLIsValid:(NSURL*)url {
    if (HACObjectIsNull(url)||HACObjectIsEmpty(url.absoluteString)) {
        return NO;
    }
    NSError *err;
    NSRegularExpression * patternEx = [NSRegularExpression regularExpressionWithPattern:HACRouteURLPattern options:NSRegularExpressionCaseInsensitive error:&err];
    if (HACObjectIsNull(err)) {
        NSString *matchStr = url.absoluteString;
        if ([patternEx firstMatchInString:matchStr options:0 range:NSMakeRange(0, matchStr.length)]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)insertTreeNodeWithParentNode:(HACRouteNode*)parent dic:(NSDictionary*)dic {
    NSString *name = [dic objectForKey:HACRouteConfigKeyName];
    NSString *handler = [dic objectForKey:HACRouteConfigKeyHandler];
    NSArray *subModules = [dic objectForKey:HACRouteConfigKeySubNodes];
    if (HACObjectIsEmpty(name)) {
        return NO;
    }
    HACRouteNode *nodeAdd = [[HACRouteNode alloc] initWithName:name handler:handler];
    [parent addChildNode:nodeAdd];
    NSLog(@"add child Node: %@", [nodeAdd description]);
    BOOL __block ret = YES;
    [subModules enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![self insertTreeNodeWithParentNode:nodeAdd dic:obj]) {
            ret = NO;
            *stop = YES;
        }
    }];
    return ret;
}
@end
