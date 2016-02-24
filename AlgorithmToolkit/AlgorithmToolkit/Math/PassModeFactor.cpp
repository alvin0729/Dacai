//
//  PassModeFactor.cpp
//  DacaiProject
//
//  Created by WUFAN on 14-7-24.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#include <string.h>
#include <assert.h>
#include <math.h>
#include "PassModeFactor.h"
#include "PassModeDefine.h"
#include "BaseMath.h"
#include "../GameTypeDefine.h"

CPassModeFactor::CPassModeFactor() {
    // 自由过关
    // 1
    mJcSpf.freedomCount = mJcRqspf.freedomCount = mLcSf.freedomCount = mLcRfsf.freedomCount = mLcDxf.freedomCount = FreedomTableSize1;
    CMathHelper::MemoryCopy(mJcSpf.freedomTags, FreedomPassModeTable1, FreedomTableSize1 * sizeof(int));
    CMathHelper::MemoryCopy(mJcRqspf.freedomTags, FreedomPassModeTable1, FreedomTableSize1 * sizeof(int));
    CMathHelper::MemoryCopy(mLcSf.freedomTags, FreedomPassModeTable1, FreedomTableSize1 * sizeof(int));
    CMathHelper::MemoryCopy(mLcRfsf.freedomTags, FreedomPassModeTable1, FreedomTableSize1 * sizeof(int));
    CMathHelper::MemoryCopy(mLcDxf.freedomTags, FreedomPassModeTable1, FreedomTableSize1 * sizeof(int));
    
    // 2
    mJcBf.freedomCount = mLcSfc.freedomCount = FreedomTableSize2;
    CMathHelper::MemoryCopy(mJcBf.freedomTags, FreedomPassModeTable2, FreedomTableSize2 * sizeof(int));
    CMathHelper::MemoryCopy(mLcSfc.freedomTags, FreedomPassModeTable2, FreedomTableSize2 * sizeof(int));
    
    // 3
    mJcZjq.freedomCount = FreedomTableSize3;
    CMathHelper::MemoryCopy(mJcZjq.freedomTags, FreedomPassModeTable3, FreedomTableSize3 * sizeof(int));
    
    // 4
    mJcBqc.freedomCount = FreedomTableSize4;
    CMathHelper::MemoryCopy(mJcBqc.freedomTags, FreedomPassModeTable4, FreedomTableSize4 * sizeof(int));
    
    // 5
    mBdRqspf.freedomCount = FreedomTableSize5;
    CMathHelper::MemoryCopy(mBdRqspf.freedomTags, FreedomPassModeTable5, FreedomTableSize5 * sizeof(int));
    
    // 6
    mBdBf.freedomCount = FreedomTableSize6;
    CMathHelper::MemoryCopy(mBdBf.freedomTags, FreedomPassModeTable6, FreedomTableSize6 * sizeof(int));
    
    // 7
    mBdZjq.freedomCount = mBdBqc.freedomCount = mBdSxds.freedomCount = FreedomTableSize7;
    CMathHelper::MemoryCopy(mBdZjq.freedomTags, FreedomPassModeTable7, FreedomTableSize7 * sizeof(int));
    CMathHelper::MemoryCopy(mBdBqc.freedomTags, FreedomPassModeTable7, FreedomTableSize7 * sizeof(int));
    CMathHelper::MemoryCopy(mBdSxds.freedomTags, FreedomPassModeTable7, FreedomTableSize7 * sizeof(int));
    
    // 组合过关
    // 1
    mJcSpf.combineCount = mJcRqspf.combineCount = mLcSf.combineCount = mLcRfsf.combineCount = mLcDxf.combineCount = CombineTableSize1;
    CMathHelper::MemoryCopy(mJcSpf.combineTags, CombinePassModeTable1, CombineTableSize1 * sizeof(int));
    CMathHelper::MemoryCopy(mJcRqspf.combineTags, CombinePassModeTable1, CombineTableSize1 * sizeof(int));
    CMathHelper::MemoryCopy(mLcSf.combineTags, CombinePassModeTable1, CombineTableSize1 * sizeof(int));
    CMathHelper::MemoryCopy(mLcRfsf.combineTags, CombinePassModeTable1, CombineTableSize1 * sizeof(int));
    CMathHelper::MemoryCopy(mLcDxf.combineTags, CombinePassModeTable1, CombineTableSize1 * sizeof(int));
    
    // 2
    mJcBf.combineCount = mJcBqc.combineCount = mLcSfc.combineCount = CombineTableSize2;
    CMathHelper::MemoryCopy(mJcBf.combineTags, CombinePassModeTable2, CombineTableSize2 * sizeof(int));
    CMathHelper::MemoryCopy(mJcBqc.combineTags, CombinePassModeTable2, CombineTableSize2 * sizeof(int));
    CMathHelper::MemoryCopy(mLcSfc.combineTags, CombinePassModeTable2, CombineTableSize2 * sizeof(int));
    
    // 3
    mJcZjq.combineCount = CombineTableSize3;
    CMathHelper::MemoryCopy(mJcZjq.combineTags, CombinePassModeTable3, CombineTableSize3 * sizeof(int));
    
    // 4
    mBdRqspf.combineCount = mBdZjq.combineCount = mBdBqc.combineCount = mBdSxds.combineCount = CombineTableSize4;
    CMathHelper::MemoryCopy(mBdRqspf.combineTags, CombinePassModeTable4, CombineTableSize4 * sizeof(int));
    CMathHelper::MemoryCopy(mBdZjq.combineTags, CombinePassModeTable4, CombineTableSize4 * sizeof(int));
    CMathHelper::MemoryCopy(mBdBqc.combineTags, CombinePassModeTable4, CombineTableSize4 * sizeof(int));
    CMathHelper::MemoryCopy(mBdSxds.combineTags, CombinePassModeTable4, CombineTableSize4 * sizeof(int));
    
    // 5
    mBdBf.combineCount = CombineTableSize5;
    CMathHelper::MemoryCopy(mBdBf.combineTags, CombinePassModeTable5, CombineTableSize5 * sizeof(int));
}


