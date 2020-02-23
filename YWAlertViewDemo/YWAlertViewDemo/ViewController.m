//
//  ViewController.m
//  YWAlertViewDemo
//
//  Created by yaowei on 2018/8/27.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "ViewController.h"
#import "YWAlertView.h"
#import "YWTheme.h"
#import "UIImage+YW.h"

@interface ViewController ()
<YWAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *list;
//Alert懒加载演示
@property (nonatomic,strong) id <YWAlertViewProtocol>ywAlert;
//sheet懒加载演示
@property (nonatomic,strong) id <YWAlertViewProtocol>sheetAlert;
//Address懒加载演示
@property (nonatomic,strong) id <YWAlertViewProtocol>alert;
//date懒加载演示
@property (nonatomic,strong) id <YWAlertViewProtocol>dateAlert;


@end

int i = 0;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    
    tableView.backgroundColor = [UIColor cyanColor];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.list.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dict = self.list[section];
    return [[dict objectForKey:@"msg"] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
    }
    NSDictionary *dict = self.list[indexPath.section];
    NSArray *sAr = [dict objectForKey:@"msg"];
    cell.textLabel.text = [sAr objectAtIndex:indexPath.row];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *view = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    NSDictionary *dict = self.list[section];

    view.text = [dict objectForKey:@"section"];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self alert_defalut];
                break;
            case 1:
                [self alert_vertical];
                break;
            case 2:
                [self alert_defalut_close];
                break;
            case 3:
                [self alert_defalut_body_custom];
                break;
            case 4:
                [self alert_defalut_body_theme];
                break;
            case 5:
                [self alert_defalut_body_VC];
                break;
            case 6:
                [self alert_Segmentation_fontName];
                break;
            case 7:
                [self alert_not_title];
                break;
            case 8:
                [self alert_defalut_lazing];
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                [self sheet_defalut];
                break;
            case 1:
                [self sheet_no_title];
                break;
            case 2:
                [self sheet_no_msg];
                break;
            case 3:
                [self sheet_no_other];
                break;
            case 4:
                [self sheet_no_canlcel];
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 2){
        switch (indexPath.row) {
            case 0:
                [self date_defalut];
                break;
            case 1:
                [self date_defalut_Vertical];
                break;
            case 2:
                [self date_defalut_once];
                break;
            case 3:
                [self date_defalut_yearMoth];
                break;
            case 4:
                [self date_defalut_hourMinuteSecond];
                break;
            case 5:
                [self date_defalut_foot];
                break;
            case 6:
                [self date_defalut_yearMonthDay_foot];
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 3){
        switch (indexPath.row) {
            case 0:
                [self address_defalut];
                break;
            case 1:
                [self address_defalut_lazing];
                break;
            case 2:
                [self address_defalut_modityHeight];
                break;
            case 3:
                [self address_setting_defalutValue];
                break;
            case 4:
                [self address_mode1_defalutValue];
                break;
                
                
            default:
                break;
        }
    }
    
    
    
}
- (id<YWAlertViewProtocol>)ywAlert{
    if (!_ywAlert) {
        _ywAlert = [YWAlertView alertViewWithTitle:nil message:@"message" delegate:self preferredStyle:YWAlertViewStyleAlert footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertPublicBodyStyleDefalut cancelButtonTitle:@"cancel" otherButtonTitles:@[@"Ok"]];
    }
    return _ywAlert;
}
- (void)alert_defalut_lazing{
    [(id<YWAlertAlertViewProtocol>)self.ywAlert resetAlertMessage:@"懒加载模式，我要重置message的信息，高度也要进行相关的变化哦"];
    [(id<YWAlertAlertViewProtocol>)self.ywAlert resetAlertTitle:@"使用第一行的对象alter"];
    [self.ywAlert show];
}
- (void)alert_defalut{
    if (i == 0) {
        [self.ywAlert show];
    }else if (i == 1){
        [(id<YWAlertAlertViewProtocol>)self.ywAlert resetAlertTitle:@"第一行的对象alter"];
        [(id<YWAlertAlertViewProtocol>)self.ywAlert resetAlertMessage:@"message"];
        [self.ywAlert showOnViewController];
    }else{
        [(id<YWAlertAlertViewProtocol>)self.ywAlert resetAlertTitle:@"第一行的对象alter"];
        [(id<YWAlertAlertViewProtocol>)self.ywAlert resetAlertMessage:@"懒加载模式，我要重置message的信息，高度也要进行相关的变化哦"];
        [self.ywAlert show];
    }
    i ++;
}
- (void)alert_vertical{
    
    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:@"温馨提示" message:@"Do any additional setup after loading the view,typically from a nib.Do any additional setup after loading the view," delegate:self preferredStyle:YWAlertViewStyleAlert footStyle:YWAlertPublicFootStyleVertical bodyStyle:YWAlertPublicBodyStyleDefalut cancelButtonTitle:@"cancel" otherButtonTitles:@[@"Ok",@"other"]];
    [alert setMessageFontWithName:@"BodoniSvtyTwoITCTT-BookIta" size:16];
    [alert show];
    
}
- (void)alert_defalut_close{

    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:@"温馨提示" message:@"Do any additional setup after loading the view,typically from a nib" preferredStyle:YWAlertViewStyleAlert footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertPublicBodyStyleDefalut cancelButtonTitle:nil otherButtonTitles:nil handler:^(NSInteger buttonIndex, id  _Nullable value) {
        NSLog(@"block=当前点击--%zi",buttonIndex);
    }];
    [alert setMessageFontWithName:@"Bodoni Ornaments" size:15];
    [(id<YWAlertAlertViewProtocol>)alert showCloseOnTitleView];
    [alert show];
}
- (void)alert_defalut_body_custom{
    
    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:@"温馨提示" message:nil delegate:self preferredStyle:YWAlertViewStyleAlert footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertPublicBodyStyleCustom cancelButtonTitle:@"cancel" otherButtonTitles:@[@"Ok",@"other"]];
    
    UIView *view = [UIView new];
    
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[@"自定义的body",@"自定义的body"]];
    seg.selectedSegmentIndex = 0;
    seg.frame = CGRectMake(20, 20, 200, 30);
    [view addSubview:seg];
    [(id<YWAlertAlertViewProtocol>)alert setCustomBodyView:view height:80];
    [alert show];
}

