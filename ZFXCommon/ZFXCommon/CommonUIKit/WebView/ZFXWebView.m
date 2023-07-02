//
//  ZFXWebView.m
//  ZFXCommon
//
//  Created by zhuhc on 2023/6/30.
//

#import "ZFXWebView.h"

#define ZFXWebEstimatedProgress @"estimatedProgress"
#define ZFXWebTitle @"title"

// 解决 WKWebView 内存不释放的问题
@interface WeakWebViewScriptMessageDelegate : NSObject<WKScriptMessageHandler>

// WKScriptMessageHandler 这个协议类专门用来处理JavaScript调用原生OC的方法
@property (weak, nonatomic, nullable) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end

@implementation WeakWebViewScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        self.scriptDelegate = scriptDelegate;
    }
    return self;
}

#pragma mark - WKScriptMessageHandler
//遵循WKScriptMessageHandler协议，必须实现如下方法，然后把方法向外传递
//通过接收JS传出消息的name进行捕捉的回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([self.scriptDelegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}

@end

@interface ZFXWebView ()<WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate>

/// webView
@property (nullable, strong, nonatomic) WKWebView *webView;

/// progress 加载进度
@property (nullable, strong, nonatomic) UIProgressView *progressView;

@end

@implementation ZFXWebView


- (void)dealloc {
    
    [self removeObserver];
    
    [self removeScriptMessages];
}

#pragma mark - init and subviews

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

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
    
    // progress
    self.progressView.frame = CGRectMake(0, 0, self.frame.size.width, 1.0);
    
    // webview
    self.webView.frame = self.bounds;
}


- (void)setupUI {
    
    // 添加wkWebView
    // 设置wkWebView 的配置信息
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    
    // 创建设置对象
    WKPreferences *perferences = [[WKPreferences alloc] init];
    
    //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
    perferences.minimumFontSize = 0;
    // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
    perferences.javaScriptCanOpenWindowsAutomatically = YES;
    
    configuration.preferences = perferences;
    
    //设置请求的User-Agent信息中应用程序名称 iOS9后可用
//    configuration.applicationNameForUserAgent = @"";
    
    // 是否允许H5播放器内联播放 YES: 允许 NO:使用原生全屏控制器
    configuration.allowsInlineMediaPlayback = YES;
    
    // 是否允许H5视频支持画中画
    configuration.allowsPictureInPictureMediaPlayback = YES;
    
    // 是否允许H5视频AirPlay
    configuration.allowsAirPlayForMediaPlayback = YES;
    
    self.webView = [[WKWebView alloc] initWithFrame:self.bounds configuration:configuration];
    
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    
    [self addSubview:self.webView];
    
    // 添加progressView
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1.0)];
    self.progressView.tintColor = [UIColor orangeColor];
    self.progressView.progressTintColor = [UIColor orangeColor];
    self.progressView.trackTintColor = [UIColor clearColor];
    // 进度条默认设置
    [self addSubview:self.progressView];
    
    self.isHideProgressView = NO;
    
    // 添加观察者
    [self addObserver];
}

#pragma mark - public action

- (void)loadWithUrlString:(NSString *)urlString {
    
    if (urlString == nil || urlString.length <= 0) return;
    
    NSURL *url = [NSURL URLWithString:urlString];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)loadFileURLString:(NSString *)urlString {
    
    if (urlString == nil || urlString.length <= 0) return;
    NSURL *url =  [NSURL fileURLWithPath:urlString];
    [self.webView loadFileURL:url allowingReadAccessToURL:url];
}

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL {
    if (string == nil || string.length <= 0) return;
    [self.webView loadHTMLString:string baseURL:baseURL];
}

- (void)loadWithUrl:(NSURL *)url {
    if (url == nil) return;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}


- (BOOL)canGoBack {
    return self.webView.canGoBack;
}

- (BOOL)canGoForward {
    return self.webView.canGoForward;
}

- (void)goBack {
    [self.webView goBack];
}

- (void)goForward {
    [self.webView goForward];
}

- (void)reload {
    [self.webView reload];
}

- (void)reloadUrlString:(NSString *)urlString {
    if (urlString == nil || urlString.length <= 0) return;
    
    [self removeScriptMessages];
    [self removeObserver];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    [self addObserver];
}

