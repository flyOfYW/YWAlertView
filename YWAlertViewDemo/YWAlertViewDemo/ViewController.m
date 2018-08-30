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


@interface ViewController ()
<YWAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
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
//                [self alert_Segmentation_fontName];
                break;
            default:
                break;
        }
    }
}

- (void)alert_defalut{
    
    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:@"温馨提示" message:@"Do any additional setup after loading the view" delegate:self preferredStyle:YWAlertViewStyleAlert footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertPublicBodyStyleDefalut cancelButtonTitle:@"cancel" otherButtonTitles:@[@"Ok"]];
    [alert show];
}
- (void)alert_vertical{
    
    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:@"温馨提示" message:@"Do any additional setup after loading the view,typically from a nib.Do any additional setup after loading the view," delegate:self preferredStyle:YWAlertViewStyleAlert footStyle:YWAlertPublicFootStyleVertical bodyStyle:YWAlertPublicBodyStyleDefalut cancelButtonTitle:@"cancel" otherButtonTitles:@[@"Ok",@"other"]];
    [alert show];
    
}
- (void)alert_defalut_close{

    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:@"温馨提示" message:@"Do any additional setup after loading the view,typically from a nib" preferredStyle:YWAlertViewStyleAlert footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertPublicBodyStyleDefalut cancelButtonTitle:nil otherButtonTitles:nil handler:^(NSInteger buttonIndex, id  _Nullable value) {
        NSLog(@"block=当前点击--%zi",buttonIndex);
    }];
    
    [alert showCloseOnTitleView];
    [alert show];
}
- (void)alert_defalut_body_custom{
    
    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:@"温馨提示" message:nil delegate:self preferredStyle:YWAlertViewStyleAlert footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertPublicBodyStyleCustom cancelButtonTitle:@"cancel" otherButtonTitles:@[@"Ok",@"other"]];
    UIImageView *view = [UIImageView new];
    view.image = [UIImage imageNamed:@"105459445"];
    [alert setCustomBodyView:view height:80];
    [alert show];
}
- (void)alert_defalut_body_theme{
    
    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:@"温馨提示" message:@"主题配置颜色以及背景图" delegate:self preferredStyle:YWAlertViewStyleAlert footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertPublicBodyStyleDefalut cancelButtonTitle:@"cancel" otherButtonTitles:@[@"Ok"]];
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
    [self.list addObject:@{@"section":@"  alter模式",@"msg":@[@"YWAlertViewStyleAlert模式下的YWAlertPublicStyleDefalut",@"YWAlertViewStyleAlert模式下的YWAlertPublicStyleVertical",@"YWAlertViewStyleAlert模式下的各个模式均可以显示CloseBtn",@"YWAlertViewStyleAlert模式下的YWAlertPublicBodyStyleCustom",@"YWAlertViewStyleAlert模式下的theme主题配置基本信息",@"YWAlertViewStyleAlert显示控制器上",@"YWAlertViewStyleAlert的YWAlertPublicFootStyleSegmentation字号及其大小"]}];
}

- (void)didClickAlertView:(NSInteger)buttonIndex value:(id)value{
    NSLog(@"委托代理=当前点击--%zi",buttonIndex);

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
