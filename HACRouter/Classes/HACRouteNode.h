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

/**
 nearest handler
 */
@property (nonatomic, copy) NSString *nearestHandler;

@property (nonatomic, copy, readonly) NSMutableArray <HACRouteNode*>*childNodes;

- (instancetype)initWithName:(NSString*)name
                     handler:(NSString*)handler ;

- (BOOL)updateName:(NSString*)name handler:(NSString*)handler ;

- (BOOL)addChildNode:(HACRouteNode*)node ;

/**
 Query child node by name.

 @param name child node name
 @return child node
 */
- (HACRouteNode*)queryChildNodeByName:(NSString*)name ;
@end
