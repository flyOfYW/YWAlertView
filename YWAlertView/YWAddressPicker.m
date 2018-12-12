//
//  YWAddressPicker.m
//  YWAlertViewDemo
//
//  Created by yaowei on 2018/12/5.
//  Copyright © 2018 yaowei. All rights reserved.
//

#import "YWAddressPicker.h"
#import "YWAlertViewHelper.h"
#import "UIView+Autolayout.h"
#import "YWAddressModel.h"
#import "YWContainerViewController.h"

@interface YWAddressPicker ()
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
/** 省份数组 */
@property (nonatomic, strong) NSMutableArray *provinceList;
/** 市数组 */
@property (nonatomic, strong) NSMutableArray *cityList;
/** 地区数组 */
@property (nonatomic, strong) NSMutableArray *areaList;
/** 选中的省 */
@property(nonatomic, strong) YWProvinceModel *selectProvinceModel;
/** 选中的市 */
@property(nonatomic, strong) YWCityModel *selectCityModel;
/** 选中的区 */
@property(nonatomic, strong) YWAreaModel *selectAreaModel;




@end

@implementation YWAddressPicker


- (instancetype _Nullable)initWithTitle:(nullable NSString *)title
                               delegate:(id _Nullable)delegate
                              bodyStyle:(YWAlertPublicBodyStyle)bodyStyle
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
    _pickerStyle = bodyStyle;
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self parseDataSource];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"加载本地数据完成");
//            [self.datePicker reloadAllComponents];
//        });
//    });

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
    
    UIWindow *keyWindows = [UIApplication sharedApplication].keyWindow;
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
    
    switch (_pickerStyle) {
        case YWAlertAddressPickerShowProvince:
            [self selectIndex:self.selectProvinceModel.index inComponent:0 animated:NO];
            break;
        case YWAlertAddressPickerShowCity:
            [self selectIndex:self.selectProvinceModel.index inComponent:0 animated:NO];
            [self selectIndex:self.selectCityModel.index inComponent:1 animated:NO];
            break;
        case YWAlertAddressPickerShowArea:
            [self selectIndex:self.selectProvinceModel.index inComponent:0 animated:NO];
            [self selectIndex:self.selectCityModel.index inComponent:1 animated:NO];
            [self selectIndex:self.selectAreaModel.index inComponent:2 animated:NO];
            break;
        
        default:
            break;
    }
}
/**
 显示在viewController上
 */
- (void)showOnViewController{
    self.maskView.backgroundColor = [UIColor clearColor];
    switch (_pickerStyle) {
        case YWAlertAddressPickerShowProvince:
            [self selectIndex:self.selectProvinceModel.index inComponent:0 animated:NO];
            break;
        case YWAlertAddressPickerShowCity:
            [self selectIndex:self.selectProvinceModel.index inComponent:0 animated:NO];
            [self selectIndex:self.selectCityModel.index inComponent:1 animated:NO];
            break;
        case YWAlertAddressPickerShowArea:
            [self selectIndex:self.selectProvinceModel.index inComponent:0 animated:NO];
            [self selectIndex:self.selectCityModel.index inComponent:1 animated:NO];
            [self selectIndex:self.selectAreaModel.index inComponent:2 animated:NO];
            break;
        default:
            break;
    }
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
        YWResultModel *model = [YWResultModel new];
        model.province = [self.selectProvinceModel copy];
        if (_pickerStyle == YWAlertAddressPickerShowCity) {
            model.city = [self.selectCityModel copy];
        }else if (_pickerStyle == YWAlertAddressPickerShowArea){
            model.city = [self.selectCityModel copy];
            model.area = [self.selectAreaModel copy];
        }
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
    switch (_pickerStyle) {
        case YWAlertAddressPickerShowProvince:
            return 1;
            break;
        case YWAlertAddressPickerShowCity:
            return 2;
            break;
        case YWAlertAddressPickerShowArea:
            return 3;
            break;
        default:
            return 0;
            break;
    }
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return self.provinceList.count;
            break;
        case 1:
            return self.cityList.count;
            break;
        case 2:
            return self.areaList.count;
            break;
        default:
            return 0;
            break;
    }
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
    NSString *title;
    switch (_pickerStyle) {
        case YWAlertAddressPickerShowProvince:{
                YWProvinceModel *model = self.provinceList[row];
               title = [NSString stringWithFormat:@"%@",model.name];
        }
            break;
        case YWAlertAddressPickerShowCity:{
            if (component == 0){
                YWProvinceModel *model = self.provinceList[row];
                title = [NSString stringWithFormat:@"%@",model.name];
            }else if (component == 1){
                YWCityModel *model = self.cityList[row];
                title = [NSString stringWithFormat:@"%@",model.name];
            }
        }
            break;
        case YWAlertAddressPickerShowArea:{
            if (component == 0){
                YWProvinceModel *model = self.provinceList[row];
                title = [NSString stringWithFormat:@"%@",model.name];
            }else if (component == 1){
                YWCityModel *model = self.cityList[row];
                title = [NSString stringWithFormat:@"%@",model.name];
            }else if (component == 2){
                YWAreaModel *model = self.areaList[row];
                title = [NSString stringWithFormat:@"%@",model.name];
            }
        }
            break;
        default:
            title = @"";
            break;
    }
    nameLabel.text = title;
    return nameLabel;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 36;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (_pickerStyle) {
        case YWAlertAddressPickerShowProvince:{
            if (component == 0)
                self.selectProvinceModel = self.provinceList[row];
                self.selectCityModel = nil;
                self.selectAreaModel = nil;
                //设置结果
                break;
        }
        case YWAlertAddressPickerShowCity:{
            if (component == 0){
                self.selectProvinceModel = self.provinceList[row];
                @synchronized (self) {
                    [self.cityList removeAllObjects];
                }
                [self.cityList addObjectsFromArray:self.selectProvinceModel.citylist];
                self.selectCityModel = self.cityList.firstObject;
                self.selectAreaModel = nil;
                [pickerView reloadComponent:1];
                [self.datePicker selectRow:0 inComponent:1 animated:YES];
            }else if (component == 1){
                self.selectCityModel = self.cityList[row];
                self.selectAreaModel = nil;
            }
                break;
        }
        case YWAlertAddressPickerShowArea:{
            if (component == 0){
                self.selectProvinceModel = self.provinceList[row];
                @synchronized (self) {
                    [self.cityList removeAllObjects];
                }
                [self.cityList addObjectsFromArray:self.selectProvinceModel.citylist];
                self.selectCityModel = self.cityList.firstObject;
                @synchronized (self) {
                    [self.areaList removeAllObjects];
                }
                [self.areaList addObjectsFromArray:self.selectCityModel.arealist];
                self.selectAreaModel = self.areaList.firstObject;
                [pickerView reloadComponent:1];
                [pickerView reloadComponent:2];
                [self.datePicker selectRow:0 inComponent:1 animated:YES];
                [self.datePicker selectRow:0 inComponent:2 animated:YES];

            }else if (component == 1){
                self.selectCityModel = self.cityList[row];
                @synchronized (self) {
                    [self.areaList removeAllObjects];
                }
                [self.areaList addObjectsFromArray:self.selectCityModel.arealist];
                self.selectAreaModel = self.areaList.firstObject;
                [pickerView reloadComponent:2];
                [self.datePicker selectRow:0 inComponent:2 animated:YES];
            }
            break;
        }
        default:
            break;
    }
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
 alert背景图(目前对YWAlert有效)
 
 @param image image
 @param articulation 0~1(越小越清晰)
 */
