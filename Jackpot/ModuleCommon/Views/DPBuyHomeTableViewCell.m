//
//  DPBuyHomeTableViewCell.m
//  Jackpot
//
//  Created by sxf on 15/7/2.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  #define kSingleViewTagBase 20
//  本页注释由sxf提供，如有更改，请标明

#import "DPBetToggleControl.h"
#import "DPBuyHomeTableViewCell.h"

#define KCommunityImageTag 30
#define KCommunityLabelTag 40

//任选一注（大乐透）
@interface DPSelectedBallViewCell () {
@private
    UILabel *_lotteryTitle;
    UILabel *_bonusMoney;
    NSArray *_balls;
    UIButton *_payButton;
}

@property (nonatomic, strong) MTStringParser *parser;
@end


@implementation DPSelectedBallViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *contentView = self.contentView;
        contentView.backgroundColor = [UIColor clearColor];
        [contentView addSubview:self.lotteryTitle];
        [contentView addSubview:self.bonusMoney];
        [self.lotteryTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(10);
            make.width.equalTo(@50);
            make.top.equalTo(contentView).offset(12);
            make.height.equalTo(@24);
        }];
        [self.bonusMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lotteryTitle.mas_right).offset(5);
            make.width.equalTo(@160);
            make.top.equalTo(self.lotteryTitle).offset(2.5);
            make.bottom.equalTo(self.lotteryTitle).offset(-2.5);
        }];
        UIView *line = [UIView dp_viewWithColor:UIColorFromRGB(0xcececc)];
        [contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView);
            make.right.equalTo(contentView);
            make.bottom.equalTo(contentView);
            make.height.equalTo(@0.5);
        }];

        UIButton *selectButton = [[UIButton alloc] init];
        [selectButton setTitle:@"换一注" forState:UIControlStateNormal];
        [selectButton setImage:dp_AppRootImage(@"randomLottery.png") forState:UIControlStateNormal];
        [selectButton setImageEdgeInsets:UIEdgeInsetsMake(3, 41, 3, 3)];
        [selectButton setTitleEdgeInsets:UIEdgeInsetsMake(10, -20, 10, 20)];
        [selectButton setTitleColor:UIColorFromRGB(0xcbcccc) forState:UIControlStateNormal];
        selectButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        selectButton.backgroundColor = [UIColor clearColor];
        [selectButton addTarget:self action:@selector(randomSelectedBall) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:selectButton];
        [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(contentView).offset(-10);
            make.width.equalTo(@60);
            make.top.equalTo(self.lotteryTitle);
            make.bottom.equalTo(self.lotteryTitle);
        }];

        [contentView addSubview:self.payButton];
        [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(contentView).offset(-15);
            make.width.equalTo(@55);
            make.bottom.equalTo(contentView).offset(-12);
            make.height.equalTo(@30);
        }];
        UIView *ballView = [UIView dp_viewWithColor:[UIColor clearColor]];
        [contentView addSubview:ballView];
        [ballView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(10);
            make.right.equalTo(selectButton.mas_left).offset(-10);
            make.centerY.equalTo(_payButton);
            make.height.equalTo(@30);
        }];
        NSMutableArray *balls = [[NSMutableArray alloc] initWithCapacity:7];
        for (int i = 0; i < 7; i++) {
            UIButton *button = [[UIButton alloc] init];
            button.userInteractionEnabled = NO;
            [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
            if (i > 4) {
                [button setBackgroundImage:dp_AppRootImage(@"homeBlue.png") forState:UIControlStateNormal];
            } else {
                [button setBackgroundImage:dp_AppRootImage(@"homeRed.png") forState:UIControlStateNormal];
            }
            [button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
            [button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateSelected];
            [button setUserInteractionEnabled:NO];
            [button.titleLabel setFont:[UIFont dp_systemFontOfSize:14.0]];
            [balls addObject:button];
            [ballView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@29);
                make.height.equalTo(@29);
                make.top.equalTo(ballView);
                make.left.equalTo(@(34 * i));
            }];
        }
        _balls = balls;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chaneEndTime:) name:kDPNumberTimerNotificationKey object:nil];
    }
    return self;
}
//换一注（随机一注）
- (void)randomSelectedBall {
    if (self.delegate && [self.delegate respondsToSelector:@selector(randomSelectedBallViewCell:)]) {
        [self.delegate randomSelectedBallViewCell:self];
    }
}
//支付
- (void)payButtonClick:(UIButton *)btn {
    NSString *title = btn.titleLabel.text;
    if ([title isEqualToString:@"停售"]) {
        [[DPToast makeText:@"当前没有可售期"] show];
        return;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(payForSelectedBallViewCell:)]) {
        [self.delegate payForSelectedBallViewCell:self];
    }
}

