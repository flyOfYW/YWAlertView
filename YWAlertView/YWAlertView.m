//
//  YWAlertView.m
//  YWAlertViewDemo
//
//  Created by yaowei on 2018/8/28.
//  Copyright © 2018年 yaowei. All rights reserved.
//

#import "YWAlertView.h"
#import "YWAlert.h"
#import "YWActionSheet.h"
#import "YWDatePicker.h"
@implementation YWAlertView

+(nullable id<YWAlertViewProtocol>)alertViewWithTitle:(nullable NSString *)title
                                              message:(nullable NSString *)message
                                             delegate:(nullable id<YWAlertViewDelegate>)delegate
                                       preferredStyle:(YWAlertViewStyle)preferredStyle
                                             footStyle:(YWAlertPublicFootStyle)footStyle
                                            bodyStyle:(YWAlertPublicBodyStyle)bodyStyle
                                    cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                    otherButtonTitles:(nullable NSArray *)otherButtonTitles{
    id<YWAlertViewProtocol>alertView = nil;
    switch (preferredStyle) {
        case YWAlertViewStyleAlert:
            alertView = [YWAlertView YWAlertTitle:title message:message delegate:delegate footStyle:footStyle bodyStyle:bodyStyle cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles handler:nil];
            break;
        case YWAlertViewStyleActionSheet:
            alertView = [YWAlertView YWSheetTitle:title message:message delegate:delegate footStyle:footStyle bodyStyle:bodyStyle cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles handler:nil];
            break;
        default:
            break;
    }
    return alertView;
}

+(nullable id<YWAlertViewProtocol>)alertViewWithTitle:(nullable NSString *)title
                                              message:(nullable NSString *)message
                                       preferredStyle:(YWAlertViewStyle)preferredStyle
                                            footStyle:(YWAlertPublicFootStyle)footStyle
                                            bodyStyle:(YWAlertPublicBodyStyle)bodyStyle
                                    cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                    otherButtonTitles:(nullable NSArray *)otherButtonTitles handler:(nullable void(^)(NSInteger buttonIndex,id _Nullable value))handler{
    
    id<YWAlertViewProtocol>alertView = nil;
    
    switch (preferredStyle) {
        case YWAlertViewStyleAlert:
            alertView = [YWAlertView YWAlertTitle:title message:message delegate:nil footStyle:footStyle bodyStyle:bodyStyle cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles handler:handler];
            break;
        case YWAlertViewStyleActionSheet:
            alertView = [YWAlertView YWSheetTitle:title message:message delegate:nil footStyle:footStyle bodyStyle:bodyStyle cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles handler:handler];
            break;
        default:
            break;
    }
    return alertView;
}
//MARK: --- YWAlertViewStyleActionSheet
+ (nullable id<YWAlertViewProtocol>)YWSheetTitle:(nullable NSString *)title
                                         message:(nullable NSString *)message
                                        delegate:(nullable id<YWAlertViewDelegate>)delegate
                                       footStyle:(YWAlertPublicFootStyle)footStyle
                                       bodyStyle:(YWAlertPublicBodyStyle)bodyStyle
                               cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                               otherButtonTitles:(nullable NSArray *)otherButtonTitles
                                         handler:(nullable void(^)(NSInteger buttonIndex,id _Nullable value))handler{
   return [[YWActionSheet alloc] initWithTitle:title message:message delegate:delegate footStyle:footStyle bodyStyle:bodyStyle cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles handler:handler];
}



//MARK: --- YWAlertViewStyleAlert
+ (nullable id<YWAlertViewProtocol>)YWAlertTitle:(nullable NSString *)title
                                         message:(nullable NSString *)message
                                        delegate:(nullable id<YWAlertViewDelegate>)delegate
                                        footStyle:(YWAlertPublicFootStyle)footStyle
                                       bodyStyle:(YWAlertPublicBodyStyle)bodyStyle
                               cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                               otherButtonTitles:(nullable NSArray *)otherButtonTitles
                                         handler:(nullable void(^)(NSInteger buttonIndex,id _Nullable value))handler{
    
   return [[YWAlert alloc] initWithTitle:title message:message delegate:delegate footStyle:footStyle bodyStyle:bodyStyle cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles handler:handler];
    
}

+(nullable id<YWAlertViewProtocol>)alertViewWithTitle:(nullable NSString *)title
                                       preferredStyle:(YWAlertViewStyle)preferredStyle
                                            footStyle:(YWAlertPublicFootStyle)footStyle
                                            bodyStyle:(YWAlertPublicBodyStyle)bodyStyle
                                    cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                    sureButtonTitles:(nullable NSString *)sureButtonTitles handler:(nullable void(^)(NSInteger buttonIndex,id _Nullable value))handler{
    
    return [[YWDatePicker alloc] initWithTitle:title delegate:nil footStyle:footStyle bodyStyle:bodyStyle mode:0 cancelButtonTitle:cancelButtonTitle okButtonTitles:sureButtonTitles handler:handler];
    
}
@end
