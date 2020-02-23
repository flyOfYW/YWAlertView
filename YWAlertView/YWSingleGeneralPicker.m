//
//  YWSingleGeneralPicker.m
//  YWAlertViewDemo
//
//  Created by Mr.Yao on 2020/2/23.
//  Copyright © 2020 yaowei. All rights reserved.
//

#import "YWSingleGeneralPicker.h"
#import "YWAlertViewHelper.h"
#import "UIView+Autolayout.h"
#import "YWAddressModel.h"
#import "YWContainerViewController.h"
#import "YWSingleGeneralModel.h"

@interface YWSingleGeneralPicker ()
<UIPickerViewDelegate,UIPickerViewDataSource>
{
    YWAlertPublicBodyStyle _pickerStyle;
    BOOL _isSetSpeartorView;//是否设置过分割线的颜色
    NSInteger _font;//字体大小
    CGFloat _pickerHeight;
    CGFloat _pickerAlertViewWidth;
    
    NSLayoutConstraint *_layOnTitleViewHeight;//方便后期扩展自定义高度
    NSLayoutConstraint *_layPickerViewHeight;//方便后期扩展自定义高度
    BOOL _isSetFrame;//是否设置过frame
    BOOL _isModal;
    
}
//sheet的容器
@property (nonatomic, strong) UIView *pickerAlertView;
//蒙层
@property (nonatomic, strong) UIView *maskView;
//高斯模糊的背景图
@property (nonatomic, strong) UIImageView *gaussianBlurOnMaskView;
//标题的view
@property (nonatomic, strong) UIView *titleView;
//标题
@property (nonatomic, strong) UILabel *titleLabel;
//取消按钮
@property (nonatomic, strong) UIButton *cancelBtn;
//确认按钮
@property (nonatomic, strong) UIButton *sureBtn;
//picker容器
@property (nonatomic, strong) UILabel *messageLabel;
//picker
@property (nonatomic, strong) UIPickerView *datePicker;
//picker 字体颜色（默认黑色）
@property (nonatomic,strong) UIColor *addressColor;

@property (nonatomic,   copy) void(^handler)(NSInteger buttonIndex,id value);
/** 选中 */
@property(nonatomic, strong) YWSingleGeneralModel *selectModel;

@property(nonatomic, assign) NSInteger selectRow;


@property (nonatomic, strong) NSMutableArray <YWSingleGeneralModel *>*listData;




@end

@implementation YWSingleGeneralPicker


- (instancetype _Nullable)initWithTitle:(nullable NSString *)title
                               delegate:(id _Nullable)delegate
                             dataSource:(NSArray <YWSingleGeneralModel*> *)dataSource
                      cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                         okButtonTitles:(nullable NSString *)sureButtonTitles
                                handler:(nullable void(^)(NSInteger buttonIndex,
                                                          id _Nullable value))handler{
    
    UIView *currentView = [YWAlertViewHelper currentViewController].view;
    
    self = [super initWithFrame:currentView.frame];
    
    if (!self) {
        return nil;
    }
    _handler = handler;
    _delegate = delegate;
    _listData = [NSMutableArray arrayWithArray:dataSource];
    _selectModel = _listData.firstObject;
    
    self.maskView.frame = currentView.frame;
    [self addSubview:_maskView];
    self.gaussianBlurOnMaskView.frame = currentView.frame;
    [_maskView addSubview:self.gaussianBlurOnMaskView];
    
    _font = 15;
    
    _pickerAlertViewWidth = YWAlertScreenW;
    _pickerHeight = 160;
    UIView *alert = [[UIView alloc] initWithFrame:CGRectMake(0, YWAlertScreenH, _pickerAlertViewWidth , 300)];
    alert.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    alert.backgroundColor = [UIColor whiteColor];
    [self addSubview:alert];
    _pickerAlertView = alert;
    [self onPrepareAlertViewOnFoot:title cancelButtonTitle:cancelButtonTitle otherButtonTitles:sureButtonTitles frame:currentView.frame];
    
    return self;
    
}
/**
 配合懒加载，即时即地show的时候，回调
 
 @param handler 回调
 */
- (void)showWindowWithHandler:(nullable void(^)(NSInteger buttonIndex,id _Nullable value))handler{
    _handler = handler;
    [self show];
}
- (void)show{
    
    UIWindow *keyWindows = [YWAlertViewHelper getWindow];
    [keyWindows addSubview:self];
    _isModal = NO;
    
    [self addConstraint:NSLayoutAttributeLeft equalTo:keyWindows offset:0];
    [self addConstraint:NSLayoutAttributeRight equalTo:keyWindows offset:0];
    [self addConstraint:NSLayoutAttributeTop equalTo:keyWindows offset:0];
    [self addConstraint:NSLayoutAttributeBottom equalTo:keyWindows offset:0];
    
    if (!_isSetFrame) {
        [self setNeedsLayout];
    }else{
        [UIView animateWithDuration:0.62 animations:^{
            CGRect rect1 = self.pickerAlertView.frame;
            rect1.origin.y = YWAlertScreenH - rect1.size.height;
            self.pickerAlertView.frame = rect1;
        }];
    }
    
    _datePicker.delegate = self;
    _datePicker.dataSource = self;
    
    [self selectIndex:self.selectRow inComponent:0 animated:NO];
}
/**
 显示在viewController上
 */
