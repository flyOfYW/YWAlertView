//
//  YWTheme.m
//  YWAlertViewDemo
//
//  Created by yaowei on 2018/8/29.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "YWTheme.h"

@implementation YWTheme
- (UIColor *)alertTitleViewColor{
   return [UIColor greenColor];
}
- (UIColor *)alertCancelColor{
    return [UIColor redColor];
}
- (UIImage *)alertBackgroundView{
    return [UIImage imageNamed:@"105459445"];
}
- (CGFloat)alterBackgroundViewArticulation{
    return 0.5;
}
- (NSString *)alertMessageFontWithName{
    return @"AmericanTypewriter";
}
- (NSString *)alertTitleFontWithName{
    return @"Baskerville-SemiBoldItalic";
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
