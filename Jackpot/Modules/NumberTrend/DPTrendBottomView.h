//
//  DPTrendBottomView.h
//  DacaiProject
//
//  Created by sxf on 15/2/13.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  走势图底部选号视图

#import <UIKit/UIKit.h>
@protocol DPTrendBottomViewDelegate;

#define UIbuttonTagIndex 10000
@interface DPTrendBottomView : UIView {
    UIView *_upHline, *_downHLine, *_leftSLine, *_rightSLine;
}
@property (nonatomic, weak) id<DPTrendBottomViewDelegate> delegate;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) UIView *upHline, *downHLine, *leftSLine, *rightSLine; //上边线，中间线，左侧（选号）线，右侧边界线
@property (nonatomic, strong) UIButton *finishButton;                                         //完成
@property (nonatomic, assign) float ballsHeight;
@property (nonatomic, strong) NSArray *rowWidthArray; //宽度
//生成投注页面
- (void)createTrendBottomBallView:(NSArray *)redballArray        //前区文字
                        blueArray:(NSArray *)blueBallArray       //后区文字(如果只有一种情况，则传为空)
                         rowWidth:(float)rowWidth                //每一列宽度
              normalBallTextColor:(UIColor *)normalColor         //字体颜色
              selectBallTextColor:(UIColor *)selectextColor      //选中字体颜色
                  normalbackImage:(UIImage *)normalBackImage     //单元格背景图片
               selectRedBackImage:(UIImage *)selectRedBackImage  //前区选中单元格背景图片
              selectBlueBackImage:(UIImage *)selectBlueBackImage //后区选中单元格背景图片
                          redBall:(int *)redBall
                         blueBall:(int *)blueBall;

- (void)selectedballInfoLabelText:(NSMutableAttributedString *)infoString; //得到投注内容
- (void)gainLayOutWidthForTitlelabel:(float)width;                         //改变title 的宽度
- (void)optionstitleColor:(UIColor *)color;                                //选号颜色
- (void)optionsSelectedTitleColor:(UIColor *)color;                        //已选颜色
@end

@protocol DPTrendBottomViewDelegate <NSObject>
@optional
//滚动数据
- (void)trendBottomView:(DPTrendBottomView *)trendView offset:(CGPoint)offset;

//保存选中的小球
- (void)saveSelectedBallForBottomView:(NSInteger)index isSelected:(BOOL)isSelected;

//完成选择返回上一页
- (void)finishedSelectedBallForBottomView;
@end