//
//  DPGameLiveBasketballCell.h
//  Jackpot
//
//  Created by wufan on 15/8/14.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPGameLiveBaseCell.h"

#define kDPGameLiveBasketballUnfoldViewHeight   110.0f

@interface DPGameLiveBasketballUnfoldView : UIView
- (void)setExtra:(BOOL)extra;
- (void)setTotalScore:(NSInteger)totalScore;
- (void)setPointDiff:(NSInteger)pointDiff;
- (void)setHomeName:(NSString *)homeName;
- (void)setAwayName:(NSString *)awayName;
- (void)setHomeScore:(NSArray *)homeScore;
- (void)setAwayScore:(NSArray *)awayScore;
@end

@interface DPGameLiveBasketballCell : DPGameLiveBaseCell
@property (nonatomic, strong) DPGameLiveBasketballUnfoldView *unfoldView;
@end
