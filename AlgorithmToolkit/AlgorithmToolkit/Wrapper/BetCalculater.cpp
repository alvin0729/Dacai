//
//  BetCalculater.cpp
//  DacaiLibrary
//
//  Created by wufan on 15/8/24.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#include <vector>
#include <math.h>
#include <float.h>
#include <assert.h>
#include "BetCalculater.h"
#include "MLAnalyser.h"
#include "MLFTAnalyser.h"
#include "MLBKAnalyser.h"
#include "MLCalculater.h"
#include "PassModeDefine.h"
#include "BaseMath.h"

using namespace std;

namespace LotteryCalculater {
    
int JczqCalculater(JczqCalculaterOption optionList[], int count, int passModes[], int pmCount, int64_t &note, float &minBonus, float &maxBonus) {
    if (count == 0 || pmCount == 0) {
        note = 0;
        minBonus = 0;
        maxBonus = 0;
        return 0;
    }
    // 记录创建的对象, 在最后进行释放
    vector<Array<Array<int> *> *> total_int_2d;
    vector<Array<Array<double> *> *> total_double_2d;
    vector<Array<int> *> total_int_1d;
    vector<Array<double> *> total_double_1d;
    
    // 过关方式
    Array<PassMode *> passMode(pmCount);
    for (int i = 0; i < pmCount; i++) {
        *passMode[i] = new PassMode(GetPassModeNamePrefix(passModes[i]), GetPassModeNameSuffix(passModes[i]));
    }
    
    // 投注选项
    Array<MLAnalyser *> analyserArray(count);
    int markIndex[8] = { 0 }; int markCount = 0;
    for (int i = 0; i < count; i++) {
        JczqCalculaterOption &betOption = optionList[i];
        double betSpListRqspf[3], betSpListBf[31], betSpListZjq[8], betSpListBqc[9], betSpListSpf[3];
        int betOptionRqspf[3], betOptionBf[31], betOptionZjq[8], betOptionBqc[9], betOptionSpf[3];
        int countRqspf = 0, countBf = 0, countZjq = 0, countBqc = 0, countSpf = 0;
        
        for (int i = 0; i < 3; i++) {
            if (betOption.betOptionRqspf[i]) {
                betSpListRqspf[countRqspf] = betOption.betSpListRqspf[i];
                betOptionRqspf[countRqspf] = i;
                countRqspf++;
            }
        }
        for (int i = 0; i < 31; i++) {
            if (betOption.betOptionBf[i]) {
                betSpListBf[countBf] = betOption.betSpListBf[i];
                betOptionBf[countBf] = i;
                countBf++;
            }
        }
        for (int i = 0; i < 8; i++) {
            if (betOption.betOptionZjq[i]) {
                betSpListZjq[countZjq] = betOption.betSpListZjq[i];
                betOptionZjq[countZjq] = i;
                countZjq++;
            }
        }
        for (int i = 0; i < 9; i++) {
            if (betOption.betOptionBqc[i]) {
                betSpListBqc[countBqc] = betOption.betSpListBqc[i];
                betOptionBqc[countBqc] = i;
                countBqc++;
            }
        }
        for (int i = 0; i < 3; i++) {
            if (betOption.betOptionSpf[i]) {
                betSpListSpf[countSpf] = betOption.betSpListSpf[i];
                betOptionSpf[countSpf] = i;
                countSpf++;
            }
        }
        
        assert(countRqspf || countBf || countZjq || countBqc || countSpf);
        
        
        Array<Array<int> *> *optionsIndexArray = new Array<Array<int> *>(5);
        Array<Array<double> *> *optionsSpArray = new Array<Array<double> *>(5);
        
        Array<int> *spfIndex = NULL;
        Array<int> *bfIndex = NULL;
        Array<int> *zjqIndex = NULL;
        Array<int> *bqcIndex = NULL;
        Array<int> *rqspfIndex = NULL;
        
        Array<double> *spfSp = NULL;
        Array<double> *bfSp = NULL;
        Array<double> *zjqSp = NULL;
        Array<double> *bqcSp = NULL;
        Array<double> *rqspfSp = NULL;
        
        if (countSpf) {
            spfIndex = new Array<int>(betOptionSpf, countSpf);
            spfSp = new Array<double>(betSpListSpf, countSpf);
        }
        if (countBf) {
            bfIndex = new Array<int>(betOptionBf, countBf);
            bfSp = new Array<double>(betSpListBf, countBf);
        }
        if (countZjq) {
            zjqIndex = new Array<int>(betOptionZjq, countZjq);
            zjqSp = new Array<double>(betSpListZjq, countZjq);
        }
        if (countBqc) {
            bqcIndex = new Array<int>(betOptionBqc, countBqc);
            bqcSp = new Array<double>(betSpListBqc, countBqc);
        }
        if (countRqspf) {
            rqspfIndex = new Array<int>(betOptionRqspf, countRqspf);
            rqspfSp = new Array<double>(betSpListRqspf, countRqspf);
        }
        if (betOption.mark) {
            markIndex[markCount] = i;
            markCount++;
        }
        
        *(*optionsIndexArray)[0] = spfIndex;
        *(*optionsIndexArray)[1] = bfIndex;
        *(*optionsIndexArray)[2] = zjqIndex;
        *(*optionsIndexArray)[3] = bqcIndex;
        *(*optionsIndexArray)[4] = rqspfIndex;
        
        *(*optionsSpArray)[0] = spfSp;
        *(*optionsSpArray)[1] = bfSp;
        *(*optionsSpArray)[2] = zjqSp;
        *(*optionsSpArray)[3] = bqcSp;
        *(*optionsSpArray)[4] = rqspfSp;
        
        *analyserArray[i] = new MLFTAnalyser(optionsIndexArray, optionsSpArray, betOption.betRqs);
        
        // 记录创建的对象
        total_int_2d.push_back(optionsIndexArray);
        total_double_2d.push_back(optionsSpArray);
        total_int_1d.push_back(spfIndex);
        total_int_1d.push_back(bfIndex);
        total_int_1d.push_back(zjqIndex);
        total_int_1d.push_back(bqcIndex);
        total_int_1d.push_back(rqspfIndex);
        total_double_1d.push_back(spfSp);
        total_double_1d.push_back(bfSp);
        total_double_1d.push_back(zjqSp);
        total_double_1d.push_back(bqcSp);
        total_double_1d.push_back(rqspfSp);
    }
    
    Array<int> *gallIndexArray = NULL;
    Array<int> *gallRangeArray = NULL;
    
    assert(markCount <= 8);
    if (markCount) {
        gallIndexArray = new Array<int>(markIndex, markCount);
        gallRangeArray = new Array<int>(&markCount, 1);
    }
    
    MLCalculater calculater(&analyserArray, gallIndexArray, gallRangeArray, &passMode);
    Int64 realNote = calculater.GetBetCount();
    double realMinBonus = calculater.GetMinBonus();
    double realMaxBonus = calculater.GetMaxBonus();
    
    // 释放内存
    for (int i = 0; i < total_int_2d.size(); i++) {
        if (total_int_2d[i]) {
            delete total_int_2d[i];
            total_int_2d[i] = NULL;
        }
    }
    for (int i = 0; i < total_double_2d.size(); i++) {
        if (total_double_2d[i]) {
            delete total_double_2d[i];
            total_double_2d[i] = NULL;
        }
    }
    for (int i = 0; i < total_int_1d.size(); i++) {
        if (total_int_1d[i]) {
            delete total_int_1d[i];
            total_int_1d[i] = NULL;
        }
    }
    for (int i = 0; i < total_double_1d.size(); i++) {
        if (total_double_1d[i]) {
            delete total_double_1d[i];
            total_double_1d[i] = NULL;
        }
    }
    for (int i = 0; i < analyserArray.GetLength(); i++) {
        MLFTAnalyser *analyser = (MLFTAnalyser *)*analyserArray[i];
        if (analyser) {
            delete analyser;
            *analyserArray[i] = NULL;
        }
    }
    for (int i = 0; i < pmCount; i++) {
        if (*passMode[i] == NULL) {
            delete (*passMode[i]);
            *passMode[i] = NULL;
        }
    }
    
    note = realNote;
    maxBonus = realMaxBonus;
    minBonus = realMinBonus;
    
//    DbgPrint("注数: %d, 最大奖金: %f, 最小奖金: %f", note, maxBonus, minBonus);
    
    return 0;
}

int JclqCalculater(JclqCalculaterOption optionList[], int count, int passModes[], int pmCount, int64_t &note, float &minBonus, float &maxBonus) {
    if (count == 0 || pmCount == 0) {
        note = 0;
        minBonus = 0;
        maxBonus = 0;
        return 0;
    }
    // 记录创建的对象, 在最后进行释放
    vector<Array<Array<int> *> *> total_int_2d;
    vector<Array<Array<double> *> *> total_double_2d;
    vector<Array<int> *> total_int_1d;
    vector<Array<double> *> total_double_1d;
    
    // 过关方式
    Array<PassMode *> passMode(pmCount);
    for (int i = 0; i < pmCount; i++) {
        *passMode[i] = new PassMode(GetPassModeNamePrefix(passModes[i]), GetPassModeNameSuffix(passModes[i]));
    }
    
    Array<MLAnalyser *> analyserArray(count);
    int markIndex[8] = { 0 }; int markCount = 0;
    for (int i = 0; i < count; i++) {
        JclqCalculaterOption &betOption = optionList[i];
        
        double betSpListSf[2], betSpListRfsf[2], betSpListDxf[2], betSpListSfc[12];
        int betOptionSf[2], betOptionRfsf[2], betOptionDxf[2], betOptionSfc[12];
        int countSf = 0, countRfsf = 0, countDxf = 0, countSfc = 0;
        
        for (int i = 0; i < 2; i++) {
            if (betOption.betOptionSf[i]) {
                betSpListSf[countSf] = betOption.betSpListSf[i];
                betOptionSf[countSf] = i;
                countSf++;
            }
        }
        for (int i = 0; i < 2; i++) {
            if (betOption.betOptionRfsf[i]) {
                betSpListRfsf[countRfsf] = betOption.betSpListRfsf[i];
                betOptionRfsf[countRfsf] = i;
                countRfsf++;
            }
        }
        for (int i = 0; i < 2; i++) {
            if (betOption.betOptionDxf[i]) {
                betSpListDxf[countDxf] = betOption.betSpListDxf[i];
                betOptionDxf[countDxf] = i;
                countDxf++;
            }
        }
        for (int i = 0; i < 12; i++) {
            if (betOption.betOptionSfc[i]) {
                betSpListSfc[countSfc] = betOption.betSpListSfc[i];
                betOptionSfc[countSfc] = i;
                countSfc++;
            }
        }
        
        assert(countSf || countRfsf || countDxf || countSfc);
        
        Array<Array<int> *> *optionsIndexArray = new Array<Array<int> *>(4);
        Array<Array<double> *> *optionsSpArray = new Array<Array<double> *>(4);
        
        Array<int> *sfIndex = NULL;
        Array<int> *rfsfIndex = NULL;
        Array<int> *dxfIndex = NULL;
        Array<int> *sfcIndex = NULL;
        
        Array<double> *sfSp = NULL;
        Array<double> *rfsfSp = NULL;
        Array<double> *dxfSp = NULL;
        Array<double> *sfcSp = NULL;
        
        if (countSf) {
            sfIndex = new Array<int>(betOptionSf, countSf);
            sfSp = new Array<double>(betSpListSf, countSf);
        }
        if (countRfsf) {
            rfsfIndex = new Array<int>(betOptionRfsf, countRfsf);
            rfsfSp = new Array<double>(betSpListRfsf, countRfsf);
        }
        if (countDxf) {
            dxfIndex = new Array<int>(betOptionDxf, countDxf);
            dxfSp = new Array<double>(betSpListDxf, countDxf);
        }
        if (countSfc) {
            sfcIndex = new Array<int>(betOptionSfc, countSfc);
            sfcSp = new Array<double>(betSpListSfc, countSfc);
        }
        if (betOption.mark) {
            markIndex[markCount] = i;
            markCount++;
        }
        
        *(*optionsIndexArray)[0] = sfIndex;
        *(*optionsIndexArray)[1] = sfcIndex;
        *(*optionsIndexArray)[2] = dxfIndex;
        *(*optionsIndexArray)[3] = rfsfIndex;
        
        *(*optionsSpArray)[0] = sfSp;
        *(*optionsSpArray)[1] = sfcSp;
        *(*optionsSpArray)[2] = dxfSp;
        *(*optionsSpArray)[3] = rfsfSp;
        
        *analyserArray[i] = new MLBKAnalyser(optionsIndexArray, optionsSpArray, betOption.betRf);
        
        // 记录创建的对象
        total_int_2d.push_back(optionsIndexArray);
        total_double_2d.push_back(optionsSpArray);
        total_int_1d.push_back(sfIndex);
        total_int_1d.push_back(rfsfIndex);
        total_int_1d.push_back(dxfIndex);
        total_int_1d.push_back(sfcIndex);
        total_double_1d.push_back(sfSp);
        total_double_1d.push_back(rfsfSp);
        total_double_1d.push_back(dxfSp);
        total_double_1d.push_back(sfcSp);
    }
    
    Array<int> *gallIndexArray = NULL;
    Array<int> *gallRangeArray = NULL;
    
    assert(markCount <= 8);
    if (markCount) {
        gallIndexArray = new Array<int>(markIndex, markCount);
        gallRangeArray = new Array<int>(&markCount, 1);
    }
    
    MLCalculater calculater(&analyserArray, gallIndexArray, gallRangeArray, &passMode);
    Int64 realNote = calculater.GetBetCount();
    double realMinBonus = calculater.GetMinBonus();
    double realMaxBonus = calculater.GetMaxBonus();
    
    // 释放内存
    for (int i = 0; i < total_int_2d.size(); i++) {
        if (total_int_2d[i]) {
            delete total_int_2d[i];
            total_int_2d[i] = NULL;
        }
    }
    for (int i = 0; i < total_double_2d.size(); i++) {
        if (total_double_2d[i]) {
            delete total_double_2d[i];
            total_double_2d[i] = NULL;
        }
    }
    for (int i = 0; i < total_int_1d.size(); i++) {
        if (total_int_1d[i]) {
            delete total_int_1d[i];
            total_int_1d[i] = NULL;
        }
    }
    for (int i = 0; i < total_double_1d.size(); i++) {
        if (total_double_1d[i]) {
            delete total_double_1d[i];
            total_double_1d[i] = NULL;
        }
    }
    for (int i = 0; i < analyserArray.GetLength(); i++) {
        MLBKAnalyser *analyser = (MLBKAnalyser *)*analyserArray[i];
        if (analyser) {
            delete analyser;
            *analyserArray[i] = NULL;
        }
    }
    for (int i = 0; i < pmCount; i++) {
        if (*passMode[i] == NULL) {
            delete (*passMode[i]);
            *passMode[i] = NULL;
        }
    }
    
    note = realNote;
    maxBonus = realMaxBonus;
    minBonus = realMinBonus;
    
//    DbgPrint("注数: %d, 最大奖金: %f, 最小奖金: %f", note, maxBonus, minBonus);
    return 0;
}
    
int DltCalculater(int redTuoCount,int redDanCount, int blueTuoCount, int blueDanCount) {
    bool bile = false;
    // 发现有胆, 必为胆拖
    if (redDanCount || blueDanCount) {
        bile = true;
    }
    
    if (bile) {
        if (redDanCount == 0 && blueDanCount == 0) {
            return 0;
        }
        if (redDanCount + redTuoCount == 5 && blueDanCount + blueTuoCount == 2) {
            return 0;
        }
        
        if (redDanCount) {
            if (redDanCount < 1 || redDanCount > 4 || redTuoCount < 2) {
                return 0;
            }
            if (redDanCount + redTuoCount <= 5) {
                return 0;
            }
        }
        if (blueDanCount) {
            if (blueDanCount > 1 || blueTuoCount < 2) {
                return 0;
            }
            if (blueDanCount + blueTuoCount <= 2) {
                return 0;
            }
        }
    }
    return CMathHelper::GetCombinationInt(redTuoCount, 5 - redDanCount) * CMathHelper::GetCombinationInt(blueTuoCount, 2 - blueDanCount);
}

int DltCalculater(int red[kDltRedCount], int blue[kDltBlueCount]) {
    int redTuoCount = 0;
    int redDanCount = 0;
    int blueTuoCount = 0;
    int blueDanCount = 0;
    
    
    for (int i = 0; i < kDltRedCount; i++) {
        if (red[i] == 1) {
            redTuoCount++;
        } else if (red[i] == -1) {
            redDanCount++;
        }
    }
    for (int i = 0; i < kDltBlueCount; i++) {
        if (blue[i] == 1) {
            blueTuoCount++;
        } else if (blue[i] == -1) {
            blueDanCount++;
        }
    }
    return DltCalculater(redTuoCount, redDanCount, blueTuoCount, blueDanCount);
}


}