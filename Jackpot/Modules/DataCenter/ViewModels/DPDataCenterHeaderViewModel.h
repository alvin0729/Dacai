//
//  DPDataCenterHeaderViewModel.h
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPDataCenterHeaderViewModel : NSObject
@property (nonatomic, assign) NSInteger matchId;

// KVO Property
@property (nonatomic, strong) UIImage *homeIconImage;
@property (nonatomic, strong) UIImage *awayIconImage;
@property (nonatomic, strong) NSString *timeText;
@property (nonatomic, strong) NSAttributedString *scoreText;
@property (nonatomic, strong) NSAttributedString *statusText;
@property (nonatomic, strong) NSAttributedString *homeText;
@property (nonatomic, strong) NSAttributedString *awayText;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, assign) BOOL action;


@end

@interface DPFootballCenterHeaderViewModel : DPDataCenterHeaderViewModel
@property (nonatomic, assign) int32_t homeScore;
@property (nonatomic, assign) int32_t awayScore;
@property (nonatomic, assign) int32_t homeHalfScore;
@property (nonatomic, assign) int32_t awayHalfScore;
//@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *halfTime;
@property (nonatomic, strong) NSString *homeIconURL;
@property (nonatomic, strong) NSString *awayIconURL;
@property (nonatomic, assign) NSInteger matchStatus;
@property (nonatomic, strong) NSString *homeName;
@property (nonatomic, strong) NSString *awayName;
@property (nonatomic, strong) NSString *homeRank;
@property (nonatomic, strong) NSString *awayRank;
@end

@interface DPBasketballCenterHeaderViewModel : DPDataCenterHeaderViewModel
@property (nonatomic, assign) int32_t homeScore;
@property (nonatomic, assign) int32_t awayScore;
//@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *homeIconURL;
@property (nonatomic, strong) NSString *awayIconURL;
@property (nonatomic, assign) NSInteger matchStatus;
@property (nonatomic, strong) NSString *homeName;
@property (nonatomic, strong) NSString *awayName;
@property (nonatomic, strong) NSString *homeRank;
@property (nonatomic, strong) NSString *awayRank;
@property (nonatomic, strong) NSString* onTime;
@end