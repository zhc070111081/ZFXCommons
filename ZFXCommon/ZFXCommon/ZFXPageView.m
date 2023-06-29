//
//  ZFXPageView.m
//  AnswerDemo
//
//  Created by zhuhc on 2023/5/24.
//

#import "ZFXPageView.h"

#define PageView_CellID @"PageView_collection_cell_id"

#define KViewCacheKey @"_viewCahces"

@interface ZFXPageView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/// collectionView
@property (strong, nonatomic, nullable) UICollectionView *collectionView;

/// view caches
@property (strong, nonatomic, nullable) NSMutableDictionary *viewCaches;

/// 当前页
@property (assign, nonatomic) NSInteger currentIndex;

/// 总页数
@property (assign, nonatomic) NSInteger numberOfPage;

@end

@implementation ZFXPageView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.collectionView];
}

#pragma mark - private method
- (void)prepareWithData {
    self.currentIndex = 0;
    self.numberOfPage = [self.delegate numberOfPagesInPageView:self];
    [self.collectionView reloadData];
}

#pragma mark - public method

- (void)reloadData {
    
 
}

- (void)reloadDataToFirst {
    self.currentIndex = 0;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

- (BOOL)switchToNextPageAnimated:(BOOL)animated {
    
    NSInteger item = self.currentIndex + 1;
    
    if (item >= self.numberOfPage) return NO;
    
    self.currentIndex = item;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:animated];
    
    return YES;
}

- (BOOL)switchToPrePageAnimated:(BOOL)animated {
    
    NSInteger item = self.currentIndex - 1;
    
    if (item <= 0) return NO;
    
    self.currentIndex = item;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:animated];
    
    return YES;
}

- (BOOL)switchToPage:(NSInteger)page animated:(BOOL)animated {
    
    if ((page >= self.numberOfPage) || (page < 0)) return NO;
    
    self.currentIndex = page;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:page inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:animated];
    return YES;
}

#pragma mark - <UICollectionViewDelegate && UICollectionViewDataSource && UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numberOfPage;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PageView_CellID forIndexPath:indexPath];
        
    NSString *key = [NSString stringWithFormat:@"%lu%@", indexPath.item, KViewCacheKey];
    UIView *cacheView = self.viewCaches[key];
    if (cacheView == nil) {
        cacheView = [self.delegate pageView:self itemViewAtPage:indexPath.item];
        self.viewCaches[key] = cacheView;
    }
    
    if ([cell.contentView.subviews containsObject:cacheView]) {
        [cacheView removeFromSuperview];
    }
   
    cacheView.frame = cell.contentView.bounds;
    [cell.contentView addSubview:cacheView];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = collectionView.frame.size.width;
    CGFloat height = collectionView.frame.size.height;
    return CGSizeMake(width, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.00f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 计算当前展示的page
    CGFloat width = scrollView.frame.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger currentIndex = offsetX / width;
    
    self.currentIndex = currentIndex;
    
//    NSLog(@"page---- : %lu", currentIndex);
    NSLog(@"%s",__func__);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%s",__func__);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%s",__func__);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"%s",__func__);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"%s",__func__);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"%s",__func__);
    [self scrollViewDidEndDecelerating:scrollView];
}

#pragma mark - setter && getter
- (NSMutableDictionary *)viewCaches {
    
    if (_viewCaches == nil) {
        _viewCaches = [NSMutableDictionary dictionary];
    }
    return _viewCaches;
}

- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:PageView_CellID];
    }
    return _collectionView;
}

- (void)setDelegate:(id<UIZFXPageViewDelegate>)delegate {
    _delegate = delegate;
    
    [self prepareWithData];
}

@end
