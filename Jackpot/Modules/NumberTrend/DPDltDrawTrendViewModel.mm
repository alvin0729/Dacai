//
//  DPDltDrawTrendViewModel.m
//  Jackpot
//
//  Created by wufan on 15/9/23.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPDltDrawTrendViewModel.h"
#import <AlgorithmToolkit/LotteryType.h>
#import "DrawTrend.pbobjc.h"

@interface DPDltDrawTrendViewModel () {
@private
    struct {
        int GameCount;
        bool HasData;
        int *GameNames;
        CTrendChartCell *RedCell;       // 红球
        CTrendChartCell *BlueCell;      // 篮球
        CTrendChartCell *OneAreaCell;   // 一区
        CTrendChartCell *TwoAreaCell;   // 二区
        CTrendChartCell *ThreeAreaCell; // 三区
    } _trendChart;
}

@property (nonatomic, strong) NSURLSessionDataTask *task;
@end

@implementation DPDltDrawTrendViewModel

#pragma mark - Life cycle

- (instancetype)init {
    if (self = [super init]) {
        _trendChart.GameCount = 200;
    }
    return self;
}

- (void)dealloc {
    if (_trendChart.GameNames) {
        delete [] _trendChart.GameNames;
        _trendChart.GameNames = NULL;
    }
    if (_trendChart.RedCell) {
        delete _trendChart.RedCell;
        _trendChart.RedCell = NULL;
    }
    if (_trendChart.BlueCell) {
        delete _trendChart.BlueCell;
        _trendChart.BlueCell = NULL;
    }
    if (_trendChart.OneAreaCell) {
        delete _trendChart.OneAreaCell;
        _trendChart.OneAreaCell = NULL;
    }
    if (_trendChart.TwoAreaCell) {
        delete _trendChart.TwoAreaCell;
        _trendChart.TwoAreaCell = NULL;
    }
    if (_trendChart.ThreeAreaCell) {
        delete _trendChart.ThreeAreaCell;
        _trendChart.ThreeAreaCell = NULL;
    }
    [self.task cancel];
}

#pragma mark - Public Interface

- (BOOL)hasData {
    return _trendChart.HasData;
}

- (void)fetch {
    if (self.task) {
        return;
    }
    
    @weakify(self);
    self.task = [[AFHTTPSessionManager dp_sharedManager] GET:@"/dlt/chart"
        parameters:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
            @strongify(self);
            [self parserMessage:[PBMDrawTrend parseFromData:responseObject error:nil]];
            [self setTask:nil];
            if ([self.delegate respondsToSelector:@selector(trendViewModel:error:)]) {
                [self.delegate trendViewModel:self error:nil];
            }
        }
        failure:^(NSURLSessionDataTask *task, NSError *error){
            @strongify(self);
            [self setTask:nil];
            if ([self.delegate respondsToSelector:@selector(trendViewModel:error:)]) {
                [self.delegate trendViewModel:self error:error];
            }
        }];
}

- (void)getChartGameNames:(int[200])gameNames count:(int)count {
    if (!_trendChart.HasData) {
        return;
    }
    for (int i = 0; i < count; i++) {
        gameNames[i] = _trendChart.GameNames[_trendChart.GameCount - i - 1];
    }
}

- (void)getChartNormalRed:(int[200][35])redValue blue:(int[200][12])blueValue count:(int)count {
    if (!_trendChart.HasData) {
        return;
    }
    for (int i = 0; i < count; i++) {
        memcpy(redValue[i], _trendChart.RedCell->mMissNumber[_trendChart.GameCount - i - 1], 35 * sizeof(int));
        memcpy(blueValue[i], _trendChart.BlueCell->mMissNumber[_trendChart.GameCount - i - 1], 12 * sizeof(int));
    }
}

