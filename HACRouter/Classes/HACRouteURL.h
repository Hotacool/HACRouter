//
//  HACRouteURL.h
//  Pods
//
//  Created by macbook on 17/1/16.
//
//

#import "HACObject.h"

@interface HACRouteURL : HACObject
@property (nonatomic, copy, readonly) NSURL *url;

@property (nonatomic, copy, readonly) NSString *scheme;
@property (nonatomic, copy, readonly) NSDictionary <NSString*,NSString*>*queryParameters;
@property (nonatomic, copy, readonly) NSArray <NSString*>*routeParameters;

- (instancetype)initWithURL:(NSURL*)url ;

+ (NSString*)extractRouteSchemeFromURL:(NSURL*)url ;

+ (NSDictionary*)extractRouteParametersFromURL:(NSURL*)url ;

+ (NSDictionary*)extractQueryParametersFromURL:(NSURL *)url ;
@end
