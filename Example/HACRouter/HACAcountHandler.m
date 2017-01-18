//
//  HACAcountHandler.m
//  HACRouter
//
//  Created by macbook on 17/1/18.
//  Copyright © 2017年 sicong.qian. All rights reserved.
//

#import "HACAcountHandler.h"

@implementation HACAcountHandler

+ (void)handleRouteUrl:(HACRouteURL *)url withCallback:(HACRouterRet)callback {
    callback(@{@"key": @"HACAcountHandler callback"},nil);
}
@end
