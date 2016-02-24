//
//  DPChaseNumberInfoCell.m
//  Jackpot
//
//  Created by sxf on 15/12/10.
//  Copyright © 2015年 dacai. All rights reserved.
//  本页注释由sxf提供，如有更改，请标明

#import "DPChaseNumberInfoCell.h"
@interface DPChaseNumberInfoCell()
{
@private
    UILabel *_issueLabel;
    UILabel *_chaseStateLabel;
    UILabel *_drawLabel;
    UILabel *_winLabel;
    
}
@property(nonatomic,strong,readonly)UILabel *issueLabel; //期号
@property(nonatomic,strong,readonly)UILabel *chaseStateLabel;//追号状态
@property(nonatomic,strong,readonly)UILabel *drawLabel;//开奖号码
@property(nonatomic,strong,readonly)UILabel *winLabel;//开奖状态
@end
@implementation DPChaseNumberInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *contenView=self.contentView;
        self.backgroundColor=[UIColor clearColor];
        contenView.backgroundColor=[UIColor dp_flatWhiteColor];
        [contenView addSubview:self.issueLabel];
        [contenView addSubview:self.chaseStateLabel];
        [contenView addSubview:self.drawLabel];
        [contenView addSubview:self.winLabel];
       
        [self.issueLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(12);
            make.width.equalTo(@((kScreenWidth-32)*0.1));
            make.bottom.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
        [self.chaseStateLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.issueLabel.mas_right);
            make.width.equalTo(@((kScreenWidth-32)*0.2));
            make.bottom.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
        [self.winLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.mas_equalTo(-12);
            make.width.equalTo(@((kScreenWidth-32)*0.2));
            make.bottom.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
        [self.drawLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.chaseStateLabel.mas_right);
            make.right.equalTo(self.winLabel.mas_left);
            make.bottom.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
        UIImageView *rightArrow=[[UIImageView alloc] init];
        rightArrow.backgroundColor=[UIColor clearColor];
        rightArrow.image=dp_AccountImage(@"chaseArrow.png");
        [contenView addSubview:rightArrow];
        
        UIView *line=[UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
        [contenView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(contenView).offset(16);
            make.right.equalTo(contenView);
            make.top.mas_equalTo(0);
            make.height.equalTo(@0.5);
        }];
        [rightArrow mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.equalTo(contenView).offset(-10);
            make.centerY.equalTo(contenView);
            make.width.equalTo(@4.5);
            make.height.equalTo(@8);
        }];
        

    }
    return self;
}
//期号
-(void)setIssueLabelText:(NSString *)text{
    self.issueLabel.text=text;
}
//状态
-(void)setStateLabel:(NSString *)text{
    self.chaseStateLabel.text=text;
}
//开奖号码
-(void)setDrawLabelText:(NSMutableAttributedString *)text{
    self.drawLabel.attributedText=text;
}
//中奖情况
-(void)setWinLabelText:(NSString *)text{
    self.winLabel.text=text;
    if ([text isEqualToString:@"中奖"] ) {
        self.winLabel.textColor=UIColorFromRGB(0xdc4f4d);
    }else{
    self.winLabel.textColor=UIColorFromRGB(0x666666);
    }
}
//期号
-(UILabel *)issueLabel{
    if (_issueLabel==nil) {
        _issueLabel=[[UILabel alloc] init];
        _issueLabel.backgroundColor=[UIColor clearColor];
        _issueLabel.textColor=UIColorFromRGB(0x666666);
        _issueLabel.textAlignment=NSTextAlignmentCenter;
        _issueLabel.font=[UIFont dp_systemFontOfSize:11.0];
    }
    return _issueLabel;
}
//追号状态
-(UILabel *)chaseStateLabel{
    if (_chaseStateLabel==nil) {
        _chaseStateLabel=[[UILabel alloc] init];
        _chaseStateLabel.backgroundColor=[UIColor clearColor];
        _chaseStateLabel.textColor=UIColorFromRGB(0x666666);
        _chaseStateLabel.textAlignment=NSTextAlignmentCenter;
        _chaseStateLabel.font=[UIFont dp_systemFontOfSize:11.0];
    }
    return _chaseStateLabel;
}
//开奖号码
-(UILabel *)winLabel{
    if (_winLabel==nil) {
        _winLabel=[[UILabel alloc] init];
        _winLabel.backgroundColor=[UIColor clearColor];
        _winLabel.textColor=UIColorFromRGB(0x666666);
        _winLabel.textAlignment=NSTextAlignmentCenter;
        _winLabel.font=[UIFont dp_systemFontOfSize:11.0];
    }
    return _winLabel;
}
//开奖状态
-(UILabel *)drawLabel{
    if (_drawLabel==nil) {
        _drawLabel=[[UILabel alloc] init];
        _drawLabel.backgroundColor=[UIColor clearColor];
        _drawLabel.textColor=UIColorFromRGB(0x666666);
        _drawLabel.textAlignment=NSTextAlignmentCenter;
        _drawLabel.font=[UIFont dp_systemFontOfSize:11.0];
    }
    return _drawLabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end



@implementation DPChaseNumberProjectHeaderView


-(void)bulidLayOut
{
  self.contentView.backgroundColor=[UIColor dp_flatWhiteColor];
    UILabel *titleLabel=[[UILabel alloc] init];
    [titleLabel setText:@"方案内容:"];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    titleLabel.font=[UIFont dp_systemFontOfSize:12.0];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.textColor=UIColorFromRGB(0x999999);
    titleLabel.adjustsFontSizeToFitWidth=YES;
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.contentView addSubview:self.projectInfo];
    self.projectInfo.adjustsFontSizeToFitWidth=YES;
    [self.projectInfo mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(titleLabel.mas_right).offset(5);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    UIView *line=[UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
    self.lineView=line;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView);
        make.bottom.mas_equalTo(0);
        make.height.equalTo(@0.5);
    }];
}

