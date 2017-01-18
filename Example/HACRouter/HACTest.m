//
//  HACTest.m
//  HACRouter
//
//  Created by macbook on 17/1/16.
//  Copyright © 2017年 sicong.qian. All rights reserved.
//

#import "HACTest.h"

@implementation HACTest

- (UIViewController *)presentVCToForeground:(NSString *)title {
    UIViewController *ctrl = [[UIViewController alloc] init];
    ctrl.view.backgroundColor = [UIColor greenColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    label.center = ctrl.view.center;
    label.text = title;
    [ctrl.view addSubview:label];
    return ctrl;
}

+ (void)handleRouteUrl:(HACRouteURL*)url withCallback:(HACRouterRet)callback {
    callback(@{@"key": @"Hello, work!"},nil);
}

- (void)dealloc {
    NSLog(@"dealloc");
}
@end
