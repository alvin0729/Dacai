//
//  DPJingCaiMoreView.m
//  DacaiProject
//
//  Created by sxf on 14-7-16.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPJingCaiMoreView.h"
#import "DPBetToggleControl.h"
#import "DPJczqDataModel.h"

@interface DPFootBallMore () {
    GameTypeId _gameType;
}

@property (nonatomic, strong, readonly) UIScrollView *contentView;

@property (nonatomic, strong) NSArray *sp_rqspf;    //让球胜平负
@property (nonatomic, strong) NSArray *sp_bf;       //比分
@property (nonatomic, strong) NSArray *sp_zjq;      //总进球
@property (nonatomic, strong) NSArray *sp_bqc;      //半全场
@property (nonatomic, strong) NSArray *sp_spf;      //胜平负

@property (nonatomic, strong, readonly) UIImageView *dan_rqspf;    //让球单关
@property (nonatomic, strong, readonly) UIImageView *dan_spf;      //胜平负单关
@property (nonatomic, strong, readonly) UIImageView *dan_bf;       //比分单关
@property (nonatomic, strong, readonly) UIImageView *dan_zjq;      //总进球单关
@property (nonatomic, strong, readonly) UIImageView *dan_bqc;      //半全场单关

@end

@implementation DPFootBallMore
@synthesize contentView = _contentView, dan_spf = _dan_spf, dan_rqspf = _dan_rqspf, dan_bf = _dan_bf, dan_zjq = _dan_zjq, dan_bqc = _dan_bqc, view_spf = _view_spf, view_zjq = _view_zjq, view_rqspf = _view_rqspf, view_bf = _view_bf, view_bqc = _view_bqc, view_signalBqc = _view_signalBqc;

- (instancetype)initWithGameType:(GameTypeId)gameType {
    self = [super init];
    if (self) {
        _gameType = gameType;
    }
    return self;
}

#pragma mark - Getter
- (UIImageView *)dan_spf {
    if (_dan_spf == nil) {
        _dan_spf = [[UIImageView alloc] init];
        _dan_spf.backgroundColor = [UIColor dp_flatRedColor];
        _dan_spf.backgroundColor = [UIColor clearColor];
        [_dan_spf setImage:dp_SportLotteryImage(@"htdanguan.png")];
    }
    return _dan_spf;
}
- (UIImageView *)dan_rqspf {
    if (_dan_rqspf == nil) {
        _dan_rqspf = [[UIImageView alloc] init];
        _dan_rqspf.backgroundColor = [UIColor dp_flatRedColor];
        _dan_rqspf.backgroundColor = [UIColor clearColor];
        [_dan_rqspf setImage:dp_SportLotteryImage(@"htdanguan.png")];
    }
    return _dan_rqspf;
}
- (UIImageView *)dan_bf {
    if (_dan_bf == nil) {
        _dan_bf = [[UIImageView alloc] init];
        _dan_bf.backgroundColor = [UIColor dp_flatRedColor];
        _dan_bf.backgroundColor = [UIColor clearColor];
        [_dan_bf setImage:dp_SportLotteryImage(@"danguan.png")];
    }
    return _dan_bf;
}
- (UIImageView *)dan_zjq {
    if (_dan_zjq == nil) {
        _dan_zjq = [[UIImageView alloc] init];
        _dan_zjq.backgroundColor = [UIColor dp_flatRedColor];
        _dan_zjq.backgroundColor = [UIColor clearColor];
        [_dan_zjq setImage:dp_SportLotteryImage(@"danguan.png")];
    }
    return _dan_zjq;
}
- (UIImageView *)dan_bqc {
    if (_dan_bqc == nil) {
        _dan_bqc = [[UIImageView alloc] init];
        _dan_bqc.backgroundColor = [UIColor dp_flatRedColor];
        _dan_bqc.backgroundColor = [UIColor clearColor];
        [_dan_bqc setImage:dp_SportLotteryImage(@"danguan.png")];
    }
    return _dan_bqc;
}

- (DPBetToggleControl *)horBet {
    DPBetToggleControl *bet = [DPBetToggleControl horizontalControl];
    [bet addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    bet.showBorderWhenSelected = YES;
    return bet;
}
- (DPBetToggleControl *)vertBet {
    DPBetToggleControl *bet = [DPBetToggleControl verticalControl];
    [bet addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    bet.showBorderWhenSelected = YES;
    return bet;
}
- (void)buttonClick:(DPBetToggleControl *)bet {
    bet.selected = !bet.selected;
}
- (UILabel *)createNoSelllabel {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
    label.text = @"未开售";
    label.textColor = [UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont dp_regularArialOfSize:15.0];
    label.layer.borderWidth = 0.5;
    label.layer.borderColor = [UIColor colorWithRed:0.88 green:0.85 blue:0.78 alpha:1].CGColor;

    return label;
}
- (UIView *)createTitleView:(NSString *)title {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    UIView *imageView = [[UIView alloc] init];
    imageView.backgroundColor = [UIColor colorWithRed:126.0 / 255 green:107.0 / 255 blue:91.0 / 255 alpha:1.0];
    [view addSubview:imageView];

    UILabel *titlelabel = [[UILabel alloc] init];
    titlelabel.text = title;
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.textColor = UIColorFromRGB(0x7e6b5a);
    titlelabel.textAlignment = NSTextAlignmentLeft;
    titlelabel.font = [UIFont dp_systemFontOfSize:12.0];
    [view addSubview:titlelabel];

    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithRed:205.0 / 255 green:204.0 / 255 blue:198.0 / 255 alpha:1.0];
    [view addSubview:line];

    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.width.equalTo(@5);
        make.top.equalTo(view.mas_centerY).offset(-2.5);
        make.bottom.equalTo(view.mas_centerY).offset(2.5);
    }];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(2);
        make.width.equalTo(@40);
        make.top.equalTo(view.mas_centerY).offset(-10);
        make.bottom.equalTo(view.mas_centerY).offset(10);
    }];

    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titlelabel.mas_right);
        make.right.equalTo(view).offset(20);
        make.top.equalTo(view.mas_centerY).offset(-0.25);
        make.bottom.equalTo(view.mas_centerY).offset(0.25);
    }];
    return view;
}

