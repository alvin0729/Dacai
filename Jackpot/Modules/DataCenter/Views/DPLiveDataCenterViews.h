//
//  DPLiveDataCenterViews.h
//  DacaiProject
//
//  Created by WUFAN on 14-9-1.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPImageLabel.h"
#import <UIKit/UIKit.h>

#define labelTag 10000

extern NSString *g_homeName;
extern NSString *g_awayName;

@interface DPLiveOddsHeaderView : UIView

/**
 *  文字大小
 */
@property (nonatomic, strong) UIFont *titleFont;
/**
 *  文字颜色
 */
@property (nonatomic, strong) UIColor *textColors;
@property (nonatomic, strong) CALayer *bottmoLayer;    //底部线条
/**
 *  行数
 */
@property (nonatomic, assign) NSInteger numberOfLabLines;

/**
 *  没有边缘框
 *
 *  @return DPLiveOddsHeaderView
 */
- (instancetype)initWithNoLayer;
/**
 *  初始化
 *
 *  @param yesOrno 有没有顶部线条
 *  @param height  高度
 *  @param width   宽度
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithTopLayer:(BOOL)yesOrno withHigh:(CGFloat)height withWidth:(CGFloat)width;
/**
 *  初始化
 *
 *  @param yesOrno 有没有顶部线条
 *  @param bottom  有无底部线条
 *  @param height  高度
 *  @param width   宽度
 *
 *  @return
 */
- (instancetype)initWithTopLayer:(BOOL)yesOrno bottomLayer:(BOOL)bottom withHigh:(CGFloat)height withWidth:(CGFloat)width;
/**
 *  初始化
 *
 *  @param yesOrno 有无顶部线条
 *  @param bottom  底部线条
 *  @param height  高度
 *  @param width   宽度
 *  @param color   线条颜色
 *
 *  @return
 */
- (instancetype)initWithTopLayer:(BOOL)yesOrno bottomLayer:(BOOL)bottom withHigh:(CGFloat)height withWidth:(CGFloat)width lineColor:(UIColor *)color;

/**
 *  改变行数 默认1行
 *
 *  @param index       label的位置
 *  @param  number 行数
 */

- (void)changeNumberOfLinesWithIndex:(NSInteger)index withNumber:(NSInteger)number;
/**
 *  改变某行字体大小
 *
 *  @param index       label的位置
 *  @param font       文字大小

 */
- (void)changeFontWithIndex:(NSInteger)index withFont:(UIFont *)font;
/**
 *  根据宽和高创建label
 *
 *  @param widthArray       各个label的宽度
 *  @param hight           各个label的高度
 *  @param yesOrNo           是否有分隔线

 */

- (void)createHeaderWithWidthArray:(NSArray *)widthArray whithHigh:(CGFloat)hight withSeg:(BOOL)yesOrNo;
/**
 *  根据宽和高创建label
 *
 *  @param widthArray       各个label的宽度
 *  @param hight           各个label的高度
 *  @param indexArray          分隔线位置 0不要右边分割线  1:要右边分割线
 
 */

- (void)createHeaderWithWidthArray:(NSArray *)widthArray whithHigh:(CGFloat)hight withSegIndexArray:(NSArray *)indexArray;

/**
 *  设置各个label的文字
 *
 *  @param titleArray       各个label文字
 
 */

- (void)setTitles:(NSArray *)titleArray;

/**
 *  设置各个label的文字颜色
 *
 *  @param colorsArray       各个label文字颜色
 
 */
- (void)changeAllTitleColor:(UIColor *)color;
- (void)settitleColors:(NSArray *)colorsArray;
/**
 *  设置背景色
 *
 *  @param bgColorsArray 颜色数组
 */
- (void)setBgColors:(NSArray *)bgColorsArray;

/**
 *  改变对齐方式
 *
 *  @param index         位置
 *  @param textAlignment 对齐方式
 */
- (void)changeTextAlignWithIndex:(NSInteger)index withAlig:(NSTextAlignment)textAlignment;

@end

//// 技术统计/各项高分

@interface DPLCCompetitionStateCell : UITableViewCell
@property (nonatomic, strong) DPLiveOddsHeaderView *cellView;
@property (nonatomic, strong) UIView *homeBar;         //左边线条
@property (nonatomic, strong) UIView *awayBar;         //右边线条
@property (nonatomic, strong) CALayer *bottmoLayer;    //底部线条
/**
 *  初始化
 *
 *  @param widthArray      宽度数组
 *  @param reuseIdentifier reuseIdentifier
 *  @param height          高度
 *  @param segIndexArr     是否有分割线数组 1：有 0 ：无
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithItemWithArray:(NSArray *)widthArray reuseIdentifier:(NSString *)reuseIdentifier withHigh:(CGFloat)height segIndexArray:(NSArray *)segIndexArr;

@end

//// 技术统计

@interface DPLiveCompetitionStateCell : UITableViewCell
@property (nonatomic, strong) DPLiveOddsHeaderView *cellView;
@property (nonatomic, strong) UIView *homeBar;         //左边线条
@property (nonatomic, strong) UIView *awayBar;         //右边线条
@property (nonatomic, strong) CALayer *bottmoLayer;    //底部线条
/**
 *  初始化
 *
 *  @param widthArray      宽度数组
 *  @param reuseIdentifier reuseIdentifier
 *  @param height          高度
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithItemWithArray:(NSArray *)widthArray reuseIdentifier:(NSString *)reuseIdentifier withHigh:(CGFloat)height;

@end

@interface DPLiveDataCenterSectionHeaderView : UITableViewHeaderFooterView
/**
 *  标题Label
 */
