//
//  ZFXWaterFlowLayout.h
//  ZFXCommon
//
//  Created by zhuhc on 2023/6/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZFXWaterFlowLayout;

@protocol ZFXWaterFlowLayoutDelegate <NSObject>

@required

/// 每个item的高度
/// @param waterFlowLayout FlowLayout
/// @param indexPath indexPath
/// @param itemWidth item width
- (CGFloat)waterFlowLayout:(nullable ZFXWaterFlowLayout *)waterFlowLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;

@optional

/// 列数
/// @param waterFlowLayout FlowLayout
- (NSInteger)columnCountInWaterFlowLayout:(nullable ZFXWaterFlowLayout *)waterFlowLayout;

/// 列间距
/// @param waterFlowLayout FlowLayout
- (CGFloat)columnMarginInWaterFlowLayout:(nullable ZFXWaterFlowLayout *)waterFlowLayout;

/// 行间距
/// @param waterFlowLayout FlowLayout
- (CGFloat)rowMarginInWaterFlowLayout:(nullable ZFXWaterFlowLayout *)waterFlowLayout;

/// 边缘间距
/// @param waterFlowLayout FlowLayout
- (UIEdgeInsets)edgeInsetsInWaterFlowLayout:(nullable ZFXWaterFlowLayout *)waterFlowLayout;

@end

@interface ZFXWaterFlowLayout : UICollectionViewLayout

/// 代理
@property (nonatomic, weak, nullable) id<ZFXWaterFlowLayoutDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
