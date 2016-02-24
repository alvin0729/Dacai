//
//  BetCalculater+Optimize.cpp
//  AlgorithmToolkit
//
//  Created by WUFAN on 15/12/14.
//  Copyright © 2015年 dacai. All rights reserved.
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
#include "GameTypeDefine.h"

namespace LotteryCalculater {
    
#pragma mark - 优化投注
#define balance_max_all  10000000000000.0
#define balance_max_dv   0.1
    
/**
 *  平衡算法
 *
 *  @param bc  [in out]计算所得倍数数组, 外部赋值内存管理
 *  @param spm [in]对阵奖金, 外部赋值内存管理
 *  @param n   [in]对阵数
 *  @param c   [in]预算注数
 */
void balance(int *bc, float *spm, int n, int c) {
    float all = 1;
    for (int i = 0; i < n; i++) {
        all *= spm[i];
        while (all > balance_max_all) {
            all /= 10;
        }
    }
    
    float *tbc = new float[n];
    for (int i = 0; i < n; i++) {
        tbc[i] = all / spm[i];
    }
    
    float sum_tbc = 0;
    for (int i = 0; i < n; i++) {
        sum_tbc += tbc[i];
    }
    
    if (c > 0) {
        float d = sum_tbc / c;
        float *dv = new float[n];
        for (int i = 0; i < n; i++) {
            float dbc = tbc[i] / d;
            bc[i] = floor(dbc);
            dv[i] = (dbc - bc[i]) * spm[i];
        }
        
        int *idx = new int[n];
        for (int i = 0; i < n; i++) {
            idx[i] = i;
        }
        
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n - i - 1; j++) {
                if (dv[j] < dv[j + 1]) {
                    std::swap(idx[j], idx[j + 1]);
                    std::swap(dv[j], dv[j + 1]);
                }
            }
        }
        
        float sum_bc = 0;
        for (int i = 0; i < n; i++) {
            sum_bc += bc[i];
        }
        float dc = c - sum_bc;
        
        for (int i = 0; i < dc && i < n; i++) {
            bc[idx[i]] += 1;
        }
        
        delete [] dv;
        delete [] idx;
    } else {
        float min_tbc = FLT_MAX;
        for (int i = 0; i < n; i++) {
            tbc[i] = round(tbc[i]);
            if (min_tbc > tbc[i]) {
                min_tbc = tbc[i];
            }
        }
        
        unsigned long long k = 1;
        if (min_tbc >= 1000) {
            k = min_tbc / 500;
            min_tbc = min_tbc / k;
        }
        for (int i = 0; i < n; i++) {
            tbc[i] /= k;
        }
        
        float min_bonus = 0, max_bonus = 0, bc_bonus = 0;
        for (int i = min_tbc; i > 0; i--) {
            min_bonus = FLT_MAX;
            max_bonus = FLT_MIN;
            for (int j = 0; j < n; j++) {
                bc[j] = round(tbc[j] / i);
                bc_bonus = bc[j] * spm[j];
                if (min_bonus > bc_bonus) {
                    min_bonus = bc_bonus;
                }
                if (max_bonus < bc_bonus) {
                    max_bonus = bc_bonus;
                }
            }
            
            if ((max_bonus - min_bonus) / max_bonus < balance_max_dv) {
                break;
            }
//            assert(i > 1);
        }
        
        // 去除公约数
        int min_bc = INT_MAX;
        for (int i = 0; i < n; i++) {
            if (min_bc > bc[i]) {
                min_bc = bc[i];
            }
        }
        
        for (int i = sqrt(min_bc); i > 1; i--) {
            if (min_bc % i != 0) {
                continue;
            }
            bool div = true;
            for (int j = 0; j < n; j++) {
                if (bc[j] % i != 0) {
                    div = false;
                    break;
                }
            }
            
            if (!div) {
                continue;
            }
            
            min_bc /= i;
            for (int j = 0; j < n; j++) {
                bc[j] /= i;
            }
        }
    }
    
    delete [] tbc;
}

/**
 *  拆分算法, 组合
 *
 *  @param origs  [in]原始元素
 *  @param n      [in]组成一组需要的元素个数
 *  @param result [out]结果
 */
