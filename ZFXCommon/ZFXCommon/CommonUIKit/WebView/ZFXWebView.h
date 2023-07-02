//
//  ZFXWebView.h
//  ZFXCommon
//
//  Created by zhuhc on 2023/6/30.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZFXWebView;

@protocol UIZFXWebViewDelegate <NSObject>

@optional
/// JS交互代理回调方法
/// @param webView webView
/// @param name name description
/// @param body body description
- (void)webView:(nullable ZFXWebView *)webView didReceiveScriptMessageWithName:(nullable NSString *)name body:(nullable id)body;

/// 接收特定URL处理回调
/// @param webView webView description
/// @param name name description
/// @param request request description
- (void)webView:(nullable ZFXWebView *)webView decidePolicyForNavigationAction:(nullable WKNavigationAction *)name request:(nullable NSString *)request;

/// web load finish
/// @param webView webView description
/// @param isLoadSuccess is load success YES or NO
- (void)webView:(nullable ZFXWebView *)webView didFinishNavigation:(BOOL) isLoadSuccess;

@end
@interface ZFXWebView : UIView


/// 代理方法
@property (nullable, weak, nonatomic) id<UIZFXWebViewDelegate> delegate;

/// 接收js方法的数组 JS调用OC原生方法 数组
@property (nullable, strong, nonatomic) NSArray<NSString *> *scriptMessages;

/// 对特定请求进行处理的内容
@property (nullable, strong, nonatomic) NSArray<NSString *> *requests;

/// progressView tintColor
@property (nullable, strong, nonatomic) UIColor *tintColor;

/// progressView progressTintColor
@property (nullable, strong, nonatomic) UIColor *progressTintColor;

/// progressView trackTintColor
@property (nullable, strong, nonatomic) UIColor *trackTintColor;

/// 是否隐藏 progressView default NO
@property (assign, nonatomic) BOOL isHideProgressView;

/// JS交互回调方法
@property (nullable, copy, nonatomic) void(^didReceiveScriptMessage)(NSString * _Nullable name, id _Nullable body);

/// 接收特定URL处理回调
@property (nullable, copy, nonatomic) void(^decidePolicyForNavigationAction)(NSString * _Nullable request);

/// web load finish
/// isLoadSuccess 是否加载成功
@property (nullable, copy, nonatomic) void(^didFinishNavigation)(BOOL isLoadSuccess);

/// webview 加载
/// @param urlString 网页地址
- (void)loadWithUrlString:(nonnull NSString *)urlString;

/// webview 加载
/// @param url url 对象
- (void)loadWithUrl:(nonnull NSURL *)url;

// TODO: - 加载本地HTML文件
- (void)loadFileURLString:(nonnull NSString *)urlString;

/// 加载html文件
/// - Parameters:
///   - string: html链接
///   - baseURL: baseURL
- (void)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL;

/// 是否可以返回到上一个网页
- (BOOL)canGoBack;

/// 是否可以push到下一个网页
- (BOOL)canGoForward;

/// 返回上一个网页
- (void)goBack;

/// push下一个网页
- (void)goForward;

/// 重新加载
- (void)reload;

/// 重新加载新的网页
/// @param urlString urlString 网页地址
- (void)reloadUrlString:(nonnull NSString *)urlString;

/// 重新加载新的网页
/// @param url url url 对象
- (void)reloadWithUrl:(nonnull NSURL *)url;

/// OC 调用JS 方法
/// @param javaScriptString 要执行的JS方法
/// @param completionHandler 调用回调
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
