//
//  DPLotteryInfoViewModel.m
//  Jackpot
//
//  Created by wufan on 15/9/22.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPLotteryInfoViewModel.h"


static const NSInteger kTotalSize = 200;

@interface DPLotteryInfoItem : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) NSInteger gameType;
@property (nonatomic, assign) NSInteger newsId;
@property (nonatomic, strong) PBMShareItem *shareItem;
@end
@implementation DPLotteryInfoItem
@end

@interface DPLotteryInfoViewModel ()
@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation DPLotteryInfoViewModel

#pragma mark - Life cycle

- (instancetype)init {
    if (self = [super init]) {
        _totalCount = kTotalSize;
    }
    return self;
}

- (void)dealloc {
    [self.task cancel];
}

#pragma mark - Public Interface

- (NSInteger)gameTypeAtIndex:(NSInteger)index {
    return [self itemAtIndex:index].gameType;
}

- (NSString *)titleAtIndex:(NSInteger)index {
    return [self itemAtIndex:index].title;
}

- (NSString *)dateTextAtIndex:(NSInteger)index {
    return [self itemAtIndex:index].date;
}

- (NSString *)URLAtIndex:(NSInteger)index {
    return [self itemAtIndex:index].url;
}
- (PBMShareItem *)shareItemAtIndex:(NSInteger)index{
    return [self itemAtIndex:index].shareItem;
}

- (void)fetch {
    if (self.task) {
        if ([self.task.dp_userInfo isEqualToString:NSStringFromSelector(_cmd)]) {
            return;
        } else {
            [self.task cancel];
            self.task = nil;
        }
    }
    
    NSDictionary *parameters = @{@"ps": @(kPageSize),
                                 @"pi": @1};

    @weakify(self);
    self.task = [[AFHTTPSessionManager dp_sharedManager] GET:self.url
        parameters:parameters
        success:^(NSURLSessionDataTask *task, id responseObject) {
            @strongify(self);
            self.task = nil;
            self.currentCount = kPageSize;
            
            [self.items removeAllObjects];
            [self parserFromMessage:[PBMNewsInfo parseFromData:responseObject error:nil]];
            if ([self.delegate respondsToSelector:@selector(viewModel:fetchFinished:)]) {
                [self.delegate viewModel:self fetchFinished:nil];
            }
        }
        failure:^(NSURLSessionDataTask *task, NSError *error){
            @strongify(self);
            self.task = nil;
            if ([self.delegate respondsToSelector:@selector(viewModel:fetchFinished:)]) {
                [self.delegate viewModel:self fetchFinished:error];
            }
        }];
    self.task.dp_userInfo = NSStringFromSelector(_cmd);
}

- (void)fetchMore {
    if (self.task) {
        return;
    }
    
    NSDictionary *parameters = @{@"ps": @(kPageSize),
                                 @"pi": @(self.currentCount / kPageSize + 1)};

    @weakify(self);
    self.task = [[AFHTTPSessionManager dp_sharedManager] GET:self.url
        parameters:parameters
        success:^(NSURLSessionDataTask *task, id responseObject) {
            @strongify(self);
            self.task = nil;
            self.currentCount += kPageSize;
            
            [self parserFromMessage:[PBMNewsInfo parseFromData:responseObject error:nil]];
            if ([self.delegate respondsToSelector:@selector(viewModel:fetchFinished:)]) {
                [self.delegate viewModel:self fetchFinished:nil];
            }
        }
        failure:^(NSURLSessionDataTask *task, NSError *error){
            @strongify(self);
            self.task = nil;
            
            if (error.code == NSURLErrorCancelled) {
                return;
            }
            
            if ([self.delegate respondsToSelector:@selector(viewModel:fetchFinished:)]) {
                [self.delegate viewModel:self fetchFinished:error];
            }
        }];
    self.task.dp_userInfo = NSStringFromSelector(_cmd);
}

#pragma mark - Internal Interface

- (DPLotteryInfoItem *)itemAtIndex:(NSInteger)index {
    return [self.items dp_safeObjectAtIndex:index];
}

- (void)parserFromMessage:(PBMNewsInfo *)message {

    NSArray *items = [message.infoArray dp_mapObjectUsingBlock:^id(PBMNewsInfo_Item *obj, NSUInteger idx, BOOL *stop) {
        
        // 去重
        for (DPLotteryInfoItem *item in self.items) {
            if (item.newsId == obj.newsId) {
                return nil;
            }
        }
        DPLotteryInfoItem *item = [[DPLotteryInfoItem alloc] init];
        item.title = obj.title;
        item.url = obj.uRL;
        item.gameType = obj.gameTypeId;
        item.newsId = obj.newsId;
        item.date = [NSDate dp_coverDateString:obj.time fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm];
        item.shareItem = obj.shareItem;
        return item;
    }];
    [self.items addObjectsFromArray:items];
}


#pragma mark - Property (getter, setter)

- (NSMutableArray *)items {
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (BOOL)hasMore {
    return ((_currentCount == 0) || (_totalCount > _currentCount));
}

- (NSInteger)count {
    return _items.count;
}

@end
