//
//  DPJcdgTableCells.h
//  DacaiProject
//
//  Created by jacknathan on 15-1-16.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  单关相关单元格

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DPJcdgDataModel.h"

@interface UITableViewCell (DPJcdgAddition)
/**
 *  赋值
 *
 *  @param dataModel 数据model
 */

- (void)dp_setCelldataModel:(id)dataModel;

@end

@implementation UITableViewCell (DPJcdgAddition)

- (void)dp_setCelldataModel:(id)dataModel
{
    // 重写
}

@end


@protocol DPJcdgTeamsViewDelegate;
@interface DPJcdgTeamsView : UIView
@property (nonatomic, strong, readonly)UIScrollView *scrollView; // 滚动视图
@property (nonatomic, weak) id <DPJcdgTeamsViewDelegate> delegate;
@property (nonatomic, assign) int gameCount; // 比赛场次
@property(nonatomic,assign)MyGameType myGameType ;

-(void)cleanAllTeamView ;//清空数据

- (void)setSingleTeamAtIndex:(NSInteger)index withDataModel:(DPJcdgPerTeamModel *)model;
/**
 *  区分足球或篮球
 *
 *  @param type <#type description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithGameType:(MyGameType)type ;


@end


@class DPJcdgGameTypeBasicCell ;

@protocol DPJcdgBottomDelegate <NSObject>
/**
 *  点击立即购买
 *
 *  @param cell  当前cell
 *  @param times 倍数
 */
 - (void)bottomCommit:(DPJcdgGameTypeBasicCell *)cell times:(int)times;
/**
 *  点击奖金优化
 *
 *  @param cell  当前cell
 *  @param times 倍数
 */
- (void)bottomBonusBetterClick:(DPJcdgGameTypeBasicCell *)cell times:(NSString *)times;
/**
 *  结束编辑
 *
 *  @param cell 当前cell
 *  @param text 输入框文字
 */
- (void)bottomOfCell:(DPJcdgGameTypeBasicCell *)cell endEditingWithText:(NSString *)text;
/**
 *  键盘响应
 *
 *  @param cell       当前cell
 *  @param event      键盘事件
 *  @param curve      动画
 *  @param duration   时间
 *  @param frameBegin 开始位置
 *  @param frameEnd   结束位置
 */
- (void)bottomOfCell:(DPJcdgGameTypeBasicCell *)cell keyboardVisible:(BOOL)keyboardVisible options:(UIViewAnimationOptions)options duration:(CGFloat)duration frameBegin:(CGRect)frameBegin frameEnd:(CGRect)frameEnd;
@end


@protocol DPJcdgTeamsViewDelegate <NSObject>
/**
 *  滚动栏切换
 *
 *  @param oldPage 上一个页面
 *  @param newPage 新的页面
 */
- (void)gamePageChangeFromPage:(int)oldPage toNewPage:(int)newPage;
@end

 @protocol DPJcdgGameBasicCellDelegate;

@class  UUBar ;
/**
 *  玩法cell基类
 */
@interface DPJcdgGameTypeBasicCell : UITableViewCell
{
    NSString *_warnContent;
    
    UIView *headViewBg ;
    
    MyGameType _myGameType ;
    
    NSInteger _gameIndex ;//当前比赛id
    
    BOOL _hasLoaded ;

}
@property (nonatomic, strong, readonly)UITextField *gameTypeLabel; // 玩法
@property (nonatomic, assign) GameTypeId gameType; // 玩法类型

@property (nonatomic, weak) id <DPJcdgGameBasicCellDelegate> delegate;

@property (nonatomic, weak) id <DPJcdgBottomDelegate> bottomDelegate;

@property (nonatomic, strong) NSString *warnContent; // 玩法说明
@property (nonatomic, strong, readonly) UIImageView *flagView;

/**
 *  创建带有柱形图的按钮
 *
 *  @param contentView 根view
 *  @param percentBar  柱形图
 *  @param teamNameBtn 球队名称按钮
 */
- (void)buildView:(UIView *)contentView withPercent:(UUBar *)percentBar teamNameBtn:(UIButton *)teamNameBtn ;
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier WithGameType:(MyGameType)type ;
/**
 *  刷新金额
 *
 *  @param timesText 倍数
 *  @param gameIndex 当前比赛索引
 */
- (void)dp_reloadMoneyWithTimeTex:(NSString *)timesText gameIndex:(int)gameIndex;

- (void)buildCommonUI ;


@end

@protocol DPJcdgGameBasicCellDelegate <NSObject>

/**
 *  点击事件
 *
 *  @param cell       当前cell
 *  @param gameType   当前gametype
 *  @param index      在cell中的序号
 *  @param isSelected 是否选中
 */
- (void)clickButtonWithCell:(DPJcdgGameTypeBasicCell *)cell gameType:(int)gameType index:(int)index isSelected:(BOOL)isSelected;
/**
 *  玩法说明
 *
 *  @param cell 当前cell
 */
- (void)dpjcdgInfoButtonClick:(DPJcdgGameTypeBasicCell *)cell;
@end



typedef enum : NSUInteger {
    KSfRfsfType = 0,
    KSfSfType = 0,
} KRfsfDetailType;
/**
 * 篮球让分胜负/胜负
 */
@interface DPJcdgBasketRfsfCell : DPJcdgGameTypeBasicCell
//- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier WithGameType:(MyGameType)type ;


@end

/**
 * 篮球大小分
 */
@interface DPJcdgBasketDxfCell : DPJcdgGameTypeBasicCell
//- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier WithGameType:(MyGameType)type ;


@end

/**
 * 篮球胜分差
 */

@interface DPjcdgBasketSfcCell : DPJcdgGameTypeBasicCell
//- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier WithGameType:(MyGameType)type ;

@end


// 让球胜平负
typedef enum {
    KSpfTypeRqspf = 0,
    KSpfTypeSpf,
} KSpfDetailType;
/**
 *  足球让球胜平负/胜平负
 */
 @interface DPjcdgTypeRqspfCell : DPJcdgGameTypeBasicCell
@end

 /**
 *  足球总进球
 */
@interface DPjcdgAllgoalCell : DPJcdgGameTypeBasicCell
@end

 /**
 *  足球猜赢球
 */
@interface dpJcdgGuessWinCell : DPJcdgGameTypeBasicCell
@end


 /**
 *  足球玩法说明
 */
@interface DPJcdgWarnView : UIView
@property (nonatomic, strong, readonly)UILabel *gameTypeLabel;
@property (nonatomic, strong) NSString *titleText;
@end


#pragma mark- 创建柱形图
#define KCharWith 50

/**
 *  柱形图视图
 */
@interface UUBar : UIView
{
    KTMCountLabel *_percentLabel ;
    UIView *_bottomView ;
    
    UIView *_chartView;
    
    int _currentPercent;
    
}
@property(nonatomic,strong,readonly) UIView *chartView;

@property (nonatomic,assign) int  currentPercent;




/**
 *  0~1
 */
@property(nonatomic)float chartHight;

- (instancetype)initWithColors:(UIColor*)colors bottomColor:(UIColor*)botColor;


@end
