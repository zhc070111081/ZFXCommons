//
//  ZFXWaterFlowLayout.m
//  ZFXCommon
//
//  Created by zhuhc on 2023/6/30.
//

#import "ZFXWaterFlowLayout.h"

/// 默认列数
static const NSInteger ZFXDefaultColumnCount = 3;

/// 每列之间的间距
static const CGFloat ZFXDefaultColumnMargin = 10;

/// 每行之间的间距
static const CGFloat ZFXDefaultRowMargin = 10;

/// 边缘间距
static const UIEdgeInsets ZFXDefaultEdgeInsets = {10, 10, 10, 10};

@interface ZFXWaterFlowLayout ()

/// 存放所有item的布局属性(Attributes)数组
@property (nullable, strong, nonatomic) NSMutableArray *attributes;

/// 存放所有列的当前高度
@property (nullable, strong, nonatomic) NSMutableArray *columnHeights;

/// 列数
- (NSInteger)columnCount;

/// 列间距
- (CGFloat)columnMargin;

/// 行间距
- (CGFloat)rowMargin;

/// 边缘间距
- (UIEdgeInsets)edgeInsetsMargin;


@end

@implementation ZFXWaterFlowLayout


- (NSMutableArray *)attributes {
    if (_attributes == nil) {
        _attributes = [NSMutableArray array];
    }
    
    return _attributes;
}

- (NSMutableArray *)columnHeights {
    if (_columnHeights == nil) {
        _columnHeights = [NSMutableArray array];
    }
    
    return _columnHeights;
}

/**
 * 初始化 自定义布局必须实现的方法
 */
- (void)prepareLayout {
    [super prepareLayout];
    NSLog(@"%s",__func__);
    
    // 清除以前所有计算的高度
    [self.columnHeights removeAllObjects];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.edgeInsetsMargin.top)];
    }
    
    // 清除所有ite的布局
    [self.attributes removeAllObjects];
    // 获取collectionView 每一个section的item总数，一般瀑布流的section为0
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    // 为每个item设置布局
    for (NSInteger i = 0; i < itemCount; i++) {
        // 获得每一个item
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        // 将布局添加到数组中
        [self.attributes addObject:attr];
    }
}

/**
 * 获取collectionView所有的布局
 */
- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributes;
}

/**
 * 获得每一个item对应的布局
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s",__func__);
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    /**
     * 每个item的frame在这个里面计算
     * 计算item的宽 首先需知道当前需要排放几列 默认3列
     */
    CGFloat collectinViewW = self.collectionView.frame.size.width;
    CGFloat itemW = 1.0 * (collectinViewW - self.edgeInsetsMargin.left - self.edgeInsetsMargin.right - (self.columnCount - 1) * self.columnMargin) / self.columnCount;
    
    // 需要动态计算的高度
    CGFloat itemH = [self.delegate waterFlowLayout:self heightForItemAtIndexPath:indexPath itemWidth:itemW];
        
    // 找到高度最短的那一列
    NSInteger destColumn = 0;
    CGFloat minColumnH = [self.columnHeights[0] floatValue];
    for (NSInteger i = 1; i < self.columnCount; i++) {
        CGFloat columnHeight = [self.columnHeights[i] floatValue];
        if (minColumnH > columnHeight) {
            minColumnH = columnHeight;
            destColumn = i;
        }
    }
    
    
    // 列和高度 计算x和y值
    CGFloat itemX = self.edgeInsetsMargin.left + (itemW + self.columnMargin) * destColumn;
    CGFloat itemY = minColumnH;
    if (itemY != self.edgeInsetsMargin.top) {
        itemY += self.rowMargin;
    }
    
    attr.frame = CGRectMake(itemX, itemY, itemW, itemH);
    
    // 将每列的最大高度存放起来
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attr.frame));
    return attr;
}

/**
 * 设置collectionView 的 ContentSize
 */
- (CGSize)collectionViewContentSize {
    // 找到高度最长的那一列
    CGFloat maxColumnH = [self.columnHeights[0] floatValue];
    for (NSInteger i = 1; i < self.columnCount; i++) {
        CGFloat columnHeight = [self.columnHeights[i] floatValue];
        if (maxColumnH < columnHeight) {
            maxColumnH = columnHeight;
        }
    }
    
    return CGSizeMake(0, maxColumnH + self.edgeInsetsMargin.bottom);
}

#pragma mark - private action
- (NSInteger)columnCount {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(columnCountInWaterFlowLayout:)]) {
        return [self.delegate columnCountInWaterFlowLayout:self];
    }
    
    return ZFXDefaultColumnCount;
}

- (CGFloat)columnMargin {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(columnMarginInWaterFlowLayout:)]) {
        return [self.delegate columnMarginInWaterFlowLayout:self];
    }
    
    return ZFXDefaultColumnMargin;
}

- (CGFloat)rowMargin {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(rowMarginInWaterFlowLayout:)]) {
        return [self.delegate rowMarginInWaterFlowLayout:self];
    }
    
    return ZFXDefaultRowMargin;
}

- (UIEdgeInsets)edgeInsetsMargin {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(edgeInsetsInWaterFlowLayout:)]) {
        return [self.delegate edgeInsetsInWaterFlowLayout:self];
    }
    
    return ZFXDefaultEdgeInsets;
}




@end
