#ifndef __LOTTERYTYPE_H__
#define __LOTTERYTYPE_H__

#include <string.h>
#include <algorithm>

class CTrendChartCell {
public:
    CTrendChartCell(int gameCount, int numberCount) : mGameCount(gameCount), mNumberCount(numberCount) {
        mInitMiss    = new int[numberCount];
        mAppearCount = new int[numberCount];
        mAvgMiss     = new int[numberCount];
        mMaxMiss     = new int[numberCount];
        mMaxCombo    = new int[numberCount];
        
        memset(mInitMiss, 0, sizeof(int) * numberCount);
        memset(mAppearCount, 0, sizeof(int) * numberCount);
        memset(mAvgMiss, 0, sizeof(int) * numberCount);
        memset(mMaxMiss, 0, sizeof(int) * numberCount);
        memset(mMaxCombo, 0, sizeof(int) * numberCount);
        
        mMissNumber  = new int*[gameCount];
        
        for (int i = 0; i < gameCount; i++) {
            mMissNumber[i] = new int[numberCount];
            
            memset(mMissNumber[i], 0, sizeof(int) * numberCount);
        }
    }
    ~CTrendChartCell() {
        for (int i = 0; i < mGameCount; i++) {
            delete [] mMissNumber[i];
        }
        
        delete [] mMissNumber;
        delete [] mInitMiss;
        delete [] mAppearCount;
        delete [] mAvgMiss;
        delete [] mMaxMiss;
        delete [] mMaxCombo;
    }
    
    void Statistics(int count, int *buffer, int gameCount = 200) {
        if (count == 0) {
            memcpy(buffer + mNumberCount * 0, mMaxCombo, sizeof(int) * mNumberCount);
            memcpy(buffer + mNumberCount * 1, mMaxMiss, sizeof(int) * mNumberCount);
            memcpy(buffer + mNumberCount * 2, mAvgMiss, sizeof(int) * mNumberCount);
            memcpy(buffer + mNumberCount * 3, mAppearCount, sizeof(int) * mNumberCount);
        } else {
            int *maxCombo = new int[mNumberCount];
            int *maxMiss = new int[mNumberCount];
            int *avgMiss = new int[mNumberCount];
            int *appearCount = new int[mNumberCount];
            int *comboCount = new int[mNumberCount];
            memset(maxCombo, 0, sizeof(int) * mNumberCount);
            memset(maxMiss, 0, sizeof(int) * mNumberCount);
            memset(avgMiss, 0, sizeof(int) * mNumberCount);
            memset(appearCount, 0, sizeof(int) * mNumberCount);
            memset(comboCount, 0, sizeof(int) * mNumberCount);
            for (int i = 0; i < count; i++) {
                for (int j = 0; j < mNumberCount; j++) {
                    int missValue = mMissNumber[gameCount - count + i][j];
                    
                    // 出现次数
                    if (missValue < 0) {
                        appearCount[j]++;
                    }
                    // 平均遗漏, 先统计总遗漏
                    if (missValue > 0) {
                        avgMiss[j] += missValue;
                    }
                    // 最大遗漏
                    if (missValue > maxMiss[j]) {
                        maxMiss[j] = missValue;
                    }
                    // 最大连出
                    if (missValue < 0) {
                        comboCount[j]++;
                    } else {
                        if (comboCount[j] > maxCombo[j]) {
                            maxCombo[j] = comboCount[j];
                        }
                        comboCount[j] = 0;
                    }
                }
            }
            for (int i = 0; i < mNumberCount; i++) {
                if (comboCount[i] > maxCombo[i]) {
                    maxCombo[i] = comboCount[i];
                }
                comboCount[i] = 0;
            }
            
            for (int i = 0; i < mNumberCount; i++) {
                avgMiss[i] /= count;
            }
            memcpy(buffer + mNumberCount * 0, maxCombo, sizeof(int) * mNumberCount);
            memcpy(buffer + mNumberCount * 1, maxMiss, sizeof(int) * mNumberCount);
            memcpy(buffer + mNumberCount * 2, avgMiss, sizeof(int) * mNumberCount);
            memcpy(buffer + mNumberCount * 3, appearCount, sizeof(int) * mNumberCount);
            delete [] maxCombo;
            delete [] maxMiss;
            delete [] avgMiss;
            delete [] appearCount;
            delete [] comboCount;
        }
    }
    
public:
    int **mMissNumber;  // 遗漏值
    
    int *mInitMiss;     // 初始遗漏
    int *mAppearCount;  // 出现次数
    int *mAvgMiss;      // 平均遗漏
    int *mMaxMiss;      // 最大遗漏
    int *mMaxCombo;     // 最大连出
    
    int mGameCount;     // 期数
    int mNumberCount;   // 号码数
};


#endif

