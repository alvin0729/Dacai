//
//  DPDataCenterBaseViewModel.m
//  Jackpot
//
//  Created by wufan on 15/9/2.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPDataCenterBaseViewModel.h"

@interface DPDataCenterBaseViewModel ()
@property (nonatomic, weak) id<IDPDataCenterViewModel> child;
@property (nonatomic, strong) NSURLSessionDataTask *requestTask;
/**
 *  是否有数据
 */
@property (nonatomic, assign) BOOL hasData;
@end

@implementation DPDataCenterBaseViewModel

#pragma mark - Lifecycle

- (instancetype)init {
    @throw [NSException exceptionWithName:NSGenericException reason:@"Use initWithMatchId:delegate: instead." userInfo:nil];
}

- (instancetype)initWithMatchId:(NSInteger)matchId {
    if (self = [super init]) {
        _matchId = matchId;
        _child = (id<IDPDataCenterViewModel>)self;
        
        // 子类必须实现 IDPDataCenterViewModel 协议
        NSAssert([self conformsToProtocol:@protocol(IDPDataCenterViewModel)], @"ViewModel must implement IDPDataCenterViewModel interface.");
        
        // 子类必须实现以下协议方法
        NSAssert([self.child respondsToSelector:@selector(fetchURL)], @"failure...");
        NSAssert([self.child respondsToSelector:@selector(parserData:)], @"failure...");
    }
    return self;
}

- (void)dealloc {
    [self.requestTask cancel];
}

#pragma mark - Public Interface

- (void)fetch {
    NSAssert(self.requestTask == nil, @"failure...");
    
        
    NSString *url = [self.child fetchURL] ? [[self.child fetchURL] copy] : @"";
    NSDictionary *parameters;
    if ([self.child respondsToSelector:@selector(fetchParameters)]) {
        parameters = [self.child fetchParameters];
    } else {
        parameters = @{ @"matchid": @(self.matchId) };
    }
    
    @weakify(self);
    NSURLSessionDataTask *task = [[AFHTTPSessionManager dp_sharedManager] GET:url
        parameters:parameters
        success:^(NSURLSessionDataTask *task, id responseObject) {
            @strongify(self);
            [self.child parserData:responseObject];
            if ([self.delegate respondsToSelector:@selector(fetchFinished:)]) {
                [self.delegate fetchFinished:nil];
            }
            self.requestTask = nil;
            self.hasData = YES;
        }
        failure:^(NSURLSessionDataTask *task, NSError *error){
            @strongify(self);
            NSLog(@"error: %@, code: %d", error.localizedDescription, (int)error.code);
            if ([self.delegate respondsToSelector:@selector(fetchFinished:)]) {
                [self.delegate fetchFinished:error];
            }
            self.requestTask = nil;
            self.hasData = NO;
        }];
    
    self.requestTask = task;
}

@end
