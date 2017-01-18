//
//  HACRouterCenter.h
//  Pods
//
//  Created by macbook on 17/1/16.
//
//

#import "HACObject.h"
#import "HACRouteHandlerProtocol.h"

extern NSString *const HACRouteConfigKeyName;
extern NSString *const HACRouteConfigKeyHandler;
extern NSString *const HACRouteConfigKeySubNodes;

@class HACRouteURL;
@class HACRouteTree;
extern NSString *const HACRouteDefaultScheme;

@interface HACRouterCenter : HACObject
@property (nonatomic, strong, readonly) HACRouteTree *routeTree;

+ (instancetype)defautRouterCenter ;

- (BOOL)registerUrl:(NSURL*)url ;

- (BOOL)registerUrlWithJsonFile:(NSString*)fileName ;

- (BOOL)registerUrl:(NSURL*)url withHandler:(NSString*)handlerName ;

- (BOOL)registerUrl:(NSURL*)url withConfigDic:(NSDictionary*)dic ;

- (BOOL)canHandleWithURL:(NSURL*)url;

- (BOOL)handleUrl:(NSURL*)url withCallback:(HACRouterRet)callback ;

+ (BOOL)checkURLIsValid:(NSURL*)url ;
@end
