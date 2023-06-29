//
//  UIView+ZFXKit.h
//  ZFXCommon
//
//  Created by zhuhc on 2023/5/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZFXKit)

@property (assign, nonatomic) CGFloat zfx_x;
@property (assign, nonatomic) CGFloat zfx_y;
@property (assign, nonatomic) CGFloat zfx_w;
@property (assign, nonatomic) CGFloat zfx_h;
@property (assign, nonatomic) CGFloat zfx_centerX;
@property (assign, nonatomic) CGFloat zfx_centerY;

@end

NS_ASSUME_NONNULL_END