- (void)getChartOneAreaRed:(int[200][12])redValue area:(int[200][6])areaValue count:(int)count {
    if (!_trendChart.HasData) {
        return;
    }
    for (int i = 0; i < count; i++) {
        memcpy(redValue[i], _trendChart.RedCell->mMissNumber[_trendChart.GameCount - i - 1], 12 * sizeof(int));
        memcpy(areaValue[i], _trendChart.OneAreaCell->mMissNumber[_trendChart.GameCount - i - 1], 6 * sizeof(int));
    }
}

- (void)getChartTwoAreaRed:(int[200][11])redValue area:(int[200][6])areaValue count:(int)count {
    if (!_trendChart.HasData) {
        return;
    }
    for (int i = 0; i < count; i++) {
        memcpy(redValue[i], _trendChart.RedCell->mMissNumber[_trendChart.GameCount - i - 1] + 12, 11 * sizeof(int));
        memcpy(areaValue[i], _trendChart.TwoAreaCell->mMissNumber[_trendChart.GameCount - i - 1], 6 * sizeof(int));
    }
}

- (void)getChartThreeAreaRed:(int[200][12])redValue area:(int[200][6])areaValue count:(int)count {
    if (!_trendChart.HasData) {
        return;
    }
    for (int i = 0; i < count; i++) {
        memcpy(redValue[i], _trendChart.RedCell->mMissNumber[_trendChart.GameCount - i - 1] + 23, 12 * sizeof(int));
        memcpy(areaValue[i], _trendChart.ThreeAreaCell->mMissNumber[_trendChart.GameCount - i - 1], 6 * sizeof(int));
    }
}

- (void)getChartStatisticsValue:(int[4][47])value type:(int)type count:(int)count {
    if (!_trendChart.HasData) {
        return;
    }
    if (type == 0) {
        int *buffer1 = new int[4 * 35];
        int *buffer2 = new int[4 * 12];
        _trendChart.RedCell->Statistics(count, buffer1);
        _trendChart.BlueCell->Statistics(count, buffer2);
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < 35; j++) {
                value[i][j] = buffer1[i * 35 + j];
            }
            for (int j = 0; j < 12; j++) {
                value[i][j + 35] = buffer2[i * 12 + j];
            }
        }
        delete [] buffer1;
        delete [] buffer2;
        return;
    }
    
    int *buffer1 = new int[4 * 35];
    int *buffer2 = new int[4 * 6];
    CTrendChartCell *areaCell = NULL;
    switch (type) {
        case 1:
            areaCell = _trendChart.OneAreaCell;
            break;
        case 2:
            areaCell = _trendChart.TwoAreaCell;
            break;
        case 3:
            areaCell = _trendChart.ThreeAreaCell;
            break;
        default:
            NSParameterAssert(NO);
            break;
    }
    _trendChart.RedCell->Statistics(count, buffer1);
    areaCell->Statistics(count, buffer2);
    int len[3] = { 12, 11, 12 };
    int idx[3] = { 0, 12, 23 };
    for (int i = 0; i < 4; i++) {
        NSParameterAssert(type >= 1 && type <= 3);
        int length = len[type - 1];
        int offset = idx[type - 1];
        for (int j = 0; j < length; j++) {
            value[i][j] = buffer1[i * 35 + j + offset];
        }
        for (int j = 0; j < 6; j++) {
            value[i][j + length] = buffer2[i * 6 + j];
        }
    }
    delete [] buffer1;
    delete [] buffer2;
    return;
}

#pragma mark - Internal Interface