- (JczqOption)option {
    JczqOption option;
    switch (_gameType) {
        case GameTypeJcDgAll:
        case GameTypeJcDg:
            option = self.match.matchOption.dgOption;
            break;
        case GameTypeJcHt:
            option = self.match.matchOption.htOption;
            break;
        default:
            option = self.match.matchOption.normalOption;
            break;
    }
    return option;
}
#pragma mark - 胜平负视图
- (UIView *)view_spf {
    if (_view_spf == nil) {
        _view_spf = [[UIView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = UIColorFromRGB(0x01ab81);
        label.textColor = [UIColor dp_flatWhiteColor];
        label.font = [UIFont systemFontOfSize:12.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor dp_flatWhiteColor];
        label.backgroundColor = [UIColor colorWithRed:0 green:0.67 blue:0.51 alpha:1];
        label.layer.borderWidth = 0;
        label.text = @"0";
        [_view_spf addSubview:label];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_view_spf);
            make.width.equalTo(@16);
            make.top.equalTo(_view_spf).offset(8.5);
            make.bottom.equalTo(_view_spf).offset(-0.5);
        }];

        self.dan_spf.hidden = !(self.match.spfItem.supportSingle && _gameType == GameTypeJcHt);
        [_view_spf addSubview:self.dan_spf];
        [self.dan_spf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@30.5);
            make.height.equalTo(@14);
            make.left.equalTo(_view_spf).offset(7);
            make.top.equalTo(_view_spf).offset(8.5);
        }];

        if (!self.match.spfItem.gameVisible) {
            label.textColor = [UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
            label.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
            label.layer.borderColor = [UIColor colorWithRed:0.88 green:0.85 blue:0.78 alpha:1].CGColor;
            label.layer.borderWidth = 0.5;

            UILabel *stopCellspf_ = [self createNoSelllabel];
            [_view_spf addSubview:stopCellspf_];

            [stopCellspf_ mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label.mas_right).offset(3);
                make.right.equalTo(_view_spf);
                make.top.equalTo(_view_spf).offset(8);
                make.bottom.equalTo(_view_spf);
            }];
            [_view_spf bringSubviewToFront:self.dan_spf];

            return _view_spf;
        }

        NSArray *option128 = @[ self.horBet, self.horBet, self.horBet ];
        [option128 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [_view_spf addSubview:obj];
        }];
        NSArray *titleArray = [NSArray arrayWithObjects:@"胜", @"平", @"负", nil];

        for (int i = 0; i < option128.count; i++) {
            DPBetToggleControl *obj = option128[i];
            obj.selected = NO;
            if (self.option.betSpf[i] == 1) {
                obj.selected = YES;
            }
            [obj setTag:(GameTypeJcSpf << 16) | i];
            obj.titleText = [titleArray objectAtIndex:i];
            obj.oddsText = self.match.spfItem.spListArray[i];
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(_view_spf).valueOffset(@-5.7).dividedBy(3);
                make.top.equalTo(_view_spf).offset(8);
                make.bottom.equalTo(_view_spf);
            }];

            if (!self.match.spfItem.gameVisible) {
                obj.titleColor = [UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
                obj.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
                obj.oddsText = @"";
            }

            if (i == 0) {
                [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(label.mas_right).offset(3);
                }];
            }
            if (i >= option128.count - 1) {    // 每行5个选项
                continue;
            }
            DPBetToggleControl *obj1 = option128[i];
            DPBetToggleControl *obj2 = option128[i + 1];

            [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(obj1.mas_right).offset(-1);
            }];
        }
        [_view_spf bringSubviewToFront:self.dan_spf];
    }
    return _view_spf;
}

#pragma mark - 让球胜平负视图

