//
//  UIApplication+ZFXAdapter.m
//  ZFXCommon
//
//  Created by zhuhc on 2023/6/30.
//

#import "UIApplication+ZFXAdapter.h"

@implementation UIApplication (ZFXAdapter)

+ (UIWindow *)keyWindow {
    UIWindow *keyWindow = nil;
    if(@available(iOS 13.0, *)) {
        UIWindowScene *windowScene = [self windowScene];
        NSArray *windows = windowScene.windows;
        for (UIWindow *window in windows) {
            if ([window isKeyWindow]) {
                keyWindow = window;
                break;
            }
        }
    }
    else {
        keyWindow = [UIApplication sharedApplication].keyWindow;
    }
    
    return keyWindow;
}

+ (UIWindowScene *)windowScene  API_AVAILABLE(ios(13.0)) {
    UIWindowScene *windowScene = nil;
    NSSet<UIScene *> *connectedScenes = [UIApplication sharedApplication].connectedScenes;
    for (UIScene *scene in connectedScenes) {
        if(scene.activationState == UISceneActivationStateForegroundActive) {
            windowScene = (UIWindowScene *)scene;
            break;
        }
    }
    return nil;
}

+ (UIViewController *)rootViewController {
    return [self keyWindow].rootViewController;
}


+ (BOOL)haveHomeIndicator {
    BOOL isHave = NO;
    UIEdgeInsets safeAreaInsets = [self keyWindow].safeAreaInsets;
    CGFloat bottom = safeAreaInsets.bottom;
    if (bottom > 0) {
        isHave = YES;
    }
    
    return isHave;
}

/// 获取状态栏的高度(包括安全区)
+ (CGFloat)statusBarHeight {
    
    CGFloat statusBarH = 0.0f;
    if(@available(iOS 13.0, *)) {
        statusBarH = [self keyWindow].windowScene.statusBarManager.statusBarFrame.size.height;
    }
    else {
        statusBarH = [self sharedApplication].statusBarFrame.size.height;
    }
    
    return statusBarH;
}

/// 获取状态栏+导航栏的高度
+ (CGFloat)navgationBarHeight {
    CGFloat navgationBarH = 44.0f;
    navgationBarH = [self statusBarHeight] + navgationBarH;
    return navgationBarH;
}

/// 获取顶部安全区的距离
+ (CGFloat)safeDistanceTop {
    
    CGFloat safeTop = 0.0;
    if(@available(iOS 11.0, *)) {
        safeTop = [self keyWindow].safeAreaInsets.top;
    }
    
    return safeTop;
}

/// 获取底部安全区的距离
+ (CGFloat)safeDistanceBottom {
    CGFloat safeBottom = 0.0;
    if(@available(iOS 11.0, *)) {
        safeBottom = [self keyWindow].safeAreaInsets.bottom;
    }
    
    return safeBottom;
}

/// 获取底部tabbar的高度(包括安全区)
+ (CGFloat)tabBarHeight {
    CGFloat tabBarH = 49.0f;
    if(@available(iOS 11.0, *)) {
        tabBarH = tabBarH + [self safeDistanceBottom];
    }
    
    return tabBarH;
}

@end