- (void)parserMessage:(PBMDrawTrend *)message {
    NSParameterAssert(message.initMissArray.count == 65);
    NSParameterAssert(message.allCountArray.count == 65);
    NSParameterAssert(message.avgMissArray.count == 65);
    NSParameterAssert(message.maxMissArray.count == 65);
    NSParameterAssert(message.maxComboArray.count == 65);
    NSParameterAssert(message.drawResultArray.count == 200);
    
    int red = 35, blue = 12, oneArea = 6, twoArea = 6, threeArea = 6;
    
    if (_trendChart.RedCell == NULL) {
        _trendChart.RedCell = new CTrendChartCell(_trendChart.GameCount, red);
    }
    if (_trendChart.BlueCell == NULL) {
        _trendChart.BlueCell = new CTrendChartCell(_trendChart.GameCount, blue);
    }
    if (_trendChart.OneAreaCell == NULL) {
        _trendChart.OneAreaCell = new CTrendChartCell(_trendChart.GameCount, oneArea);
    }
    if (_trendChart.TwoAreaCell == NULL) {
        _trendChart.TwoAreaCell = new CTrendChartCell(_trendChart.GameCount, twoArea);
    }
    if (_trendChart.ThreeAreaCell == NULL) {
        _trendChart.ThreeAreaCell = new CTrendChartCell(_trendChart.GameCount, threeArea);
    }
    if (_trendChart.GameNames == NULL) {
        _trendChart.GameNames = new int[_trendChart.GameCount];
    }
    
    // 红球
    for (int i = 0, j = 0; i < 35; i++, j++) {
        _trendChart.RedCell->mInitMiss[i] = [message.initMissArray valueAtIndex:j];
        _trendChart.RedCell->mAppearCount[i] = [message.allCountArray valueAtIndex:j];
        _trendChart.RedCell->mAvgMiss[i] = [message.avgMissArray valueAtIndex:j];
        _trendChart.RedCell->mMaxMiss[i] = [message.maxMissArray valueAtIndex:j];
        _trendChart.RedCell->mMaxCombo[i] = [message.maxComboArray valueAtIndex:j];
    }
    // 篮球
    for (int i = 0, j = 35; i < 12; i++, j++) {
        _trendChart.BlueCell->mInitMiss[i] = [message.initMissArray valueAtIndex:j];
        _trendChart.BlueCell->mAppearCount[i] = [message.allCountArray valueAtIndex:j];
        _trendChart.BlueCell->mAvgMiss[i] = [message.avgMissArray valueAtIndex:j];
        _trendChart.BlueCell->mMaxMiss[i] = [message.maxMissArray valueAtIndex:j];
        _trendChart.BlueCell->mMaxCombo[i] = [message.maxComboArray valueAtIndex:j];
    }
    // 一区
    for (int i = 0, j = 47; i < 6; i++, j++) {
        _trendChart.OneAreaCell->mInitMiss[i] = [message.initMissArray valueAtIndex:j];
        _trendChart.OneAreaCell->mAppearCount[i] = [message.allCountArray valueAtIndex:j];
        _trendChart.OneAreaCell->mAvgMiss[i] = [message.avgMissArray valueAtIndex:j];
        _trendChart.OneAreaCell->mMaxMiss[i] = [message.maxMissArray valueAtIndex:j];
        _trendChart.OneAreaCell->mMaxCombo[i] = [message.maxComboArray valueAtIndex:j];
    }
    // 二区
    for (int i = 0, j = 53; i < 6; i++, j++) {
        _trendChart.TwoAreaCell->mInitMiss[i] = [message.initMissArray valueAtIndex:j];
        _trendChart.TwoAreaCell->mAppearCount[i] = [message.allCountArray valueAtIndex:j];
        _trendChart.TwoAreaCell->mAvgMiss[i] = [message.avgMissArray valueAtIndex:j];
        _trendChart.TwoAreaCell->mMaxMiss[i] = [message.maxMissArray valueAtIndex:j];
        _trendChart.TwoAreaCell->mMaxCombo[i] = [message.maxComboArray valueAtIndex:j];
    }
    // 三区
    for (int i = 0, j = 59; i < 6; i++, j++) {
        _trendChart.ThreeAreaCell->mInitMiss[i] = [message.initMissArray valueAtIndex:j];
        _trendChart.ThreeAreaCell->mAppearCount[i] = [message.allCountArray valueAtIndex:j];
        _trendChart.ThreeAreaCell->mAvgMiss[i] = [message.avgMissArray valueAtIndex:j];
        _trendChart.ThreeAreaCell->mMaxMiss[i] = [message.maxMissArray valueAtIndex:j];
        _trendChart.ThreeAreaCell->mMaxCombo[i] = [message.maxComboArray valueAtIndex:j];
    }
    
    // 开奖号码
    for (int i = 0; i < _trendChart.GameCount; i++) {
        PBMDrawTrend_Result *result = [message.drawResultArray objectAtIndex:i];
        
        NSParameterAssert(result.numbersArray.count == 7);
        
        int nums[7] = { 0 };
        int oneCount = 0, twoCount = 0, threeCount = 0;
        for (int j = 0; j < 7; j++) {
            nums[j] = [result.numbersArray valueAtIndex:j];
            
            if (j < 5) {    // 红球
                if (nums[j] <= 12) {
                    oneCount++;
                } else if (nums[j] <= 23) {
                    twoCount++;
                } else {
                    threeCount++;
                }
            }
        }
        _trendChart.GameNames[i] = result.gameName.intValue;
        
        if (i == 0) {
            memcpy(_trendChart.RedCell->mMissNumber[i], _trendChart.RedCell->mInitMiss, sizeof(int) * 35);
            memcpy(_trendChart.BlueCell->mMissNumber[i], _trendChart.BlueCell->mInitMiss, sizeof(int) * 12);
            memcpy(_trendChart.OneAreaCell->mMissNumber[i], _trendChart.OneAreaCell->mInitMiss, sizeof(int) * 6);
            memcpy(_trendChart.TwoAreaCell->mMissNumber[i], _trendChart.TwoAreaCell->mInitMiss, sizeof(int) * 6);
            memcpy(_trendChart.ThreeAreaCell->mMissNumber[i], _trendChart.ThreeAreaCell->mInitMiss, sizeof(int) * 6);
            
            _trendChart.OneAreaCell->mMissNumber[i][oneCount] = -1;
            _trendChart.TwoAreaCell->mMissNumber[i][twoCount] = -1;
            _trendChart.ThreeAreaCell->mMissNumber[i][threeCount] = -1;
        } else {
            for (int j = 0; j < 35; j++) {
                _trendChart.RedCell->mMissNumber[i][j] = std::max(0, _trendChart.RedCell->mMissNumber[i - 1][j]) + 1;
            }
            for (int j = 0; j < 12; j++) {
                _trendChart.BlueCell->mMissNumber[i][j] = std::max(0, _trendChart.BlueCell->mMissNumber[i - 1][j]) + 1;
            }
            // 统计遗漏值和连出值
            for (int j = 0; j < 6; j++) {
                if (j == oneCount) {
                    _trendChart.OneAreaCell->mMissNumber[i][j] = std::min(_trendChart.OneAreaCell->mMissNumber[i - 1][j], 0) - 1;
                } else {
                    _trendChart.OneAreaCell->mMissNumber[i][j] = std::max(_trendChart.OneAreaCell->mMissNumber[i - 1][j], 0) + 1;
                }
                if (j == twoCount) {
                    _trendChart.TwoAreaCell->mMissNumber[i][j] = std::min(_trendChart.TwoAreaCell->mMissNumber[i - 1][j], 0) - 1;
                } else {
                    _trendChart.TwoAreaCell->mMissNumber[i][j] = std::max(_trendChart.TwoAreaCell->mMissNumber[i - 1][j], 0) + 1;
                }
                if (j == threeCount) {
                    _trendChart.ThreeAreaCell->mMissNumber[i][j] = std::min(_trendChart.ThreeAreaCell->mMissNumber[i - 1][j], 0) - 1;
                } else {
                    _trendChart.ThreeAreaCell->mMissNumber[i][j] = std::max(_trendChart.ThreeAreaCell->mMissNumber[i - 1][j], 0) + 1;
                }
            }
        }
        
        // 中奖号高亮
        for (int j = 0; j < 7; j++) {
            if (j < 5) {
                _trendChart.RedCell->mMissNumber[i][nums[j] - 1] = -1;
            } else {
                _trendChart.BlueCell->mMissNumber[i][nums[j] - 1] = -1;
            }
        }
    }
    
    _trendChart.HasData = true;
}

@end
