//
//  YWDatePicker.m
//  YWAlertViewDemo
//
//  Created by yaowei on 2018/8/31.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "YWDatePicker.h"
#import "UIView+Autolayout.h"
#import "YWAlertViewHelper.h"
#import "NSDate+YW.h"

static const float titleViewHeight = 40;
static const float butttionViewHeight = 45;

#define YWMAXYEAR 2099
#define YWMINYEAR 1927


@interface YWDatePicker ()
<UIPickerViewDelegate,UIPickerViewDataSource>
{
    CGFloat _pickerAlertViewWidth;
    NSLayoutConstraint *_layOnTitleViewHeight;//方便后期扩展自定义高度
    NSLayoutConstraint *_layOnButtionViewHeight;//方便后期扩展自定义高度
    NSLayoutConstraint *_layPickerViewHeight;//方便后期扩展自定义高度

    NSMutableArray *_buttionList;
    YWAlertPublicBodyStyle _datePickerStyle;

    //日期存储数组
    NSMutableArray *_yearArray;//年
    NSMutableArray *_monthArray;//月
    NSMutableArray *_dayArray;//日
    NSMutableArray *_hourArray;//时
    NSMutableArray *_minuteArray;//分
    NSMutableArray *_secondArray;//秒
    
    //记录位置
    NSInteger _yearIndex;
    NSInteger _monthIndex;
    NSInteger _dayIndex;
    NSInteger _hourIndex;
    NSInteger _minuteIndex;
    NSInteger _secondIndex;
    BOOL _isSetSpeartorView;//是否设置过分割线的颜色

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

//其他按钮的容器
@property (nonatomic, strong) UIView *buttionContainerView;
//取消按钮
@property (nonatomic, strong) UIButton *cancelBtn;
//确认按钮
@property (nonatomic, strong) UIButton *sureBtn;
//picker容器
@property (nonatomic, strong) UILabel *messageLabel;
//picker
@property (nonatomic, strong) UIPickerView *datePicker;

@property (nonatomic,   copy) void(^handler)(NSInteger buttonIndex,id value);

/**
 *  年-月-日-时-分-秒 文字颜色(默认黑色)
 */
@property (nonatomic,strong) UIColor *dateLabelColor;

@property (nonatomic,  copy) NSString *dateValue;


@end

@implementation YWDatePicker

- (instancetype _Nullable)initWithTitle:(nullable NSString *)title
                               delegate:(id _Nullable)delegate
                              footStyle:(YWAlertPublicFootStyle)footStyle
                              bodyStyle:(YWAlertPublicBodyStyle)bodyStyle
                                   mode:(NSInteger)mode//扩展date具体位置
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
    _datePickerStyle = bodyStyle;
    _buttionList = @[].mutableCopy;
    if (mode == 0) {
        _pickerAlertViewWidth = currentView.frame.size.width - 20;
        //横屏或者ipad时，宽度为394即可
        _pickerAlertViewWidth = _pickerAlertViewWidth > 394 ? 394 : _pickerAlertViewWidth;
    }else{
        _pickerAlertViewWidth = 300;
    }
    
    self.maskView.frame = currentView.frame;
    [self addSubview:_maskView];
    self.gaussianBlurOnMaskView.frame = currentView.frame;
    [_maskView addSubview:self.gaussianBlurOnMaskView];
    
    UIView *alert = [[UIView alloc] initWithFrame:CGRectMake(10, (YWAlertScreenH-300)/2, _pickerAlertViewWidth , 300)];
    alert.backgroundColor = [UIColor whiteColor];
    alert.layer.cornerRadius = 15.0f;
    alert.layer.masksToBounds = YES;
    [self addSubview:alert];
    _pickerAlertView = alert;
    
    [self onPrepareTitle:title footStyle:footStyle cancelButtonTitle:cancelButtonTitle otherButtonTitles:sureButtonTitles frame:currentView.frame];
    [self initData];
    
    return self;
    
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    switch (_datePickerStyle) {
        case YWAlertStyleShowYearMonthDayHourMinuteSecond:
            return 6;
        default:
            return 0;
    }
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSArray *numberArr = [self getNumberOfRowsInComponent];
    return [numberArr[component] integerValue];
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *nameLabel = (UILabel *)view;
    if (!nameLabel) {
        nameLabel = [[UILabel alloc] init];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        if (_dateLabelColor) {
            nameLabel.textColor = _dateLabelColor;
        }else{
            nameLabel.textColor = [UIColor blackColor];
        }
        [nameLabel setFont:[UIFont systemFontOfSize:15]];
        [self changeSpearatorLineColor];
    }
    NSString *title;
    switch (_datePickerStyle) {
        case YWAlertStyleShowYearMonthDayHourMinuteSecond:
            if (component==0) title = [NSString stringWithFormat:@"%@年",_yearArray[row]];
            else if (component == 1) title = [NSString stringWithFormat:@"%@月",_monthArray[row]];
            else if (component == 2) title = [NSString stringWithFormat:@"%@日",_dayArray[row]];
            else if (component == 3) title = [NSString stringWithFormat:@"%@时",_hourArray[row]];
            else if (component == 4) title = [NSString stringWithFormat:@"%@分",_minuteArray[row]];
            else if (component == 5) title = [NSString stringWithFormat:@"%@秒",_secondArray[row]];
            break;
        default:
            title = @"";
            break;
    }
    nameLabel.text = title;
    return nameLabel;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    BOOL isNeddReload = NO;//是否需要刷新
    switch (_datePickerStyle) {
        case YWAlertStyleShowYearMonthDayHourMinuteSecond:{
            if (component == 0)      _yearIndex   = row;
            else if (component == 1) _monthIndex  = row;
            else if (component == 2) _dayIndex    = row;
            else if (component == 3) _hourIndex   = row;
            else if (component == 4) _minuteIndex = row;
            else if (component == 5) _secondIndex = row;
            
            if (component == 0 || component == 1) {
                [self daysOnYear:[_yearArray[_yearIndex] integerValue] month:[_monthArray[_monthIndex] integerValue]];
                if (_dayArray.count - 1 < _dayIndex) {
                    _dayIndex = _dayArray.count - 1;
                }
                isNeddReload = YES;
                self.messageLabel.text = [NSString stringWithFormat:@"%@",_yearArray[_yearIndex]];
                [pickerView reloadComponent:2];

            }
            _dateValue = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",_yearArray[_yearIndex],_monthArray[_monthIndex],_dayArray[_dayIndex],_hourArray[_hourIndex],_minuteArray[_minuteIndex],_secondArray[_secondIndex]];
            break;
        }
        default:
            break;
    }
}
//MARK: --- 返回所有component的每个列表的行数
- (NSArray *)getNumberOfRowsInComponent{
    
    NSInteger yearNum   = _yearArray.count;
    NSInteger monthNum  = _monthArray.count;
    NSInteger dayNum    = 0;
    NSInteger hourNum   = _hourArray.count;
    NSInteger minuteNum = _minuteArray.count;
    NSInteger secondNum = _secondArray.count;
    
    dayNum = [self daysOnYear:[_yearArray[_yearIndex] integerValue] month:[_monthArray[_monthIndex] integerValue]];
    
    switch (_datePickerStyle) {
        case YWAlertStyleShowYearMonthDayHourMinuteSecond:
            return @[@(yearNum),@(monthNum),@(dayNum),@(hourNum),@(minuteNum),@(secondNum)];
            break;
        default:
            return @[];
            break;
            
    }
}
//MARK: --- 开始搭建界面
- (void)onPrepareTitle:(nullable NSString *)title
             footStyle:(YWAlertPublicFootStyle)footStyle
     cancelButtonTitle:(nullable NSString *)cancelButtonTitle
     otherButtonTitles:(nullable NSString *)otherButtonTitles
                 frame:(CGRect)frame{
    
    [_pickerAlertView addSubview:self.titleView];
    [self.titleView addConstraint:NSLayoutAttributeTop equalTo:_pickerAlertView offset:0];
    [self.titleView addConstraint:NSLayoutAttributeLeft equalTo:_pickerAlertView offset:0];
    [self.titleView addConstraint:NSLayoutAttributeRight equalTo:_pickerAlertView offset:0];
    
    if (title && title.length > 0) {
        [self addTitleView];
        _layOnTitleViewHeight = [self.titleView addConstraintAndReturn:NSLayoutAttributeHeight equalTo:nil toAttribute:NSLayoutAttributeHeight offset:titleViewHeight];
    }else{
        _layOnTitleViewHeight = [self.titleView addConstraintAndReturn:NSLayoutAttributeHeight equalTo:nil toAttribute:NSLayoutAttributeHeight offset:0];
    }
    
    //按钮部分（footView）
    UIView *buttV = [UIView new];
    [_pickerAlertView addSubview:buttV];
    _buttionContainerView = buttV;
    
    [_buttionContainerView addConstraint:NSLayoutAttributeLeft equalTo:_pickerAlertView offset:0];
    [_buttionContainerView addConstraint:NSLayoutAttributeRight equalTo:_pickerAlertView offset:0];
    [_buttionContainerView addConstraint:NSLayoutAttributeBottom equalTo:_pickerAlertView offset:0];
    
    
    if (cancelButtonTitle && cancelButtonTitle.length > 0) {
        [_buttionContainerView addSubview:self.cancelBtn];
        [_cancelBtn setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [_buttionList addObject:self.cancelBtn];
    }
    
    if (otherButtonTitles && otherButtonTitles.length > 0) {
        [_buttionContainerView addSubview:self.sureBtn];
        [_sureBtn setTitle:otherButtonTitles forState:UIControlStateNormal];
        [_buttionList addObject:self.sureBtn];
    }
    if (_buttionList.count == 0) {
        [_buttionContainerView addConstraint:NSLayoutAttributeHeight equalTo:nil offset:0];
    }else if(_buttionList.count == 1){
        _layOnButtionViewHeight = [_buttionContainerView addConstraintAndReturn:NSLayoutAttributeHeight equalTo:nil toAttribute:NSLayoutAttributeHeight offset:butttionViewHeight];
        [self addOnceButtion:_buttionList.firstObject];
    }else{
        
        if (footStyle == YWAlertPublicFootStyleVertical) {//竖排
            _layOnButtionViewHeight = [_buttionContainerView addConstraintAndReturn:NSLayoutAttributeHeight equalTo:nil toAttribute:NSLayoutAttributeHeight offset:butttionViewHeight * 2 + 2];
            [self addVerticalButtionView];
        }else{//横排
            _layOnButtionViewHeight = [_buttionContainerView addConstraintAndReturn:NSLayoutAttributeHeight equalTo:nil toAttribute:NSLayoutAttributeHeight offset:butttionViewHeight];
            [self addDefalutButtionView];
        }
        
    }
    
    //添加pickerView
    [_pickerAlertView addSubview:self.messageLabel];
    [_messageLabel addConstraint:NSLayoutAttributeLeft equalTo:_pickerAlertView offset:0];
    [_messageLabel addConstraint:NSLayoutAttributeRight equalTo:_pickerAlertView offset:0];
    [_messageLabel addConstraint:NSLayoutAttributeTop equalTo:_titleView toAttribute:NSLayoutAttributeBottom offset:0];
    _layPickerViewHeight = [_messageLabel addConstraintAndReturn:NSLayoutAttributeHeight equalTo:nil toAttribute:NSLayoutAttributeHeight offset:170];

    [_messageLabel addSubview:self.datePicker];
    
    [_datePicker addConstraint:NSLayoutAttributeLeft equalTo:_messageLabel offset:0];
    [_datePicker addConstraint:NSLayoutAttributeRight equalTo:_messageLabel offset:0];
    [_datePicker addConstraint:NSLayoutAttributeBottom equalTo:_messageLabel offset:0];
    [_datePicker addConstraint:NSLayoutAttributeTop equalTo:_messageLabel offset:0];


}

- (void)addOnceButtion:(UIButton *)btn{
 
    [btn setTranslatesAutoresizingMaskIntoConstraints:NO];

    UIView *topLineView = [UIView new];
    topLineView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    topLineView.tag = 102;
    [topLineView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_buttionContainerView addSubview:topLineView];
    
    NSDictionary *views  = NSDictionaryOfVariableBindings(btn,topLineView);
    
    ///水平方向的约束
    NSArray *VContrains = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[topLineView(1)]-0-[btn]-0-|" options:0 metrics:nil views:views];
    
    NSArray *HTopContrains = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[topLineView]-0-|" options:0 metrics:nil views:views];
    NSArray *HCanContrains = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[btn]-0-|" options:0 metrics:nil views:views];

    [_buttionContainerView addConstraints:VContrains];
    [_buttionContainerView addConstraints:HTopContrains];
    [_buttionContainerView addConstraints:HCanContrains];
    
}
- (void)addVerticalButtionView{
    
    [_cancelBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_sureBtn setTranslatesAutoresizingMaskIntoConstraints:NO];

    UIView *topLineView = [UIView new];
    topLineView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    topLineView.tag = 102;
    [topLineView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_buttionContainerView addSubview:topLineView];
    
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    lineView.tag = 103;
    [lineView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_buttionContainerView addSubview:lineView];

    NSDictionary *views  = NSDictionaryOfVariableBindings(_cancelBtn,_sureBtn,topLineView,lineView);

    ///水平方向的约束
    NSArray *VContrains = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[topLineView(1)]-0-[_cancelBtn(==_sureBtn)]-0-[lineView(1)]-0-[_sureBtn]-0-|" options:0 metrics:nil views:views];

    NSArray *HTopContrains = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[topLineView]-0-|" options:0 metrics:nil views:views];
    NSArray *HCanContrains = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_cancelBtn]-0-|" options:0 metrics:nil views:views];
    NSArray *HLineContrains = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[lineView]-0-|" options:0 metrics:nil views:views];
    NSArray *HSureContrains = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_sureBtn]-0-|" options:0 metrics:nil views:views];
    
    [_buttionContainerView addConstraints:VContrains];
    [_buttionContainerView addConstraints:HTopContrains];
    
    [_buttionContainerView addConstraints:HCanContrains];
    [_buttionContainerView addConstraints:HLineContrains];
    [_buttionContainerView addConstraints:HSureContrains];
    

}
- (void)addDefalutButtionView{
    
    [_cancelBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_sureBtn setTranslatesAutoresizingMaskIntoConstraints:NO];

    UIView *topLineView = [UIView new];
    topLineView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    topLineView.tag = 102;
    [topLineView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_buttionContainerView addSubview:topLineView];
    
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    lineView.tag = 103;
    [lineView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_buttionContainerView addSubview:lineView];

    NSDictionary *views  = NSDictionaryOfVariableBindings(_cancelBtn,_sureBtn,lineView,topLineView);
    ///创建第三个参数 所用到的 布局度量 metres 字典
    NSDictionary *metres = @{@"space":@1,@"leftArglin":@0,@"rightArglin":@0};
    
    ///水平方向的约束
    NSArray *HContrains = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftArglin-[_cancelBtn]-rightArglin-[lineView(1)]-rightArglin-[_sureBtn(==_cancelBtn)]-rightArglin-|" options:0 metrics:metres views:views];

    NSArray *HTopContrains = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftArglin-[topLineView]-rightArglin-|" options:0 metrics:metres views:views];

    NSArray *VTopContrains = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[topLineView(1)]" options:0 metrics:metres views:views];

    ///垂直方向的约束
    NSArray *VContrains = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[_cancelBtn]-0-|" options:0 metrics:metres views:views];
    
    NSArray *VContrains1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[_sureBtn]-0-|" options:0 metrics:metres views:views];
    
    NSArray *VContrains2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[lineView]-0-|" options:0 metrics:metres views:views];
    
    [_buttionContainerView addConstraints:HContrains];
    [_buttionContainerView addConstraints:HTopContrains];

    [_buttionContainerView addConstraints:VTopContrains];
    [_buttionContainerView addConstraints:VContrains];
    [_buttionContainerView addConstraints:VContrains1];
    [_buttionContainerView addConstraints:VContrains2];
    

}

