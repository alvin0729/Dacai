//
//  DPHLMatchDetailCell.m
//  Jackpot
//
//  Created by mu on 15/12/21.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPHLMatchDetailCell.h"
#import "DPBetToggleControl.h"
#import "DPJczqDataModel.h"

@interface DPHLMatchDetailItem : UIView

@end
@implementation DPHLMatchDetailItem

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

@end

@interface DPHLMatchDetailCell (){

@private
    UIView *_infoView;
    UIView *_titleView;
    UIView *_optionView;
    
    UILabel *_competitionLabel;
    UILabel *_orderNameLabel;
    UILabel *_matchDateLabel;
    
    UILabel *_homeNameLabel;
    UILabel *_awayNameLabel;
    UILabel *_homeRankLabel;
    UILabel *_awayRankLabel;
    UILabel *_middleLabel;
    UILabel *_rangQiuLabel ;
    
    UILabel*_stopCellLabel ;
    UILabel *_stopCellspf ;
    
    UILabel *_spfLabel;
    UILabel *_rqspfLabel;
}
@property (nonatomic, strong) UILabel *matchTitle;
@property (nonatomic, strong) UILabel *matchNum;
@property (nonatomic, strong) UILabel *matchTime;

@property (nonatomic, strong, readonly) UIView *infoView;//左边视图
@property (nonatomic, strong, readonly) UIView *titleView;//对阵视图
@property (nonatomic, strong, readonly) UIView *optionView;//赔率视图

@end

@implementation DPHLMatchDetailCell
@dynamic infoView;
@dynamic titleView;
@dynamic optionView;
@dynamic competitionLabel;
@dynamic orderNameLabel;
@dynamic matchDateLabel;

@dynamic homeNameLabel;
@dynamic awayNameLabel;
@dynamic homeRankLabel;
@dynamic awayRankLabel;
@dynamic middleLabel;
@dynamic rangQiuLabel ;

@synthesize stopCellLabel ;
@synthesize stopCellspf ;

@dynamic spfLabel;
@dynamic rqspfLabel;


- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"DPHLMatchDetailCell";
    DPHLMatchDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [self initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor dp_flatBackgroundColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        UIView *contentView = self.contentView;

        [contentView addSubview:self.infoView];
        [contentView addSubview:self.titleView];
        [contentView addSubview:self.optionView];

        [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView).offset(5);
            make.bottom.equalTo(contentView);
            make.left.equalTo(contentView);
            make.width.equalTo(contentView).multipliedBy(0.21);
        }];
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.infoView.mas_right);
            make.right.equalTo(contentView);
            make.top.equalTo(contentView).offset(3);
            make.height.equalTo(@23);
        }];
        [self.optionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.infoView.mas_right);
            make.right.equalTo(contentView);
            make.top.equalTo(self.titleView.mas_bottom).offset(10);
            make.bottom.equalTo(contentView).offset(-5);
        }];
        [self infoBuildLayout];
        [self titleBuildLayout];
        [self optionHtBuildLayout];
    }
    return self;
}

/**
 *  左侧视图
 */
- (void)infoBuildLayout {
    UIView *contentView = self.infoView;
    
    [contentView addSubview:self.competitionLabel]; //赛事号
    [contentView addSubview:self.orderNameLabel];//赛事名字
    [contentView addSubview:self.matchDateLabel];// start time or end time 截止时间
    
    [self.competitionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.orderNameLabel.mas_top).offset(-2);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
    }];
    [self.orderNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView.mas_centerY).offset(5);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
    }];
    [self.matchDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderNameLabel.mas_bottom).offset(2);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
    }];
    
}

/**
 *  顶部视图
 */
- (void)titleBuildLayout {
    UIView *contentView = self.titleView;
    
    
    [contentView addSubview:self.middleLabel];//中间   VS  让球数
    [contentView addSubview:self.homeNameLabel];//主队名字
    [contentView addSubview:self.awayNameLabel];//客队名字
    [contentView addSubview:self.homeRankLabel];//主队排名
    [contentView addSubview:self.awayRankLabel];//客队排名
    
    [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.bottom.equalTo(contentView);
    }];
    [self.homeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.middleLabel.mas_left).offset(-15);
        make.bottom.equalTo(contentView);
    }];
    [self.awayNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.middleLabel.mas_right).offset(15);
        make.bottom.equalTo(contentView);
    }];
    [self.homeRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.homeNameLabel.mas_left);
        make.bottom.equalTo(contentView);
    }];
    [self.awayRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.awayNameLabel.mas_right);
        make.bottom.equalTo(contentView);
    }];
    
    
    [contentView addSubview:self.rangQiuLabel];
    [self.rangQiuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(2.5);
        make.width.equalTo(@10) ;
        make.centerY.equalTo(contentView).offset(5) ;
    }];
    
 }

