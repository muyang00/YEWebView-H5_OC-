//
//  YEWebViewStyleOneVC.m
//  YEWebView(H5_OC)
//
//  Created by yongen on 17/3/27.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import "YEWebViewStyleOneVC.h"
#import "YEWebViewH5-OC.h"
#import "YEH5ImageAutoFitVC.h"
#import "YENativeLoadH5ImageVC.h"
#import "YEH5ImageAddTapEventVC.h"
#import "YENewsDetailVC.h"

/*第一种：有很多的app直接使用在webview的代理中通过拦截的方式与native进行交互，通常是通过拦截url scheme判断是否是我们需要拦截处理的url及其所对应的要处理的功能是什么
 */
#define kKeyWindow [UIApplication sharedApplication].keyWindow
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
static NSString *tableViewCell = @"cell";

@interface YEWebViewStyleOneVC ()<UITableViewDelegate, UITableViewDataSource,UITableViewDataSourcePrefetching>

//列表
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, retain) UITableView *tableView;

@end

@implementation YEWebViewStyleOneVC

- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [NSMutableArray arrayWithCapacity:0];
        [_datasource addObjectsFromArray:@[@"UIWebVC(H5 和 OC的交互)",@"WebView图片自适应", @"Native加载H5中的图片", @"WebView图片添加点击事件", @" 仿今日头条新闻详情页的H5图文混排方式"]];
    }
    return _datasource;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"UIWebView交互方式一";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];
    
}

- (void)setupTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.prefetchDataSource = self;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.rowHeight = 60;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:tableViewCell];
    self.tableView.separatorColor = [UIColor orangeColor];
    [self.view addSubview:self.tableView];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    static NSString *resusedCell = @"cell";
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resusedCell];
    //    if (!cell) {
    //        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resusedCell];
    //    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCell forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.datasource[indexPath.row];
    cell.textLabel.textColor = [UIColor blueColor];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
     case 0://
        {
            YEWebViewH5_OC *UIWebVC = [[YEWebViewH5_OC alloc]init];
            [self.navigationController pushViewController:UIWebVC animated:YES];
            break;
        }
        case 1://
        {
            YEH5ImageAutoFitVC *UIWebVC = [[YEH5ImageAutoFitVC alloc]init];
            [self.navigationController pushViewController:UIWebVC animated:YES];
            break;
        }
        case 2://
        {
            YENativeLoadH5ImageVC *UIWebVC = [[YENativeLoadH5ImageVC alloc]init];
            [self.navigationController pushViewController:UIWebVC animated:YES];
            break;
        }
        case 3://
        {
            YEH5ImageAddTapEventVC *UIWebVC = [[YEH5ImageAddTapEventVC alloc]init];
            [self.navigationController pushViewController:UIWebVC animated:YES];
            break;
        }
        case 4://
        {
            YENewsDetailVC *UIWebVC = [[YENewsDetailVC alloc]init];
            UIWebVC.passTitle = self.datasource[indexPath.row];
            [self.navigationController pushViewController:UIWebVC animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - iOS 10 新特性
- (void)tableView:(UITableView *)tableView prefetchRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    
}

- (void)tableView:(UITableView *)tableView cancelPrefetchingForRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    
}

@end
