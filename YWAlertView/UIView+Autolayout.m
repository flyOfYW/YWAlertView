//
//  UIView+Autolayout.m
//  YWAlertViewDemo
//
//  Created by yaowei on 2018/8/27.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "UIView+Autolayout.h"

@implementation UIView (Autolayout)

-(void)addConstraint:(NSLayoutAttribute)attribute equalTo:(UIView *)to offset:(CGFloat)offset{
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:to attribute:attribute multiplier:1.0 constant:offset]];
}

-(NSLayoutConstraint *)addConstraint:(NSLayoutAttribute)attribute equalTo:(UIView *)to offset:(CGFloat)offset identifier:(NSString *)identifier{
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *lay = [NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:to attribute:attribute multiplier:1.0 constant:offset];
    [self.superview addConstraint:lay];
    return lay;
}
-(void)addConstraint:(NSLayoutAttribute)attribute equalTo:(UIView *)to toAttribute:(NSLayoutAttribute)toAttribute offset:(CGFloat)offset{
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:to attribute:toAttribute multiplier:1.0 constant:offset]];
}
- (void)removeAllAutoLayout{
    for (NSLayoutConstraint *con in self.constraints)
    {
        [self removeConstraint:con];
    }
}

- (void)removeAutoLayout:(NSLayoutConstraint *)constraint{
    for (NSLayoutConstraint *con in self.superview.constraints) {
        if ([con isEqual:constraint]) {
            [self.superview removeConstraint:con];
        }
    }
}
- (NSLayoutConstraint *)getAutoLayoutByIdentifier:(NSString *)identifier{
    NSLayoutConstraint *lay = nil;
    for (NSLayoutConstraint *con in self.constraints)
    {
        if ([con.identifier isEqualToString:identifier]) {
            lay = con;
            break;
        }
    }
    return lay;
}

@end
