//
//  UIApplication+ZFXAdapter.h
//  ZFXCommon
//
//  Created by zhuhc on 2023/6/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (ZFXAdapter)

/// 获取keyWindow
+ (nullable UIWindow *)keyWindow;

/// 获取根控制器
+ (nullable UIViewController *)rootViewController;

/// 底部是否有安全区 是否是刘海
+ (BOOL)haveHomeIndicator;

/// 获取状态栏的高度(包括安全区)
+ (CGFloat)statusBarHeight;

/// 获取状态栏+导航栏的高度
+ (CGFloat)navgationBarHeight;

/// 获取顶部安全区的距离
+ (CGFloat)safeDistanceTop;

/// 获取底部安全区的距离
+ (CGFloat)safeDistanceBottom;

/// 获取底部tabbar的高度(包括安全区)
+ (CGFloat)tabBarHeight;

@end

NS_ASSUME_NONNULL_END
