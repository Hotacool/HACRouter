//
//  HACRouteHandlerProtocol.h
//  Pods
//
//  Created by macbook on 17/1/18.
//
//

#ifndef HACRouteHandlerProtocol_h
#define HACRouteHandlerProtocol_h
typedef void(^HACRouterRet)(NSDictionary* dic, NSError *error);
@class HACRouteURL;

@protocol HACRouterHandlerProtocol <NSObject>
@required
+ (void)handleRouteUrl:(HACRouteURL*)url withCallback:(HACRouterRet)callback ;
@end

#endif /* HACRouteHandlerProtocol_h */
