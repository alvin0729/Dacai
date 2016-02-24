//
//  BetDescription+Optimize.c
//  AlgorithmToolkit
//
//  Created by WUFAN on 15/12/15.
//  Copyright © 2015年 dacai. All rights reserved.
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
    

static void GetOriginalDescription(Json::Value &jBetDesc, JczqCalculaterOption optionList[], int count, int passModes[], int pmCount, int gameType) {
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
    jBetDesc["IsSingle"] = false;
    jBetDesc["__type"] = "JcDuplex";
}
    
static void GetBetsDescription(Json::Value &jBets, const OptimizeResult &result, int &noteCount) {
    noteCount = 0;
    char temp[20];
    for (int i = 0; i < result.result.size(); i++) {
        Json::Value jMatchs(Json::arrayValue);
        
        if (result.multiple[i] == 0) {
            continue;
        }
        
        for (int j = 0; j < result.result[i].size(); j++) {
            const OptimizeOption &option = result.result[i][j];
            Json::Value jItem;
            jItem["Id"] = option.matchId;
            jItem["GT"] = option.gameType;
            sprintf(temp, "%.2f", option.sp + 0.001);
            jItem["Sp"] = temp;
            switch (option.gameType) {
                case GameTypeJcRqspf:
                    sprintf(temp, "%d", JczqRqspfBetOption[option.index]);
                    break;
                case GameTypeJcSpf:
                    sprintf(temp, "%d", JczqSpfBetOption[option.index]);
                    break;
                case GameTypeJcBf:
                    sprintf(temp, "%02d", JczqBfBetOption[option.index]);
                    break;
                case GameTypeJcBqc:
                    sprintf(temp, "%02d", JczqBqcBetOption[option.index]);
                    break;
                case GameTypeJcZjq:
                    sprintf(temp, "%d", JczqZjqBetOption[option.index]);
                    break;
                default:
                    assert(false);
                    break;
            }
            jItem["OP"] = temp;
            jMatchs.append(jItem);
        }
        
        Json::Value jItem;
        jItem["Matchs"] = jMatchs;
        jItem["Mul"] = result.multiple[i];
        jBets.append(jItem);
        
        noteCount += result.multiple[i];
    }
}
    
string JczqOptimizeDescription(JczqCalculaterOption optionList[], int count, int passModes[], int pmCount, const OptimizeResult &result, int gameType) {
    Json::Value jOriginal;
    Json::Value jBets;
    int noteCount = 0;
    
    GetOriginalDescription(jOriginal, optionList, count, passModes, pmCount, gameType);
    GetBetsDescription(jBets, result, noteCount);
    
    Json::Value jBetDesc;
    jBetDesc["__type"] = "JcOptimize";
    jBetDesc["Original"] = jOriginal;
    jBetDesc["Bets"] = jBets;
    jBetDesc["Count"] = noteCount;
    jBetDesc["IsSingle"] = false;
    jBetDesc["PassModes"] = jOriginal["PassModes"];
    
    return Json::FastWriter().write(jBetDesc);
}

}
