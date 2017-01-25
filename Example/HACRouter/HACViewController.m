//
//  HACViewController.m
//  HACRouter
//
//  Created by sicong.qian on 01/16/2017.
//  Copyright (c) 2017 sicong.qian. All rights reserved.
//

#import "HACViewController.h"
#import <HACRouter/HACRouter.h>


@interface HACViewController ()
@property (nonatomic, strong) UIButton *btn;
@end

@implementation HACViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[HACRouterCenter defautRouterCenter] registerUrlWithJsonFile:@"RouteMap" withCompleteBlk:^(BOOL suc) {
        NSLog(@"load file complete: %d", suc);
    }];
    [[HACRouterCenter defautRouterCenter] registerUrl:[NSURL URLWithString:@"HACRouter://HACSearchVC/show"]];
 
    self.btn.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
    [self.view addSubview:self.btn];
    [self.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)btn {
    if (!_btn) {
        _btn = [[UIButton alloc] init];
        [_btn setTitle:@"search page" forState:UIControlStateNormal];
        _btn.backgroundColor = [UIColor grayColor];
    }
    return _btn;
}

- (void)btnClick:(id)sender {
    BOOL suc = [[HACRouterCenter defautRouterCenter] handleUrl:[NSURL URLWithString:@"HACRouter://HACSearchVC/show"]
                                                  withCallback:^(NSDictionary *dic, NSError *error) {
                                                      NSLog(@"callback: %@", dic);
                                                  }
                                                        strict:YES];
    if (suc) {
        NSLog(@"success");
    } else {
        NSLog(@"failed");
    }
}

@end