template <typename T>
void gen_split(std::vector<std::vector<T> *> origs, int n, std::vector<std::vector<T> *> &result) {
    int  count = origs.size();
    int *lens = new int[count];
    for (int i = 0; i < count; i++) {
        lens[i] = origs[i]->size();
    }
    
    int *idxs = new int[n];
    int *opts = new int[n];
    for (int i = 0; i < n; i++) {
        idxs[i] = i; opts[i] = 0;
    }
    
    /**
     
     origs:
     o o o o
     o o
     o
     o o o
     o
     
     n: 3
     
     idxs:
     Y轴索引
     
     opts:
     X轴索引
     
     idx_carry:
     Y轴进位
     
     opt_carry:
     X轴进位
     
     遍历过程:
     比如当前有  idxs: [0, 1, 2]  opts: [0, 0, 0]
     其中由 idxs 指定了当前遍历为第1, 2, 3场比赛, opts: 指定了当前遍历为每场比赛的第一个选项
     
     完成当前遍历, 进行下一次遍历, 首先对 opts[2] 进行+1操作, 发现需要第3场比赛只有一个选择, 无法加一需要进位
     此时先对opts[2]置0, 进位到 opts[1], 此时 opts: [0, 1, 0]
     
     经过多次遍历, 完成后出现 idxs: [0, 1, 2], opts: [3, 1, 0], 进行下一次遍历时, 发现进位到 opts[0] 仍然需要进位,
     此时将进位计如 idxs[2], 得到 idxs: [0, 1, 3], opts: [0, 0, 0]
     
     idxs 的进位规则同 opts, 多次遍历后出现 idxs: [2, 3, 4], opts: [0, 2, 0], 此时均无法继续进位, 则遍历结束
     
     */
    
    bool idx_carry = true;
    bool opt_carry = true;
    do {
        memset(opts, 0, sizeof(int) * n);
        do {
            // 组织数据
            std::vector<T> *tmp = new std::vector<T>;
            for (int i = 0; i < n; i++) {
                
                std::vector<T> *ts = origs[idxs[i]];
                T t = ts->at(opts[i]);
                tmp->push_back(t);
            }
            result.push_back(tmp);
            
            opt_carry = true;   // 需要进位
            for (int i = n - 1; opt_carry && i >= 0; i--) {
                if ((opt_carry = (opts[i] >= lens[idxs[i]] - 1))) {   // 进位
                    opts[i] = 0;
                } else {
                    opts[i]++;
                }
            }
        } while (!opt_carry);
        
        idx_carry = true;
        for (int i = n - 1; idx_carry && i >= 0; i--) {
            idx_carry = idxs[i] >= (count - n + i);//opts[i] >= lens[i];
            if (!idx_carry) {
                idxs[i]++;
                for (int j = 1; j < n - i; j++) {
                    idxs[i + j] = idxs[i] + j;
                }
            }
        }
    } while (!idx_carry);
}

/**
 *  拆分算法, 组合
 *
 *  @param origs    [in]原始元素
 *  @param n        [in]组成一串需要的元素个数, 即 N串1 中的 N
 *  @param passMode [in]过关方式
 *  @param mark     [in]胆索引数组
 *  @param markLen  [in]胆的个数
 *  @param result   [out]结果
 */
template <typename T>
void gen_split(std::vector< std::vector<T> > origs, int n, int passMode, int mark[], int markLen, std::vector< std::vector<T> > &result) {
    int c = GetPassModeNamePrefix(passMode);
    
    int  count = (int)origs.size();
    int *lens = new int[count];
    for (int i = 0; i < count; i++) {
        lens[i] = (int)origs[i].size();
    }
    
    int *idxs = new int[n];
    int *opts = new int[n];
    for (int i = 0; i < n; i++) {
        idxs[i] = i; opts[i] = 0;
    }
    
    bool idx_carry = true;
    bool opt_carry = true;
    do {
        // 设胆优化, 判断是否满足设胆条件
        int match = 0;
        for (int i = 0; markLen > 0 && i < markLen; i++) {
            for (int j = 0; j < n; j++) {
                if (mark[i] == idxs[j]) {
                    match++;
                    break;
                }
            }
        }
        
        // 允许不为胆的个数 >= 不匹配胆的个数
        // 比如 3串3, c = 3, n = 2, 此时设 2 个胆, markLen = 2
        // 则选中的一组元素中必有2(markLen)个胆, 1个非胆(c - markLen)
        // 那么说明, 此时的 idxs 中最多一个不是胆
        if ((GetPassModeNameSuffix(passMode) == 1 && markLen == match) ||
            (GetPassModeNameSuffix(passMode) != 1 && c - markLen >= markLen - match)) {
            memset(opts, 0, sizeof(int) * n);
            do {
                // 组织数据
                std::vector<T> tmp;
                for (int i = 0; i < n; i++) {
                    tmp.push_back(origs[idxs[i]][opts[i]]);
                }
                result.push_back(tmp);
                
                opt_carry = true;   // 需要进位
                for (int i = n - 1; opt_carry && i >= 0; i--) {
                    if ((opt_carry = (opts[i] >= lens[idxs[i]] - 1))) {   // 进位
                        opts[i] = 0;
                    } else {
                        opts[i]++;
                    }
                }
            } while (!opt_carry);
        }
        
        idx_carry = true;
        for (int i = n - 1; idx_carry && i >= 0; i--) {
            idx_carry = idxs[i] >= (count - n + i);//opts[i] >= lens[i];
            if (!idx_carry) {
                idxs[i]++;
                for (int j = 1; j < n - i; j++) {
                    idxs[i + j] = idxs[i] + j;
                }
            }
        }
    } while (!idx_carry);
}