//投注
- (UIButton *)payButton {
    if (_payButton == nil) {
        _payButton = [[UIButton alloc] init];
        [_payButton setTitle:@"投注" forState:UIControlStateNormal];
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _payButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _payButton.backgroundColor = UIColorFromRGB(0xd44649);
        _payButton.layer.cornerRadius = 5;
        [_payButton addTarget:self action:@selector(payButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _payButton.dp_eventId = DPAnalyticsTypeHomeQuickDlt;
    }

    return _payButton;
}
//标题
- (UILabel *)lotteryTitle {
    if (_lotteryTitle == nil) {
        _lotteryTitle = [[UILabel alloc] init];
        _lotteryTitle.backgroundColor = [UIColor clearColor];
        _lotteryTitle.text = @"大乐透";
        _lotteryTitle.textColor = [UIColor dp_flatBlackColor];
        _lotteryTitle.font = [UIFont dp_boldArialOfSize:16.0];
    }
    return _lotteryTitle;
}
//奖池
- (UILabel *)bonusMoney {
    if (_bonusMoney == nil) {
        _bonusMoney = [[UILabel alloc] init];
        _bonusMoney.backgroundColor = [UIColor clearColor];
        _bonusMoney.attributedText = [self.parser attributedStringFromMarkup:[NSString stringWithFormat:@"--期截止还有<red>--:--</red>"]];
        _bonusMoney.textColor = UIColorFromRGB(0x666676);
        _bonusMoney.textAlignment = NSTextAlignmentLeft;
        _bonusMoney.font = [UIFont dp_boldArialOfSize:11.0];
    }
    return _bonusMoney;
}
//倒计时
- (void)chaneEndTime:(NSNotification *)notify {
    self.bonusMoney.attributedText = [self getDateTime];
}
//获取倒计时
- (NSAttributedString *)getDateTime {
    NSAttributedString *dateTime;
    NSString *timeStr = self.endTime;

    if (timeStr && self.gameName) {
        NSDate *endDate = [NSDate dp_dateFromString:timeStr withFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss];
        NSTimeInterval countDown = [endDate dp_timeIntervalSinceNow];

        if (countDown > 0) {
            NSInteger hours = (countDown) / 3600;
            NSInteger mins = (countDown - 3600 * hours) / 60;
            NSInteger seconds = (countDown)-3600 * hours - 60 * mins;

            dateTime = [self.parser attributedStringFromMarkup:[NSString stringWithFormat:@"%@期截止还有<red>%02d:%02d:%02d</red>", self.gameName, (int)hours, (int)mins, (int)seconds]];
        } else {
            dateTime = [self.parser attributedStringFromMarkup:[NSString stringWithFormat:@"--期截止还有<red>--:--</red>"]];
            if (self.delegate) {
                [self.delegate updateDataForTime];
            }
        }
    }

    else {
        dateTime = [self.parser attributedStringFromMarkup:[NSString stringWithFormat:@"--期截止还有<red>--:--</red>"]];
    }

    return dateTime;
}

- (NSArray *)balls {
    return _balls;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDPNumberTimerNotificationKey object:nil];
}

- (MTStringParser *)parser {
    if (_parser == nil) {
        _parser = [[MTStringParser alloc] init];
        [_parser setDefaultAttributes:({
                     MTStringAttributes *attr = [[MTStringAttributes alloc] init];
                     attr.alignment = NSTextAlignmentLeft;
                     attr.textColor = UIColorFromRGB(0x666676);
                     attr.font = [UIFont dp_systemFontOfSize:11.0];
                     attr;
                 })];
        [_parser addStyleWithTagName:@"red" color:[UIColor dp_flatRedColor]];
    }

    return _parser;
}

@end

//选择竞彩系列
@interface DPSelectedJCViewCell () <UIScrollViewDelegate> {
    int _gameCount;      // 比赛场次
    int _curIndex;       // 当前页
    float _jcRate[3];    //竞彩选中状态
    float _lcRate[2];    //篮彩选中状态
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation DPSelectedJCViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _gameCount = 0;
        _curIndex = 0;
        UIView *contentView = self.contentView;
        contentView.backgroundColor = [UIColor clearColor];
        [contentView addSubview:self.scrollView];
        [contentView addSubview:self.pageControl];

        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];

        UIView *line = [UIView dp_viewWithColor:UIColorFromRGB(0xcececc)];
        [contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView);
            make.right.equalTo(contentView);
            make.bottom.equalTo(contentView);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}