- (void)setAlertBackgroundView:(UIImage *)image articulation:(CGFloat)articulation{
    NSLog(@"地址选择器目前不支持alert背景图");
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
/**
 设置默认省市区

 @param defalutModel 默认模型
 */
- (void)setDefalutOnAddressPickerView:(YWResultModel *)defalutModel{
    
    NSAssert(!(defalutModel==nil), @"defalutModel不能为nil");
    YWProvinceModel *tempProinceModel = nil;
    YWCityModel *tempCityModel = nil;
    YWAreaModel *tempAreaModel = nil;
    if (_pickerStyle == YWAlertAddressPickerShowProvince) {
       NSString *province = defalutModel.province.name;
        if (!province) {
            NSLog(@"没有传入默认的省份名称，匹配不到情况下，默认值为内部实现的默认值");
        }else{
            for (YWProvinceModel *model in self.provinceList) {
                if ([model.name isEqualToString:province]) {
                    tempProinceModel = model;
                    break;
                }
            }
        }
        if (!tempProinceModel) {
            tempProinceModel = self.selectProvinceModel;
        }
    }else if (_pickerStyle == YWAlertAddressPickerShowCity){
        
        NSString *province = defalutModel.province.name;
        NSString *city = defalutModel.city.name;

        if (!province) {
            NSLog(@"没有传入默认的省份名称，匹配不到情况下，默认值为内部实现的默认值");
            NSAssert(!(city!=nil), @"必须有省份才有市");
        }else{
            for (YWProvinceModel *model in self.provinceList) {
                if ([model.name isEqualToString:province]) {
                    tempProinceModel = model;
                    break;
                }
            }
        }
        //省份匹不到情况下，取默认值
        if (!tempProinceModel) {
            tempProinceModel = self.selectProvinceModel;
        }
        @synchronized (self) {
            [self.cityList removeAllObjects];
            [self.cityList addObjectsFromArray:tempProinceModel.citylist];
        }
        
        if (!city) {
            NSLog(@"没有传入默认的市的名称，匹配不到情况下，默认值为内部实现的默认值");
        }else{
            for (YWCityModel *model in self.cityList) {
                if ([model.name isEqualToString:city]) {
                    tempCityModel = model;
                    break;
                }
            }
            if (!tempCityModel) {
                tempCityModel = tempProinceModel.citylist.firstObject;
            }
        }
        //市匹配不到情况下，取省份的第一个市
        if (!tempCityModel) {
            tempCityModel = tempProinceModel.citylist.firstObject;
        }
    }else if (_pickerStyle == YWAlertAddressPickerShowArea){
        NSString *province = defalutModel.province.name;
        NSString *city = defalutModel.city.name;
        NSString *area = defalutModel.area.name;

        if (!province) {
            NSLog(@"没有传入默认的省份名称，匹配不到情况下，默认值为内部实现的默认值");
            NSAssert(!(city!=nil), @"必须有省份才有市");
            NSAssert(!(area!=nil), @"必须有省份才有市才有区，不能跨级,避免数据混乱");
        }else{
            for (YWProvinceModel *model in self.provinceList) {
                if ([model.name isEqualToString:province]) {
                    tempProinceModel = model;
                    break;
                }
            }
        }
        //省份匹不到情况下，取默认值
        if (!tempProinceModel) {
            tempProinceModel = self.selectProvinceModel;
        }
        @synchronized (self) {
            [self.cityList removeAllObjects];
            [self.cityList addObjectsFromArray:tempProinceModel.citylist];
        }

        
        if (!city) {
            NSLog(@"没有传入默认的市的名称，匹配不到情况下，默认值为内部实现的默认值");
            NSAssert(!(area!=nil), @"必须有省份才有市才有区，不能跨级,避免数据混乱");
        }else{
            for (YWCityModel *model in self.cityList) {
                if ([model.name isEqualToString:city]) {
                    tempCityModel = model;
                    break;
                }
            }
        }
        //市匹配不到情况下，取省份的第一个市
        if (!tempCityModel) {
            tempCityModel = tempProinceModel.citylist.firstObject;
        }
        @synchronized (self) {
            [self.areaList removeAllObjects];
            [self.areaList addObjectsFromArray:tempCityModel.arealist];
        }

        
        if (!area) {
            NSLog(@"没有传入默认的区的名称，匹配不到情况下，默认值为内部实现的默认值");
        }else{
            for (YWAreaModel *model in self.areaList) {
                if ([model.name isEqualToString:area]) {
                    tempAreaModel = model;
                    break;
                }
            }
        }
        //区匹配不到情况下，取市的第一个区
        if (!tempAreaModel) {
            tempAreaModel = tempCityModel.arealist.firstObject;
        }
    }
    self.selectProvinceModel = tempProinceModel;
    self.selectCityModel = tempCityModel;
    self.selectAreaModel = tempAreaModel;
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
// 解析数据源
- (void)parseDataSource {
    
    NSArray *dataSource = [self loadLocationData];
    
    NSMutableArray *tempArr1 = [NSMutableArray array];
    
    for (NSDictionary *proviceDic in dataSource) {
        YWProvinceModel *proviceModel = [[YWProvinceModel alloc]init];
        proviceModel.code = proviceDic[@"code"];
        proviceModel.name = proviceDic[@"name"];
        proviceModel.index = [dataSource indexOfObject:proviceDic];
        NSArray *citylist = proviceDic[@"citylist"];
        NSMutableArray *tempArr2 = [NSMutableArray array];
        for (NSDictionary *cityDic in citylist) {
            YWCityModel *cityModel = [[YWCityModel alloc]init];
            cityModel.code = cityDic[@"code"];
            cityModel.name = cityDic[@"name"];
            cityModel.index = [citylist indexOfObject:cityDic];
            NSArray *arealist = cityDic[@"arealist"];
            NSMutableArray *tempArr3 = [NSMutableArray array];
            for (NSDictionary *areaDic in arealist) {
                YWAreaModel *areaModel = [[YWAreaModel alloc]init];
                areaModel.code = areaDic[@"code"];
                areaModel.name = areaDic[@"name"];
                areaModel.index = [arealist indexOfObject:areaDic];
                [tempArr3 addObject:areaModel];
            }
            cityModel.arealist = [tempArr3 copy];
            [tempArr2 addObject:cityModel];
        }
        proviceModel.citylist = [tempArr2 copy];
        [tempArr1 addObject:proviceModel];
    }
    
    [self.provinceList removeAllObjects];
    [self.provinceList addObjectsFromArray:[tempArr1 copy]];
    
    //设置默认选中的
    self.selectProvinceModel = self.provinceList.firstObject;
    self.selectCityModel = self.selectProvinceModel.citylist.firstObject;
    self.selectAreaModel = self.selectCityModel.arealist.firstObject;
    
    [self.cityList removeAllObjects];
    [self.areaList removeAllObjects];

    [self.cityList addObjectsFromArray:self.selectProvinceModel.citylist];
    [self.areaList addObjectsFromArray:self.selectCityModel.arealist];

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
- (NSMutableArray *)provinceList{
    if (!_provinceList) {
        _provinceList = [NSMutableArray new];
    }
    return _provinceList;
}
- (NSMutableArray *)cityList{
    if (!_cityList) {
        _cityList = [NSMutableArray new];
    }
    return _cityList;
}
- (NSMutableArray *)areaList{
    if (!_areaList) {
        _areaList = [NSMutableArray new];
    }
    return _areaList;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setSheetFrame];
}
@end
