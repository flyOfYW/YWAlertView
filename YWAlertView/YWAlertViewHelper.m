//
//  YWAlertViewHelper.m
//  YWAlertViewDemo
//
//  Created by yaowei on 2018/8/30.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "YWAlertViewHelper.h"

@implementation YWAlertViewHelper

//MARK: --- 跟控制器相关
+ (UIViewController*)currentViewController {
    UIViewController* rootViewController = [self getWindow].rootViewController;
    return [self currentViewControllerFrom:rootViewController];
}
// 通过递归拿到当前控制器
+ (UIViewController*)currentViewControllerFrom:(UIViewController*)viewController {
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController *)viewController;
        // 如果传入的控制器是导航控制器,则返回最后一个
        return [self currentViewControllerFrom:navigationController.viewControllers.lastObject];
    }else if([viewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController* tabBarController = (UITabBarController *)viewController;
        // 如果传入的控制器是tabBar控制器,则返回选中的那个
        return [self currentViewControllerFrom:tabBarController.selectedViewController];
    }else if(viewController.presentedViewController != nil) {
        // 如果传入的控制器发生了modal,则就可以拿到modal的那个控制器
        return [self currentViewControllerFrom:viewController.presentedViewController];
    }else {
        return viewController;
    }
    
}

+ (UIWindow *)getWindow{
    UIWindow *window = nil;
    if (@available(iOS 13.0, *))
    {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes.allObjects)
        {
            if (windowScene.activationState == UISceneActivationStateForegroundActive)
            {
                for (UIWindow *w in windowScene.windows) {
                    if (w.isKeyWindow) {
                        window = w;
                        break;
                    }
                }
                break;
            }
        }
        if (!window) {
            window = [UIApplication sharedApplication].delegate.window;
        }
    }else{
        window = [UIApplication sharedApplication].delegate.window;
    }
    return window;
}

@end
