//
//  DPFootballCenterOddsHandicapViewModel.h
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPDataCenterBaseViewModel.h"

@class PBMFootOddsHandicap ;
@interface DPFootballCenterOddsHandicapViewModel : DPDataCenterBaseViewModel <IDPDataCenterViewModel>

@property(nonatomic,strong)PBMFootOddsHandicap *message ;

@end
