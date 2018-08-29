//
//  UIImage+YW.h
//  YWAlertViewDemo
//
//  Created by yaowei on 2018/8/29.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YW)
/// 获取屏幕截图
///
/// @return 屏幕截图图像
+ (UIImage *)yw_screenShot;
+ (UIImage *)yw_blurImage:(UIImage *)image blur:(CGFloat)blur;
@end