//根据竞彩或者篮彩是否显示生成视图
- (void)rebuildContentWithCount:(int)gameCount {
    _pageControl.numberOfPages = gameCount;
    [self.singleTeamsArray removeAllObjects];
    if (gameCount <= 0) {
        return;
    }
    GameTypeId tempTypeFirst = GameTypeLcNone;     //第一位彩种信息
    GameTypeId tempTypeSecond = GameTypeJcNone;    //第二位彩种信息
    if (self.gameFirst) {                          //判断竞彩足球和篮彩显示的先后顺序 1:竞彩足球 0:竞彩篮球
        tempTypeFirst = GameTypeJcNone;
        tempTypeSecond = GameTypeLcNone;
    }
    if (gameCount == 1) {    //如果只显示1个，则页面控制隐藏
        _pageControl.hidden = YES;
        _pageControl.userInteractionEnabled = NO;
    } else {
        _pageControl.hidden = NO;
        _pageControl.userInteractionEnabled = NO;
    }
    if (gameCount == 1) {
        //根据传递过去的彩种类型生成视图
        DPHomeBuyJCView *singleView = [[DPHomeBuyJCView alloc] initWithGameTye:tempTypeFirst];
        singleView.delegate = self;
        [self.singleTeamsArray addObject:singleView];
        singleView.tag = kSingleViewTagBase;
        [self.scrollView addSubview:singleView];
        [singleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView);
            make.top.equalTo(self.scrollView);
            make.bottom.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
            make.height.equalTo(self.scrollView);
        }];
        _pageControl.hidden = YES;
        _pageControl.userInteractionEnabled = NO;
        return;
    }
    //如果当前需要生成的视图大于1的话，则循环生成
    while (self.singleTeamsArray.count < gameCount) {
        DPHomeBuyJCView *singleView = nil;
        if (self.singleTeamsArray.count % 2 == 0) {    //因为目前只有足彩和篮彩，因此这么处理
            singleView = [[DPHomeBuyJCView alloc] initWithGameTye:tempTypeFirst];
        } else {
            singleView = [[DPHomeBuyJCView alloc] initWithGameTye:tempTypeSecond];
        }
        singleView.delegate = self;
        [self.singleTeamsArray addObject:singleView];
    }
    DPAssert(self.singleTeamsArray.count >= gameCount);
    int i = 0;
    for (DPHomeBuyJCView *singleView in self.singleTeamsArray) {
        [self.scrollView addSubview:singleView];
        singleView.tag = kSingleViewTagBase + i;
        [singleView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(self.scrollView);
            } else if (i == gameCount - 1) {
                DPHomeBuyJCView *preView = self.singleTeamsArray[i - 1];
                make.left.equalTo(preView.mas_right);
                make.right.equalTo(self.scrollView);

            } else {
                DPHomeBuyJCView *preView = self.singleTeamsArray[i - 1];
                make.left.equalTo(preView.mas_right);
            }
            make.top.equalTo(self.scrollView);
            make.bottom.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
            make.height.equalTo(self.scrollView);
        }];
        i++;
    }
}

static BOOL IsZero(int *mem, int n) {
    for (int i = 0; i < n; i++) {
        if (mem[i]) {
            return false;
        }
    }

    return YES;
}

