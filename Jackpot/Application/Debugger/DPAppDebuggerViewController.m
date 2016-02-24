//
//  DPAppDebuggerViewController.m
//  Jackpot
//
//  Created by WUFAN on 15/12/9.
//  Copyright © 2015年 dacai. All rights reserved.
//

#ifdef DEBUG

#import "DPAppDebuggerViewController.h"
#import "DPAppDebuggerTestController.h"
#import "DPDltContentModel.h"

@interface DPAppDebuggerListItem : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, copy) void (^execute)(void);

+ (DPAppDebuggerListItem *)itemWithTitle:(NSString *)title execute:(void (^)(void))execute;
@end

@implementation DPAppDebuggerListItem
+ (DPAppDebuggerListItem *)itemWithTitle:(NSString *)title execute:(void (^)(void))execute {
    DPAppDebuggerListItem *item = [[DPAppDebuggerListItem alloc] init];
    item.title = title;
    item.execute = execute;
    return item;
}
@end

@interface DPAppDebuggerViewController ()
@property (nonatomic, strong) NSArray<DPAppDebuggerListItem *> *items;
@end

@implementation DPAppDebuggerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Debugger";
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithTitle:@"关闭" target:self action:@selector(onNavigatonLeftItem)];
    
    @weakify(self);
    DPAppDebuggerListItem *item1 = [DPAppDebuggerListItem itemWithTitle:@"KTMCollectionViewLayout" execute:^{
        @strongify(self);
        [self.navigationController pushViewController:[[DPAppDebuggerTestController alloc] init] animated:YES];
    }];
    DPAppDebuggerListItem *item2 = [DPAppDebuggerListItem itemWithTitle:@"分辨率适配" execute:^{
        @strongify(self);
        
        UIImage *image = dp_AccountImage(@"checked.png");
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
        }];
        
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor redColor];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.equalTo(@18);
            make.top.equalTo(imageView.mas_bottom).offset(10);
            make.centerX.equalTo(imageView);
        }];
        
        
        CGFloat widths[] = { 0.1, 0.5, 0.51,  0.8, 0.81, 0.85, 0.9, 0.99, 1.0, 1.01 };
        
        for (int i = 0; i < sizeof(widths) / sizeof(CGFloat); i++) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(50 + i * 5, 100, widths[i], 100)];
            line.backgroundColor = [UIColor blackColor];
            [self.view addSubview:line];
        }
    }];
    
    DPAppDebuggerListItem *item3 = [DPAppDebuggerListItem itemWithTitle:@"KTMToast" execute:^{
        [KTMToast showText:@"this is a test string."];
    }];
    DPAppDebuggerListItem *item4 = [DPAppDebuggerListItem itemWithTitle:@"KTMAlertView" execute:^{
        KTMAlertView *alertView = [KTMAlertView alertViewWithTitle:@"提示"
                                                           message:@"啊哈哈红烧豆腐啊士大夫是啊适当放宽就爱看三闾大夫士大啊哈"
                                                 cancelButtonTitle:@"前去查看"
                                               cancelButtonhandler:nil
                                                confirmButtonTitle:@"我知道了"
                                              confirmButtonHandler:nil];
        [alertView show];
    }];
    DPAppDebuggerListItem *item5 = [DPAppDebuggerListItem itemWithTitle:@"KTMIndicatorView" execute:^{
        @strongify(self);
        
        KTMIndicatorView *indicatorView = [KTMIndicatorView circleView];
        [indicatorView startAnimating];
        [self.view addSubview:indicatorView];
        [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
        }];
    }];
    
    DPAppDebuggerListItem *item6 = [DPAppDebuggerListItem itemWithTitle:@"YYModel" execute:^{
        NSString *json = @"[{\"BackAreaNums\":[\"11\",\"12\"],\"IsAdd\":false,\"IsSingle\":false,\"PropAreaNums\":[\"04\",\"08\",\"10\",\"11\",\"12\",\"19\",\"20\",\"35\"],\"__type\":\"DltDuplex\"},{\"BackAreaDrags\":[\"05\",\"06\"],\"BackAreaGalls\":[\"04\"],\"IsAdd\":false,\"IsSingle\":false,\"PropAreaDrags\":[\"05\",\"06\",\"07\",\"13\"],\"PropAreaGalls\":[\"02\",\"04\",\"25\"],\"__type\":\"DltGallDrag\"},{\"Bets\":[\"05,18,24,26,30|06,09\",\"05,11,24,25,31|03,10\",\"01,06,22,33,35|01,09\"],\"IsAdd\":false,\"IsSingle\":true,\"__type\":\"DltSingle\"}]";
        NSArray *array = [NSArray yy_modelArrayWithClass:[DPProjectDltBaseModel class] json:json];
        
        NSLog(@"array: %@", array);
    }];
    
    KTMCountLabel *countLabel = [[KTMCountLabel alloc] initWithFrame:CGRectMake(100, 400, 250, 30)];
    countLabel.backgroundColor = [UIColor blackColor];
    countLabel.textColor = [UIColor whiteColor];
    countLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:countLabel];
    DPAppDebuggerListItem *item7 = [DPAppDebuggerListItem itemWithTitle:@"KTMCountLabel" execute:^{
        [countLabel countWithDuration:1 animationCurve:UIViewAnimationCurveEaseOut fromNumber:10 toNumber:200 textHandler:nil];
    }];
    
    self.items = @[item1, item2, item3, item4, item5, item6, item7];
}

- (void)onNavigatonLeftItem {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    DPAppDebuggerListItem *item = self.items[indexPath.row];
    cell.textLabel.text = item.title;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DPAppDebuggerListItem *item = self.items[indexPath.row];
    if (item.execute) {
        item.execute();
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

#endif