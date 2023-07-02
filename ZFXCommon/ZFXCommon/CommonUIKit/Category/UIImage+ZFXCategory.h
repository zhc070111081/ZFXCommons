//
//  UIImage+ZFXCategory.h
//  ZFXCommon
//
//  Created by zhuhc on 2023/6/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZFXCategory)


/// 图片水印
/// @param content 水印内容
/// @param contentRect 内容位置
/// @param attrs 内容属性
/// @param contentImage 水印图片
/// @param imageRect 图片位置
- (nullable UIImage *)watermarkWithContent:(nullable NSString *)content
                      contentRect:(CGRect)contentRect
                   withAttributes:(nullable NSDictionary<NSAttributedStringKey, id> *)attrs
                     contentImage:(nullable UIImage *)contentImage
                        imageRect:(CGRect)imageRect;

/// 图片裁剪(圆形)
/// @param image 待裁剪的图片
/// @param border 边框
/// @param borderColor 边框颜色
+ (nullable UIImage *)imageWithClipImage:(nullable UIImage *)image border:(CGFloat)border borderColor:(nullable UIColor *)borderColor;

/// 控件截屏
/// @param targetView 待截屏的控件
+ (nullable UIImage *)imageWithCaputure:(nullable UIView *)targetView;

@end

@interface UIImage (ZFXQRCode)

/*!
 生成二维码
 @param urlString 需要生成的二维码内容
 */
+ (nullable UIImage *)createQRCodeWithUrlString:(nullable NSString *)urlString;

/*!
 生成高清的二维码
 @param urlString 需要生成的二维码内容
 @param size 需要生成二维码的尺寸
 */
+ (nullable UIImage *)createQRCodeWithUrlString:(nullable NSString *)urlString size:(CGFloat)size;

/*!
 生成带logo的二维码
 @param urlString 需要生成的二维码内容
 @param size 需要生成二维码的尺寸
 @param imageName log0名称
 */
+ (nullable UIImage *)createQRCodeWithUrlString:(nullable NSString *)urlString size:(CGFloat)size imageName:(nullable NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
