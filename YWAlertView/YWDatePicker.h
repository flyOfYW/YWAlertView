//
//  YWDatePicker.h
//  YWAlertViewDemo
//
//  Created by yaowei on 2018/8/31.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWAlertViewProtocol.h"

@interface YWDatePicker : UIView <YWAlertViewProtocol>
@property (nonatomic, weak) _Nullable id delegate;

- (instancetype _Nullable)initWithTitle:(nullable NSString *)title
                     delegate:(id _Nullable)delegate
                    footStyle:(YWAlertPublicFootStyle)footStyle
                    bodyStyle:(YWAlertPublicBodyStyle)bodyStyle
                         mode:(NSInteger)mode//扩展date具体位置
            cancelButtonTitle:(nullable NSString *)cancelButtonTitle
               okButtonTitles:(nullable NSString *)sureButtonTitles
                      handler:(nullable void(^)(NSInteger buttonIndex,
                                                id _Nullable value))handler;
@end
