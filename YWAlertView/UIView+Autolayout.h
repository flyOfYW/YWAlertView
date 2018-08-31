//
//  UIView+Autolayout.h
//  YWAlertViewDemo
//
//  Created by yaowei on 2018/8/27.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Autolayout)
-(void)addConstraint:(NSLayoutAttribute)attribute equalTo:(UIView *)to offset:(CGFloat)offset;

-(void)addConstraint:(NSLayoutAttribute)attribute equalTo:(UIView *)to toAttribute:(NSLayoutAttribute)toAttribute offset:(CGFloat)offset;
- (void)removeAllAutoLayout;
- (void)removeAutoLayout:(NSLayoutConstraint *)constraint;

- (NSLayoutConstraint *)getAutoLayoutByIdentifier:(NSString *)identifier;

@end
