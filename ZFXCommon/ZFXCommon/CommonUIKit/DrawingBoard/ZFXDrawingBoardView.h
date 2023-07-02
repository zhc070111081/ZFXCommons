//
//  ZFXDrawingBoardView.h
//  ZFXCommon
//
//  Created by zhuhc on 2023/6/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFXDrawingBoardView : UIView

/// path lineWidth default 1
@property (nonatomic, assign) CGFloat lineWidth;

/// path color default black
@property (nullable, nonatomic, strong) UIColor *pathColor;

/// insert image
@property (nullable, nonatomic, strong) UIImage *image;

/// clear all
/// 清屏，全部取消
- (void)clear;

/// revoke
/// 撤销
- (void)revoke;

/// eraser
/// 橡皮擦
- (void)eraser;

/// save image to photos
/// 截屏保存图片到相册
- (void)saveImagePhotos;


@end

NS_ASSUME_NONNULL_END
