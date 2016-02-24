//
//  DPFootballCenterAnalysisViewModel.h
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPDataCenterBaseViewModel.h"

@class PBMFootAnalysis;
@interface DPFootballCenterAnalysisViewModel : DPDataCenterBaseViewModel <IDPDataCenterViewModel>
@property (nonatomic, strong) PBMFootAnalysis *message;
@end



//@class PBMFootAnalysisDetail ;
//@interface DPFootballCenterAnalysisDetailModel : DPDataCenterBaseViewModel <IDPDataCenterViewModel>
//@property (nonatomic, strong) PBMFootAnalysisDetail *message;
//@end