//
//  HACRouteNode.m
//  Pods
//
//  Created by macbook on 17/1/17.
//
//

#import "HACRouteNode.h"
#import "HACHelp.h"

@implementation HACRouteNode

- (instancetype)initWithName:(NSString*)name
                     handler:(NSString*)handler
                  paramRules:(NSDictionary*)paramRules{
    if (self = [super init]) {
        _name = [name copy];
        _handler = [handler copy];
        _paramRules = [paramRules copy];
        _childNodes = [NSMutableArray array];
    }
    return self;
}

- (BOOL)isValidateWithRouteURL:(HACRouteURL *)url {
    return YES;
}

- (BOOL)addChildNode:(HACRouteNode *)node {
    if (HACObjectIsNull(node) || HACObjectIsEmpty(node.name)) {
        NSLog(@"node is not correct: %@", [node description]);
        return NO;
    }
    if (!HACObjectIsNull([self isContainOfChildNodeWithName:node.name])) {
        NSLog(@"node: %@ has been added.", [node description]);
        return NO;
    }
    [self.childNodes addObject:node];
    return YES;
}

- (HACRouteNode *)queryChildNodeByName:(NSString *)name {
    return [self isContainOfChildNodeWithName:name];
}

- (HACRouteNode*)isContainOfChildNodeWithName:(NSString*)nodeName {
    HACRouteNode *__block find;
    [self.childNodes enumerateObjectsUsingBlock:^(HACRouteNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:nodeName]) {
            find = obj;
            *stop = YES;
        }
    }];
    return find;
}
@end
