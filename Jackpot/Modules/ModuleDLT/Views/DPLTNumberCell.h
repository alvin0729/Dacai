//
//  DPLTNumberCell.h
//  DacaiProject
//
//  Created by WUFAN on 15/1/9.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  数字彩中转cell

#import <UIKit/UIKit.h>
#import "DPLTNumberProtocol.h"

@interface DPLTNumberCell : UITableViewCell

@property (nonatomic, weak) id <DPLTNumberMutualDelegate> delegate;
//计算当前行的高度
+ (NSInteger)heightForNumberContent:(NSString *)string;
//数据源刷新
- (void)styleForModel:(id<DPLTNumberCellDataSource>)model;
//- (void)dp_resetHighlighted:(BOOL)highlighted;
@end

  