@property (nonatomic, strong, readonly) UILabel *titleLabel;

@end

@interface DPLiveAnalysisViewCell : UITableViewCell
@property (nonatomic, strong) DPLiveOddsHeaderView *rootbgView;
/**
 *  初始化
 *
 *  @param widArray        宽度数组
 *  @param reuseIdentifier reuseIdentifier
 *  @param height          高度
 *
 *  @return DPLiveAnalysisViewCell
 */
- (instancetype)initWithWidthArray:(NSArray *)widArray reuseIdentifier:(NSString *)reuseIdentifier withHight:(CGFloat)height;
@end

/**
 *  无数据cell
 */
@interface DPLiveNoDataCell : UITableViewCell

@property (nonatomic, strong) DPImageLabel *noDataImgView;

@end

@interface DPFutureView : UIView
/**
 *  球队名
 */
@property (nonatomic, strong, readonly) UILabel *nameLabel;
/**
 *  时间
 */
@property (nonatomic, strong, readonly) UILabel *timeLabel;
/**
 *  左边球队图标
 */
@property (nonatomic, strong, readonly) UIImageView *leftImgView;
/**
 *  右边球队图标
 */
@property (nonatomic, strong, readonly) UIImageView *rightImgView;
/**
 *  左边文字
 */
@property (nonatomic, strong, readonly) UILabel *leftLabel;
/**
 *  右边文字
 */
@property (nonatomic, strong, readonly) UILabel *rightLabel;
/**
 *  无数据视图
 */
@property (nonatomic, strong, readonly) UIImageView *nodataView;
;

@end

@interface DPAnalysisFutureCell : UITableViewCell

@property (nonatomic, strong, readonly) DPFutureView *leftView;
@property (nonatomic, strong, readonly) DPFutureView *rightView;

@end

@interface DPHistoryView : UIView
/**
 *  比例数组
 */
@property (nonatomic, strong) NSArray *percentArray;
/**
 *  标题数组
 */
@property (nonatomic, strong) NSArray *titleArray;

@end

@interface DPAnalysisHistoryCell : UITableViewCell

@property (nonatomic, strong, readonly) DPHistoryView *historyView;

@end

/**
 *  近期战绩视图
 */
@interface DPRecentView : UIView
@property (nonatomic, strong, readonly) UILabel *titleLabel;
/**
 *  近期战绩状态（负-1 平0 ,胜1）数组
 */
@property (nonatomic, strong) NSArray *recentArray;
/**
 *  初始化
 *
 *  @param type 彩种类型
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithGameType:(GameTypeId)type;

@end

@interface DPAnalysicRecentCell : UITableViewCell
/**
 *  左边近期战绩
 */
@property (nonatomic, strong, readonly) DPRecentView *leftRecentView;
/**
 *  右边近期战绩
 */
@property (nonatomic, strong, readonly) DPRecentView *rightRecentView;
/**
 *  初始化
 *
 *  @param type            彩种类型
 *  @param reuseIdentifier reuseIdentifier
 *
 *  @return <#return value description#>
 */
- (id)initWithGameType:(GameTypeId)type reuseIdentifier:(NSString *)reuseIdentifier;

@end

@interface DPLCHistoryView : UIView

@property (nonatomic, strong) NSArray *percentArray;
@property (nonatomic, strong) NSArray *teamNameArray;

@property (nonatomic, strong) NSArray *scoreArray;

@end

@interface DPAnalysisLCHistoryCell : UITableViewCell

@property (nonatomic, strong, readonly) DPLCHistoryView *historyView;

@end

/**
 *  大小分饼图
 */
@interface DPLCPlotView : UIView
/**
 *  大小分次数数组
 */
@property (nonatomic, strong) NSArray *scoreArray;

@end

@interface DPLCRecentCell : UITableViewCell
/**
 *  左边圆饼图
 */
@property (nonatomic, strong, readonly) DPLCPlotView *leftPlotView;
/**
 *  右边圆饼图
 */
@property (nonatomic, strong, readonly) DPLCPlotView *rightPlotView;

@end
