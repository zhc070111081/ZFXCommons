//
//  ZFXGestureUnLockView.h
//  ZFXCommon
//
//  Created by zhuhc on 2023/6/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZFXGestureUnLockView;

typedef void(^ZFXGestureUnLockCallback)(NSString * _Nullable password);

@protocol UIGestureUnLockViewDelegate <NSObject>

@optional
- (void)gestureUnLockView:(nullable ZFXGestureUnLockView *)lockView password:(nullable NSString *)password;

@end

@interface ZFXGestureUnLockView : UIView


@property (nonatomic, weak, nullable) id <UIGestureUnLockViewDelegate> delegate;

/// call back
@property (copy, nonatomic, nullable) ZFXGestureUnLockCallback callback;

/// line color defaut white
@property (strong, nonatomic, nullable) UIColor *lineColor;

/// line width default 3
@property (assign, nonatomic) CGFloat lineWidth;

@end

NS_ASSUME_NONNULL_END