- (UIView *)view_rqspf {
    if (_view_rqspf == nil) {
        _view_rqspf = [[UIView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = UIColorFromRGB(0xffb527);
        label.textAlignment = NSTextAlignmentCenter;
        //        label.layer.cornerRadius=6;
        label.font = [UIFont systemFontOfSize:12.0];
        label.text = [NSString stringWithFormat:@"%@%lld", self.match.rqs > 0 ? @"+" : @"", self.match.rqs];
        label.textColor = self.match.rqs > 0 ? [UIColor dp_flatRedColor] : [UIColor dp_flatBlueColor];
        [_view_rqspf addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_view_rqspf);
            make.width.equalTo(@16);
            make.top.equalTo(_view_rqspf).offset(2.5);
            make.bottom.equalTo(_view_rqspf).offset(-0.5);
        }];

        self.dan_rqspf.hidden = !(self.match.rqspfItem.supportSingle && _gameType == GameTypeJcHt);
        [_view_rqspf addSubview:self.dan_rqspf];
        [self.dan_rqspf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@30.5);
            make.height.equalTo(@14);
            make.left.equalTo(_view_rqspf).offset(7);
            make.top.equalTo(_view_rqspf).offset(2.5);
        }];

        if (!self.match.rqspfItem.gameVisible) {
            label.textColor = [UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];

            label.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
            label.layer.borderColor = [UIColor colorWithRed:0.91 green:0.88 blue:0.82 alpha:1.0].CGColor;
            label.layer.borderWidth = 0.5;

            UILabel *stopCellspf_ = [self createNoSelllabel];
            [_view_rqspf addSubview:stopCellspf_];

            [stopCellspf_ mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label.mas_right).offset(3);
                make.right.equalTo(_view_rqspf);
                make.top.equalTo(_view_rqspf).offset(2);
                make.bottom.equalTo(_view_rqspf);
            }];
            [_view_rqspf bringSubviewToFront:self.dan_rqspf];

            return _view_rqspf;
        }

        NSArray *option121 = @[ self.horBet, self.horBet, self.horBet ];
        NSArray *titleArray = [NSArray arrayWithObjects:@"胜", @"平", @"负", nil];
        [option121 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [_view_rqspf addSubview:obj];
        }];
        for (int i = 0; i < option121.count; i++) {
            DPBetToggleControl *obj = option121[i];
            obj.selected = NO;
            if (self.option.betRqspf[i]) {
                obj.selected = YES;
            }
            [obj setTag:(GameTypeJcRqspf << 16) | i];
            obj.oddsText = self.match.rqspfItem.spListArray[i];
            obj.titleText = [titleArray objectAtIndex:i];
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(_view_rqspf).valueOffset(@-5.7).dividedBy(3);
                make.top.equalTo(_view_rqspf).offset(2);
                make.bottom.equalTo(_view_rqspf);
            }];
            if (!self.match.rqspfItem.gameVisible) {
                obj.titleColor = [UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
                obj.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
                obj.oddsText = @"";
            }

            if (i == 0) {
                [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(label.mas_right).offset(3);
                }];
            }
            if (i >= option121.count - 1) {    // 每行5个选项
                continue;
            }
            DPBetToggleControl *obj1 = option121[i];
            DPBetToggleControl *obj2 = option121[i + 1];

            [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(obj1.mas_right).offset(-1);
            }];
        }

        [_view_rqspf bringSubviewToFront:self.dan_rqspf];
    }
    return _view_rqspf;
}

#pragma mark -比分视图

