//
//  YEH5ImageAutoFitVC.m
//  YEWebView(H5_OC)
//
//  Created by yongen on 17/3/27.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import "YEH5ImageAutoFitVC.h"

@interface YEH5ImageAutoFitVC ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, assign) CGFloat webViewHeight;


@end

@implementation YEH5ImageAutoFitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"web 图片自适应ImageWebVC";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configImageWebView];
}
- (void)configImageWebView{
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Image" ofType:@"html"];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]]];
    
    webView.delegate = self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    img.style.maxWidth = %f;   \
    } \
    }";
    js = [NSString stringWithFormat:js, [UIScreen mainScreen].bounds.size.width - 20];
    
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
}


@end
