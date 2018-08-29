//
//  YWContainerViewController.m
//  YWAlertViewDemo
//
//  Created by yaowei on 2018/8/29.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "YWContainerViewController.h"
#import "UIView+Autolayout.h"

@interface YWContainerViewController ()

@end

@implementation YWContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.alertView];

    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];

    [self.alertView addConstraint:NSLayoutAttributeLeft equalTo:self.view offset:0];
    [self.alertView addConstraint:NSLayoutAttributeRight equalTo:self.view offset:0];
    [self.alertView addConstraint:NSLayoutAttributeTop equalTo:self.view offset:0];
    [self.alertView addConstraint:NSLayoutAttributeBottom equalTo:self.view offset:0];
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

@end