- (void)addTitleView{
    
    [self.titleView addSubview:self.titleLabel];    
    [self.titleLabel addConstraint:NSLayoutAttributeTop equalTo:self.titleView offset:0];
    [self.titleLabel addConstraint:NSLayoutAttributeLeft equalTo:self.titleView offset:0];
    [self.titleLabel addConstraint:NSLayoutAttributeRight equalTo:self.titleView offset:0];
    [self.titleLabel addConstraint:NSLayoutAttributeBottom equalTo:self.titleView offset:0];
    
}

- (void)initData{
    
    _yearArray   = [NSMutableArray new];
    _monthArray  = [NSMutableArray new];
    _dayArray    = [NSMutableArray new];
    _hourArray   = [NSMutableArray new];
    _minuteArray = [NSMutableArray new];
    _secondArray = [NSMutableArray new];
    
    for (int i = 0; i < 60; i ++) {
        NSString *num = [NSString stringWithFormat:@"%02d",i];
        if (0<i && i<=12) [_monthArray addObject:num];
        if (i<24) [_hourArray addObject:num];
        
        [_minuteArray addObject:num];
        [_secondArray addObject:num];
    }
    for (NSInteger i = YWMINYEAR; i <= YWMAXYEAR; i++) {
        NSString *num = [NSString stringWithFormat:@"%ld",(long)i];
        [_yearArray addObject:num];
    }
}
//滚动到指定的时间位置
- (void)getNowDate:(NSDate *)date animated:(BOOL)animated
{
    if (!date) {
        date = [NSDate date];
    }
    
    [self daysOnYear:date.year month:date.month];
    
    _yearIndex = date.year - YWMINYEAR;
    _monthIndex = date.month-1;
    _dayIndex = date.day-1;
    _hourIndex = date.hour;
    _minuteIndex = date.minute;
    _secondIndex = date.seconds;

    NSArray *indexArray;
    
    if (_datePickerStyle == YWAlertStyleShowYearMonthDayHourMinuteSecond){
        indexArray = @[@(_yearIndex),@(_monthIndex),@(_dayIndex),
                       @(_hourIndex),@(_minuteIndex),@(_secondIndex)];
    }
    
    [self.datePicker reloadAllComponents];
    
    for (int i=0; i<indexArray.count; i++) {

    [self.datePicker selectRow:[indexArray[i] integerValue] inComponent:i animated:animated];
    }
    
    self.messageLabel.text = _yearArray[_yearIndex];
}

