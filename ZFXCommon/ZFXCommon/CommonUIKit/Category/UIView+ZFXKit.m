//
//  UIView+ZFXKit.m
//  ZFXCommon
//
//  Created by zhuhc on 2023/5/26.
//

#import "UIView+ZFXKit.h"

@implementation UIView (ZFXKit)

- (void)setZfx_x:(CGFloat)zfx_x {
    CGRect frame = self.frame;
    frame.origin.x = zfx_x;
    self.frame = frame;
}

- (CGFloat)zfx_x {
    return self.frame.origin.x;
}

- (void)setZfx_y:(CGFloat)zfx_y {
    CGRect frame = self.frame;
    frame.origin.y = zfx_y;
    self.frame = frame;
}

- (CGFloat)zfx_y {
    return self.frame.origin.y;
}

- (void)setZfx_w:(CGFloat)zfx_w {
    CGRect frame = self.frame;
    frame.size.width = zfx_w;
    self.frame = frame;
}

- (CGFloat)zfx_w {
    return self.frame.size.width;
}

- (void)setZfx_h:(CGFloat)zfx_h {
    CGRect frame = self.frame;
    frame.size.height = zfx_h;
    self.frame = frame;
}

- (CGFloat)zfx_h {
    return self.frame.size.height;
}

- (void)setZfx_centerX:(CGFloat)zfx_centerX {
    CGPoint center = self.center;
    center.x = zfx_centerX;
    self.center = center;
}

- (CGFloat)zfx_centerX {
    return self.center.x;
}

- (void)setZfx_centerY:(CGFloat)zfx_centerY {
    CGPoint center = self.center;
    center.y = zfx_centerY;
    self.center = center;
}

- (CGFloat)zfx_centerY {
    return self.center.y;
}


@end
