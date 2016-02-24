//
//  DPProjectDetailCell.m
//  Jackpot
//
//  Created by sxf on 15/9/1.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPImageLabel.h"
#import "DPProjectDetailCell.h"

//竞彩足球优化投注详情每一行的视图
@implementation DPJcOptimizeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.screeningLabel];
        [self addSubview:self.homeNameLabel];
        [self addSubview:self.awayNameLabel];
        [self addSubview:self.optionLabel];
        //场次
        [self.screeningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.equalTo(@(kScreenWidth * 0.25));
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        //主队
        [self.homeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.screeningLabel.mas_right);
            make.width.equalTo(@(kScreenWidth * 0.22));
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        //客队
        [self.awayNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.homeNameLabel.mas_right);
            make.width.equalTo(@(kScreenWidth * 0.22));
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        //选项
        [self.optionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.awayNameLabel.mas_right);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        UIView *hline = [UIView dp_viewWithColor:UIColorFromRGB(0x18272e)];
        UIView *vline1 = [UIView dp_viewWithColor:UIColorFromRGB(0x18272e)];
        UIView *vline2 = [UIView dp_viewWithColor:UIColorFromRGB(0x18272e)];
        UIView *vline3 = [UIView dp_viewWithColor:UIColorFromRGB(0x18272e)];
        [self addSubview:hline];
        [self addSubview:vline1];
        [self addSubview:vline2];
        [self addSubview:vline3];
        [hline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.equalTo(@1);
            make.bottom.mas_equalTo(0);
        }];
        [vline1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.homeNameLabel);
            make.width.equalTo(@1);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        [vline2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.awayNameLabel);
            make.width.equalTo(@1);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        [vline3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.optionLabel);
            make.width.equalTo(@1);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

//场次
- (UILabel *)screeningLabel {
    if (_screeningLabel == nil) {
        _screeningLabel = [[UILabel alloc] init];
        _screeningLabel.backgroundColor = [UIColor clearColor];
        _screeningLabel.textColor = UIColorFromRGB(0x9badbb);
        _screeningLabel.textAlignment = NSTextAlignmentCenter;
        _screeningLabel.font = [UIFont systemFontOfSize:11.0];
    }
    return _screeningLabel;
}
//主队
- (UILabel *)homeNameLabel {
    if (_homeNameLabel == nil) {
        _homeNameLabel = [[UILabel alloc] init];
        _homeNameLabel.backgroundColor = [UIColor clearColor];
        _homeNameLabel.textColor = UIColorFromRGB(0x9badbb);
        _homeNameLabel.textAlignment = NSTextAlignmentCenter;
        _homeNameLabel.font = [UIFont systemFontOfSize:11.0];
    }
    return _homeNameLabel;
}
//客队
- (UILabel *)awayNameLabel {
    if (_awayNameLabel == nil) {
        _awayNameLabel = [[UILabel alloc] init];
        _awayNameLabel.backgroundColor = [UIColor clearColor];
        _awayNameLabel.textColor = UIColorFromRGB(0x9badbb);
        _awayNameLabel.textAlignment = NSTextAlignmentCenter;
        _awayNameLabel.font = [UIFont systemFontOfSize:11.0];
    }
    return _awayNameLabel;
}
//选项
- (UILabel *)optionLabel {
    if (_optionLabel == nil) {
        _optionLabel = [[UILabel alloc] init];
        _optionLabel.backgroundColor = [UIColor clearColor];
        _optionLabel.textColor = UIColorFromRGB(0x9badbb);
        _optionLabel.textAlignment = NSTextAlignmentCenter;
        _optionLabel.font = [UIFont systemFontOfSize:11.0];
    }
    return _optionLabel;
}
@end

//大乐透投注
@interface DPProjectDetailCell () {
@private
    UILabel *_titleLabel;    //彩种信息
    UILabel *_infoLabel;     //投注内容
}
@property (nonatomic, strong, readonly) UILabel *titleLabel;    //彩种信息（单复式，注数）

