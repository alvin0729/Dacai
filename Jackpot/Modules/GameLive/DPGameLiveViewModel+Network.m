//
//  DPGameLiveViewModel+Network.m
//  Jackpot
//
//  Created by wufan on 15/8/26.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "DPGameLiveViewModel+Network.h"
#import "DPGameLiveViewModel+Private.h"

static const CGFloat kDIAMETER = 40.0f;

@implementation DPGameLiveViewModel (Network)

- (void)fetch {
    NSString *kTypeKey = @"Type";
    
    // 如果存在请求, 进行判断
    if (self.homeTask) {
        DPGameLiveType gameLiveType = [[self.homeTask dp_strongObjectForKey:kTypeKey] integerValue];
        if (gameLiveType == self.gameLiveType) {
            // 如果请求是同一类型, 不需要重新请求了
            return;
        } else {
            // 否则, 取消上个请求, 并重新请求
            [self.homeTask cancel];
        }
    }
    
    // 停止轮询请求
    [self deactivateUpdateLoop];
    // 删除所有进球事件
    [self.goalSet removeAllObjects];
    
    NSLog(@"gamelive request...");
    NSString *url = self.gameLiveType == DPGameLiveTypeFootball ? @"/live/getjczqlivematch" : @"live/getjclqlivematch";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager dp_sharedManager];
    @weakify(self);
    NSURLSessionDataTask *task = [manager GET:url
        parameters:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
            @strongify(self);
            self.homeTask = nil;
            DPGameLiveType gameLiveType = [[task dp_strongObjectForKey:kTypeKey] integerValue];
            if (gameLiveType != self.gameLiveType) {
                NSAssert(NO, @"failure...");
                return;
            }
            
            BOOL needLocationTab = self.allMatches.count == 0 || self.dataType != gameLiveType;
            
            // 解析数据
            switch (gameLiveType) {
                case DPGameLiveTypeFootball:
                    [self parserFootballHome:responseObject];
                    break;
                case DPGameLiveTypeBasketball:
                    [self parserBasketballHome:responseObject];
                    break;
            }
            
            NSLog(@"gamelive success...");
            
            if ([self.delegate respondsToSelector:@selector(fetchFinished:needLocationTab:)]) {
                [self.delegate fetchFinished:nil needLocationTab:needLocationTab];
            }
            
            // 启动轮询
            [self activateUpdateLoop];
        }
        failure:^(NSURLSessionDataTask *task, NSError *error){
            @strongify(self);
            self.homeTask = nil;
            
            NSLog(@"gamelive failure...");
            
            // 主动取消
            if (error.code == NSURLErrorCancelled) {
                return;
            }
            // 未登录, 清空所有关注数据
            if (![DPMemberManager sharedInstance].isLogin) {
                self.attentionCount = 0;
                [self.attention removeAllObjects];
            }
            if ([self.delegate respondsToSelector:@selector(fetchFinished:needLocationTab:)]) {
                [self.delegate fetchFinished:error needLocationTab:NO];
            }
            
            // 启动轮询
            [self activateUpdateLoop];
        }];
    [task dp_setStrongObject:@(self.gameLiveType) forKey:kTypeKey];
    
    self.homeTask = task;
}

// 图片处理
- (void)setImage:(UIImage *)image forURL:(NSString *)url forMatchModel:(DPGameLiveMatchModel *)matchModel {
    NSAssert(image, @"image should not be nil");
    
    if ([url isEqualToString:matchModel.homeLogoURL]) {
        matchModel.homeLogo = image;
    } else {
        matchModel.awayLogo = image;
    }
}

