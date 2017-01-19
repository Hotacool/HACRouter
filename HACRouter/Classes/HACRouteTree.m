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
    return [self addTreeNodeByRouteURL:url withHandler:nil];
}

- (BOOL)addTreeNodeByRouteURL:(HACRouteURL *)url
                  withHandler:(NSString*)handlerName {
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
        NSString *handlerStr = (array.count==idx+1)?handlerName:nil;
        if (HACObjectIsNull(tmp)) {
            tmp = [[HACRouteNode alloc] initWithName:obj handler:handlerStr];
            [curNode addChildNode:tmp];
            ret = YES;
            NSLog(@"add a new node: %@, %@", obj, handlerStr);
        } else {
            if (array.count==idx+1) {
                [tmp updateName:obj handler:handlerStr];
                NSLog(@"update node: %@, handler: %@", obj, handlerStr);
            }
        }
        curNode = tmp;
    }];
    return ret;
}

- (HACRouteNode*)queryTreeByRouteURL:(HACRouteURL*)url strict:(BOOL)strict {
    NSLog(@"%s", __func__);
    HACRouteNode *__block  find;
    NSString *__block handler;
    NSMutableArray <NSString*>*array = [url.routeParameters mutableCopy];
    if (!HACObjectIsEmpty(url.scheme)) {
        [array insertObject:url.scheme atIndex:0];
    }
    find = _origin;
    handler = _origin.handler;
    [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"current node: %@", find.name);
        HACRouteNode *tmp = [find queryChildNodeByName:obj];
        if (HACObjectIsNull(tmp)) {
            if (strict) {
                find = nil;
            }
            *stop = YES;
        } else {
            find = tmp;
            if (!HACObjectIsEmpty(find.handler)) {
                handler = find.handler;
            }
        }
    }];
    find.nearestHandler = handler;
    return find;
}

- (NSDictionary *)walkTreeNodes {
    NSDictionary *retDic;
    NSMutableArray *subNodes = [NSMutableArray array];
    retDic = @{HACRouteConfigKeyName: _origin.name,
               HACRouteConfigKeyHandler: _origin.handler,
               HACRouteConfigKeySubNodes: subNodes
               };
    [self walkTreeWithNode:_origin subNodes:subNodes];
    return retDic;
}

- (void)walkTreeWithNode:(HACRouteNode*)node subNodes:(NSMutableArray*)array {
    if (HACObjectIsNull(node)) {
        return;
    }
    [node.childNodes enumerateObjectsUsingBlock:^(HACRouteNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *subNodes = [NSMutableArray array];
        NSDictionary *dicAdd = @{HACRouteConfigKeyName: obj.name?:@"",
                                 HACRouteConfigKeyHandler: obj.handler?:@"",
                                 HACRouteConfigKeySubNodes: subNodes
                                 };
        [array addObject:dicAdd];
        [self walkTreeWithNode:obj subNodes:subNodes];
    }];
}

@end