- (UIView *)view_bf {
    if (_view_bf == nil) {
        _view_bf = [[UIView alloc] init];

        UIView *cmpView;
        if (_gameType == GameTypeJcHt || _gameType == GameTypeJcDg || _gameType == GameTypeJcDgAll) {
            UIView *scrollTitleView = [self createTitleView:@"比分"];

            [_view_bf addSubview:scrollTitleView];
            [scrollTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_view_bf);
                make.top.equalTo(_view_bf);
                make.height.equalTo(@25);
                make.right.equalTo(_view_bf);

            }];
            self.dan_bf.hidden = !(self.match.bfItem.supportSingle && _gameType == GameTypeJcHt);

            [scrollTitleView addSubview:self.dan_bf];
            [self.dan_bf mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@28.5);
                make.height.equalTo(@14);
                make.left.equalTo(scrollTitleView).offset(32);
                make.centerY.equalTo(scrollTitleView);
            }];
            cmpView = scrollTitleView;
        } else {
            cmpView = _view_bf;
        }

        NSArray *option122 = @[ self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet ];
        [option122 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [_view_bf addSubview:obj];
        }];
        NSArray *titleArray = [NSArray arrayWithObjects:
                                           @"1:0", @"2:0", @"2:1", @"3:0", @"3:1", @"3:2", @"4:0", @"4:1", @"4:2", @"5:0", @"5:1", @"5:2", @"胜其他",
                                           @"0:0", @"1:1", @"2:2", @"3:3", @"平其他", @"0:1", @"0:2", @"1:2", @"0:3", @"1:3", @"2:3", @"0:4", @"1:4", @"2:4", @"0:5",
                                           @"1:5", @"2:5", @"负其他", nil];
        for (int i = 0; i < option122.count; i++) {
            DPBetToggleControl *obj = option122[i];
            obj.selected = NO;
            if (self.option.betBf[i] == 1) {
                obj.selected = YES;
            }
            [obj setTag:(GameTypeJcBf << 16) | i];
            obj.oddsText = self.match.bfItem.spListArray[i];
            obj.titleText = [titleArray objectAtIndex:i];
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@30);
                if (_gameType == GameTypeJcHt || _gameType == GameTypeJcDg || _gameType == GameTypeJcDgAll) {
                    if (i < 7) {
                        make.top.equalTo(cmpView.mas_bottom).offset(5);
                    } else if (i < 13) {
                        make.top.equalTo(cmpView.mas_bottom).offset(29 + 5);
                    } else if (i < 18) {
                        make.top.equalTo(cmpView.mas_bottom).offset(30 * 2 - 1 + 3 + 5);
                    } else if (i < 25) {
                        make.top.equalTo(cmpView.mas_bottom).offset(30 * 3 - 1 + 3 + 3 + 5);
                    } else {
                        make.top.equalTo(cmpView.mas_bottom).offset(30 * 4 - 1 + 6 - 1 + 5);
                    }

                } else {
                    if (i < 7) {
                        make.top.equalTo(cmpView).offset(5 + 12);
                    } else if (i < 13) {
                        make.top.equalTo(cmpView).offset(29 + 5 + 12);
                    } else if (i < 18) {
                        make.top.equalTo(cmpView).offset(30 * 2 - 1 + 3 + 5 + 12);
                    } else if (i < 25) {
                        make.top.equalTo(cmpView).offset(30 * 3 - 1 + 3 + 3 + 5 + 12);
                    } else {
                        make.top.equalTo(cmpView).offset(30 * 4 - 1 + 6 - 1 + 5 + 12);
                    }
                }
                if ((i == 0) || (i == 7) || (i == 13) || (i == 18) || (i == 25)) {
                    make.left.equalTo(_view_bf);
                    make.width.equalTo(_view_bf).multipliedBy(1.0 / 7);
                } else if ((i == 17) || (i == 6) || (i == 12) || (i == 24) || (i == 30)) {
                    make.right.equalTo(_view_bf);
                } else {
                    make.width.equalTo(_view_bf).multipliedBy(1.0 / 7);
                }
            }];

            if ((i == 6) || (i == 12) || (i == 17) || (i == 24) || (i >= option122.count - 1)) {    // 每行5个选项
                continue;
            }
            DPBetToggleControl *obj1 = option122[i];
            DPBetToggleControl *obj2 = option122[i + 1];
            [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(obj1.mas_right).offset(-1);
            }];
        }
    }
    return _view_bf;
}

#pragma mark - 总进球视图

- (UIView *)view_zjq {
    if (_view_zjq == nil) {
        _view_zjq = [[UIView alloc] init];

        UIView *cmpView;
        if (_gameType == GameTypeJcHt || _gameType == GameTypeJcDg || _gameType == GameTypeJcDgAll) {
            UIView *totalTitleView = [self createTitleView:@"总进球"];
            [_view_zjq addSubview:totalTitleView];
            [totalTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_view_zjq);
                make.top.equalTo(_view_zjq);
                make.height.equalTo(@25);
                make.right.equalTo(_view_zjq);

            }];
            self.dan_zjq.hidden = !(self.match.zjqItem.supportSingle && _gameType == GameTypeJcHt);
            [totalTitleView addSubview:self.dan_zjq];
            [self.dan_zjq mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@28.5);
                make.height.equalTo(@14);
                make.left.equalTo(totalTitleView).offset(45);
                make.centerY.equalTo(totalTitleView);
            }];
            cmpView = totalTitleView;
        } else
            cmpView = _view_zjq;

        NSArray *option123 = @[ self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet ];
        [option123 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [_view_zjq addSubview:obj];
        }];
        NSArray *titleArray = [NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7+", nil];
        for (int i = 0; i < option123.count; i++) {
            DPBetToggleControl *obj = option123[i];
            [obj setTag:(GameTypeJcZjq << 16) | i];
            obj.selected = NO;
            if (self.option.betZjq[i] == 1) {
                obj.selected = YES;
            }
            obj.oddsText = self.match.zjqItem.spListArray[i];
            obj.titleText = [titleArray objectAtIndex:i];
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(_view_zjq).multipliedBy(0.25);
                if (_gameType == GameTypeJcHt || _gameType == GameTypeJcDg || _gameType == GameTypeJcDgAll) {
                    make.height.equalTo(@30);
                } else {
                    make.height.equalTo(@35);
                }
                if (i < 4) {
                    if (_gameType == GameTypeJcHt || _gameType == GameTypeJcDg || _gameType == GameTypeJcDgAll) {
                        make.top.equalTo(cmpView.mas_bottom).offset(5);
                    } else {
                        make.top.equalTo(cmpView).offset(5 + 12);
                    }
                } else {
                    make.top.equalTo(((UIButton *)option123.firstObject).mas_bottom).offset(-1);
                }
            }];
            if (i % 4 == 0) {
                [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_view_zjq);
                }];
            }
            if ((i + 1) % 4 == 0 || (i >= option123.count - 1)) {    // 每行5个选项
                continue;
            }
            DPBetToggleControl *obj1 = option123[i];
            DPBetToggleControl *obj2 = option123[i + 1];

            [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(obj1.mas_right).offset(-1);
            }];
        }
    }
    return _view_zjq;
}

#pragma mark - 半全场视图