#pragma mark - 更新竞彩数据 Ray
- (void)updateHomeBuyJCData:(PBMHomePage_SportQuickBet *)quickBet {
    for (int i = 0; i < self.singleTeamsArray.count; i++) {
        DPHomeBuyJCView *jczqView = [self.singleTeamsArray objectAtIndex:i];
        BOOL currentViewIsJczq = NO;    //当前视图是否是足彩
        BOOL currentViewIsJclq = NO;    //当前视图是否是篮彩
        //这个方法主要是判断当前视图是什么
        if (IsGameTypeJc(quickBet.gameType)) {
            if (self.gameFirst) {
                for (int i = 0; i < 3; i++) {
                    _jcRate[i] = [quickBet.rateListArray[i] floatValue];
                }

                if (i % 2 == 0) {
                    currentViewIsJczq = YES;
                }

            } else {
                if (i % 2 == 1) {
                    currentViewIsJczq = YES;
                }
            }

        } else if (IsGameTypeLc(quickBet.gameType)) {
            //处理篮彩主客相反数据
            _lcRate[0] = [quickBet.rateListArray[1] floatValue];
            _lcRate[1] = [quickBet.rateListArray[0] floatValue];

            if (!self.gameFirst) {
                if (i % 2 == 0) {
                    currentViewIsJclq = YES;
                }
            } else {
                if (i % 2 == 1) {
                    currentViewIsJclq = YES;
                }
            }
        }

        if (currentViewIsJczq) {    //当前视图是竞彩足球
            NSDate *date = [NSDate dp_dateFromString:quickBet.endTime withFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss];
            jczqView.titleLabel.text = [NSString stringWithFormat:@"%@   截止%@", quickBet.title, [date dp_stringWithFormat:dp_DateFormatter_MM_dd_HH_mm]];
            DPBetToggleControl *button1 = (DPBetToggleControl *)[jczqView viewWithTag:JCButtonTag + 0];
            DPBetToggleControl *button2 = (DPBetToggleControl *)[jczqView viewWithTag:JCButtonTag + 1];
            DPBetToggleControl *button3 = (DPBetToggleControl *)[jczqView viewWithTag:JCButtonTag + 2];

            if (IsZero(quickBet.homeBetOption.betOption.betJczqOption, 3)) {
                HomeOption option = quickBet.homeBetOption.betOption;

                int index = 0;

                float minSp = 0;
                for (int i = 0; i < 3; i++) {
                    float sp = [quickBet.spListArray[i] floatValue];
                    if (i == 0) {
                        minSp = sp;
                        index = 0;
                    } else if (sp < minSp) {
                        minSp = sp;
                        index = i;
                    }
                }
                option.betJczqOption[index] = 1;
                quickBet.homeBetOption.betOption = option;
            }

            button1.selected = quickBet.homeBetOption.betOption.betJczqOption[0] == 1;
            button2.selected = quickBet.homeBetOption.betOption.betJczqOption[1] == 1;
            button3.selected = quickBet.homeBetOption.betOption.betJczqOption[2] == 1;

            if (quickBet.gameType == GameTypeJcRqspf) {    //竞彩让球胜平负时的让球显示
                button1.titleText = [quickBet.balance integerValue] > 0 ? [NSString stringWithFormat:@"%@(+%@)", quickBet.homeName, quickBet.balance] : [NSString stringWithFormat:@"%@(%@)", quickBet.homeName, quickBet.balance];
            } else {
                button1.titleText = [NSString stringWithFormat:@"%@", quickBet.homeName];
            }

            button2.titleText = @"平";
            button3.titleText = [NSString stringWithFormat:@"%@", quickBet.awayName];

            button1.oddsText = [NSString stringWithFormat:@"胜 %@", quickBet.spListArray[0]];
            button2.oddsText = [NSString stringWithFormat:@"%@", quickBet.spListArray[1]];
            button3.oddsText = [NSString stringWithFormat:@"负 %@", quickBet.spListArray[2]];
            [jczqView.leftSingleView setChartHight:[quickBet.rateListArray[0] floatValue] / 100.0];
            [jczqView.middleSingleView setChartHight:[quickBet.rateListArray[1] floatValue] / 100.0];
            [jczqView.rightSingleView setChartHight:[quickBet.rateListArray[2] floatValue] / 100.0];

            if (self.delegate && [self.delegate respondsToSelector:@selector(jcSelectedView:isSelected:index:gameType:isUserTouch:)]) {
                [self.delegate jcSelectedView:jczqView isSelected:YES index:0 gameType:quickBet.gameType isUserTouch:NO];
            }

        } else if (currentViewIsJclq) {    //当前视图是竞彩篮球
            NSDate *date = [NSDate dp_dateFromString:quickBet.endTime withFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss];
            jczqView.titleLabel.text = [NSString stringWithFormat:@"%@   截止%@", quickBet.title, [date dp_stringWithFormat:dp_DateFormatter_MM_dd_HH_mm]];
            DPBetToggleControl *button1 = (DPBetToggleControl *)[jczqView viewWithTag:LCButtonTag + 0];
            DPBetToggleControl *button2 = (DPBetToggleControl *)[jczqView viewWithTag:LCButtonTag + 1];

            if (IsZero(quickBet.homeBetOption.betOption.betLcOption, 2)) {
                HomeOption option = quickBet.homeBetOption.betOption;
                if ([quickBet.spListArray[0] floatValue] > [quickBet.spListArray[1] floatValue]) {
                    option.betLcOption[0] = 1;
                } else {
                    option.betLcOption[1] = 1;
                }
                quickBet.homeBetOption.betOption = option;
            }

            button1.selected = quickBet.homeBetOption.betOption.betLcOption[0] == 1;
            button2.selected = quickBet.homeBetOption.betOption.betLcOption[1] == 1;

            button1.titleFont = button2.titleFont = [UIFont systemFontOfSize:13.0];
            button1.oddsFont = button2.oddsFont = [UIFont systemFontOfSize:10.0];

             button1.titleText = [NSString stringWithFormat:@"%@", quickBet.awayName];
            if (quickBet.gameType == GameTypeLcRfsf) {//让分胜负时的让分显示
                button2.titleText =[quickBet.balance integerValue] > 0 ?[NSString stringWithFormat:@"%@(+%@)", quickBet.homeName, quickBet.balance]:[NSString stringWithFormat:@"%@(%@)", quickBet.homeName, quickBet.balance];
             } else {
                button2.titleText = [NSString stringWithFormat:@"%@", quickBet.homeName];
            };

            button1.oddsText = [NSString stringWithFormat:@"胜 %@", quickBet.spListArray[1]];
            button2.oddsText = [NSString stringWithFormat:@"%@", quickBet.spListArray[0]];

            [jczqView.leftSingleView setChartHight:_lcRate[0] / 100.0];
            [jczqView.rightSingleView setChartHight:_lcRate[1] / 100.0];

            if (self.delegate && [self.delegate respondsToSelector:@selector(jcSelectedView:isSelected:index:gameType:isUserTouch:)]) {
                [self.delegate jcSelectedView:jczqView isSelected:YES index:0 gameType:quickBet.gameType isUserTouch:NO];
            }
        }
    }
}