/**
 *  投注视图
 */
- (void)optionHtBuildLayout {
    UIView *contentView = self.optionView;
     [contentView addSubview:self.spfLabel];//胜平负让球数
    [contentView addSubview:self.rqspfLabel];//让球胜平负让球数
    
    [self.spfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.width.mas_equalTo(18*kScreenWidth/320.0);
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView.mas_centerY).offset(-1);
    }];
    [self.rqspfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.width.mas_equalTo(18*kScreenWidth/320.0);
        make.top.equalTo(contentView.mas_centerY).offset(0.5);
        make.bottom.equalTo(contentView);
    }];
    
    // 布局选项
    NSArray *titleNames = [NSArray arrayWithObjects:@"胜", @"平", @"负", nil];
    NSArray *optionButtonsSpf = @[[DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl]];
    for (int i = 0; i < optionButtonsSpf.count; i++) {
        DPBetToggleControl *control = optionButtonsSpf[i];
        [control setTag:GameTypeJcSpf << 16 | i];
        [control setTitleText:titleNames[i]];
        [control setOddsText:@"0.00"] ;
        [control addTarget:self action:@selector(pvt_onBet:) forControlEvents:UIControlEventTouchUpInside];
        [control setShowBorderWhenSelected:YES];
        [contentView addSubview:control];
    }
    [contentView addSubview:self.stopCellspf];
    [optionButtonsSpf[0] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
         make.bottom.equalTo(contentView.mas_centerY).offset(-1);
        make.left.equalTo(self.spfLabel.mas_right).offset(7);
        make.width.mas_equalTo(71 * kScreenWidth / 320.0);
 
    }];
    [optionButtonsSpf[1] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView.mas_centerY).offset(-1);
        make.left.equalTo(((DPBetToggleControl *)optionButtonsSpf[0]).mas_right).offset(-0.5);
//        make.width.equalTo(contentView).valueOffset(@((-18-16-2)/3.0)).dividedBy(3);
        make.width.mas_equalTo(71 * kScreenWidth / 320.0);

        
    }];
    [optionButtonsSpf[2] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView.mas_centerY).offset(-1);
        make.left.equalTo(((DPBetToggleControl *)optionButtonsSpf[1]).mas_right).offset(-0.5);
//        make.width.equalTo(contentView).valueOffset(@((-18-16-2)/3.0)).dividedBy(3);
        make.width.mas_equalTo(71 * kScreenWidth / 320.0);

        
    }];
    
    [self.stopCellspf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView.mas_centerY).offset(-1);
        make.left.equalTo(((DPBetToggleControl *)optionButtonsSpf[0]));
        make.right.equalTo(((DPBetToggleControl *)optionButtonsSpf[2]));
        
    }];
    
    NSArray *optionButtonsRqspf = @[[DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl]];
    for (int i = 0; i < optionButtonsRqspf.count; i++) {
        DPBetToggleControl *control = optionButtonsRqspf[i];
        [control setTag:GameTypeJcRqspf << 16 | i];
        [control setTitleText:titleNames[i]];
        [control setOddsText:@"0.00"] ;

        [control addTarget:self action:@selector(pvt_onBet:) forControlEvents:UIControlEventTouchUpInside];
        [control setShowBorderWhenSelected:YES];
        [contentView addSubview:control];
    }
    
    [contentView addSubview:self.stopCellLabel];
    
    [optionButtonsRqspf[0] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_centerY).offset(1);
        make.bottom.equalTo(contentView);
 
        make.left.equalTo(self.spfLabel.mas_right).offset(7);
        make.width.mas_equalTo(71 * kScreenWidth / 320.0);
        
    }];
    [optionButtonsRqspf[1] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_centerY).offset(1);
        make.bottom.equalTo(contentView);
        make.left.equalTo(((DPBetToggleControl *)optionButtonsRqspf[0]).mas_right).offset(-0.5);
        make.width.mas_equalTo(71 * kScreenWidth / 320.0);
    }];
    [optionButtonsRqspf[2] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_centerY).offset(1);
        make.bottom.equalTo(contentView);
        make.left.equalTo(((DPBetToggleControl *)optionButtonsRqspf[1]).mas_right).offset(-0.5);
        make.width.mas_equalTo(71 * kScreenWidth / 320.0);
    }];
    
    [_stopCellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_centerY).offset(1);
        make.bottom.equalTo(contentView);
        make.left.equalTo(((DPBetToggleControl *)optionButtonsRqspf[0]));
        make.right.equalTo(((DPBetToggleControl *)optionButtonsRqspf[2]));
    }];
    _optionButtonsRqspf = optionButtonsRqspf;
    _optionButtonsSpf = optionButtonsSpf;
    
         
}

