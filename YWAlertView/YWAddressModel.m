//
//  YWAddressModel.m
//  YWAlertViewDemo
//
//  Created by yaowei on 2018/12/5.
//  Copyright © 2018 yaowei. All rights reserved.
//

#import "YWAddressModel.h"

@implementation YWProvinceModel

- (id)copyWithZone:(NSZone *)zone{
    YWProvinceModel * model = [[YWProvinceModel allocWithZone:zone] init];
    model.code = self.code;
    model.name = self.name;
    model.index = self.index;
    return model;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    YWProvinceModel * model = [[YWProvinceModel allocWithZone:zone] init];
    model.code = self.code;
    model.name = self.name;
    model.index = self.index;
    return model;
}
@end


@implementation YWCityModel
- (id)copyWithZone:(NSZone *)zone{
    YWProvinceModel * model = [[YWProvinceModel allocWithZone:zone] init];
    model.code = self.code;
    model.name = self.name;
    model.index = self.index;
    return model;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    YWProvinceModel * model = [[YWProvinceModel allocWithZone:zone] init];
    model.code = self.code;
    model.name = self.name;
    model.index = self.index;
    return model;
}
@end


@implementation YWAreaModel
- (id)copyWithZone:(NSZone *)zone{
    YWProvinceModel * model = [[YWProvinceModel allocWithZone:zone] init];
    model.code = self.code;
    model.name = self.name;
    model.index = self.index;
    return model;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    YWProvinceModel * model = [[YWProvinceModel allocWithZone:zone] init];
    model.code = self.code;
    model.name = self.name;
    model.index = self.index;
    return model;
}
@end

@implementation YWResultModel
@end
