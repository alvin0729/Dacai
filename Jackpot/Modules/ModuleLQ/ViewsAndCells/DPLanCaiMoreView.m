//
//  DPLanCaiMoreView.m
//  DacaiProject
//
//  Created by sxf on 14-8-4.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPBetToggleControl.h"
#import "DPJclqDataModel.h"
#import "DPLanCaiMoreView.h"

@interface DPBasketMoreViewController () <UITableViewDelegate, UITableViewDataSource> {
    UIView *_backgroundView;
    GameTypeId _gameType;
    PBMJclqMatch *_match;
    NSMutableArray *_typeArr;
}

@property (nonatomic, strong, readonly) UIView *rfView;     //让分视图
@property (nonatomic, strong, readonly) UIView *dxfView;    //大小分视图
@property (nonatomic, strong, readonly) UIView *sfView;     //胜负视图
@property (nonatomic, strong, readonly) UIView *sfcView;    //胜分差视图

@property (nonatomic, strong) UILabel *rangfenLabel, *dxfLabel;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DPBasketMoreViewController
@synthesize rangfenLabel = _rangfenLabel, dxfLabel = _dxfLabel, rfView = _rfView, dxfView = _dxfView, sfView = _sfView, sfcView = _sfcView;
;

- (instancetype)initWithGameType:(GameTypeId)gameType match:(PBMJclqMatch *)match {
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
    self.view.backgroundColor = [UIColor clearColor];

    _backgroundView = [[UIView alloc] init];
    _backgroundView.backgroundColor = [UIColor dp_flatBackgroundColor];
    _backgroundView.layer.cornerRadius = 10;
    _backgroundView.clipsToBounds = YES;
    _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:_backgroundView];

    switch (_gameType) {
        case GameTypeLcHt: {
            if (_match.sfcItem.gameVisible) {
                _typeArr = [NSMutableArray arrayWithArray:@[ [NSNumber numberWithInt:GameTypeLcRfsf], [NSNumber numberWithInt:GameTypeLcDxf], [NSNumber numberWithInt:GameTypeLcSf], [NSNumber numberWithInt:GameTypeLcSfc] ]];
            } else {
                _typeArr = [NSMutableArray arrayWithArray:@[ [NSNumber numberWithInt:GameTypeLcRfsf], [NSNumber numberWithInt:GameTypeLcDxf], [NSNumber numberWithInt:GameTypeLcSf] ]];
            }

        } break;
        case GameTypeLcSfc:
            _typeArr = [NSMutableArray arrayWithArray:@[ [NSNumber numberWithInt:GameTypeLcSfc] ]];
            break;

        default:
            break;
    }

    [_backgroundView addSubview:self.tableView];

    UIButton *confirmButton = [[UIButton alloc] init];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont dp_systemFontOfSize:17.0];
    confirmButton.backgroundColor = [UIColor dp_flatRedColor];
    [confirmButton setTitleColor:UIColorFromRGB(0xfefefe) forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(pvt_onSure) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:confirmButton];

    UIButton *cancelButton = [[UIButton alloc] init];
    cancelButton.layer.borderColor = [UIColor colorWithRed:0.88 green:0.85 blue:0.78 alpha:1].CGColor;
    cancelButton.layer.borderWidth = 0.5;
    cancelButton.titleLabel.font = [UIFont dp_systemFontOfSize:17.0];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor dp_flatBackgroundColor];
    [cancelButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(pvt_onCancel) forControlEvents:UIControlEventTouchUpInside];
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
        make.top.equalTo(_backgroundView).offset(5);
        make.bottom.equalTo(@[ confirmButton.mas_top, cancelButton.mas_top ]);
    }];

    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.height.equalTo(@(self.tableView.contentSize.height + 44 + 5)).priorityLow();
        make.height.lessThanOrEqualTo(@(kScreenHeight - 100));
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _typeArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GameTypeId currentType = (GameTypeId)[[_typeArr objectAtIndex:indexPath.row] intValue];

    switch (currentType) {
        case GameTypeLcRfsf: {
            static NSString *rfsf_identifier = @"rfsf_identifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rfsf_identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rfsf_identifier];
                [cell.contentView addSubview:self.rfView];
                [self.rfView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.insets(UIEdgeInsetsMake(2, 10, 3, 10));
                }];
            }

            return cell;

        } break;
        case GameTypeLcDxf: {
            static NSString *dxf_identifier = @"dxf_identifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dxf_identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dxf_identifier];
                [cell.contentView addSubview:self.dxfView];
                [self.dxfView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.insets(UIEdgeInsetsMake(2, 10, 3, 10));
                }];
            }

            return cell;

        } break;
        case GameTypeLcSf: {
            static NSString *sf_identifier = @"sf_identifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sf_identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sf_identifier];
                [cell.contentView addSubview:self.sfView];
                [self.sfView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.insets(UIEdgeInsetsMake(2, 10, 3, 10));

                }];
            }

            return cell;

        } break;
        case GameTypeLcSfc: {
            static NSString *sfc_identifier = @"sfc_identifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sfc_identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sfc_identifier];
                [cell.contentView addSubview:self.sfcView];
                [self.sfcView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.insets(UIEdgeInsetsMake(0, 10, 0, 10));
                }];
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

    switch (currentType) {
        case GameTypeLcRfsf:
        case GameTypeLcDxf:
        case GameTypeLcSf: {
            return 38;
        } break;

        case GameTypeLcSfc: {
            if (!_match.sfcItem.gameVisible) {
                return 40 + 25;
            }
            return 125 + (_gameType == GameTypeLcSfc ? 0 : 25);
        } break;

        default:
            break;
    }

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *header_ = @"header_";
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:header_];
    if (view == nil) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:header_];
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
            make.centerY.equalTo(view.contentView).offset(-2);
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
            make.left.equalTo(view.contentView.mas_centerX).offset(40);
            make.centerY.equalTo(vslabel);
        }];

        UILabel *awaylabel = [[UILabel alloc] init];
        awaylabel.font = [UIFont dp_systemFontOfSize:16.0];
        awaylabel.backgroundColor = [UIColor clearColor];
        awaylabel.textAlignment = NSTextAlignmentCenter;
        awaylabel.textColor = [UIColor dp_flatBlackColor];
        awaylabel.tag = 778;
        [view.contentView addSubview:awaylabel];

        [awaylabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view.contentView.mas_centerX).offset(-40);

            make.centerY.equalTo(vslabel);
        }];

        UIView *colorView = [UIView dp_viewWithColor:[UIColor dp_flatWhiteColor]];
        [view.contentView addSubview:colorView];

        UILabel *line = [[UILabel alloc] init];
        line.backgroundColor = [UIColor colorWithRed:0.88 green:0.85 blue:0.78 alpha:1];
        [view.contentView addSubview:line];

        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(vslabel.mas_bottom);
            make.left.and.right.equalTo(view.contentView);
            make.height.equalTo(@0.5);
        }];

        [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(view.contentView);
            make.top.equalTo(vslabel.mas_bottom).offset(0.5);
            make.height.equalTo(@(22.5 - vslabel.dp_intrinsicHeight / 2 + 2 - 0.5));
        }];
    }

    UILabel *homeLab = (UILabel *)[view.contentView viewWithTag:777];
    UILabel *awayLab = (UILabel *)[view.contentView viewWithTag:778];
    homeLab.text = _match.homeTeamName;
    awayLab.text = _match.awayTeamName;

    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSString *fotter = @"fotter_";
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:fotter];
    if (view == nil) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:fotter];
        view.contentView.backgroundColor = [UIColor dp_flatWhiteColor];
    }

    return view;
}

