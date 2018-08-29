//
//  UIColor+YW.m
//  YWAlertViewDemo
//
//  Created by yaowei on 2018/8/29.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "UIColor+YW.h"

@implementation UIColor (YW)
- (uint32_t)rgbaValue {
    CGFloat r = 0, g = 0, b = 0, a = 0;
    [self getRed:&r green:&g blue:&b alpha:&a];
    int8_t red = r * 255;
    uint8_t green = g * 255;
    uint8_t blue = b * 255;
    uint8_t alpha = a * 255;
    return (red << 24) + (green << 16) + (blue << 8) + alpha;
}
@end