- (void)alert_defalut_body_theme{
    
    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:@"Warm prompt" message:@"Theme configuration color and background map" delegate:self preferredStyle:YWAlertViewStyleAlert footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertPublicBodyStyleDefalut cancelButtonTitle:@"cancel" otherButtonTitles:@[@"Ok"]];
    [alert setTheme:[YWTheme new]];
    [alert hiddenAllLineView];
    [alert hiddenBodyLineView];

    [alert show];
}
- (void)alert_defalut_body_VC{
    
    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:@"温馨提示" message:@"主题配置颜色以及背景图" delegate:self preferredStyle:YWAlertViewStyleAlert footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertPublicBodyStyleDefalut cancelButtonTitle:@"cancel" otherButtonTitles:@[@"Ok"]];
    [alert setTheme:[YWTheme new]];
    [alert showOnViewController];
}

- (void)alert_Segmentation_fontName{
    
    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:@"温馨提示" message:@"Do any additional setup after loading the view" delegate:self preferredStyle:YWAlertViewStyleAlert footStyle:YWAlertPublicFootStyleSegmentation bodyStyle:YWAlertPublicBodyStyleDefalut cancelButtonTitle:@"cancel" otherButtonTitles:@[@"Ok"]];
    [alert setButtionTitleFontWithName:@"AmericanTypewriter" size:16 index:1];
    [alert setButtionTitleFontWithName:@"AmericanTypewriter-Bold" size:16 index:0];

    [alert show];
}
- (void)alert_not_title{
    
    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:nil message:@"Do any additional setup after loading the view" delegate:self preferredStyle:YWAlertViewStyleAlert footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertPublicBodyStyleDefalut cancelButtonTitle:@"cancel" otherButtonTitles:@[@"Ok"]];
    [alert setButtionTitleFontWithName:@"AmericanTypewriter" size:16 index:1];
    [alert setButtionTitleFontWithName:@"AmericanTypewriter-Bold" size:16 index:0];
    
    [alert show];
}