- (UIView *)view_bqc {
    if (_view_bqc == nil) {
        _view_bqc = [[UIView alloc] init];
        UIView *cmpView;
        if (_gameType == GameTypeJcHt || _gameType == GameTypeJcDg || _gameType == GameTypeJcDgAll) {
            UIView *halfTitleView = [self createTitleView:@"半全场"];
            [_view_bqc addSubview:halfTitleView];
            [halfTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_view_bqc);
                make.top.equalTo(_view_bqc);
                make.height.equalTo(@25);
                make.right.equalTo(_view_bqc);
            }];
            self.dan_bqc.hidden = !(self.match.bqcItem.supportSingle && _gameType == GameTypeJcHt);

            [halfTitleView addSubview:self.dan_bqc];
            [self.dan_bqc mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@28.5);
                make.height.equalTo(@14);
                make.left.equalTo(halfTitleView).offset(45);
                make.centerY.equalTo(halfTitleView);
            }];
            cmpView = halfTitleView;
        } else
            cmpView = _view_bqc;

        NSArray *option124 = @[ self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet, self.vertBet ];
        [option124 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [_view_bqc addSubview:obj];
        }];
        NSArray *titleArray = [NSArray arrayWithObjects:@"胜胜", @"胜平", @"胜负", @"平胜", @"平平", @"平负", @"负胜", @"负平", @"负负", nil];
        for (int i = 0; i < option124.count; i++) {
            DPBetToggleControl *obj = option124[i];
            [obj setTag:(GameTypeJcBqc << 16) | i];
            obj.selected = NO;
            if (self.option.betBqc[i] == 1) {
                obj.selected = YES;
            }
            if (i < titleArray.count) {
                obj.oddsText = self.match.bqcItem.spListArray[i];
                obj.titleText = [titleArray objectAtIndex:i];
            } else {
                obj.userInteractionEnabled = NO;
                obj.selected = 0;
            }
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(_view_bqc).multipliedBy(0.2);
                if (_gameType == GameTypeJcHt || _gameType == GameTypeJcDg || _gameType == GameTypeJcDgAll) {
                    make.height.equalTo(@30);
                } else {
                    make.height.equalTo(@35);
                }
                if (i < 5) {
                    if (_gameType == GameTypeJcHt || _gameType == GameTypeJcDg || _gameType == GameTypeJcDgAll) {
                        make.top.equalTo(cmpView.mas_bottom).offset(5);
                    } else {
                        make.top.equalTo(cmpView).offset(5 + 12);
                    }
                } else {
                    make.top.equalTo(((UIButton *)option124.firstObject).mas_bottom).offset(-1);
                }
            }];
            if (i % 5 == 0) {
                [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_view_bqc);
                }];
            }
            if ((i + 1) % 5 == 0 || (i >= option124.count - 1)) {    // 每行5个选项
                continue;
            }
            UIButton *obj1 = option124[i];
            UIButton *obj2 = option124[i + 1];

            [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(obj1.mas_right).offset(-1);
            }];
        }
    }
    return _view_bqc;
}

- (UIView *)view_signalBqc {
    if (_view_signalBqc == nil) {
        _view_signalBqc = [[UIView alloc] init];

        NSArray *option124 = @[ self.horBet, self.horBet, self.horBet, self.horBet, self.horBet, self.horBet, self.horBet, self.horBet, self.horBet ];
        [option124 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [_view_signalBqc addSubview:obj];
        }];
        NSArray *titleArray = [NSArray arrayWithObjects:@"胜胜", @"胜平", @"胜负", @"平胜", @"平平", @"平负", @"负胜", @"负平", @"负负", nil];
        for (int i = 0; i < option124.count; i++) {
            DPBetToggleControl *obj = option124[i];
            [obj setTag:(GameTypeJcBqc << 16) | i];
            obj.selected = NO;
            if (self.option.betBqc[i] == 1) {
                obj.selected = YES;
            }
            if (i < titleArray.count) {
                obj.oddsText = self.match.bqcItem.spListArray[i];
                obj.titleText = [titleArray objectAtIndex:i];
            } else {
                obj.userInteractionEnabled = NO;
                obj.selected = 0;
            }
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(_view_signalBqc).valueOffset(@-1.33).dividedBy(3);
                make.height.equalTo(@26);
                if (i % 3 == 0) {
                    make.top.equalTo(_view_signalBqc).offset((4 + 26) * i / 3 + 16);
                    make.left.equalTo(_view_signalBqc);
                } else {
                    make.top.equalTo(((UIButton *)option124[i - 1]));
                    make.left.equalTo(((UIButton *)option124[i - 1]).mas_right).offset(2);
                }
            }];
        }
    }

    return _view_signalBqc;
}

- (void)setMatch:(PBMJczqMatch *)match {
    _match = match;

    self.sp_spf = match.spfItem.spListArray;
    self.sp_rqspf = match.rqspfItem.spListArray;
    self.sp_bf = match.bfItem.spListArray;
    self.sp_zjq = match.zjqItem.spListArray;
    self.sp_bqc = match.bqcItem.spListArray;
}

@end

