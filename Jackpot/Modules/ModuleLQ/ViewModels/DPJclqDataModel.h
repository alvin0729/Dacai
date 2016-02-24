//
//  DPJclqDataModel.h
//  Jackpot
//
//  Created by Ray on 15/8/7.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "Jclq.pbobjc.h"
#import <Foundation/Foundation.h>

typedef struct JclqOption {
    int betSf[2];
    int betRfsf[2];
    int betDxf[2];
    int betSfc[12];
    // ...
} JclqOption;

typedef struct JclqSelectNum {
    int numSf;
    int numRfsf;
    int numDxf;
    int numSfc;
} JclqSelectNum;

@interface MatchLcOption : NSObject

@property (nonatomic, assign) JclqOption htOption;
@property (nonatomic, assign) JclqOption normalOption;

@property (nonatomic, assign) JclqSelectNum htSelect;
@property (nonatomic, assign) JclqSelectNum normalSelect;

@property (nonatomic, assign) BOOL htDanTuo;      //混投胆拖
@property (nonatomic, assign) BOOL sfDanTuo;      //胜负胆拖
@property (nonatomic, assign) BOOL rfsfDanTuo;    //让分胜负胆拖
@property (nonatomic, assign) BOOL dxfDanTuo;     //大小分胆拖
@property (nonatomic, assign) BOOL sfcDanTuo;     //胜分差胆拖

/**
 *  初始化选中状态
 *
 *  @param type 彩种
 */
- (void)initializeOptionWithType:(GameTypeId)type;
/**
 *  初始化选中数目
 *
 *  @param type 彩种
 */
- (void)initializeSelectNumWithType:(GameTypeId)type;
/**
 *  是否被选中
 *
 *  @param type 彩种
 *
 *  @return 选中状态
 */
- (BOOL)hasSelectedWithType:(GameTypeId)type;
/**
 *  选中状态
 *
 *  @param total  总的按钮数
 *  @param option 选中状态数组
 *
 *  @return 1选中 0未选中
 */
- (NSInteger)getSelectedStatus:(NSInteger)total option:(int[])option;

/**
 *  获取胆拖标记
 *
 *  @param gameType 彩种
 */
- (BOOL)getMarkedStatus:(GameTypeId)gameType;
/**
 *  修改胆拖状态
 *
 *  @param gameType 彩种
 *  @param marked   是否胆拖
 */
- (void)exchangeMarkStatus:(GameTypeId)gameType mark:(BOOL)marked;

@end

@interface PBMJclqMatch (Addation)

@property (nonatomic, strong, readonly) MatchLcOption *matchOption;
@property (nonatomic, assign) int dp_gameId;

/**
 *  是否选择的都是单关玩法
 *
 *  @param type 玩法
 *
 *  @return 是否单关
 */
- (BOOL)isSelectedAllSignalWithType:(GameTypeId)type;

/**
 *  是否被选中
 *
 *  @param type 彩种
 *
 *  @return 是否选中
 */
- (BOOL)isSelectedWithType:(GameTypeId)type;
/**
 *  被选中的彩种
 *
 *  @param type 当前彩种
 *
 *  @return 选中彩种数组
 */
- (NSArray *)getSelectedTypeArrWithType:(GameTypeId)type;

/**
 *  更新选中状态
 *
 *  @param baseGameType 当前页面的彩种
 *  @param gametype     小彩种
 *  @param index        小彩种角标
 *  @param isSelect     是否选中
 *  @param isAllSub     是否是通过弹框的确定按钮提交
 */
- (void)updateSelectStatusWithBaseType:(GameTypeId)baseGameType
                        selectGmaeType:(GameTypeId)gametype
                                 index:(int)index
                                select:(BOOL)isSelect
                              isAllSub:(BOOL)isAllSub;

@end