//通过年月求每月天数
- (NSInteger)daysOnYear:(NSInteger)year month:(NSInteger)month
{
    NSInteger numYear  = year;
    NSInteger numMonth = month;
    
    //判断是否闰年
    BOOL isLeapYear = numYear%4 == 0 ? (numYear%100 == 0 ? (numYear%400 == 0 ? YES:NO):YES):NO;
    switch (numMonth) {
        case 1:case 3:case 5:case 7:case 8:case 10:case 12:{
            [self setdayArray:31];
            return 31;
            break;
        }
        case 4:case 6:case 9:case 11:{
            [self setdayArray:30];
            return 30;
            break;
        }
        case 2:{
            if (isLeapYear) {
                [self setdayArray:29];
                return 29;
            }else{
                [self setdayArray:28];
                return 28;
            }
        }
        default:
            break;
    }
    return 0;
}

//设置每月的天数数组
- (void)setdayArray:(NSInteger)num
{
    [_dayArray removeAllObjects];
    for (int i=1; i<=num; i++) {
        [_dayArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
}

//MARK: ---
- (void)show{
    UIWindow *keyWindows = [UIApplication sharedApplication].keyWindow;
    [keyWindows addSubview:self];
    
    [self addConstraint:NSLayoutAttributeLeft equalTo:keyWindows offset:0];
    [self addConstraint:NSLayoutAttributeRight equalTo:keyWindows offset:0];
    [self addConstraint:NSLayoutAttributeTop equalTo:keyWindows offset:0];
    [self addConstraint:NSLayoutAttributeBottom equalTo:keyWindows offset:0];
    
    [self layoutIfNeeded];
    
    _datePicker.delegate = self;
    _datePicker.dataSource = self;
    
    
    [self getNowDate:[NSDate date:@"2020-09-20 23:31:20" format:YWDateStyleYYYYMMDDHHMMSS] animated:NO];
    
}

-(void)buttionClick:(UIButton *)btn{
    [self removeFromSuperview];
}

- (void)setSheetFrame{
    
    [self.titleView layoutIfNeeded];
    [self.messageLabel layoutIfNeeded];
    [self.buttionContainerView layoutIfNeeded];

    CGFloat heigth = CGRectGetHeight(self.titleView.frame) + CGRectGetHeight(self.messageLabel.frame) + CGRectGetHeight(self.buttionContainerView.frame);

    [self.pickerAlertView addConstraint:NSLayoutAttributeCenterX equalTo:self offset:0];
    [self.pickerAlertView addConstraint:NSLayoutAttributeCenterY equalTo:self offset:0];
    [self.pickerAlertView addConstraint:NSLayoutAttributeHeight equalTo:nil offset:heigth];
    [self.pickerAlertView addConstraint:NSLayoutAttributeWidth equalTo:nil offset:_pickerAlertViewWidth];
    
}

//MARK: --- 参数设置
- (void)setTitleViewTitleColor:(UIColor *)color{
    
    _dateLabelColor = color;
    
}

//MARK: --- 懒加载

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
        _titleView.backgroundColor = DefaultTranslucenceColor;
    }
    return _titleView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = @"请选择";
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
#pragma mark - getter / setter
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

#pragma mark - 改变分割线的颜色
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
- (void)dealloc{
    NSLog(@"%s",__func__);
 
}
@end