- (void)requestImage:(NSString *)url forMatchModel:(DPGameLiveMatchModel *)matchModel {
    if (url == nil || matchModel == nil) {
        return;
    }
    // 图片已在本地, 则直接处理
    UIImage *image = [[AFImageDiskCache sharedCache] cachedImageForURL:url];
    if (image) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            UIImage *roundImage = [image dp_roundImageWithDiameter:kDIAMETER];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setImage:roundImage forURL:url forMatchModel:matchModel];
            });
        });
        return;
    }
    
    // 图片不存在, 则从网络请求
    // 首先判断是否已经存在对该图片的请求连接, 如果存在, 进行关联
    for (NSURLSessionDataTask *task in self.imageSessionMgr.dataTasks) {
        if ([task.dp_userInfo isEqualToString:url]) {
            NSMutableSet *models = [self.imageRequestTable objectForKey:task];
            if (![models containsObject:matchModel]) {
                [models addObject:matchModel];
            }
            return;
        }
    }
    
    @weakify(self);
    NSURLSessionDataTask *task = [self.imageSessionMgr GET:url
        parameters:nil
        success:^(NSURLSessionDataTask *task, UIImage *image) {
            @strongify(self);
            
            // 缓存图片
            [[AFImageDiskCache sharedCache] cacheImage:image forURL:url];
            
            // 处理成圆角图片
            UIImage *roundImage = [image dp_roundImageWithDiameter:kDIAMETER];
            [[NSOperationQueue mainQueue] addOperation:[NSBlockOperation blockOperationWithBlock:^{
                NSMutableSet *models = [self.imageRequestTable objectForKey:task];
                for (DPGameLiveMatchModel *matchModel in models) {
                    [self setImage:roundImage forURL:url forMatchModel:matchModel];
                }
                [self.imageRequestTable removeObjectForKey:task];
            }]];
        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
            @strongify(self);
            [[NSOperationQueue mainQueue] addOperation:[NSBlockOperation blockOperationWithBlock:^{
                [self.imageRequestTable removeObjectForKey:task];
            }]];
        }];
    [task dp_setUserInfo:url];
    
    [self.imageRequestTable setObject:[NSMutableSet setWithObject:matchModel] forKey:task];
}

- (void)fetchImageIfNeeded:(DPGameLiveMatchModel *)matchModel {
    if (matchModel.homeLogo == nil) {
        [self requestImage:matchModel.homeLogoURL forMatchModel:matchModel];
    }
    if (matchModel.awayLogo == nil) {
        [self requestImage:matchModel.awayLogoURL forMatchModel:matchModel];
    }
}

// 轮询相关
- (void)activateUpdateLoop {
    if (self.homeTask || self.updateTimer) {
        return;
    }
    self.updateTimer = [MSWeakTimer scheduledTimerWithTimeInterval:15
                                                            target:self
                                                          selector:@selector(fetchUpdate)
                                                          userInfo:nil
                                                           repeats:YES
                                                     dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

- (void)deactivateUpdateLoop {
    if (self.updateTask) {
        [self.updateTask cancel];
        self.updateTask = nil;
    }
    self.updateTimer = nil;
}

- (void)fetchUpdate {
    if (self.updateTask) {
        [self.updateTask cancel];
    }
    NSString *typeKey = @"typeKey";
    NSString *url; NSDictionary *parameters;
    switch (self.gameLiveType) {
        case DPGameLiveTypeFootball:
            parameters = @{ @"gametype" : @(GameTypeJcNone),
                            @"ticks" : self.timeTicks.length ? self.timeTicks : @"0" };
            url = @"/live/zqliveinfo";
            break;
        case DPGameLiveTypeBasketball:
            url = @"/live/lqliveinfo";
            break;
    }
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager dp_sharedManager];
    @weakify(self);
    NSURLSessionDataTask *task = [sessionManager GET:url
        parameters:parameters
        success:^(NSURLSessionDataTask *task, id responseObject) {
            @strongify(self);
            DPGameLiveType type = [[task dp_strongObjectForKey:typeKey] integerValue];
            NSAssert(type == self.gameLiveType, @"failure...");
            NSMutableSet *goalSet = [NSMutableSet set];
            
            BOOL upgrade = NO;
            switch (type) {
                case DPGameLiveTypeFootball:
                    upgrade = [self parserFootballUpdate:responseObject goalSet:goalSet];
                    break;
                case DPGameLiveTypeBasketball:
                    upgrade = [self parserBasketballUpdate:responseObject];
                    break;
            }
            // 通知代理更新数据
            if ([self.delegate respondsToSelector:@selector(updateMatchInfo)] && upgrade) {
                [self.delegate updateMatchInfo];
            }
            // 广播, 进球事件
            if (goalSet.count) {
                NSLog(@"发生进球了...");
                [[NSNotificationCenter defaultCenter] postNotificationName:kDPGameLiveScoreChangeNotifyKey object:nil userInfo:@{kDPGameLiveScoreGoalSetKey : goalSet}];
            }
        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"update error: %@", error);
        }];
    [task dp_setStrongObject:@(self.gameLiveType) forKey:typeKey];
    
    self.updateTask = task;
}

@end
