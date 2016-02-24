//
//  DPDataCenterViewController.h
//  Jackpot
//
//  Created by wufan on 15/9/2.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  关注
 *
 *  @param action 是否关注
 */
typedef void(^ActionBlock)(BOOL action);
@interface DPDataCenterViewController : UIViewController
/**
 *  比赛id
 */
@property (nonatomic, assign) NSInteger matchId;
/**
 *  比赛类型
 */
@property (nonatomic, assign) GameTypeId gameType;
/**
 *  导航栏标题
 */
@property (nonatomic, strong) NSString *titleString ;
/**
 *  默认选中的tab
 */
@property (nonatomic, assign) NSInteger selectedIndex;
@property(nonatomic,copy)ActionBlock actionBlock ;
/**
 *  主队名
 */
@property (nonatomic, strong) NSAttributedString *homeTeamName;
/**
 *  客队名
 */
@property (nonatomic, strong) NSAttributedString *awayTeamName;




@end
