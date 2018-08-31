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
  
  