- (void)showOnViewController{
    self.maskView.backgroundColor = [UIColor clearColor];
    [self selectIndex:self.selectRow inComponent:0 animated:NO];
    _isModal = YES;
    YWContainerViewController *conVC = [YWContainerViewController new];
    conVC.alertView = self;
    conVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    conVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[YWAlertViewHelper currentViewController] presentViewController:conVC animated:NO completion:^{
        [UIView animateWithDuration:0.6 animations:^{
            CGRect rect1 = self.pickerAlertView.frame;
            rect1.origin.y = YWAlertScreenH - rect1.size.height;
            self.pickerAlertView.frame = rect1;
        }];
    }];
    
}
- (void)hiddenAlertView{
    [UIView animateWithDuration:0.62 animations:^{
        CGRect rect1 = self.pickerAlertView.frame;
        rect1.origin.y = YWAlertScreenH;
        self.pickerAlertView.frame = rect1;
    } completion:^(BOOL finished) {
        if (self -> _isModal) {
            [[YWAlertViewHelper currentViewController] dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self removeFromSuperview];
        }
    }];
}
//MARK: ---------------------- action ------------------------------------
-(void)buttionClick:(UIButton *)btn{
    if (btn.tag == 101) {
        YWSingleGeneralModel *model = [YWSingleGeneralModel new];
        model.idc = self.selectModel.idc;
        model.displayName = self.selectModel.displayName;
        model.displayMenu = self.selectModel.displayMenu;
        if (_handler) {
            _handler(1,model);
        }else{
            if ([self.delegate respondsToSelector:@selector(didClickAlertView:value:)]) {
                [self.delegate didClickAlertView:1 value:model];
            }
        }
    }
    [self hiddenAlertView];
}

//MARK: ------------------------ UIPickerViewDelegate,UIPickerViewDataSource ---------------------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
        return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.listData.count;
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *nameLabel = (UILabel *)view;
    if (!nameLabel) {
        nameLabel = [[UILabel alloc] init];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        if (_addressColor) {
            nameLabel.textColor = _addressColor;
        }else{
            nameLabel.textColor = [UIColor blackColor];
        }
        [nameLabel setFont:[UIFont systemFontOfSize:_font]];
        [self changeSpearatorLineColor];
    }
    YWSingleGeneralModel *model = self.listData[row];
    nameLabel.text = [NSString stringWithFormat:@"%@",model.displayName];
    return nameLabel;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 36;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectModel = self.listData[row];
    self.selectRow = row;
}

//MARK: ------------------------ config配置信息 --------------------------------
/**
 隐藏bodyview上下的两个分隔线
 */
- (void)hiddenBodyLineView{
    
}
/**
 隐藏所有的分隔线
 */
- (void)hiddenAllLineView{
    
}
/**
 设置整个弹框的背景颜色
 
 @param color 颜色
 */
- (void)setAlertViewBackgroundColor:(UIColor *)color{
    self.pickerAlertView.backgroundColor = color;
}
/**
 设置titleView的背景颜色
 
 @param color 颜色
 */
- (void)setTitleViewBackColor:(UIColor *)color{
    self.titleView.backgroundColor = color;
}
/**
 设置titleView的title颜色
 
 @param color 颜色
 */
- (void)setTitleViewTitleColor:(UIColor *)color{
    self.titleLabel.textColor = color;
}
/**
 设置message的字体颜色
 
 @param color 颜色
 */
- (void)setMessageTitleColor:(UIColor *)color{
    
}
/**
 设置所有按钮的字体颜色
 
 @param color 颜色
 */
- (void)setAllButtionTitleColor:(UIColor *)color{
    [self.cancelBtn setTitleColor:color forState:UIControlStateNormal];
    [self.sureBtn setTitleColor:color forState:UIControlStateNormal];
}
/**
 设置单个按钮的颜色
 
 @param color 颜色
 @param index 下标
 */
- (void)setButtionTitleColor:(UIColor *)color index:(NSInteger)index{
    if (index == 0) {
        [self.cancelBtn setTitleColor:color forState:UIControlStateNormal];
    }else if (index == 1){
        [self.sureBtn setTitleColor:color forState:UIControlStateNormal];
    }else{
        NSAssert(NO, @"当前弹框按钮的小标为0~1,0-取消，1-确定");
    }
}
/**
 设置单个按钮的字体以及其大小
 
 @param name 什么字体
 @param size 大小
 @param index 小标
 */
