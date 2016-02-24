//
//  DPBaseDrawVC.h
//  DacaiProject
//
//  Created by Ray on 15/2/9.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  数字走势图父类控制器

#import <UIKit/UIKit.h>
#import "DPDrawTrendImgTool.h"
#import "DPTrendView.h"
#import "DPSegmentedControl.h"
#import "DPDrawInfoDockView.h"
#import "DPTrendBottomView.h"
#import "DPTrendSettingView.h"


@interface DPDrawBaseHeaderView : UIView


@property(nonatomic,strong)DPDrawInfoDockView *dockInfoView ;
@property (nonatomic, strong) DPSegmentedControl *titleSegment;
@property (nonatomic, assign) BOOL supportRotate;
@property (nonatomic, assign) UIInterfaceOrientation orientation; // 方向


@end


@interface DPBaseDrawVC : UIViewController<DPDrawInfoDockDelegate,DPTrendViewDelegate,DPTrendBottomViewDelegate>{

    DPDrawInfoDockView  *_dockView;
    @public
    int _navSelectIndex;//
    DPTrendView *_trendView ;
    DPTrendBottomView *_bottomView;
    GameTypeId _currentGameType ;

}
@property (nonatomic, assign) int defaultIndex;
@property (nonatomic, assign) BOOL supportRation;//是否支持横屏
@property(nonatomic,strong)DPDrawInfoDockView  *dockView;// 选项卡视图
@property(nonatomic,assign)int redBallNumber ;//红球个数
@property(nonatomic,strong,readonly)DPTrendBottomView *bottomView;//走势图-底部视图
@property (nonatomic, strong, readonly)DPTrendSettingView *trendSetting ;//走势图-设置视图
@property (nonatomic, strong) DPDrawBaseHeaderView *headerView;





/**
 *  创建UI
 *
 *  @param titleArray navigation标题
 *  @param docTitles 标题下选项名称
 *  @param selectColor 选中文字颜色
 *  @param normlColor 正常文字颜色
 *  @param bottomImg 指示图片
 *  @param supportRota 是否支持横屏

 *
 *  @return 
 */

- (instancetype)initWithTitles:(NSArray*)titleArray withDocTitles:(NSArray*)docTitles titleSelectColor:(UIColor*)selectColor titleNormalColor:(UIColor*)normlColor bottomImg:(UIImage*)bottomImg ;

- (instancetype)initWithTitles:(NSArray*)titleArray withDocTitles:(NSArray*)docTitles titleSelectColor:(UIColor*)selectColor titleNormalColor:(UIColor*)normlColor bottomImg:(UIImage*)bottomImg supportRota:(BOOL)supportRota ;


-(void)pvt_onSwitch:(DPSegmentedControl*)seg ;


-(DPDrawTrendImgData*)getImageDateWithTextColor:(UIColor*)textColor rowCount:(int)rowCount columnCount:(int)columCount lastCount:(int)lastCount hasLine:(BOOL)hasLine withWinNumbers:(NSArray*)winArray isleft:(BOOL)isleft statOn:(BOOL)statOn isChinese:(BOOL)isChinese ;

-(DPDrawTrendImgData*)getImageDateWithTextColor:(UIColor*)textColor ShapColor:(UIColor*)shpColor rowCount:(int)rowCount columnCount:(int)columCount lastNumbers:(int)lastNumbers hasLine:(BOOL)hasLine withDatas:(int [200][49])DataArray isBottom:(BOOL)isBottom  missOn:(BOOL)missOn hasRightLine:(BOOL)hasRightLine isRightData:(BOOL)isRightData ;


-(DPDrawTrendImgData*)getImageDateWithTextColor:(UIColor*)textColor ShapColor:(UIColor*)shpColor rowCount:(int)rowCount columnCount:(int)columCount lastNumbers:(int)lastNumbers hasLine:(BOOL)hasLine withDatas:(int [200][49])DataArray isBottom:(BOOL)isBottom  missOn:(BOOL)missOn hasRightLine:(BOOL)hasRightLine;

-(void)reloadTrendView:(int)issueNumbers miss:(BOOL)missOn broken:(BOOL)brokenOn stat:(BOOL)statOn info:(BOOL)infoOn ;
- (BOOL)dp_hasData; // 判断底层是否有数据
@end
#define kDockHeight 40
#define kSetBtnWidth 50