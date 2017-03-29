//
//  YENewsDetailVC.m
//  YEWebView(H5_OC)
//
//  Created by yongen on 17/3/27.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import "YENewsDetailVC.h"

//颜色 两种参数
#define RGB_255(r,g,b) [UIColor colorWithRed:(float)r/255.0 green:(float)g/255.0 blue:(float)b/255.0 alpha:1]

#define RGBA_255(r,g,b,a) [UIColor colorWithRed:(float)r/255.0 green:(float)g/255.0 blue:(float)b/255.0 alpha:a]
//屏幕高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
//屏幕宽度
#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)

@interface YENewsDetailVC ()<UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) NSString *pathStr;
@property (nonatomic, copy) NSString *pathStr_02;
@property (nonatomic,assign) CGFloat webViewHeight;

@end

@implementation YENewsDetailVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.passTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addWebView];
    
    [self addWebViewTapGesture];
    
    [self loadWebURL];
}

- (void)loadWebURL{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"First" ofType:@"html"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://onk54h4sj.bkt.clouddn.com/YENewsDetailImage.html"]];
    [_webView loadRequest:request];
}

- (void)loadWebHtml{
    
    NSURL *cssURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"News" ofType:@"css"]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CellWeb" ofType:@"html"];
    NSString *html = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    [_webView loadHTMLString:[self handleWithHtmlBody:_pathStr_02] baseURL:cssURL];
    /*
     [_webView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
     [_webView loadHTMLString:html baseURL:nil];
     [_webView loadHTMLString:html baseURL:cssURL];
     */
}

- (NSString *)handleWithHtmlBody:(NSString *)htmlBody{//此处的htmlBody一定是图片或者视频链接已被替换过
    
    NSString *html = [htmlBody stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    NSString *cssName = @"News.css";
    NSMutableString *htmlString =[[NSMutableString alloc]initWithString:@"<html>"];
    [htmlString appendString:@"<head><meta charset=\"UTF-8\">"];
    //自适应
    [htmlString appendString:@"<meta name=\"viewport\" content=\"initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no\">"];
    [htmlString appendString:@"<link rel =\"stylesheet\" href = \""];
    [htmlString appendString:cssName];
    [htmlString appendString:@"\" type=\"text/css\" />"];
    [htmlString appendString:@"</head>"];
    [htmlString appendString:@"<body>"];
    [htmlString appendString:html];
    [htmlString appendString:@"</body>"];
    [htmlString appendString:@"</html>"];
    return htmlString;
}


- (void)addWebView{
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _webView.backgroundColor = RGB_255(247, 247, 247);
    _webView.scalesPageToFit = NO;
    _webView.delegate = self;
    // webView.scrollView.bounces = NO;
    //[_webView setAutoresizingMask:UIViewAutoresizingNone];
    //[webView.scrollView setScrollEnabled:NO];
    [_webView.scrollView setScrollsToTop:NO];
    [_webView sizeToFit];
    _webView.paginationBreakingMode = UIWebPaginationBreakingModePage;
    [self.view addSubview:_webView];
    //self.webView.multipleTouchEnabled = NO;
}

- (void)addWebViewTapGesture{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(webViewTapAction:)];
    tap.delegate = self;
    tap.cancelsTouchesInView = NO;
    tap.delaysTouchesBegan = YES;
    self.webView.userInteractionEnabled = YES;
    [self.webView addGestureRecognizer:tap];
}
#pragma mark - action
// 点击图片
- (void)webViewTapAction:(UITapGestureRecognizer *)tap{
    
    CGPoint pt = [tap locationInView:self.webView];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
    NSString *urlToSave = [self.webView stringByEvaluatingJavaScriptFromString:imgURL];
    
    NSLog(@"urlToSave------%@",urlToSave);
    
    if (urlToSave.length > 0) {
        //[self showImageURL:urlToSave point:pt];
    }
}

- (void)rightAction{
    
    NSString *jsStr = [NSString stringWithFormat:@"showAlert('%@')",@"这里是JS中alert弹出的message"];
    [_webView stringByEvaluatingJavaScriptFromString:jsStr];
    // [_webView stringByEvaluatingJavaScriptFromString:@"firstClick()"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
       // [self.webView stringByEvaluatingJavaScriptFromString:@"function assignImageClickAction(){var imgs=document.getElementsByTagName('img');var length=imgs.length;for(var i=0;i<length;i++){img=imgs[i];img.onclick=function(){window.location.href='image-preview:'+this.src}}}"];
      //  [self.webView stringByEvaluatingJavaScriptFromString:@"assignImageClickAction();"];

    _webViewHeight = [[webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"]floatValue];
    NSLog(@"webViewHeight --------  %.f",_webViewHeight);
    _webView.scrollView.contentSize = CGSizeMake(kScreenWidth, _webViewHeight);
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //预览图片
    if ([request.URL.scheme isEqualToString:@"image-preview"]) {
        NSString* path = [request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
        
       NSString *version = [UIDevice currentDevice].systemVersion;
        if (version.doubleValue > 9.0) {
          path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
        } else{
            path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //启动图片浏览器
            // [self tapPhoto:path];
        });
        
        return NO;
    }
    return YES;
}


@end