- (UILabel *)createlabel:(NSString *)title backColor:(UIColor *)color textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    label.userInteractionEnabled = NO;
    label.backgroundColor = color;
    label.numberOfLines = 0;
    label.textColor = textColor;
    label.text = title;
    label.font = [UIFont dp_systemFontOfSize:9];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
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

- (UILabel *)rangfenLabel {
    if (_rangfenLabel == nil) {
        _rangfenLabel = [[UILabel alloc] init];
        _rangfenLabel.backgroundColor = [UIColor dp_flatWhiteColor];
        _rangfenLabel.textColor = [UIColor dp_flatBlueColor];
        _rangfenLabel.layer.borderColor = [UIColor colorWithRed:0.86 green:0.85 blue:0.78 alpha:1.0].CGColor;
        _rangfenLabel.layer.borderWidth = 0.5;
        _rangfenLabel.textAlignment = NSTextAlignmentCenter;
        _rangfenLabel.font = [UIFont dp_systemFontOfSize:10];
    }
    return _rangfenLabel;
}

- (UILabel *)dxfLabel {
    if (_dxfLabel == nil) {
        _dxfLabel = [[UILabel alloc] init];
        _dxfLabel.backgroundColor = [UIColor dp_flatWhiteColor];
        _dxfLabel.textColor = [UIColor dp_flatRedColor];
        _dxfLabel.layer.borderColor = [UIColor colorWithRed:0.86 green:0.85 blue:0.78 alpha:1.0].CGColor;
        _dxfLabel.layer.borderWidth = 0.5;
        _dxfLabel.textAlignment = NSTextAlignmentCenter;
        _dxfLabel.font = [UIFont dp_systemFontOfSize:10];
        ;
    }
    return _dxfLabel;
}

