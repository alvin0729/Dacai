//
//  DPTHomeBuyViews.m
//  Jackpot
//
//  Created by sxf on 15/7/10.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页注释由sxf提供，如有更改，请标明
//#define KCharWith 50
#import "DPTHomeBuyViews.h"
 #import "DPBetToggleControl.h"

@interface DPHomeBuyJCView()
{
@private
    UILabel *_titleLabel;//比赛信息
    UILabel *_bonusLabel;//预计奖金
    UIButton *_bonusButton;//购买现金
    UUBar *_leftSingleView;//左侧支持率
    UUBar *_middleSingleView;//中间支持率
    UUBar *_rightSingleView;//右侧支持率
    
}
@end
@implementation DPHomeBuyJCView


- (instancetype)initWithGameTye:(GameTypeId)gameType{
    self = [super init];
    if (self) {
 
        self.gameId=gameType;
        [self addSubview:self.titleLabel];
        
        [self addSubview:self.bonusLabel];
        [self addSubview:self.bonusButton];

        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(self);
            make.width.equalTo(@250);
            make.top.equalTo(self).offset(10);
            make.height.equalTo(@12);
        }];
               switch (gameType) {
            case GameTypeJcNone://竞彩足球
            {
                [self bulidLayOutForJC];
            }
                break;
            case GameTypeLcNone://竞彩篮球
            {
                [self bulidLayOutForLC];
            }
                break;
            default:
                break;
            
        }
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
        self.leftSingleView.chartHight = self.middleSingleView.chartHight = self.rightSingleView.chartHight = 0 ;
        
        [self.bonusButton mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.equalTo(self).offset(-15);
            make.width.equalTo(@95);
            make.bottom.equalTo(self).offset(-20);
            make.height.equalTo(@35);
        }];
        [self.bonusLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self.bonusButton.mas_left);
            make.bottom.equalTo(self.bonusButton);
            make.height.equalTo(@35);
        }];
        //投注介绍
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor=[UIColor clearColor];
        [button setImage:dp_AppRootImage(@"gameInfo.png") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dp_gameInfo) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.equalTo(self);
            make.left.equalTo(self.titleLabel.mas_right);
            make.centerY.equalTo(self.titleLabel);
            make.height.equalTo(@24);
        }];


    }
    return self;
}
//竞彩足球
-(void)bulidLayOutForJC{
    UIView *leftView=[UIView dp_viewWithColor:[UIColor clearColor]];
    UIView *rightView=[UIView dp_viewWithColor:[UIColor clearColor]];
    UIView *midView=[UIView dp_viewWithColor:[UIColor clearColor]];
    [self addSubview:leftView];
    [self addSubview:midView];
    [self addSubview:rightView];
    [leftView addSubview:self.leftSingleView];
    [midView addSubview:self.middleSingleView];
    [rightView addSubview:self.rightSingleView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(30);
        make.width.equalTo(@84);
        make.height.equalTo(@120);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        
    }];
    [midView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self);
        make.width.equalTo(@65);
         make.bottom.equalTo(leftView);
        make.top.equalTo(leftView);
        
    }];
    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self).offset(-30);
        make.width.equalTo(@84);
        make.bottom.equalTo(leftView);
        make.top.equalTo(leftView);
        
    }];

    [self.leftSingleView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(leftView);
        make.width.equalTo(@70);
        make.bottom.equalTo(leftView).offset(-52);
        make.top.equalTo(leftView);
        
    }];

    [self.rightSingleView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(rightView);
        make.width.equalTo(@70);
        make.bottom.equalTo(self.leftSingleView);
        make.top.equalTo(self.leftSingleView);
        
    }];
    
    [self.middleSingleView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(midView);
        make.width.equalTo(@70);
        make.bottom.equalTo(self.leftSingleView);
        make.top.equalTo(self.leftSingleView);
        
    }];
    
    NSArray *array=[NSArray arrayWithObjects:leftView,midView,rightView, nil];
    for (int i=0; i<array.count; i++) {
        UIView *barView=[array objectAtIndex:i];
         DPBetToggleControl *button=[self creatBetToggleControl];
        button.tag=JCButtonTag+i;
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(barView);
            make.right.equalTo(barView);
            make.bottom.equalTo(barView);
            make.height.equalTo(@44);
        }];
    }
  
}
//竞彩篮球
-(void)bulidLayOutForLC{
    
    UIView *leftView=[UIView dp_viewWithColor:[UIColor clearColor]];
    UIView *rightView=[UIView dp_viewWithColor:[UIColor clearColor]];
    [self addSubview:leftView];
    [self addSubview:rightView];
    [self addSubview:self.leftSingleView];
    [self addSubview:self.rightSingleView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self).offset(40);
        make.width.equalTo(@95);
        make.height.equalTo(@120);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        
    }];
    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self).offset(-40);
        make.width.equalTo(@95);
        make.height.equalTo(@120);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        
    }];
    [self.leftSingleView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(leftView);
        make.width.equalTo(@65);
        make.bottom.equalTo(leftView).offset(-52);
        make.top.equalTo(leftView);
    }];
    
    [self.rightSingleView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(rightView);
        make.width.equalTo(@65);
        make.bottom.equalTo(self.leftSingleView);
        make.top.equalTo(self.leftSingleView);
        
    }];
    NSArray *array=[NSArray arrayWithObjects:leftView,rightView, nil];
    for (int i=0; i<array.count; i++) {
        UIView *barView=[array objectAtIndex:i];
        DPBetToggleControl *button=[self creatBetToggleControl];
        button.tag=LCButtonTag+i;
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(barView);
            make.right.equalTo(barView);
            make.bottom.equalTo(barView);
            make.height.equalTo(@44);
        }];
    }

}


