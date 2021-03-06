//
//  YEWebViewStyleTwoVC.m
//  YEWebView(H5_OC)
//
//  Created by yongen on 17/3/27.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>
#import "YEWebViewStyleTwoVC.h"
#import "YEJS_OCModel.h"

/*
 iOS7之后出了JavaScriptCore.framework用于与JS交互
 */

@interface YEWebViewStyleTwoVC ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) JSContext *jsContext;

@end

@implementation YEWebViewStyleTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"UIWebView交互方式二";
    
    [self.view addSubview:self.webView];
    
    //  // 一个JSContext对象，就类似于Js中的window，只需要创建一次即可。
    //  self.jsContext = [[JSContext alloc] init];
    //
    //  // jscontext可以直接执行JS代码。
    //  [self.jsContext evaluateScript:@"var num = 10"];
    //  [self.jsContext evaluateScript:@"var squareFunc = function(value) { return value * 2 }"];
    //  // 计算正方形的面积
    //  JSValue *square = [self.jsContext evaluateScript:@"squareFunc(num)"];
    //
    //  // 也可以通过下标的方式获取到方法
    //  JSValue *squareFunc = self.jsContext[@"squareFunc"];
    //  JSValue *value = [squareFunc callWithArguments:@[@"20"]];
    //  NSLog(@"%@", square.toNumber);
    //  NSLog(@"%@", value.toNumber);
}

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.scalesPageToFit = YES;
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"test_02_01" withExtension:@"html"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
        _webView.delegate = self;
    }
    
    return _webView;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 通过模型调用方法，这种方式更好些。
    YEJS_OCModel *model  = [[YEJS_OCModel alloc] init];
    self.jsContext[@"OCModel"] = model;
    model.jsContext = self.jsContext;
    model.webView = self.webView;
    
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}



@end