#pragma mark - scrollView delegate
//滚动协议
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _curIndex = self.scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.bounds);
    self.pageControl.currentPage = _curIndex;
    DPHomeBuyJCView *jcView = [self.singleTeamsArray objectAtIndex:_curIndex];
    if (IsGameTypeLc(jcView.gameId)) {
        [jcView.leftSingleView setChartHight:_lcRate[0] / 100.0];
        [jcView.rightSingleView setChartHight:_lcRate[1] / 100.0];
    } else if (IsGameTypeJc(jcView.gameId)) {
        [jcView.leftSingleView setChartHight:_jcRate[0] / 100.0];
        [jcView.middleSingleView setChartHight:_jcRate[1] / 100.0];
        [jcView.rightSingleView setChartHight:_jcRate[2] / 100.0];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    DPHomeBuyJCView *firstSingleView = self.singleTeamsArray.firstObject;

    if (firstSingleView.hidden == YES) firstSingleView.hidden = NO;

    DPHomeBuyJCView *jcView = [self.singleTeamsArray objectAtIndex:_curIndex > 0 ? 0 : 1];
    if (IsGameTypeLc(jcView.gameId)) {
        [jcView.leftSingleView setChartHight:0];
        [jcView.rightSingleView setChartHight:0];
    } else if (IsGameTypeJc(jcView.gameId)) {
        [jcView.leftSingleView setChartHight:0];
        [jcView.middleSingleView setChartHight:0];
        [jcView.rightSingleView setChartHight:0];
    }
}
#pragma mark - getter & setter
//玩法个数
- (int)gameCount {
    return _gameCount;
}
- (void)setGameCount:(int)gameCount {
    _gameCount = gameCount;

    [self rebuildContentWithCount:gameCount];
}
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        _scrollView.clipsToBounds = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}
- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0xf46667);
        _pageControl.pageIndicatorTintColor = UIColorFromRGB(0xe6e6e6);
    }
    return _pageControl;
}
//保存视图的组合
- (NSMutableArray *)singleTeamsArray {
    if (_singleTeamsArray == nil) {
        _singleTeamsArray = [NSMutableArray array];
    }
    return _singleTeamsArray;
}
//滚动视图和页面控制
- (void)setInfoArray:(NSArray *)array {
    self.scrollView.scrollEnabled = array.count > 1;
    self.pageControl.numberOfPages = array.count;
}
//竞彩足球，篮球
//点击比赛选项
- (void)clickHomeBuyJCView:(DPHomeBuyJCView *)view isSelected:(BOOL)isSelected index:(NSInteger)index gameType:(GameTypeId)gameType {
    if (self.delegate && [self.delegate respondsToSelector:@selector(jcSelectedView:isSelected:index:gameType:isUserTouch:)]) {
        [self.delegate jcSelectedView:view isSelected:isSelected index:index gameType:gameType isUserTouch:YES];
    }
}
//快速投注--竞彩付款
- (void)clickJcPayMoney:(GameTypeId)gameType {
    if (self.delegate && [self.delegate respondsToSelector:@selector(jcSelectedToPay:)]) {
        [self.delegate jcSelectedToPay:gameType];
    }
}
//竞彩快速投注玩法介绍
- (void)clickGameInfo:(DPHomeBuyJCView *)view {
    if (self.delegate && [self.delegate respondsToSelector:@selector(jcGameInfoView:)]) {
        [self.delegate jcGameInfoView:view];
    }
}
@end

