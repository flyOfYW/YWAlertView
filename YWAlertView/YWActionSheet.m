//
//  YWActionSheet.m
//  YWAlertViewDemo
//
//  Created by yaowei on 2018/8/30.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "YWActionSheet.h"
#import "YWAlertViewHelper.h"
#import "UIView+Autolayout.h"

static const float btnHeight = 45;



@interface YWActionSheet ()
{
    CGFloat _alterWidth;
    //装lineView的集合(包括所有的lineView)
    NSMutableArray *_lineList;
    //装body上下的两个lineView;
    NSMutableArray *_bodyLineList;
    //    alertView的背景view
    UIImageView *_backgroundAlterView;
    BOOL _isModal;
    UIColor *_backgroundColor;
    UIView *_upperView;//上部分
    CGFloat _bottomValue;//距离底部的值
    CGFloat _boundsHeight;
    NSInteger _isNeedLayout;//0-默认，没有开始布局，1-已经布局过，由于设置message，需要重新刷新布局，2-布局已完成
}
//sheet的容器
@property (nonatomic, strong) UIView *sheetView;
//蒙层
@property (nonatomic, strong) UIView *maskView;
//高斯模糊的背景图
@property (nonatomic, strong) UIImageView *gaussianBlurOnMaskView;
//标题的view
@property (nonatomic, strong) UIView *titleView;
//标题
@property (nonatomic, strong) UILabel *titleLabel;
//描述的容器
@property (nonatomic, strong) UIView *messageContainerView;
//描述
@property (nonatomic, strong) UILabel *messageLabel;
//其他按钮的容器
@property (nonatomic, strong) UIView *otherContainerView;
//取消按钮的容器
@property (nonatomic, strong) UIView *cancelContainerView;
//取消按钮
@property (nonatomic, strong) UIButton *cancelBtn;
//按钮的集合
@property (nonatomic, strong) NSMutableArray *buttionList;

@property (nonatomic, copy) void(^handler)(NSInteger buttonIndex,id value);

@end

@implementation YWActionSheet

- (instancetype _Nullable )initWithTitle:(nullable NSString *)title
                                 message:(nullable NSString *)message
                                delegate:(id _Nullable )delegate
                               footStyle:(YWAlertPublicFootStyle)footStyle
                               bodyStyle:(YWAlertPublicBodyStyle)bodyStyle
                       cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                       otherButtonTitles:(nullable NSArray <NSString *> *)otherButtonTitles
                                 handler:(nullable void(^)(NSInteger buttonIndex,
                                                           id _Nullable value))handler{
    
    UIView *currentView = [YWAlertViewHelper currentViewController].view;
    self = [super initWithFrame:currentView.frame];
    
    if (!self) {
        return nil;
    }
    
    _handler = handler;
    _delegate = delegate;
    _bodyLineList = @[].mutableCopy;
    _lineList = @[].mutableCopy;
    _buttionList = @[].mutableCopy;
    
    //蒙层及其背景
    self.maskView.frame = currentView.frame;
    [self addSubview:_maskView];
    self.gaussianBlurOnMaskView.frame = currentView.frame;
    [_maskView addSubview:self.gaussianBlurOnMaskView];
    
    //整个sheet
    //    UIView *sheet = [[UIView alloc] initWithFrame:CGRectMake(0, currentView.frame.size.height,currentView.frame.size.width, 300)];
    UIView *sheet = [[UIView alloc] initWithFrame:CGRectMake(0, currentView.frame.size.height,currentView.frame.size.width, 300)];
    
    sheet.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    sheet.backgroundColor = [UIColor clearColor];
    self.sheetView = sheet;
    [self addSubview:sheet];
    
    [self onPrepareTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles frame:currentView.frame];
    
    return self;
}
//MARK: ---------------------- show&hdien ----------------------------
- (void)show{
    
    UIWindow *keyWindows = [YWAlertViewHelper getWindow];
    _boundsHeight = keyWindows.bounds.size.height;
    [keyWindows addSubview:self];
    _isModal = NO;
    
    [self addConstraint:NSLayoutAttributeLeft equalTo:keyWindows offset:0];
    [self addConstraint:NSLayoutAttributeRight equalTo:keyWindows offset:0];
    [self addConstraint:NSLayoutAttributeTop equalTo:keyWindows offset:0];
    [self addConstraint:NSLayoutAttributeBottom equalTo:keyWindows offset:0];
    
    if (_isNeedLayout == 0) {
        [self layoutIfNeeded];
    }else if(_isNeedLayout == 1){
        [self layoutIfNeeded];
    }
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.7 animations:^{
        
        CGRect sheetFrame = weakSelf.sheetView.frame;
        
        sheetFrame.origin.y = keyWindows.bounds.size.height - sheetFrame.size.height;
        
        weakSelf.sheetView.frame = sheetFrame;
        
    } completion:^(BOOL finished) {
        
    }];
    
}
- (void)showOnViewController{
    [self show];
}
/**
 配合懒加载，即时即地show的时候，回调
 
 @param handler 回调
 */