- (void)setButtionTitleFontWithName:(NSString *)name size:(CGFloat)size index:(NSInteger)index{
    if (index == 0) {
        if (name) {
            self.cancelBtn.titleLabel.font = [UIFont fontWithName:name size:size];
        }else{
            self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:size];
        }
    }else if (index == 1){
        if (name) {
            self.sureBtn.titleLabel.font = [UIFont fontWithName:name size:size];
        }else{
            self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:size];
        }
    }else{
        NSAssert(NO, @"当前弹框按钮的小标为0~1,0-取消，1-确定");
    }
    
}
/**
 设置title的字体以及其大小
 
 @param name 什么字体(为nil时,即是系统字体)
 @param size 大小
 */
- (void)setTitleFontWithName:(NSString *)name size:(CGFloat)size{
    if (name) {
        self.titleLabel.font = [UIFont fontWithName:name size:size];
    }else{
        self.titleLabel.font = [UIFont systemFontOfSize:size];
    }
}
/**
 设置message的字体以及其大小
 
 @param name 什么字体(为nil时,即是系统字体)
 @param size 大小
 */
- (void)setMessageFontWithName:(NSString *)name size:(CGFloat)size{
    
}
/**
 设置picker的高度
 
 @param height 高度
 */
- (void)setPickerHeightOnAddressPickerView:(CGFloat)height{
    if (height<=0) {
        return;
    }
    _layPickerViewHeight.constant = height;
    _isSetFrame = NO;
    [self setNeedsLayout];
}
/**
 设置蒙版的背景图
 
 @param image 蒙版的背景图（可使用高斯的image）
 */
- (void)setGaussianBlurImage:(UIImage *)image{
    self.gaussianBlurOnMaskView.image = image;
}
/**
 统一配置信息
 
 @param theme 主题
 */
- (void)setTheme:(id<YWAlertViewThemeProtocol>)theme{
    NSLog(@"地址选择器目前不支持主题theme设置");
}
- (void)setDefalutOnSingleGeneraPickerView:(YWSingleGeneralModel *)defalutModel{
    NSAssert(!(defalutModel==nil), @"defalutModel不能为nil");
    YWSingleGeneralModel *tempProinceModel = nil;
    int index = 0;
    for (YWSingleGeneralModel *model in self.listData) {
        if (model.idc == defalutModel.idc) {
            tempProinceModel = model;
            _selectRow = index;
            break;
        }
        index ++;
    }
    if (!tempProinceModel) {
        tempProinceModel = self.selectModel;
    }
    self.selectModel = tempProinceModel;
}

