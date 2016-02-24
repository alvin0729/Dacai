//
//  DPJcdgDataModel.h
//  DacaiProject
//
//  Created by jacknathan on 15-1-16.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  竞彩单关数据模型

#import <Foundation/Foundation.h>
#import "DPJcdgProtocols.h"

@protocol DPJcdgDataModelDelegate <NSObject>
- (void)handleNotify:(int)cmdId result:(int)ret type:(int)cmdtype;
@end

@interface DPJcdgDataModel : NSObject <DPJcdgDataSoure, DPJcdgMutualDelegate>
@property (nonatomic, weak) id <DPJcdgDataModelDelegate> delegate;
@property(nonatomic,assign)    MyGameType myGameType ;

- (instancetype)initWithMyGameType:(MyGameType)type ;


@end

@interface DPJcdgPerTeamModel : NSObject <DPJcdgPerTeamData>
@end

@interface DPJcdgSpfCellModel : NSObject <DPJcdgSpfCellData>
@end


@interface DPJcdgZjqCellModel : NSObject <DPJcdgZjqCellData>
@end

@interface DPJcdgGuessCellModel : NSObject <DPJcdgGuessCellData>
@end

 

@interface DPJcdgBasketCellModel : NSObject<DPJcdgBasketDataModel>

@end
