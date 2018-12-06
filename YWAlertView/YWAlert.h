//
//  YWAlert.h
//  YWAlertViewDemo
//
//  Created by yaowei on 2018/8/27.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWAlertViewProtocol.h"

@interface YWAlert : UIView <YWAlertAlertViewProtocol>

@property (nonatomic, weak) _Nullable id delegate;

@property (nonatomic, assign, readonly) YWAlertPublicFootStyle footStyle;
@property (nonatomic, assign, readonly) YWAlertPublicBodyStyle bodyStyle;


- (instancetype _Nullable )initWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message
                     delegate:(id _Nullable )delegate
                    footStyle:(YWAlertPublicFootStyle)footStyle
                    bodyStyle:(YWAlertPublicBodyStyle)bodyStyle
            cancelButtonTitle:(nullable NSString *)cancelButtonTitle
            otherButtonTitles:(nullable NSArray <NSString *> *)otherButtonTitles
                      handler:(nullable void(^)(NSInteger buttonIndex,
                                                id _Nullable value))handler;
@end
