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
#import "YWAddressPicker.h"

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
        case YWAlertViewStyleDatePicker:
            @throw [NSException exceptionWithName:@"调用提示" reason:@"请使用dataPicker快速调用方法" userInfo:nil];
            break;
        case YWAlertViewStyleDatePicker2:
            @throw [NSException exceptionWithName:@"调用提示" reason:@"请使用dataPicker快速调用方法" userInfo:nil];
            break;

        case YWAlertViewStyleAddressPicker:
            alertView = [YWAlertView YWAddressTitle:title message:nil delegate:delegate bodyStyle:bodyStyle cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles handler:nil];
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
        case YWAlertViewStyleDatePicker:
            @throw [NSException exceptionWithName:@"调用提示" reason:@"请使用dataPicker快速调用方法" userInfo:nil];
            break;
        case YWAlertViewStyleDatePicker2:
            @throw [NSException exceptionWithName:@"调用提示" reason:@"请使用dataPicker快速调用方法" userInfo:nil];
            break;
        case YWAlertViewStyleAddressPicker:
            alertView = [YWAlertView YWAddressTitle:title message:nil delegate:nil bodyStyle:bodyStyle cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles handler:handler];
            break;
        default:
            break;
    }
    return alertView;
}
//MARK: --- YWAlertViewStyleAddressPicker
+ (nullable id<YWAlertViewProtocol>)YWAddressTitle:(nullable NSString *)title
                                           message:(nullable NSString *)message
                                          delegate:(nullable id<YWAlertViewDelegate>)delegate
                                         bodyStyle:(YWAlertPublicBodyStyle)bodyStyle
                                 cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                 otherButtonTitles:(nullable NSArray *)otherButtonTitles
                                           handler:(nullable void(^)(NSInteger buttonIndex,id _Nullable value))handler{
    
    return [[YWAddressPicker alloc] initWithTitle:title delegate:delegate bodyStyle:bodyStyle cancelButtonTitle:cancelButtonTitle okButtonTitles:otherButtonTitles.firstObject handler:handler];
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




//MARK: --- 日期的快速调用方法
+ (nullable id<YWAlertViewProtocol>)alertViewWithTitle:(nullable NSString *)title
                                       preferredStyle:(YWAlertViewStyle)preferredStyle
                                            footStyle:(YWAlertPublicFootStyle)footStyle
                                            bodyStyle:(YWAlertPublicBodyStyle)bodyStyle
                                    cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                     sureButtonTitles:(nullable NSString *)sureButtonTitles handler:(nullable void(^)(NSInteger buttonIndex,id _Nullable value))handler{
    if (preferredStyle == YWAlertViewStyleDatePicker) {
        return [[YWDatePicker alloc] initWithTitle:title delegate:nil footStyle:footStyle bodyStyle:bodyStyle mode:0 cancelButtonTitle:cancelButtonTitle okButtonTitles:sureButtonTitles handler:handler];
    }else if (preferredStyle == YWAlertViewStyleDatePicker2){
        return [[YWDatePicker alloc] initWithTitle:title delegate:nil footStyle:footStyle bodyStyle:bodyStyle mode:1 cancelButtonTitle:cancelButtonTitle okButtonTitles:sureButtonTitles handler:handler];
    }else{
        @throw [NSException exceptionWithName:@"提示" reason:@"请检查preferredStyle是否正确" userInfo:nil];
        return nil;
    }
}
+ (nullable id<YWAlertViewProtocol>)alertViewWithTitle:(nullable NSString *)title
                                       preferredStyle:(YWAlertViewStyle)preferredStyle
                                             delegate:(nullable id<YWAlertViewDelegate>)delegate
                                            footStyle:(YWAlertPublicFootStyle)footStyle
                                            bodyStyle:(YWAlertPublicBodyStyle)bodyStyle
                                    cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                     sureButtonTitles:(nullable NSString *)sureButtonTitles{
    
    if (preferredStyle == YWAlertViewStyleDatePicker) {
        return [[YWDatePicker alloc] initWithTitle:title delegate:delegate footStyle:footStyle bodyStyle:bodyStyle mode:0 cancelButtonTitle:cancelButtonTitle okButtonTitles:sureButtonTitles handler:nil];
    }else if (preferredStyle == YWAlertViewStyleDatePicker2){
        return [[YWDatePicker alloc] initWithTitle:title delegate:delegate footStyle:footStyle bodyStyle:bodyStyle mode:1 cancelButtonTitle:cancelButtonTitle okButtonTitles:sureButtonTitles handler:nil];
    }else{
        @throw [NSException exceptionWithName:@"提示" reason:@"请检查preferredStyle是否正确" userInfo:nil];
        return nil;
    }
    
}
+ (NSString *)version{
    return @"1.2.2";
}
@end
