//
//  YEWebViewH5-OC.m
//  YEWebView(H5_OC)
//
//  Created by yongen on 17/3/27.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import "YEWebViewH5-OC.h"

@interface YEWebViewH5_OC ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, assign) CGFloat webViewHeight;
@property (nonatomic, assign) NSInteger count;

@end

@implementation YEWebViewH5_OC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
         [self configWebView];
}

- (void)configWebView{
    
    self.webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    _webView.backgroundColor = [UIColor redColor];
    _webView.delegate = self;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"First" ofType:@"html"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:path]];
    [_webView loadRequest:request];
    
    self.count = 0;
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSURL * url = [request URL];
    
    if ([[url scheme] isEqualToString:@"firstclick"]) {
        NSArray *params =[url.query componentsSeparatedByString:@"&"];
        
        
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        for (NSString *paramStr in params) {
            NSArray *dicArray = [paramStr componentsSeparatedByString:@"="];
            if (dicArray.count > 1) {
                NSString *decodeValue = [dicArray[1] stringByRemovingPercentEncoding];
                [tempDic setObject:decodeValue forKey:dicArray[0]];
            }
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"方式一" message:@"这是OC原生的弹出窗" delegate:self cancelButtonTitle:@"收到" otherButtonTitles:nil];
        [alertView show];
        NSLog(@"tempDic:%@",tempDic);
        return NO;
    }
    
#pragma mark - JS来获取高度：document.body.offsetHeight;
    self.webViewHeight = webView.scrollView.contentSize.height;
    NSLog(@"self.webViewHeight===%f", self.webViewHeight);
    
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.activityIndicatorView stopAnimating];
    
    NSString *secretAgent = [_webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    NSString *newUagent = [NSString stringWithFormat:@"%@ version/3.0.5&safari/iPhone&comcnwest.news.CNWestIphone",secretAgent];
    
    NSLog(@"newUagent-------%@", newUagent);
    
    NSString *jsStr = [NSString stringWithFormat:@"pushNativeInfos('%@')",newUagent];
    [self.webView stringByEvaluatingJavaScriptFromString:jsStr];
    
#pragma mark - JS来获取高度：document.body.offsetHeight;
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] intValue];
    if (self.webViewHeight != height && self.count <= 3) {
        self.webViewHeight = height;
        self.count++;
        NSLog(@"height====%f,self.webViewHeight===== %f", height, self.webViewHeight);
    }
    
    
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.activityIndicatorView startAnimating];
    
    
    
}



- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    // 判断button是否被触摸
    if (!self.button ) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}


@end
