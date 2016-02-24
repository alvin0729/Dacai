//
//  DPBasketballCenterCommentViewModel.h
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPDataCenterBaseViewModel.h"


@class PBMBasketballComment ;
@interface DPBasketballCenterCommentViewModel : DPDataCenterBaseViewModel <IDPDataCenterViewModel>

@property(nonatomic,strong)PBMBasketballComment *message ;
/**
 *   评论id
 */
@property(nonatomic,strong)NSString *commendId ;

@end