#pragma mark-  getter /setter

//胜平负让球数--0
- (UILabel *)spfLabel {
    if (_spfLabel == nil) {
        _spfLabel = [[UILabel alloc] init];
        _spfLabel.backgroundColor = [UIColor colorWithRed:0 green:0.67 blue:0.51 alpha:1];
        _spfLabel.textColor = [UIColor dp_flatWhiteColor];
        _spfLabel.textAlignment = NSTextAlignmentCenter;
        _spfLabel.font = [UIFont dp_systemFontOfSize:10];
        _spfLabel.text = @"0" ;
    }
    return _spfLabel;
}
//让球胜平负让球数
- (UILabel *)rqspfLabel {
    if (_rqspfLabel == nil) {
        _rqspfLabel = [[UILabel alloc] init];
        _rqspfLabel.backgroundColor = [UIColor colorWithRed:1 green:0.71 blue:0.15 alpha:1];
        _rqspfLabel.textAlignment = NSTextAlignmentCenter;
        _rqspfLabel.font = [UIFont dp_systemFontOfSize:10];
        _rqspfLabel.text = @"-1" ;
    }
    return _rqspfLabel;
}


//左边视图
- (UIView *)infoView {
    if (_infoView == nil) {
        _infoView = [[UIView alloc] init];
        _infoView.backgroundColor = [UIColor clearColor];
    }
    return _infoView;
}
//对阵视图
- (UIView *)titleView {
    if (_titleView == nil) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [UIColor clearColor];
    }
    return _titleView;
}
//赔率视图
- (UIView *)optionView {
    if (_optionView == nil) {
        _optionView = [[UIView alloc] init];
        _optionView.backgroundColor = [UIColor clearColor];
    }
    return _optionView;
}
//赛事名称
- (UILabel *)competitionLabel {
    if (_competitionLabel == nil) {
        _competitionLabel = [[UILabel alloc] init];
        _competitionLabel.backgroundColor = [UIColor clearColor];
        _competitionLabel.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
        _competitionLabel.textAlignment = NSTextAlignmentCenter;
        _competitionLabel.font = [UIFont dp_systemFontOfSize:13];
        _competitionLabel.text = @"荷乙" ;
    }
    return _competitionLabel;
}
//编号名称
- (UILabel *)orderNameLabel {
    if (_orderNameLabel == nil) {
        _orderNameLabel = [[UILabel alloc] init];
        _orderNameLabel.backgroundColor = [UIColor clearColor];
        _orderNameLabel.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
        _orderNameLabel.textAlignment = NSTextAlignmentCenter;
        _orderNameLabel.font = [UIFont dp_systemFontOfSize:13];
        _orderNameLabel.text = @"001" ;
    }
    return _orderNameLabel;
}
//截止时间
- (UILabel *)matchDateLabel {
    if (_matchDateLabel == nil) {
        _matchDateLabel = [[UILabel alloc] init];
        _matchDateLabel.backgroundColor = [UIColor clearColor];
        _matchDateLabel.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
        _matchDateLabel.textAlignment = NSTextAlignmentCenter;
        _matchDateLabel.font = [UIFont dp_systemFontOfSize:11];
        _matchDateLabel.text = @"23:50截止" ;
    }
    return _matchDateLabel;
}


