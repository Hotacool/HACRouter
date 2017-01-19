//
//  HACRouterCenter.h
//  Pods
//
//  Created by macbook on 17/1/16.
//
//

#import "HACObject.h"
#import "HACRouteHandlerProtocol.h"

@class HACRouteURL;
@class HACRouteTree;

@interface HACRouterCenter : HACObject
@property (nonatomic, strong, readonly) HACRouteTree *routeTree;

/**
 get default router center

 @return router center object
 */
+ (instancetype)defautRouterCenter ;

/**
 Register url into route tree. The url will be set default handler(runtime handler), which will try to send url by runtime message calling.

 @param url NSURL
 @return register success or not
 */
- (BOOL)registerUrl:(NSURL*)url ;

/**
 Register url by json file. The file should follow given styles.

 @param fileName json file name
 @prarm completBlk complete block
 @return register success or not
 */
- (BOOL)registerUrlWithJsonFile:(NSString*)fileName withCompleteBlk:(void(^)(BOOL))completBlk ;

/**
 Register url with special handler. The handler should implement HACRouteHandlerProtocol. When the url be called, the url will be send to binded handler.

 @param url NSURL
 @param handlerName handler class name
 @return register register success or not. Asynchronously register, not accuracyly.
 */
- (BOOL)registerUrl:(NSURL*)url withHandler:(NSString*)handlerName ;

/**
 Verify the legitimacy of url.

 @param url NSURL
 @param strict strict mode
 @return success or not
 */
- (BOOL)canHandleWithURL:(NSURL*)url strict:(BOOL)strict ;

/**
 Send url to handler. Callback is a asynchronous block commonly returned in background thread.
 Strict is NO.
 
 @param url NSURL
 @param callback callback block
 @return send success or not
 */
- (BOOL)handleUrl:(NSURL*)url withCallback:(HACRouterRet)callback ;
/**
 Send url to handler with strict mode. If strict is no, router center will try to find a nearest matched node to handle with url. For example: /page/func?key=value, '/page/func' is not registered in route, but '/page' is found, the url will be forward to the handler of '/page'.
 
 @param url NSURL
 @param callback callback block
 @param strict strict mode
 @return send success or not
 */
- (BOOL)handleUrl:(NSURL*)url withCallback:(HACRouterRet)callback strict:(BOOL)strict ;

/**
 Check url is valid.

 @param url NSURL
 @return valid
 */
+ (BOOL)checkURLIsValid:(NSURL*)url ;

/**
 get current route map
 
 @param callback return route map
 */
- (void)currentRouteMapWithCallback:(void(^)(NSDictionary*))callback ;
@end