- (void)showWindowWithHandler:(nullable void(^)(NSInteger buttonIndex,id _Nullable value))handler{
    _handler = handler;
    [self show];
}
- (void)hiddenAlertView{
    
    __weak typeof(self)weakSelf = self;
    
    CGRect frame = self.sheetView.frame;
    
    frame.origin.y = _boundsHeight;
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:0 animations:^{
        weakSelf.sheetView.frame = frame;
        weakSelf.maskView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        weakSelf.maskView.alpha = 1;
    }];
}
//MARK: ---------------------- action ------------------------------------
- (void)buttionClick:(UIButton *)btn{
    [self hiddenAlertView];
    if (_handler) {
        _handler(btn.tag - 100,btn.titleLabel.text);
    }
    if (_delegate && [_delegate respondsToSelector:@selector(didClickAlertView:value:)]) {
        [_delegate didClickAlertView:btn.tag - 100 value:btn.titleLabel.text];
    }
}

//MARK: --------------------- private method ------------------------
//准备布局
- (void)onPrepareTitle:(nullable NSString *)title
               message:(nullable NSString *)message
     cancelButtonTitle:(nullable NSString *)cancelButtonTitle
     otherButtonTitles:(nullable NSArray <NSString *> *)otherButtonTitles
                 frame:(CGRect)frame{
    
    _backgroundColor = [UIColor whiteColor];
    
    _upperView = [UIView new];
    _upperView.backgroundColor = [UIColor clearColor];
    _upperView.layer.cornerRadius = 15;
    _upperView.layer.masksToBounds = YES;
    [self.sheetView addSubview:_upperView];
    
    [_upperView addConstraint:NSLayoutAttributeLeft equalTo:self.sheetView offset:10];
    [_upperView addConstraint:NSLayoutAttributeRight equalTo:self.sheetView offset:-10];
    [_upperView addConstraint:NSLayoutAttributeTop equalTo:self.sheetView offset:0];
    
    //头部设置
    _titleView = [UIView new];
    _titleView.backgroundColor = [UIColor whiteColor];
    [_upperView addSubview:_titleView];
    
    [_titleView addConstraint:NSLayoutAttributeLeft equalTo:_upperView offset:0];
    [_titleView addConstraint:NSLayoutAttributeRight equalTo:_upperView offset:0];
    [_titleView addConstraint:NSLayoutAttributeTop equalTo:_upperView offset:0];
    
//    if (title && title.length > 0) {
        _titleView.backgroundColor = [UIColor whiteColor];
     if (title && title.length > 0) {
         self.titleLabel.text = [NSString stringWithFormat:@"\r\n%@\r\n",title];
     }
//        self.titleLabel.text = title;
        [_titleView addSubview:self.titleLabel];
        
        [self.titleLabel addConstraint:NSLayoutAttributeLeft equalTo:_titleView offset:10];
        [self.titleLabel addConstraint:NSLayoutAttributeRight equalTo:_titleView offset:-10];
//        [self.titleLabel addConstraint:NSLayoutAttributeTop equalTo:_titleView offset:14];
        [self.titleLabel addConstraint:NSLayoutAttributeTop equalTo:_titleView offset:0];
        
        UIView *lineTop = [UIView new];
        lineTop.backgroundColor = DefaultLineTranslucenceColor;
        [_titleView addSubview:lineTop];
        [_bodyLineList addObject:lineTop];
        
        [lineTop addConstraint:NSLayoutAttributeLeft equalTo:_titleView offset:0];
        [lineTop addConstraint:NSLayoutAttributeRight equalTo:_titleView offset:0];
        [lineTop addConstraint:NSLayoutAttributeBottom equalTo:_titleView offset:0];
        [lineTop addConstraint:NSLayoutAttributeHeight equalTo:nil offset:1];

        [_titleView addConstraint:NSLayoutAttributeHeight equalTo:self.titleLabel offset:1];
    
//        [_titleView addConstraint:NSLayoutAttributeHeight equalTo:self.titleLabel offset:28+1];
    
//    }else{
//        [_titleView addConstraint:NSLayoutAttributeHeight equalTo:nil offset:0];
//    }
    
    //message设置
    _messageContainerView = [UIView new];
    _messageContainerView.backgroundColor = [UIColor whiteColor];
    [_upperView addSubview:_messageContainerView];
    
    [_messageContainerView addConstraint:NSLayoutAttributeLeft equalTo:_upperView offset:0];
    [_messageContainerView addConstraint:NSLayoutAttributeRight equalTo:_upperView offset:0];
    [_messageContainerView addConstraint:NSLayoutAttributeTop equalTo:_titleView toAttribute:NSLayoutAttributeBottom offset:0];
    [_messageContainerView addSubview:self.messageLabel];
    
    [self.messageLabel addConstraint:NSLayoutAttributeLeft equalTo:_messageContainerView offset:10];
    [self.messageLabel addConstraint:NSLayoutAttributeRight equalTo:_messageContainerView offset:-10];
    [self.messageLabel addConstraint:NSLayoutAttributeTop equalTo:_messageContainerView offset:0];
    
    UIView *lineMsg = [UIView new];
    lineMsg.backgroundColor = DefaultLineTranslucenceColor;
    [_messageContainerView addSubview:lineMsg];
    [_bodyLineList addObject:lineMsg];
    
    [lineMsg addConstraint:NSLayoutAttributeLeft equalTo:_messageContainerView offset:0];
    [lineMsg addConstraint:NSLayoutAttributeRight equalTo:_messageContainerView offset:0];
    [lineMsg addConstraint:NSLayoutAttributeBottom equalTo:_messageContainerView offset:0];
    [lineMsg addConstraint:NSLayoutAttributeHeight equalTo:nil offset:1];
    
    if (message) {
        self.messageLabel.text = [NSString stringWithFormat:@"\r\n%@\r\n",message];
    }
    [_messageContainerView addConstraint:NSLayoutAttributeHeight equalTo:self.messageLabel offset:1];

    
    //other设置
    _otherContainerView = [UIView new];
    _otherContainerView.backgroundColor = [UIColor whiteColor];
    [_upperView addSubview:_otherContainerView];
    
    [_otherContainerView addConstraint:NSLayoutAttributeLeft equalTo:_upperView offset:0];
    [_otherContainerView addConstraint:NSLayoutAttributeRight equalTo:_upperView offset:0];
    [_otherContainerView addConstraint:NSLayoutAttributeTop equalTo:_messageContainerView toAttribute:NSLayoutAttributeBottom offset:0];
    
    
    if (otherButtonTitles.count) {
        
        [_otherContainerView addConstraint:NSLayoutAttributeHeight equalTo:nil offset:btnHeight * otherButtonTitles.count + otherButtonTitles.count - 1];
        [_otherContainerView layoutIfNeeded];
        [self createOtherButtion:otherButtonTitles width:CGRectGetWidth(_otherContainerView.frame) height:btnHeight];
        
    }else{
        [_otherContainerView addConstraint:NSLayoutAttributeHeight equalTo:nil offset:0];
        
    }
    
    [_upperView addConstraint:NSLayoutAttributeBottom equalTo:_otherContainerView toAttribute:NSLayoutAttributeBottom offset:0];
    
    
    if (cancelButtonTitle && cancelButtonTitle.length > 0) {
        
        [self.sheetView addSubview:self.cancelContainerView];
        [self.cancelBtn setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [self.cancelContainerView addSubview:self.cancelBtn];
        
        [_cancelContainerView addConstraint:NSLayoutAttributeLeft equalTo:self.sheetView offset:10];
        [_cancelContainerView addConstraint:NSLayoutAttributeRight equalTo:self.sheetView offset:-10];
        
        [_cancelContainerView addConstraint:NSLayoutAttributeHeight equalTo:nil offset:btnHeight];
        
        [_cancelContainerView addConstraint:NSLayoutAttributeTop equalTo:_upperView toAttribute:NSLayoutAttributeBottom offset:10];
        
        [_cancelBtn addConstraint:NSLayoutAttributeLeft equalTo:self.cancelContainerView offset:0];
        [_cancelBtn addConstraint:NSLayoutAttributeRight equalTo:self.cancelContainerView offset:0];
        [_cancelBtn addConstraint:NSLayoutAttributeTop equalTo:self.cancelContainerView offset:0];
        [_cancelBtn addConstraint:NSLayoutAttributeBottom equalTo:self.cancelContainerView offset:0];
        
        _bottomValue = 10;
    }
    
    if (kDevice_Is_iPhoneX || kDevice_Is_iPhoneXR
        || kDevice_Is_iPhoneXS || kDevice_Is_iPhoneXS_MAX) {
        _bottomValue += 10;
    }
    
}

- (void)setSheetFrame{
    
    CGFloat heigth = CGRectGetHeight(self.titleView.frame) + CGRectGetHeight(self.messageContainerView.frame) + CGRectGetHeight(self.otherContainerView.frame) + CGRectGetHeight(self.cancelContainerView.frame) + 10 + _bottomValue;
    
    CGRect rect = self.sheetView.frame;
    rect.size.height = heigth;
    self.sheetView.frame = rect;
    _isNeedLayout = 2;
}

- (void)createOtherButtion:(NSArray <NSString *>*)otherButtonTitles
                     width:(CGFloat)width
                    height:(CGFloat)height{
    int i = 0;
    for (NSString *titles in otherButtonTitles) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, i * (height + 1), width, height);
        btn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        btn.tag = 101 + i;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:titles forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttionClick:) forControlEvents:UIControlEventTouchUpInside];
        [_otherContainerView addSubview:btn];
        [_buttionList addObject:btn];
        if (i != otherButtonTitles.count - 1) {
            UIView *lineTop = [UIView new];
            lineTop.frame = CGRectMake(0, CGRectGetMaxY(btn.frame), width, 1);
            lineTop.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            lineTop.backgroundColor = DefaultLineTranslucenceColor;
            [_otherContainerView addSubview:lineTop];
            [_lineList addObject:lineTop];
        }
        
        i ++;
    }
    
}