-(UILabel *)projectInfo{
    if (_projectInfo==nil) {
        _projectInfo=[[UILabel alloc] init];
        _projectInfo.backgroundColor=[UIColor clearColor];
        _projectInfo.textColor=UIColorFromRGB(0x333333);
        _projectInfo.textAlignment=NSTextAlignmentLeft;
        _projectInfo.font=[UIFont dp_systemFontOfSize:14.0];
    }
    return _projectInfo;
}
@end

@implementation DPChaseNumberContentHeaderView

-(void)bulidLayOut
{
    self.contentView.backgroundColor=[UIColor dp_flatBackgroundColor];
    UIView *topView=[UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
    UIView *bottomView=[UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
    [self.contentView addSubview:topView];
    [self.contentView addSubview:bottomView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(4);
        make.height.equalTo(@30);
    }];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(topView.mas_bottom);
        make.height.equalTo(@30);
    }];
    UIView *topLine=[UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
    UIView *midLine=[UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
    UIView *bottomLine=[UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
    [self.contentView addSubview:topLine];
    [topView addSubview:midLine];
    [bottomView addSubview:bottomLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.equalTo(@0.5);
    }];
    [midLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.equalTo(@0.5);
    }];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(bottomView);
        make.height.equalTo(@1);
    }];
    
    UILabel *titleLabel=[self createLabel:@"追号内容" textColor:UIColorFromRGB(0x333333) textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:12.0]];
    UILabel *issueLabel=[self createLabel:@"期号" textColor:UIColorFromRGB(0xccbeb1) textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:11.0]];
    UILabel *stateLabel=[self createLabel:@"状态" textColor:UIColorFromRGB(0xccbeb1) textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:11.0]];
    UILabel *drawLabel=[self createLabel:@"开奖号码" textColor:UIColorFromRGB(0xccbeb1) textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:11.0]];
    UILabel *winInfoLabel=[self createLabel:@"中奖情况" textColor:UIColorFromRGB(0xccbeb1) textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:11.0]];
    titleLabel.adjustsFontSizeToFitWidth=YES;
    [topView addSubview:titleLabel];
    [bottomView addSubview:issueLabel];
    [bottomView addSubview:stateLabel];
    [bottomView addSubview:drawLabel];
    [bottomView addSubview:winInfoLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(14);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    [issueLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(12);
        make.width.equalTo(@((kScreenWidth-32)*0.1));
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(issueLabel.mas_right);
        make.width.equalTo(@((kScreenWidth-32)*0.2));
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    [winInfoLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_equalTo(-12);
        make.width.equalTo(@((kScreenWidth-32)*0.2));
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    [drawLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(stateLabel.mas_right);
        make.right.equalTo(winInfoLabel.mas_left);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    
    UIView *topline=[UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
    [self.contentView addSubview:topline];
    [topline mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.mas_equalTo(0);
        make.height.equalTo(@0.5);
    }];
    UIView *midline=[UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
    [topView addSubview:midline];
    [midline mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(topView);
        make.right.equalTo(topView);
        make.top.mas_equalTo(0);
        make.height.equalTo(@0.5);
    }];
    UIView *bottomline=[UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
    [bottomView addSubview:bottomline];
    [bottomline mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(bottomView);
        make.right.equalTo(bottomView);
        make.top.mas_equalTo(0);
        make.height.equalTo(@1);
    }];
   
    
}
-(UILabel *)createLabel:(NSString *)text  textColor:(UIColor *)textColor  textAlignment:(NSTextAlignment)textAlignment font:(UIFont *)font{
    UILabel *label=[[UILabel alloc] init];
    label.backgroundColor=[UIColor clearColor];
    label.text=text;
    label.textColor=textColor;
    label.textAlignment=textAlignment;
    label.font=font;
    return label;
}

@end