//主队名称
- (UILabel *)homeNameLabel {
    if (_homeNameLabel == nil) {
        _homeNameLabel = [[UILabel alloc] init];
        _homeNameLabel.backgroundColor = [UIColor clearColor];
        _homeNameLabel.textColor = [UIColor dp_flatBlackColor];
        _homeNameLabel.textAlignment = NSTextAlignmentCenter;
        _homeNameLabel.font = [UIFont dp_systemFontOfSize:15];
        _homeNameLabel.text = @"前进之鹰" ;
    }
    return _homeNameLabel;
}
//客队名称
- (UILabel *)awayNameLabel {
    if (_awayNameLabel == nil) {
        _awayNameLabel = [[UILabel alloc] init];
        _awayNameLabel.backgroundColor = [UIColor clearColor];
        _awayNameLabel.textColor = [UIColor dp_flatBlackColor];
        _awayNameLabel.textAlignment = NSTextAlignmentCenter;
        _awayNameLabel.font = [UIFont dp_systemFontOfSize:15];
        _awayNameLabel.text = @"福伦丹" ;
    }
    return _awayNameLabel;
}
//主队排名
- (UILabel *)homeRankLabel {
    if (_homeRankLabel == nil) {
        _homeRankLabel = [[UILabel alloc] init];
        _homeRankLabel.backgroundColor = [UIColor clearColor];
        _homeRankLabel.textColor = UIColorFromRGB(0x958b7a);
        _homeRankLabel.textAlignment = NSTextAlignmentCenter;
        _homeRankLabel.font = [UIFont dp_systemFontOfSize:9];
        _homeRankLabel.text = @"[17]";
    }
    return _homeRankLabel;
}
//客队排名
- (UILabel *)awayRankLabel {
    if (_awayRankLabel == nil) {
        _awayRankLabel = [[UILabel alloc] init];
        _awayRankLabel.backgroundColor = [UIColor clearColor];
        _awayRankLabel.textColor =  UIColorFromRGB(0x958b7a);
        _awayRankLabel.textAlignment = NSTextAlignmentCenter;
        _awayRankLabel.font = [UIFont dp_systemFontOfSize:9];
        _awayRankLabel.text = @"[17]" ;
    }
    return _awayRankLabel;
}