@end
@implementation DPProjectDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView *contentView = self.contentView;
        contentView.backgroundColor = [UIColor dp_flatWhiteColor];
        UIView *backView = [UIView dp_viewWithColor:[UIColor clearColor]];
        [contentView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(-0.5);
        }];
        [backView addSubview:self.titleLabel];
        [backView addSubview:self.infoLabel];
        //彩种信息
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView).offset(16);
            make.right.equalTo(backView).offset(-16);
            make.top.equalTo(backView).offset(6);
            make.height.equalTo(@20);
        }];
        //投注内容
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.right.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(2);
            make.bottom.equalTo(backView).offset(-5);
        }];
        UIImageView *line = [[UIImageView alloc] init];
        line.backgroundColor = [UIColor clearColor];
        line.image = dp_ProjectImage(@"imaginaryline.png");
        self.lineView = line;
        [backView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backView);
            make.left.equalTo(self.infoLabel);
            make.bottom.equalTo(backView);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}
//类型和注数
- (void)titleLabelText:(NSString *)typeText {
    self.titleLabel.text = typeText;
}
//详情
- (void)infoLabelText:(NSMutableAttributedString *)hinString {
    self.infoLabel.attributedText = hinString;
}
#pragma mark - getter, setter
//彩种信息
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = UIColorFromRGB(0x666666);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return _titleLabel;
}
//投注内容
- (UILabel *)infoLabel {
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.textColor = UIColorFromRGB(0x766a53);
        _infoLabel.textAlignment = NSTextAlignmentLeft;
        _infoLabel.font = [UIFont systemFontOfSize:12.0];
        _infoLabel.numberOfLines = 0;
    }
    return _infoLabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//竞彩投注内容
