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

NSString *const HACRouteConfigKeyName = @"Name";
NSString *const HACRouteConfigKeyHandler = @"Handler";
NSString *const HACRouteConfigKeySubNodes = @"subNodes";

NSString *const HACRouteDefaultScheme = @"HACRouter";
static NSString *const HACRouteURLPattern=@"^([\\w-_]+\\:\\/)?\\/([\\w-_]+\\/)+[\\w-_]+(\\?([\\w-_]+\\=[\\w-_]+\\&)*[\\w-_]+\\=[\\w-_]+)?$";
@implementation HACRouterCenter
@synthesize routeTree;

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
        routeTree = [[HACRouteTree alloc] initWithOrigin:[[HACRouteNode alloc] initWithName:@"origin" handler:@"HACRouteHandlerDefault"]];
    }
    return self;
}

- (BOOL)registerUrl:(NSURL*)url {
    return [self registerUrl:url withHandler:nil];
}

- (BOOL)registerUrlWithJsonFile:(NSString*)fileName {
    NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"json"]];
    NSError *error;
    id result = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error || HACObjectIsEmpty(result)) {
        return NO;
    }
    NSLog(@"result: %@", result);
    return [self analyzeDic:result withPrefix:@""];
}

- (BOOL)registerUrl:(NSURL *)url withConfigDic:(NSDictionary *)dic {
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
    HACRouteURL *routeUrl = [[HACRouteURL alloc] initWithURL:url];
    [routeTree addTreeNodeByRouteURL:routeUrl withHandler:handlerName];
    return YES;
}

- (BOOL)canHandleWithURL:(NSURL*)url {
    return YES;
}
- (BOOL)handleUrl:(NSURL *)url withCallback:(HACRouterRet)callback {
    if (HACObjectIsEmpty(url.absoluteString)) {
        return NO;
    }
    if (![HACRouterCenter checkURLIsValid:url]) {
        return NO;
    }
    HACRouteURL *routeUrl = [[HACRouteURL alloc] initWithURL:url];
    HACRouteNode *node = [routeTree queryTreeByRouteURL:routeUrl];
    NSString *handleName = node.nearestHandler;
    Class handleClass = NSClassFromString(handleName);
    if (handleClass && [handleClass respondsToSelector:@selector(handleRouteUrl:withCallback:)]) {
        HACBackground(^{
            [handleClass handleRouteUrl:routeUrl withCallback:callback];
        });
        return YES;
    }
    return NO;
}

+ (BOOL)checkURLIsValid:(NSURL*)url {
    NSError *err;
    NSRegularExpression * patternEx = [NSRegularExpression regularExpressionWithPattern:HACRouteURLPattern options:NSRegularExpressionCaseInsensitive error:&err];
    if (HACObjectIsNull(err)) {
        NSString *matchStr = url.absoluteString;
        if ([patternEx firstMatchInString:matchStr options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, matchStr.length)]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)analyzeDic:(NSDictionary*)dic withPrefix:(NSString*)prefix{
    NSString *name = [dic objectForKey:HACRouteConfigKeyName];
    NSString *handler = [dic objectForKey:HACRouteConfigKeyHandler];
    NSArray *subModules = [dic objectForKey:HACRouteConfigKeySubNodes];
    if (HACObjectIsEmpty(name)) {
        return NO;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", prefix, name];
    [self registerUrl:[NSURL URLWithString:urlString] withHandler:handler];
    
    BOOL __block ret = YES;
    if (!HACObjectIsEmpty(subModules)) {
        [subModules enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![self analyzeDic:obj withPrefix:urlString]) {
                ret = NO;
                *stop = YES;
            }
        }];
    }
    return ret;
}
@end
