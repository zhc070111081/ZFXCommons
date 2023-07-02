//
//  UIImage+ZFXCategory.m
//  ZFXCommon
//
//  Created by zhuhc on 2023/6/30.
//

#import "UIImage+ZFXCategory.h"

@implementation UIImage (ZFXCategory)

- (UIImage *)watermarkWithContent:(NSString *)content contentRect:(CGRect)contentRect withAttributes:(NSDictionary<NSAttributedStringKey,id> *)attrs contentImage:(UIImage *)contentImage imageRect:(CGRect)imageRect{
    
    if (content == nil && contentImage == nil) return nil;
    
    // 开启位图上下文
    // size
    // NO - 透明
    // 0 - 不缩放
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    
    // 绘制原生图片
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    // 绘制文字内容
    if (content) {
        [content drawInRect:contentRect withAttributes:attrs];
    }
    
    // 绘制图片内容
    if (contentImage) {
        [contentImage drawInRect:imageRect];
    }
   
    // 获取水印图片
    UIImage *waterImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭位图上下文
    UIGraphicsEndImageContext();
    
    return waterImage;
}

+ (UIImage *)imageWithClipImage:(UIImage *)image border:(CGFloat)border borderColor:(UIColor *)borderColor {
    
    if (!image) return nil;
    
    CGFloat imageW = image.size.width + 2 * border;
    CGFloat imageH = image.size.height + 2 * border;
    
    // 1. 开启位图上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageW, imageH), NO, 0);
    
    // 2. 画底部大圆 作为边框显示的颜色
    UIBezierPath *OvalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, imageW, imageH)];
    
    // 2.1 设置底部圆颜色
    if (borderColor) [borderColor set];
    
    // 2.1 填充圆
    [OvalPath fill];
    
    // 3. 添加裁剪区域
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(border, border, image.size.width, image.size.height)];
    
    [path addClip];
    
    // 4. 绘制原图片
    [image drawAtPoint:CGPointZero];
    
    // 5. 生成新的图片
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 6. 关闭上下文
    UIGraphicsEndImageContext();
    
    return clipImage;
}


+ (UIImage *)imageWithCaputure:(UIView *)targetView {
    if (!targetView) return nil;
    
    // 开启位图上下文
    UIGraphicsBeginImageContextWithOptions(targetView.bounds.size, NO, 0);
    
    // 将targetView的layer 渲染到当前上下文中
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    // 将layer 渲染到当前上下文中
    [targetView.layer renderInContext:ref];
    
    // 生成新的图片
    UIImage *caputureImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭位图上下文
    UIGraphicsEndImageContext();
    
    return caputureImage;
}


@end

@implementation UIImage (ZFXQRCode)

+ (UIImage *)createQRCodeWithUrlString:(NSString *)urlString {
    if (!urlString) return nil;
    
    // 1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
     
    // 2. 恢复滤镜的默认设置(因为滤镜有可能保存上一次的属性)
    [filter setDefaults];
    
    // 3. 通过KVO设置滤镜, 传入data, 将来滤镜就知道要通过传入的数据生成二维码
    NSData *data = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4. 输出二维码图片
    CIImage *outputImage = [filter outputImage];
    
    return [UIImage imageWithCIImage:outputImage];
}

+ (UIImage *)createQRCodeWithUrlString:(NSString *)urlString size:(CGFloat)size {
    
    if (!urlString) return nil;
    
    // 1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
     
    // 2. 恢复滤镜的默认设置(因为滤镜有可能保存上一次的属性)
    [filter setDefaults];
    
    // 3. 通过KVO设置滤镜, 传入data, 将来滤镜就知道要通过传入的数据生成二维码
    NSData *data = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4. 输出二维码图片
    CIImage *outputImage = [filter outputImage];
    
    CGRect extent = CGRectIntegral(outputImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:outputImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

+ (UIImage *)createQRCodeWithUrlString:(NSString *)urlString size:(CGFloat)size imageName:(NSString *)imageName {
    
    UIImage *outputImage = [self createQRCodeWithUrlString:urlString size:size];
    
    CGSize imageSize = outputImage.size;
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    // 开启图形上下文
    UIGraphicsBeginImageContext(outputImage.size);
    
    [outputImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    
    CGFloat centerW = imageSize.width * 0.25;
    
    CGFloat centerH = centerW;
    
    CGFloat centerX=(imageSize.width-centerW)*0.5;
    
    CGFloat centerY=(imageSize.height-centerH)*0.5;
    
    [image drawInRect:CGRectMake(centerX, centerY, centerW, centerH)];
    
    //5.3获取绘制好的图片
    UIImage *finalImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return finalImg;
}


@end
