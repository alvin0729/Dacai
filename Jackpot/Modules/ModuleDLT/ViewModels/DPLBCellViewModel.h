//
//  DPLBCellViewModel.h
//  DacaiProject
//
//  Created by jacknathan on 15-1-21.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  单元格数据模型

#import <Foundation/Foundation.h>
#import "DPLBNumberProtocol.h"

//走势图
@interface DPLBTrendCellViewModel : NSObject <DPLBTrendCellDataProtocol>

@end

 

//投注内容
@interface DPLBDigitalCellViewModel : NSObject <DPLBDigitalCellDataProtocol>

@end

 