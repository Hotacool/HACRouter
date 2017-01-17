//
//  HACRouteURL.m
//  Pods
//
//  Created by macbook on 17/1/16.
//
//

#import "HACRouteURL.h"
#import "HACHelp.h"

static NSString * const HACRouteURLslash=@"/";
static NSString * const HACRouteURLAnd=@"&";
static NSString * const HACRouteURLEqual=@"=";
@implementation HACRouteURL

- (instancetype)initWithURL:(NSURL *)url {
    if (self = [super init]) {
        _url = [url copy];
        [self analyze];
    }
    return self;
}

- (void)analyze {
    if (HACObjectIsEmpty(_url)) {
        return;
    }
    _scheme = [HACRouteURL extractRouteSchemeFromURL:_url];
    _queryParameters = [HACRouteURL extractQueryParametersFromURL:_url];
    _routeParameters = [HACRouteURL extractRouteParametersFromURL:_url];
}

+ (NSString*)extractRouteSchemeFromURL:(NSURL*)url {
    return [url scheme];
}

+ (NSArray *)extractRouteParametersFromURL:(NSURL *)url {
    NSMutableArray *routeParameters;
    if (!HACObjectIsEmpty(url)) {
        routeParameters = [NSMutableArray array];
        // if url has scheme, the first object will be host, add to array.
        if (!HACObjectIsEmpty([self extractRouteSchemeFromURL:url])) {
            NSString *host = [url host];
            if (!HACObjectIsEmpty(host)) {
                [routeParameters addObject:host];
            }
        }
        [[url pathComponents] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![HACRouteURLslash isEqualToString:obj]) {
                [routeParameters addObject:obj];
            }
        }];
    }
    return routeParameters;
}

+ (NSDictionary*)extractQueryParametersFromURL:(NSURL *)url {
    NSMutableDictionary *queryParameters;
    if (!HACObjectIsEmpty(url)) {
        queryParameters = [NSMutableDictionary dictionary];
        NSString *query = [url query];
        [[query componentsSeparatedByString:HACRouteURLAnd] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *part = [obj componentsSeparatedByString:HACRouteURLEqual];
            if (part.count == 2) {
                [queryParameters setObject:part[1] forKey:part[0]];
            }
        }];
    }
    return queryParameters;
}

@end
