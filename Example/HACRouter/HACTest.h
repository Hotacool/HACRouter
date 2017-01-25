//
//  HACTest.h
//  HACRouter
//
//  Created by macbook on 17/1/16.
//  Copyright © 2017年 sicong.qian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <HACRouter/HACRouter.h>

@interface HACTest : NSObject <HACRouterHandlerProtocol>

- (UIViewController*)presentVCToForeground:(NSString*)title ;

+ (int)test:(int)num ;
@end