@interface DPJcProjectDetailCell () {
@private
    UILabel *_orderNumberLabel;    //日期编号
    UILabel *_leftNameLabel;
    UILabel *_rightNameLabel;
    UILabel *_resultLabel;           //彩果
    UILabel *_infoLabel;             //投注内容
    UIImageView *_arrowImageView;    //展开箭头
    BOOL _isShowAll;                 //是否展开
    UIImageView *_danImageView;      //设胆
}
@property (nonatomic, strong, readonly) UILabel *orderNumberLabel;    //场次
@property (nonatomic, strong, readonly) UILabel *resultLabel;         //彩果
@property (nonatomic, strong, readonly) UIImageView *arrowImageView;
@end
@implementation DPJcProjectDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        UIView *backView = [UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
        [self.contentView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-2);
        }];
        UILabel *vsLabel = [[UILabel alloc] init];
        vsLabel.backgroundColor = [UIColor clearColor];
        vsLabel.text = @"VS";
        vsLabel.textAlignment = NSTextAlignmentCenter;
        vsLabel.font = [UIFont systemFontOfSize:12.0];
        vsLabel.adjustsFontSizeToFitWidth = YES;
        vsLabel.textColor = UIColorFromRGB(0x8e8e8e);

        UILabel *optionLabel = [[UILabel alloc] init];
        optionLabel.backgroundColor = [UIColor clearColor];
        optionLabel.text = @"选项";
        optionLabel.adjustsFontSizeToFitWidth = YES;
        optionLabel.textAlignment = NSTextAlignmentCenter;
        optionLabel.font = [UIFont systemFontOfSize:12.0];
        optionLabel.textColor = UIColorFromRGB(0x8e8e8e);

        UIView *topView = [UIView dp_viewWithColor:[UIColor clearColor]];
        UIView *topMidView = [UIView dp_viewWithColor:[UIColor clearColor]];
        [backView addSubview:topView];
        [topView addSubview:self.orderNumberLabel];
        [topView addSubview:topMidView];
        [topView addSubview:self.resultLabel];
        [topMidView addSubview:vsLabel];
        [topMidView addSubview:self.leftNameLabel];
        [topMidView addSubview:self.rightNameLabel];
        [topMidView addSubview:self.danImageView];

        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView);
            make.right.equalTo(backView);
            make.top.equalTo(backView);
            make.height.equalTo(@30);
        }];
        [self.orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topView);
            make.width.equalTo(@45);
            make.top.equalTo(topView);
            make.bottom.equalTo(topView);
        }];
        [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(topView);
            make.width.equalTo(@60);
            make.top.equalTo(topView);
            make.bottom.equalTo(topView);
        }];
        [topMidView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderNumberLabel.mas_right);
            make.right.equalTo(self.resultLabel.mas_left);
            make.top.equalTo(topView);
            make.bottom.equalTo(topView);
        }];
        [vsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(topView);
            make.top.equalTo(topView);
            make.bottom.equalTo(topView);
        }];
        [self.danImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderNumberLabel.mas_right);
            make.width.equalTo(@18);
            make.height.equalTo(@18);
            make.centerY.equalTo(topMidView);
        }];

        [self.leftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.danImageView.mas_right);
            make.right.equalTo(vsLabel.mas_left);
            make.top.equalTo(topView);
            make.bottom.equalTo(topView);
        }];
        [self.rightNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(vsLabel.mas_right);
            make.right.equalTo(self.resultLabel.mas_left);
            make.top.equalTo(topView);
            make.bottom.equalTo(topView);
        }];

        UIView *bottomView = [UIView dp_viewWithColor:[UIColor clearColor]];
        [backView addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView);
            make.right.equalTo(backView);
            make.top.equalTo(topView.mas_bottom);
            make.bottom.equalTo(backView);
        }];
        [bottomView addSubview:optionLabel];
        [bottomView addSubview:self.infoLabel];
        [bottomView addSubview:self.arrowImageView];
        [optionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.orderNumberLabel);
            make.right.equalTo(self.orderNumberLabel);
            make.centerY.equalTo(bottomView);
        }];
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(optionLabel.mas_right).offset(5);
            make.right.equalTo(bottomView).offset(-30);
            make.centerY.equalTo(bottomView);
            make.bottom.equalTo(bottomView).offset(-5);
        }];
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bottomView).offset(-10);
            make.width.equalTo(@15);
            make.height.equalTo(@15);
            make.top.equalTo(bottomView).offset(5);
        }];

        UIView *horizontal1 = [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
        UIView *horizontal2 = [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
        UIView *horizontal3 = [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
        UIView *vertical1 = [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
        [backView addSubview:horizontal1];
        [backView addSubview:horizontal2];
        [backView addSubview:horizontal3];
        [backView addSubview:vertical1];
        [horizontal1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backView);
            make.left.equalTo(backView);
            make.height.equalTo(@0.5);
            make.top.equalTo(backView);
        }];
        [horizontal2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backView);
            make.left.equalTo(backView);
            make.height.equalTo(@0.5);
            make.bottom.equalTo(topView);
        }];
        [horizontal3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backView);
            make.left.equalTo(backView);
            make.height.equalTo(@0.5);
            make.bottom.equalTo(backView);
        }];
        [vertical1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(horizontal2);
            make.bottom.equalTo(horizontal3);
            make.width.equalTo(@0.5);
            make.left.equalTo(optionLabel.mas_right);
        }];
        [bottomView addGestureRecognizer:({
                        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onClick)];
                        tapRecognizer;
                    })];
    }
    return self;
}
- (void)pvt_onClick {
    _isShowAll = !_isShowAll;
    if (_isShowAll) {
        self.infoLabel.numberOfLines = 0;
        self.arrowImageView.image = dp_CommonImage(@"brown_smallarrow_up.png");
    } else {
        self.infoLabel.numberOfLines = 1;
        self.arrowImageView.image = dp_CommonImage(@"brown_smallarrow_down.png");
    }
    if (self.clickBlock) {
        self.clickBlock(self, _isShowAll);
    }
}
- (void)imageSelectedView:(BOOL)isShow {
    self.arrowImageView.hidden = !isShow;
    self.contentView.userInteractionEnabled = isShow;
}
//场次
- (void)orderNumberText:(NSString *)text {
    self.orderNumberLabel.text = text;
}

//彩种信息
- (void)resultText:(NSString *)text {
    if (text.length > 0) {
        self.resultLabel.text = text;
        self.resultLabel.textColor = UIColorFromRGB(0xfa2e27);
    } else {
        self.resultLabel.text = @"--";
        self.resultLabel.textColor = UIColorFromRGB(0x8e8e8e);
    }
}
#pragma mark - getter, setter

