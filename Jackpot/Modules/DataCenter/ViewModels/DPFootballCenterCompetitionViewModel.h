//
//  DPFootballCenterCompetitionViewModel.h
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPDataCenterBaseViewModel.h"

@class PBMFootEventData ;
@interface DPFootballCenterCompetitionViewModel : DPDataCenterBaseViewModel <IDPDataCenterViewModel>

@property(nonatomic,strong)PBMFootEventData *message ;
@end
