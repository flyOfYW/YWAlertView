//
//  YWAlertView.h
//  YWAlertViewDemo
//
//  Created by yaowei on 2018/8/28.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YWAlertViewProtocol.h"

typedef NS_ENUM(NSInteger, YWAlertViewStyle){
    YWAlertViewStyleAlert = 0,
    YWAlertViewStyleActionSheet = 1,
    YWAlertViewStyleDatePicker = 2,//datePicker默认在中间显示
    YWAlertViewStyleDatePicker2 = 3,//datePicke显示在底部
};

@interface YWAlertView : NSObject

/**
 创建并弹出使用代理监听点击事件的

 @param title 标题
 @param message 提示内容
 @param delegate 委托代理
 @param preferredStyle 弹框的样式
 @param footStyle footView的样式
 @param bodyStyle messageView的样式
 @param cancelButtonTitle 取消按钮的标题
 @param otherButtonTitles 其他按钮的标题
 @return 弹框的对象
 */
+(nullable id<YWAlertViewProtocol>)alertViewWithTitle:(nullable NSString *)title
                                              message:(nullable NSString *)message
                                             delegate:(nullable id<YWAlertViewDelegate>)delegate
                                       preferredStyle:(YWAlertViewStyle)preferredStyle
                                            footStyle:(YWAlertPublicFootStyle)footStyle
                                            bodyStyle:(YWAlertPublicBodyStyle)bodyStyle
                                    cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                    otherButtonTitles:(nullable NSArray *)otherButtonTitles;

/**
 创建并弹出使用block监听点击事件的
 
 @param title 标题
 @param message 提示内容
 @param preferredStyle 弹框的样式
 @param footStyle footView的样式
 @param bodyStyle messageView的样式
 @param cancelButtonTitle 取消按钮的标题
 @param otherButtonTitles 其他按钮的标题
 @param handler blcok
 @return 弹框的对象
 */
+(nullable id<YWAlertViewProtocol>)alertViewWithTitle:(nullable NSString *)title
                                              message:(nullable NSString *)message
                                       preferredStyle:(YWAlertViewStyle)preferredStyle
                                            footStyle:(YWAlertPublicFootStyle)footStyle
                                            bodyStyle:(YWAlertPublicBodyStyle)bodyStyle
                                    cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                    otherButtonTitles:(nullable NSArray *)otherButtonTitles handler:(nullable void(^)(NSInteger buttonIndex,id _Nullable value))handler;

/**
 快速调用datePicker使用block回调

 @param title 标题（可选）
 @param preferredStyle dataPicker的显示位置，默认YWAlertViewStyleDatePicker（中间）
 @param footStyle footView的样式
 @param bodyStyle 日历格式的样式
 @param cancelButtonTitle  取消按钮的标题
 @param sureButtonTitles 其他按钮的标题
 @param handler blcok
 @return 弹框的对象
 */
+(nullable id<YWAlertViewProtocol>)alertViewWithTitle:(nullable NSString *)title
                                       preferredStyle:(YWAlertViewStyle)preferredStyle
                                            footStyle:(YWAlertPublicFootStyle)footStyle
                                            bodyStyle:(YWAlertPublicBodyStyle)bodyStyle
                                    cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                    sureButtonTitles:(nullable NSString *)sureButtonTitles handler:(nullable void(^)(NSInteger buttonIndex,id _Nullable value))handler;

/**
  快速调用datePicker使用delegate回调

 @param title 标题（可选）
 @param preferredStyle dataPicker的显示位置，默认YWAlertViewStyleDatePicker（中间）
 @param delegate 委托代理
 @param footStyle footView的样式
 @param bodyStyle 日历格式的样式
 @param cancelButtonTitle 取消按钮的标题
 @param sureButtonTitles 其他按钮的标题
 @return 弹框的对象
 */
+(nullable id<YWAlertViewProtocol>)alertViewWithTitle:(nullable NSString *)title
                                       preferredStyle:(YWAlertViewStyle)preferredStyle
                                             delegate:(nullable id<YWAlertViewDelegate>)delegate
                                            footStyle:(YWAlertPublicFootStyle)footStyle
                                            bodyStyle:(YWAlertPublicBodyStyle)bodyStyle
                                    cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                     sureButtonTitles:(nullable NSString *)sureButtonTitles;


@end
