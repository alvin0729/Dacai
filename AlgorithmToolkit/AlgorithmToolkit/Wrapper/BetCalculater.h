//
//  BetCalculater.h
//  DacaiLibrary
//
//  Created by wufan on 15/8/24.
//  Copyright (c) 2015年 dacai. All rights reserved.
//
//  该类用于计算注数, 奖金, 过关方式, 竞技彩投注内容JSON组装
//

#ifndef __DacaiLibrary__BetCalculater__
#define __DacaiLibrary__BetCalculater__

#include <stdio.h>
#include <inttypes.h>
#include <string>
#include <string.h>
#include <vector>

#define kDltRedCount    35
#define kDltBlueCount   12

namespace LotteryCalculater {
    
typedef struct JczqCalculaterOption {
    int betOptionSpf[3];
    int betOptionRqspf[3];
    int betOptionZjq[8];
    int betOptionBqc[9];
    int betOptionBf[31];
    
    double betSpListSpf[3];
    double betSpListRqspf[3];
    double betSpListZjq[8];
    double betSpListBqc[9];
    double betSpListBf[31];
    
    int betRqs;
    int matchId;
    bool mark;
    char orderNumberName[20];
} JczqCalculaterOption;

typedef struct JclqCalculaterOption {
    int betOptionSf[2];
    int betOptionRfsf[2];
    int betOptionDxf[2];
    int betOptionSfc[12];
    
    double betSpListSf[2];
    double betSpListRfsf[2];
    double betSpListDxf[2];
    double betSpListSfc[12];
    
    double betRf;
    double betZf;
    int matchId;
    bool mark;
    char orderNumberName[20];
} JclqCalculaterOption;
    

typedef struct NumberBetOption {
    int betRed[40];
    int betBlue[20];
} DltCalculaterOption;
    
typedef struct OptimizeOption {
    int matchId;
    int gameType;
    int index;
    float sp;
} OptimizeOption;
    
typedef struct OptimizeResult {
    std::vector< std::vector<OptimizeOption> > result;
    std::vector<float> sp;
    std::vector<int> multiple;
} OptimizeResult;

/**
 *  竞彩足球混投玩法计算注数
 *
 *  @param optionList [in]选择比赛的投注选项
 *  @param count      [in]选择的比赛数
 *  @param passModes  [in]过关方式数组
 *  @param pmCount    [in]过关方式数
 *  @param note       [out]注数
 *  @param minBonus   [out]最小奖金
 *  @param maxBonus   [out]最大奖金
 *
 *  @return >=0表示成功
 */
int JczqCalculater(JczqCalculaterOption optionList[], int count, int passModes[], int pmCount, int64_t &note, float &minBonus, float &maxBonus);

/**
 *  竞彩篮球混投玩法计算注数
 *
 *  @param optionList [in]选择比赛的投注选项
 *  @param count      [in]选择的比赛数
 *  @param passModes  [in]过关方式数组
 *  @param pmCount    [in]过关方式数
 *  @param note       [out]注数
 *  @param minBonus   [out]最小奖金
 *  @param maxBonus   [out]最大奖金
 *
 *  @return >=0表示成功
 */
int JclqCalculater(JclqCalculaterOption optionList[], int count, int passModes[], int pmCount, int64_t &note, float &minBonus, float &maxBonus);
    
    
int DltCalculater(int redTuoCount,int redDanCount, int blueTuoCount, int blueDanCount);
/**
 *  大乐透注数计算
 *
 *  @param red  [in]红球选择内容
 *  @param blue [in]蓝球选择内容
 *
 *  @return 计算所得的注数
 */
int DltCalculater(int red[kDltRedCount], int blue[kDltBlueCount]);


/**
 *  足球下单格式组织
 *
 *  @param optionList [in]选择比赛的投注选项
 *  @param count      [in]选择的比赛数
 *  @param passModes  [in]过关方式数组
 *  @param pmCount    [in]过关方式数
 *  @param gameType   [in]彩种
 *
 *  @return
 */
std::string JczqBetDescription(JczqCalculaterOption optionList[], int count, int passModes[], int pmCount, int gameType, int note);
    
    
/**
 *  足球优化投注下单格式组织
 *
 *  @param optionList [in]选择比赛的投注选项
 *  @param count      [in]选择的比赛数
 *  @param passModes  [in]过关方式数组
 *  @param pmCount    [in]过关方式数
 *  @param result     [in]优化投注结果
 *  @param gameType   [in]彩种
 *
 *  @return
 */
std::string JczqOptimizeDescription(JczqCalculaterOption optionList[], int count, int passModes[], int pmCount, const OptimizeResult &result, int gameType);
    
/**
 *  篮球下单格式组织
 *
 *  @param optionList [in]选择比赛的投注选项
 *  @param count      [in]选择的比赛数
 *  @param passModes  [in]过关方式数组
 *  @param pmCount    [in]过关方式数
 *  @param gameType   [in]彩种
 *
 *  @return
 */
std::string JclqBetDescription(JclqCalculaterOption optionList[], int count, int passModes[], int pmCount, int gameType, int note);
    
/**
 *  大乐透下单格式组织
 *
 *  @param optionList [in]投注内容长度
 *  @param count      [in]数组长度
 *  @param addition   [in]是否追加
 *
 *  @return
 */
std::string DltBetDescription(NumberBetOption optionList[], int count, bool addition);
    
/**
 *  大乐透追号下单格式
 *
 *  @param optionList  [in]投注内容长度
 *  @param count       [in]数组长度
 *  @param addition    [in]是否追加
 *  @param multiple    [in]倍数
 *  @param followCount [in]追号期数
 *
 *  @return
 */
std::string DltFollowDescription(NumberBetOption optionList[], int count, bool addition, int multiple, int followCount);
    
OptimizeResult JczqOptimize(JczqCalculaterOption optionList[], int count, int passModes[], int pmCount, int amount);
    
}


#endif /* defined(__DacaiLibrary__BetCalculater__) */