- (id<YWAlertViewProtocol>)sheetAlert{
    if (!_sheetAlert) {//@"温馨提示"
        _sheetAlert = [YWAlertView alertViewWithTitle:@"温馨提示" message:nil delegate:self preferredStyle:YWAlertViewStyleActionSheet footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertPublicBodyStyleDefalut cancelButtonTitle:@"cancel" otherButtonTitles:@[@"Ok"]];
    }
    return _sheetAlert;
}

- (void)sheet_defalut{
//    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:@"温馨提示" message:@"Do any additional setup after loading the view,setup after loading the view,setup after loading the view" delegate:self preferredStyle:YWAlertViewStyleActionSheet footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertPublicBodyStyleDefalut cancelButtonTitle:@"cancel" otherButtonTitles:@[@"Ok"]];
    [(id<YWAlertActionSheetViewProtocol>)self.sheetAlert resetAlertTitle:@"温馨提示"];
    [(id<YWAlertActionSheetViewProtocol>)self.sheetAlert resetAlertMessage:@"Do any additional setup after loading the view,setup after loading the view,setup after loading the view"];
    [self.sheetAlert show];
}
- (void)sheet_no_title{
//    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:nil message:@"Do any additional setup after loading the view,setup after loading the view,setup after loading the view" delegate:self preferredStyle:YWAlertViewStyleActionSheet footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertPublicBodyStyleDefalut cancelButtonTitle:@"cancel" otherButtonTitles:@[@"Ok"]];
    
    [self.sheetAlert setMessageFontWithName:@"BradleyHandITCTT-Bold" size:20];
    [(id<YWAlertActionSheetViewProtocol>)self.sheetAlert resetAlertMessage:@"懒加载演示修改message,同时修改头部"];
    [(id<YWAlertActionSheetViewProtocol>)self.sheetAlert resetAlertTitle:nil];

    [self.sheetAlert show];
}

- (void)sheet_no_msg{
    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:@"温馨提示" message:nil delegate:self preferredStyle:YWAlertViewStyleActionSheet footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertPublicBodyStyleDefalut cancelButtonTitle:@"cancel" otherButtonTitles:@[@"Ok"]];
    [alert setMessageTitleColor:[UIColor redColor]];
    [alert show];
}
- (void)sheet_no_other{
    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:@"温馨提示" message:@"没有其他按钮" delegate:self preferredStyle:YWAlertViewStyleActionSheet footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertPublicBodyStyleDefalut cancelButtonTitle:@"cancel" otherButtonTitles:nil];
    [alert show];
}
- (void)sheet_no_canlcel{
    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:@"温馨提示" message:@"没有取消按钮" delegate:self preferredStyle:YWAlertViewStyleActionSheet footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertPublicBodyStyleDefalut cancelButtonTitle:nil otherButtonTitles:@[@"other 1",@"other 2"]];
    [alert show];
}
- (void)date_defalut{
    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:@"请选择日期" preferredStyle:YWAlertViewStyleDatePicker footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertStyleShowYearMonthDayHourMinuteSecond cancelButtonTitle:@"取消" sureButtonTitles:@"确定" handler:^(NSInteger buttonIndex, id  _Nullable value) {
        
    }];
    [alert setTitleViewTitleColor:[UIColor redColor]];
    [alert show];
}
- (void)date_defalut_Vertical{
    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:@"请选择日期" preferredStyle:YWAlertViewStyleDatePicker footStyle:YWAlertPublicFootStyleVertical bodyStyle:YWAlertStyleShowYearMonthDayHourMinute cancelButtonTitle:@"取消" sureButtonTitles:@"确定" handler:^(NSInteger buttonIndex, id  _Nullable value) {
        
    }];
    [alert show];
}
- (void)date_defalut_once{
    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:@"请选择日期" preferredStyle:YWAlertViewStyleDatePicker footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertStyleShowYearMonthDay cancelButtonTitle:@"取消" sureButtonTitles:@"确定" handler:^(NSInteger buttonIndex, id  _Nullable value) {
        
    }];
    [alert setGaussianBlurImage:[UIImage yw_blurImage:[UIImage imageNamed:@"bg_fuweus"] blur:1]];
    [alert showOnViewController];
}

