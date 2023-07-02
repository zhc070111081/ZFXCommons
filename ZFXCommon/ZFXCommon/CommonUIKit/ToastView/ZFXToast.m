//
//  ZFXToast.m
//  ZFXCommon
//
//  Created by zhuZFX on 2023/6/30.
//

#import "ZFXToast.h"

/**
 Toast类型

 - ZFXToastType_Toast: 普通Toast
 - ZFXToastType_SuccessIconToast: 带成功图标的Toast
 - ZFXToastType_ErrorIconToast: 带失败图标的Toast
 - ZFXToastType_TopToast: 顶部显示Toast
 */
//typedef NS_ENUM(NSInteger , ZFXToastType) {
//    ZFXToastType_Toast = 0,
//    ZFXToastType_SuccessIconToast = 1,
//    ZFXToastType_ErrorIconToast = 2,
//    ZFXToastType_TopToast = 3,
//};

typedef NS_ENUM(NSInteger, ZFXToastType) {
    ZFXToastTypeWithTop = 0,
    ZFXToastTypeWithCenter = 1,
    ZFXToastTypeWithBottom = 2,
};

//typedef NS_ENUM(NSInteger, ZFXToastImageType);

@interface ZFXToastView : UIView

@end

@implementation ZFXToastView


@end

@interface ZFXToast ()

/// 提示框
@property (strong, nonatomic, nullable) ZFXToastView *toastView;

/// 动画时间
@property (assign, nonatomic) NSTimeInterval duration;

/// 是否是活跃状态
@property (assign, nonatomic) BOOL isActive;

/// 顶部显示Toast偏移量
@property (assign, nonatomic) CGFloat top_offsetY;

@end

@implementation ZFXToast

+ (instancetype)shareInstance {
    static ZFXToast *_toast = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _toast = [[ZFXToast alloc] init];
    });
    
    return _toast;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.toastView = [[ZFXToastView alloc] initWithFrame:CGRectZero];
    self.toastView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.isActive = NO;
    self.top_offsetY = 0;
}

#pragma mark - public class method
+ (void)showToast:(NSString *)message {
    
}

+ (void)showToast:(NSString *)message duration:(NSTimeInterval)duration type:(id)type {
    if (message == nil || message.length == 0) return;
}

@end
