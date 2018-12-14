# YWAlertView
提示弹出框、选择弹出框、日期选择器、地址选择器、高效调用、高效扩展
  ```
    v1.3.0 YWAlertView中的YWAlertViewStyleActionSheet模式支持懒加载，支持动态修改title和message，高度自动变化
    v1.2.2 YWAlertView中的YWAlertViewStyleAlert模式支持懒加载，支持动态修改title和message，高度自动变化
    v1.2.1 新增地址选择器
    v1.0.0 新增日历选择器以及时间格式化以及时间戳相关工具类
    v0.1.0 新增弹框提示和弹框选择器
   ```
### 兼容性
   * iPhone和iPad
   * 横屏和竖屏
   * iOS 7以上
  
### 集成方法
   1. 将YWAlertView文件拖入项目，引入头文件 
   > #import "YWAlertView.h"
   2. 使用cocopod
   ```ruby
      pod 'YWAlertView'
   ```
 
 ### 介绍
 
  YWAlertView目前提供五种模式：
  
    > YWAlertViewStyleAlert
    > YWAlertViewStyleActionSheet
    > YWAlertViewStyleDatePicker ////datePicker默认在中间显示
    > YWAlertViewStyleDatePicker2 //datePicker底部显示
    > YWAlertViewStyleAddressPicker
    
    
    
  * 注意点：YWAlertView并不是view，可以比作是一个简单的工厂，通过它管理规格去生成不同的控件，因为这样后期将陆续加入其它的控件，日历，地址等
  
  
  > ##### * YWAlertViewStyleAlert 的模式
  
  >   1. 默认情况下 
  >       >   ![image](https://github.com/flyOfYW/YWAlertView/blob/master/image/1.png)
  >   2. footView上的按钮横排，这个类似系统的，当多个按钮的时候，就横排显示，而YWAlertView提供三个模式：横排和竖排以及有按钮之间有间距的横排，供开发者自由选择
  >       >   ![image](https://github.com/flyOfYW/YWAlertView/blob/master/image/2.png) ![image](https://github.com/flyOfYW/YWAlertView/blob/master/image/6.png)
  >   3.  没有footView的情况下(支持没有title和message的情况)，可以选择行，把close按钮显示，字体也可以修改
  >       >   ![image](https://github.com/flyOfYW/YWAlertView/blob/master/image/3.png)
  >   4.  bodyView支持自定义（默认显示文字）
  >       >   ![image](https://github.com/flyOfYW/YWAlertView/blob/master/image/4.png)
  >   5.  全局配置基本设置（色调、背景、字体大小、字号等）解决在每次弹框设置这些的参数的烦恼
  >       >   ![image](https://github.com/flyOfYW/YWAlertView/blob/master/image/5.png)
  >   6.  其他情况，请结合demo
  
  
  
  > #####  *  YWAlertViewStyleActionSheet 的模式
  
  >   1.  默认情况下，跟系统的ActionSheet没有什么差异
  >       >   ![image](https://github.com/flyOfYW/YWAlertView/blob/master/image/7.png)
  >   2.  没有title的情况，（支持字号以及字体等修改）
  >       >   ![image](https://github.com/flyOfYW/YWAlertView/blob/master/image/8.png)
  >   3.  没有cancel的情况下
  >       >   ![image](https://github.com/flyOfYW/YWAlertView/blob/master/image/9.png)
  >   4.  其他情况，请结合demo
  
  > #####  *  YWAlertViewStyleDatePicker 的模式
  >   1.  年月日时分秒，位置显示在中间，按钮横排显示
  >       >   ![image](https://github.com/flyOfYW/YWAlertView/blob/master/image/10.png)
  >   2.  年月日时分，位置显示在中间，按钮竖排显示
  >       >   ![image](https://github.com/flyOfYW/YWAlertView/blob/master/image/11.png)
  >   3.  年月日，位置显示在底部
  >       >   ![image](https://github.com/flyOfYW/YWAlertView/blob/master/image/13.png)
  >   4.  其他情况，请结合demo
  
  
 ### 使用
  
  >   1.  delegate回调
  
  ```
     id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:@"温馨提示" message:@"Do any additional setup after loading the view" delegate:self preferredStyle:YWAlertViewStyleAlert footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertPublicBodyStyleDefalut cancelButtonTitle:@"cancel" otherButtonTitles:@[@"Ok"]];
    [alert show];
  ```
  
  >   2.  block回调
  
  ```
    id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:@"温馨提示" message:@"Do any additional setup after loading the view,typically from a nib" preferredStyle:YWAlertViewStyleAlert footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertPublicBodyStyleDefalut cancelButtonTitle:nil otherButtonTitles:nil handler:^(NSInteger buttonIndex, id  _Nullable value) {
        NSLog(@"block=当前点击--%zi",buttonIndex);
    }];
    [alert setMessageFontWithName:@"Bodoni Ornaments" size:15];
    [alert show];
  ```
  
 >    3.  全局配置基本参数
 >    >  创建一个继承NSObject的实体类，并且准守<YWAlertViewThemeProtocol>协议，实现其基本的参数配置方法，在显示alert的时候使用该实体类的对象，如：
  
  ```
      id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:@"温馨提示" message:@"主题配置颜色以及背景图" delegate:self preferredStyle:YWAlertViewStyleAlert footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertPublicBodyStyleDefalut cancelButtonTitle:@"cancel" otherButtonTitles:@[@"Ok"]];
    [alert setTheme:[YWTheme new]];
    [alert showOnViewController];
  ```
>    >  该继承NSObject的实体类的m文件内容如下，按需实现<YWAlertViewThemeProtocol>相应的方法
  ```
  @implementation YWTheme
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
  @end
  
  ```
  
  
  
  