#pragma mark - 让分视图
- (UIView *)rfView {
    if (_rfView == nil) {
        _rfView = [[UIView alloc] init];

        UILabel *label = [self createlabel:@"让分" backColor:UIColorFromRGB(0x2a8988) textColor:[UIColor dp_flatWhiteColor]];
        [_rfView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_rfView);
            make.width.equalTo(@12);
            make.top.equalTo(_rfView);
            make.bottom.equalTo(_rfView);
        }];

        UIImageView *rfDanView = [[UIImageView alloc] initWithImage:dp_SportLotteryImage(@"htdanguan.png")];
        [_rfView addSubview:rfDanView];

        [rfDanView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label);
            make.left.equalTo(label).offset(6);
            make.width.equalTo(@30);
            make.height.equalTo(@14);
        }];

        rfDanView.hidden = !_match.rfsfItem.supportSingle;
        if (!_match.rfsfItem.gameVisible) {
            UILabel *noSaleLabel = [self createNoSelllabel];

            [_rfView addSubview:noSaleLabel];
            [noSaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label.mas_right).offset(5);
                make.right.equalTo(_rfView).offset(-1);
                make.top.and.bottom.equalTo(_rfView);
            }];

            [_rfView bringSubviewToFront:rfDanView];

            return _rfView;
        }

        NSArray *title132 = [NSArray arrayWithObjects:@"主负", @"主胜", nil];
        NSArray *option132 = @[ [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl] ];
        [option132 enumerateObjectsUsingBlock:^(DPBetToggleControl *obj, NSUInteger idx, BOOL *stop) {
            [_rfView addSubview:obj];
            [obj setShowBorderWhenSelected:YES];
            [obj addTarget:self action:@selector(pvt_onSelected:) forControlEvents:UIControlEventTouchUpInside];
        }];
        for (int i = 0; i < option132.count; i++) {
            DPBetToggleControl *obj = option132[i];
            obj.selected = NO;
            if (_match.matchOption.htOption.betRfsf[i] == 1) {
                obj.selected = YES;
            }
            [obj setTag:(GameTypeLcRfsf << 16) | i];
            obj.titleText = [title132 objectAtIndex:i];
            obj.oddsText = _match.rfsfItem.spListArray[i];
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(_rfView).valueOffset([NSNumber numberWithFloat:-8.5]).dividedBy(2);
                make.top.equalTo(_rfView);
                make.bottom.equalTo(_rfView);
            }];

            if (!_match.rfsfItem.gameVisible) {
                obj.userInteractionEnabled = NO;
                obj.titleColor = [UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
                obj.oddsText = @"";
                obj.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];

                self.rangfenLabel.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
            } else {
                obj.userInteractionEnabled = YES;
                self.rangfenLabel.backgroundColor = [UIColor dp_flatWhiteColor];
            }

            if (i >= option132.count - 1) {    // 每行5个选项
                continue;
            }
            DPBetToggleControl *obj1 = option132[i];
            DPBetToggleControl *obj2 = option132[i + 1];
            [obj1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label.mas_right).offset(5);
            }];
            [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(obj1.mas_right).offset(-1);
            }];
        }
        [_rfView addSubview:self.rangfenLabel];
        self.rangfenLabel.text = [NSString stringWithFormat:@"%@", _match.rf];
        self.rangfenLabel.textColor = _match.rf.intValue > 0 ? [UIColor dp_flatRedColor] : [UIColor dp_flatBlueColor];

        [self.rangfenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_rfView.mas_centerX).offset(17 / 2.0);
            make.width.equalTo(@35);
            make.centerY.equalTo(label.mas_centerY);
            make.height.equalTo(@15);
        }];

        [_rfView bringSubviewToFront:rfDanView];
    }
    return _rfView;
}
#pragma mark - 大小分视图
- (UIView *)dxfView {
    if (_dxfView == nil) {
        _dxfView = [[UIView alloc] init];

        UILabel *label = [self createlabel:@"大小分" backColor:UIColorFromRGB(0x2a8988) textColor:[UIColor dp_flatWhiteColor]];
        [_dxfView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_dxfView);
            make.width.equalTo(@12);
            make.top.equalTo(_dxfView).offset(-1);
            make.bottom.equalTo(_dxfView);
        }];

        UIImageView *dxfDanView = [[UIImageView alloc] initWithImage:dp_SportLotteryImage(@"htdanguan.png")];
        [_dxfView addSubview:dxfDanView];

        [dxfDanView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label);
            make.left.equalTo(label).offset(6);
            make.width.equalTo(@30);
            make.height.equalTo(@14);
        }];

        dxfDanView.hidden = !_match.dxfItem.supportSingle;

        if (!_match.dxfItem.gameVisible) {
            UILabel *noSaleLabel = [self createNoSelllabel];

            [_dxfView addSubview:noSaleLabel];
            [noSaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label.mas_right).offset(5);
                make.right.equalTo(_dxfView).offset(-1);
                make.top.and.bottom.equalTo(_dxfView);
            }];

            [_dxfView bringSubviewToFront:dxfDanView];

            return _dxfView;
        }

        NSArray *title134 = [NSArray arrayWithObjects:@"大分", @"小分", nil];
        NSArray *option134 = @[ [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl] ];
        [option134 enumerateObjectsUsingBlock:^(DPBetToggleControl *obj, NSUInteger idx, BOOL *stop) {
            [_dxfView addSubview:obj];
            [obj setShowBorderWhenSelected:YES];
            [obj addTarget:self action:@selector(pvt_onSelected:) forControlEvents:UIControlEventTouchUpInside];
        }];
        for (int i = 0; i < option134.count; i++) {
            DPBetToggleControl *obj = option134[i];
            obj.selected = NO;
            if (_match.matchOption.htOption.betDxf[i] == 1) {
                obj.selected = YES;
            }
            [obj setTag:(GameTypeLcDxf << 16) | i];
            obj.titleText = [title134 objectAtIndex:i];
            obj.oddsText = _match.dxfItem.spListArray[i];
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(_dxfView).valueOffset([NSNumber numberWithFloat:-8.5]).dividedBy(2);
                make.top.equalTo(_dxfView);
                make.bottom.equalTo(_dxfView);
            }];

            if (!_match.dxfItem.gameVisible) {
                obj.userInteractionEnabled = NO;
                obj.titleColor = [UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
                obj.oddsColor = [UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
                obj.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];

                obj.oddsText = @"";

                self.dxfLabel.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
            } else {
                obj.userInteractionEnabled = YES;
                self.dxfLabel.backgroundColor = [UIColor dp_flatWhiteColor];
            }

            if (i >= option134.count - 1) {    // 每行5个选项
                continue;
            }
            DPBetToggleControl *obj1 = option134[i];
            DPBetToggleControl *obj2 = option134[i + 1];
            [obj1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label.mas_right).offset(5);
            }];
            [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(obj1.mas_right).offset(-1);
            }];
        }
        [_dxfView addSubview:self.dxfLabel];
        self.dxfLabel.text = [NSString stringWithFormat:@"%@", _match.zf];
        [self.dxfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_dxfView.mas_centerX).offset(17 / 2.0);
            make.width.equalTo(@35);
            make.centerY.equalTo(_dxfView.mas_centerY);
            make.height.equalTo(@15);
        }];

        [_dxfView bringSubviewToFront:dxfDanView];
    }
    return _dxfView;
}
#pragma mark - 胜负视图
- (UIView *)sfView {
    if (_sfView == nil) {
        _sfView = [[UIView alloc] init];

        UILabel *label = [self createlabel:@"胜负" backColor:[UIColor colorWithRed:0.51 green:0.41 blue:0.24 alpha:1.0] textColor:[UIColor dp_flatWhiteColor]];
        [_sfView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_sfView);
            make.width.equalTo(@12);
            make.top.equalTo(_sfView);
            make.bottom.equalTo(_sfView);
        }];

        UIImageView *sfDanView = [[UIImageView alloc] initWithImage:dp_SportLotteryImage(@"htdanguan.png")];
        [_sfView addSubview:sfDanView];

        [sfDanView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label);
            make.left.equalTo(label).offset(6);
            make.width.equalTo(@30);
            make.height.equalTo(@14);
        }];

        sfDanView.hidden = !_match.sfItem.supportSingle;
        if (!_match.sfItem.gameVisible) {
            UILabel *noSaleLabel = [self createNoSelllabel];
            [_sfView addSubview:noSaleLabel];
            [noSaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label.mas_right).offset(5);
                make.right.equalTo(_sfView).offset(-1);
                make.top.and.bottom.equalTo(_sfView);
            }];
            [_sfView bringSubviewToFront:sfDanView];

            return _sfView;
        }

        NSArray *title131 = [NSArray arrayWithObjects:@"主负", @"主胜", nil];
        NSArray *option131 = @[ [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl] ];
        [option131 enumerateObjectsUsingBlock:^(DPBetToggleControl *obj, NSUInteger idx, BOOL *stop) {
            [_sfView addSubview:obj];
            [obj setShowBorderWhenSelected:YES];
            [obj addTarget:self action:@selector(pvt_onSelected:) forControlEvents:UIControlEventTouchUpInside];
        }];
        for (int i = 0; i < option131.count; i++) {
            DPBetToggleControl *obj = option131[i];
            obj.selected = NO;
            if (_match.matchOption.htOption.betSf[i] == 1) {
                obj.selected = YES;
            }
            [obj setTag:(GameTypeLcSf << 16) | i];
            obj.titleText = [title131 objectAtIndex:i];
            obj.oddsText = _match.sfItem.spListArray[i];
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(_sfView).valueOffset([NSNumber numberWithFloat:-8.5]).dividedBy(2);
                make.top.equalTo(_sfView);
                make.bottom.equalTo(_sfView);
            }];

            if (!_match.sfItem.gameVisible) {
                obj.userInteractionEnabled = NO;
                obj.titleColor = [UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
                obj.oddsText = @"";

                obj.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
            } else {
                obj.userInteractionEnabled = YES;
            }

            if (i >= option131.count - 1) {    // 每行5个选项
                continue;
            }
            DPBetToggleControl *obj1 = option131[i];
            DPBetToggleControl *obj2 = option131[i + 1];
            [obj1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label.mas_right).offset(5);
            }];

            [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(obj1.mas_right).offset(-1);
            }];
        }

        [_sfView bringSubviewToFront:sfDanView];
    }
    return _sfView;
}

