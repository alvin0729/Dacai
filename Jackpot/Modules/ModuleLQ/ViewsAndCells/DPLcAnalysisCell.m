//
//  DPLcAnalysisCell.m
//  DacaiProject
//
//  Created by sxf on 15/3/10.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPLcAnalysisCell.h"
@interface DPLcAnalysisCell () {
@private
    BOOL _hasLoaded;
    UILabel *_rqWinLabel, *_rqLoseLabel;
    UILabel *_ratioWinLabel, *_ratioLoseLabel;
    UILabel *_historyLabel;
    UILabel *_zhanJiLabel;
}
@end

@implementation DPLcAnalysisCell
@dynamic rqWinLabel, rqLoseLabel;
@dynamic ratioWinLabel, ratioLoseLabel;
@dynamic historyLabel, zhanJiLabel;
@synthesize activityIndicatorView = _activityIndicatorView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithRed:0.19 green:0.25 blue:0.29 alpha:1];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];

    if (!_hasLoaded && newSuperview) {
        _hasLoaded = YES;

        [self buildLayout];
    }
}

- (void)buildLayout {
    UIButton *goAnalysisButton = [[UIButton alloc] init];
    [goAnalysisButton setBackgroundColor:[UIColor colorWithRed:0.35 green:0.58 blue:0.28 alpha:1]];
    [goAnalysisButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goAnalysisButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [goAnalysisButton setTitle:@"详细赛事分析>" forState:UIControlStateNormal];
    [goAnalysisButton setImage:dp_SportLotteryImage(@"lqMatch.png") forState:UIControlStateNormal];
    [goAnalysisButton setImageEdgeInsets:UIEdgeInsetsMake(0, -2, 0, 2)];
    [goAnalysisButton.titleLabel setFont:[UIFont dp_systemFontOfSize:13]];
    [goAnalysisButton.titleLabel setShadowOffset:CGSizeMake(0, 0.5)];
    [goAnalysisButton addTarget:self action:@selector(pvt_onAnalysis) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:goAnalysisButton];

    [goAnalysisButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.equalTo(@25);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    switch (self.gameType) {
        case GameTypeLcSf:      //胜负
        case GameTypeLcRfsf:    //让球胜负
        case GameTypeLcDxf:     //大小分
        {
            [self layOutSpfView];
        } break;
        case GameTypeLcHt:    //混投
        {
            [self layOutHtView];
        } break;

        case GameTypeLcSfc:    //胜分差

        {
            [self layOutBfView];
        } break;

        default:
            break;
    }

    [self.contentView addSubview:self.activityIndicatorView];

    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = dp_TogetherBuyImage(@"arrow.png");
    [self.contentView addSubview:imageView];

    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(-5);
        make.left.equalTo(self.contentView).offset(27.5);
        make.height.equalTo(@5);
        make.width.equalTo(@8);
    }];
}
- (void)clearAllData {
    self.rqWinLabel.text = @"-";
    self.rqLoseLabel.text = @"-";
    self.ratioWinLabel.text = @"-";
    self.ratioLoseLabel.text = @"-";
    self.historyLabel.text = @"-";
    self.zhanJiLabel.text = @"-";
}
//混投
- (void)layOutHtView {
    UILabel *ratioTitleLabel = [self pvt_titleLabelFactory];
    UILabel *historyTitleLabel = [self pvt_titleLabelFactory];
    UILabel *newZhanJiTitleLabel = [self pvt_titleLabelFactory];
    ratioTitleLabel.text = @"投注比例";
    historyTitleLabel.text = @"历史交锋";
    newZhanJiTitleLabel.text = @"近期战绩";

    [self.contentView addSubview:ratioTitleLabel];
    [self.contentView addSubview:historyTitleLabel];
    [self.contentView addSubview:newZhanJiTitleLabel];

    UILabel *upLabel = [self pvt_gridLabelFactory];
    upLabel.text = @"让分";
    UILabel *downLabel = [self pvt_gridLabelFactory];
    downLabel.text = @"大小分";
    [self.contentView addSubview:upLabel];
    [self.contentView addSubview:downLabel];
    [self.contentView addSubview:self.ratioWinLabel];
    [self.contentView addSubview:self.ratioLoseLabel];
    [self.contentView addSubview:self.rqWinLabel];
    [self.contentView addSubview:self.rqLoseLabel];
    [self.contentView addSubview:self.historyLabel];
    [self.contentView addSubview:self.zhanJiLabel];

    [@[ historyTitleLabel, newZhanJiTitleLabel ] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(-1);
        make.height.equalTo(@25);
        make.width.equalTo(@60);
    }];
    [@[ upLabel ] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ratioTitleLabel.mas_right).offset(-1);
        make.top.equalTo(ratioTitleLabel);
        make.height.equalTo(@26);
        make.width.equalTo(@45);
    }];
    [@[ downLabel ] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ratioTitleLabel.mas_right).offset(-1);
        make.bottom.equalTo(ratioTitleLabel);
        make.height.equalTo(@25);
        make.right.equalTo(upLabel);
    }];
    [@[ self.ratioWinLabel, self.ratioLoseLabel, self.rqWinLabel, self.rqLoseLabel ] mas_makeConstraints:^(MASConstraintMaker *make) {

        make.width.equalTo(@((kScreenWidth - 105) * 0.5));
    }];

    [ratioTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(6);
        make.left.equalTo(self.contentView).offset(-1);
        make.height.equalTo(@50);
        make.width.equalTo(@60);
    }];
    [historyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ratioTitleLabel.mas_bottom).offset(-1);
    }];
    [newZhanJiTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(historyTitleLabel.mas_bottom).offset(-1);
    }];

    NSArray *ratioLabels = @[ upLabel, self.ratioWinLabel, self.ratioLoseLabel ];
    for (int i = 0; i < ratioLabels.count - 1; i++) {
        UILabel *preLabel = ratioLabels[i];
        UILabel *curLabel = ratioLabels[i + 1];
        [curLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(preLabel.mas_right).offset(-1);
            make.top.equalTo(preLabel);
            make.height.equalTo(@26);
        }];
    }
    NSArray *rqLabels = @[ downLabel, self.rqWinLabel, self.rqLoseLabel ];
    for (int i = 0; i < rqLabels.count - 1; i++) {
        UILabel *preLabel = rqLabels[i];
        UILabel *curLabel = rqLabels[i + 1];
        [curLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(preLabel.mas_right).offset(-1);
            make.top.equalTo(preLabel);
            make.height.equalTo(@25);
        }];
    }

    [self.historyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(historyTitleLabel.mas_right).offset(-1);
        make.top.equalTo(historyTitleLabel);
        make.bottom.equalTo(historyTitleLabel);
        make.right.equalTo(self.contentView).offset(1);
    }];

    [self.zhanJiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(newZhanJiTitleLabel.mas_right).offset(-1);
        make.top.equalTo(newZhanJiTitleLabel);
        make.bottom.equalTo(newZhanJiTitleLabel);
        make.right.equalTo(self.contentView).offset(1);
    }];
}

