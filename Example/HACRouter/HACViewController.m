//
//  HACViewController.m
//  HACRouter
//
//  Created by sicong.qian on 01/16/2017.
//  Copyright (c) 2017 sicong.qian. All rights reserved.
//

#import "HACViewController.h"
#import <HACRouter/HACRouter.h>

@interface HACViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation HACViewController {
    NSArray *dataArr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    dataArr = @[
                @"Example://x-callback-url/aaa",
                @"Example://x-callback-url/bbb",
                @"Example://x-callback-url/ccc",
                @"/x-callback-url/ddd",
                @"/x-url/eee"
                ];
    
    
    [[HACRouterCenter defautRouterCenter] registerUrl:[NSURL URLWithString:@"Example://x-callback-url/aaa"] withHandler:@"HACTest"];
    [[HACRouterCenter defautRouterCenter] registerUrl:[NSURL URLWithString:@"Example://x-callback-url/bbb"]];
    [[HACRouterCenter defautRouterCenter] registerUrl:[NSURL URLWithString:@"Example://x-callback-url/ccc"]];
    [[HACRouterCenter defautRouterCenter] registerUrl:[NSURL URLWithString:@"/x-callback-url/ddd"]];
    [[HACRouterCenter defautRouterCenter] registerUrl:[NSURL URLWithString:@"/x-url/eee"] withHandler:@"HACTest"];
    
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __func__);
    BOOL suc = [[HACRouterCenter defautRouterCenter] handleUrl:[NSURL URLWithString:dataArr[indexPath.row]]
                                                  withCallback:^(NSDictionary *dic, NSError *error) {
                                                      NSLog(@"callback: %@", dic);
                                                  }];
    if (suc) {
        NSLog(@"success");
    } else {
        NSLog(@"failed");
    }
}

@end
