//
//  YWAlert.m
//  YWAlertViewDemo
//
//  Created by yaowei on 2018/8/27.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#define YWAlertScreenW [UIScreen mainScreen].bounds.size.width
#define YWAlertScreenH [UIScreen mainScreen].bounds.size.height

#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)


// 判断是否是iPhone X
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

#define DefaultTranslucenceColor [UIColor colorWithRed:255 / 255.0f green:255 / 255.0 blue:255 / 255.0 alpha:0.98]
#define DefaultLineTranslucenceColor [UIColor colorWithRed:219 / 255.0f green:219 / 255.0 blue:219 / 255.0 alpha:0.7]


static const float btnHeight = 40;
static const float titleHeight = 40;


#import "YWAlert.h"
#import "UIView+Autolayout.h"
#import "YWContainerViewController.h"
#import "UIColor+YW.h"

@interface YWAlert ()
{
    CGFloat _alterWidth;
    //装lineView的集合(包括所有的lineView)
    NSMutableArray *_lineList;
    //装body上下的两个lineView;
    NSMutableArray *_bodyLineList;
    UIView *_lineBoad;
    NSLayoutConstraint *_lay;
//    alertView的背景view
    UIImageView *_backgroundAlterView;
    BOOL _isModal;
    UIColor *_backgroundColor;
}
//alter的容器
@property (nonatomic, strong) UIView *alertView;
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
//按钮的容器
@property (nonatomic, strong) UIView *btnContainerView;
//关闭按钮
@property (nonatomic, strong) UIButton *closeBtn;
//取消按钮
@property (nonatomic, strong) UIButton *cancelBtn;
//按钮的集合
@property (nonatomic, strong) NSMutableArray *buttionList;

@property (nonatomic, copy) void(^handler)(NSInteger buttonIndex,id value);

@end


@implementation YWAlert


- (instancetype)initWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message
                     delegate:(id<YWAlertViewDelegate>)delegate
                    footStyle:(YWAlertPublicFootStyle)footStyle
                    bodyStyle:(YWAlertPublicBodyStyle)bodyStyle
            cancelButtonTitle:(nullable NSString *)cancelButtonTitle
            otherButtonTitles:(nullable NSArray <NSString *> *)otherButtonTitles
                      handler:(nullable void(^)(NSInteger buttonIndex,
                                                 id value))handler{
    
    UIView *currentView = [YWAlert currentViewController].view;
    self = [super initWithFrame:currentView.frame];
    
    if (!self) {
        return nil;
    }
    _lineList = @[].mutableCopy;
    _bodyLineList = @[].mutableCopy;
    _handler = handler;
    _footStyle = footStyle;
    _bodyStyle = bodyStyle;
    _delegate = delegate;
    _backgroundColor = DefaultTranslucenceColor;
    if (IS_PAD) {
        _alterWidth = 300;
    }else{//其他做iPhone处理
        if (kDevice_Is_iPhone6Plus) {
            _alterWidth = 290;
        }else if (kDevice_Is_iPhoneX){
            _alterWidth = 280;
        }else if (kDevice_Is_iPhone6){
            _alterWidth = 270;
        }else{
            _alterWidth = 260;
        }
    }
    self.maskView.frame = currentView.frame;
    [self addSubview:_maskView];
    self.gaussianBlurOnMaskView.frame = currentView.frame;
    [_maskView addSubview:self.gaussianBlurOnMaskView];
    
    [self onPrepareTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];

    return self;
}
//MARK:-- 显示
- (void)show{
    UIWindow *keyWindows = [UIApplication sharedApplication].keyWindow;
    [keyWindows addSubview:self];
    [self addConstraint:NSLayoutAttributeLeft equalTo:keyWindows offset:0];
    [self addConstraint:NSLayoutAttributeRight equalTo:keyWindows offset:0];
    [self addConstraint:NSLayoutAttributeTop equalTo:keyWindows offset:0];
    [self addConstraint:NSLayoutAttributeBottom equalTo:keyWindows offset:0];
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.maskView.backgroundColor = [UIColor colorWithRed:10 / 255.0 green:10 / 255.0 blue:10 / 255.0 alpha:0.4];
        weakSelf.maskView.alpha = 1;
    }];
}
- (void)showOnViewController{
    _isModal = YES;
    YWContainerViewController *conVC = [YWContainerViewController new];
    conVC.alertView = self;
    conVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    conVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[YWAlert currentViewController] presentViewController:conVC animated:YES completion:nil];
    
}

