//
//  ZFXAnswerPageView.h
//  ZFXCommon
//
//  Created by zhuhc on 2023/5/26.
//

#import <UIKit/UIKit.h>

/// 一个简易的答题视图，类似驾考宝典等答题的界面展示
NS_ASSUME_NONNULL_BEGIN

@class ZFXAnswerPageView;

@protocol ZFXAnswerPageViewDelegate <NSObject>

@required
/// 返回视图总个数
- (NSInteger)numberOfPageInPageView:(nullable ZFXAnswerPageView *)pageView;

/// 获取当前展示的视图
/// - Parameters:
///   - pageView: pageView
///   - index: 索引
- (nonnull UIView *)pageView:(nullable ZFXAnswerPageView *)pageView itemViewAtIndex:(NSInteger)index;

@end

@interface ZFXAnswerPageView : UIView

@property (nonatomic, weak, nullable) id <ZFXAnswerPageViewDelegate> delegate;


- (void)switchToNextPageAnimated:(BOOL)animated;

- (void)switchToPrePageAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
