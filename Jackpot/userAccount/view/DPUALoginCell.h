//
//  DPUALoginCell.h
//  Jackpot
//
//  Created by mu on 15/8/17.
//  Copyright (c) 2015年 dacai. All rights reserved.
// 绑定手机（sxf）

#import <UIKit/UIKit.h>
#import "DPUABaseCell.h"
typedef void (^myBtnBlock)(UIButton *btn);
@interface DPUALoginCell : DPUABaseCell
/**
 *  btnBlock  按钮点击事件回调
 */
@property (nonatomic, copy) myBtnBlock btnBlock;
/**
 *  btn    按钮
 */
@property (nonatomic, strong) UIButton *cellBtn;
/**
 *  text  输入框
 */
@property (nonatomic, strong) UITextField *textField;
/**
 *  uilabel   属性
 */
@property (nonatomic, strong) UILabel *titleLab;

- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
@end