- (void)date_defalut_yearMoth{
    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:@"请选择日期" preferredStyle:YWAlertViewStyleDatePicker footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertStyleShowYearMonth cancelButtonTitle:@"取消" sureButtonTitles:@"确定" handler:^(NSInteger buttonIndex, id  _Nullable value) {
        NSLog(@"选择日期 %@",value);
    }];
    [alert setGaussianBlurImage:[UIImage yw_blurImage:[UIImage imageNamed:@"bg_fuweus"] blur:1]];
    [alert showOnViewController];
}
- (void)date_defalut_hourMinuteSecond{
    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:@"请选择日期" preferredStyle:YWAlertViewStyleDatePicker  footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertStyleShowHourMinuteSecond cancelButtonTitle:@"取消" sureButtonTitles:@"确定" handler:^(NSInteger buttonIndex, id  _Nullable value) {
        NSLog(@"选择日期 %@",value);
    }];
    [alert setGaussianBlurImage:[UIImage yw_blurImage:[UIImage imageNamed:@"bg_fuweus"] blur:1]];
    [alert showOnViewController];
}
- (void)date_defalut_foot{
    //懒加载模式演示
    [(id<YWAlertDatePickerViewProtocol>)self.dateAlert setPickerHeightOnDatePickerView:300];
    [self.dateAlert show];

    
}
- (void)date_defalut_yearMonthDay_foot{
    //懒加载模式演示
    [self.dateAlert show];
    
}

- (id<YWAlertViewProtocol>)dateAlert{
    if (!_dateAlert) {
        _dateAlert = [YWAlertView alertViewWithTitle:@"请选择日期" preferredStyle:YWAlertViewStyleDatePicker2 footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertStyleShowYearMonthDay cancelButtonTitle:@"取消" sureButtonTitles:@"确定" handler:^(NSInteger buttonIndex, id  _Nullable value) {
            NSLog(@"选择日期 %@",value);
        }];
    }
    return _dateAlert;
}

- (void)address_defalut{
    
    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:@"请选择地区" message:nil preferredStyle:YWAlertViewStyleAddressPicker footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertAddressPickerShowArea cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(NSInteger buttonIndex, id  _Nullable value) {

    }];
    
    [alert show];
}
- (void)address_defalut_lazing{
    //    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:@"请选择地区" message:nil preferredStyle:YWAlertViewStyleAddressPicker footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertAddressPickerShowArea cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(NSInteger buttonIndex, id  _Nullable value) {
    //
    //    }];
    //支持懒加载
    [self.alert show];
}
- (void)address_defalut_modityHeight{

    id<YWAlertAddressPickerViewProtocol>newAlert = (id<YWAlertAddressPickerViewProtocol>)self.alert;

    [newAlert setPickerHeightOnAddressPickerView:220];
    //支持懒加载
    [self.alert show];
}

- (void)address_setting_defalutValue{
    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:@"请选择地区" message:nil preferredStyle:YWAlertViewStyleAddressPicker footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertAddressPickerShowArea cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(NSInteger buttonIndex, id  _Nullable value) {
        
    }];
#warning 强转协议的原因
    ///<YWAlertAddressPickerViewProtocol>继承于<YWAlertViewProtocol>
    ///强转，以便调用<YWAlertAddressPickerViewProtocol>的私有方法
    id<YWAlertAddressPickerViewProtocol>newAlert = (id<YWAlertAddressPickerViewProtocol>)alert;
    YWResultModel *reModel = [YWResultModel new];
    YWProvinceModel *pModel = [YWProvinceModel new];
    pModel.name = @"广东省";
    reModel.province = pModel;
    [newAlert setDefalutOnAddressPickerView:reModel];
    [alert show];
}
- (void)address_mode1_defalutValue{
    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:@"请选择地区" message:nil preferredStyle:YWAlertViewStyleAddressPicker footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertAddressPickerShowCity cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(NSInteger buttonIndex, id  _Nullable value) {

    }];
    [alert show];
    
