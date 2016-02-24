//
//  DPJczqOptimizeCell.h
//  Jackpot
//
//  Created by Ray on 15/12/8.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPJczqOptimizeModel.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, OptimizeCellType) {
    OptimizeCellTypeNormal,
    OptimizeCellTypeFold,
};

const static NSInteger kRowHeight = 26;
/**
 *  对阵信息视图
 */
@interface DPMatchInfoView : UIView
/**
 *  match 数组
 */
@property (strong, nonatomic) NSArray *matchArray;

@end

//// 加减视图
@interface DPMinusPlusView : UITextField

@end

@class DPJczqOptimizeCell;
typedef void (^DPShowMatch)(DPJczqOptimizeCell *curCell);
typedef void (^DPChangeValue)(DPJczqOptimizeCell *curCell);
@interface DPJczqOptimizeCell : UITableViewCell
/**
 *  显示详情
 */
@property (nonatomic, copy) DPShowMatch showMatch;        //查看详情
@property (nonatomic, copy) DPChangeValue changeValue;    //数值改变
@property (nonatomic, strong) DPJczqOptimizeModel *modelData;

@property (nonatomic, strong, readonly) DPMinusPlusView *countView;

@property (nonatomic, strong) NSString *lastNumString;    //上一次的值
@property (nonatomic, strong) UILabel *awardLab;          //奖金

- (id)initWithCellStyle:(OptimizeCellType)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)analysisViewIsExpand:(BOOL)isExpand;    //箭头变化

@end
