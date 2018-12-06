//
//  YWAddressPicker.h
//  YWAlertViewDemo
//
//  Created by yaowei on 2018/12/5.
//  Copyright © 2018 yaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWAlertViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface YWAddressPicker : UIView <YWAlertAddressPickerViewProtocol>
@property (nonatomic, weak) _Nullable id delegate;
- (instancetype _Nullable)initWithTitle:(nullable NSString *)title
                               delegate:(id _Nullable)delegate
                              bodyStyle:(YWAlertPublicBodyStyle)bodyStyle
                      cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                         okButtonTitles:(nullable NSString *)sureButtonTitles
                                handler:(nullable void(^)(NSInteger buttonIndex,
                                                          id _Nullable value))handler;
@end

NS_ASSUME_NONNULL_END