//彩种投注cell
@interface DPLotteryInfoViewCell () {
@private
    UIImageView *_lottteryImage;
    UILabel *_titleLabel;
    UILabel *_advertiseLabel;
    UILabel *_bonusMoneyLabel;
    UILabel *_participantsLabel;
    UILabel *_markLabel;
}
@property (nonatomic, strong, readonly) UIImageView *lottteryImage;    //彩种图标
@property (nonatomic, strong, readonly) UILabel *titleLabel;           //彩种名称
@property (nonatomic, strong, readonly) UILabel *advertiseLabel;       //宣传文字
@property (nonatomic, strong, readonly) UILabel *bonusMoneyLabel;      //奖池，焦点
@property (nonatomic, strong, readonly) UILabel *participantsLabel;    //参与数
@property (nonatomic, strong, readonly) UILabel *markLabel;            //角标

@end
;
@implementation DPLotteryInfoViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *contentView = self.contentView;
        [contentView addSubview:self.lottteryImage];
        [contentView addSubview:self.titleLabel];
        [contentView addSubview:self.markLabel];
        [contentView addSubview:self.advertiseLabel];
        [contentView addSubview:self.bonusMoneyLabel];
        [contentView addSubview:self.participantsLabel];
        [self.lottteryImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(15);
            make.centerY.equalTo(contentView);
            make.height.equalTo(@48);
            make.width.equalTo(@48);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lottteryImage.mas_right).offset(5);
            make.top.equalTo(self.lottteryImage).offset(-1);
            make.height.equalTo(@18);
        }];

        [self.markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(5);
            make.centerY.equalTo(self.titleLabel);
        }];

        [self.advertiseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(3);
            make.height.equalTo(@14);
        }];
        [self.bonusMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.top.equalTo(self.advertiseLabel.mas_bottom).offset(2);
            make.height.equalTo(@14);

        }];
        [self.participantsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bonusMoneyLabel.mas_right).offset(5);
            make.top.equalTo(self.bonusMoneyLabel);
            make.height.equalTo(@14);
        }];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = dp_AppRootImage(@"homeArrow.png");
        [contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(contentView).offset(-10);
            make.centerY.equalTo(contentView);
            make.width.height.equalTo(@24);
        }];
        UIView *line = [UIView dp_viewWithColor:UIColorFromRGB(0xcececc)];
        [contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView);
            make.right.equalTo(contentView);
            make.bottom.equalTo(contentView);
            make.height.equalTo(@0.5);
        }];
        [self.contentView addGestureRecognizer:({
                              UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onSelectedLottery)];
                              tapRecognizer;
                          })];
    }
    return self;
}

