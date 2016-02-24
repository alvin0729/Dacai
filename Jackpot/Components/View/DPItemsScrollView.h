//
//  DPItemsScrollView.h
//  Jackpot
//
//  Created by mu on 15/8/31.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DPItemsScrollViewItemBlock)(UIButton *btn);
@interface DPItemsScrollView : UIView
/**
 *  按钮所在区域
 */
@property (nonatomic, strong) UIView *btnsView;
/**
 *  所有按钮
 */
@property (nonatomic, strong) NSMutableArray *btnArray;
/**
 *  当前点击btn
 */
@property (nonatomic, strong) UIButton *currentBtn;
/**
 *  上次点击btn
 */
@property (nonatomic, strong) UIButton *lastBtn;
/**
 *  指示器
 */
@property (nonatomic, strong) UIView *indicatorView;
/**
 *  btnView的高度
 */
@property (nonatomic, weak) MASConstraint *btnViewHeight;
/**
 *  指示器的宽
 */
@property (nonatomic, assign) CGFloat indirectorWidth;
/**
 *  指示器的高
 */
@property (nonatomic, assign) CGFloat indirectorHeight;
/**
 *  表格所在区域
 */
@property (nonatomic, strong) UIScrollView *tablesView;
/**
 *  所有view容器
 */
@property (nonatomic, strong) NSMutableArray *viewArray;
/**
 *  item点击
 */
@property (nonatomic, copy) DPItemsScrollViewItemBlock itemTappedBlock;
/**
 *  选择item
 */
@property (nonatomic, assign) NSInteger selectIndex;
/**
 *  初始化
 *
 *  @param frame
 *  @param items 按钮titles
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame andItems:(NSArray *)items;
/**
 *  选择按钮点击
 *
 *  @param btn 按钮
 */
- (void)btnTapped:(UIButton *)btn;
@end
