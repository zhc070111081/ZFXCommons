//
//  NSString+ZFXCategory.h
//  ZFXCommon
//
//  Created by zhuhc on 2023/6/30.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZFXCategory)

/// 获取系统生成的UUID 设备通用识别码
+ (nullable NSString *)uuid;

/// 随机生成UUID 设备通用识别码
+ (NSString *)random_uuid;

@end

NS_ASSUME_NONNULL_END
