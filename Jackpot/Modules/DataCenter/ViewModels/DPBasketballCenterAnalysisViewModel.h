//
//  DPBasketballCenterAnalysisViewModel.h
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPDataCenterBaseViewModel.h"


@class PBMBasketballAnalysis ;
@interface DPBasketballCenterAnalysisViewModel : DPDataCenterBaseViewModel <IDPDataCenterViewModel>
@property(nonatomic,strong)PBMBasketballAnalysis *message ;

@end