//日期编号
- (UILabel *)orderNumberLabel {
    if (_orderNumberLabel == nil) {
        _orderNumberLabel = [[UILabel alloc] init];
        _orderNumberLabel.backgroundColor = [UIColor clearColor];
        _orderNumberLabel.textColor = UIColorFromRGB(0x8e8e8e);
        _orderNumberLabel.textAlignment = NSTextAlignmentCenter;
        _orderNumberLabel.font = [UIFont systemFontOfSize:10.0];
        _orderNumberLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _orderNumberLabel;
}
- (UILabel *)leftNameLabel {
    if (_leftNameLabel == nil) {
        _leftNameLabel = [[UILabel alloc] init];
        _leftNameLabel.backgroundColor = [UIColor clearColor];
        _leftNameLabel.textColor = UIColorFromRGB(0x8e8e8e);
        _leftNameLabel.textAlignment = NSTextAlignmentCenter;
        _leftNameLabel.font = [UIFont systemFontOfSize:12.0];
        _leftNameLabel.numberOfLines = 0;
        _leftNameLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _leftNameLabel;
}
- (UILabel *)rightNameLabel {
    if (_rightNameLabel == nil) {
        _rightNameLabel = [[UILabel alloc] init];
        _rightNameLabel.backgroundColor = [UIColor clearColor];
        _rightNameLabel.textColor = UIColorFromRGB(0x8e8e8e);
        _rightNameLabel.textAlignment = NSTextAlignmentCenter;
        _rightNameLabel.font = [UIFont systemFontOfSize:12.0];
        _rightNameLabel.numberOfLines = 0;
        _rightNameLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _rightNameLabel;
}
//彩果
- (UILabel *)resultLabel {
    if (_resultLabel == nil) {
        _resultLabel = [[UILabel alloc] init];
        _resultLabel.backgroundColor = [UIColor clearColor];
        _resultLabel.textColor = UIColorFromRGB(0x8e8e8e);
        _resultLabel.textAlignment = NSTextAlignmentCenter;
        _resultLabel.font = [UIFont systemFontOfSize:12.0];
        _resultLabel.numberOfLines = 0;
        _resultLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _resultLabel;
}
//彩种内容
- (UILabel *)infoLabel {
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.textColor = UIColorFromRGB(0x8e8e8e);
        _infoLabel.textAlignment = NSTextAlignmentLeft;
        _infoLabel.font = [UIFont systemFontOfSize:12.0];
        _infoLabel.numberOfLines = 1;
        _infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _infoLabel.adjustsFontSizeToFitWidth = YES;
        _infoLabel.minimumScaleFactor = 12.0;
    }
    return _infoLabel;
}
//箭头
- (UIImageView *)arrowImageView {
    if (_arrowImageView == nil) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.backgroundColor = [UIColor clearColor];
        _arrowImageView.image = dp_CommonImage(@"brown_smallarrow_down.png");
    }
    return _arrowImageView;
}
//胆
- (UIImageView *)danImageView {
    if (_danImageView == nil) {
        _danImageView = [[UIImageView alloc] init];
        _danImageView.backgroundColor = [UIColor clearColor];
        _danImageView.image = dp_SportLotteryImage(@"selectDan.png");
    }
    return _danImageView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//竞彩优化投注
@interface DPJcOptimizeProjectDetailCell () {
@private
    UILabel *_optimizeInfo;//单注
    UILabel *_zhuLabel; //注数
    UILabel *_bonusLabel;//理论奖金
    UIImageView *_analysisView;//分析图标
    UIImageView *_lineImageView;
}
@property (nonatomic, strong, readonly) UILabel *optimizeInfo;        //单注
@property (nonatomic, strong, readonly) UILabel *zhuLabel;            //注数
@property (nonatomic, strong, readonly) UILabel *bonusLabel;          //理论奖金
@property (nonatomic, strong, readonly) UIImageView *analysisView;    //分析图标
@property (nonatomic, strong, readonly) UIImageView *lineImageView;
@end
@implementation DPJcOptimizeProjectDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *contentView = self.contentView;
        self.contentView.backgroundColor = [UIColor dp_flatBackgroundColor];
        contentView.backgroundColor = [UIColor dp_flatBackgroundColor];
        [contentView addSubview:self.optimizeInfo];
        [contentView addSubview:self.zhuLabel];
        [contentView addSubview:self.bonusLabel];
        [contentView addSubview:self.analysisView];
        //单注
        [self.optimizeInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.width.equalTo(@((kScreenWidth - 16) * 0.54));
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        //分析图标
        [self.analysisView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.optimizeInfo.mas_right).offset(10);
            make.centerY.equalTo(contentView);
            make.height.equalTo(@12.5);
            make.width.equalTo(@12.5);

        }];
        //理论奖金
        [self.bonusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-8);
            make.width.equalTo(@((kScreenWidth - 16) * 0.26));
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        //注数
        [self.zhuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.analysisView.mas_right).offset(6);
            make.right.equalTo(self.bonusLabel.mas_left);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];

        [contentView addSubview:self.lineImageView];
        [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.height.equalTo(@0.5);
            make.bottom.mas_equalTo(0);
        }];
        [contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onHandleTap)]];
    }
    return self;
}
//数据中心倒三角切换
- (void)analysisViewIsExpand:(BOOL)isExpand {
    self.analysisView.highlighted = !isExpand;
    self.lineImageView.hidden = !isExpand;
}
//点击倒三角进入详情
- (void)pvt_onHandleTap {
    if (self.clickBlock) {
        self.clickBlock(self);
    }
}
//设置单注内容
- (void)setOptimizeInfoLabelText:(NSString *)text {
    self.optimizeInfo.text = text;
}
//设置注数
- (void)setZhuLabelText:(NSString *)text {
    self.zhuLabel.text = text;
}
//设置理论奖金
- (void)setBonusLabelText:(NSString *)text {
    self.bonusLabel.text = text;
}
#pragma mark - getter, setter

