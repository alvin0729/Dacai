//
//  DPLotteryInfoViewModel.h
//  Jackpot
//
//  Created by wufan on 15/9/22.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsInfo.pbobjc.h"
static const NSInteger kPageSize = 20;

typedef NS_ENUM(NSInteger, DPLotteryInfoType) {
    DPLotteryInfoTypeRecommend,
    DPLotteryInfoTypeAnnouncement,
    DPLotteryInfoTypeSpecify,
};

@protocol DPLotteryInfoViewModelDelegate;

@interface DPLotteryInfoViewModel : NSObject
@property (nonatomic, weak) id<DPLotteryInfoViewModelDelegate> delegate;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign, readonly) BOOL hasMore;
@property (nonatomic, assign, readonly) NSInteger count;
@property (nonatomic, assign) NSInteger currentCount;


- (NSInteger)gameTypeAtIndex:(NSInteger)index;
- (NSString *)titleAtIndex:(NSInteger)index;
- (NSString *)dateTextAtIndex:(NSInteger)index;
- (NSString *)URLAtIndex:(NSInteger)index;
- (PBMShareItem *)shareItemAtIndex:(NSInteger)index;
- (void)fetch;
- (void)fetchMore;

@end

@protocol DPLotteryInfoViewModelDelegate <NSObject>
@optional
- (void)viewModel:(DPLotteryInfoViewModel *)viewModel fetchFinished:(NSError *)error;
@end
