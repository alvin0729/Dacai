//
//  DPGSItemsScrollView.m
//  Jackpot
//
//  Created by mu on 15/12/2.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPGSItemsScrollView.h"

@implementation DPGSItemsScrollView

- (instancetype)init{
    self = [super initWithFrame:CGRectZero andItems:@[@"新手任务",@"每日任务",@"成就任务"]];
    if (self) {
        for (NSInteger i = 0; i < self.btnArray.count; i++){
            UIButton *btn = self.btnArray[i];
            btn.backgroundColor = [UIColor dp_flatWhiteColor];
            [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor dp_flatRedColor] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:17];
            if (i==0) {
                [self btnTapped:btn];
            }
            
            UIView *verLine = [[UIView alloc]init];
            verLine.backgroundColor = UIColorFromRGB(0xeef6f9);
            verLine.hidden = i==3;
            [self.btnsView addSubview:verLine];
            [verLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.equalTo(btn.mas_right).offset(0.25);
                make.width.mas_equalTo(0.5);
                make.bottom.mas_equalTo(0);
            }];
            
            UIView *redPointView = [[UIView alloc]init];
            redPointView.backgroundColor = [UIColor dp_flatRedColor];
            redPointView.layer.cornerRadius = 4;
            redPointView.tag = 210+i;
            redPointView.hidden = YES;
            [self.btnsView addSubview:redPointView];
            [redPointView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(btn.mas_top).offset(8);
                make.right.equalTo(btn.mas_right).offset(-10);
                make.size.mas_equalTo(CGSizeMake(8, 8));
            }];
        }
        
        self.indicatorView.backgroundColor = [UIColor dp_flatRedColor];
        
        self.btnViewHeight.mas_equalTo(44);
    }
    return self;
}
- (void)setTaskDayGet:(BOOL)taskDayGet{
    _taskDayGet = taskDayGet;
    UIView *redPointView = (UIView *)[self.btnsView viewWithTag:211];
    redPointView.hidden = _taskDayGet;
}
- (void)setTaskAchieveGet:(BOOL)taskAchieveGet{
    _taskAchieveGet =  taskAchieveGet;
    UIView *redPointView = (UIView *)[self.btnsView viewWithTag:212];
    redPointView.hidden = _taskAchieveGet;
}
- (void)setTaskNewerGet:(BOOL)taskNewerGet{
    _taskNewerGet = taskNewerGet;
    UIView *redPointView = (UIView *)[self.btnsView viewWithTag:210];
    redPointView.hidden = _taskNewerGet;
}
@end