#pragma mark - 胜分差
- (UIView *)sfcView {
    if (_sfcView == nil) {
        _sfcView = [[UIView alloc] init];

        JclqOption option;
        switch (_gameType) {
            case GameTypeLcHt:
                option = _match.matchOption.htOption;
                break;
            default:
                option = _match.matchOption.normalOption;
                break;
        }

        UIView *cmpView;
        if (_gameType == GameTypeLcHt) {
            UIView *scrollTitleView = [self createTitleView:@"胜分差"];
            [_sfcView addSubview:scrollTitleView];
            [scrollTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_sfcView);
                make.right.equalTo(_sfcView);
                make.top.equalTo(_sfcView);
                make.height.equalTo(@25);

            }];
            UIImageView *sfcDanView = [[UIImageView alloc] initWithImage:dp_SportLotteryImage(@"danguan.png")];

            [_sfcView addSubview:sfcDanView];
            [sfcDanView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(scrollTitleView);
                make.left.equalTo(scrollTitleView).offset(45);
            }];
            sfcDanView.hidden = !_match.sfcItem.supportSingle;

            cmpView = scrollTitleView;

        } else {
            cmpView = _sfcView;
        }

        if (!_match.sfcItem.gameVisible) {
            UILabel *stopCellspf_ = [[UILabel alloc] init];
            stopCellspf_.text = @"未开售";
            stopCellspf_.textColor = [UIColor colorWithRed:0.75 green:0.72 blue:0.62 alpha:1.0];
            stopCellspf_.textAlignment = NSTextAlignmentCenter;
            stopCellspf_.font = [UIFont dp_systemFontOfSize:14];
            stopCellspf_.layer.borderColor = [UIColor colorWithRed:0.91 green:0.88 blue:0.82 alpha:1.0].CGColor;
            stopCellspf_.layer.borderWidth = 0.5;
            stopCellspf_.backgroundColor = [UIColor colorWithRed:0.94 green:0.91 blue:0.86 alpha:1.0];
            [_sfcView addSubview:stopCellspf_];

            [stopCellspf_ mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_sfcView);
                make.right.equalTo(_sfcView);
                make.top.equalTo(_sfcView).offset(2);
                make.bottom.equalTo(_sfcView).offset(-5);
            }];

            return _sfcView;
        }

        UILabel *ksLabel = [self createlabel:@"客胜" backColor:UIColorFromRGB(0x2a8988) textColor:[UIColor dp_flatWhiteColor]];
        [_sfcView addSubview:ksLabel];
        [ksLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_sfcView);
            make.width.equalTo(@12);
            if (_gameType == GameTypeLcHt) {
                make.top.equalTo(cmpView.mas_bottom).offset(2);
            } else {
                make.top.equalTo(_sfcView).offset(1);
            }

            make.height.equalTo(@58);
        }];

        UILabel *zsLabel = [self createlabel:@"主胜" backColor:[UIColor colorWithRed:0.51 green:0.41 blue:0.24 alpha:1.0] textColor:[UIColor dp_flatWhiteColor]];
        [_sfcView addSubview:zsLabel];
        [zsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_sfcView);
            make.width.equalTo(@12);
            make.top.equalTo(ksLabel.mas_bottom).offset(4 + 2);
            make.height.equalTo(@58);
        }];

        NSArray *option133 = @[ [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl], [DPBetToggleControl horizontalControl] ];
        [option133 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [_sfcView addSubview:obj];
            [obj setShowBorderWhenSelected:YES];
            [obj addTarget:self action:@selector(pvt_onSelected:) forControlEvents:UIControlEventTouchUpInside];
        }];
        NSArray *titleArray = [NSArray arrayWithObjects:@"1-5", @"6-10", @"11-15", @"16-20", @"21-25", @"26+", @"1-5", @"6-10", @"11-15", @"16-20", @"21-25", @"26+", nil];
        for (int i = 0; i < option133.count; i++) {
            DPBetToggleControl *obj = option133[i];
            [obj setTag:(GameTypeLcSfc << 16) | i];
            obj.selected = NO;
            if (option.betSfc[i]) {
                obj.selected = YES;
            }
            obj.oddsText = _match.sfcItem.spListArray[i];
            obj.titleText = [titleArray objectAtIndex:i];
            obj.titleFont = [UIFont dp_systemFontOfSize:12.0];
            obj.oddsFont = [UIFont dp_systemFontOfSize:10.0];
            obj.titleColor = [UIColor dp_flatBlackColor];
            obj.oddsColor = UIColorFromRGB(0xa59d90);
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(_sfcView).valueOffset([NSNumber numberWithFloat:-5]).dividedBy(3);
                make.height.equalTo(@30);
                if (_gameType == GameTypeLcHt) {
                    if (i < 6) {
                        make.top.equalTo(cmpView.mas_bottom).offset(2 + 29 * (i / 3));
                    } else {
                        make.top.equalTo(cmpView.mas_bottom).offset(8 + 29 * (i / 3));
                    }
                } else {
                    if (i < 6) {
                        make.top.equalTo(_sfcView).offset(1 + 29 * (i / 3));
                    } else {
                        make.top.equalTo(_sfcView).offset(7 + 29 * (i / 3));
                    }
                }

            }];
            if (i % 3 == 0) {
                [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(ksLabel.mas_right).offset(5);
                }];
            }
            if ((i + 1) % 3 == 0 || (i >= option133.count - 1)) {    // 每行5个选项
                continue;
            }
            DPBetToggleControl *obj1 = option133[i];
            DPBetToggleControl *obj2 = option133[i + 1];

            [obj2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(obj1.mas_right).offset(-1);
            }];
        }
    }
    return _sfcView;
}
- (void)pvt_onSelected:(DPBetToggleControl *)betToggle {
    betToggle.selected = !betToggle.selected;
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

- (void)pvt_onCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pvt_onSure {
    [_match.matchOption initializeSelectNumWithType:_gameType];
    switch (_gameType) {
        case GameTypeLcHt: {
            [self sumitSelectDataWithView:self.rfView selectedType:GameTypeLcRfsf count:2];
            [self sumitSelectDataWithView:self.dxfView selectedType:GameTypeLcDxf count:2];
            [self sumitSelectDataWithView:self.sfView selectedType:GameTypeLcSf count:2];
            [self sumitSelectDataWithView:self.sfcView selectedType:GameTypeLcSfc count:12];

        } break;

        case GameTypeLcSfc: {
            [self sumitSelectDataWithView:self.sfcView selectedType:GameTypeLcSfc count:12];
        } break;

        default:
            break;
    }
    if (self.reloadBlock) {
        self.reloadBlock();
    }

    [self dismissViewControllerAnimated:YES completion:nil];
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
