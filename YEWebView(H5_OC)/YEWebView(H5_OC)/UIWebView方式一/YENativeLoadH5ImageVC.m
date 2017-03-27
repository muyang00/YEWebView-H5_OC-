//
//  YENativeLoadH5ImageVC.m
//  YEWebView(H5_OC)
//
//  Created by yongen on 17/3/27.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "YENativeLoadH5ImageVC.h"

@interface YENativeLoadH5ImageVC ()

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSMutableArray *imageViews;

@end

@implementation YENativeLoadH5ImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"iOS Native加载H5中的图片";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self setupNativeImageWebView];
    
}
- (void)setupNativeImageWebView{
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"NativeImage" withExtension:@"html"];
    NSString *html = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<img\\ssrc[^>]*/>" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSArray *result = [regex matchesInString:html options:NSMatchingReportCompletion range:NSMakeRange(0, html.length)];
    
    NSMutableDictionary *urlDicts = [[NSMutableDictionary alloc] init];
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    for (NSTextCheckingResult *item in result) {
        NSString *imgHtml = [html substringWithRange:[item rangeAtIndex:0]];
        
        NSArray *tmpArray = nil;
        if ([imgHtml rangeOfString:@"src=\""].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"src=\""];
        } else if ([imgHtml rangeOfString:@"src="].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"src="];
        }
        
        if (tmpArray.count >= 2) {
            NSString *src = tmpArray[1];
            
            NSUInteger loc = [src rangeOfString:@"\""].location;
            if (loc != NSNotFound) {
                src = [src substringToIndex:loc];
                
                NSLog(@"正确解析出来的SRC为：%@", src);
                if (src.length > 0) {
                    NSString *localPath = [docPath stringByAppendingPathComponent:[self md5:src]];
                    // 先将链接取个本地名字，且获取完整路径
                    [urlDicts setObject:localPath forKey:src];
                }
            }
        }
    }
    
    // 遍历所有的URL，替换成本地的URL，并异步获取图片
    for (NSString *src in urlDicts.allKeys) {
        NSString *localPath = [urlDicts objectForKey:src];
        html = [html stringByReplacingOccurrencesOfString:src withString:localPath];
        
        // 如果已经缓存过，就不需要重复加载了。
        if (![[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
           
        }
    }
    

    
    [self.webView loadHTMLString:html baseURL:url];
    
}

- (NSString *)md5:(NSString *)sourceContent {
    if (self == nil || [sourceContent length] == 0) {
        return nil;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([sourceContent UTF8String], (int)[sourceContent lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}



@end
