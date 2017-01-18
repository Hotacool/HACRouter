//
//  AlipayActionHandler.m
//  HACRouter
//
//  Created by macbook on 17/1/18.
//  Copyright © 2017年 sicong.qian. All rights reserved.
//

#import "AlipayActionHandler.h"

@implementation AlipayActionHandler
+ (void)handleRouteUrl:(HACRouteURL *)url withCallback:(HACRouterRet)callback {
    callback(@{@"key": @"AlipayActionHandler callback"},nil);
}
@end
