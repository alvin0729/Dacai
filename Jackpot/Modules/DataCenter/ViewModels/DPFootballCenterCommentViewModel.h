//
//  DPFootballCenterCommentViewModel.h
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPDataCenterBaseViewModel.h"

@class PBMFootComment;
 @interface DPFootballCenterCommentViewModel : DPDataCenterBaseViewModel <IDPDataCenterViewModel>

@property(nonatomic,strong)PBMFootComment *message ;
/**
 *  评论id
 */
@property(nonatomic,strong)NSString *commendId ;


@end

 