//
//  HACRouteTree.h
//  Pods
//
//  Created by macbook on 17/1/17.
//
//

#import "HACObject.h"

@class HACRouteNode;
@class HACRouteURL;
@interface HACRouteTree : HACObject

/**
 origin node
 */
@property (nonatomic, strong, readonly) HACRouteNode* origin;

- (instancetype)initWithOrigin:(HACRouteNode*)origin ;

- (BOOL)addTreeNodeByRouteURL:(HACRouteURL*)url ;

- (BOOL)addTreeNodeByRouteURL:(HACRouteURL *)url
                  withHandler:(NSString*)handlerName;

/**
 Query tree node by url. Example: scheme:module/page/func?key1=value1&key2=value2.
 ① if exist tree branch with path scheme->module->page->func, return func. strict or not.
 ② if exist tree branch with path scheme->module->page, return the final found node page. only not strictly.
 ③ if exist no branch with node scheme, return the top node origin. only not strictly.

 @param url HACRouteURL
 @param strict BOOL
 @return found node
 */
- (HACRouteNode*)queryTreeByRouteURL:(HACRouteURL*)url strict:(BOOL)strict ;

- (NSDictionary*)walkTreeNodes ;
@end
