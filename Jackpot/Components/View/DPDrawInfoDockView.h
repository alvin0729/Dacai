//
//  DPDrawInfoDockView.h
//  DacaiProject
//
//  Created by Ray on 15/2/12.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DPDrawInfoDockDelegate <NSObject>

-(void)changeDocIndex:(NSInteger)index ;

@end

@interface DPDrawInfoDockView : UIView
@property(nonatomic,weak)id<DPDrawInfoDockDelegate>delegate ;
@property(nonatomic,strong)NSArray*titleArray ;
@property(nonatomic,assign)NSInteger currentDocIndex ;
@property(nonatomic,strong)UIImage *selectBGImg ;//选中背景色
@property(nonatomic,strong)UIImage *normalBGImg ;//正常背景色
@property(nonatomic,strong)UIColor *middleLineColor ;//中间分隔线颜色



/**
 *  创建UI
 *
 *  @param titleArray 标题下选项名称
 *  @param selectColor 选中文字颜色
 *  @param normalColor 正常文字颜色
 *  @param bottomImg 指示图片
 
 *
 *  @return cmdId
 */

- (instancetype)initWithTitles:(NSArray*)titleArray bottomImg:(UIImage*)botomImg selectColor:(UIColor*)selectColor normalColor:(UIColor*)normalColor;


@end

#define kTextFont 15
#define DrawTag 1000