int CPassModeFactor::GetFreedomPassModes(int *gameTypes, int typeCount, int markCount, int matchCount, vector<int> &freedomTags) {
    int freedomTemp[80];
    int freedomLength = 0;
    int temp[80];
    int length = 0;
    
    for (int i = 0; i < FreedomTableSize; i++) {
        int needCount = GetPassModeNamePrefix(FreedomPassModeTable[i]);
        if (needCount >= markCount && needCount <= matchCount) {
            freedomTemp[freedomLength++] = FreedomPassModeTable[i];
        }
    }
    
    for (int i = 0; i < typeCount; i++) {
        CPassModeFactor::PassModeGroup table = _passModeTable(gameTypes[i]);
        
        if (CMathHelper::IntersectIntSet(freedomTemp, freedomLength, table.freedomTags, table.freedomCount, temp, 80, length) == 0) {
            CMathHelper::MemoryCopy(freedomTemp, temp, sizeof(int) * 80);
            freedomLength = length;
        }
    }
    
    vector<int> freedom;
    for (int i = 0; i < freedomLength; i++) {
        freedom.push_back(freedomTemp[i]);
    }
    freedomTags = freedom;
    
    return 0;
}

int CPassModeFactor::GetCombinePassModes(int *gameTypes, int typeCount, int markCount, int matchCount, vector<int> &combineTags) {
    int combineTemp[80];
    int combineLength = 0;
    int temp[80];
    int length = 0;
   
    for (int i = 0; i < CombineTableSize; i++) {
        int needCount = GetPassModeNamePrefix(CombinePassModeTable[i]);
        if (needCount >= markCount && needCount <= matchCount) {
            combineTemp[combineLength++] = CombinePassModeTable[i];
        }
    }
    
    for (int i = 0; i < typeCount; i++) {
        CPassModeFactor::PassModeGroup table = _passModeTable(gameTypes[i]);
       
        if (CMathHelper::IntersectIntSet(combineTemp, combineLength, table.combineTags, table.combineCount, temp, 80, length) == 0) {
            CMathHelper::MemoryCopy(combineTemp, temp, sizeof(int) * 80);
            combineLength = length;
        }
    }
    
    vector<int> combine;
    for (int i = 0; i < combineLength; i++) {
        combine.push_back(combineTemp[i]);
    }
    combineTags = combine;
    
    return 0;
}