//单注
- (UILabel *)optimizeInfo {
    if (_optimizeInfo == nil) {
        _optimizeInfo = [[UILabel alloc] init];
        _optimizeInfo.backgroundColor = [UIColor clearColor];
        _optimizeInfo.textColor = UIColorFromRGB(0x7f6b5a);
        _optimizeInfo.textAlignment = NSTextAlignmentLeft;
        _optimizeInfo.font = [UIFont systemFontOfSize:11.0];
    }
    return _optimizeInfo;
}
//注数
- (UILabel *)zhuLabel {
    if (_zhuLabel == nil) {
        _zhuLabel = [[UILabel alloc] init];
        _zhuLabel.backgroundColor = [UIColor clearColor];
        _zhuLabel.textColor = UIColorFromRGB(0x7f6b5a);
        _zhuLabel.textAlignment = NSTextAlignmentCenter;
        _zhuLabel.font = [UIFont systemFontOfSize:11.0];
    }
    return _zhuLabel;
}
//理论奖金
- (UILabel *)bonusLabel {
    if (_bonusLabel == nil) {
        _bonusLabel = [[UILabel alloc] init];
        _bonusLabel.backgroundColor = [UIColor clearColor];
        _bonusLabel.textColor = UIColorFromRGB(0x7f6b5a);
        _bonusLabel.textAlignment = NSTextAlignmentCenter;
        _bonusLabel.font = [UIFont systemFontOfSize:11.0];
    }
    return _bonusLabel;
}
//分析箭头
- (UIImageView *)analysisView {
    if (_analysisView == nil) {
        _analysisView = [[UIImageView alloc] init];
        _analysisView.image = dp_CommonImage(@"brown_smallarrow_down.png");
        _analysisView.highlightedImage = dp_CommonImage(@"brown_smallarrow_up.png");
    }
    return _analysisView;
}
//虚线(展开时需要隐藏)
- (UIImageView *)lineImageView {
    if (_lineImageView == nil) {
        _lineImageView = [[UIImageView alloc] init];
        _lineImageView.backgroundColor = [UIColor clearColor];
        _lineImageView.image = dp_ProjectImage(@"imaginaryline.png");
    }
    return _lineImageView;
}

@end

