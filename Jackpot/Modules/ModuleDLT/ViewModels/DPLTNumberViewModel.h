//
//  DPLotteryNumberPlayStyle.h
//  DacaiProject
//
//  Created by WUFAN on 15/1/4.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPLTNumberProtocol.h"

@interface DPLTNumberViewModel : NSObject <DPLTNumberMutualDataSource, DPLTNumberBaseProtocol>{
    NSMutableAttributedString *_attStr;
}
@property (nonatomic, assign) NSInteger lastName;   // 上一期期号
@end

 
@interface DPLTDltModel : DPLTNumberViewModel <DPLTNumberMainDataSource,DPLTNumberMutualDataSource, DPLTNumberTimerDataSource>
@end

 