//MARK: --------------------- private method ------------------------
//加载本地bundle资源
- (NSArray *)loadLocationData{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *url = [bundle URLForResource:@"YWAlertView" withExtension:@"bundle"];
    NSBundle *plistBundle = [NSBundle bundleWithURL:url];
    
    NSString *filePath = [plistBundle pathForResource:@"YWCity" ofType:@"plist"];
    NSArray *dataSource = [NSArray arrayWithContentsOfFile:filePath];
    if (!dataSource || dataSource.count == 0) {
        NSAssert(NO, @"加载本地数据异常");
        return nil;
    }
    return dataSource;
}
- (void)selectIndex:(NSInteger)index inComponent:(NSInteger)component animated:(BOOL)animated{
    [self.datePicker selectRow:index inComponent:component animated:animated];
}
- (void)onPrepareAlertViewOnFoot:(nullable NSString *)title
               cancelButtonTitle:(nullable NSString *)cancelButtonTitle
               otherButtonTitles:(nullable NSString *)otherButtonTitles
                           frame:(CGRect)frame{
    
    [_pickerAlertView addSubview:self.titleView];
    [self.titleView addConstraint:NSLayoutAttributeTop equalTo:_pickerAlertView offset:0];
    [self.titleView addConstraint:NSLayoutAttributeLeft equalTo:_pickerAlertView offset:0];
    [self.titleView addConstraint:NSLayoutAttributeRight equalTo:_pickerAlertView offset:0];
    
    _layOnTitleViewHeight = [self.titleView addConstraintAndReturn:NSLayoutAttributeHeight equalTo:nil toAttribute:NSLayoutAttributeHeight offset:titleViewHeight];
    
    [self.cancelBtn setTitle:cancelButtonTitle forState:UIControlStateNormal];
    [self.titleView addSubview:_cancelBtn];
    
    [self.sureBtn setTitle:otherButtonTitles forState:UIControlStateNormal];
    [self.titleView addSubview:_sureBtn];
    
    [_cancelBtn addConstraint:NSLayoutAttributeTop equalTo:self.titleView offset:0];
    [_cancelBtn addConstraint:NSLayoutAttributeBottom equalTo:self.titleView offset:0];
    [_cancelBtn addConstraint:NSLayoutAttributeLeft equalTo:self.titleView offset:10];
    [_cancelBtn addConstraint:NSLayoutAttributeWidth equalTo:nil toAttribute:NSLayoutAttributeWidth offset:60];
    
    [_sureBtn addConstraint:NSLayoutAttributeTop equalTo:self.titleView offset:0];
    [_sureBtn addConstraint:NSLayoutAttributeBottom equalTo:self.titleView offset:0];
    [_sureBtn addConstraint:NSLayoutAttributeRight equalTo:self.titleView toAttribute:NSLayoutAttributeRight offset:-10];
    [_sureBtn addConstraint:NSLayoutAttributeWidth equalTo:nil toAttribute:NSLayoutAttributeWidth offset:60];
    
    
    self.titleLabel.text = title;
    [self.titleView addSubview:self.titleLabel];
    [self.titleLabel addConstraint:NSLayoutAttributeTop equalTo:self.titleView offset:0];
    [self.titleLabel addConstraint:NSLayoutAttributeBottom equalTo:self.titleView offset:0];
    [self.titleLabel  addConstraint:NSLayoutAttributeLeft equalTo:_cancelBtn toAttribute:NSLayoutAttributeRight offset:10];
    [self.titleLabel  addConstraint:NSLayoutAttributeRight equalTo:_sureBtn toAttribute:NSLayoutAttributeLeft offset:-10];
    
    
    //添加pickerView
    [_pickerAlertView addSubview:self.messageLabel];
    [_messageLabel addConstraint:NSLayoutAttributeLeft equalTo:_pickerAlertView offset:0];
    [_messageLabel addConstraint:NSLayoutAttributeRight equalTo:_pickerAlertView offset:0];
    [_messageLabel addConstraint:NSLayoutAttributeTop equalTo:self.titleView toAttribute:NSLayoutAttributeBottom offset:0];
    _layPickerViewHeight = [_messageLabel addConstraintAndReturn:NSLayoutAttributeHeight equalTo:nil toAttribute:NSLayoutAttributeHeight offset:_pickerHeight];
    
    [_messageLabel addSubview:self.datePicker];
    
    [_datePicker addConstraint:NSLayoutAttributeLeft equalTo:_messageLabel offset:0];
    [_datePicker addConstraint:NSLayoutAttributeRight equalTo:_messageLabel offset:0];
    [_datePicker addConstraint:NSLayoutAttributeBottom equalTo:_messageLabel offset:0];
    [_datePicker addConstraint:NSLayoutAttributeTop equalTo:_messageLabel offset:0];
    
}
//改变分割线的颜色
- (void)changeSpearatorLineColor{
    if (!_isSetSpeartorView) {
        for(UIView *speartorView in self.datePicker.subviews){
            if (speartorView.frame.size.height < 1){//取出分割线view
                speartorView.backgroundColor = DefaultLineTranslucenceColor;//隐藏分割线
            }
        }
        _isSetSpeartorView = YES;
    }
}
- (void)setSheetFrame{
    
    [self.titleView layoutIfNeeded];
    [self.messageLabel layoutIfNeeded];
    
    CGFloat heigth = CGRectGetHeight(self.titleView.frame) + CGRectGetHeight(self.messageLabel.frame);
    CGRect rect = self.pickerAlertView.frame;
    rect.size.height = heigth;
    self.pickerAlertView.frame = rect;
    
    [UIView animateWithDuration:0.62 animations:^{
        CGRect rect1 = self.pickerAlertView.frame;
        rect1.origin.y = YWAlertScreenH - heigth;
        self.pickerAlertView.frame = rect1;
    }];
    
    _isSetFrame = YES;
    
}
//MARK: --------------------- gertter & setter ------------------------
- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectZero];
        _maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _maskView.backgroundColor = [UIColor colorWithRed:10 / 255.0 green:10 / 255.0 blue:10 / 255.0 alpha:0.6];
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
    }
    return _titleView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = @"请选择地址";
    }
    return _titleLabel;
}
- (UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [UILabel new];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont boldSystemFontOfSize:100];
        _messageLabel.textColor = [UIColor colorWithRed:233/255.0 green:237/255.0 blue:242/255.0 alpha:0.9];
        _messageLabel.userInteractionEnabled = YES;
    }
    return _messageLabel;
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.tag = 100;
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(buttionClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.tag = 101;
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sureBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(buttionClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
-(UIPickerView *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
        _datePicker.delegate = self;
        _datePicker.dataSource = self;
        _datePicker.showsSelectionIndicator = NO;
    }
    return _datePicker;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self setSheetFrame];
}
@end