//竞彩优化投注详情（点击竞彩优化投注展开的）
@implementation DPJcOptimizeListProjectDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = UIColorFromRGB(0x31404a);
        self.viewArray = [[NSMutableArray alloc] init];
    }
    return self;
}
//获取当前需要显示的行数并渲染
- (void)bulidOutForRowCount:(NSInteger)rowCount {
    UIView *hline = [UIView dp_viewWithColor:UIColorFromRGB(0x18272e)];
    [self.contentView addSubview:hline];
    [hline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.equalTo(@1);
        make.top.mas_equalTo(5);
    }];
    for (int i = 0; i < rowCount; i++) {
        DPJcOptimizeView *view = [[DPJcOptimizeView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.tag = 100 + i;
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.equalTo(self.contentView).offset(5 + 27 * i);
            make.height.equalTo(@27);
        }];
        if (i == 0)//如果第一行，则给出标题
        {
            view.screeningLabel.text = @"场次";
            view.homeNameLabel.text = @"主场";
            view.awayNameLabel.text = @"客队";
            view.optionLabel.text = @"选项";
            view.screeningLabel.textColor = UIColorFromRGB(0x9badbb);
            view.homeNameLabel.textColor = UIColorFromRGB(0x9badbb);
            view.awayNameLabel.textColor = UIColorFromRGB(0x9badbb);
            view.optionLabel.textColor = UIColorFromRGB(0x9badbb);
        } else
        {
            view.screeningLabel.textColor = [UIColor dp_flatWhiteColor];
            view.homeNameLabel.textColor = [UIColor dp_flatWhiteColor];
            view.awayNameLabel.textColor = [UIColor dp_flatWhiteColor];
            view.optionLabel.textColor = [UIColor dp_flatWhiteColor];
            [self.viewArray addObject:view];
        }
    }
}
@end

//方案内容区头部
@interface DPProjectHeaderView () {
@private
    UILabel *_projectInfo; //方案内容
    UILabel *_passLabel;   //过关方式
    UILabel *_ticketLabel;  //部分出票
    UIImageView *_ticketImageView; //票样点击标示
}
@property (nonatomic, strong, readonly) UILabel *projectInfo;            //方案内容
@property (nonatomic, strong, readonly) UILabel *passLabel;              //过关方式
@property (nonatomic, strong, readonly) UIImageView *ticketImageView;    //部分出票
@end

@implementation DPProjectHeaderView

