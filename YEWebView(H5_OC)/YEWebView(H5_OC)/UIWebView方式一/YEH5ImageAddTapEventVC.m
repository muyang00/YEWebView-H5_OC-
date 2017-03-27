//
//  YEH5ImageAddTapEventVC.m
//  YEWebView(H5_OC)
//
//  Created by yongen on 17/3/27.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import "YEH5ImageAddTapEventVC.h"

@interface YEH5ImageAddTapEventVC ()<UIWebViewDelegate>

@end

@implementation YEH5ImageAddTapEventVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ObjC点击H5图片Native预览";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self setupClickImageWebView];
}
- (void)setupClickImageWebView{
    
    UIWebView *webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webview];
    webview.delegate = self;
    
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.jianshu.com/p/8d7365e89305"]]];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.scheme hasPrefix:@"image-preview"]) {
        // 获取原始图片的完整URL
        NSString *src = [request.URL.absoluteString stringByReplacingOccurrencesOfString:@"image-preview:" withString:@""];
        if (src.length > 0) {
            // 原生API展开图片
            // 这里已经拿到所点击的图片的URL了，剩下的部分，自己处理了
            // 有时候会感觉点击无响应，这是因为webViewDidFinishLoad,还没有调用。
            // 调用很晚的原因，通常是因为H5页面中有比较多的内容在加载
            // 因此，若是原生APP与H5要交互，H5要尽可能地提高加载速度
            // 不相信？在webViewDidFinishLoad加个断点就知道了
            NSLog(@"所点击的HTML中的img标签的图片的URL为：%@", src);
        }
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *js = @"function addImgClickEvent() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) { \
    var img = imgs[i]; \
    img.onclick = function () { \
    window.location.href = 'image-preview:' + this.src; \
    }; \
    } \
    }";
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"addImgClickEvent();"];
}



@end
