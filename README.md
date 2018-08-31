# YWAlertView
提示弹出框、选择弹出框、高效调用、高效扩展


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
 
  YWAlertView目前提供两种模式：
  
    > YWAlertViewStyleAlert
    > YWAlertViewStyleActionSheet
    
    
  * 注意点：YWAlertView并不是view，可以比作是一个简单的工厂，通过它管理规格去生成不同的控件，因为这样后期将陆续加入其它的控件，日历，地址等
  
  
  > #### YWAlertViewStyleAlert 的模式
  
    >> * 默认情况下 ![image](https://github.com/flyOfYW/YWAlertView/blob/master/image/1.png '默认情况下')
