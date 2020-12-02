//
//  YWAlertViewHelper.h
//  YWAlertViewDemo
//
//  Created by yaowei on 2018/8/30.
//  Copyright © 2018年 yaowei. All rights reserved.
//


#define YWAlertScreenW [UIScreen mainScreen].bounds.size.width
#define YWAlertScreenH [UIScreen mainScreen].bounds.size.height

//判断是否是刘海屏
#define IS_LIU_HAI_SCREEN ({\
BOOL isBangsScreen = NO; \
if (@available(iOS 11.0, *)) { \
UIWindow *window = [[UIApplication sharedApplication].windows firstObject]; \
isBangsScreen = window.safeAreaInsets.bottom > 0; \
} \
isBangsScreen; \
})

//刘海屏底部的高度
#define kDevice_TABBARBOTTOM ({\
CGFloat isBangsScreen = 0; \
if (@available(iOS 11.0, *)) { \
UIWindow *window = [[UIApplication sharedApplication].windows firstObject]; \
isBangsScreen = window.safeAreaInsets.bottom; \
} \
isBangsScreen; \
})





//#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

#define DefaultTranslucenceColor [UIColor colorWithRed:255 / 255.0f green:255 / 255.0 blue:255 / 255.0 alpha:0.98]
#define DefaultLineTranslucenceColor [UIColor colorWithRed:219 / 255.0f green:219 / 255.0 blue:219 / 255.0 alpha:0.7]

static const float titleViewHeight = 40;
static const float butttionViewHeight = 40;


#import <UIKit/UIKit.h>

@interface YWAlertViewHelper : UIView
+ (UIViewController*)currentViewController;
// 通过递归拿到当前控制器
+ (UIViewController*)currentViewControllerFrom:(UIViewController*)viewController;
+ (UIWindow *)getWindow;
@end