@interface DPFootBallMoreViewController () <UITableViewDelegate, UITableViewDataSource> {
    UIView *_backgroundView;
    GameTypeId _gameType;
    PBMJczqMatch *_match;
    DPFootBallMore *_footBallMore;
    UILabel *_rangQiuLabel;

    NSMutableArray *_typeArr;
}

@property (nonatomic, strong, readonly) UILabel *rangQiuLabel;    // 让球
@property (nonatomic, strong, readonly) UIImageView *hotView;     //热门赛事

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DPFootBallMoreViewController
@synthesize hotView = _hotView;

- (instancetype)initWithGameType:(GameTypeId)gameType match:(PBMJczqMatch *)match {
    self = [super init];
    if (self) {
        _gameType = gameType;
        _match = match;
     }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor clearColor]];

    _backgroundView = [[UIView alloc] init];
    _backgroundView.backgroundColor = UIColorFromRGB(0xF5F0EC);
    _backgroundView.layer.cornerRadius = 10;
    _backgroundView.clipsToBounds = YES;
    _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:_backgroundView];

    _footBallMore = [[DPFootBallMore alloc] initWithGameType:_gameType];
    _footBallMore.match = _match;

    switch (_gameType) {
        case GameTypeJcHt: {
            //            _typeArr = [NSMutableArray arrayWithArray:@[ [NSNumber numberWithInt:GameTypeJcSpf], [NSNumber numberWithInt:GameTypeJcRqspf], [NSNumber numberWithInt:GameTypeJcBf], [NSNumber numberWithInt:GameTypeJcZjq], [NSNumber numberWithInt:GameTypeJcBqc] ]];

            _typeArr = [NSMutableArray arrayWithArray:@[ [NSNumber numberWithInt:GameTypeJcSpf], [NSNumber numberWithInt:GameTypeJcRqspf] ]];

            if (_match.bfItem.gameVisible) {
                [_typeArr addObject:[NSNumber numberWithInt:GameTypeJcBf]];
            }
            if (_match.zjqItem.gameVisible) {
                [_typeArr addObject:[NSNumber numberWithInt:GameTypeJcZjq]];
            }
            if (_match.bqcItem.gameVisible) {
                [_typeArr addObject:[NSNumber numberWithInt:GameTypeJcBqc]];
            }

        } break;
        case GameTypeJcBf:
            _typeArr = [NSMutableArray arrayWithArray:@[ [NSNumber numberWithInt:GameTypeJcBf] ]];
            break;
        case GameTypeJcZjq: {
            _typeArr = [NSMutableArray arrayWithArray:@[ [NSNumber numberWithInt:GameTypeJcZjq] ]];
        } break;
        case GameTypeJcBqc: {
            _typeArr = [NSMutableArray arrayWithArray:@[ [NSNumber numberWithInt:GameTypeJcBqc] ]];

        } break;
        case GameTypeJcDg:
        case GameTypeJcDgAll: {
            _typeArr = [[NSMutableArray alloc] init];
            if (_match.spfItem.supportSingle) {
                [_typeArr addObject:[NSNumber numberWithInt:GameTypeJcSpf]];
            }
            if (_match.rqspfItem.supportSingle) {
                [_typeArr addObject:[NSNumber numberWithInt:GameTypeJcRqspf]];
            }
            if (_match.bfItem.supportSingle) {
                [_typeArr addObject:[NSNumber numberWithInt:GameTypeJcBf]];
            }
            if (_match.zjqItem.supportSingle) {
                [_typeArr addObject:[NSNumber numberWithInt:GameTypeJcZjq]];
            }
            if (_match.bqcItem.supportSingle) {
                [_typeArr addObject:[NSNumber numberWithInt:GameTypeJcBqc]];
            }

        } break;
        default:
            break;
    }

    [_backgroundView addSubview:self.tableView];

    UIButton *confirmButton = [[UIButton alloc] init];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    confirmButton.backgroundColor = [UIColor dp_flatRedColor];
    [confirmButton setTitleColor:UIColorFromRGB(0xfefefe) forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(pvt_onSure) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.titleLabel.font = [UIFont dp_systemFontOfSize:17.0];
    [_backgroundView addSubview:confirmButton];

    UIButton *cancelButton = [[UIButton alloc] init];
    cancelButton.layer.borderColor = [UIColor colorWithRed:0.88 green:0.85 blue:0.78 alpha:1].CGColor;
    cancelButton.layer.borderWidth = 0.5;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor dp_flatBackgroundColor];
    [cancelButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(pvt_onCancel) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = [UIFont dp_systemFontOfSize:17.0];

    [_backgroundView addSubview:cancelButton];

    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.width.equalTo(_backgroundView).dividedBy(2);
        make.right.equalTo(_backgroundView);
        make.bottom.equalTo(_backgroundView);
    }];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.width.equalTo(_backgroundView).dividedBy(2);
        make.left.equalTo(_backgroundView);
        make.bottom.equalTo(_backgroundView);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_backgroundView);
        make.top.equalTo(_backgroundView);
        make.bottom.equalTo(@[ confirmButton.mas_top, cancelButton.mas_top ]);
    }];

    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.height.equalTo(@(self.tableView.contentSize.height + 44)).priorityLow();
        make.height.lessThanOrEqualTo(@(kScreenHeight - 100));
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _typeArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GameTypeId currentType = (GameTypeId)[[_typeArr objectAtIndex:indexPath.row] intValue];

    switch (currentType) {
        case GameTypeJcSpf: {
            static NSString *spf_identifier = @"spf_identifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:spf_identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:spf_identifier];
                [cell.contentView addSubview:_footBallMore.view_spf];
                [_footBallMore.view_spf mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.insets(UIEdgeInsetsMake(1, 8, 1, 8));
                }];
            }

            return cell;

        } break;
        case GameTypeJcRqspf: {
            static NSString *rqspf_identifier = @"rqspf_identifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rqspf_identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rqspf_identifier];
                [cell.contentView addSubview:_footBallMore.view_rqspf];
                [_footBallMore.view_rqspf mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.insets(UIEdgeInsetsMake(1, 8, 1, 8));
                }];
            }

            return cell;

        } break;
        case GameTypeJcBf: {
            static NSString *bf_identifier = @"bf_identifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bf_identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bf_identifier];
                [cell.contentView addSubview:_footBallMore.view_bf];
                [_footBallMore.view_bf mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.insets(UIEdgeInsetsMake(0, 8, 0, 8));

                }];
            }

            return cell;

        } break;
        case GameTypeJcZjq: {
            static NSString *zjq_identifier = @"zjq_identifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:zjq_identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zjq_identifier];
                [cell.contentView addSubview:_footBallMore.view_zjq];
                [_footBallMore.view_zjq mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.insets(UIEdgeInsetsMake(0, 8, 0, 8));
                }];
            }

            return cell;

        } break;
        case GameTypeJcBqc: {
            static NSString *bqc_identifier = @"bqc_identifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bqc_identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bqc_identifier];
                if (_gameType == GameTypeJcBqc) {
                    cell.contentView.backgroundColor = [UIColor dp_flatWhiteColor];
                    [cell.contentView addSubview:_footBallMore.view_signalBqc];
                    [_footBallMore.view_signalBqc mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.insets(UIEdgeInsetsMake(0, 8, 0, 8));
                    }];
                } else {
                    [cell.contentView addSubview:_footBallMore.view_bqc];
                    [_footBallMore.view_bqc mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.insets(UIEdgeInsetsMake(0, 8, 0, 8));
                    }];
                }
            }

            return cell;
        } break;
        default:
            break;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    GameTypeId currentType = (GameTypeId)[[_typeArr objectAtIndex:indexPath.row] intValue];
    CGFloat addHight = 0;
    if (_gameType == GameTypeJcHt || _gameType == GameTypeJcDg || _gameType == GameTypeJcDgAll) {
        addHight = 0;
    } else {
        addHight = 7;
    }
    switch (currentType) {
        case GameTypeJcSpf:
            return 37 + 6;
            break;
        case GameTypeJcRqspf: {
            return 37;
        } break;

        case GameTypeJcBf: {
            if (!_match.bfItem.gameVisible) {
                return 65;
            }
            return 190;
        } break;
        case GameTypeJcZjq: {
            if (!_match.zjqItem.gameVisible) {
                return 65;
            }
            return 95 + addHight;
        } break;
        case GameTypeJcBqc: {
            if (!_match.bqcItem.gameVisible) {
                return 65;
            }

            if (_gameType == GameTypeJcBqc) {
                return 90 + 16 + 12;
            }
            return 95 + addHight;
        } break;
        default:
            break;
    }

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *header_identif = @"header_identif";
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:header_identif];
    if (view == nil) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:header_identif];
        view.contentView.backgroundColor = [UIColor dp_flatBackgroundColor];

        //总标题
        UILabel *vslabel = [[UILabel alloc] init];
        vslabel.font = [UIFont dp_systemFontOfSize:16.0];
        vslabel.backgroundColor = [UIColor clearColor];
        vslabel.textAlignment = NSTextAlignmentCenter;
        vslabel.textColor = [UIColor dp_flatBlackColor];
        vslabel.text = @"VS";
        [view.contentView addSubview:vslabel];

        [vslabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view.contentView);
            make.centerY.equalTo(view.contentView).offset(5);
            make.width.equalTo(@80);
        }];

        UILabel *homelabel = [[UILabel alloc] init];
        homelabel.font = [UIFont dp_systemFontOfSize:16.0];
        homelabel.backgroundColor = [UIColor clearColor];
        homelabel.textAlignment = NSTextAlignmentCenter;
        homelabel.textColor = [UIColor dp_flatBlackColor];
        homelabel.tag = 777;
        [view.contentView addSubview:homelabel];

        [homelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view.contentView.mas_centerX).offset(-40);
            make.centerY.equalTo(view.contentView).offset(5);
        }];

        UILabel *awaylabel = [[UILabel alloc] init];
        awaylabel.font = [UIFont dp_systemFontOfSize:16.0];
        awaylabel.backgroundColor = [UIColor clearColor];
        awaylabel.textAlignment = NSTextAlignmentCenter;
        awaylabel.textColor = [UIColor dp_flatBlackColor];
        awaylabel.tag = 778;
        [view.contentView addSubview:awaylabel];

        [awaylabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.contentView.mas_centerX).offset(40);
            make.centerY.equalTo(view.contentView).offset(5);
        }];

        [view.contentView addSubview:self.hotView];
        [self.hotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.contentView);
            make.top.equalTo(view.contentView);
            make.width.equalTo(@35.5);
            make.height.equalTo(@20);

        }];

        UILabel *line = [[UILabel alloc] init];
        line.backgroundColor = [UIColor colorWithRed:0.88 green:0.85 blue:0.78 alpha:1];
        [view.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.equalTo(view.contentView);
            make.height.equalTo(@0.5);
        }];

        [view.contentView addSubview:self.rangQiuLabel];
        [self.rangQiuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(view.contentView);
            make.left.equalTo(view.contentView).offset(10);
            make.width.equalTo(@12);
        }];
    }

    UILabel *homeLab = (UILabel *)[view.contentView viewWithTag:777];
    UILabel *awayLab = (UILabel *)[view.contentView viewWithTag:778];
    homeLab.text = _match.homeTeamName;
    awayLab.text = _match.awayTeamName;

    if (_gameType == GameTypeJcHt || ((_gameType == GameTypeJcDg || _gameType == GameTypeJcDgAll) && (_match.spfItem.supportSingle || _match.rqspfItem.supportSingle))) {
        self.rangQiuLabel.hidden = NO;
    } else {
        self.rangQiuLabel.hidden = YES;
    }

    self.hotView.hidden = !_match.isHot;
    return view;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor dp_flatBackgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
        _tableView.bounces = NO;
    }

    return _tableView;
}

