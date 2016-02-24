//
//  DPFootballCenterAnalysisController.h
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPDataCenterTableController.h"

@interface DPFootballCenterAnalysisController : DPDataCenterTableController

@end

/**
 *  分析详情
 */
@interface DPFootballAnalysisDetailController : UITableViewController
/**
 *  赛事id
 */
@property (nonatomic, assign) NSInteger matchId;
/**
 *  主队名
 */
@property (nonatomic, strong) NSString *homeName;
/**
 *  客队名
 */
@property (nonatomic, strong) NSString *awayName;
@end