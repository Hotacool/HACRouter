//
//  HACSearchVC.m
//  HACRouter
//
//  Created by macbook on 17/1/19.
//  Copyright © 2017年 sicong.qian. All rights reserved.
//

#import "HACSearchVC.h"
#import <HACRouter/HACRouter.h>

@interface HACSearchVC ()
@property (nonatomic, strong) UILabel *showLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *btn;
@end

@implementation HACSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.showLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    [self.view addSubview:self.showLabel];
    self.textField.frame = CGRectMake(0, 200, self.view.frame.size.width, 50);
    [self.view addSubview:self.textField];
    self.btn.frame = CGRectMake(0, 300, self.view.frame.size.width, 50);
    [self.view addSubview:self.btn];
    [self.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)show {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (rootVC) {
        UIViewController *presentVC = [[HACSearchVC alloc] init];
        dispatch_async(dispatch_get_main_queue(), ^{
            [rootVC presentViewController:presentVC animated:YES completion:nil];
        });
    }
}

+ (void)dismiss {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *presentVC = [rootVC presentedViewController];
    if (presentVC != rootVC) {
        [presentVC dismissViewControllerAnimated:YES completion:nil];
    }
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
                                                        strict:NO];
    if (suc) {
        NSLog(@"success");
    } else {
        NSLog(@"failed");
        self.showLabel.text = @"failed";
    }
}

@end
