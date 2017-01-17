//
//  HACRouterCenter.h
//  Pods
//
//  Created by macbook on 17/1/16.
//
//

#import "HACObject.h"
#import "HACRouteURL.h"

extern NSString *const HACRouteDefaultScheme;
typedef void(^HACRouterRet)(NSDictionary* dic, NSError *error);

@protocol HACRouterHandlerProtocol <NSObject>
@required
- (void)handleRouteUrl:(HACRouteURL*)url withCallback:(HACRouterRet)callback ;
@end

@interface HACRouterCenter : HACObject

+ (instancetype)defautRouterCenter ;

- (BOOL)registerUrl:(NSURL*)url ;

- (BOOL)registerUrlWithJsonFile:(NSString*)fileName ;

- (BOOL)registerUrl:(NSURL*)url withHandler:(NSString*)handlerName ;

- (BOOL)canHandleWithURL:(NSURL*)url;

- (BOOL)handleUrl:(NSURL*)url withCallback:(HACRouterRet)callback ;
@end
