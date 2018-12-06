//
//  YWAddressModel.h
//  YWAlertViewDemo
//
//  Created by yaowei on 2018/12/5.
//  Copyright © 2018 yaowei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/// 省
@interface YWProvinceModel : NSObject <NSCopying,NSMutableCopying>
/** 省对应的code或id */
@property (nonatomic, copy) NSString *code;
/** 省的名称 */
@property (nonatomic, copy) NSString *name;
/** 省的索引 */
@property (nonatomic, assign) NSInteger index;
/** 城市数组 */
@property (nonatomic, strong) NSArray *citylist;

@end

/// 市
@interface YWCityModel : NSObject <NSCopying,NSMutableCopying>
/** 市对应的code或id */
@property (nonatomic, copy) NSString *code;
/** 市的名称 */
@property (nonatomic, copy) NSString *name;
/** 市的索引 */
@property (nonatomic, assign) NSInteger index;
/** 地区数组 */
@property (nonatomic, strong) NSArray *arealist;

@end

/// 区
@interface YWAreaModel : NSObject <NSCopying,NSMutableCopying>
/** 区对应的code或id */
@property (nonatomic, copy) NSString *code;
/** 区的名称 */
@property (nonatomic, copy) NSString *name;
/** 区的索引 */
@property (nonatomic, assign) NSInteger index;

@end


/// 结果返回的model
@interface YWResultModel : NSObject
/** 区model */
@property (nonatomic, strong) YWAreaModel *area;
/** 市model */
@property (nonatomic, strong) YWCityModel *city;
/** 省model */
@property (nonatomic, strong) YWProvinceModel *province;

@end

NS_ASSUME_NONNULL_END
