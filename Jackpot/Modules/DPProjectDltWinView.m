//
//  DPProjectDltWinView.m
//  Jackpot
//
//  Created by sxf on 15/9/21.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPProjectDltWinView.h"

@implementation DPProjectDltWinView

- (instancetype)init
{
    self = [super init];
    if (self) {

        UILabel* titleLabel = [self createLabel:@"中奖实例" textColor:UIColorFromRGB(0xd70000) textAlignment:NSTextAlignmentCenter font:[UIFont dp_systemFontOfSize:15.0]];
        [self addSubview:titleLabel];
        UIView* infoView = [UIView dp_viewWithColor:[UIColor clearColor]];
        [self addSubview:infoView];
        UILabel* introuceLabel = [self createLabel:@"每追加1元，奖金最高可提高60%" textColor:UIColorFromRGB(0x736751) textAlignment:NSTextAlignmentCenter font:[UIFont dp_systemFontOfSize:15.0]];
        [self addSubview:introuceLabel];

        UIButton* button = [[UIButton alloc] init];
        [button setTitle:@"我知道了" forState:UIControlStateNormal];
        button.backgroundColor = UIColorFromRGB(0xd34348);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        button.layer.cornerRadius = 5;
        [button addTarget:self action:@selector(winIntrouce) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];

        [titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.top.equalTo(self);
            make.height.equalTo(@50);

        }];
        [button mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
            make.bottom.equalTo(self).offset(-18);
            make.height.equalTo(@35);

        }];
        [introuceLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(button.mas_top).offset(-10);
            make.height.equalTo(@25);

        }];
        [infoView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
            make.top.equalTo(titleLabel.mas_bottom);
            make.height.equalTo(@175);

        }];
        UIView* hLine = [UIView dp_viewWithColor:UIColorFromRGB(0xdddbd0)];
        UIView* vLine = [UIView dp_viewWithColor:UIColorFromRGB(0xdddbd0)];
        [infoView addSubview:hLine];
        [infoView addSubview:vLine];
        [hLine mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(infoView);
            make.right.equalTo(infoView);
            make.height.equalTo(@0.5);
            make.top.equalTo(infoView);

        }];
        [vLine mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(infoView);
            make.width.equalTo(@0.5);
            make.top.equalTo(infoView);
            make.bottom.equalTo(infoView);

        }];
        NSArray* titleArray = [NSArray arrayWithObjects:@"奖项", @"一等奖", @"二等奖", @"三等奖", @"四等奖", @"五等奖", @"六等奖", nil];
        NSArray* infoArray = [NSArray arrayWithObjects:@"中奖示例", @"5+2", @"5+1", @"5+0/4+2", @"4+1/3+2", @"4+0/3+1/2+2", @"3+0/2+11+2/0+2", nil];
        NSArray* winMoneyArray = [NSArray arrayWithObjects:@"奖金", @"浮动奖", @"浮动奖", @"浮动奖", @"200", @"10", @"5", nil];
        for (int i = 0; i < 7; i++) {
            UILabel* leftLabel = [self createLabel:[titleArray objectAtIndex:i] textColor:UIColorFromRGB(0x767676) textAlignment:NSTextAlignmentCenter font:[UIFont dp_systemFontOfSize:11.0]];
            UILabel* midLabel = [self createLabel:[infoArray objectAtIndex:i] textColor:UIColorFromRGB(0x767676) textAlignment:NSTextAlignmentCenter font:[UIFont dp_systemFontOfSize:11.0]];
            UILabel* rightLabel = [self createLabel:[winMoneyArray objectAtIndex:i] textColor:UIColorFromRGB(0x767676) textAlignment:NSTextAlignmentCenter font:[UIFont dp_systemFontOfSize:11.0]];
            [infoView addSubview:leftLabel];
            [infoView addSubview:rightLabel];
            [infoView addSubview:midLabel];
            [leftLabel mas_makeConstraints:^(MASConstraintMaker* make) {
                make.left.equalTo(infoView);
                make.width.equalTo(@50);
                make.top.equalTo(infoView).offset(25 * i);
                make.height.equalTo(@25);

            }];
            [rightLabel mas_makeConstraints:^(MASConstraintMaker* make) {
                make.width.equalTo(@50);
                make.right.equalTo(infoView);
                make.top.equalTo(leftLabel);
                make.bottom.equalTo(leftLabel);

            }];
            [midLabel mas_makeConstraints:^(MASConstraintMaker* make) {
                make.left.equalTo(leftLabel.mas_right);
                make.right.equalTo(rightLabel.mas_left);
                make.top.equalTo(leftLabel);
                make.bottom.equalTo(leftLabel);

            }];

            UIView* hLine1 = [UIView dp_viewWithColor:UIColorFromRGB(0xdddbd0)];
            UIView* hLine2 = [UIView dp_viewWithColor:UIColorFromRGB(0xdddbd0)];
            UIView* hLine3 = [UIView dp_viewWithColor:UIColorFromRGB(0xdddbd0)];
            UIView* vLine1 = [UIView dp_viewWithColor:UIColorFromRGB(0xdddbd0)];
            UIView* vLine2 = [UIView dp_viewWithColor:UIColorFromRGB(0xdddbd0)];
            UIView* vLine3 = [UIView dp_viewWithColor:UIColorFromRGB(0xdddbd0)];
            [infoView addSubview:hLine1];
            [infoView addSubview:hLine2];
            [infoView addSubview:hLine3];
            [infoView addSubview:vLine1];
            [infoView addSubview:vLine2];
            [infoView addSubview:vLine3];
            [hLine1 mas_makeConstraints:^(MASConstraintMaker* make) {
                make.left.equalTo(leftLabel);
                make.right.equalTo(leftLabel);
                make.height.equalTo(@0.5);
                make.bottom.equalTo(leftLabel);

            }];
            [hLine2 mas_makeConstraints:^(MASConstraintMaker* make) {
                make.left.equalTo(midLabel);
                make.right.equalTo(midLabel);
                make.height.equalTo(@0.5);
                make.bottom.equalTo(midLabel);

            }];
            [hLine3 mas_makeConstraints:^(MASConstraintMaker* make) {
                make.left.equalTo(rightLabel);
                make.right.equalTo(rightLabel);
                make.height.equalTo(@0.5);
                make.bottom.equalTo(rightLabel);

            }];
            [vLine1 mas_makeConstraints:^(MASConstraintMaker* make) {
                make.right.equalTo(leftLabel);
                make.width.equalTo(@0.5);
                make.top.equalTo(leftLabel);
                make.bottom.equalTo(leftLabel);

            }];
            [vLine2 mas_makeConstraints:^(MASConstraintMaker* make) {
                make.right.equalTo(midLabel);
                make.width.equalTo(@0.5);
                make.top.equalTo(midLabel);
                make.bottom.equalTo(midLabel);

            }];
            [vLine3 mas_makeConstraints:^(MASConstraintMaker* make) {
                make.right.equalTo(rightLabel);
                make.width.equalTo(@0.5);
                make.top.equalTo(rightLabel);
                make.bottom.equalTo(rightLabel);

            }];
        }
    }
    return self;
}
- (void)winIntrouce
{
    if (self.clickBlock) {
        self.clickBlock(self);
    }
}
- (UILabel*)createLabel:(NSString*)text textColor:(UIColor*)textColor textAlignment:(NSTextAlignment)textAlignment font:(UIFont*)font
{
    UILabel* label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    label.font = font;
    return label;
}
@end
