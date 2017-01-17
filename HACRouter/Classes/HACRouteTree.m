//
//  HACRouteTree.m
//  Pods
//
//  Created by macbook on 17/1/17.
//
//

#import "HACRouteTree.h"
#import "HACRouteURL.h"
#import "HACRouteNode.h"
#import "HACHelp.h"

@implementation HACRouteTree

- (instancetype)initWithOrigin:(HACRouteNode *)origin {
    if (self = [super init]) {
        _origin = origin;
    }
    return self;
}

- (BOOL)addTreeNodeByRouteURL:(HACRouteURL *)url {
    return [self addTreeNodeByRouteURL:url withHandler:nil paramRules:nil];
}

- (BOOL)addTreeNodeByRouteURL:(HACRouteURL *)url
                  withHandler:(NSString*)handlerName
                   paramRules:(NSDictionary*)paramRules {
    NSLog(@"%s", __func__);
    BOOL __block ret;
    NSMutableArray <NSString*>*array = [url.routeParameters mutableCopy];
    if (!HACObjectIsEmpty(url.scheme)) {
        [array insertObject:url.scheme atIndex:0];
    }
    HACRouteNode *__block curNode = _origin;
    [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"current node: %@", curNode.name);
        HACRouteNode *tmp = [curNode queryChildNodeByName:obj];
        if (HACObjectIsNull(tmp)) {
            tmp = [[HACRouteNode alloc] initWithName:obj handler:handlerName paramRules:paramRules];
            [curNode addChildNode:tmp];
            ret = YES;
            NSLog(@"add a new node: %@", obj);
        }
        curNode = tmp;
    }];
    return ret;
}

- (HACRouteNode*)queryTreeByRouteURL:(HACRouteURL*)url {
    NSLog(@"%s", __func__);
    HACRouteNode *__block  find;
    NSMutableArray <NSString*>*array = [url.routeParameters mutableCopy];
    if (!HACObjectIsEmpty(url.scheme)) {
        [array insertObject:url.scheme atIndex:0];
    }
    find = _origin;
    [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"current node: %@", find.name);
        HACRouteNode *tmp = [find queryChildNodeByName:obj];
        if (HACObjectIsNull(tmp)) {
            *stop = YES;
        }
        find = tmp;
    }];
    return find;
}

- (void)walkTreeNodes {
    [self queryTreeNode:_origin];
}

- (void)queryTreeNode:(HACRouteNode*)node {
    NSLog(@"node: %@", node.name);
    [node.childNodes enumerateObjectsUsingBlock:^(HACRouteNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self queryTreeNode:obj];
    }];
}

@end
