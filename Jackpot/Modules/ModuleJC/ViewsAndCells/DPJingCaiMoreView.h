//
//  DPJingCaiMoreView.h
//  DacaiProject
//
//  Created by sxf on 14-7-16.
//  Copyright (c) 2014年 dacai. All rights reserved.
//  竞彩足球投注更多玩法

#import <UIKit/UIKit.h>

@class PBMJczqMatch;

@interface DPFootBallMore : NSObject

- (instancetype)initWithGameType:(GameTypeId)gameType;

@property (nonatomic, strong) PBMJczqMatch *match;

@property (nonatomic, strong, readonly) UIView *view_spf;      //胜平负
@property (nonatomic, strong, readonly) UIView *view_rqspf;    //让球胜平负
@property (nonatomic, strong, readonly) UIView *view_bf;       //比分
@property (nonatomic, strong, readonly) UIView *view_zjq;      //总进球
@property (nonatomic, strong, readonly) UIView *view_bqc;      //半全场

@property (nonatomic, strong, readonly) UIView *view_signalBqc;    //半全场单独页面

@end

typedef void (^ReloadBlock)(void);
@interface DPFootBallMoreViewController : UIViewController
- (instancetype)initWithGameType:(GameTypeId)gameType match:(PBMJczqMatch *)match;
/**
 *  刷新数据
 */
@property (nonatomic, copy) ReloadBlock reloadBlock;
@end
