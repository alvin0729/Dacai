//
//  BetDescription.cpp
//  DacaiLibrary
//
//  Created by wufan on 15/9/10.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#include "BetCalculater.h"
#include "json.h"
#include "PassModeDefine.h"
#include "GameTypeDefine.h"
#include <assert.h>
//#include "CommonMacro.h"
#include "BaseMath.h"

namespace LotteryCalculater {

static int JczqRqspfBetOption[3] = {
    3, 1, 0
};
static int JczqBfBetOption[31] = {
    10, 20, 21, 30, 31, 32, 40, 41, 42, 50, 51, 52, 90,
    00, 11, 22, 33, 99,
    01, 02, 12, 03, 13, 23, 04, 14, 24, 05, 15, 25,  9,
};
static int JczqZjqBetOption[8] = {
    0, 1, 2, 3, 4, 5, 6, 7
};
static int JczqBqcBetOption[9] = {
    33, 31, 30, 13, 11, 10, 03, 01, 00
};
static int JczqSpfBetOption[3] = {
    3, 1, 0
};
    
std::string JczqBetDescription(JczqCalculaterOption optionList[], int count, int passModes[], int pmCount, int gameType, int note) {
    Json::Value jBetDesc;
    Json::Value jGgType(Json::arrayValue);
    Json::Value jMatchs(Json::arrayValue);
    Json::Value jGalls(Json::arrayValue);
    
    char temp[20];
    char orderNumberTemp[300] = ",";
    char ggTypeTemp[300];
    char passTypeTemp[300];
    int orderNumberLen = 1;
    int ggTypeLen = 0;
    int passTypeLen = 0;
    int gallCount = 0;
    
    for (int i = 0; i < pmCount; i++) {
        int prefix = GetPassModeNamePrefix(passModes[i]);
        int suffix = GetPassModeNameSuffix(passModes[i]);
        
        sprintf(temp, "%d-%d", prefix, suffix);
        
        jGgType.append(temp);
        ggTypeLen += sprintf(ggTypeTemp + ggTypeLen, "%d-%d,", prefix, suffix);
        passTypeLen += sprintf(passTypeTemp + passTypeLen, "%d串%d,", prefix, suffix);
    }
    ggTypeTemp[ggTypeLen - 1] = '\0';
    passTypeTemp[passTypeLen - 1] = '\0';
    
    for (int i = 0; i < count; i++) {
        JczqCalculaterOption &betOption = optionList[i];
        Json::Value jGames(Json::arrayValue);
        
        switch (gameType) {
            case GameTypeJcHt: {
                if (!CMathHelper::IsZero(betOption.betOptionSpf, sizeof(betOption.betOptionSpf))) {
                    Json::Value jOptions(Json::arrayValue);
                    Json::Value jSps(Json::arrayValue);
                    for (int i = 0; i < 3; i++) {
                        if (betOption.betOptionSpf[i]) {
                            sprintf(temp, "%d", JczqSpfBetOption[i]);
                            jOptions.append(temp);
                            sprintf(temp, "%.2f", betOption.betSpListSpf[i] + 0.001);
                            jSps.append(temp);
                        }
                    }
                    Json::Value jItem;
                    jItem["Type"] = GameTypeJcSpf;
                    jItem["Sps"] = jSps;
                    jItem["Options"] = jOptions;
                    jGames.append(jItem);
                }
                if (!CMathHelper::IsZero(betOption.betOptionRqspf, sizeof(betOption.betOptionRqspf))) {
                    Json::Value jOptions(Json::arrayValue);
                    Json::Value jSps(Json::arrayValue);
                    for (int i = 0; i < 3; i++) {
                        if (betOption.betOptionRqspf[i]) {
                            sprintf(temp, "%d", JczqRqspfBetOption[i]);
                            jOptions.append(temp);
                            sprintf(temp, "%.2f", betOption.betSpListRqspf[i] + 0.001);
                            jSps.append(temp);
                        }
                    }
                    Json::Value jItem;
                    jItem["Type"] = GameTypeJcRqspf;
                    jItem["Sps"] = jSps;
                    jItem["Options"] = jOptions;
                    jItem["Coefficient"] = betOption.betRqs;
                    jGames.append(jItem);
                }
                if (!CMathHelper::IsZero(betOption.betOptionBf, sizeof(betOption.betOptionBf))) {
                    Json::Value jOptions(Json::arrayValue);
                    Json::Value jSps(Json::arrayValue);
                    for (int i = 0; i < 31; i++) {
                        if (betOption.betOptionBf[i]) {
                            sprintf(temp, "%02d", JczqBfBetOption[i]);
                            jOptions.append(temp);
                            sprintf(temp, "%.2f", betOption.betSpListBf[i] + 0.001);
                            jSps.append(temp);
                        }
                    }
                    Json::Value jItem;
                    jItem["Type"] = GameTypeJcBf;
                    jItem["Sps"] = jSps;
                    jItem["Options"] = jOptions;
                    jGames.append(jItem);
                }
                if (!CMathHelper::IsZero(betOption.betOptionZjq, sizeof(betOption.betOptionZjq))) {
                    Json::Value jOptions(Json::arrayValue);
                    Json::Value jSps(Json::arrayValue);
                    for (int i = 0; i < 8; i++) {
                        if (betOption.betOptionZjq[i]) {
                            sprintf(temp, "%d", JczqZjqBetOption[i]);
                            jOptions.append(temp);
                            sprintf(temp, "%.2f", betOption.betSpListZjq[i]+ 0.001);
                            jSps.append(temp);
                        }
                    }
                    Json::Value jItem;
                    jItem["Type"] = GameTypeJcZjq;
                    jItem["Sps"] = jSps;
                    jItem["Options"] = jOptions;
                    jGames.append(jItem);
                }
                if (!CMathHelper::IsZero(betOption.betOptionBqc, sizeof(betOption.betOptionBqc))) {
                    Json::Value jOptions(Json::arrayValue);
                    Json::Value jSps(Json::arrayValue);
                    for (int i = 0; i < 9; i++) {
                        if (betOption.betOptionBqc[i]) {
                            sprintf(temp, "%02d", JczqBqcBetOption[i]);
                            jOptions.append(temp);
                            sprintf(temp, "%.2f", betOption.betSpListBqc[i] + 0.001);
                            jSps.append(temp);
                        }
                    }
                    Json::Value jItem;
                    jItem["Type"] = GameTypeJcBqc;
                    jItem["Sps"] = jSps;
                    jItem["Options"] = jOptions;
                    jGames.append(jItem);
                }
            } break;
            case GameTypeJcRqspf: {
                Json::Value jOptions(Json::arrayValue);
                Json::Value jSps(Json::arrayValue);
                for (int i = 0; i < 3; i++) {
                    if (betOption.betOptionRqspf[i]) {
                        sprintf(temp, "%d", JczqRqspfBetOption[i]);
                        jOptions.append(temp);
                        sprintf(temp, "%.2f", betOption.betSpListRqspf[i] + 0.001);
                        jSps.append(temp);
                    }
                }
                Json::Value jItem;
                jItem["Type"] = GameTypeJcRqspf;
                jItem["Sps"] = jSps;
                jItem["Options"] = jOptions;
                jItem["Coefficient"] = betOption.betRqs;
                jGames.append(jItem);
            } break;
            case GameTypeJcBf: {
                Json::Value jOptions(Json::arrayValue);
                Json::Value jSps(Json::arrayValue);
                for (int i = 0; i < 31; i++) {
                    if (betOption.betOptionBf[i]) {
                        sprintf(temp, "%02d", JczqBfBetOption[i]);
                        jOptions.append(temp);
                        sprintf(temp, "%.2f", betOption.betSpListBf[i] + 0.001);
                        jSps.append(temp);
                    }
                }
                Json::Value jItem;
                jItem["Type"] = GameTypeJcBf;
                jItem["Sps"] = jSps;
                jItem["Options"] = jOptions;
                jGames.append(jItem);
            } break;
            case GameTypeJcZjq: {
                Json::Value jOptions(Json::arrayValue);
                Json::Value jSps(Json::arrayValue);
                for (int i = 0; i < 8; i++) {
                    if (betOption.betOptionZjq[i]) {
                        sprintf(temp, "%d", JczqZjqBetOption[i]);
                        jOptions.append(temp);
                        sprintf(temp, "%.2f", betOption.betSpListZjq[i]+ 0.001);
                        jSps.append(temp);
                    }
                }
                Json::Value jItem;
                jItem["Type"] = GameTypeJcZjq;
                jItem["Sps"] = jSps;
                jItem["Options"] = jOptions;
                jGames.append(jItem);
            } break;
            case GameTypeJcBqc: {
                Json::Value jOptions(Json::arrayValue);
                Json::Value jSps(Json::arrayValue);
                for (int i = 0; i < 9; i++) {
                    if (betOption.betOptionBqc[i]) {
                        sprintf(temp, "%02d", JczqBqcBetOption[i]);
                        jOptions.append(temp);
                        sprintf(temp, "%.2f", betOption.betSpListBqc[i] + 0.001);
                        jSps.append(temp);
                    }
                }
                Json::Value jItem;
                jItem["Type"] = GameTypeJcBqc;
                jItem["Sps"] = jSps;
                jItem["Options"] = jOptions;
                jGames.append(jItem);
            } break;
            case GameTypeJcSpf: {
                Json::Value jOptions(Json::arrayValue);
                Json::Value jSps(Json::arrayValue);
                for (int i = 0; i < 3; i++) {
                    if (betOption.betOptionSpf[i]) {
                        sprintf(temp, "%d", JczqSpfBetOption[i]);
                        jOptions.append(temp);
                        sprintf(temp, "%.2f", betOption.betSpListSpf[i] + 0.001);
                        jSps.append(temp);
                    }
                }
                Json::Value jItem;
                jItem["Type"] = GameTypeJcSpf;
                jItem["Sps"] = jSps;
                jItem["Options"] = jOptions;
                jGames.append(jItem);
            } break;
            default:
                break;
        }
        
        assert(jGames.size());
        
        Json::Value jItem;
        jItem["Games"] = jGames;
        jItem["IsGall"] = betOption.mark;
        jItem["Id"] = betOption.matchId;
        jItem["No"] = betOption.orderNumberName;
        
        jMatchs.append(jItem);
        
        gallCount += betOption.mark ? 1 : 0;
        orderNumberLen += sprintf(orderNumberTemp + orderNumberLen, "%d,", betOption.matchId);
    }
    if (gallCount) {
        jGalls.append(gallCount);
    }
    
    jBetDesc["PassModes"] = jGgType;
    jBetDesc["Matchs"] = jMatchs;
    jBetDesc["Galls"] = jGalls;
    jBetDesc["IsSingle"] = note == 1;
    jBetDesc["__type"] = "JcDuplex";
    
    return Json::FastWriter().write(jBetDesc);
}
    
std::string JclqBetDescription(JclqCalculaterOption optionList[], int count, int passModes[], int pmCount, int gameType, int note) {
    // 生成json流
    Json::Value jBetDesc;
    Json::Value jGgType(Json::arrayValue);
    Json::Value jMatchs(Json::arrayValue);
    Json::Value jGalls(Json::arrayValue);
    
    char temp[20];
    char orderNumberTemp[300] = ",";
    char ggTypeTemp[300];
    char passTypeTemp[300];
    int orderNumberLen = 1;
    int ggTypeLen = 0;
    int passTypeLen = 0;
    int gallCount = 0;
    
    for (int i = 0; i < pmCount; i++) {
        int prefix = GetPassModeNamePrefix(passModes[i]);
        int suffix = GetPassModeNameSuffix(passModes[i]);
        
        sprintf(temp, "%d-%d", prefix, suffix);
        jGgType.append(temp);
        
        ggTypeLen += sprintf(ggTypeTemp + ggTypeLen, "%d-%d,", prefix, suffix);
        passTypeLen += sprintf(passTypeTemp + passTypeLen, "%d串%d,", prefix, suffix);
    }
    ggTypeTemp[ggTypeLen - 1] = '\0';
    passTypeTemp[passTypeLen - 1] = '\0';
    
    static int LcSfBetOption[] = { 0, 3 };
    static int LcRfsfBetOption[] = { 0, 3 };
    static int LcSfcBetOption[] = { 11, 12, 13, 14, 15, 16, 1, 2, 3, 4, 5, 6, };
    static int LcDxfBetOption[] = { 3, 0 };
    
    for (int i = 0; i < count; i++) {
        JclqCalculaterOption &betOption = optionList[i];
        Json::Value jGames(Json::arrayValue);
        switch (gameType) {
            case GameTypeLcHt: {
                if (!CMathHelper::IsZero(betOption.betOptionRfsf, sizeof(betOption.betOptionRfsf))) {
                    Json::Value jSps(Json::arrayValue);
                    Json::Value jOptions(Json::arrayValue);
                    for (int i = 0; i < 2; i++) {
                        if (betOption.betOptionRfsf[i]) {
                            sprintf(temp, "%d", LcRfsfBetOption[i]);
                            jOptions.append(temp);
                            sprintf(temp, "%.2f", betOption.betSpListRfsf[i] + 0.001);
                            jSps.append(temp);
                        }
                    }
                    Json::Value jItem;
                    jItem["Type"] = GameTypeLcRfsf;
                    jItem["Sps"] = jSps;
                    jItem["Options"] = jOptions;
                    jItem["Coefficient"] = betOption.betRf;
                    jGames.append(jItem);
                }
                if (!CMathHelper::IsZero(betOption.betOptionDxf, sizeof(betOption.betOptionDxf))) {
                    Json::Value jSps(Json::arrayValue);
                    Json::Value jOptions(Json::arrayValue);
                    for (int i = 0; i < 2; i++) {
                        if (betOption.betOptionDxf[i]) {
                            sprintf(temp, "%d", LcDxfBetOption[i]);
                            jOptions.append(temp);
                            sprintf(temp, "%.2f", betOption.betSpListDxf[i] + 0.001);
                            jSps.append(temp);
                        }
                    }
                    Json::Value jItem;
                    jItem["Type"] = GameTypeLcDxf;
                    jItem["Sps"] = jSps;
                    jItem["Options"] = jOptions;
                    jItem["Coefficient"] = betOption.betZf;
                    jGames.append(jItem);
                }
                if (!CMathHelper::IsZero(betOption.betOptionSf, sizeof(betOption.betOptionSf))) {
                    Json::Value jSps(Json::arrayValue);
                    Json::Value jOptions(Json::arrayValue);
                    for (int i = 0; i < 2; i++) {
                        if (betOption.betOptionSf[i]) {
                            sprintf(temp, "%d", LcSfBetOption[i]);
                            jOptions.append(temp);
                            sprintf(temp, "%.2f", betOption.betSpListSf[i] + 0.001);
                            jSps.append(temp);
                        }
                    }
                    Json::Value jItem;
                    jItem["Type"] = GameTypeLcSf;
                    jItem["Sps"] = jSps;
                    jItem["Options"] = jOptions;
                    jGames.append(jItem);
                }
                if (!CMathHelper::IsZero(betOption.betOptionSfc, sizeof(betOption.betOptionSfc))) {
                    Json::Value jSps(Json::arrayValue);
                    Json::Value jOptions(Json::arrayValue);
                    for (int i = 0; i < 12; i++) {
                        if (betOption.betOptionSfc[i]) {
                            sprintf(temp, "%02d", LcSfcBetOption[i]);
                            jOptions.append(temp);
                            sprintf(temp, "%.2f", betOption.betSpListSfc[i] + 0.001);
                            jSps.append(temp);
                        }
                    }
                    Json::Value jItem;
                    jItem["Type"] = GameTypeLcSfc;
                    jItem["Sps"] = jSps;
                    jItem["Options"] = jOptions;
                    jGames.append(jItem);
                }
            } break;
            case GameTypeLcSf: {
                Json::Value jSps(Json::arrayValue);
                Json::Value jOptions(Json::arrayValue);
                for (int i = 0; i < 2; i++) {
                    if (betOption.betOptionSf[i]) {
                        sprintf(temp, "%d", LcSfBetOption[i]);
                        jOptions.append(temp);
                        sprintf(temp, "%.2f", betOption.betSpListSf[i] + 0.001);
                        jSps.append(temp);
                    }
                }
                Json::Value jItem;
                jItem["Type"] = GameTypeLcSf;
                jItem["Sps"] = jSps;
                jItem["Options"] = jOptions;
                jGames.append(jItem);
            } break;
            case GameTypeLcRfsf: {
                Json::Value jSps(Json::arrayValue);
                Json::Value jOptions(Json::arrayValue);
                for (int i = 0; i < 2; i++) {
                    if (betOption.betOptionRfsf[i]) {
                        sprintf(temp, "%d", LcRfsfBetOption[i]);
                        jOptions.append(temp);
                        sprintf(temp, "%.2f", betOption.betSpListRfsf[i] + 0.001);
                        jSps.append(temp);
                    }
                }
                Json::Value jItem;
                jItem["Type"] = GameTypeLcRfsf;
                jItem["Sps"] = jSps;
                jItem["Options"] = jOptions;
                jItem["Coefficient"] = betOption.betRf;
                jGames.append(jItem);
            } break;
            case GameTypeLcSfc: {
                Json::Value jSps(Json::arrayValue);
                Json::Value jOptions(Json::arrayValue);
                for (int i = 0; i < 12; i++) {
                    if (betOption.betOptionSfc[i]) {
                        sprintf(temp, "%02d", LcSfcBetOption[i]);
                        jOptions.append(temp);
                        sprintf(temp, "%.2f", betOption.betSpListSfc[i] + 0.001);
                        jSps.append(temp);
                    }
                }
                Json::Value jItem;
                jItem["Type"] = GameTypeLcSfc;
                jItem["Sps"] = jSps;
                jItem["Options"] = jOptions;
                jGames.append(jItem);
            } break;
            case GameTypeLcDxf: {
                Json::Value jSps(Json::arrayValue);
                Json::Value jOptions(Json::arrayValue);
                for (int i = 0; i < 2; i++) {
                    if (betOption.betOptionDxf[i]) {
                        sprintf(temp, "%d", LcDxfBetOption[i]);
                        jOptions.append(temp);
                        sprintf(temp, "%.2f", betOption.betSpListDxf[i] + 0.001);
                        jSps.append(temp);
                    }
                }
                Json::Value jItem;
                jItem["Type"] = GameTypeLcDxf;
                jItem["Sps"] = jSps;
                jItem["Options"] = jOptions;
                jItem["Coefficient"] = betOption.betZf;
                jGames.append(jItem);
            } break;
            default:
                break;
        }
        
        Json::Value jItem;
        jItem["Games"] = jGames;
        jItem["IsGall"] = betOption.mark;
        jItem["Id"] = betOption.matchId;
        jItem["No"] = betOption.orderNumberName;
        
        jMatchs.append(jItem);
        
        gallCount += betOption.mark ? 1 : 0;
        orderNumberLen += sprintf(orderNumberTemp + orderNumberLen, "%d,", betOption.matchId);
    }
    
    if (gallCount) {
        jGalls.append(gallCount);
    }
    
    jBetDesc["PassModes"] = jGgType;
    jBetDesc["Matchs"] = jMatchs;
    jBetDesc["Galls"] = jGalls;
    jBetDesc["IsSingle"] = note == 1;
    jBetDesc["__type"] = "JcDuplex";
    
    return Json::FastWriter().write(jBetDesc);
}
    
const static int DltBetTypeSingle = 0x1;
const static int DltBetTypeDuplex = 0x2;
const static int DltBetTypeGall = 0x4;
    
void DltDescription(Json::Value &betRoot, int &betTypeOption, NumberBetOption optionList[], int count, bool addition) {
    int singleIndex[100] = { - 1};
    int singleCount = 0;
    
    betTypeOption = 0;
    for (int i = 0; i < count; i++) {
        NumberBetOption &betOption = optionList[i];
        
        Json::Value value;
        
        int redTuo[kDltRedCount] = { 0 };
        int redDan[kDltRedCount] = { 0 };
        int blueTuo[kDltBlueCount] = { 0 };
        int blueDan[kDltBlueCount] = { 0 };
        
        int redTuoLen = 0;
        int redDanLen = 0;
        int blueTuoLen = 0;
        int blueDanLen = 0;
        
        int note = DltCalculater(betOption.betRed, betOption.betBlue);
        
        for (int i = 0; i < kDltRedCount; i++) {
            if (betOption.betRed[i] == 1) {
                redTuo[redTuoLen++] = i + 1;
            } else if (betOption.betRed[i] == -1) {
                redDan[redDanLen++] = i + 1;
            }
        }
        for (int i = 0; i < kDltBlueCount; i++) {
            if (betOption.betBlue[i] == 1) {
                blueTuo[blueTuoLen++] = i + 1;
            } else if (betOption.betBlue[i] == -1) {
                blueDan[blueDanLen++] = i + 1;
            }
        }
        
        if (redDanLen || blueDanLen) {
            // 胆拖投注
            Json::Value redTuoValue(Json::arrayValue);
            Json::Value redDanValue(Json::arrayValue);
            Json::Value blueTuoValue(Json::arrayValue);
            Json::Value blueDanValue(Json::arrayValue);
            
            for (int i = 0; i < redTuoLen; i++) {
                char temp[8] = {0};
                sprintf(temp, "%02d", redTuo[i]);
                redTuoValue.append(temp);
            }
            for (int i = 0; i < redDanLen; i++) {
                char temp[8] = {0};
                sprintf(temp, "%02d", redDan[i]);
                redDanValue.append(temp);
            }
            for (int i = 0; i < blueTuoLen; i++) {
                char temp[8] = {0};
                sprintf(temp, "%02d", blueTuo[i]);
                blueTuoValue.append(temp);
            }
            for (int i = 0; i < blueDanLen; i++) {
                char temp[8] = {0};
                sprintf(temp, "%02d", blueDan[i]);
                blueDanValue.append(temp);
            }
            
            value["__type"] = "DltGallDrag";
            value["IsSingle"] = false;
            value["PropAreaDrags"] = redTuoValue;
            value["PropAreaGalls"] = redDanValue;
            value["BackAreaDrags"] = blueTuoValue;
            value["BackAreaGalls"] = blueDanValue;
            
            betTypeOption |= DltBetTypeGall;
        } else if (note == 1) {
            betTypeOption |= DltBetTypeSingle;
            singleIndex[singleCount++] = i;
            continue;
        } else {
            // 复式投注
            value["__type"] = "DltDuplex";
            value["IsSingle"] = false;
            
            Json::Value redValue(Json::arrayValue);
            Json::Value blueValue(Json::arrayValue);
            
            for (int i = 0; i < redTuoLen; i++) {
                char temp[8] = {0};
                sprintf(temp, "%02d", redTuo[i]);
                redValue.append(temp);
            }
            for (int i = 0; i < blueTuoLen; i++) {
                char temp[8] = {0};
                sprintf(temp, "%02d", blueTuo[i]);
                blueValue.append(temp);
            }
            value["PropAreaNums"] = redValue;
            value["BackAreaNums"] = blueValue;
            
            betTypeOption |= DltBetTypeDuplex;
        }
        
        value["IsAdd"] = addition;
        betRoot.append(value);
    }
    
    // 单式投注
    for (int i = 0; i < singleCount / 5 + ((singleCount % 5) ? 1 : 0); i++) {
        Json::Value value;
        
        for (int j = i * 5; j < (i * 5 + 5) && j < singleCount; j++) {
            NumberBetOption &betOption = optionList[singleIndex[j]];
            
            int redTuo[kDltRedCount] = { 0 };
            int redDan[kDltRedCount] = { 0 };
            int blueTuo[kDltBlueCount] = { 0 };
            int blueDan[kDltBlueCount] = { 0 };
            
            int redTuoLen = 0;
            int redDanLen = 0;
            int blueTuoLen = 0;
            int blueDanLen = 0;
            
            for (int i = 0; i < kDltRedCount; i++) {
                if (betOption.betRed[i] == 1) {
                    redTuo[redTuoLen++] = i + 1;
                } else if (betOption.betRed[i] == -1) {
                    redDan[redDanLen++] = i + 1;
                }
            }
            for (int i = 0; i < kDltBlueCount; i++) {
                if (betOption.betBlue[i] == 1) {
                    blueTuo[blueTuoLen++] = i + 1;
                } else if (betOption.betBlue[i] == -1) {
                    blueDan[blueDanLen++] = i + 1;
                }
            }
            
            // 单式投注
            char temp[32] = {0};
            sprintf(temp, "%02d,%02d,%02d,%02d,%02d|%02d,%02d", redTuo[0], redTuo[1], redTuo[2], redTuo[3], redTuo[4], blueTuo[0], blueTuo[1]);
            
            value["Bets"].append(temp);
        }
        value["__type"] = "DltSingle";
        value["IsSingle"] = true;
        value["IsAdd"] = addition;
        betRoot.append(value);
    }
}
    
std::string DltBetDescription(NumberBetOption optionList[], int count, bool addition) {
    Json::Value betRoot(Json::arrayValue);
    int betTypeOption = 0;
    DltDescription(betRoot, betTypeOption, optionList, count, addition);
    return Json::FastWriter().write(betRoot);
}
    
std::string DltFollowDescription(NumberBetOption optionList[], int count, bool addition, int multiple, int followCount) {
    Json::Value multiples(Json::arrayValue);
    for (int i = 0; i < followCount; i++) {
        multiples.append(multiple);
    }
    
    Json::Value betRoot(Json::arrayValue);
    int betTypeOption = 0;
    DltDescription(betRoot, betTypeOption, optionList, count, addition);
    
    std::string betTypeName;
    if (betTypeOption & DltBetTypeSingle) {
        betTypeName.append("单式, ");
    }
    if (betTypeOption & DltBetTypeDuplex) {
        betTypeName.append("复式, ");
    }
    if (betTypeOption & DltBetTypeGall) {
        betTypeName.append("胆拖, ");
    }
    betTypeName.erase(betTypeName.begin() + betTypeName.size() - 2, betTypeName.end());
    
    Json::Value value;
    value["__type"] = "Fixed";
    value["BetDescriptors"] = Json::FastWriter().write(betRoot);
    value["Multiples"] = multiples;
    value["BetTypeId"] = betTypeOption;
    value["ProjectBetTypeName"] = betTypeName;
    
    return Json::FastWriter().write(value);
}
    
}