//胜负，让球胜负 大小分
- (void)layOutSpfView {
    UILabel *ratioTitleLabel = [self pvt_titleLabelFactory];
    UILabel *historyTitleLabel = [self pvt_titleLabelFactory];
    UILabel *newZhanJiTitleLabel = [self pvt_titleLabelFactory];
    ratioTitleLabel.text = @"投注比例";
    historyTitleLabel.text = @"历史交锋";
    newZhanJiTitleLabel.text = @"近期战绩";

    [self.contentView addSubview:ratioTitleLabel];
    [self.contentView addSubview:historyTitleLabel];
    [self.contentView addSubview:newZhanJiTitleLabel];
    [self.contentView addSubview:self.ratioWinLabel];
    [self.contentView addSubview:self.ratioLoseLabel];
    [self.contentView addSubview:self.historyLabel];
    [self.contentView addSubview:self.zhanJiLabel];

    [@[ ratioTitleLabel, historyTitleLabel, newZhanJiTitleLabel ] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(-1);
        make.height.equalTo(@25);
        make.width.equalTo(@60);
    }];

    [@[ self.ratioWinLabel, self.ratioLoseLabel ] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@((kScreenWidth - 60) * 0.5));
    }];

    [ratioTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(6);
    }];
    [historyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ratioTitleLabel.mas_bottom).offset(-1);
    }];
    [newZhanJiTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(historyTitleLabel.mas_bottom).offset(-1);
    }];

    NSArray *ratioLabels = @[ ratioTitleLabel, self.ratioWinLabel, self.ratioLoseLabel ];
    for (int i = 0; i < ratioLabels.count - 1; i++) {
        UILabel *preLabel = ratioLabels[i];
        UILabel *curLabel = ratioLabels[i + 1];
        [curLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(preLabel.mas_right).offset(-1);
            make.top.equalTo(preLabel);
            make.bottom.equalTo(preLabel);

        }];
    }

    [self.historyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(historyTitleLabel.mas_right).offset(-1);
        make.top.equalTo(historyTitleLabel);
        make.bottom.equalTo(historyTitleLabel);
        make.right.equalTo(self.contentView).offset(1);
    }];

    [self.zhanJiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(newZhanJiTitleLabel.mas_right).offset(-1);
        make.top.equalTo(newZhanJiTitleLabel);
        make.bottom.equalTo(newZhanJiTitleLabel);
        make.right.equalTo(self.contentView).offset(1);
    }];
}

