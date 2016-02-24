//
//  DPDataCenterBaseViewModel.h
//  Jackpot
//
//  Created by wufan on 15/9/2.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DPDataCenterViewModelDelegate;

@interface DPDataCenterBaseViewModel : NSObject
/**
 *  赛事id
 */
@property (nonatomic, assign, readonly) NSInteger matchId;
/**
 *  是否有数据
 */
@property (nonatomic, assign, readonly) BOOL hasData;
/**
 *  主队名
 */
@property (nonatomic, strong) NSString *homeName;
/**
 *  客队名
 */
@property (nonatomic, strong) NSString *awayName;
@property (nonatomic, weak) id<DPDataCenterViewModelDelegate> delegate;

/**
 *  初始化
 *
 *  @param matchId matchId
 *
 *  @return baseViewModel
 */
- (instancetype)initWithMatchId:(NSInteger)matchId;
/**
 *  请求数据
 */
- (void)fetch;

@end

@protocol DPDataCenterViewModelDelegate <NSObject>
@optional
/**
 *  请求完成
 *
 *  @param error error
 */
- (void)fetchFinished:(NSError *)error;
@end

// 子类实现该接口
@protocol IDPDataCenterViewModel <NSObject>
@required

/**
 *  网络请求地址
 */
@property (nonatomic, strong, readonly) NSString *fetchURL;

/**
 *  解析服务器返回的 protobuf 数据
 *
 *  @param data [in]服务器返回的数据
 */
- (void)parserData:(NSData *)data;


@optional
/**
 *  数据请求字典
 */
@property (nonatomic, strong, readonly) NSDictionary *fetchParameters;

@end