//MARK: ---------------------- 配置信息 ------------------------------------
- (void)setMessageFontWithName:(NSString *)name size:(CGFloat)size{
    if (name) {
        _messageLabel.font = [UIFont fontWithName:name size:size];
    }else{
        _messageLabel.font = [UIFont systemFontOfSize:size];
    }
}
- (void)setTitleFontWithName:(NSString *)name size:(CGFloat)size{
    if (name) {
        _titleLabel.font = [UIFont fontWithName:name size:size];
    }else{
        _titleLabel.font = [UIFont systemFontOfSize:size];
    }
}
- (void)hiddenBodyLineView{
    
    for (UIView *line in _bodyLineList) {
        line.hidden = YES;
    }
}
- (void)hiddenAllLineView{
    for (UIView *line in _lineList) {
        line.hidden = YES;
    }
    [self hiddenBodyLineView];
}

- (void)setAlertViewBackgroundColor:(UIColor *)color{
    if (_upperView) {
        _upperView.backgroundColor = color;
    }
}
- (void)setTitleViewBackColor:(UIColor *)color{
    _titleView.backgroundColor = color;
}
- (void)setTitleViewTitleColor:(UIColor *)color{
    _titleLabel.textColor = color;
}
- (void)setMessageTitleColor:(UIColor *)color{
    _messageLabel.textColor = color;
}
- (void)setAllButtionTitleColor:(UIColor *)color{
    
    for (UIButton *btn in _buttionList) {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
}
- (void)setButtionTitleColor:(UIColor *)color index:(NSInteger)index{
    if (index == 0) {
        [_cancelBtn setTitleColor:color forState:index];
    }else{
        UIButton *btn = [_otherContainerView viewWithTag:101+index];
        [btn setTitleColor:color forState:index];
    }
}
- (void)setButtionTitleFontWithName:(NSString *)name
                               size:(CGFloat)size
                              index:(NSInteger)index{
    
    if (name) {
        if (index == 0) {
            _cancelBtn.titleLabel.font = [UIFont fontWithName:name size:size];
        }else{
            UIButton *btn = [_otherContainerView viewWithTag:101+index];
            btn.titleLabel.font = [UIFont fontWithName:name size:size];
        }
    }else{
        if (index == 0) {
            _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:size];
        }else{
            UIButton *btn = [_otherContainerView viewWithTag:101+index];
            btn.titleLabel.font = [UIFont systemFontOfSize:size];
        }
    }
}