//    YWSingleGeneralModel *model = [YWSingleGeneralModel new];
//    model.idc = 1;
//    model.displayName = @"1岁";
//
//
//    YWSingleGeneralModel *model1 = [YWSingleGeneralModel new];
//     model1.idc = 2;
//     model1.displayName = @"2岁";
//
//    YWSingleGeneralModel *model2 = [YWSingleGeneralModel new];
//     model2.idc = 3;
//     model2.displayName = @"3岁";
//
//
//    id <YWAlertSingleGeneralPickerViewProtocol>alert = [YWAlertView alertViewWithTitle:@"请选择" dataSource:@[model,model1,model2] cancelButtonTitle:@"取消" sureButtonTitles:@"确定" handler:^(NSInteger buttonIndex, id  _Nullable value) {
//        YWSingleGeneralModel *s = value;
//        NSLog(@"---%@",s.displayName);
//    }];
//    [alert setDefalutOnSingleGeneraPickerView:model1];
//    [alert show];
}



- (id<YWAlertViewProtocol>)alert{
    if (!_alert) {
        _alert = [YWAlertView alertViewWithTitle:@"请选择地区" message:nil preferredStyle:YWAlertViewStyleAddressPicker footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertAddressPickerShowArea cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(NSInteger buttonIndex, id  _Nullable value) {
            
        }];
    }
    return _alert;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{


    /*
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"获取图片" message:@"00000" preferredStyle: UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"打开照相机" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    
    
    [alertController addAction:cancelAction];
    
    
    
    [alertController addAction:deleteAction];
    
    
    
//    [alertController addAction:archiveAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    */
    
}
- (void)initData{
    self.list = @[].mutableCopy;
    [self.list addObject:@{@"section":@"  alter模式",@"msg":@[@"YWAlertViewStyleAlert模式下的YWAlertPublicStyleDefalut",@"YWAlertViewStyleAlert模式下的YWAlertPublicStyleVertical",@"YWAlertViewStyleAlert模式下的各个模式均可以显示CloseBtn",@"YWAlertViewStyleAlert模式下的YWAlertPublicBodyStyleCustom",@"YWAlertViewStyleAlert模式下的theme主题配置基本信息",@"YWAlertViewStyleAlert显示控制器上",@"YWAlertViewStyleAlert的YWAlertPublicFootStyleSegmentation字号及其大小",@"YWAlertViewStyleAlert的没有title",@"开始支持懒加载，同时支持修改title以及message，高度动态变化"]}];
    
    [self.list addObject:@{@"section":@"  sheet模式",@"msg":@[@"YWAlertViewStyleActionSheet模式下",@"YWAlertViewStyleActionSheet模式下没有头部情况下",@"YWAlertViewStyleActionSheet模式下没有message情况下",@"YWAlertViewStyleActionSheet模式下没有other情况下",@"YWAlertViewStyleActionSheet模式下没有cancel情况下"]}];

    [self.list addObject:@{@"section":@"  date模式",@"msg":@[@"中心显示日期选择器年月日时分秒",@"中心显示日期选择器年月日时分",@"中心显示日期选择器年月日",@"中心显示日期选择器年月",@"中心显示日期选择器时分秒",@"底部显示日期选择器年月日时分秒",@"底部显示日期选择器年月日",]}];

    [self.list addObject:@{@"section":@"  address模式",@"msg":@[@"省市区显示",@"懒加载模式",@"修改懒加载alert的高度",@"强转协议，调用专属的方法",@"省市模式"]}];

    
}

- (void)didClickAlertView:(NSInteger)buttonIndex value:(id)value{
    NSLog(@"委托代理=当前点击--%zi",buttonIndex);

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
