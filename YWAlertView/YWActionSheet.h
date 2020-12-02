//
//  YWActionSheet.h
//  YWAlertViewDemo
//
//  Created by yaowei on 2018/8/30.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWAlertViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@interface YWActionSheet : UIView <YWAlertActionSheetViewProtocol>

@property (nonatomic, weak) _Nullable id delegate;

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

@interface YWActionSheetButtion : UIView
- (instancetype)initWithTitle:(NSString *)title;
@end
NS_ASSUME_NONNULL_END