//比赛信息
-(UILabel *)titleLabel{
    if (_titleLabel==nil) {
        _titleLabel=[[UILabel alloc] init];
        _titleLabel.backgroundColor=[UIColor clearColor];
        _titleLabel.text=@"";
        _titleLabel.textColor=UIColorFromRGB(0xc4c6c6);
        _titleLabel.font=[UIFont systemFontOfSize:12.0];
        _titleLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _titleLabel;
}
//预计奖金
-(UILabel *)bonusLabel{
    if (_bonusLabel==nil) {
        _bonusLabel=[[UILabel alloc] init];
        _bonusLabel.backgroundColor=[UIColor clearColor];
        _bonusLabel.text=@"预计奖金：";
        _bonusLabel.textColor=UIColorFromRGB(0x3b3e3e);
        _bonusLabel.font=[UIFont systemFontOfSize:14.0];
        _bonusLabel.textAlignment=NSTextAlignmentLeft;
    }
    return _bonusLabel;
}
//购买现金
-(UIButton *)bonusButton{
    if (_bonusButton==nil) {
        _bonusButton=[[UIButton alloc] init];
        _bonusButton.backgroundColor=[UIColor clearColor];
        [_bonusButton setBackgroundImage:dp_AppRootResizeImage(@"betSure.png") forState:UIControlStateNormal];
        [_bonusButton setTitle:@"购买" forState:UIControlStateNormal];
        [_bonusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bonusButton.titleLabel.font=[UIFont systemFontOfSize:16.0];
        [_bonusButton addTarget:self action:@selector(dp_BonusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _bonusButton;
}
//左侧支持率
-(UUBar *)leftSingleView{
    if (_leftSingleView==nil) {
        _leftSingleView=[[UUBar alloc] initWithColors:UIColorFromRGB(0xF84C4F) bottomColor:[UIColor dp_flatRedColor]];
        _leftSingleView.backgroundColor=[UIColor dp_flatRedColor];
     }
    return _leftSingleView;
}
//中间支持率
-(UUBar *)middleSingleView{
    if (_middleSingleView==nil) {
        _middleSingleView=[[UUBar alloc] initWithColors:UIColorFromRGB(0x4A87E8) bottomColor:UIColorFromRGB(0x3069C4)];
        _middleSingleView.backgroundColor=[UIColor clearColor];
    }
    return _middleSingleView;
}
//右侧支持率
-(UUBar *)rightSingleView{
    if (_rightSingleView==nil) {
        _rightSingleView=[[UUBar alloc] initWithColors:UIColorFromRGB(0x7CB666) bottomColor:UIColorFromRGB(0x649550)];
        _rightSingleView.backgroundColor=[UIColor clearColor];
    }
    return _rightSingleView;
}
//创建选项按钮
-(DPBetToggleControl *)creatBetToggleControl{
    DPBetToggleControl *button=[DPBetToggleControl verticalControl];
    button.normalImage=dp_AppRootResizeImage(@"quickNormal.png");
    button.selectedImage=dp_AppRootResizeImage(@"quickSelected.png");
    button.titleColor=UIColorFromRGB(0x3c3f3f);
    button.oddsColor=UIColorFromRGB(0x939595);
    button.selectedColor=[UIColor dp_flatRedColor];
    button.titleFont=[UIFont systemFontOfSize:13.0];
    button.titleFont=[UIFont systemFontOfSize:13.0];
    [button addTarget:self action:@selector(dp_singleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}
//选项点击事件
-(void)dp_singleBtnClick:(DPBetToggleControl *)button{
    button.selected=!button.selected;
    NSInteger index=button.tag-LCButtonTag;
    if (self.gameId==GameTypeJcNone) {
        index=button.tag-JCButtonTag;
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickHomeBuyJCView:isSelected:index:gameType:)]) {
        [self.delegate clickHomeBuyJCView:self isSelected:button.selected index:index gameType:self.gameId];
    };
}
//点击购买按钮
-(void)dp_BonusBtnClick:(UIButton *)button{
    
    NSString *buttonStr = button.titleLabel.text ;
    if ([buttonStr hasPrefix:@"0元"]) {
        [[DPToast makeText:@"请选择一个选项"]show ];
        return ;
    }
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(clickJcPayMoney:)]) {
        [self.delegate clickJcPayMoney:self.gameId];
    }
}
//投注介绍
-(void)dp_gameInfo{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(clickGameInfo:)]) {
        [self.delegate clickGameInfo:self];
    }
}
@end