/**
 设置蒙版的背景图
 
 @param image 蒙版的背景图（可使用高斯的image）
 */
- (void)setGaussianBlurImage:(UIImage *)image{
    self.gaussianBlurOnMaskView.hidden = NO;
    self.gaussianBlurOnMaskView.image = image;
}

/**
 修改tiele
 
 @param title 提示名称
 */
- (void)resetAlertTitle:(NSString *)title{
    if (title) {
        self.titleLabel.text = [NSString stringWithFormat:@"\r\n%@\r\n",title];
    }else{
        self.titleLabel.text = nil;
    }
    if (_isNeedLayout == 2) {
        _isNeedLayout = 1;
    }
}
/**
 修改message信息，高度也会跟着适配
 
 @param message 信息
 */
- (void)resetAlertMessage:(NSString *)message{
    if (message) {
        self.messageLabel.text = [NSString stringWithFormat:@"\r\n%@\r\n",message];
    }else{
        self.messageLabel.text = nil;
    }
    if (_isNeedLayout == 2) {
        _isNeedLayout = 1;
    }
}
/**
 统一配置信息
 
 @param theme 主题
 */
- (void)setTheme:(id<YWAlertViewThemeProtocol>)theme{
    
    if ([theme respondsToSelector:@selector(alertBackgroundView)]) {
        NSLog(@"***********暂时不支持");
    }
    if ([theme respondsToSelector:@selector(alterBackgroundViewArticulation)]) {
        NSLog(@"***********暂时不支持");
    }
    if ([theme respondsToSelector:@selector(alertBackgroundColor)]) {
        [self setAlertViewBackgroundColor:[theme alertBackgroundColor]];
    }
    if ([theme respondsToSelector:@selector(alertTitleViewColor)]) {
        [self setTitleViewBackColor:[theme alertTitleViewColor]];
    }
    if ([theme respondsToSelector:@selector(alertCancelColor)]) {
        UIColor *color = [theme alertCancelColor];
        _cancelBtn.backgroundColor = color;
    }
    
    CGFloat alp1 = 16;
    if ([theme respondsToSelector:@selector(alertTitleFont)]) {
        alp1 = [theme alertTitleFont];
    }
    if ([theme respondsToSelector:@selector(alertTitleFontWithName)]) {
        [self setTitleFontWithName:[theme alertTitleFontWithName] size:alp1];
    }else{
        [self setTitleFontWithName:nil size:alp1];
    }
    CGFloat alp2 = 14;
    if ([theme respondsToSelector:@selector(alertMessageFont)]) {
        alp2 = [theme alertMessageFont];
    }
    if ([theme respondsToSelector:@selector(alertMessageFontWithName)]) {
        [self setMessageFontWithName:[theme alertMessageFontWithName] size:alp2];
    }else{
        [self setMessageFontWithName:nil size:alp2];
    }
    
}
//MARK: ----------------------------- getter & setter ----------------------------------
- (UIView *)cancelContainerView{
    if (!_cancelContainerView) {
        _cancelContainerView = [UIView new];
    }
    return _cancelContainerView;
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.tag = 100;
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        [_cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(buttionClick:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.layer.cornerRadius = 10;
        _cancelBtn.layer.masksToBounds = YES;
    }
    return _cancelBtn;
}
- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectZero];
        _maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _maskView.backgroundColor = [UIColor colorWithRed:10 / 255.0 green:10 / 255.0 blue:10 / 255.0 alpha:0.5];
    }
    return _maskView;
}
- (UIImageView *)gaussianBlurOnMaskView{
    if (!_gaussianBlurOnMaskView) {
        _gaussianBlurOnMaskView = [UIImageView new];
        _gaussianBlurOnMaskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _gaussianBlurOnMaskView.hidden = YES;
    }
    return _gaussianBlurOnMaskView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}
- (UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [UILabel new];
        [_messageLabel setLineBreakMode:NSLineBreakByWordWrapping];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = [UIFont systemFontOfSize:14];
    }
    return _messageLabel;
}

- (void)layoutIfNeeded{
    [super layoutIfNeeded];
    [self setSheetFrame];
}
- (void)dealloc{
    NSLog(@"%s",__func__);
    _sheetView = nil;
    _maskView = nil;
    _gaussianBlurOnMaskView = nil;
    _titleView = nil;
    _titleLabel = nil;
    _messageContainerView = nil;
    _messageLabel = nil;
    _otherContainerView = nil;
    _cancelContainerView = nil;
    _cancelBtn = nil;
    _buttionList = nil;
    _lineList = nil;
    _bodyLineList = nil;
    _backgroundAlterView = nil;
    _backgroundColor = nil;
    _upperView = nil;
    
    
}
@end