int CPassModeFactor::GetPassModes(int *gameTypes, int typeCount, int markCount, int matchCount, vector<int> &freedomTags, vector<int> &combineTags) {
    int freedomTemp[80];
    int combineTemp[80];
    
    int freedomLength = 0;
    int combineLength = 0;
    
    int temp[80];
    int length = 0;
    
    for (int i = 0; i < FreedomTableSize; i++) {
        int needCount = GetPassModeNamePrefix(FreedomPassModeTable[i]);
        if (needCount >= markCount && needCount <= matchCount) {
            freedomTemp[freedomLength++] = FreedomPassModeTable[i];
        }
    }
    for (int i = 0; i < CombineTableSize; i++) {
        int needCount = GetPassModeNamePrefix(CombinePassModeTable[i]);
        if (needCount >= markCount && needCount <= matchCount) {
            combineTemp[combineLength++] = CombinePassModeTable[i];
        }
    }
    
    for (int i = 0; i < typeCount; i++) {
        CPassModeFactor::PassModeGroup table = _passModeTable(gameTypes[i]);
        
        if (CMathHelper::IntersectIntSet(freedomTemp, freedomLength, table.freedomTags, table.freedomCount, temp, 80, length) == 0) {
            CMathHelper::MemoryCopy(freedomTemp, temp, sizeof(int) * 80);
            freedomLength = length;
        }
        if (CMathHelper::IntersectIntSet(combineTemp, combineLength, table.combineTags, table.combineCount, temp, 80, length) == 0) {
            CMathHelper::MemoryCopy(combineTemp, temp, sizeof(int) * 80);
            combineLength = length;
        }
    }
    
    vector<int> freedom;
    vector<int> combine;
    
    for (int i = 0; i < freedomLength; i++) {
        freedom.push_back(freedomTemp[i]);
    }
    for (int i = 0; i < combineLength; i++) {
        combine.push_back(combineTemp[i]);
    }
    
    freedomTags = freedom;
    combineTags = combine;
    
    return 0;
}

CPassModeFactor::PassModeGroup CPassModeFactor::_passModeTable(int gameType) {
    switch (gameType) {
        case GameTypeJcSpf:
            return mJcSpf;
        case GameTypeJcRqspf:
            return mJcRqspf;
        case GameTypeJcBf:
            return mJcBf;
        case GameTypeJcBqc:
            return mJcBqc;
        case GameTypeJcZjq:
            return mJcZjq;
            
        case GameTypeBdRqspf:
            return mBdRqspf;
        case GameTypeBdBf:
            return mBdBf;
        case GameTypeBdBqc:
            return mBdBqc;
        case GameTypeBdZjq:
            return mBdZjq;
        case GameTypeBdSxds:
            return mBdSxds;
            
        case GameTypeLcSf:
            return mLcSf;
        case GameTypeLcRfsf:
            return mLcRfsf;
        case GameTypeLcSfc:
            return mLcSfc;
        case GameTypeLcDxf:
            return mLcDxf;
        default:
            break;
    }
    
    assert(false);
    
    return CPassModeFactor::PassModeGroup();
}

