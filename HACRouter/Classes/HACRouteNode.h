//
//  HACRouteNode.h
//  Pods
//
//  Created by macbook on 17/1/17.
//
//

#import "HACObject.h"
#import "HACRouteURL.h"

@interface HACRouteNode : HACObject
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *handler;
@property (nonatomic, copy, readonly) NSDictionary *paramRules;

@property (nonatomic, copy, readonly) NSMutableArray <HACRouteNode*>*childNodes;

- (instancetype)initWithName:(NSString*)name
                     handler:(NSString*)handler
                  paramRules:(NSDictionary*)paramRules ;

- (BOOL)isValidateWithRouteURL:(HACRouteURL*)url ;

- (BOOL)addChildNode:(HACRouteNode*)node ;

- (HACRouteNode*)queryChildNodeByName:(NSString*)name ;
@end