- (void)bulidLayOutGameType:(GameTypeId)gameType {
    self.contentView.backgroundColor = [UIColor dp_flatWhiteColor];
    UILabel *projectLabel = [[UILabel alloc] init];
    projectLabel.backgroundColor = [UIColor clearColor];
    projectLabel.text = @"方案内容:";
    projectLabel.adjustsFontSizeToFitWidth = YES;
    projectLabel.textAlignment = NSTextAlignmentLeft;
    projectLabel.font = [UIFont systemFontOfSize:12.0];
    projectLabel.textColor = UIColorFromRGB(0x8e8e8e);
    [self addSubview:projectLabel];
    [self addSubview:self.projectInfo];
    [self addSubview:self.ticketImageView];
    [self.ticketImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
        make.right.equalTo(self).offset(-80);
    }];
    UIImageView *ticketImage = [[UIImageView alloc] init];
    ticketImage.backgroundColor = [UIColor clearColor];
    ticketImage.image = dp_ProjectImage(@"checkTicket.png");
    [self addSubview:ticketImage];
    [self addSubview:self.ticketLabel];

    UIView *line = [UIView dp_viewWithColor:UIColorFromRGB(0xdcdcdc)];
    [self addSubview:line];
    
    if (IsGameTypeJc(gameType) || IsGameTypeLc(gameType)) {//竞彩有过关方式
        UILabel *passTitle = [[UILabel alloc] init];
        passTitle.backgroundColor = [UIColor clearColor];
        passTitle.text = @"过关方式:";
        passTitle.textAlignment = NSTextAlignmentLeft;
        passTitle.font = [UIFont systemFontOfSize:12.0];
        passTitle.textColor = UIColorFromRGB(0x8e8e8e);
        [self addSubview:passTitle];
        [self addSubview:self.passLabel];

        [projectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(16);
            make.width.equalTo(@52);
            make.top.equalTo(self).offset(10);
            make.height.equalTo(@25);
        }];
        [self.projectInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(projectLabel.mas_right).offset(5);
            make.top.equalTo(projectLabel);
            make.bottom.equalTo(projectLabel).offset(-2);
        }];
        [ticketImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.centerY.equalTo(projectLabel);
            make.height.equalTo(@7.5);
            make.width.equalTo(@4.5);
        }];
        [self.ticketLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(ticketImage.mas_left).offset(-5);
            make.centerY.equalTo(ticketImage);
            make.height.equalTo(@25);
        }];

        [passTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(projectLabel);
            make.top.equalTo(projectLabel.mas_bottom).offset(5);
            make.width.equalTo(@52);
            make.height.equalTo(@20);
        }];
        [self.passLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(passTitle.mas_right).offset(5);
            make.right.equalTo(self).offset(-15);
            make.top.equalTo(passTitle);
            make.bottom.equalTo(self).offset(-33);
        }];

        //底部
        UILabel *session = [[UILabel alloc] init];
        session.backgroundColor = [UIColor clearColor];
        session.text = @"场次";
        session.textAlignment = NSTextAlignmentCenter;
        session.font = [UIFont systemFontOfSize:12.0];
        session.textColor = UIColorFromRGB(0x8e8e8e);
        [self addSubview:session];
        UILabel *encounter = [[UILabel alloc] init];
        encounter.backgroundColor = [UIColor clearColor];
        encounter.text = @"对阵";
        encounter.textAlignment = NSTextAlignmentCenter;
        encounter.font = [UIFont systemFontOfSize:12.0];
        encounter.textColor = UIColorFromRGB(0x8e8e8e);
        [self addSubview:encounter];
        UILabel *result = [[UILabel alloc] init];
        result.backgroundColor = [UIColor clearColor];
        result.text = @"彩果";
        result.textAlignment = NSTextAlignmentCenter;
        result.font = [UIFont systemFontOfSize:12.0];
        result.textColor = UIColorFromRGB(0x8e8e8e);
        [self addSubview:result];
        [session mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.width.equalTo(@40);
            make.bottom.equalTo(self);
            make.height.equalTo(@20);
        }];
        [encounter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.equalTo(@40);
            make.top.equalTo(session);
            make.bottom.equalTo(session);
        }];
        [result mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.width.equalTo(@40);
            make.top.equalTo(session);
            make.bottom.equalTo(session);
        }];

        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.equalTo(@0.5);
            make.bottom.equalTo(self).offset(-20);
        }];
        UIView *line2 = [UIView dp_viewWithColor:UIColorFromRGB(0xdcdcdc)];
        [self addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.equalTo(@1);
        }];

    } else { //数字彩没有过关方式
        [projectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(16);
            make.centerY.equalTo(self);
            make.height.equalTo(@30);
        }];
        [self.projectInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(projectLabel.mas_right).offset(5);
            make.centerY.equalTo(self);
            make.top.equalTo(projectLabel);
            make.bottom.equalTo(projectLabel);
        }];
        [ticketImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.centerY.equalTo(projectLabel);
            make.height.equalTo(@7.5);
            make.width.equalTo(@4.5);
        }];
        [self.ticketLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(ticketImage.mas_left).offset(-5);
            make.centerY.equalTo(ticketImage);
            make.height.equalTo(@20);
        }];

        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.equalTo(@0.5);
            make.bottom.equalTo(self);
        }];
    }
}
//获取方案内容
- (void)projectInfoText:(NSString *)infoText {
    self.projectInfo.text = infoText;
}
//获取过关方式
- (void)passLabelText:(NSString *)passText {
    self.passLabel.text = passText;
}
//是否显示部分出票图片
- (void)isShowTicketImage:(BOOL)isShow {
    self.ticketImageView.hidden = !isShow;
}

#pragma mark - getter, setter