int CCapacityFactor::_generateAmt(vector<int> &multiple, vector<int> &totalAmount, vector<int> &minProfit, vector<int> &maxProfit, vector<int> &rate) {
    multiple.clear();
    totalAmount.clear();
    minProfit.clear();
    maxProfit.clear();
    rate.clear();
    
    if (mAmount >= mMinBonus) {
        return ERROR_CANNOT_PROFIX;
    }
    
    int total = 0;
    for (int i = 0; i < mPeriods; i++) {
        // 当前倍数
        int n = ceilf(1.0 * (mProfitAmount + total)/ (mMinBonus - mAmount));
        if (i == 0) {
            n = std::max(n, mInitMultiple);
        } else {
            n = std::max(n, multiple.back());
        }
        if (n > 1000) {
            return i;
        }
        
        // 当前累加金额
        total += n * mAmount;
        
        // 盈利金额
        int min = n * mMinBonus - total;
        int max = n * mMaxBonus - total;
        
        multiple.push_back(n);
        totalAmount.push_back(total);
        minProfit.push_back(min);
        maxProfit.push_back(max);
        // 盈利率
        rate.push_back(total == 0 ? 0 : (100.0 * min / total));
    }
    
    return mPeriods;
}

int CCapacityFactor::_generateRate(vector<int> &multiple, vector<int> &totalAmount, vector<int> &minProfit, vector<int> &maxProfit, vector<int> &rate) {
    multiple.clear();
    totalAmount.clear();
    minProfit.clear();
    maxProfit.clear();
    rate.clear();
    
    if (mAmount >= mMinBonus) {
        return ERROR_CANNOT_PROFIX;
    }
    if (1.0f * (mMinBonus - mAmount) / mAmount < mProfitRate) {
        return ERROR_OVERLARGE_EXPECT;
    }
    
    int total = 0;
    for (int i = 0; i < mPeriods; i++) {
        // 当前倍数
        int n = i == 0 ? mInitMultiple : ceilf(1.0 * (mProfitRate * total + total) / (mMinBonus - mAmount - mProfitRate * mAmount));
        if (i > 0) {
            n = std::max(n, multiple.back());
        }
        if (n > 1000) {
            return i;
        }
        
        // 当前累加金额
        total += n * mAmount;
        
        // 盈利金额
        int min = n * mMinBonus - total;
        int max = n * mMaxBonus - total;
        
        multiple.push_back(n);
        totalAmount.push_back(total);
        minProfit.push_back(min);
        maxProfit.push_back(max);
        // 盈利率
        rate.push_back(total == 0 ? 0 : (100.0 * min / total));
    }
    
    return mPeriods;
}

int CCapacityFactor::_generateCommon(vector<int> &multiple, vector<int> &totalAmount, vector<int> &minProfit, vector<int> &maxProfit, vector<int> &rate) {
    multiple.clear();
    totalAmount.clear();
    minProfit.clear();
    maxProfit.clear();
    rate.clear();
    
    if (mAmount >= mMinBonus) {
        return ERROR_CANNOT_PROFIX;
    }
    if (1.0f * (mMinBonus - mAmount) / mAmount < mEarlyRate || 1.0f * (mMinBonus - mAmount) / mAmount < mLastRate) {
        return ERROR_OVERLARGE_EXPECT;
    }
    
    int total = 0;
    for (int i = 0; i < mPeriods; i++) {
        // 当前倍数
        int n = 0;
        
        if (i < mEarlyPeriods) {
            n = i == 0 ? mInitMultiple : ceilf(1.0 * (mEarlyRate * total + total) / (mMinBonus - mAmount - mEarlyRate * mAmount));
            if (i > 0) {
                n = std::max(n, multiple.back());
            }
        } else {
            n = i == 0 ? mInitMultiple : ceilf(1.0 * (mLastRate * total + total) / (mMinBonus - mAmount - mLastRate * mAmount));
            if (i > 0) {
                n = std::max(n, multiple.back());
            }
        }
        if (n > 1000) {
            return i;
        }
        
        // 当前累加金额
        total += n * mAmount;
        
        // 盈利金额
        int min = n * mMinBonus - total;
        int max = n * mMaxBonus - total;
        
        multiple.push_back(n);
        totalAmount.push_back(total);
        minProfit.push_back(min);
        maxProfit.push_back(max);
        // 盈利率
        rate.push_back(total == 0 ? 0 : (100.0 * min / total));
    }
    
    return mPeriods;
}
