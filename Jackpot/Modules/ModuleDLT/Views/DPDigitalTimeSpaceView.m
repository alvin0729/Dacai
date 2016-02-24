//
//  DPDigitalTimeSpaceView.m
//  DacaiProject
//
//  Created by sxf on 15/1/13.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页面有sxf做注释，他人如有更改，请标明

#import "DPDigitalTimeSpaceView.h"

@interface DPDigitalTimeSpaceView ()
{
@private
    NSInteger _gameType;
    UIView *_backView;
    UILabel *_infoLabel;
    UILabel *_bonusLabel;
 }
@property(nonatomic,strong,readonly)UIView *backView;
@property(nonatomic,strong,readonly)UILabel *infoLabel;
@property(nonatomic,strong,readonly)UILabel *bonusLabel;


@end
@implementation DPDigitalTimeSpaceView

- (instancetype)initWithFrame:(CGRect)frame lotteryType:(NSInteger)lotteryType {
    if (self = [super initWithFrame:frame]) {
        _gameType = lotteryType;
             [self bulidLayoutForDigital];
     }
    return self;
}
//数字彩
-(void)bulidLayoutForDigital{
    [self addSubview:self.backView];
    [self.backView addSubview:self.infoLabel];
    [self.backView addSubview:self.bonusLabel];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView);
        make.left.equalTo(self.backView).offset(16);
      }];
    [self.bonusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView);
        make.right.equalTo(self.backView).offset(-16);
    }];
    UIView *line=[UIView dp_viewWithColor:UIColorFromRGB(0xe1d7c3)];
    [self.backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backView);
        make.height.equalTo(@0.5);
        make.left.equalTo(self.backView);
        make.right.equalTo(self.backView);
    }];


    
}
//设置倒计时
 -(void)timeInfoString:(NSMutableAttributedString *)infoString{
    self.infoLabel.attributedText=infoString;
}
//设置奖池
-(void)bonusString:(NSMutableAttributedString *)totalMoney{

    self.bonusLabel.attributedText=totalMoney;

}
//得到滚存钱
-(NSString*)logogramForMoney:(NSInteger)money{
    if(money<0){
        return @"";
    }
    NSString *string1=@"0";
    NSString *string2=@"元";
    if (money/100000000.0>=1) {
        string1=[NSString stringWithFormat:@"%.1f",money/100000000.0];
        string2=@"亿元";
    }else{
        if (money/1000000.0>=1) {
            string1=[NSString stringWithFormat:@"%.1f",money/10000000.0];
            string2=@"千万元";
        }else {
            return @"";
        }
    }
    return [NSString stringWithFormat:@"%@ %@",string1,string2];
    
}
//背景
-(UIView *)backView{
    if (_backView==nil) {
        _backView=[[UIView alloc] init];
        _backView.backgroundColor=[UIColor clearColor];
    }
    return _backView;

}
//倒计时
-(UILabel *)infoLabel{
    if (_infoLabel==nil) {
        _infoLabel=[[UILabel alloc]init];
        _infoLabel.backgroundColor=[UIColor clearColor];
        _infoLabel.font=[UIFont dp_regularArialOfSize:12.0];
        _infoLabel.textAlignment=NSTextAlignmentLeft;
        _infoLabel.textColor=[UIColor dp_flatRedColor];
        _infoLabel.text=@"期号正在获取中";
    }
    return _infoLabel;
    
}
//奖池
-(UILabel *)bonusLabel{
    if (_bonusLabel==nil) {
        _bonusLabel=[[UILabel alloc]init];
        _bonusLabel.backgroundColor=[UIColor clearColor];
        _bonusLabel.font=[UIFont dp_regularArialOfSize:12.0];
        _bonusLabel.textAlignment=NSTextAlignmentRight;
        _bonusLabel.textColor=[UIColor colorWithRed:0.45 green:0.37 blue:0.30 alpha:1.0];
    }
    return _bonusLabel;

}

 @end