- (void)reloadWithUrl:(NSURL *)url {
    
    if (url == nil) return;
    
    [self removeScriptMessages];
    [self removeObserver];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    [self addObserver];
}

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id _Nullable, NSError * _Nullable))completionHandler {
    [self.webView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
}

#pragma mark - pravite action

//  网页JS调原生:
//   1> 需要先设置Webview.config 的WKUserContentController
//   2> 注册方法名 [userCC addScriptMessageHandler:self name:];
//   3> 遵守协议<WKScriptMessageHandler>，实现其方法.
//   4> 在控制器销毁时，需要移除方法名注册
- (void)setUserContentController {
    if (self.scriptMessages.count <= 0) return;
    
    // 自定义的WKScriptMessageHandler 是为了解决内存不释放的问题
    WeakWebViewScriptMessageDelegate *delegate = [[WeakWebViewScriptMessageDelegate alloc] initWithDelegate:self];
    
    //这个类主要用来做native与JavaScript的交互管理
    WKUserContentController *content = [[WKUserContentController alloc] init];
    
    // 注册js方法 设置处理接收JS方法的对象
    for (NSString *name in self.scriptMessages) {
        [content addScriptMessageHandler:delegate name:name];
    }
    
    self.webView.configuration.userContentController = content;
}

/**
 * 移除与JS交互的方法
 */
- (void)removeScriptMessages {
    if (self.scriptMessages.count == 0) return;
    
    for (NSString *name in self.scriptMessages) {
        [[self.webView configuration].userContentController removeScriptMessageHandlerForName:name];
    }
}

/**
 * 添加观察者 KVO
 */
- (void)addObserver {
    [self.webView addObserver:self forKeyPath:ZFXWebEstimatedProgress options:0 context:nil];
    [self.webView addObserver:self forKeyPath:ZFXWebTitle options:0 context:nil];
}

/**
 * 移除观察者 KVO
 */
- (void)removeObserver {
    [self.webView removeObserver:self forKeyPath:ZFXWebEstimatedProgress context:nil];
    [self.webView removeObserver:self forKeyPath:ZFXWebTitle context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:ZFXWebEstimatedProgress]) {
//        NSLog(@"网页加载进度 = %f",self.wkWebView.estimatedProgress);
        self.progressView.progress = self.webView.estimatedProgress;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.progressView.progress = 0.0;
        });
    }
    else if ([keyPath isEqualToString:ZFXWebTitle]) {
        
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - WKScriptMessageHandler
/**
 * 和JS 交互的方法
 */
- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    NSLog(@"name:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n",message.name,message.body,message.frameInfo);
    /**
     * 和JS交互回调方法
     * 回调到上层 有上层代码进行操作
     */
    if (self.didReceiveScriptMessage) {
        self.didReceiveScriptMessage(message.name, message.body);
    }
    
    if ([self.delegate respondsToSelector:@selector(webView:didReceiveScriptMessageWithName:body:)]) {
        [self.delegate webView:self didReceiveScriptMessageWithName:message.name body:message.body];
    }
}

#pragma mark - WKScriptMessageHandler && WKScriptMessageHandler
/**
 * 截取URL 进行跳转和其它
 * 是否允许继续加载url请求
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if (self.requests.count == 0) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    // 获取完整url并进行UTF-8转码
    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];

    // 是否允许继续加载
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    
    // 进行代理方法回调处理
    for (NSString *request in self.requests) {
        if ([strRequest hasPrefix:request]) {
            actionPolicy = WKNavigationActionPolicyCancel;
            break;
        }
    }
    
    // 调用代理或block回调
    if (self.decidePolicyForNavigationAction) {
        self.decidePolicyForNavigationAction(strRequest);
    }
    
    if ([self.delegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:request:)]) {
        [self.delegate webView:self decidePolicyForNavigationAction:navigationAction request:strRequest];
    }
    
    // 是否允许跳转
    decisionHandler(actionPolicy);
}

/*
 WKNavigationDelegate主要处理一些跳转、加载处理操作，WKUIDelegate主要处理JS脚本，确认框，警告框等
 */

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {

}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
    
    if (self.didFinishNavigation) self.didFinishNavigation(NO);
    
    if ([self.delegate respondsToSelector:@selector(webView:didFinishNavigation:)]) {
        [self.delegate webView:self didFinishNavigation:NO];
    }
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    if (self.didFinishNavigation) self.didFinishNavigation(YES);
    
    if ([self.delegate respondsToSelector:@selector(webView:didFinishNavigation:)]) {
        [self.delegate webView:self didFinishNavigation:YES];
    }
}

// 提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
    
    if (self.didFinishNavigation) self.didFinishNavigation(NO);
    
    if ([self.delegate respondsToSelector:@selector(webView:didFinishNavigation:)]) {
        [self.delegate webView:self didFinishNavigation:NO];
    }
}
 
// 进程被终止时调用
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    
}

#pragma mark - setter action
- (void)setScriptMessages:(NSArray<NSString *> *)scriptMessages{
    _scriptMessages = scriptMessages;
    
    [self setUserContentController];
}


- (void)setRequests:(NSArray<NSString *> *)requests {
    _requests = requests;
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    
    if (tintColor == nil) return;
    
    self.progressView.tintColor = tintColor;
}

- (void)setProgressTintColor:(UIColor *)progressTintColor {
    _progressTintColor = progressTintColor;
    
    if (progressTintColor == nil) return;
    
    self.progressView.progressTintColor = progressTintColor;
}

- (void)setTrackTintColor:(UIColor *)trackTintColor {
    _trackTintColor = trackTintColor;
    
    if (trackTintColor == nil) return;
    
    self.progressView.trackTintColor = trackTintColor;
}

- (void)setIsHideProgressView:(BOOL)isHideProgressView {
    _isHideProgressView = isHideProgressView;
    
    self.progressView.hidden = isHideProgressView;
}


@end