//MARK: --- buttion_Action
- (void)buttionClick:(UIButton *)btn{
    [self hiddenAlertView];
    if (_isModal) {
        [[YWAlert currentViewController] dismissViewControllerAnimated:YES completion:nil];
    }
    if (_handler) {
        _handler(btn.tag - 100,btn.titleLabel.text);
    }
    if (_delegate &&
        [_delegate respondsToSelector:@selector(didClickAlertView:value:)]) {
        [_delegate didClickAlertView:btn.tag - 100 value:btn.titleLabel.text];
    }
}
- (void)hiddenAlertView{
    __weak typeof(self)weakSelf = self;

    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:0 animations:^{
        weakSelf.maskView.alpha = 0.0f;
        weakSelf.alertView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}
//MAKR: --- 准备布局
- (void)onPrepareTitle:(nullable NSString *)title
                 message:(nullable NSString *)message
       cancelButtonTitle:(nullable NSString *)cancelButtonTitle
       otherButtonTitles:(nullable NSArray <NSString *> *)otherButtonTitles{
    
    CGFloat x = (YWAlertScreenW - _alterWidth)/2;
    UIView *alert = [[UIView alloc] initWithFrame:CGRectMake(x, (YWAlertScreenH-300)/2, _alterWidth , 300)];
    alert.backgroundColor = DefaultTranslucenceColor;
    alert.layer.cornerRadius = 15.0f;
    alert.layer.masksToBounds = YES;
    [self addSubview:alert];
    _alertView = alert;

    UIImageView *bgIV = [UIImageView new];
    bgIV.contentMode = UIViewContentModeScaleAspectFill;
    bgIV.backgroundColor = [UIColor redColor];
    bgIV.hidden = YES;
    [alert addSubview:bgIV];
    _backgroundAlterView = bgIV;

    // titleView
    UIView *titleView = self.titleView;
    [alert addSubview:titleView];
    
    [titleView addConstraint:NSLayoutAttributeLeft equalTo:alert offset:0];
    [titleView addConstraint:NSLayoutAttributeRight equalTo:alert offset:0];
    [titleView addConstraint:NSLayoutAttributeTop equalTo:alert offset:0];
    if (title && title.length > 0) {
        [titleView addConstraint:NSLayoutAttributeHeight equalTo:nil offset:titleHeight];
    }else{
        [titleView addConstraint:NSLayoutAttributeHeight equalTo:nil offset:0];
    }
    [titleView layoutIfNeeded];

    [titleView addSubview:self.titleLabel];
    self.titleLabel.text = title;
    UILabel *titleLabel = self.titleLabel;
    [titleLabel addConstraint:NSLayoutAttributeLeft equalTo:_titleView offset:0];
    [titleLabel addConstraint:NSLayoutAttributeRight equalTo:_titleView offset:0];
    [titleLabel addConstraint:NSLayoutAttributeCenterY equalTo:_titleView offset:0];
    [titleLabel layoutIfNeeded];
    
    [titleView addSubview:self.closeBtn];
    [self.closeBtn addConstraint:NSLayoutAttributeRight equalTo:_titleView offset:-10];
    [self.closeBtn addConstraint:NSLayoutAttributeCenterY equalTo:_titleView offset:0];
    [self.closeBtn addConstraint:NSLayoutAttributeHeight equalTo:nil offset:20];
    [self.closeBtn addConstraint:NSLayoutAttributeWidth equalTo:nil offset:20];

    
    UIView *lineTitle = ({
        lineTitle = [UIView new];
        lineTitle.backgroundColor = DefaultLineTranslucenceColor;
        [alert addSubview:lineTitle];
        lineTitle;
    });
    [_bodyLineList addObject:lineTitle];
    
    [lineTitle addConstraint:NSLayoutAttributeLeft equalTo:titleView offset:0];
    [lineTitle addConstraint:NSLayoutAttributeRight equalTo:titleView offset:0];
    [lineTitle addConstraint:NSLayoutAttributeTop equalTo:titleView toAttribute:NSLayoutAttributeBottom offset:0];
    [lineTitle addConstraint:NSLayoutAttributeHeight equalTo:nil offset:1];
    

    // BodyView
    UIView *bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = DefaultTranslucenceColor;
    [alert addSubview:bodyView];
    _messageContainerView = bodyView;
    
    [bodyView addConstraint:NSLayoutAttributeLeft equalTo:alert offset:0];
    [bodyView addConstraint:NSLayoutAttributeRight equalTo:alert offset:0];
    [bodyView addConstraint:NSLayoutAttributeTop equalTo:titleView toAttribute:NSLayoutAttributeBottom  offset:1];
    
    // messageLabel
    if (_bodyStyle == YWAlertPublicBodyStyleDefalut) {
        [self getDefalutBody:bodyView text:message];
    }

    [bodyView layoutIfNeeded];

    
    UIView *lineBoad = ({
        lineBoad = [UIView new];
        lineBoad.backgroundColor = DefaultLineTranslucenceColor;
        [alert addSubview:lineBoad];
        _lineBoad = lineBoad;
        lineBoad;
    });
    [_bodyLineList addObject:lineBoad];


    [lineBoad addConstraint:NSLayoutAttributeLeft equalTo:alert offset:0];
    [lineBoad addConstraint:NSLayoutAttributeRight equalTo:alert offset:0];
    [lineBoad addConstraint:NSLayoutAttributeTop equalTo:bodyView toAttribute:NSLayoutAttributeBottom offset:0];
    [lineBoad addConstraint:NSLayoutAttributeHeight equalTo:nil offset:1];

    
    // BodyView
    UIView *btnView = [[UIView alloc] init];
    btnView.backgroundColor = DefaultTranslucenceColor;

    [alert addSubview:btnView];
    _btnContainerView = btnView;
    
    [btnView addConstraint:NSLayoutAttributeLeft equalTo:alert offset:0];
    [btnView addConstraint:NSLayoutAttributeRight equalTo:alert offset:0];
    [btnView addConstraint:NSLayoutAttributeTop equalTo:lineBoad toAttribute:NSLayoutAttributeBottom offset:0];
    switch (_footStyle) {
        case YWAlertPublicFootStyleDefalut:
            [self getDefalutFootView:otherButtonTitles cancelButtonTitle:cancelButtonTitle];
            break;
        case YWAlertPublicFootStyleVertical:
            [self getVerticalFootView:otherButtonTitles cancelButtonTitle:cancelButtonTitle];
            break;
        case YWAlertPublicFootStyleSegmentation:
            [self getSegmentationFootView:otherButtonTitles cancelButtonTitle:cancelButtonTitle];
            break;
        default:
            break;
    }
   
   //更新alert内部布局约束
    CGFloat alertHeight = CGRectGetHeight(titleView.frame) + 1 + CGRectGetHeight(bodyView.frame) + 1 + CGRectGetHeight(btnView.frame);
    [alert addConstraint:NSLayoutAttributeCenterX equalTo:self offset:0];
    [alert addConstraint:NSLayoutAttributeCenterY equalTo:self offset:0];
    _lay = [alert addConstraint:NSLayoutAttributeHeight equalTo:nil offset:alertHeight identifier:@"alertHeight"];
    
    [alert addConstraint:NSLayoutAttributeWidth equalTo:nil offset:_alterWidth];

    
    [_backgroundAlterView addConstraint:NSLayoutAttributeTop equalTo:alert offset:0];
    [_backgroundAlterView addConstraint:NSLayoutAttributeBottom equalTo:alert offset:0];
    [_backgroundAlterView addConstraint:NSLayoutAttributeLeft equalTo:alert offset:0];
    [_backgroundAlterView addConstraint:NSLayoutAttributeRight equalTo:alert offset:0];

}

- (void)getDefalutBody:(UIView *)bodyView
                  text:(NSString *)text{
    self.messageLabel.text = text;
    [bodyView addSubview:self.messageLabel];

    [self.messageLabel addConstraint:NSLayoutAttributeTop equalTo:bodyView toAttribute:NSLayoutAttributeTop offset:10];
    [self.messageLabel addConstraint:NSLayoutAttributeLeft equalTo:bodyView offset:20];
    [self.messageLabel addConstraint:NSLayoutAttributeRight equalTo:bodyView offset:-20];
    
    [bodyView addConstraint:NSLayoutAttributeHeight equalTo:self.messageLabel offset:20];
    [self.messageLabel layoutIfNeeded];
}


- (void)getSegmentationFootView:(NSArray <NSString *>*)otherButtonTitles
          cancelButtonTitle:(NSString *)cancelButtonTitle{
    
    int count = (int)otherButtonTitles.count;
    
    if ((cancelButtonTitle && cancelButtonTitle.length > 0) || otherButtonTitles.count > 0) {
        
        [_btnContainerView addConstraint:NSLayoutAttributeHeight equalTo:nil offset:btnHeight + 10];
        [_btnContainerView layoutIfNeeded];
        CGFloat startValue = 30;
        CGFloat middleValue = 20;
        if (cancelButtonTitle && cancelButtonTitle.length > 0) {
            UIButton *cancelBtn = self.cancelBtn;
            [cancelBtn setTitle:cancelButtonTitle forState:UIControlStateNormal];
            [_btnContainerView addSubview:cancelBtn];
            [self.buttionList addObject:cancelBtn];
            cancelBtn.backgroundColor = [UIColor redColor];
            [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cancelBtn.clipsToBounds = YES;
            cancelBtn.layer.cornerRadius = 8;

            if (otherButtonTitles.count > 0) {
                CGFloat w = (CGRectGetWidth(_btnContainerView.frame) -  count * middleValue - startValue * 2)/(count+1);
                cancelBtn.frame = CGRectMake(startValue, 5, w, btnHeight);
                [self createSpectOtherBtn:otherButtonTitles originX:CGRectGetMaxX(cancelBtn.frame) + middleValue width:w height:btnHeight value:middleValue];
            }else{
                cancelBtn.frame = CGRectMake(startValue, 5, CGRectGetWidth(_btnContainerView.frame), btnHeight);
            }
        }else{
            CGFloat w = (CGRectGetWidth(_btnContainerView.frame) -  (count - 1) * middleValue - startValue * 2)/count;
            [self createSpectOtherBtn:otherButtonTitles originX:startValue width:w height:btnHeight  value:middleValue];
        }
        
    }else{
        [_btnContainerView addConstraint:NSLayoutAttributeHeight equalTo:nil offset:0];
        [_btnContainerView layoutIfNeeded];
    }
    
}
/**
 YWAlertPublicStyleVertical的footView

 @param otherButtonTitles 按钮集合
 @param cancelButtonTitle 取消的按钮名称
 */
- (void)getVerticalFootView:(NSArray <NSString *>*)otherButtonTitles
          cancelButtonTitle:(NSString *)cancelButtonTitle{
    
    if ((cancelButtonTitle && cancelButtonTitle.length > 0) || otherButtonTitles.count > 0) {
        
        CGFloat origin = [self createVerticalOtherBtn:otherButtonTitles height:btnHeight];
        
        if (cancelButtonTitle && cancelButtonTitle.length > 0) {
            UIButton *cancelBtn = self.cancelBtn;
            [self.buttionList addObject:cancelBtn];
            if (origin != 0) {
                UIView *lineView = [UIView new];
                lineView.backgroundColor = DefaultLineTranslucenceColor;
                lineView.frame = CGRectMake(0, origin, _alterWidth, 1);
                [_btnContainerView addSubview:lineView];
                [_lineList addObject:lineView];
                cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(lineView.frame), _alterWidth, btnHeight);
                origin = origin + 1 + btnHeight;
            }else{
                cancelBtn.frame = CGRectMake(0, 0, _alterWidth, btnHeight);
                origin = origin + btnHeight;
            }
            [cancelBtn setTitle:cancelButtonTitle forState:UIControlStateNormal];
            [_btnContainerView addSubview:cancelBtn];
            
        }
        [_btnContainerView addConstraint:NSLayoutAttributeHeight equalTo:nil offset:origin];
    }else{
        [_btnContainerView addConstraint:NSLayoutAttributeHeight equalTo:nil offset:0];
    }

    [_btnContainerView layoutIfNeeded];

}
- (CGFloat)createVerticalOtherBtn:(NSArray <NSString *>*)otherButtonTitles
                           height:(CGFloat)height{
    int i = 0;
    CGFloat width = _alterWidth;
    CGFloat originY = 0;
    for (NSString *btnTitle in otherButtonTitles) {
        UIButton *otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        otherBtn.tag = 101 + i;
        
        otherBtn.frame = CGRectMake(0, i * (height + 1), width, height);
        otherBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [otherBtn setTitle:btnTitle forState:UIControlStateNormal];
//        otherBtn.backgroundColor = DefaultTranslucenceColor;
        [otherBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [otherBtn addTarget:self action:@selector(buttionClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnContainerView addSubview:otherBtn];
        [self.buttionList addObject:otherBtn];
        if (i < otherButtonTitles.count - 1) {
            UIView *lineView = [UIView new];
            lineView.frame = CGRectMake(0, CGRectGetMaxY(otherBtn.frame), width, 1);
            lineView.backgroundColor = DefaultLineTranslucenceColor;
            [_btnContainerView addSubview:lineView];
            [_lineList addObject:lineView];
        }else{
            originY = CGRectGetMaxY(otherBtn.frame);
        }
        i ++;
    }
    return originY;
}
/**
 获取默认的footView(横排的一组buttion)

 @param otherButtonTitles buttion集合
 @param cancelButtonTitle 取消buttion的title
 */
- (void)getDefalutFootView:(NSArray <NSString *>*)otherButtonTitles
         cancelButtonTitle:(NSString *)cancelButtonTitle{
    
    int count = (int)otherButtonTitles.count;
    
    if ((cancelButtonTitle && cancelButtonTitle.length > 0) || otherButtonTitles.count > 0) {
        
        [_btnContainerView addConstraint:NSLayoutAttributeHeight equalTo:nil offset:btnHeight];
        [_btnContainerView layoutIfNeeded];
        
        if (cancelButtonTitle && cancelButtonTitle.length > 0) {
            UIButton *cancelBtn = self.cancelBtn;
            [cancelBtn setTitle:cancelButtonTitle forState:UIControlStateNormal];
            [_btnContainerView addSubview:cancelBtn];
            [self.buttionList addObject:cancelBtn];
            if (otherButtonTitles.count > 0) {
                CGFloat w = (CGRectGetWidth(_btnContainerView.frame) -  count)/(count+1);
                cancelBtn.frame = CGRectMake(0, 0, w, btnHeight);
                UIView *lineView = [UIView new];
                lineView.backgroundColor = DefaultLineTranslucenceColor;
                lineView.frame = CGRectMake(CGRectGetMaxX(cancelBtn.frame), 0, 1, btnHeight);
                [_btnContainerView addSubview:lineView];
                [_lineList addObject:lineView];
                [self createDefalutOtherBtn:otherButtonTitles originX:CGRectGetMaxX(lineView.frame) width:w height:btnHeight];
                
            }else{
                cancelBtn.frame = CGRectMake(0, 0, CGRectGetWidth(_btnContainerView.frame), btnHeight);
            }
            
        }else{
            CGFloat w = (CGRectGetWidth(_btnContainerView.frame) -  (count - 1))/count;
            [self createDefalutOtherBtn:otherButtonTitles originX:0 width:w height:btnHeight];
        }
        
    }else{
        [_btnContainerView addConstraint:NSLayoutAttributeHeight equalTo:nil offset:0];
        [_btnContainerView layoutIfNeeded];
    }
    
}
//MARK: --- 创建一排的按钮
- (void)createDefalutOtherBtn:(NSArray <NSString *>*)otherButtonTitles
               originX:(CGFloat)x
                 width:(CGFloat)width
                       height:(CGFloat)height{
    int i = 0;
    for (NSString *btnTitle in otherButtonTitles) {
        UIButton *otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        otherBtn.tag = 101 + i;
        otherBtn.frame = CGRectMake(x + (i*(width+1)), 0, width, height);
        otherBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [otherBtn setTitle:btnTitle forState:UIControlStateNormal];
//        otherBtn.backgroundColor = DefaultTranslucenceColor;
        [otherBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [otherBtn addTarget:self action:@selector(buttionClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnContainerView addSubview:otherBtn];
        [self.buttionList addObject:otherBtn];

        if (i < otherButtonTitles.count - 1) {
            UIView *lineView = [UIView new];
            lineView.frame = CGRectMake(CGRectGetMaxX(otherBtn.frame), 0, 1, height);
            lineView.backgroundColor = DefaultLineTranslucenceColor;
            [_btnContainerView addSubview:lineView];
            [_lineList addObject:lineView];

        }
        i ++;
    }
}
- (void)createSpectOtherBtn:(NSArray <NSString *>*)otherButtonTitles
                    originX:(CGFloat)x
                    width:(CGFloat)width
                     height:(CGFloat)height
                      value:(CGFloat)value{
    int i = 0;
    for (NSString *btnTitle in otherButtonTitles) {
        UIButton *otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        otherBtn.tag = 101 + i;
        otherBtn.frame = CGRectMake(x + (i*(width+value)), 5, width, height);
        otherBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [otherBtn setTitle:btnTitle forState:UIControlStateNormal];
        otherBtn.backgroundColor = [UIColor blueColor];
        otherBtn.clipsToBounds = YES;
        otherBtn.layer.cornerRadius = 8;
        [otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [otherBtn addTarget:self action:@selector(buttionClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnContainerView addSubview:otherBtn];
        [self.buttionList addObject:otherBtn];
        i ++;
    }
}
//MARK: --- 配置信息
- (void)setAlertViewBackgroundColor:(UIColor *)color{
    _backgroundColor = color;
    self.alertView.backgroundColor = _backgroundColor;
    self.titleView.backgroundColor = _backgroundColor;
    self.messageContainerView.backgroundColor = _backgroundColor;
    self.btnContainerView.backgroundColor = _backgroundColor;
}
- (void)showCloseOnTitleView{
    self.closeBtn.hidden = NO;
}
- (void)hiddenAllLineView{
    for (UIView *line in _lineList) {
        line.backgroundColor = _backgroundColor;
    }
    [self hiddenBodyLineView];
}
- (void)hiddenBodyLineView{
    for (UIView *line in _bodyLineList) {
        line.backgroundColor = _backgroundColor;
    }
}
- (void)setTitleViewBackColor:(UIColor *)color{
    self.titleView.backgroundColor = color;
}
- (void)setTitleViewTitleColor:(UIColor *)color{
    self.titleLabel.textColor = color;
}
- (void)setMessageTitleColor:(UIColor *)color{
    self.messageLabel.textColor = color;
}
- (void)setAllButtionTitleColor:(UIColor *)color{
    for (UIButton *btn in self.buttionList) {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
}
- (void)setButtionTitleColor:(UIColor *)color index:(NSInteger)index{
    UIButton *btn = [self.btnContainerView viewWithTag:100+index];
    if (btn) {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
}
- (void)setButtionTitleFont:(CGFloat)font index:(NSInteger)index{
    UIButton *btn = [self.btnContainerView viewWithTag:100+index];
    if (btn) {
        btn.titleLabel.font = [UIFont systemFontOfSize:font];
    }
}
- (void)setButtionTitleFontWithName:(NSString *)name size:(CGFloat)size index:(NSInteger)index{
    UIButton *btn = [self.btnContainerView viewWithTag:100+index];
    if (btn) {
        btn.titleLabel.font = [UIFont fontWithName:name size:size];
    }
}

- (void)setCustomBodyView:(UIView *)bodyView height:(CGFloat)height{
    
    [self.messageContainerView addSubview:bodyView];
    
    [bodyView addConstraint:NSLayoutAttributeTop equalTo:self.messageContainerView toAttribute:NSLayoutAttributeTop offset:5];
    [bodyView addConstraint:NSLayoutAttributeLeft equalTo:self.messageContainerView offset:5];
    [bodyView addConstraint:NSLayoutAttributeRight equalTo:self.messageContainerView offset:-5];
    [bodyView addConstraint:NSLayoutAttributeHeight equalTo:nil offset:height];
    [self.messageContainerView addConstraint:NSLayoutAttributeHeight equalTo:bodyView offset:5];
    
    
    [self removeConstraint:_lay];
    //更新alert内部布局约束
    CGFloat alertHeight = CGRectGetHeight(self.titleView.frame) + 1 + height + 5 + 1 + CGRectGetHeight(self.btnContainerView.frame);
    [self.alertView addConstraint:NSLayoutAttributeHeight equalTo:nil offset:alertHeight];
    
    [self.alertView layoutIfNeeded];


}
- (void)setAlertBackgroundView:(UIImage *)image articulation:(CGFloat)articulation{
    _backgroundAlterView.hidden = NO;
    _backgroundAlterView.image = image;
//    uint32_t rgbaValue = [_backgroundColor rgbaValue];
//    UIColor *co = [UIColor colorWithRed:190 / 255.0f green:100 / 255.0 blue:255 / 255.0 alpha:0.4];
//    CGFloat r = 0, g = 0, b = 0, a = 0;
//    [co getRed:&r green:&g blue:&b alpha:&a];
//
    UIColor *newColor = [_backgroundColor colorWithAlphaComponent:articulation];
    self.titleView.backgroundColor = newColor;
    self.messageContainerView.backgroundColor = newColor;
    self.btnContainerView.backgroundColor = newColor;
}

//MAKR: --- 统一参数配置/主题
- (void)setTheme:(id<YWAlertViewThemeProtocol>)theme{
    
    if ([theme respondsToSelector:@selector(alertBackgroundView)]) {
        UIImage *img = [theme alertBackgroundView];
        if (img) {
            CGFloat alp = 0;
            if ([theme respondsToSelector:@selector(alterBackgroundViewArticulation)]) {
               alp = [theme alterBackgroundViewArticulation];
            }
            [self setAlertBackgroundView:img articulation:alp];
        }
    }
    if ([theme respondsToSelector:@selector(alertTitleViewColor)]) {
        UIColor *titleColor = [theme alertTitleViewColor];
        if (titleColor) {
            self.titleLabel.textColor = titleColor;
        }
    }
    if ([theme respondsToSelector:@selector(alertCancelColor)]) {
       UIColor *cancelColor = [theme alertCancelColor];
        if (cancelColor) {
            [self.cancelBtn setTitleColor:cancelColor forState:UIControlStateNormal];
        }
    }
    if ([theme respondsToSelector:@selector(alertGaussianBlurImage)]) {
       UIImage *blur = [theme alertGaussianBlurImage];
        if (blur) {
            self.gaussianBlurOnMaskView.hidden = NO;
            self.gaussianBlurOnMaskView.image = blur;
        }
    }
    if ([theme respondsToSelector:@selector(alertBackgroundColor)]) {
         UIColor *backgroundColor = [theme alertBackgroundColor];
        [self setAlertViewBackgroundColor:backgroundColor];
    }

}

//MARK: --- getter & setter
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.tag = 100;
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        _cancelBtn.backgroundColor = DefaultTranslucenceColor;
        [_cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(buttionClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectZero];
        _maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _maskView.backgroundColor = [UIColor colorWithRed:10 / 255.0 green:10 / 255.0 blue:10 / 255.0 alpha:0.0];
        _maskView.alpha = 0;
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

- (UIView *)titleView{
    if (!_titleView) {
        _titleView = [UIView new];
        _titleView.backgroundColor = DefaultTranslucenceColor;
    }
    return _titleView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
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
- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"yw_alter_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(hiddenAlertView) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.hidden = YES;
    }
    return _closeBtn;
}
- (NSMutableArray *)buttionList{
    if (!_buttionList) {
        _buttionList = [NSMutableArray new];
    }
    return _buttionList;
}

//MARK: --- 跟控制器相关
+ (UIViewController*)currentViewController {
    UIViewController* rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
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
- (void)dealloc{
    NSLog(@"%s",__func__);
    _lineList = nil;
    _bodyLineList = nil;
    _maskView = nil;
    _alertView = nil;
    _gaussianBlurOnMaskView = nil;
    _titleView = nil;
    _titleLabel = nil;
    _messageContainerView = nil;
    _messageLabel = nil;
    _btnContainerView = nil;
    _closeBtn = nil;
    _cancelBtn = nil;
    _buttionList = nil;
    _lineBoad = nil;
    _lay = nil;
    _backgroundAlterView = nil;
    _backgroundColor = nil;
}
@end
