//
//  DPGSTaskObject.h
//  Jackpot
//
//  Created by mu on 15/7/8.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPPlayKind.h"

typedef NS_ENUM(NSInteger, DPTaskState) {
    DPTaskStateFinished = 3,
    DPTaskStateCanGet = 2,
    DPTaskStateInitilizer = 1,
};

typedef enum{
    DPTaskTypeCommon =0,
    DPTaskTypeUp = 1,
    DPTaskTypeSuperPlay = 2,
}DPTaskType;

@interface DPGSTaskObject : NSObject
/**
 *  taskId
 */
@property (nonatomic, copy) NSString *taskId;
/**
 *  titleLabel
 */
@property (nonatomic, copy) NSString *titleLabelStr;
/**
 *  subTitleLab
 */
@property (nonatomic, copy) NSString *subTitleLabStr;
/**
 *  moneyLab
 */
@property (nonatomic, copy) NSString *moneyLabStr;
/**
 *  iconImg
 */
@property (nonatomic, copy) NSString *iconImageURL;
/**
 *  任务跳转路径
 */
@property (nonatomic, copy) NSString *taskEvent;
/**
 *  任务状态
 */
@property (nonatomic, assign) DPTaskState stata;
/**
 *  任务类型
 */
@property (nonatomic, assign) DPTaskType type;
/**
 *  任务玩法数组
 */
@property (nonatomic, strong) NSMutableArray *kindArray;
@end
