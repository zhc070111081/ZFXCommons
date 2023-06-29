//
//  ZFXPageView.h
//  AnswerDemo
//
//  Created by zhuhc on 2023/5/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZFXPageView;
@protocol UIZFXPageViewDelegate <NSObject>
@required

/// 获取总页数
/// - Parameter pageView: pageview
- (NSInteger)numberOfPagesInPageView:(nullable ZFXPageView *)pageView;

/// 获取当前页展示视图
/// - Parameters:
///   - pageView: pageview
///   - page: 当前页
- (nonnull UIView *)pageView:(nullable ZFXPageView *)pageView itemViewAtPage:(NSInteger)page;

@end

@interface ZFXPageView : UIView

@property (nonatomic, weak, nullable) id <UIZFXPageViewDelegate> delegate;

/**
 重新加载数据 索引在正常范围内(currentIndex >= 0 && currentIndex < numberOfPages)当前页不变 否则会重新加载到第一页
 */
- (void)reloadData;

/**
 重新加载数据到第一页
 */
- (void)reloadDataToFirst;

/// 切换到下一页
/// @param animated 是否需要切换动画
- (BOOL)switchToNextPageAnimated:(BOOL)animated;

///  切换到上一页
/// @param animated 是否需要切换动画
- (BOOL)switchToPrePageAnimated:(BOOL)animated;

/**
 切换到某一页

 @param page 页数
 @param animated 是否需要切换动画
 @return 是否切换成功
 */
- (BOOL)switchToPage:(NSInteger)page animated:(BOOL)animated;


@end

NS_ASSUME_NONNULL_END
