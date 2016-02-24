//
//  DPDataCenterController.m
//  Jackpot
//
//  Created by wufan on 15/9/2.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPDataCenterTableController.h"
#import "DPDataCenterTableController+Private.h"

@interface DPDataCenterTableController () 
@property (nonatomic, weak) id<UITableViewDelegate, UITableViewDataSource> child;
@end

@implementation DPDataCenterTableController
@synthesize tableView = _tableView;
@synthesize title = _title;
@synthesize viewModel = _viewModel;

+ (UILabel *)signlLabel {
       UILabel*  _signlLabel = [[UILabel alloc] initWithFrame:CGRectMake(-5, 0, kScreenWidth - 20, 20)];
        _signlLabel.textAlignment = NSTextAlignmentRight;
        _signlLabel.backgroundColor = [UIColor clearColor];
        _signlLabel.font = [UIFont dp_systemFontOfSize:12.0];
        _signlLabel.textColor = UIColorFromRGB(0xADABA9);
        _signlLabel.text = @"以上数据仅供参考";
     return _signlLabel;
}


- (instancetype)initWithMatchId:(NSInteger)matchId delegate:(id<DPDataCenterTableControllerDelegate>)delegate {
    if (self = [super init]) {
        if (![self conformsToProtocol:@protocol(UITableViewDelegate)] ||
            ![self conformsToProtocol:@protocol(UITableViewDataSource)]) {
            @throw [NSException exceptionWithName:NSGenericException
                                    reason:@"child class must implementation UITableViewDelegate and UITableViewDataSource"
                                  userInfo:nil];
        }
        
        _matchId = matchId;
        _delegate = delegate;
        _child = (id<UITableViewDataSource, UITableViewDelegate>)self;
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:NSMallocException reason:@"Use initWithMatchId:delegate instead." userInfo:nil];
}

#pragma mark - Public Interface

- (void)request {
    
   
     [self.viewModel fetch];
    if ([self.delegate respondsToSelector:@selector(requestDidStart:)]) {
        [self.delegate requestDidStart:self];
    }
}

- (BOOL)requestIfNeeded {
    BOOL hasData = self.viewModel.hasData;
    if (!hasData) {
        [self request];
    }
    return !hasData;
}

#pragma mark - Delegate

#pragma mark - DPDataCenterViewModelDelegate 

- (void)fetchFinished:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(requestDidFinish:error:)]) {
        [self.delegate requestDidFinish:self error:error];
    }
    [self.tableView reloadData];
}

#pragma mark - Property (getter, setter)

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = (id<UITableViewDelegate>)self;
        _tableView.dataSource = (id<UITableViewDataSource>)self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColorFromRGB(0xfaf9f2);
//        _tableView.allowsSelection = NO;
//        _tableView.contentInset = UIEdgeInsetsMake(kHeaderHeight + kTabBarHeight, 0, 0, 0);
//        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderHeight + kTabBarHeight)];
    }
    return _tableView;
}

@end