//彩种图标
- (UIImageView *)lottteryImage {
    if (_lottteryImage == nil) {
        _lottteryImage = [[UIImageView alloc] init];
        _lottteryImage.backgroundColor = [UIColor clearColor];
    }
    return _lottteryImage;
}
//彩种名称
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = UIColorFromRGB(0x000000);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont dp_boldArialOfSize:17.0];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}
//宣传文字
- (UILabel *)advertiseLabel {
    if (_advertiseLabel == nil) {
        _advertiseLabel = [[UILabel alloc] init];
        _advertiseLabel.backgroundColor = [UIColor clearColor];
        _advertiseLabel.textColor = UIColorFromRGB(0x666676);
        _advertiseLabel.textAlignment = NSTextAlignmentLeft;
        _advertiseLabel.font = [UIFont dp_boldArialOfSize:12.0];
        _advertiseLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _advertiseLabel;
}
//奖池，焦点
- (UILabel *)bonusMoneyLabel {
    if (_bonusMoneyLabel == nil) {
        _bonusMoneyLabel = [[UILabel alloc] init];
        _bonusMoneyLabel.backgroundColor = [UIColor clearColor];
        //        _bonusMoneyLabel.text=@"奖池 10亿500万元,";
        _bonusMoneyLabel.textColor = UIColorFromRGB(0x666676);
        _bonusMoneyLabel.textAlignment = NSTextAlignmentLeft;
        _bonusMoneyLabel.font = [UIFont dp_boldArialOfSize:12.0];
        _bonusMoneyLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _bonusMoneyLabel;
}
//角标
- (UILabel *)markLabel {
    if (_markLabel == nil) {
        _markLabel = [[UILabel alloc] init];
        _markLabel.backgroundColor = [UIColor dp_flatRedColor];
        //        _markLabel.text=@"";  // 今日开奖
        _markLabel.layer.cornerRadius = 5;
        _markLabel.clipsToBounds = YES;
        _markLabel.textColor = [UIColor dp_flatWhiteColor];
        _markLabel.textAlignment = NSTextAlignmentLeft;
        _markLabel.font = [UIFont dp_boldArialOfSize:12.0];
        //        _markLabel.adjustsFontSizeToFitWidth=YES;
    }

    return _markLabel;
}
//参与数
- (UILabel *)participantsLabel {
    if (_participantsLabel == nil) {
        _participantsLabel = [[UILabel alloc] init];
        _participantsLabel.backgroundColor = [UIColor clearColor];
        //        _participantsLabel.text=@"参与人数：1111";
        _participantsLabel.textColor = UIColorFromRGB(0x666676);
        _participantsLabel.textAlignment = NSTextAlignmentLeft;
        _participantsLabel.font = [UIFont dp_boldArialOfSize:12.0];
        _participantsLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _participantsLabel;
}
//跳转到投注页面
- (void)pvt_onSelectedLottery {
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonClickForLotteryView:)]) {
        [self.delegate buttonClickForLotteryView:self.gameType];
    }
}
//设置图片
- (void)setlottteryImage:(UIImage *)image {
    self.lottteryImage.image = image;
}
//设置彩种名称
- (void)settitleLabel:(NSString *)title {
    self.titleLabel.text = title;
}
//设置彩种宣传文字
- (void)setadvertiseLabel:(NSString *)advertise {
    self.advertiseLabel.text = advertise;
}
//设置奖池
- (void)setbonusMoneyLabel:(NSString *)BonusMoney {
    self.bonusMoneyLabel.text = BonusMoney;
}
//设置参与数
- (void)setparticipantsLabel:(NSString *)numberString {
    self.participantsLabel.text = numberString;
}
//设置角标
- (void)setMarkLabel:(NSString *)markString {
    self.markLabel.text = [NSString stringWithFormat:@" %@ ", markString];
    self.markLabel.hidden = !markString.length;
}