template <typename T>
void del_split(std::vector<std::vector<T> *> &result) {
    for (int i = 0; i < result.size(); i++) {
        if (result[i]) {
            result[i]->clear();
            delete result[i];
            result[i] = NULL;
        }
    }
    result.clear();
}
    
OptimizeResult JczqOptimize(JczqCalculaterOption optionList[], int count, int passModes[], int pmCount, int amount) {
    vector< vector<OptimizeOption> > origin;
    vector< vector<OptimizeOption> > result;
    
    int mark[20] = { 0 }, markLen = 0;
    for (int i = 0; i < count; i++) {
        JczqCalculaterOption &betOption = optionList[i];
        vector<OptimizeOption> optimizeList;
        
        for (int i = 0; i < 3; i++) {
            if (betOption.betOptionRqspf[i]) {
                OptimizeOption optimize = { 0 };
                optimize.matchId = betOption.matchId;
                optimize.gameType = GameTypeJcRqspf;
                optimize.index = i;
                optimize.sp = betOption.betSpListRqspf[i];
                optimizeList.push_back(optimize);
            }
        }
        for (int i = 0; i < 31; i++) {
            if (betOption.betOptionBf[i]) {
                OptimizeOption optimize = { 0 };
                optimize.matchId = betOption.matchId;
                optimize.gameType = GameTypeJcBf;
                optimize.index = i;
                optimize.sp = betOption.betSpListBf[i];
                optimizeList.push_back(optimize);
            }
        }
        for (int i = 0; i < 8; i++) {
            if (betOption.betOptionZjq[i]) {
                OptimizeOption optimize = { 0 };
                optimize.matchId = betOption.matchId;
                optimize.gameType = GameTypeJcZjq;
                optimize.index = i;
                optimize.sp = betOption.betSpListZjq[i];
                optimizeList.push_back(optimize);
            }
        }
        for (int i = 0; i < 9; i++) {
            if (betOption.betOptionBqc[i]) {
                OptimizeOption optimize = { 0 };
                optimize.matchId = betOption.matchId;
                optimize.gameType = GameTypeJcBqc;
                optimize.index = i;
                optimize.sp = betOption.betSpListBqc[i];
                optimizeList.push_back(optimize);
            }
        }
        for (int i = 0; i < 3; i++) {
            if (betOption.betOptionSpf[i]) {
                OptimizeOption optimize = { 0 };
                optimize.matchId = betOption.matchId;
                optimize.gameType = GameTypeJcSpf;
                optimize.index = i;
                optimize.sp = betOption.betSpListSpf[i];
                optimizeList.push_back(optimize);
            }
        }
        if (betOption.mark) {
            mark[markLen++] = i;
        }
        origin.push_back(optimizeList);
    }
    
    for (int i = 0; i < pmCount; i++) {
        int passModeTag = passModes[i];
        for (int j = GetPassModeMinSingle(passModeTag); j <= GetPassModeMaxSingle(passModeTag); j++) {
            gen_split(origin, j, passModeTag, mark, markLen, result);
        }
    }
    
    float *sp_addup = new float[result.size()];
    int *bet_multiple = new int[result.size()];
    for (int i = 0; i < result.size(); i++) {
        vector<OptimizeOption> &list = result[i];
        sp_addup[i] = 1;
        for (int j = 0; j < list.size(); j++) {
            OptimizeOption &option = list[j];
            sp_addup[i] *= option.sp;
        }
    }
    balance(bet_multiple, sp_addup, (int)result.size(), amount);
    
    OptimizeResult optimizeResult;
    optimizeResult.result = result;
    for (int i = 0; i < result.size(); i++) {
        optimizeResult.sp.push_back(sp_addup[i]);
        optimizeResult.multiple.push_back(bet_multiple[i]);
    }
    
    delete [] sp_addup;
    delete [] bet_multiple;
    
    return optimizeResult;
}
    
}