//方案内容
- (UILabel *)projectInfo {
    if (_projectInfo == nil) {
        _projectInfo = [[UILabel alloc] init];
        _projectInfo.backgroundColor = [UIColor clearColor];
        _projectInfo.textColor = UIColorFromRGB(0x333333);
        _projectInfo.textAlignment = NSTextAlignmentLeft;
        _projectInfo.font = [UIFont systemFontOfSize:14.0];
        _projectInfo.adjustsFontSizeToFitWidth = YES;
    }
    return _projectInfo;
}
//过关方式
- (UILabel *)passLabel {
    if (_passLabel == nil) {
        _passLabel = [[UILabel alloc] init];
        _passLabel.backgroundColor = [UIColor clearColor];
        _passLabel.textColor = UIColorFromRGB(0x333333);
        _passLabel.textAlignment = NSTextAlignmentLeft;
        _passLabel.font = [UIFont systemFontOfSize:14.0];
        _passLabel.numberOfLines = 0;
        //       _passLabel.adjustsFontSizeToFitWidth=YES;
        _passLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _passLabel;
}
//部分出票
- (UILabel *)ticketLabel {
    if (_ticketLabel == nil) {
        _ticketLabel = [[UILabel alloc] init];
        _ticketLabel.backgroundColor = [UIColor clearColor];
        _ticketLabel.textColor = UIColorFromRGB(0x8e8e8e);
        _ticketLabel.textAlignment = NSTextAlignmentRight;
        _ticketLabel.font = [UIFont systemFontOfSize:12.0];
        _ticketLabel.clipsToBounds = YES;
        _ticketLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _ticketLabel;
}
//票样点击标示
- (UIImageView *)ticketImageView {
    if (_ticketImageView == nil) {
        _ticketImageView = [[UIImageView alloc] init];
        _ticketImageView.backgroundColor = [UIColor clearColor];
        _ticketImageView.image = dp_AccountImage(@"UAOpening.png");
    }
    return _ticketImageView;
}
@end

//优化投注区头部
@implementation DPOptimizeHeaderView

- (void)bulidLayOut {
    self.contentView.backgroundColor = [UIColor dp_flatBackgroundColor];
    UIView *topView = [UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
    UIView *bottomView = [UIView dp_viewWithColor:[UIColor clearColor]];
    UIView *line1 = [UIView dp_viewWithColor:UIColorFromRGB(0xd0cfcd)];
    UIView *line2 = [UIView dp_viewWithColor:UIColorFromRGB(0xd0cfcd)];
    UIImageView *lineView = [[UIImageView alloc] init];
    lineView.image = dp_ProjectImage(@"imaginaryline.png");
    lineView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [self createLabel:@"优化详情" textColor:UIColorFromRGB(0x333333) textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:14.0]];
    UILabel *infoLabel = [self createLabel:@"单注" textColor:UIColorFromRGB(0x333333) textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:11.0]];
    UILabel *zhuLabel = [self createLabel:@"注数" textColor:UIColorFromRGB(0x333333) textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:11.0]];
    UILabel *bonusLabel = [self createLabel:@"理论奖金" textColor:UIColorFromRGB(0x333333) textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:11.0]];
    [self.contentView addSubview:topView];
    [self.contentView addSubview:bottomView];
    [topView addSubview:titleLabel];
    [bottomView addSubview:infoLabel];
    [bottomView addSubview:zhuLabel];
    [bottomView addSubview:bonusLabel];
    [topView addSubview:line1];
    [topView addSubview:line2];
    [bottomView addSubview:lineView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(12);
        make.height.equalTo(@30);
    }];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.equalTo(topView.mas_bottom);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.width.equalTo(@((kScreenWidth - 16) * 0.54));
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    [bonusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.width.equalTo(@((kScreenWidth - 16) * 0.26));
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    [zhuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bonusLabel.mas_left);
        make.left.equalTo(infoLabel.mas_right).offset(20);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];

    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.equalTo(@0.5);
        make.top.mas_equalTo(0);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.equalTo(@0.5);
        make.bottom.mas_equalTo(0);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.bottom.mas_equalTo(0);
        make.height.equalTo(@0.5);
    }];
}

- (UILabel *)createLabel:(NSString *)text textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    label.font = font;
    return label;
}

@end