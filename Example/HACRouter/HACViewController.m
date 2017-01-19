//
//  HACViewController.m
//  HACRouter
//
//  Created by sicong.qian on 01/16/2017.
//  Copyright (c) 2017 sicong.qian. All rights reserved.
//

#import "HACViewController.h"
#import <HACRouter/HACRouter.h>

#import <objc/message.h>

@interface HACViewController ()
@property (nonatomic, strong) UILabel *showLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *btn;
@end

@implementation HACViewController {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[HACRouterCenter defautRouterCenter] registerUrlWithJsonFile:@"RouteMap" withCompleteBlk:^(BOOL suc) {
        NSLog(@"load file complete: %d", suc);
    }];
    [[HACRouterCenter defautRouterCenter] registerUrl:[NSURL URLWithString:@"RouteTestXXXX://PaymentModule/iapPage/buy"] withHandler:@"HACTest"];
    [[HACRouterCenter defautRouterCenter] registerUrl:[NSURL URLWithString:@"RouteTestXXXX://PaymentModule/iapPage/cancel"] withHandler:@"HACTest"];

    self.showLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    [self.view addSubview:self.showLabel];
    self.textField.frame = CGRectMake(0, 200, self.view.frame.size.width, 50);
    [self.view addSubview:self.textField];
    self.btn.frame = CGRectMake(0, 300, self.view.frame.size.width, 50);
    [self.view addSubview:self.btn];
    [self.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UILabel *)showLabel {
    if (!_showLabel) {
        _showLabel = [[UILabel alloc] init];
        _showLabel.font = [UIFont systemFontOfSize:18];
        _showLabel.textAlignment = NSTextAlignmentCenter;
        _showLabel.numberOfLines = 0;
        _showLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _showLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.layer.borderColor = [UIColor blueColor].CGColor;
        _textField.layer.borderWidth = 1;
    }
    return _textField;
}

- (UIButton *)btn {
    if (!_btn) {
        _btn = [[UIButton alloc] init];
        [_btn setTitle:@"send" forState:UIControlStateNormal];
        _btn.backgroundColor = [UIColor grayColor];
    }
    return _btn;
}

- (void)btnClick:(id)sender {
//    [[HACRouterCenter defautRouterCenter] currentRouteMapWithCallback:^(NSDictionary *dic) {
//        NSLog(@"route map: %@", dic);
//    }];
    BOOL suc = [[HACRouterCenter defautRouterCenter] handleUrl:[NSURL URLWithString:self.textField.text]
                                                  withCallback:^(NSDictionary *dic, NSError *error) {
                                                      NSLog(@"callback: %@", dic);
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          self.showLabel.text = [dic description];
                                                      });
                                                  }
                strict:YES];
    if (suc) {
        NSLog(@"success");
    } else {
        NSLog(@"failed");
        self.showLabel.text = @"failed";
    }
}

@end