- (UILabel *)rangQiuLabel {
    if (_rangQiuLabel == nil) {
        _rangQiuLabel = [[UILabel alloc] init];
        _rangQiuLabel.backgroundColor = [UIColor clearColor];
        _rangQiuLabel.textAlignment = NSTextAlignmentCenter;
        _rangQiuLabel.font = [UIFont dp_systemFontOfSize:9];
        _rangQiuLabel.text = @"让\n球";
        _rangQiuLabel.numberOfLines = 0;
        _rangQiuLabel.textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
    }

    return _rangQiuLabel;
}

- (UIImageView *)hotView {
    if (_hotView == nil) {
        _hotView = [[UIImageView alloc] init];
        _hotView.backgroundColor = [UIColor clearColor];
        [_hotView setImage:dp_SportLotteryImage(@"re.png")];
    }
    return _hotView;
}

- (void)pvt_onCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pvt_onSure {
    [_match.matchOption initializeSelectNumWithType:_gameType];

    switch (_gameType) {
        case GameTypeJcHt: {
            [self sumitSelectDataWithView:_footBallMore.view_spf selectedType:GameTypeJcSpf count:3];
            [self sumitSelectDataWithView:_footBallMore.view_rqspf selectedType:GameTypeJcRqspf count:3];
            [self sumitSelectDataWithView:_footBallMore.view_bf selectedType:GameTypeJcBf count:31];
            [self sumitSelectDataWithView:_footBallMore.view_zjq selectedType:GameTypeJcZjq count:8];
            [self sumitSelectDataWithView:_footBallMore.view_bqc selectedType:GameTypeJcBqc count:9];

        } break;

        case GameTypeJcBf: {
            [self sumitSelectDataWithView:_footBallMore.view_bf selectedType:GameTypeJcBf count:31];
        } break;
        case GameTypeJcBqc: {
            if (_gameType == GameTypeJcBqc) {
                [self sumitSelectDataWithView:_footBallMore.view_signalBqc selectedType:GameTypeJcBqc count:9];

            } else {
                [self sumitSelectDataWithView:_footBallMore.view_bqc selectedType:GameTypeJcBqc count:9];
            }
        } break;
        case GameTypeJcZjq: {
            [self sumitSelectDataWithView:_footBallMore.view_zjq selectedType:GameTypeJcZjq count:8];

        } break;
        case GameTypeJcDg:
        case GameTypeJcDgAll: {
            [self sumitSelectDataWithView:_footBallMore.view_spf selectedType:GameTypeJcSpf count:3];
            [self sumitSelectDataWithView:_footBallMore.view_rqspf selectedType:GameTypeJcRqspf count:3];
            [self sumitSelectDataWithView:_footBallMore.view_bf selectedType:GameTypeJcBf count:31];
            [self sumitSelectDataWithView:_footBallMore.view_zjq selectedType:GameTypeJcZjq count:8];
            [self sumitSelectDataWithView:_footBallMore.view_bqc selectedType:GameTypeJcBqc count:9];

        } break;

        default:
            break;
    }
    if (self.reloadBlock) {
        self.reloadBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 提交所选到低层<通用>
- (void)sumitSelectDataWithView:(UIView *)view selectedType:(int)selectedType
                          count:(int)count {
    for (int i = 0; i < count; i++) {
        DPBetToggleControl *obj = (DPBetToggleControl *)
            [view viewWithTag:(selectedType << 16) | i];
        [_match updateSelectStatusWithBaseType:_gameType selectGmaeType:selectedType index:i select:obj.selected isAllSub:YES];
    }
}

@end