//胜分差
- (void)layOutBfView {
    UILabel *historyTitleLabel = [self pvt_titleLabelFactory];
    UILabel *newZhanJiTitleLabel = [self pvt_titleLabelFactory];
    historyTitleLabel.text = @"历史交锋";
    newZhanJiTitleLabel.text = @"近期战绩";

    [self.contentView addSubview:historyTitleLabel];
    [self.contentView addSubview:newZhanJiTitleLabel];

    [self.contentView addSubview:self.historyLabel];
    [self.contentView addSubview:self.zhanJiLabel];

    [@[ historyTitleLabel, newZhanJiTitleLabel ] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(-1);
        make.height.equalTo(@25);
        make.width.equalTo(@60);
    }];

    [historyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(6);
    }];
    [newZhanJiTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(historyTitleLabel.mas_bottom).offset(-1);
    }];

    [self.historyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(historyTitleLabel.mas_right).offset(-1);
        make.top.equalTo(historyTitleLabel);
        make.bottom.equalTo(historyTitleLabel);
        make.right.equalTo(self.contentView).offset(1);
    }];

    [self.zhanJiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(newZhanJiTitleLabel.mas_right).offset(-1);
        make.top.equalTo(newZhanJiTitleLabel);
        make.bottom.equalTo(newZhanJiTitleLabel);
        make.right.equalTo(self.contentView).offset(1);
    }];
}

- (UILabel *)pvt_titleLabelFactory {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColorFromRGB(0xfffdbd);
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont dp_boldSystemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.borderColor = [UIColor colorWithRed:0.11 green:0.16 blue:0.2 alpha:1].CGColor;
    label.layer.borderWidth = 1;
    return label;
}

- (UILabel *)rqWinLabel {
    if (_rqWinLabel == nil) {
        _rqWinLabel = [[UILabel alloc] init];
        _rqWinLabel.textColor = [UIColor dp_flatWhiteColor];
        _rqWinLabel.backgroundColor = [UIColor clearColor];
        _rqWinLabel.font = [UIFont dp_boldSystemFontOfSize:12];
        _rqWinLabel.textAlignment = NSTextAlignmentCenter;
        _rqWinLabel.layer.borderColor = [UIColor colorWithRed:0.11 green:0.16 blue:0.2 alpha:1].CGColor;
        _rqWinLabel.layer.borderWidth = 1;
    }
    return _rqWinLabel;
}

