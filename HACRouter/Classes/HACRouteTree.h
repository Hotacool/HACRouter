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
@property (nonatomic, strong, readonly) HACRouteNode* origin;

- (instancetype)initWithOrigin:(HACRouteNode*)origin ;

- (BOOL)addTreeNodeByRouteURL:(HACRouteURL*)url ;

- (BOOL)addTreeNodeByRouteURL:(HACRouteURL *)url
                  withHandler:(NSString*)handlerName
                   paramRules:(NSDictionary*)paramRules ;

- (HACRouteNode*)queryTreeByRouteURL:(HACRouteURL*)url ;

- (void)walkTreeNodes ;
@end
