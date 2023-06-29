//
//  ZFXAnswerPageView.m
//  ZFXCommon
//
//  Created by zhuhc on 2023/5/26.
//

#import "ZFXAnswerPageView.h"
#import "UIView+ZFXKit.h"

/// 缓存视图索引
#define KViewCaches @"view_caches"

@interface ZFXAnswerPageView ()

/// 视图总个数
@property (assign, nonatomic) NSInteger pageCount;

/// 当前视图索引
@property (assign, nonatomic) NSInteger currentIndex;

/// 当前展示的视图
@property (strong, nonatomic, nullable) UIView *currentView;

/// 将要展示的视图
@property (strong, nonatomic, nullable) UIView *toView;

/// <#Description#>
//@property (assign, nonatomic) <#Class#> <#name#>;

/// 视图缓存
@property (strong, nonatomic, nullable) NSMutableDictionary *viewCaches;

@end

@implementation ZFXAnswerPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setConfigUI];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setConfigUI];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.currentView layoutIfNeeded];
    [self.toView layoutIfNeeded];
}

- (void)setConfigUI {
    self.backgroundColor = [UIColor whiteColor];
    
    self.currentIndex = 0;
    // 添加手势视图 待完成
}

- (void)setDelegate:(id<ZFXAnswerPageViewDelegate>)delegate {
    _delegate = delegate;
    
    // 获取数据 刷新界面
    [self reloadData];
}

- (void)reloadData {
    // 更新界面frame
    if (self.zfx_w == 0) {
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
    
    [self.currentView removeFromSuperview];
    [self.toView removeFromSuperview];
    
    self.currentView = nil;
    self.toView = nil;
    
    // 获取视图总数
    self.pageCount = [self.delegate numberOfPageInPageView:self];
    if (self.currentIndex >= self.pageCount) {
        self.currentIndex = 0;
    }
    
    // 获取当前视图
    NSString *viewKey = [NSString stringWithFormat:@"%@_%lu", KViewCaches, self.currentIndex];
    UIView *view = self.viewCaches[viewKey];
    if (view == nil) {
        self.currentView = [self.delegate pageView:self itemViewAtIndex:self.currentIndex];
        // 保存当前视图
        self.viewCaches[viewKey] = self.currentView;
    }
    else {
        self.currentView = view;
    }
    
    [self addSubview:self.currentView];
    self.currentView.frame = self.bounds;
    
    [self.currentView setNeedsLayout];
    [self.currentView layoutIfNeeded];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)switchToNextPageAnimated:(BOOL)animated {
    [self switchToPage:(self.currentIndex + 1) animated:animated];
}

- (void)switchToPrePageAnimated:(BOOL)animated {
    [self switchToPage:(self.currentIndex - 1) animated:animated];
}

- (void)switchToPage:(NSInteger)pageIndex animated:(BOOL)animated {
    
    if (pageIndex >= self.pageCount) return;
    if (pageIndex == self.currentIndex) return;
    if (pageIndex < 0) return;
    
    // 是否是下一个视图
    BOOL next = pageIndex > self.currentIndex;
    
    // 获取将要展现的视图
    if (self.toView == nil) {
        NSString *viewKey = [NSString stringWithFormat:@"%@_%lu", KViewCaches, pageIndex];
        UIView *view = self.viewCaches[viewKey];
        if (view == nil) {
            view = [self.delegate pageView:self itemViewAtIndex:pageIndex];
        }
        self.toView = view;
        self.viewCaches[viewKey] = view;
        
        if (self.toView.superview != self) {
            [self addSubview:self.toView];
        }
        
        CGFloat x = next ? 0 : -self.zfx_w;
        self.toView.frame = CGRectMake(x, 0, self.zfx_w, self.zfx_h);
        
//        [self.toView setNeedsLayout];
//        [self.toView layoutIfNeeded];
//        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
    
    if (next) {
        [self bringSubviewToFront:self.currentView];
    }
    
    if (!animated) { // 不动画切换
        [self switchCompletionPage:pageIndex];
        return;
    }
    
    if (next) {
        self.currentView.frame = CGRectMake(-self.zfx_w, 0, self.zfx_w, self.zfx_h);
    }
    else {
        self.toView.frame = CGRectMake(0, 0, self.zfx_w, self.zfx_h);
    }
    
    // 开始动画
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModePaced animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        // 切换完成
        [self switchCompletionPage:pageIndex];
    }];
}

- (void)switchCompletionPage:(NSInteger)pageIndex {
    
    [self.currentView removeFromSuperview];
    self.currentView = nil;
    
    self.currentView = self.toView;
    self.toView = nil;
    
    self.currentIndex = pageIndex;
}

#pragma mark - setter && getter
- (NSMutableDictionary *)viewCaches {
    if (_viewCaches == nil) {
        _viewCaches = [NSMutableDictionary dictionary];
    }
    return _viewCaches;
}

@end