@end

//社区板块
@interface DPCommunityViewCell ()

@end

@implementation DPCommunityViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *contentView = self.contentView;
        float buttonWidth = 65;
        float spaceWidth = (kScreenWidth - 40 - 65 * 3) / 2.0;
        for (int i = 0; i < 3; i++) {
            UIView *view = [[UIView alloc] init];
            view.tag = i;
            view.backgroundColor = [UIColor clearColor];
            [contentView addSubview:view];

            UIImageView *homeLogoHoverView = [[UIImageView alloc] init];
            homeLogoHoverView.backgroundColor = [UIColor clearColor];
            homeLogoHoverView.layer.cornerRadius = buttonWidth / 2.0;
            homeLogoHoverView.clipsToBounds = YES;
            [view addSubview:homeLogoHoverView];

            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.tag = KCommunityImageTag + i;
            //            imageView.layer.cornerRadius=buttonWidth/2.0;
            [homeLogoHoverView addSubview:imageView];

            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor dp_flatBlackColor];
            label.tag = KCommunityLabelTag + i;
            label.font = [UIFont systemFontOfSize:14.0];
            [view addSubview:label];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(contentView).offset(20 + (buttonWidth + spaceWidth) * i);
                make.width.equalTo(@(buttonWidth));
                make.centerY.equalTo(contentView);
                make.height.equalTo(@90);
            }];
            [homeLogoHoverView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view);
                make.right.equalTo(view);
                make.height.equalTo(@(buttonWidth));
                make.top.equalTo(view).offset(5);
            }];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view);
                make.right.equalTo(view);
                make.height.equalTo(@(buttonWidth));
                make.top.equalTo(homeLogoHoverView);
            }];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view);
                make.right.equalTo(view);
                make.bottom.equalTo(view);
                make.top.equalTo(imageView.mas_bottom).offset(2);
            }];

            [view addGestureRecognizer:({
                      UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick:)];
                      tapRecognizer;
                  })];
        }
        UIView *line = [UIView dp_viewWithColor:UIColorFromRGB(0xcececc)];
        [contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView);
            make.right.equalTo(contentView);
            make.top.equalTo(contentView);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}
//获取社区信息
- (void)communityWithArray:(NSArray *)imageArray titleArray:(NSArray *)titleArray {
    if (imageArray.count != titleArray.count) {
        return;
    }
    for (int i = 0; i < imageArray.count; i++) {
        UIImageView *imageView = (UIImageView *)[self.contentView viewWithTag:KCommunityImageTag + i];
        UILabel *label = (UILabel *)[self.contentView viewWithTag:KCommunityLabelTag + i];
        if ([imageArray objectAtIndex:i]) {
            imageView.image = [imageArray objectAtIndex:i];
        }
        label.text = [titleArray objectAtIndex:i];
    }
}
//点击跳转
- (void)btnClick:(UITapGestureRecognizer *)gesture {
    //    NSInteger index=button.tag=KCommunityButtonTag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonClickForCommunityView:)]) {
        [self.delegate buttonClickForCommunityView:gesture.view.tag];
    }
}
//获取描述标签
- (UILabel *)labelForIndex:(NSInteger)index {
    NSAssert(index < 3, @"out of bound");
    return [self.contentView viewWithTag:KCommunityLabelTag + index];
}
//获取logo
- (UIImageView *)imageViewForIndex:(NSInteger)index {
    NSAssert(index < 3, @"out of bound");
    return [self.contentView viewWithTag:KCommunityImageTag + index];
}

@end