- (UILabel *)rqLoseLabel {
    if (_rqLoseLabel == nil) {
        _rqLoseLabel = [[UILabel alloc] init];
        _rqLoseLabel.textColor = [UIColor dp_flatWhiteColor];
        _rqLoseLabel.backgroundColor = [UIColor clearColor];
        _rqLoseLabel.font = [UIFont dp_systemFontOfSize:12];
        _rqLoseLabel.text = @"--";
        _rqLoseLabel.textAlignment = NSTextAlignmentCenter;
        _rqLoseLabel.layer.borderColor = [UIColor colorWithRed:0.11 green:0.16 blue:0.2 alpha:1].CGColor;
        _rqLoseLabel.layer.borderWidth = 1;
    }
    return _rqLoseLabel;
}
- (UILabel *)ratioWinLabel {
    if (_ratioWinLabel == nil) {
        _ratioWinLabel = [[UILabel alloc] init];
        _ratioWinLabel.textColor = [UIColor dp_flatWhiteColor];
        _ratioWinLabel.backgroundColor = [UIColor clearColor];
        _ratioWinLabel.font = [UIFont dp_systemFontOfSize:12];
        _ratioWinLabel.text = @"--";
        _ratioWinLabel.textAlignment = NSTextAlignmentCenter;
        _ratioWinLabel.layer.borderColor = [UIColor colorWithRed:0.11 green:0.16 blue:0.2 alpha:1].CGColor;
        _ratioWinLabel.layer.borderWidth = 1;
    }
    return _ratioWinLabel;
}

- (UILabel *)ratioLoseLabel {
    if (_ratioLoseLabel == nil) {
        _ratioLoseLabel = [[UILabel alloc] init];
        _ratioLoseLabel.textColor = [UIColor dp_flatWhiteColor];
        _ratioLoseLabel.backgroundColor = [UIColor clearColor];
        _ratioLoseLabel.font = [UIFont dp_systemFontOfSize:12];
        _ratioLoseLabel.text = @"--";
        _ratioLoseLabel.textAlignment = NSTextAlignmentCenter;
        _ratioLoseLabel.layer.borderColor = [UIColor colorWithRed:0.11 green:0.16 blue:0.2 alpha:1].CGColor;
        _ratioLoseLabel.layer.borderWidth = 1;
    }
    return _ratioLoseLabel;
}

- (UILabel *)pvt_gridLabelFactory {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithRed:0.89 green:0.9 blue:0.89 alpha:1];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont dp_systemFontOfSize:12];
    label.text = @"--";
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.borderColor = [UIColor colorWithRed:0.11 green:0.16 blue:0.2 alpha:1].CGColor;
    label.layer.borderWidth = 1;
    return label;
}
- (UILabel *)historyLabel {
    if (_historyLabel == nil) {
        _historyLabel = [[UILabel alloc] init];
        _historyLabel.backgroundColor = [UIColor clearColor];
        _historyLabel.userInteractionEnabled = NO;
        _historyLabel.textAlignment = NSTextAlignmentLeft;
        _historyLabel.font = [UIFont dp_systemFontOfSize:12.0];
        _historyLabel.layer.borderColor = [UIColor colorWithRed:0.11 green:0.16 blue:0.2 alpha:1].CGColor;
        _historyLabel.layer.borderWidth = 1;
    }
    return _historyLabel;
}
- (UILabel *)zhanJiLabel {
    if (_zhanJiLabel == nil) {
        _zhanJiLabel = [[UILabel alloc] init];
        _zhanJiLabel.backgroundColor = [UIColor clearColor];
        _zhanJiLabel.userInteractionEnabled = NO;
        _zhanJiLabel.textAlignment = NSTextAlignmentLeft;
        _zhanJiLabel.font = [UIFont dp_systemFontOfSize:12.0];
        _zhanJiLabel.layer.borderColor = [UIColor colorWithRed:0.11 green:0.16 blue:0.2 alpha:1].CGColor;
        _zhanJiLabel.layer.borderWidth = 1;
    }
    return _zhanJiLabel;
}
- (UIActivityIndicatorView *)activityIndicatorView {
    if (_activityIndicatorView == nil) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] init];
        _activityIndicatorView.color = [UIColor whiteColor];
    }
    return _activityIndicatorView;
}
- (void)pvt_onAnalysis {
    if (self.clickBlock) {
        self.clickBlock(self);
    }
}
- (void)upDateAnalysisCellData {
}

@end