-(UILabel*)stopCellLabel
{
    if (_stopCellLabel == nil) {
        _stopCellLabel = [[UILabel alloc]init];
        _stopCellLabel.text = @"未开售" ;
        _stopCellLabel.textColor = [UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
        _stopCellLabel.textAlignment = NSTextAlignmentCenter ;
        _stopCellLabel.font = [UIFont dp_systemFontOfSize:14];
        _stopCellLabel.layer.borderColor=[UIColor colorWithRed:0.91 green:0.88 blue:0.82 alpha:1.0].CGColor;
        _stopCellLabel.layer.borderWidth=1;
        _stopCellLabel.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
        _stopCellLabel.hidden = YES ;
    }
    
    return _stopCellLabel ;
}

-(UILabel*)stopCellspf
{
    if (_stopCellspf == nil) {
        
        _stopCellspf = [[UILabel alloc]init];
        _stopCellspf.text = @"未开售" ;
        _stopCellspf.textColor = [UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
        _stopCellspf.textAlignment = NSTextAlignmentCenter ;
        _stopCellspf.font = [UIFont dp_systemFontOfSize:14];
        _stopCellspf.layer.borderColor=[UIColor colorWithRed:0.91 green:0.88 blue:0.82 alpha:1.0].CGColor;
        _stopCellspf.layer.borderWidth=1;
        _stopCellspf.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
        _stopCellspf.hidden = YES ;
    }
    
    return _stopCellspf ;
}


- (UILabel *)middleLabel {
    if (_middleLabel == nil) {
        _middleLabel = [[UILabel alloc] init];
        _middleLabel.backgroundColor = [UIColor clearColor];
        _middleLabel.textAlignment = NSTextAlignmentCenter;
        _middleLabel.font = [UIFont dp_systemFontOfSize:13];
        _middleLabel.text = @"VS";
        _middleLabel.textColor =  UIColorFromRGB(0x958b7a);
    }
    return _middleLabel;
}
//VS或者让球
-(UILabel*)rangQiuLabel{
    if (_rangQiuLabel == nil) {
        _rangQiuLabel = [[UILabel alloc] init];
        _rangQiuLabel.backgroundColor = [UIColor clearColor];
        _rangQiuLabel.textAlignment = NSTextAlignmentCenter;
        _rangQiuLabel.font = [UIFont dp_systemFontOfSize:11];
        _rangQiuLabel.text = @"让\n球";
        _rangQiuLabel.numberOfLines = 0 ;
        _rangQiuLabel.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
        
    }
    
    return _rangQiuLabel ;
}


#pragma mark - event

//点击赔率
- (void)pvt_onBet:(DPBetToggleControl *)sender {
//    sender.selected = !sender.isSelected;
    
    if (self.betControlSelected) {
        self.betControlSelected(self,sender,(sender.tag & 0xFFFF0000) >> 16,sender.tag & 0x0000FFFF,!sender.isSelected) ;
    }
    
}


#pragma mark---------data赋值

-(void)setMatch:(PBMJczqMatch *)match
{
    _match = match ;
    
    self.competitionLabel.text = match.competitionName ;
    self.orderNameLabel.text = match.orderNumberName ;
    self.matchDateLabel.text = [NSDate dp_coverDateString:match.endTime
                                               fromFormat:@"yyyy-MM-dd HH:mm:ss"
                                                 toFormat:@"HH:mm截止"];
    self.homeNameLabel.text = match.homeTeamName;
    self.awayNameLabel.text = match.awayTeamName;
    
    
    self.homeRankLabel.text = match.homeTeamRank.length?
    [NSString stringWithFormat:@"[%@]", match.homeTeamRank] :@"";
    self.awayRankLabel.text =match.awayTeamRank.length?
    [NSString stringWithFormat:@"[%@]", match.awayTeamRank]:@"";

    
     self.spfLabel.text = @"0";
    if (match.spfItem.gameVisible) {
        self.spfLabel.textColor = [UIColor dp_flatWhiteColor];
        self.spfLabel.backgroundColor =
        [UIColor colorWithRed:0
                        green:0.67
                         blue:0.51
                        alpha:1];
        self.spfLabel.layer.borderWidth = 0;
    } else {
        self.spfLabel.textColor =
        [UIColor colorWithRed:0.75
                        green:0.72
                         blue:0.62
                        alpha:1.0];
        
        self.spfLabel.backgroundColor =
        [UIColor colorWithRed:0.94
                        green:0.91
                         blue:0.86
                        alpha:1.0];
        self.spfLabel.layer.borderColor =
        [UIColor colorWithRed:0.91
                        green:0.88
                         blue:0.82
                        alpha:1.0]
        .CGColor;
        self.spfLabel.layer.borderWidth = 1;
    }
    self.rqspfLabel.text = [NSString stringWithFormat:@"%+d", (int)match.rqs];
    
    if (match.rqspfItem.gameVisible) {
        self.rqspfLabel.textColor = match.rqs > 0 ? [UIColor dp_flatRedColor]
        : [UIColor dp_flatBlueColor];
        
        self.rqspfLabel.backgroundColor =
        [UIColor colorWithRed:1
                        green:0.71
                         blue:0.15
                        alpha:1];
        self.rqspfLabel.layer.borderWidth = 0;
        
    } else {
        self.rqspfLabel.textColor =
        [UIColor colorWithRed:0.75
                        green:0.72
                         blue:0.62
                        alpha:1.0];
        
        self.rqspfLabel.backgroundColor =
        [UIColor colorWithRed:0.94
                        green:0.91
                         blue:0.86
                        alpha:1.0];
        self.rqspfLabel.layer.borderColor =
        [UIColor colorWithRed:0.91
                        green:0.88
                         blue:0.82
                        alpha:1.0]
        .CGColor;
        self.rqspfLabel.layer.borderWidth = 1;
    }
    
    
    JczqOption option = match.matchOption.htOption ;
    
    for (int i = 0; i < self.optionButtonsSpf.count; i++) {
         
        DPBetToggleControl *control = self.optionButtonsSpf[i];
        if (match.spfItem.gameVisible) {
            control.userInteractionEnabled = YES;
            control.oddsText = [match.spfItem.spListArray dp_safeObjectAtIndex:i];
            control.selected = option.betSpf[i];
            control.titleColor = [UIColor dp_flatBlackColor];
            self.stopCellspf.hidden = YES;
            
        } else {
            self.stopCellspf.hidden = NO;
            control.userInteractionEnabled = NO;
            control.oddsText = @"";
        }
    }
    for (int i = 0; i < self.optionButtonsRqspf.count; i++) {
        
        DPBetToggleControl *control = self.optionButtonsRqspf[i];
        if (match.rqspfItem.gameVisible) {
            control.userInteractionEnabled = YES;
            control.oddsText = [match.rqspfItem.spListArray dp_safeObjectAtIndex:i];
            control.selected = option.betRqspf[i];
            self.stopCellLabel.hidden = YES;
        } else {
            self.stopCellLabel.hidden = NO;
            control.userInteractionEnabled = NO;
            control.oddsText = @"";
        }
    }


}

@end
