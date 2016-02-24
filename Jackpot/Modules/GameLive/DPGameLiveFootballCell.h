//
//  DPGameLiveFootballCell.h
//  Jackpot
//
//  Created by wufan on 15/8/14.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPGameLiveBaseCell.h"

@interface DPGameLiveFootballUnfoldView : UIView
@property (nonatomic, strong) NSArray *events;
@end

@interface DPGameLiveFootballCell : DPGameLiveBaseCell
@property (nonatomic, strong) DPGameLiveFootballUnfoldView *unfoldView;
+ (CGFloat)unfoldHeightForRowCount:(NSInteger)rowCount;
@end
