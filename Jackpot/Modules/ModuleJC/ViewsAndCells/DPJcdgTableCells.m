//
//  DPJcdgTableCells.m
//  DacaiProject
//
//  Created by jacknathan on 15-1-16.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPJcdgTableCells.h"
#import "UIImageView+AFNetworking.h"
#import "DPImageLabel.h"
#import "DPBetToggleControl.h"

#define FloatTextForIntDivHundred(value)  value>=0?([NSString stringWithFormat:@"%lld.%02lld", (long long)(value) / 100, (long long)(value) % 100]):@"?"  // e.g. 104 - > @"1.04"

#define kCommonJcdgFont 14
#pragma mark- 滚动球队视图的单一视图
@interface DPJcdgSingleTeamView:UIView
@property (nonatomic, strong) DPJcdgPerTeamModel *dataModel;
//- (void)setContentWithHomeName:(NSString *)homeName awayName:(NSString *)awayName
//                      homeRank:(NSString *)homeRank awayRank:(NSString *)awayRank
//                       homeImg:(NSString *)homeImg awayImg:(NSString *)awayImg
//                 compitionName:(NSString *)compName endTime:(NSString *)endTime
//                        sugest:(NSString *)sugest;

- (instancetype)initWithGameTye:(MyGameType)type ;

@end

@interface DPJcdgSingleTeamView (){
    MyGameType _myGameType ;
}
@property (nonatomic, strong, readonly)UILabel      *kindLabel; // 球种
@property (nonatomic, strong, readonly)UILabel      *deadTimeLabel; // 截止时间
@property (nonatomic, strong, readonly)UILabel      *gameSugLabel; // 赛事提点
@property (nonatomic, strong, readonly)UIImageView  *LeftTeamImgView; // 球队图标
@property (nonatomic, strong, readonly)UIImageView  *RightTeamImgView; // 球队图标

@property (nonatomic, strong, readonly)UILabel      *RightTeamNameLabel; // 球队名称
@property (nonatomic, strong, readonly)UILabel      *LeftTeamNameLabel; // 球队名称
@end

@implementation DPJcdgSingleTeamView
@synthesize kindLabel = _kindLabel;
@synthesize deadTimeLabel = _deadTimeLabel;
@synthesize gameSugLabel = _gameSugLabel;
@synthesize LeftTeamImgView = _LeftTeamImgView;
@synthesize LeftTeamNameLabel = _LeftTeamNameLabel;
@synthesize RightTeamImgView = _RightTeamImgView;
@synthesize RightTeamNameLabel = _RightTeamNameLabel;
@synthesize dataModel = _dataModel;

- (instancetype)initWithGameTye:(MyGameType)type
{
    self = [super init];
    if (self) {
        _myGameType = type ;
        [self dp_buildUI];

    }
    return self;
}
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        
//        [self dp_buildUI];
//    }
//    return self;
//}
- (void)dp_buildUI
{
    self.backgroundColor = [UIColor clearColor];
    //    self.backgroundColor = [UIColor grayColor];
    
    UIImage *img = _myGameType == GameTypeFootBall? dp_SportLotteryImage(@"dan_football.png") :dp_SportLotteryImage(@"dan_basketbal.png") ;
    
    UIImageView *contentView = [[UIImageView alloc]initWithImage:img];
//    contentView.contentMode = UIViewContentModeScaleAspectFill ;
    contentView.backgroundColor = [UIColor dp_flatWhiteColor];
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:contentView];
    [self addSubview:bottomView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(bottomView.mas_top);
    }];
    
    // 底部赛事提点
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@25);
    }];
    
    // 赛事提点
    [bottomView addSubview:self.gameSugLabel];
    [self.gameSugLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.centerX.equalTo(bottomView);
        make.width.equalTo(bottomView).offset(- 30);
    }];
    
    [self buildContentView:contentView];
    
}
- (void)buildContentView:(UIView *)contentView
{
    // 整个的中间部分
    UIView *middleView = [[UIView alloc]init];
    middleView.backgroundColor = [UIColor clearColor];
    // 左边球队
    UIView *leftView = [[UIView alloc]init];
    leftView.backgroundColor = [UIColor clearColor];
    // 右边球队
    UIView *rightView = [[UIView alloc]init];
    rightView.backgroundColor = [UIColor clearColor];
    
    [contentView addSubview:leftView];
    [contentView addSubview:rightView];
    [contentView addSubview:middleView];
    
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(7);
        make.centerX.equalTo(contentView);
        make.bottom.equalTo(contentView).offset(- 10);
        make.width.equalTo(@60);
    }];
    
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(middleView.mas_left).offset(- 20);
        make.top.equalTo(contentView).offset(8);
        make.bottom.equalTo(contentView).offset(- 10);
        make.width.equalTo(@70);
    }];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(middleView.mas_right).offset(20);
        make.top.equalTo(contentView).offset(8);
        make.bottom.equalTo(contentView).offset(- 10);
        make.width.equalTo(@70);
    }];
    
    // 中间vs部分内容
    UILabel *vsLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor dp_flatWhiteColor];
        label.font = [UIFont dp_boldArialOfSize:20];
        label.text = @"VS";
        label;
    });
    
    [middleView addSubview:self.kindLabel];
    [middleView addSubview:vsLabel];
    [middleView addSubview:self.deadTimeLabel];
    
    [self.kindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleView);
        make.centerX.equalTo(middleView);
    }];
    [vsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(middleView);
        make.centerY.equalTo(middleView);
    }];
    
    [self.deadTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vsLabel.mas_bottom).offset(4);
        make.centerX.equalTo(middleView);
    }];
    
    
    [self buildTeamView:leftView withTeamImg:self.LeftTeamImgView teamNameLabel:self.LeftTeamNameLabel];
    [self buildTeamView:rightView withTeamImg:self.RightTeamImgView teamNameLabel:self.RightTeamNameLabel];
    
}
- (void)buildTeamView:(UIView *)view withTeamImg:(UIImageView *)imageView teamNameLabel:(UILabel *)teamLabel
{
    UIView *backView = ({
        UIView *view = [[UIView alloc]init];
        //        view.backgroundColor = [UIColor dp_flatWhiteColor];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 19.5;
        view.layer.masksToBounds = YES;
        view.clipsToBounds = YES;
        view;
    });
    
    UIImageView *teamBg = [[UIImageView alloc]initWithImage:dp_SportLotteryImage(@"竞彩单关m弹框球徽框_11.png")];
    teamBg.backgroundColor = [UIColor clearColor];
    
    //    [view addSubview:teamBg];
    [view addSubview:teamLabel];
    [view addSubview:backView];
    [backView addSubview:imageView];
    [backView addSubview:teamBg];
    
    [teamBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(backView);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view);
        make.centerX.equalTo(view);
        make.width.equalTo(@39);
        make.height.equalTo(@39);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(backView);
        make.width.equalTo(@39);
        make.height.equalTo(@39);
    }];
    
    [teamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(teamBg.mas_bottom);
        make.centerX.equalTo(teamBg);
    }];
    
}
- (void)setContentWithHomeName:(NSString *)homeName awayName:(NSString *)awayName homeRank:(NSString *)homeRank awayRank:(NSString *)awayRank homeImg:(NSString *)homeImg awayImg:(NSString *)awayImg compitionName:(NSString *)compName endTime:(NSString *)endTime sugest:(NSString *)sugest
{
    NSString *leftRankString = [NSString stringWithFormat:@"[%@]",homeRank];
    if (homeRank == nil || homeRank.length == 0) {
        leftRankString = @"";
    }
    NSString *leftString = [leftRankString stringByAppendingString:homeName];
    NSMutableAttributedString *leftAttriString = [[NSMutableAttributedString alloc]initWithString:leftString];
    [leftAttriString addAttribute:(NSString *)NSFontAttributeName value:[UIFont dp_systemFontOfSize:9] range:NSMakeRange(0, leftRankString.length)];
    [leftAttriString addAttribute:(NSString *)NSForegroundColorAttributeName value:[UIColor dp_flatBlackColor] range:NSMakeRange(leftRankString.length, homeName.length)];

    self.LeftTeamNameLabel.attributedText = leftAttriString;
    
    NSString *rightRankString = [NSString stringWithFormat:@"[%@]",awayRank];
    if (awayRank == nil || awayRank.length == 0) {
        rightRankString = @"";
    }
    NSString *rightString = [awayName stringByAppendingString:rightRankString];
    NSMutableAttributedString *rightAttriString = [[NSMutableAttributedString alloc]initWithString:rightString];
    [rightAttriString addAttribute:(NSString *)NSFontAttributeName value:[UIFont dp_systemFontOfSize:9] range:NSMakeRange(awayName.length, rightRankString.length)];
    [rightAttriString addAttribute:(NSString *)NSForegroundColorAttributeName value:[UIColor dp_flatBlackColor] range:NSMakeRange(0, awayName.length)];
    self.RightTeamNameLabel.attributedText = rightAttriString;
    
    [self.LeftTeamImgView setImageWithURL:[NSURL URLWithString:homeImg] placeholderImage:dp_SportLotteryImage(@"default.png")];
    [self.RightTeamImgView setImageWithURL:[NSURL URLWithString:awayImg] placeholderImage:dp_SportLotteryImage(@"default.png")];
    self.kindLabel.text = compName;
    self.deadTimeLabel.text = endTime;
    NSString *sugestString = [NSString stringWithFormat:@"赛事提点 : %@", sugest];
    if (sugest.length == 0 || [sugest isEqualToString:@""]) sugestString = @"";
    self.gameSugLabel.text = sugestString;
}
- (void)setDataModel:(DPJcdgPerTeamModel *)dataModel
{
    NSString *leftRankString = [NSString stringWithFormat:@"[%@]",dataModel.homeRank];
    if (dataModel.homeRank == nil || dataModel.homeRank.length == 0) {
        leftRankString = @"";
    }
    NSString *leftString = [leftRankString stringByAppendingString:dataModel.homeName];
    NSMutableAttributedString *leftAttriString = [[NSMutableAttributedString alloc]initWithString:leftString];
    [leftAttriString addAttribute:(NSString *)NSFontAttributeName value:[UIFont dp_systemFontOfSize:9] range:NSMakeRange(0, leftRankString.length)];
    [leftAttriString addAttribute:(NSString *)NSForegroundColorAttributeName value:[UIColor dp_flatBlackColor] range:NSMakeRange(leftRankString.length, dataModel.homeName.length)];
    self.LeftTeamNameLabel.attributedText = leftAttriString;
    
    NSString *rightRankString = [NSString stringWithFormat:@"[%@]",dataModel.awayRank];
    if (dataModel.awayRank == nil || dataModel.awayRank.length == 0) {
        rightRankString = @"";
    }
    NSString *rightString = [dataModel.awayName stringByAppendingString:rightRankString];
    NSMutableAttributedString *rightAttriString = [[NSMutableAttributedString alloc]initWithString:rightString];
    [rightAttriString addAttribute:(NSString *)NSFontAttributeName value:[UIFont dp_systemFontOfSize:9] range:NSMakeRange(dataModel.awayName.length, rightRankString.length)];
    [rightAttriString addAttribute:(NSString *)NSForegroundColorAttributeName value:[UIColor dp_flatBlackColor] range:NSMakeRange(0, dataModel.awayName.length)];

    self.RightTeamNameLabel.attributedText = rightAttriString;
    
    [self.LeftTeamImgView setImageWithURL:[NSURL URLWithString:dataModel.homeImg] placeholderImage:dp_SportLotteryImage(@"default.png")];
    [self.RightTeamImgView setImageWithURL:[NSURL URLWithString:dataModel.awayImg] placeholderImage:dp_SportLotteryImage(@"default.png")];
    self.kindLabel.text = dataModel.compitionName;
    self.deadTimeLabel.text = dataModel.endTime;
    NSString *sugestString = [NSString stringWithFormat:@"赛事提点 : %@", dataModel.sugest];
    if (dataModel.sugest.length == 0 || [dataModel.sugest isEqualToString:@""]) sugestString = @"";
    self.gameSugLabel.text = sugestString;

}
#pragma mark - getter和setter
- (UILabel *)kindLabel
{
    if (_kindLabel == nil) {
        _kindLabel = [[UILabel alloc]init];
        _kindLabel.backgroundColor = [UIColor clearColor];
        _kindLabel.textColor = [UIColor dp_flatWhiteColor];
        _kindLabel.font = [UIFont dp_systemFontOfSize:15];
        _kindLabel.text = @"欧冠";
    }
    return _kindLabel;
}
- (UILabel *)deadTimeLabel
{
    if (_deadTimeLabel == nil) {
        _deadTimeLabel = [[UILabel alloc]init];
        _deadTimeLabel.backgroundColor = [UIColor clearColor];
        _deadTimeLabel.textColor = [UIColor dp_flatWhiteColor];
        _deadTimeLabel.font = [UIFont dp_systemFontOfSize:10.2];
        _deadTimeLabel.text = @"截止 12:12:12";
    }
    return _deadTimeLabel;
}
- (UILabel *)gameSugLabel
{
    if (_gameSugLabel == nil) {
        _gameSugLabel = [[UILabel alloc]init];
        _gameSugLabel.backgroundColor = [UIColor clearColor];
        _gameSugLabel.textColor = UIColorFromRGB(0xACACAC);
        _gameSugLabel.font = [UIFont dp_systemFontOfSize:12];
        _gameSugLabel.numberOfLines = 1;
        _gameSugLabel.textAlignment = NSTextAlignmentCenter;
        _gameSugLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _gameSugLabel.text = @"赛事提点:国际米兰新赛季走势平稳，主场不容小觑";
    }
    return _gameSugLabel;
}
- (UIImageView *)LeftTeamImgView
{
    if (_LeftTeamImgView == nil) {
        _LeftTeamImgView = [[UIImageView alloc]init];
        _LeftTeamImgView.layer.cornerRadius = 19.5;
        _LeftTeamImgView.layer.masksToBounds = YES;
        _LeftTeamImgView.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    return _LeftTeamImgView;
}
- (UILabel *)LeftTeamNameLabel
{
    if (_LeftTeamNameLabel == nil) {
        _LeftTeamNameLabel = [[UILabel alloc]init];
        _LeftTeamNameLabel.backgroundColor = [UIColor clearColor];
        _LeftTeamNameLabel.font = [UIFont dp_systemFontOfSize:14];
        _LeftTeamNameLabel.textColor = UIColorFromRGB(0x919191);
    }
    return _LeftTeamNameLabel;
}
- (UIImageView *)RightTeamImgView
{
    if (_RightTeamImgView == nil) {
        _RightTeamImgView = [[UIImageView alloc]init];
        _RightTeamImgView.layer.cornerRadius = 19.5;
        _RightTeamImgView.layer.masksToBounds = YES;
        _RightTeamImgView.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    return _RightTeamImgView;
}
- (UILabel *)RightTeamNameLabel
{
    if (_RightTeamNameLabel == nil) {
        _RightTeamNameLabel = [[UILabel alloc]init];
        _RightTeamNameLabel.backgroundColor = [UIColor clearColor];
        _RightTeamNameLabel.font = [UIFont dp_systemFontOfSize:14];
        _RightTeamNameLabel.textColor = UIColorFromRGB(0x919191);
    }
    return _RightTeamNameLabel;
}
@end


#pragma mark-顶部滚动视图
#define kSingleViewTagBase 20
#define kArrowTagBase 15
/**
 *  顶部滚动视图
 */
@interface DPJcdgTeamsView () <UIScrollViewDelegate>
{
    int            _gameCount; // 比赛场次
    UIScrollView    *_scrollView; // 滚动视图
    int             _curIndex; // 当前页
    
    MyGameType _myGameType ;
}
@property (nonatomic, strong, readonly)NSMutableArray *singleTeamsArray; // 存放滚动的单一视图
@property (nonatomic, strong, readonly)UIImageView *leftArrow; // 左边箭头
@property (nonatomic, strong, readonly)UIImageView *rightArrow; // 右边箭头

- (instancetype)initWithGameType:(MyGameType)type ;

@end

@implementation DPJcdgTeamsView
@synthesize singleTeamsArray = _singleTeamsArray;
@synthesize leftArrow = _leftArrow;
@synthesize rightArrow = _rightArrow;
@synthesize myGameType = _myGameType ;

-(void)setMyGameType:(MyGameType)myGameType{

    _myGameType = myGameType ;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _gameCount = 0;
        _curIndex = 0;
        [self buildUI];
    }
    return self;
}

- (instancetype)initWithGameType:(MyGameType)type
{
    self = [super init];
    if (self) {
        _myGameType = type ;
    }
    return self;
}

- (void)buildUI
{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.scrollView];
    [self addSubview:self.leftArrow];
    [self addSubview:self.rightArrow];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    [self.leftArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self).offset(- 20);
    }];
    
    [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(- 10);
        make.centerY.equalTo(self).offset(- 20);
    }];
}
- (void)rebuildContentWithCount:(int)gameCount
{
    [self.singleTeamsArray removeAllObjects];

    if (gameCount <= 0) {
        return;
    }
    if (gameCount == 1) {
        DPJcdgSingleTeamView *singleView = self.singleTeamsArray.firstObject;
        if (singleView == nil) {
            singleView = [[DPJcdgSingleTeamView alloc]initWithGameTye:_myGameType];
            [self.singleTeamsArray addObject:singleView];
        }
        [self.scrollView addSubview:singleView];
        singleView.tag = kSingleViewTagBase + 0;
        [singleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView);
            make.bottom.equalTo(self.scrollView);
            make.left.equalTo(self.scrollView);
            make.right.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
            make.height.equalTo(self.scrollView);
        }];
        self.leftArrow.hidden = YES;
        self.rightArrow.hidden = YES;
        
    }else{
        [self.singleTeamsArray removeAllObjects];
        while (self.singleTeamsArray.count < gameCount + 2) {
            DPJcdgSingleTeamView *singleView = [[DPJcdgSingleTeamView alloc]initWithGameTye:_myGameType];
            [self.singleTeamsArray addObject:singleView];
        }
        DPJcdgSingleTeamView *firstSingleView = self.singleTeamsArray.firstObject;
        firstSingleView.hidden = YES;
        DPAssert(self.singleTeamsArray.count >= gameCount + 2);
        int i = 0;
        for (DPJcdgSingleTeamView *singleView in self.singleTeamsArray) {
            [self.scrollView addSubview:singleView];
            singleView.tag = kSingleViewTagBase + i;
            [singleView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.left.equalTo(self.scrollView);
                }else if (i == gameCount + 1){
                    DPJcdgSingleTeamView *preView = self.singleTeamsArray[i - 1];
                    make.left.equalTo(preView.mas_right);
                    make.right.equalTo(self.scrollView);
                    
                }else{
                    DPJcdgSingleTeamView *preView = self.singleTeamsArray[i - 1];
                    make.left.equalTo(preView.mas_right);
                }
                make.top.equalTo(self.scrollView);
                make.bottom.equalTo(self.scrollView);
                make.width.equalTo(self.scrollView);
                make.height.equalTo(self.scrollView);
            }];
            i++;
        }
        self.leftArrow.hidden = NO;
        self.rightArrow.hidden = NO;
    }
}
- (void)tapScrollClick:(UIGestureRecognizer *)sender
{
    DPJcdgSingleTeamView *firstSingleView = self.singleTeamsArray.firstObject;
    if (firstSingleView.hidden == YES) firstSingleView.hidden = NO;
    
    CGPoint newOffset = CGPointZero;
    if (sender.view.tag == kArrowTagBase+1) {
        newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.bounds), 0);

    }else{
        newOffset = CGPointMake(self.scrollView.contentOffset.x - CGRectGetWidth(self.scrollView.bounds), 0);

    }
    [UIView animateWithDuration:0.3f animations:^{
        self.scrollView.contentOffset = newOffset;
    } completion:^(BOOL finished) {
        [self dp_scrollViewCircleChange];
    }];
}
- (void)dp_scrollViewCircleChange
{
    int gameCount = self.gameCount + 2;
    CGFloat width = CGRectGetWidth(self.scrollView.bounds);
    int curX = self.scrollView.contentOffset.x;
    if (curX <= 0) {
        self.scrollView.contentOffset = CGPointMake(width * (gameCount - 2), 0);
    }else if(curX >= (gameCount - 1 ) * width){
        self.scrollView.contentOffset = CGPointMake(width, 0);
    }
    int index = self.scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.bounds) - 1;
    if (index != _curIndex) {
        if ([self.delegate respondsToSelector:@selector(gamePageChangeFromPage:toNewPage:)]) {
            [self.delegate gamePageChangeFromPage:_curIndex toNewPage:index];
        }
    }
    _curIndex = index;
}

-(void)cleanAllTeamView{

    for (DPJcdgTeamsView *view in self.singleTeamsArray) {
        [view removeFromSuperview];
    }
    
 
}
- (void)setSingleTeamAtIndex:(NSInteger)index withDataModel:(DPJcdgPerTeamModel *)model;
{
    DPJcdgSingleTeamView *view = nil;
    DPJcdgSingleTeamView *viewOther = nil;
    if (_gameCount == 1) {
        view = self.singleTeamsArray[index];
        view.dataModel = model;
        return;
    }
    view = self.singleTeamsArray[index + 1];
    if (self.singleTeamsArray.count && index < self.singleTeamsArray.count - 2) {
        if (index == 0 && self.gameCount > 1) {
            viewOther = self.singleTeamsArray.lastObject;
        }else if (index == self.gameCount - 1)
        {
            viewOther = self.singleTeamsArray.firstObject;
        }
        view.dataModel = model;
        if (viewOther) viewOther.dataModel = model;
    }

}
#pragma mark - scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self dp_scrollViewCircleChange];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    DPJcdgSingleTeamView *firstSingleView = self.singleTeamsArray.firstObject;
    
    if (firstSingleView.hidden == YES) firstSingleView.hidden = NO;
}


#pragma mark - getter & setter
- (int)gameCount
{
    return _gameCount;
}
- (void)setGameCount:(int)gameCount
{
    _gameCount = gameCount;
    
    [self rebuildContentWithCount:gameCount];
}
- (NSMutableArray *)singleTeamsArray
{
    if (_singleTeamsArray == nil) {
        _singleTeamsArray = [NSMutableArray array];
    }
    return _singleTeamsArray;
}
- (UIImageView *)leftArrow
{
    if (_leftArrow == nil) {
 
        _leftArrow = [[UIImageView alloc]initWithImage:dp_SportLotteryImage(@"arrow_left.png")];
     
        _leftArrow.tag = kArrowTagBase + 0;
        _leftArrow.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScrollClick:)];
        [_leftArrow addGestureRecognizer:tap];
        _leftArrow.backgroundColor = [UIColor clearColor] ;
        _leftArrow.hidden = YES;
    }
    return _leftArrow;
}
- (UIImageView *)rightArrow
{
    if (_rightArrow == nil) {
         _rightArrow = [[UIImageView alloc]initWithImage:dp_SportLotteryImage(@"arrow_right.png")];
        _rightArrow.tag = kArrowTagBase + 1;
        _rightArrow.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScrollClick:)];
        [_rightArrow addGestureRecognizer:tap];
        _rightArrow.hidden = YES;
        _rightArrow.backgroundColor = [UIColor clearColor] ;
    }
    return _rightArrow;
}
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
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
@end

@implementation UUBar




-(UIView*)chartView{

    if (_chartView == nil) {
        _chartView = [[UIView alloc]initWithFrame: CGRectMake(7.5, CGRectGetHeight(self.frame)-5, KCharWith, 5)];
        _chartView.backgroundColor = [UIColor clearColor] ;
        _chartView.layer.cornerRadius = 5 ;
        _chartView.clipsToBounds = YES ;

    }
    
    return _chartView;
}

- (instancetype)initWithColors:(UIColor*)colors bottomColor:(UIColor*)botColor
{
    self = [super init];
    if (self) {
        
        _currentPercent = 0 ;
        self.clipsToBounds = YES ;
        self.layer.cornerRadius = 2.0 ;
        
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = botColor ;
        _bottomView.clipsToBounds = YES ;
        _bottomView.layer.cornerRadius = 3 ;
        [self addSubview:_bottomView];
        
        [self addSubview:self.chartView];
        self.chartView.backgroundColor = colors ;
        
        
        _percentLabel= [[KTMCountLabel alloc]init];
        _percentLabel.backgroundColor =[UIColor clearColor] ;
        _percentLabel.textAlignment = NSTextAlignmentCenter ;
        _percentLabel.font = [UIFont dp_systemFontOfSize:10.f] ;
        [self addSubview:_percentLabel];
                        
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    _bottomView.frame = CGRectMake(0, CGRectGetHeight(self.frame)-5, self.frame.size.width, 5) ;
    
    
}

 -(void)setCurrentPercent:(int)currentPercent{
    _currentPercent = currentPercent ;
    _percentLabel.text = [NSString stringWithFormat:@"%d%%支持",currentPercent ] ;
}


-(void)setChartHight:(float)chartHight{
    
    _currentPercent = 0 ;
    _chartHight = chartHight ;
   
    _percentLabel.text = [NSString stringWithFormat:@"%d%%支持",0 ] ;
    
    self.chartView.frame = CGRectMake(7.5, CGRectGetHeight(self.frame)-2.5, KCharWith, 0) ;
    _percentLabel.frame = CGRectMake(0, CGRectGetHeight(self.frame)-15, self.frame.size.width, 10) ;

    if (chartHight == 0) {
        return ;
    }
    
    [_percentLabel countWithDuration:1.5
                      animationCurve:UIViewAnimationCurveEaseOut
                          fromNumber:0
                            toNumber:100 * chartHight
                         textHandler:^NSString *(NSInteger number) {
                             return [NSString stringWithFormat:@"%d%%支持", (int)number];
                         }];
    
    self.chartView.frame = CGRectMake(7.5, CGRectGetHeight(self.frame)-2.5, KCharWith, 0);
    _percentLabel.center = CGPointMake(CGRectGetWidth(self.frame)/2,CGRectGetHeight(self.frame)-10);
    
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.chartView.frame = CGRectMake(7.5, (self.frame.size.height-15)*(1-chartHight)+10+2.5, KCharWith, (self.frame.size.height-15)*chartHight);
        _percentLabel.center = CGPointMake(CGRectGetWidth(self.frame)/2, (CGRectGetHeight(self.frame)-15)*(1-chartHight)+5+2.5);
    } completion:nil];
//    [UIView animateWithDuration:1.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState animations:^{
//        self.chartView.frame = CGRectMake(7.5, (self.frame.size.height-15)*(1-chartHight)+10+2.5, KCharWith, (self.frame.size.height-15)*chartHight);
//        _percentLabel.center = CGPointMake(CGRectGetWidth(self.frame)/2, (CGRectGetHeight(self.frame)-15)*(1-chartHight)+5+2.5);
//    } completion:nil];
}

-(void)drawRect:(CGRect)rect{
    //画背景色
    CGContextRef context  =UIGraphicsGetCurrentContext() ;
    CGContextSetFillColorWithColor(context, [UIColor dp_flatWhiteColor].CGColor);
    CGContextFillRect(context, rect) ;
}



@end



////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark- 底部投注部分


typedef void(^KSubmitBlock)(int zhushu);
/**
 *  底部投注部分
 */
@interface DPCellBottomView : UIView<UITextFieldDelegate,KTMKeyboardObserver>{

    UILabel *_bonusLabel;
    UILabel *_moneyLabel;
    UITextField *_textField;
    UIView   *_commitView;
    NSLayoutConstraint *_timeLabelConst;
    UILabel *_bonusBetterLabel;
    BOOL _hasLoaded;

    MyGameType _myType ;
    UILabel *_timesLabel;

}

//@property (nonatomic, weak) id <DPJcdgPullCellDelegate> delegate;
@property(nonatomic,copy)KSubmitBlock submitBlock ;
@property (nonatomic, assign) float miniBonus; // 最小奖金
@property (nonatomic, assign) float maxBonus; // 最大奖金
@property (nonatomic, assign) GameTypeId gameType; // 玩法类型
@property (nonatomic, assign) int zhuShu; // 注数
@property (nonatomic, strong, readonly) UITextField *textField; // 倍数
@property (nonatomic, strong, readonly) UIView *commitView;  // 提交视图
@property (nonatomic, strong, readonly) UILabel *timesLabel; // 倍



@property (nonatomic, strong, readonly) UILabel *moneyLabel; // 金额
@property (nonatomic, strong, readonly) UILabel *bonusLabel; // 奖金
@property (nonatomic, strong, readonly) NSLayoutConstraint *timeLabelConst; // 奖金的位置
@property (nonatomic, strong, readonly) UILabel *bonusBetterLabel;

- (void)dp_reloadMoney ;
/**
 *  更新“倍”的位置
 */
-(void)updateTimesLabel ;


@end

@implementation DPCellBottomView
@dynamic bonusLabel;
@dynamic moneyLabel;
@synthesize zhuShu = _zhuShu ;
@synthesize timesLabel = _timesLabel ;


-(NSLayoutConstraint*)timeLabelConst{

    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstItem == self.timesLabel && constraint.firstAttribute == NSLayoutAttributeLeft) {
            _timeLabelConst = constraint ;
            break ;
        }
        
    }
    return  _timeLabelConst ;

}

-(UILabel*)timesLabel{

    if (_timesLabel == nil) {
        _timesLabel = [[UILabel alloc]init];
        _timesLabel.font = [UIFont dp_systemFontOfSize:16]  ;
        _timesLabel.backgroundColor = [UIColor clearColor] ;
        _timesLabel.text = @"倍" ;
        _timesLabel.textColor = [UIColor dp_flatBlackColor] ;
    }
    
    return _timesLabel ;
}

- (instancetype)initWithGameType:(MyGameType)type
{
    self = [super init];
    if (self) {
        
        _myType = type ;
        [self buildUI:type];
    }
    return self;
}


static inline float TTextLength(NSString *text){

//    [text boundingRectWithSize:CGSizeMake(60, 30) options:NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont dp_systemFontOfSize:16],NSFontAttributeName, nil] context:nil] ;
//   CGSize size = [text sizeWithFont:[UIFont dp_systemFontOfSize:16] constrainedToSize:CGSizeMake(60, 30)];
    CGSize size = [NSString dpsizeWithSting:text andFont:[UIFont dp_systemFontOfSize:16] andMaxSize:CGSizeMake(60, 30)];
    return size.width ;
 } ;

-(void)buildUI:(MyGameType)type{

    
    
    UIView *contentView = [[UIView alloc]init];
    contentView.userInteractionEnabled = YES;
    contentView.backgroundColor = [UIColor dp_flatWhiteColor];
    
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self) ;
        make.left.equalTo(self) ;
        make.right.equalTo(self) ;
        make.height.equalTo(@(type == GameTypeFootBall?100:70)) ;
    }];
    
    
    [contentView addSubview:self.bonusLabel];
    
    
    if (type == GameTypeFootBall) {
        
        UIButton *infoButton = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
            
            [btn setImage:dp_SportLotteryImage(@"i_42.png") forState:UIControlStateNormal];
            [btn setTitle: @"竞猜90分钟内的比赛(含伤停补时)" forState:UIControlStateNormal];
            [btn setTitleColor: UIColorFromRGB(0xADADAD) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont dp_systemFontOfSize:13];
            btn.backgroundColor = [UIColor clearColor] ;
            btn ;
            
        });
        [contentView addSubview:self.bonusBetterLabel];
        [contentView addSubview:infoButton];
        
        
        [self.bonusBetterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(contentView).offset(- 30);
            make.top.equalTo(contentView).offset(5);
         }];
        
        [self.bonusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(contentView).offset(5);
            make.left.equalTo(contentView).offset(30);
            make.bottom.equalTo(self.bonusBetterLabel) ;
            make.right.equalTo(contentView).offset(-80);
            
        }];
        
        
        [infoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bonusLabel.mas_bottom);
            make.centerX.equalTo(contentView);
            make.height.equalTo(@35) ;
        }] ;
        
        
        
    }else{
        
        [self.bonusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(contentView).offset(5);
            make.left.equalTo(contentView).offset(30);
            make.height.equalTo(@20) ;
            make.right.equalTo(contentView).offset(-25);
            
        }];
        
    }
    UIView *commitView = self.commitView;
    [contentView addSubview:commitView];
    
    [commitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView).offset(- 10);
        make.right.equalTo(contentView).offset(- 30);
        make.width.equalTo(@140) ;
        make.height.equalTo(@30) ;
    }];
    
    UITextField *timeFeild = ({
        UITextField *textField = [[UITextField alloc]init];
        textField.backgroundColor = [UIColor dp_flatWhiteColor];
        textField.layer.cornerRadius = 5;
        textField.layer.borderWidth = 1;
        textField.layer.borderColor = [UIColor dp_colorFromHexString:@"#DBDBDB"].CGColor;
        textField.text = @"10";
        textField.textAlignment = NSTextAlignmentCenter;
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        
        textField.leftView =({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
            btn.backgroundColor = [UIColor clearColor] ;
            [btn setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
            [btn setTitle:@"＋" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont dp_boldSystemFontOfSize:18] ;
            [btn addTarget:self action:@selector(pvt_addTimes) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(0, 0, 30, 30);
            btn ;
        });
         textField.rightView = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
            btn.backgroundColor = [UIColor clearColor] ;
            [btn setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
            [btn setTitle:@"－" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont dp_boldSystemFontOfSize:18] ;
            [btn addTarget:self action:@selector(pvt_minuTimes) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(0, 0, 46, 30);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 0) ;
            btn ;
        });
        textField.font = [UIFont dp_systemFontOfSize:16] ;
        textField.rightViewMode =
        textField.leftViewMode = UITextFieldViewModeAlways ;
        textField;
    });
    _textField = timeFeild;
    
    [contentView addSubview:timeFeild];
    [timeFeild mas_makeConstraints:^(MASConstraintMaker *make) {
 
        make.right.equalTo(contentView.mas_centerX).offset(-15) ;
        make.bottom.equalTo(contentView).offset(- 10);
        make.left.equalTo(contentView).offset(30) ;
        make.height.equalTo(@30) ;
        
    }];
    
    [self addSubview:self.timesLabel];
    [self.timesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeFeild.mas_centerY) ;
        make.left.equalTo(timeFeild.mas_centerX).offset(TTextLength(timeFeild.text)/2-8) ;
    }];
    
    
    
    // build commitView
    UILabel *buyLabel = ({
        
        UILabel *lab = [[UILabel alloc]init];
        lab.textColor = [UIColor dp_flatWhiteColor] ;
        lab.text = @"立即购买  ";
        lab.font = [UIFont dp_boldSystemFontOfSize:15] ;
        lab.textAlignment = NSTextAlignmentCenter ;
        lab.backgroundColor = [UIColor clearColor] ;
        lab ;
    });
    
    [commitView addSubview:buyLabel];
    [commitView addSubview:self.moneyLabel];
    
    [buyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(commitView).offset(-5);
        make.width.equalTo(@60) ;
        make.centerY.equalTo(commitView);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(commitView).offset(5);
        make.centerY.equalTo(commitView);
        make.right.equalTo(buyLabel.mas_left) ;
        
    }];


}

-(void)updateTimesLabel{
    
    self.timeLabelConst.constant = 0 ;
    float textWidth = TTextLength(self.textField.text) ;
    self.timeLabelConst.constant += textWidth/2-8 ;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)dp_reloadMoney
{
    NSString *string1 = @"预计奖金: ";
    NSString *moneyString = [NSString stringWithFormat:@"%.2f-%.2f元", _miniBonus * self.textField.text.intValue * 2, _maxBonus * self.textField.text.intValue * 2];
    
    if (_miniBonus == _maxBonus) moneyString = [NSString stringWithFormat:@"%.2f元", _maxBonus * self.textField.text.intValue * 2];
    NSString *bonusText = [string1 stringByAppendingString:moneyString];
    
    //    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc]initWithString:bonusText];
    //    [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor dp_flatRedColor] range:NSMakeRange(string1.length, moneyString.length - 1)];
    //
    //    self.bonusLabel.attributedText = attriString;
    self.bonusLabel.text = bonusText;
    self.moneyLabel.text = [NSString stringWithFormat:@"金额%d元", self.zhuShu * self.textField.text.intValue * 2];
    
}


-(void)pvt_addTimes{
    
     if ([_textField.text intValue]>=1000) {
        
        return ;
    }
    
    _textField.text = [NSString stringWithFormat:@"%d",[_textField.text intValue]+1] ;
    [self dp_reloadMoney];
    [self updateTimesLabel];
 }
-(void)pvt_minuTimes{
     NSString *num = _textField.text   ;
    if ([num intValue]<=1) {
        
        return ;
    }
    _textField.text = [NSString stringWithFormat:@"%d",[num intValue]-1] ;
    [self dp_reloadMoney];
    [self updateTimesLabel];
    
    
}



- (UIView *)commitView
{
    if (_commitView == nil) {
        _commitView = [[UIView alloc]init];
        _commitView.backgroundColor = [UIColor dp_flatRedColor];
        _commitView.layer.cornerRadius = 3 ;
        _commitView.layer.masksToBounds = YES ;
        [_commitView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pvt_commitTap)]] ;
       
    }
    return _commitView;
}

-(void)pvt_commitTap{

    [self.textField resignFirstResponder];
    if (self.submitBlock) {
        self.submitBlock(self.zhuShu) ;
    }
}
- (UILabel *)bonusLabel
{
    if (_bonusLabel == nil) {
        _bonusLabel = [[UILabel alloc]init];
        _bonusLabel.backgroundColor = [UIColor clearColor];
        _bonusLabel.font = [UIFont dp_systemFontOfSize:15];
        _bonusLabel.numberOfLines = 1;
        _bonusLabel.textAlignment = NSTextAlignmentLeft;
        _bonusLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _bonusLabel.textColor = [UIColor dp_flatRedColor] ;
        _bonusLabel.text = @"预计奖金：210.00元" ;
    }
    return _bonusLabel;
}

- (UILabel *)bonusBetterLabel
{
    if (_bonusBetterLabel == nil) {
        _bonusBetterLabel = [[UILabel alloc]init];
        _bonusBetterLabel.backgroundColor = [UIColor clearColor];
        _bonusBetterLabel.textColor = [UIColor dp_colorFromHexString:@"#1E50A2"];
        _bonusBetterLabel.font = [UIFont dp_systemFontOfSize:15];
        _bonusBetterLabel.userInteractionEnabled = YES;
        _bonusBetterLabel.textAlignment = NSTextAlignmentCenter ;
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc]initWithString:@"奖金优化"];
        [attriString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, 4)];
        _bonusBetterLabel.attributedText = attriString;
       
    }
    return _bonusBetterLabel;
}

- (UILabel *)moneyLabel
{
    if (_moneyLabel == nil) {
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.backgroundColor = [UIColor clearColor];
        _moneyLabel.font = [UIFont dp_systemFontOfSize:11];
        _moneyLabel.textColor = [UIColor dp_flatWhiteColor];
        _moneyLabel.text = @"金额100元";
    }
    return _moneyLabel;
}
- (void)setMiniBonus:(float)miniBonus
{
    _miniBonus = miniBonus;
    
    [self dp_reloadMoney];
}

- (void)setMaxBonus:(float)maxBonus
{
    _maxBonus = maxBonus;
    [self dp_reloadMoney];
}



@end

#pragma mark- cell基类
@interface DPJcdgGameTypeBasicCell ()<KTMKeyboardObserver,UITextFieldDelegate>
{
    UITextField *_gameTypeLabel;
    UIView  *_basContentView;
    UIImageView *_flagView;
    DPCellBottomView * _bottomContentView ;
    
    
}
@property (nonatomic, strong, readonly)UIView *basContentView;
@property (nonatomic, strong, readonly)DPCellBottomView *bottomContentView;


@end

@implementation DPJcdgGameTypeBasicCell
@dynamic gameTypeLabel;
@synthesize   basContentView = _basContentView ;;
@synthesize flagView =_flagView ;


- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview) {
        [[KTMKeyboardManager defaultManager] addObserver:self];
    }else{
        [[KTMKeyboardManager defaultManager] removeObserver:self];
    }
    
    if (!_hasLoaded && newSuperview) {
        _hasLoaded = YES;
        
        [self buildCommonUI];
    }
    
}


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier WithGameType:(MyGameType)type
{
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) && !_hasLoaded) {
        _myGameType = type ;
        [self buildCommonUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self buildCommonUI];
    }
    return self;
}

- (void)buildCommonUI
{
    
    _hasLoaded = YES ;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    
    headViewBg = [[UIView alloc]init];
    headViewBg.backgroundColor = [UIColor clearColor] ;
    [self.contentView addSubview:headViewBg];
    [headViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView) ;
        make.left.equalTo(self.contentView).offset(5) ;
        make.right.equalTo(self.contentView).offset(-10) ;
        make.height.equalTo(@30) ;
    }];
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dp_infoButtonClick:)];
    [headViewBg addGestureRecognizer:tap];
    
    [headViewBg addSubview:self.flagView];
    [headViewBg addSubview:self.gameTypeLabel];
    
    [self.flagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headViewBg);
        make.left.equalTo(headViewBg);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    [self.gameTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headViewBg).offset(30);
        make.bottom.equalTo(headViewBg).offset(-3);
    }];

    
    
    
    [self.contentView addSubview:self.basContentView];
    [self.contentView addSubview:self.bottomContentView];

    
 }

- (void)dp_infoButtonClick:(UIButton *)sender
{
        if ([self.delegate respondsToSelector:@selector(dpjcdgInfoButtonClick:)]) {
        [self.delegate dpjcdgInfoButtonClick:self];
    }
}

- (UITextField *)gameTypeLabel
{
    if (_gameTypeLabel == nil) {
        _gameTypeLabel = [[UITextField alloc]init];
        _gameTypeLabel.backgroundColor = [UIColor clearColor];
        _gameTypeLabel.font = [UIFont dp_systemFontOfSize:16];
        _gameTypeLabel.textColor = [UIColor dp_flatBlackColor];
        _gameTypeLabel.enabled = NO ;
        _gameTypeLabel.rightView =({
        
            UIImageView *infoBtn = [[UIImageView alloc]initWithImage:dp_SportLotteryImage(@"dgInfo.png")];
            infoBtn.backgroundColor = [UIColor clearColor];
            infoBtn.contentMode = UIViewContentModeScaleAspectFit ;
            infoBtn ;
        });
        _gameTypeLabel.rightViewMode =  UITextFieldViewModeAlways ;
        _gameTypeLabel.text = @"让球胜平负";
    }
    return _gameTypeLabel;
}
- (UIView *)basContentView
{
    if (_basContentView == nil) {
        _basContentView = [[UIView alloc]init];
        _basContentView.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    return _basContentView;
}

-(UIImageView*)flagView{

    if (_flagView == nil) {
        _flagView = [[UIImageView alloc]initWithImage:dp_SportLiveImage(@"dan_rf.png")];
        _flagView.userInteractionEnabled = YES ;
        _flagView.backgroundColor = [UIColor clearColor] ;
    }
    
    return _flagView ;
}

-(DPCellBottomView*)bottomContentView{
    if (_bottomContentView == nil) {
        _bottomContentView = [[DPCellBottomView alloc]initWithGameType:_myGameType];
        _bottomContentView.backgroundColor = [UIColor dp_flatWhiteColor] ;
        
        __weak __typeof(self)weakSelf = self ;
        _bottomContentView.submitBlock = ^(int zhushu){
            
            if (zhushu <=0) {
                [[DPToast makeText:@"没有选项怎么中奖"]show]  ;
                return ;
            }
            
            [weakSelf pvt_commitTap];
            
        
        } ;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pvt_bonusBetterClick)];
        [_bottomContentView.bonusBetterLabel addGestureRecognizer:tap];
        
        _bottomContentView.textField.delegate =self ;
        
        


    }
    return _bottomContentView ;
}
-(void)pvt_commitTap {

     if (self.bottomContentView.textField.text.length == 0 || [self.bottomContentView.textField.text isEqual: @""]) {
        [DPToast makeText:@"请设置投注倍数"];
        return;
    }
    if ([self.bottomDelegate respondsToSelector:@selector(bottomCommit:times:)]) {
        [self.bottomDelegate bottomCommit:self times: self.bottomContentView.textField.text.intValue];
    }


}
- (void)pvt_bonusBetterClick
{
    if ([self.bottomDelegate respondsToSelector:@selector(bottomBonusBetterClick:times:)]) {
        [self.bottomDelegate bottomBonusBetterClick:self times:self.bottomContentView.textField.text];
    }
}



- (void)buildView:(UIView *)contentView withPercent:(UUBar *)percentBar teamNameBtn:(UIButton *)teamNameBtn
{
    [contentView addSubview:percentBar];
    [contentView addSubview:teamNameBtn];
    
    [percentBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@65);
        make.height.equalTo(@65);
        make.top.equalTo(contentView);
        make.centerX.equalTo(contentView);
    }];
    
    [teamNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(percentBar.mas_bottom).offset(5);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.bottom.equalTo(contentView);
    }];
    
    [percentBar setNeedsLayout];
    [percentBar layoutIfNeeded];
    
}


- (void)dp_reloadMoneyWithTimeTex:(NSString *)timesText gameIndex:(int)gameIndex
{
    GameTypeId gameType = self.gameType;
    int note, minBonus, maxBonus;
    int result = 0 ;
    // TODO:
//    if (_myGameType == GameTypeFootBall) {
//        CLotteryJczq *lotteryJczq = CFrameWork::GetInstance()->GetLotteryJczq();
//        result = lotteryJczq -> GetSingleTargetAmount(gameIndex, gameType, note, minBonus, maxBonus);
//
//    }else{
//        CLotteryJclq *lotteryLq = CFrameWork::GetInstance()->GetLotteryJclq() ;
//        result = lotteryLq ->GetSingleTargetAmount(gameIndex, gameType, note, minBonus, maxBonus) ;
//    }
    
   
    if (result < 0 ) {
        DPLog(@"数据错误，--------------数据错误");
        return;
    }
    self.bottomContentView.miniBonus = [FloatTextForIntDivHundred(minBonus) floatValue];
    self.bottomContentView.maxBonus = [FloatTextForIntDivHundred(maxBonus) floatValue];
    self.bottomContentView.zhuShu = note;
    if (timesText.length > 0) self.bottomContentView.textField.text = [NSString stringWithFormat:@"%@倍",timesText];
    
    
    [self.bottomContentView dp_reloadMoney];
}


#pragma mark KTMKeyboardObserver

- (void)keyboardFrameChanged:(KTMKeyboardTransition)transition {
    if ([self.bottomDelegate respondsToSelector:@selector(bottomOfCell:keyboardVisible:options:duration:frameBegin:frameEnd:)]) {
        [self.bottomDelegate bottomOfCell:self keyboardVisible:transition.keyboardVisible options:transition.animationOptions duration:transition.animationDuration frameBegin:transition.frameBegin frameEnd:transition.frameEnd];
    }
}

#pragma mark - textfield delegate


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
     if (![KTMValidator isNumber:string]) {

         return NO;
    }
    
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (newString.intValue > 1000){
        newString = @"1000";
    }
    if(newString.length<=0){
        self.bottomContentView.textField.text = newString  ;
    }else
        self.bottomContentView.textField.text = [NSString stringWithFormat:@"%d",newString.intValue] ;
    [self.bottomContentView dp_reloadMoney];
    [self.bottomContentView updateTimesLabel];
    
    return NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.text.intValue<1){
         textField.text=@"1";

        [self.bottomContentView dp_reloadMoney];
        [self.bottomContentView updateTimesLabel];
    }
    if ([self.bottomDelegate respondsToSelector:@selector(bottomOfCell:endEditingWithText:)]) {
        [self.bottomDelegate bottomOfCell:self endEditingWithText:textField.text ];
    }
}


- (void)setGameType:(GameTypeId)gameType
{
    _gameType = gameType;
    if (_myGameType == GameTypeBasketBall) {
        self.bottomContentView.bonusBetterLabel.hidden = YES;
    }else{
        self.bottomContentView.bonusBetterLabel.hidden =  NO ;
    }

 }

-(void)dp_setCelldataModel:(id)dataModel{

    self.bottomContentView.textField.text = @"10" ;
    [self.bottomContentView updateTimesLabel];
}


@end




#pragma mark- 让球胜负
#define kRqspfCommonBtnTagBase 200
@interface DPjcdgTypeRqspfCell ()
@property (nonatomic, strong) NSArray *percents; // 百分比
@property (nonatomic, strong) NSArray *teamNames; // 队伍名称
@property (nonatomic, assign) KSpfDetailType detailType; // 让球胜平负和胜平负区分
@property (nonatomic, assign) NSArray *defaultOption;


@property (nonatomic, strong, readonly)UUBar *leftPercentBar;
@property (nonatomic, strong, readonly)UUBar *middlePercentBar;
@property (nonatomic, strong, readonly)UUBar *rightPercentBar;

@property (nonatomic, strong, readonly)UIButton *leftTeamBtn;
@property (nonatomic, strong, readonly)UIButton *middleTeamBtn;
@property (nonatomic, strong, readonly)UIButton *rightTeamBtn;

@end

@implementation DPjcdgTypeRqspfCell

@synthesize leftTeamBtn = _leftTeamBtn;
@synthesize middleTeamBtn = _middleTeamBtn;
@synthesize rightTeamBtn = _rightTeamBtn;
@synthesize detailType = _detailType;


@synthesize leftPercentBar = _leftPercentBar ;
@synthesize middlePercentBar = _middlePercentBar ;
@synthesize rightPercentBar = _rightPercentBar ;



- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier WithGameType:(MyGameType)type
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier WithGameType:type]) {
//        [self dp_bulidRqspf];
    }
    
    return self;
    
}
-(void)buildCommonUI{
    if (_hasLoaded) {
        return ;
    }
    [super buildCommonUI];
    
    
    [self.basContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headViewBg.mas_bottom);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@135) ;
    }];
    
//135+100+30
    [self.bottomContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView) ;
        make.left.equalTo(self.contentView) ;
        make.right.equalTo(self.contentView) ;
        make.height.equalTo(@100);
    }];
    
    [self dp_bulidRqspf];
    
}

- (void)dp_bulidRqspf
{
    
    
    UIView *leftView = [[UIView alloc]init];
    UIView *rightView = [[UIView alloc]init];
    UIView *middleView = [[UIView alloc]init];
    leftView.backgroundColor = [UIColor clearColor];
    rightView.backgroundColor = [UIColor clearColor];
    middleView.backgroundColor = [UIColor clearColor];
    
    UIView *contentView = self.basContentView;
    [contentView addSubview:leftView];
    [contentView addSubview:middleView];
    [contentView addSubview:rightView];
    
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(30);
        make.top.equalTo(contentView).offset(7);
        make.bottom.equalTo(contentView).offset(- 10);
        make.width.equalTo(@91);
    }];
    
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView) ;
        make.top.equalTo(leftView);
        make.bottom.equalTo(leftView);
        make.width.equalTo(@71);
    }];
    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-30);
        make.top.equalTo(leftView);
        make.bottom.equalTo(leftView);
        make.width.equalTo(@91);
    }];
    
    
    [self buildView:leftView withPercent:self.leftPercentBar teamNameBtn:self.leftTeamBtn];
    [self buildView:middleView withPercent:self.middlePercentBar teamNameBtn:self.middleTeamBtn];
    [self buildView:rightView withPercent:self.rightPercentBar teamNameBtn:self.rightTeamBtn];

    

}


// 按钮初始化
- (UIButton *)createCommonButtonWithTitle:(NSString *)title tag:(int)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *resizeImg = dp_SportLotteryResizeImage(@"选取样式框架_34.png") ;
    [button setBackgroundImage:resizeImg forState:UIControlStateSelected];
    [button setBackgroundImage:dp_SportLotteryResizeImage(@"btn_bg_03.png") forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont dp_systemFontOfSize:kCommonJcdgFont - 2];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.numberOfLines = 0;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor dp_colorFromHexString:@"#333333"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor dp_colorFromHexString:@"#F91C1C"] forState:UIControlStateSelected];
    button.tag = kRqspfCommonBtnTagBase + tag;
    [button addTarget:self action:@selector(dp_singleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
- (void)dp_singleBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (![self.delegate respondsToSelector:@selector(clickButtonWithCell:gameType:index:isSelected:)]) {
        return;
    }
    if (sender.selected == YES) {
        [self.delegate clickButtonWithCell:self gameType:self.gameType index:((int)sender.tag - kRqspfCommonBtnTagBase) isSelected:YES ];
    }else{
       
        [self.delegate clickButtonWithCell:self gameType:self.gameType index:((int)sender.tag - kRqspfCommonBtnTagBase) isSelected:NO ];
    }
    

}

- (void)dp_setCelldataModel:(id)dataModel
{
    
    [super dp_setCelldataModel:dataModel];
    
    if (![dataModel isKindOfClass:[DPJcdgSpfCellModel class]]) {
        return;
    }
    
    CGRect framLeft = self.leftPercentBar.chartView.frame ;
    framLeft.size.width = 5 ;
    framLeft.origin.y = framLeft.size.height-5 ;
    self.leftPercentBar.chartView.frame = framLeft ;
    
    CGRect framRight = self.rightPercentBar.chartView.frame ;
    framRight.size.width = 5 ;
    framRight.origin.y = framRight.size.height-5 ;
    self.rightPercentBar.chartView.frame = framRight ;
    
    CGRect framCenter = self.middlePercentBar.chartView.frame ;
    framCenter.size.width = 5 ;
    framCenter.origin.y = framCenter.size.height-5 ;
    self.middlePercentBar.chartView.frame = framCenter ;
    

    
    DPJcdgSpfCellModel *spfModel = (DPJcdgSpfCellModel *)dataModel;
    self.teamNames = spfModel.teamsName;
    self.detailType = spfModel.gameType == GameTypeJcRqspf ? KSpfTypeRqspf : KSpfTypeSpf;
    self.defaultOption = spfModel.defaultOption;
    self.percents = spfModel.percents;
    self.gameType = self.detailType == KSpfTypeRqspf ? GameTypeJcRqspf : GameTypeJcSpf;


    self.bottomContentView.zhuShu = spfModel.zhushu ;
    self.bottomContentView.miniBonus = spfModel.minBonus ;
    self.bottomContentView.maxBonus = spfModel.maxBonus ;
    _warnContent = spfModel.warnContent;
    
    
    if(spfModel.gameType == GameTypeJcRqspf){
    
        self.gameTypeLabel.text = @"让球胜平负";
        self.flagView.image = dp_SportLotteryImage(@"dan_rf.png") ;
    }else if (spfModel.gameType == GameTypeJcSpf){
    
        self.gameTypeLabel.text = @"胜平负";
        self.flagView.image = dp_SportLotteryImage(@"dan_spf.png") ;
    }else{
    
        DPAssertMsg(NO ,@"gametype赋值错误") ;
    }
}
#pragma mark - getter and setter

-(UUBar*)leftPercentBar{

    if (_leftPercentBar == nil) {
        _leftPercentBar = [[UUBar alloc]initWithColors:UIColorFromRGB(0xF84C4F)  bottomColor:[UIColor dp_flatRedColor]];
    }
    return _leftPercentBar ;
}

-(UUBar*)middlePercentBar{
    if (_middlePercentBar == nil) {
        _middlePercentBar = [[UUBar alloc]initWithColors:UIColorFromRGB(0x4A87E8) bottomColor:UIColorFromRGB(0x3069C4)];
    }
    
    return _middlePercentBar ;
}

-(UUBar*)rightPercentBar{
    if (_rightPercentBar == nil) {
        _rightPercentBar = [[UUBar alloc]initWithColors: UIColorFromRGB(0x7CB666) bottomColor:UIColorFromRGB(0x649550)];
    }
    
    return _rightPercentBar ;
}


- (UIButton *)leftTeamBtn
{
    if (_leftTeamBtn == nil) {
        
        _leftTeamBtn = [self createCommonButtonWithTitle:@"曼城(-1)\n胜 2.18" tag:0];
    }
    return _leftTeamBtn;
}
- (UIButton *)middleTeamBtn
{
    if (_middleTeamBtn == nil) {
        _middleTeamBtn = [self createCommonButtonWithTitle:@"曼城(-1)\n胜 2.18" tag:1];
    }
    return _middleTeamBtn;
}

- (UIButton *)rightTeamBtn
{
    if (_rightTeamBtn == nil) {
        _rightTeamBtn = [self createCommonButtonWithTitle:@"曼城(-1)\n胜 2.18" tag:2];
    }
    return _rightTeamBtn;
}
- (void)setTeamNames:(NSArray *)teamNames
{
    _teamNames = teamNames;
    [self.leftTeamBtn setTitle:teamNames[0] forState:UIControlStateNormal];
    [self.middleTeamBtn setTitle:teamNames[1] forState:UIControlStateNormal];
    [self.rightTeamBtn setTitle:teamNames[2] forState:UIControlStateNormal];
    
    [self.leftTeamBtn setTitle:teamNames[0] forState:UIControlStateSelected];
    [self.middleTeamBtn setTitle:teamNames[1] forState:UIControlStateSelected];
    [self.rightTeamBtn setTitle:teamNames[2] forState:UIControlStateSelected];
}
- (void)setPercents:(NSArray *)percents
{
     if (percents.count < 3) {
        DPLog(@"百分比数据出错");
        return;
    }
    
    self.leftPercentBar.chartHight =[percents[0] intValue]/100.0;
    self.middlePercentBar.chartHight =[percents[1] intValue]/100.0;
    self.rightPercentBar.chartHight = [percents[2] intValue]/100.0;
    
    _percents = percents;
}
- (void)setDefaultOption:(NSArray *)defaultOption
{
    if (defaultOption.count < 3) {
        return;
    }
    _defaultOption = defaultOption;
    self.leftTeamBtn.selected = [defaultOption[0] intValue];
    self.middleTeamBtn.selected = [defaultOption[1] intValue];
    self.rightTeamBtn.selected = [defaultOption[2] intValue];
}
- (void)setDetailType:(KSpfDetailType)detailType
{
    _detailType = detailType;
//    CGFloat flagViewW = 100;
//    self.gameTypeLabel.text = detailType == KSpfTypeRqspf ? @"让球胜平负" : @"胜平负";
//    
//    if (detailType == KSpfTypeSpf) flagViewW = 80;
//    
 
}

@end


#pragma mark- 总进球
@interface DPJcdgAllgoalButton : UIButton
{
    UILabel *_numberLabel;
    UILabel *_spLabel;
}
@property (nonatomic, strong, readonly)UILabel *numberLabel;
@property (nonatomic, strong, readonly)UILabel *spLabel;

@end

@implementation DPJcdgAllgoalButton
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self dp_buildUI];
    }
    return self;
}
- (void)dp_buildUI
{
     self.backgroundColor = [UIColor clearColor];
     UIImage *resizeImg = dp_SportLotteryResizeImage(@"选取样式框架_34.png") ;
    [self setBackgroundImage:resizeImg forState:UIControlStateSelected];
    [self setBackgroundImage:dp_SportLotteryResizeImage(@"btn_bg_03.png") forState:UIControlStateNormal];
    
    [self addSubview:self.numberLabel];
    [self addSubview:self.spLabel];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_centerY);
    }];
    [self.spLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_centerY);
    }];
}
- (UILabel *)numberLabel
{
    if (_numberLabel == nil) {
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.backgroundColor = [UIColor clearColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.font = [UIFont dp_systemFontOfSize:kCommonJcdgFont];
        _numberLabel.textColor =[UIColor dp_colorFromHexString:@"#333333"];
        //        _titleLabel.text = @"1\n2.18";
    }
    return _numberLabel;
}
- (UILabel *)spLabel
{
    if (_spLabel == nil) {
        _spLabel = [[UILabel alloc]init];
        _spLabel.backgroundColor = [UIColor clearColor];
        _spLabel.textAlignment = NSTextAlignmentCenter;
        _spLabel.font = [UIFont dp_systemFontOfSize:kCommonJcdgFont - 2];
        _spLabel.textColor =[UIColor dp_colorFromHexString:@"#C1C1C1"];
    }
    return _spLabel;
}

@end
//////////////////////////////////////////////////////////////////////////////////////////
#define kAllgoalTagBase 38
@interface DPjcdgAllgoalCell ()
@property (nonatomic, strong) NSArray *sp_Numbers; // sp值
@property (nonatomic, strong) NSArray *defaultOption; // 选中状态
@property (nonatomic, strong, readonly)NSMutableArray *buttonsArray;
@end
@implementation DPjcdgAllgoalCell
@synthesize sp_Numbers = _sp_Numbers;
@synthesize buttonsArray = _buttonsArray;
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier WithGameType:(MyGameType)type {
    
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier WithGameType:type]) {
//        [self dp_buildUI];
    }
    
    return self;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        [self dp_buildUI];
    }
    return self;
}

-(void)buildCommonUI{
    
    if (_hasLoaded) {
        return ;
    }
    [super buildCommonUI];
    
    [self.basContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headViewBg.mas_bottom);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@121) ;
    }];
    
//    121+30+100
    
    [self.bottomContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView) ;
        make.left.equalTo(self.contentView) ;
        make.right.equalTo(self.contentView) ;
        make.height.equalTo(@(100));
    }];
    [self dp_buildUI];
    
}

- (void)dp_buildUI
{
    
    UIView *upView = [[UIView alloc]init];
    UIView *downView = [[UIView alloc]init];
    upView.backgroundColor = [UIColor clearColor];
    downView.backgroundColor = [UIColor clearColor];
    
    [self.basContentView addSubview:upView];
    [self.basContentView addSubview:downView];
    
    [upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.basContentView).offset(20);
        make.top.equalTo(self.basContentView).offset(15);
        make.right.equalTo(self.basContentView).offset(- 10);
        make.height.equalTo(@38);
    }];
    
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(upView);
        make.top.equalTo(upView.mas_bottom).offset(15);
        make.right.equalTo(upView);
        make.height.equalTo(@38);
    }];
    
    [self bulidSinglePartView:upView withTagBase:kAllgoalTagBase];
    [self bulidSinglePartView:downView withTagBase:kAllgoalTagBase + 4];
    
}
- (void)bulidSinglePartView:(UIView *)view withTagBase:(int)tagBase
{
    DPJcdgAllgoalButton *button0 = [self createSingleButtonWithTitle:[NSString stringWithFormat:@"%d", tagBase - kAllgoalTagBase + 0] tag:tagBase + 0];
    DPJcdgAllgoalButton *button1 = [self createSingleButtonWithTitle:[NSString stringWithFormat:@"%d", tagBase - kAllgoalTagBase + 1] tag:tagBase + 1];
    DPJcdgAllgoalButton *button2 = [self createSingleButtonWithTitle:[NSString stringWithFormat:@"%d", tagBase - kAllgoalTagBase + 2] tag:tagBase + 2];
    DPJcdgAllgoalButton *button3 = [self createSingleButtonWithTitle:[NSString stringWithFormat:@"%d", tagBase - kAllgoalTagBase + 3] tag:tagBase + 3];
    if (tagBase-kAllgoalTagBase==4) {
        button3.numberLabel.text=@"7+";
    }
    
    [view addSubview:button0];
    [view addSubview:button1];
    [view addSubview:button2];
    [view addSubview:button3];
    
    [button0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.top.equalTo(view);
        make.width.equalTo(@62.5);
        make.height.equalTo(view);
    }];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button0.mas_right).offset(10);
        make.top.equalTo(button0);
        make.width.equalTo(@62.5);
        make.height.equalTo(view);
    }];
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button1.mas_right).offset(10);
        make.top.equalTo(view);
        make.width.equalTo(@62.5);
        make.height.equalTo(view);
    }];
    [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button2.mas_right).offset(10);
        make.top.equalTo(view);
        make.width.equalTo(@62.5);
        make.height.equalTo(view);
    }];
}
- (DPJcdgAllgoalButton *)createSingleButtonWithTitle:(NSString *)title tag:(int)tag
{
    DPJcdgAllgoalButton *button = [DPJcdgAllgoalButton buttonWithType:UIButtonTypeCustom];
    button.numberLabel.text = title;
    button.tag = tag;
    [button addTarget:self action:@selector(dp_singleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonsArray addObject:button];
    return button;
}


- (void)dp_singleBtnClick:(DPJcdgAllgoalButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected == YES) {
        sender.numberLabel.textColor = [UIColor dp_flatRedColor];
        sender.spLabel.textColor = [UIColor dp_flatRedColor];
        if ([self.delegate respondsToSelector:@selector(clickButtonWithCell:gameType:index:isSelected:)]) {
            [self.delegate clickButtonWithCell:self gameType:GameTypeJcZjq index:((int)sender.tag - kAllgoalTagBase) isSelected:YES ];
        }
    }else{
        sender.numberLabel.textColor = [UIColor dp_colorFromHexString:@"#333333"];
        sender.spLabel.textColor = [UIColor dp_colorFromHexString:@"#C1C1C1"];
        if ([self.delegate respondsToSelector:@selector(clickButtonWithCell:gameType:index:isSelected:)]) {
            
            [self.delegate clickButtonWithCell:self gameType:GameTypeJcZjq index:((int)sender.tag - kAllgoalTagBase) isSelected:NO ];
        }
    }

}


- (void)setSp_Numbers:(NSArray *)sp_Numbers
{
    if (sp_Numbers.count < 8) {
        return;
    }
    for (int i = 0; i < 8; i++) {
        DPJcdgAllgoalButton *button = (DPJcdgAllgoalButton *)self.buttonsArray[i];
        button.spLabel.text = [NSString stringWithFormat:@"%.2f", [sp_Numbers[i] floatValue]];
    }
    _sp_Numbers = sp_Numbers;
    
}
- (NSArray *)sp_Numbers
{
    if(_sp_Numbers == nil){
        _sp_Numbers = [NSArray array];
    }
    return _sp_Numbers;
}
- (void)setDefaultOption:(NSArray *)defaultOption
{
    if (defaultOption.count < 8) {
        return;
    }
    for (int i = 0; i < 8; i++) {
        DPJcdgAllgoalButton *button = (DPJcdgAllgoalButton *)self.buttonsArray[i];
        
        button.selected = [defaultOption[i] intValue];
        if ([defaultOption[i] intValue]) {
            button.numberLabel.textColor = [UIColor dp_flatRedColor];
            button.spLabel.textColor = [UIColor dp_flatRedColor];
        }else{
            button.numberLabel.textColor = [UIColor dp_colorFromHexString:@"#333333"];
            button.spLabel.textColor = [UIColor dp_colorFromHexString:@"#C1C1C1"];
        }
    }
    _defaultOption = defaultOption;
}
- (NSMutableArray *)buttonsArray
{
    if (_buttonsArray == nil) {
        _buttonsArray = [NSMutableArray arrayWithCapacity:8];
    }
    return _buttonsArray;
}
- (void)dp_setCelldataModel:(id)dataModel
{
    [super dp_setCelldataModel:dataModel];
    if (![dataModel isKindOfClass:[DPJcdgZjqCellModel class]]) {
        return;
    }
    DPJcdgZjqCellModel *zjqModel = (DPJcdgZjqCellModel *)dataModel;
    self.sp_Numbers = zjqModel.sp_Numbers;
    self.defaultOption = zjqModel.defaultOption;
    _warnContent = zjqModel.warnContent;
    self.gameType = GameTypeJcZjq ;
    
    self.gameTypeLabel.text = @"总进球";
    self.flagView.image = dp_SportLotteryResizeImage(@"dan_zjq.png") ;
    
    self.bottomContentView.zhuShu = zjqModel.zhushu ;
    self.bottomContentView.miniBonus = zjqModel.minBonus ;
    self.bottomContentView.maxBonus = zjqModel.maxBonus ;

}
@end

////////////////////////////////////////////////////////////////////////////////

#pragma mark- 猜赢球
#define kButtonCommonW 51
#define kButtonCommonH 43
#define kButtonTagLeftBase 70
#define kButtonTagRightBase 75
@interface dpJcdgGuessWinCell ()
@property (nonatomic, strong, readonly)UILabel *leftTeamNameLabel;
@property (nonatomic, strong, readonly)UILabel *rightTeamNameLabel;
@property (nonatomic, strong) NSArray *defaultOption; // 选中状态
@property (nonatomic, strong, readonly)NSMutableArray *buttonsArray;
@end
@implementation dpJcdgGuessWinCell
@synthesize leftTeamNameLabel = _leftTeamNameLabel;
@synthesize rightTeamNameLabel = _rightTeamNameLabel;
@synthesize buttonsArray = _buttonsArray;
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier WithGameType:(MyGameType)type {
    
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier WithGameType:type]) {
//        [self dp_buildCommonUI];
    }
    
    return self;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self dp_buildCommonUI];
    }
    return self;
}

-(void)buildCommonUI{
    
    if (_hasLoaded ) {
        return ;
    }
    [super buildCommonUI];
    
    [self.basContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headViewBg.mas_bottom);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@(2 * kButtonCommonH+30)) ;
    }];
    
//    116+30+100
    
    [self.bottomContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView) ;
        make.left.equalTo(self.contentView) ;
        make.right.equalTo(self.contentView) ;
        make.height.equalTo(@100);
    }];
    [self dp_buildCommonUI];

}
- (void)dp_buildCommonUI
{
    self.gameTypeLabel.text = @"猜赢球";
    self.flagView.image = dp_SportLotteryImage(@"dan_bf.png") ;
 
    UIView *leftView = [[UIView alloc]init];
    UIView *rightView = [[UIView alloc]init];
    leftView.backgroundColor = [UIColor clearColor];
    rightView.backgroundColor = [UIColor clearColor];
    
    
    UIButton *centerBtn = [self createCommonButtonWithTitle:@"平" tag:kButtonTagLeftBase + 4];
    centerBtn.titleLabel.font = [UIFont dp_systemFontOfSize:kCommonJcdgFont + 1];
    
    UIView *contentView = self.basContentView;
    [contentView addSubview:self.leftTeamNameLabel];
    [contentView addSubview:self.rightTeamNameLabel];
    [contentView addSubview:centerBtn];
    [contentView addSubview:leftView];
    [contentView addSubview:rightView];
    
    
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTeamNameLabel.mas_right).offset(5);
        make.top.equalTo(contentView).offset(15);
        make.width.equalTo(@(2 * kButtonCommonW+5));
        make.height.equalTo(@(2 * kButtonCommonH));
    }];
    
    [self.leftTeamNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10);
        make.centerY.equalTo(leftView);
        make.width.equalTo(@15);
    }];
    
    [self.rightTeamNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(- 10);
         make.centerY.equalTo(leftView);
        make.width.equalTo(@15);
    }];

    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(centerBtn.mas_right).offset(2);
        make.top.equalTo(centerBtn);
        make.width.equalTo(@(2 * kButtonCommonW+5));
        make.height.equalTo(@(2 * kButtonCommonH));
        make.right.equalTo(self.rightTeamNameLabel.mas_left).offset(-5);

    }];
    
    [centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_right).offset(2);
//        make.width.equalTo(@kButtonCommonW);
        make.height.equalTo(@(2 * kButtonCommonH));
        make.top.equalTo(leftView);
        make.right.equalTo(rightView.mas_left).offset(-2) ;
    }];
    
    [self buildItemsWithContent:leftView tagBase:kButtonTagLeftBase];
    [self buildItemsWithContent:rightView tagBase:kButtonTagRightBase];
    _buttonsArray = (NSMutableArray *) [_buttonsArray sortedArrayUsingComparator:^NSComparisonResult(UIButton * obj1, UIButton* obj2) {
        if (obj1.tag > obj2.tag){
            return NSOrderedDescending;
        }else{
            return NSOrderedAscending;
        }
        
    }];
}
- (void)buildItemsWithContent:(UIView *)content tagBase:(int)tagBase
{
    UIButton *button0 = [self createCommonButtonWithTitle:@"胜1球" tag:tagBase + 0];
    UIButton *button1 = [self createCommonButtonWithTitle:@"胜2球" tag:tagBase + 1];
    UIButton *button2 =[self createCommonButtonWithTitle:@"胜3球" tag:tagBase + 2];
    UIButton *button3 =[self createCommonButtonWithTitle:@"胜更多" tag:tagBase + 3];
    
    [content addSubview:button0];
    [content addSubview:button1];
    [content addSubview:button2];
    [content addSubview:button3];
    
    [button0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(content);
        make.top.equalTo(content);
        make.width.equalTo(@kButtonCommonW);
        make.height.equalTo(@kButtonCommonH);
    }];
    
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button0.mas_right).offset(2);
        make.top.equalTo(content);
        //        make.width.equalTo(@kButtonCommonW);
        make.right.equalTo(content);
        make.height.equalTo(@kButtonCommonH);
    }];
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(content);
        make.top.equalTo(button0.mas_bottom).offset(2);
        make.width.equalTo(@kButtonCommonW);
        //        make.height.equalTo(@kButtonCommonW);
        make.bottom.equalTo(content);
    }];
    [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button2.mas_right).offset(2);
        make.top.equalTo(button1.mas_bottom).offset(2);
        //        make.width.equalTo(@kButtonCommonW);
        make.right.equalTo(content);
        //        make.height.equalTo(@kButtonCommonW);
        make.bottom.equalTo(content);
    }];
}
- (UIButton *)createCommonButtonWithTitle:(NSString *)title tag:(int)tag
{
    
     UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor dp_colorFromHexString:@"#333333"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor dp_colorFromHexString:@"#f91c1c"] forState:UIControlStateSelected];
 
    UIImage *resizeImg = dp_SportLotteryResizeImage(@"选取样式框架_34.png") ;
    [button setBackgroundImage:resizeImg forState:UIControlStateSelected];
    [button setBackgroundImage:dp_SportLotteryResizeImage(@"btn_bg_03.png") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dp_singleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont dp_systemFontOfSize:14];
    button.tag = tag;
    [self.buttonsArray addObject:button];
    return button;
    
}

- (void)dp_singleBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    DPLog(@"sender tag = %d", (int)sender.tag);
    if (sender.selected == YES) {
        [sender.superview bringSubviewToFront:sender];
        if ([self.delegate respondsToSelector:@selector(clickButtonWithCell:gameType:index:isSelected:)]) {
            [self.delegate clickButtonWithCell:self gameType:GameTypeJcBf index:((int)sender.tag - kButtonTagLeftBase) isSelected:YES ];
        }
    }else{
        [sender.superview sendSubviewToBack:sender];
        if ([self.delegate respondsToSelector:@selector(clickButtonWithCell:gameType:index:isSelected:)]) {
           
            [self.delegate clickButtonWithCell:self gameType:GameTypeJcBf index:((int)sender.tag - kButtonTagLeftBase) isSelected:NO ];
        }
    }

}


- (UILabel *)leftTeamNameLabel
{
    if (_leftTeamNameLabel == nil) {
        _leftTeamNameLabel = [[UILabel alloc]init];
        _leftTeamNameLabel.backgroundColor = [UIColor clearColor];
        _leftTeamNameLabel.textColor = UIColorFromRGB(0x878071);
        _leftTeamNameLabel.font = [UIFont dp_systemFontOfSize:14];
        _leftTeamNameLabel.textAlignment = NSTextAlignmentCenter;
        _leftTeamNameLabel.text = @"多德蒙德";
        _leftTeamNameLabel.numberOfLines = 0;
    }
    return _leftTeamNameLabel;
}
- (UILabel *)rightTeamNameLabel
{
    if (_rightTeamNameLabel == nil) {
        _rightTeamNameLabel = [[UILabel alloc]init];
        _rightTeamNameLabel.backgroundColor = [UIColor clearColor];
        _rightTeamNameLabel.textColor = UIColorFromRGB(0x878071);
        _rightTeamNameLabel.font = [UIFont dp_systemFontOfSize:14];
        _rightTeamNameLabel.textAlignment = NSTextAlignmentCenter;
        _rightTeamNameLabel.numberOfLines = 0;
        _rightTeamNameLabel.text = @"多德蒙德";
    }
    return _rightTeamNameLabel;
}
- (NSMutableArray *)buttonsArray
{
    if (_buttonsArray == nil) {
        _buttonsArray = [NSMutableArray arrayWithCapacity:9];
    }
    return _buttonsArray;
}
- (void)setDefaultOption:(NSArray *)defaultOption
{
    if (defaultOption.count < 9) {
        return;
    }
    for (int i = 0; i < 9; i++) {
        UIButton *button = self.buttonsArray[i];
//        DPLog(@"iii =%d, button.tag = %d, defaultsele = %d", i, (int)button.tag, [defaultOption[i] intValue]);
        button.selected = [defaultOption[i] intValue];
        if (button.selected == YES) {
            [button.superview bringSubviewToFront:button];
        }
    }
    _defaultOption = defaultOption;
}
- (void)dp_setCelldataModel:(id)dataModel
{
    [super dp_setCelldataModel:dataModel];
    if (![dataModel isKindOfClass:[DPJcdgGuessCellModel class]]) {
        return;
    }
    DPJcdgGuessCellModel *guessModel = (DPJcdgGuessCellModel *)dataModel;
    self.leftTeamNameLabel.text = guessModel.leftTeamName;
    self.rightTeamNameLabel.text = guessModel.rightTeamName;
    self.defaultOption = guessModel.defaultOption;
    _warnContent = guessModel.warnContent;
    self.gameType = GameTypeJcBf ;
    
    self.bottomContentView.zhuShu = guessModel.zhushu ;
    self.bottomContentView.miniBonus = guessModel.minBonus ;
    self.bottomContentView.maxBonus = guessModel.maxBonus ;
}
@end

////////////////////////////////////////////////
@interface DPJcdgWarnView ()
@property (nonatomic, strong, readonly) NSLayoutConstraint *contentViewH;
@property (nonatomic, strong, readonly)UILabel *titleLabel;
@end
@implementation DPJcdgWarnView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self dp_buildCommonUI];
    }
    return self;
}
- (void)dp_buildCommonUI
{
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor dp_flatWhiteColor];
    
    UIView *pointView = ({
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor dp_flatBlackColor];
        view.layer.cornerRadius = 2;
        view;
    });
    
    _gameTypeLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor dp_flatRedColor];
        label.font = [UIFont dp_systemFontOfSize:17];
        label.text = @"猜赢球";
        label;
    });
    
    _titleLabel = ({
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor dp_flatBlackColor];
        label.font = [UIFont dp_systemFontOfSize:14];
        label.numberOfLines = 0;
        label.text = @"竞猜本场全场比分，猜选中的球队能赢几个球。";
        label;
    });
    
    UIButton *confirmBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor dp_flatRedColor]];
        [button setTitle:@"我知道了" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont dp_systemFontOfSize:15];
        [button addTarget:self action:@selector(dp_warnConfrim) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    [self addSubview:contentView];
    [contentView addSubview:pointView];
    [contentView addSubview:_gameTypeLabel];
    [contentView addSubview:_titleLabel];
    [contentView addSubview:confirmBtn];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.width.equalTo(@290);
        make.height.equalTo(@140);
    }];
    
    for (NSLayoutConstraint *constraint in contentView.constraints) {
        if (constraint.firstItem == contentView && constraint.firstAttribute == NSLayoutAttributeHeight) {
            _contentViewH = constraint;
            break;
        }
    }
    
    
    [pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(20);
        make.left.equalTo(contentView).offset(20);
        make.width.equalTo(@4);
        make.height.equalTo(@4);
    }];
    
     [_gameTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(pointView);
        make.left.equalTo(pointView.mas_right).offset(2);
    }];
    
     [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_gameTypeLabel);
        make.right.equalTo(contentView).offset(- 20);
        //        make.centerX.equalTo(contentView);
        make.top.equalTo(_gameTypeLabel.mas_bottom);
        make.bottom.equalTo(confirmBtn.mas_top).offset(- 5);
    }];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(20);
        //        make.centerX.equalTo(contentView);
        make.right.equalTo(contentView).offset(- 20);
        make.height.equalTo(@40);
        make.bottom.equalTo(contentView).offset(- 10);
    }];
}

- (void)dp_warnConfrim {
    [self.dp_viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)setTitleText:(NSString *)titleText
{
    
     self.titleLabel.text = titleText;
    self.titleLabel.preferredMaxLayoutWidth = 244;
//    CGSize neiSize = self.titleLabel.intrinsicContentSize;
    
//   CGSize neiSize = [titleText sizeWithFont:[UIFont dp_systemFontOfSize:14] constrainedToSize:CGSizeMake(244, MAXFLOAT) lineBreakMode:NSLineBreakByTruncatingTail] ;
    CGSize neiSize = [NSString dpsizeWithSting:titleText andFont:[UIFont dp_systemFontOfSize:14] andMaxSize:CGSizeMake(244, MAXFLOAT)];
    if (titleText.length > 100) {
        self.titleLabel.font = [UIFont dp_systemFontOfSize:12];
        self.contentViewH.constant = neiSize.height - 60;
    }else{
    
        self.contentViewH.constant = 50+20.5+5+20+neiSize.height ;
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
    
}
@end


#pragma mark- 篮球让分胜负

@interface DPJcdgBasketRfsfCell ()

@property (nonatomic, strong) NSArray *percents; // 百分比
@property (nonatomic, strong) NSArray *teamNames; // 队伍名称
@property (nonatomic, assign) KRfsfDetailType detailType; // 让分胜负和胜负区分
@property (nonatomic, assign) NSArray *defaultOption; //选中状态


@property (nonatomic, strong, readonly)UUBar *leftPercentBar;
@property (nonatomic, strong, readonly)UUBar *rightPercentBar;

@property (nonatomic, strong, readonly)UIButton *leftTeamBtn;
@property (nonatomic, strong, readonly)UIButton *rightTeamBtn;

@end

@implementation DPJcdgBasketRfsfCell

@synthesize leftTeamBtn = _leftTeamBtn;
@synthesize rightTeamBtn = _rightTeamBtn;
@synthesize detailType = _detailType;


@synthesize leftPercentBar = _leftPercentBar ;
@synthesize rightPercentBar = _rightPercentBar ;


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier WithGameType:(MyGameType)type{

    if (self = [super initWithReuseIdentifier:reuseIdentifier WithGameType:type]) {
//        [self dp_bulidRfspf];
    }
    
    return self;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self dp_bulidRfspf];
    }
    
    return self;
    
}

-(void)buildCommonUI{
    if (_hasLoaded) {
        return ;
    }
    [super buildCommonUI];
    
    
    [self.basContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headViewBg.mas_bottom);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@135) ;
    }];
    
    //135+100+30
    [self.bottomContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView) ;
        make.left.equalTo(self.contentView) ;
        make.right.equalTo(self.contentView) ;
        make.height.equalTo(@70);
    }];
    
    [self dp_bulidRfspf];
    
}

- (void)dp_bulidRfspf
{
    
   
    UIView *leftView = [[UIView alloc]init];
    UIView *rightView = [[UIView alloc]init];
    
    
    UIView *contentView = self.basContentView;
    [contentView addSubview:leftView];
    [contentView addSubview:rightView];
    
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(30);
        make.top.equalTo(contentView).offset(7);
        make.bottom.equalTo(contentView).offset(- 10);
        make.width.equalTo(@120);
    }];
    
    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-30);
        make.top.equalTo(leftView);
        make.bottom.equalTo(leftView);
        make.width.equalTo(@120);
    }];
    
    
    [self buildView:leftView withPercent:self.leftPercentBar teamNameBtn:self.leftTeamBtn];
    [self buildView:rightView withPercent:self.rightPercentBar teamNameBtn:self.rightTeamBtn];
    
    
}


// 按钮初始化
- (UIButton *)createCommonButtonWithTitle:(NSString *)title tag:(int)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *img = dp_SportLotteryImage(@"选取样式框架_34.png");
    UIImage *resizeImg = dp_SportLotteryResizeImage(@"选取样式框架_34.png") ;// [img resizableImageWithCapInsets:UIEdgeInsetsMake(3, 2, 25, 60) resizingMode:UIImageResizingModeTile];
    [button setBackgroundImage:resizeImg forState:UIControlStateSelected];
    [button setBackgroundImage:dp_SportLotteryResizeImage(@"btn_bg_03.png") forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont dp_systemFontOfSize:kCommonJcdgFont - 2];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.numberOfLines = 0;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor dp_colorFromHexString:@"#333333"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor dp_colorFromHexString:@"#F91C1C"] forState:UIControlStateSelected];
    button.tag = kRqspfCommonBtnTagBase + tag;
    [button addTarget:self action:@selector(dp_singleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
- (void)dp_singleBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (![self.delegate respondsToSelector:@selector(clickButtonWithCell:gameType:index:isSelected:)]) {
        return;
    }
    if (sender.selected == YES) {
        [self.delegate clickButtonWithCell:self gameType:self.gameType index:((int)sender.tag - kRqspfCommonBtnTagBase) isSelected:YES ];
    }else{
       
        [self.delegate clickButtonWithCell:self gameType:self.gameType index:((int)sender.tag - kRqspfCommonBtnTagBase) isSelected:NO ];
    }
    

}
 - (void)dp_setCelldataModel:(id)dataModel
{
    [super dp_setCelldataModel:dataModel];
    if (![dataModel isKindOfClass:[DPJcdgBasketCellModel class]]) {
        return;
    }
    
    CGRect framLeft = self.leftPercentBar.chartView.frame ;
    framLeft.size.width = 5 ;
    framLeft.origin.y = framLeft.size.height-5 ;
    self.leftPercentBar.chartView.frame = framLeft ;
    
    CGRect framRight = self.rightPercentBar.chartView.frame ;
    framRight.size.width = 5 ;
    framRight.origin.y = framRight.size.height-5 ;
    self.rightPercentBar.chartView.frame = framRight ;
    

    DPJcdgBasketCellModel *spfModel = (DPJcdgBasketCellModel *)dataModel;
    self.teamNames =@[spfModel.awayName ,spfModel.homeName] ;
    self.detailType = spfModel.gameType == GameTypeLcRfsf ? KSfRfsfType : KSfSfType;
    self.defaultOption = spfModel.defaultOption;
    self.percents = spfModel.percents;
    self.gameType = spfModel.gameType ;
   
    
    self.bottomContentView.zhuShu = spfModel.zhushu ;
    self.bottomContentView.miniBonus = spfModel.minBonus ;
    self.bottomContentView.maxBonus = spfModel.maxBonus ;
    
    _warnContent = spfModel.warnContent;
    [self.bottomContentView dp_reloadMoney];
    
    if(spfModel.gameType == GameTypeLcRfsf){
        self.gameTypeLabel.text = @"让分胜负";
        self.flagView.image = dp_AppRootImage(@"rf.png") ;
    }else if (spfModel.gameType == GameTypeLcSf){
        self.gameTypeLabel.text = @"胜负";
        self.flagView.image =  dp_AppRootImage(@"sf.png") ;
    
    }else{
        NSAssert(NO, @"gametype赋值错误");
    }
    
}
#pragma mark - getter and setter

-(UUBar*)leftPercentBar{
    
    if (_leftPercentBar == nil) {
        _leftPercentBar =  [[UUBar alloc]initWithColors:UIColorFromRGB(0xF84C4F)  bottomColor:[UIColor dp_flatRedColor]];
    }
    return _leftPercentBar ;
}


-(UUBar*)rightPercentBar{
    if (_rightPercentBar == nil) {
        _rightPercentBar = [[UUBar alloc]initWithColors: UIColorFromRGB(0x7CB666) bottomColor:UIColorFromRGB(0x649550)];
    }
    
    return _rightPercentBar ;
}


- (UIButton *)leftTeamBtn
{
    if (_leftTeamBtn == nil) {
        
        _leftTeamBtn = [self createCommonButtonWithTitle:@"曼城(-1)\n胜 2.18" tag:0];
    }
    return _leftTeamBtn;
}

- (UIButton *)rightTeamBtn
{
    if (_rightTeamBtn == nil) {
        _rightTeamBtn = [self createCommonButtonWithTitle:@"曼城(-1)\n胜 2.18" tag:1];
    }
    return _rightTeamBtn;
}
- (void)setTeamNames:(NSArray *)teamNames
{
    _teamNames = teamNames;
    [self.leftTeamBtn setTitle:teamNames[0] forState:UIControlStateNormal];
    [self.rightTeamBtn setTitle:teamNames[1] forState:UIControlStateNormal];
    
    [self.leftTeamBtn setTitle:teamNames[0] forState:UIControlStateSelected];
    [self.rightTeamBtn setTitle:teamNames[1] forState:UIControlStateSelected];
}
- (void)setPercents:(NSArray *)percents
{
    
    if (percents.count < 2) {
        DPLog(@"百分比数据出错");
        return;
    }
    
    self.leftPercentBar.chartHight =[percents[0] intValue]/100.0;
    self.rightPercentBar.chartHight = [percents[1] intValue]/100.0;
    
    _percents = percents;
}
- (void)setDefaultOption:(NSArray *)defaultOption
{
    if (defaultOption.count < 2) {
        return;
    }
    _defaultOption = defaultOption;
    self.leftTeamBtn.selected = [defaultOption[0] intValue];
    self.rightTeamBtn.selected = [defaultOption[1] intValue];
}
- (void)setDetailType:(KRfsfDetailType)detailType
{
    _detailType = detailType;
 
    self.gameTypeLabel.text = detailType == KSfRfsfType ? @"让分胜负" : @"胜负";
    
    //    if (detailType == KSpfTypeSpf) flagViewW = 80;
    
    
}

@end




#pragma mark- 篮球 大小分


@interface DPJcdgBasketDxfCell ()

@property (nonatomic, strong) NSArray *percents; // 百分比
@property (nonatomic, strong) NSArray *teamNames; // 队伍名称
@property (nonatomic, assign) KRfsfDetailType detailType; // 让分胜负和胜负区分
@property (nonatomic, assign) NSArray *defaultOption; //选中状态


@property (nonatomic, strong, readonly)UUBar *leftPercentBar;
@property (nonatomic, strong, readonly)UUBar *rightPercentBar;

@property (nonatomic, strong, readonly)UIButton *leftTeamBtn;
@property (nonatomic, strong, readonly)UIButton *middleTeamBtn;

@property (nonatomic, strong, readonly)UIButton *rightTeamBtn;

@end

@implementation DPJcdgBasketDxfCell

@synthesize leftTeamBtn = _leftTeamBtn;
@synthesize rightTeamBtn = _rightTeamBtn;
@synthesize middleTeamBtn = _middleTeamBtn ;
@synthesize detailType = _detailType;


@synthesize leftPercentBar = _leftPercentBar ;
@synthesize rightPercentBar = _rightPercentBar ;


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier WithGameType:(MyGameType)type {
    
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier WithGameType:type]) {
//        [self dp_bulidRfspf];
    }
    
    return self;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self dp_bulidRfspf];
    }
    
    return self;
    
}

-(void)buildCommonUI{
    if (_hasLoaded) {
        return ;
    }
    [super buildCommonUI];
    
    
    [self.basContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headViewBg.mas_bottom);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@135) ;
    }];
    
    //135+100+30
    [self.bottomContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView) ;
        make.left.equalTo(self.contentView) ;
        make.right.equalTo(self.contentView) ;
        make.height.equalTo(@70);
    }];
    
    [self dp_bulidRfspf];
    
}

- (void)dp_bulidRfspf
{
    self.gameTypeLabel.text = @"大小分";
    self.flagView.image = dp_AppRootImage(@"dxf.png") ;
    UIView *leftView = [[UIView alloc]init];
    UIView *rightView = [[UIView alloc]init];

    
    
    UIView *contentView = self.basContentView;
    [contentView addSubview:leftView];
    [contentView addSubview:rightView];
    [contentView addSubview:self.middleTeamBtn];
    
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(30);
        make.top.equalTo(contentView).offset(7);
        make.bottom.equalTo(contentView).offset(- 10);
        make.width.equalTo(@100);
    }];
    
    
    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-30);
        make.top.equalTo(leftView);
        make.bottom.equalTo(leftView);
        make.width.equalTo(@100);
    }];
    
    [self.middleTeamBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_right);
        make.right.equalTo(rightView.mas_left);
        make.bottom.equalTo(contentView).offset(-10);
        make.height.equalTo(@50) ;
        
    }];
    
    
    [self buildView:leftView withPercent:self.leftPercentBar teamNameBtn:self.leftTeamBtn];
    [self buildView:rightView withPercent:self.rightPercentBar teamNameBtn:self.rightTeamBtn];
    
    
   }


// 按钮初始化
- (UIButton *)createCommonButtonWithTitle:(NSString *)title tag:(int)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *img = dp_SportLotteryImage(@"选取样式框架_34.png");
    UIImage *resizeImg = dp_SportLotteryResizeImage(@"选取样式框架_34.png") ;// [img resizableImageWithCapInsets:UIEdgeInsetsMake(3, 2, 25, 60) resizingMode:UIImageResizingModeTile];
    [button setBackgroundImage:resizeImg forState:UIControlStateSelected];
    [button setBackgroundImage:dp_SportLotteryResizeImage(@"btn_bg_03.png") forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont dp_systemFontOfSize:kCommonJcdgFont - 2];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.numberOfLines = 0;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor dp_colorFromHexString:@"#333333"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor dp_colorFromHexString:@"#F91C1C"] forState:UIControlStateSelected];
    button.tag = kRqspfCommonBtnTagBase + tag;
    [button addTarget:self action:@selector(dp_singleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
//- (void)dp_singleBtnClick:(UIButton *)sender
//{
//    sender.selected = !sender.selected;
//    if (![self.delegate respondsToSelector:@selector(clickButtonWithCell:gameType:index:isSelected:closeExpand:)]) {
//        return;
//    }
//    int gameType = self.detailType == KSpfTypeRqspf ? GameTypeJcRqspf : GameTypeJcSpf;
//    if (sender.selected == YES) {
//        [self.delegate clickButtonWithCell:self gameType:gameType index:((int)sender.tag - kRqspfCommonBtnTagBase) isSelected:YES closeExpand:NO];
//    }else{
//        BOOL closeExpend = NO;
//        if (!self.leftTeamBtn.selected  && !self.rightTeamBtn.selected) {
//            closeExpend = YES;
//        }
//        [self.delegate clickButtonWithCell:self gameType:gameType index:((int)sender.tag - kRqspfCommonBtnTagBase) isSelected:NO closeExpand:closeExpend];
//    }
//}
- (void)dp_singleBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (![self.delegate respondsToSelector:@selector(clickButtonWithCell:gameType:index:isSelected:)]) {
        return;
    }
     if (sender.selected == YES) {
        [self.delegate clickButtonWithCell:self gameType:self.gameType index:((int)sender.tag - kRqspfCommonBtnTagBase) isSelected:YES ];
    }else{
        
        [self.delegate clickButtonWithCell:self gameType:self.gameType index:((int)sender.tag - kRqspfCommonBtnTagBase) isSelected:NO ];
    }

}

- (void)dp_setCelldataModel:(id)dataModel
{
 
    [super dp_setCelldataModel:dataModel];
    if (![dataModel isKindOfClass:[DPJcdgBasketCellModel class]]) {
        return;
    }
    
    CGRect framLeft = self.leftPercentBar.chartView.frame ;
    framLeft.size.width = 5 ;
    framLeft.origin.y = framLeft.size.height-5 ;
    self.leftPercentBar.chartView.frame = framLeft ;
    
    CGRect framRight = self.rightPercentBar.chartView.frame ;
    framRight.size.width = 5 ;
    framRight.origin.y = framRight.size.height-5 ;
    self.rightPercentBar.chartView.frame = framRight ;

    
    DPJcdgBasketCellModel *spfModel = (DPJcdgBasketCellModel *)dataModel;
    self.teamNames = @[[NSString stringWithFormat:@"大分\n%@",spfModel.sp_Numbers[0]],[NSString stringWithFormat:@"总分\n%@",spfModel.sp_Numbers[1]],[NSString stringWithFormat:@"小分\n%@",spfModel.sp_Numbers[2]]] ;
    
    self.defaultOption = spfModel.defaultOption;
    self.percents = spfModel.percents;
    self.gameType = spfModel.gameType ;
    
    _warnContent = spfModel.warnContent;
    self.bottomContentView.zhuShu = spfModel.zhushu ;
    self.bottomContentView.miniBonus = spfModel.minBonus ;
    self.bottomContentView.maxBonus = spfModel.maxBonus ;

    [self.bottomContentView dp_reloadMoney];
}
#pragma mark - getter and setter

-(UUBar*)leftPercentBar{
    
    if (_leftPercentBar == nil) {
        _leftPercentBar = [[UUBar alloc]initWithColors:UIColorFromRGB(0xF84C4F) bottomColor:[UIColor dp_flatRedColor]];
    }
    return _leftPercentBar ;
}


-(UUBar*)rightPercentBar{
    if (_rightPercentBar == nil) {
        _rightPercentBar = [[UUBar alloc]initWithColors: UIColorFromRGB(0x7CB666) bottomColor:UIColorFromRGB(0x679755)];
    }
    
    return _rightPercentBar ;
}


- (UIButton *)leftTeamBtn
{
    if (_leftTeamBtn == nil) {
        
        _leftTeamBtn = [self createCommonButtonWithTitle:@"曼城(-1)\n胜 2.18" tag:0];
    }
    return _leftTeamBtn;
}
- (UIButton *)middleTeamBtn
{
    if (_middleTeamBtn == nil) {
        
        _middleTeamBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _middleTeamBtn.backgroundColor = [UIColor clearColor] ;
        _middleTeamBtn.titleLabel.font = [UIFont dp_systemFontOfSize:kCommonJcdgFont - 2];
        _middleTeamBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _middleTeamBtn.titleLabel.numberOfLines = 0;
        [_middleTeamBtn setTitle:@"总分\n200.5" forState:UIControlStateNormal];
        [_middleTeamBtn setTitleColor:[UIColor dp_colorFromHexString:@"#333333"] forState:UIControlStateNormal];
        [_middleTeamBtn setTitleColor:[UIColor dp_colorFromHexString:@"#333333"] forState:UIControlStateSelected];
    }
    return _middleTeamBtn;
}

- (UIButton *)rightTeamBtn
{
    if (_rightTeamBtn == nil) {
        _rightTeamBtn = [self createCommonButtonWithTitle:@"曼城(-1)\n胜 2.18" tag:1];
    }
    return _rightTeamBtn;
}
- (void)setTeamNames:(NSArray *)teamNames
{
    _teamNames = teamNames;
    [self.leftTeamBtn setTitle:teamNames[0] forState:UIControlStateNormal];
    [self.middleTeamBtn setTitle:teamNames[1] forState:UIControlStateNormal];
    [self.rightTeamBtn setTitle:teamNames[2] forState:UIControlStateNormal];
    
    [self.leftTeamBtn setTitle:teamNames[0] forState:UIControlStateSelected];
    [self.middleTeamBtn setTitle:teamNames[1] forState:UIControlStateSelected];
    [self.rightTeamBtn setTitle:teamNames[2] forState:UIControlStateSelected];
}
- (void)setPercents:(NSArray *)percents
{
    
    if (percents.count < 2) {
        DPLog(@"百分比数据出错");
        return;
    }
    
    self.leftPercentBar.chartHight =[percents[0] intValue]/100.0;
    self.rightPercentBar.chartHight = [percents[1] intValue]/100.0;
    
    _percents = percents;
}
- (void)setDefaultOption:(NSArray *)defaultOption
{
    if (defaultOption.count < 2) {
        return;
    }
    _defaultOption = defaultOption;
    self.leftTeamBtn.selected = [defaultOption[0] intValue];
    self.rightTeamBtn.selected = [defaultOption[1] intValue];
}
- (void)setDetailType:(KRfsfDetailType)detailType
{
    _detailType = detailType;
    self.gameTypeLabel.text = @"大小分";
    
//    if (detailType == KSpfTypeSpf) flagViewW = 80;
    
   
}


@end


#pragma mark- 篮球胜分差

static inline  NSMutableAttributedString* ATCreateAttributStringWith(NSString *baseString ,NSString *spString,BOOL isSelected){
    
    
    NSString *base = [NSString stringWithFormat:@"%@ %@",baseString,spString] ;
    NSMutableAttributedString *AttString = [[NSMutableAttributedString alloc]initWithString:base];
    if (isSelected) {
        [AttString addAttribute:NSForegroundColorAttributeName  value:(id)[UIColor dp_flatRedColor] range:NSMakeRange(0, base.length)];
        [AttString addAttribute:NSFontAttributeName value:(id)[UIFont dp_systemFontOfSize:10] range:[base rangeOfString:spString options:NSBackwardsSearch]];

    }else{
        [AttString addAttribute:NSForegroundColorAttributeName  value:(id)UIColorFromRGB(0xA29E95) range:[base rangeOfString:spString options:NSBackwardsSearch]];
        [AttString addAttribute:NSFontAttributeName value:(id)[UIFont dp_systemFontOfSize:10] range:[base rangeOfString:spString options:NSBackwardsSearch]];
    }
    
    return AttString ;
}


#pragma mark- 篮球胜分差
#define kBetControlTag 333


static NSString *kOptions[]= {@"1-5",@"6-10",@"11-15",@"16-20",@"21-25",@"26+"} ;
@interface DPjcdgBasketSfcCell (){

    UIView *_upView ;
    UIView *_downView ;
}
@property (nonatomic, strong) NSArray *sp_Numbers; // sp值
@property (nonatomic, strong) NSArray *defaultOption; // 选中状态
@property (nonatomic, strong, readonly)NSMutableArray *buttonsArray;

@property (nonatomic, strong, readonly)UILabel *upTeamNameLabel;
@property (nonatomic, strong, readonly)UILabel *downTeamNameLabel;
@property (nonatomic, strong, readonly)UIView *upView ;
@property (nonatomic, strong, readonly)UIView *downView ;


@end

@implementation DPjcdgBasketSfcCell

@synthesize sp_Numbers = _sp_Numbers;
@synthesize buttonsArray = _buttonsArray;
@synthesize upTeamNameLabel = _upTeamNameLabel ;
@synthesize downTeamNameLabel = _downTeamNameLabel ;
@synthesize upView = _upView ;
@synthesize downView = _downView ;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier WithGameType:(MyGameType)type {
    
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier WithGameType:type]) {
//        [self dp_buildUI];
        self.contentView.backgroundColor=
        self.backgroundColor = [UIColor clearColor] ;
        
    }
    
    return self;
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)buildCommonUI
{
    _myGameType = GameTypeBasketBall ;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    
    headViewBg = [[UIView alloc]init];
    headViewBg.backgroundColor = [UIColor clearColor] ;
    [self.contentView addSubview:headViewBg];
    [headViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView) ;
        make.left.equalTo(self.contentView).offset(5) ;
        make.right.equalTo(self.contentView).offset(-10) ;
        make.height.equalTo(@30) ;
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dp_infoButtonClick:)];
    [headViewBg addGestureRecognizer:tap];
    
    
    
    [headViewBg addSubview:self.flagView];
    [headViewBg addSubview:self.gameTypeLabel];
    
    [self.flagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headViewBg);
        make.left.equalTo(headViewBg);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    [self.gameTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headViewBg).offset(30);
        make.bottom.equalTo(headViewBg).offset(-3);
    }];

    
   
    
    
    self.gameTypeLabel.text = @"胜分差";
    self.flagView.image = dp_AppRootImage(@"sfc.png") ;
    
    
    
    [self.basContentView addSubview:self.upTeamNameLabel];
    [self.basContentView addSubview:self.downTeamNameLabel];
    
    [self.basContentView addSubview:self.upView];
    [self.basContentView addSubview:self.downView];
    
    [self.upTeamNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.basContentView).offset(15);
        make.left.equalTo(self.basContentView).offset(10);
        make.width.equalTo(@25);
        make.height.equalTo(@80);
    }];
    [self.downTeamNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.upTeamNameLabel.mas_bottom).offset(15);
        make.left.equalTo(self.basContentView).offset(10);
        make.width.equalTo(@25);
        make.height.equalTo(@80);

    }];
    
  
    [self.upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.basContentView).offset(40);
        make.top.equalTo(self.basContentView).offset(15);
        make.right.equalTo(self.basContentView).offset(- 10);
        make.height.equalTo(@80);
    }];
    
    [self.downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.upView);
        make.top.equalTo(self.upView.mas_bottom).offset(15);
        make.right.equalTo(self.upView);
        make.height.equalTo(@80);
    }];
    
   
    [self.contentView addSubview:self.basContentView];
    [self.basContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(headViewBg.mas_bottom);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@195) ;
    }];
    
    
    [self.contentView addSubview:self.bottomContentView];
    [self.bottomContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.basContentView.mas_bottom) ;
        make.left.equalTo(self.contentView) ;
        make.right.equalTo(self.contentView) ;
        make.height.equalTo(@(70));
    }];
    
    

    
}

- (void)bulidSinglePartView:(UIView *)baseview withTagBase:(int)tagBase
{

    for (int i=0; i<6; i++) {
        UIButton *control = [self createButtonWithTitle:kOptions[i] tag:i+tagBase];
        
        [baseview addSubview:control];

        [control mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@((i/3)*41)) ;
            make.left.equalTo(@((i%3)*85+10));
            make.width.equalTo(@80) ;
            make.height.equalTo(@36) ;
        }];

    }
    
}

-(UIButton* )createButtonWithTitle:(NSString*)title tag:(int)tag{

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    
    UIImage *resizeImg = dp_SportLotteryResizeImage(@"选取样式框架_34.png") ;
    [btn setBackgroundImage:resizeImg forState:UIControlStateSelected];
    [btn setBackgroundImage:dp_SportLotteryResizeImage(@"btn_bg_03.png") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor dp_flatRedColor] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont dp_systemFontOfSize:13] ;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter ;
    
    [btn setAttributedTitle:ATCreateAttributStringWith(title, @"0.00",NO ) forState:UIControlStateNormal];
    [btn setAttributedTitle:ATCreateAttributStringWith(title, @"0.00",YES) forState:UIControlStateSelected];
    btn.tag = tag ;
    
    [btn addTarget:self action:@selector(dp_singleControlClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonsArray addObject:btn];
    return btn ;
}
-(void)dp_singleControlClick:(UIButton*)sender{
    
    sender.selected = !sender.selected ;
    
    if (sender.selected == YES) {
        
     
        if ([self.delegate respondsToSelector:@selector(clickButtonWithCell:gameType:index:isSelected:)]) {
            [self.delegate clickButtonWithCell:self gameType:GameTypeLcSfc index:((int)sender.tag - kBetControlTag) isSelected:YES ];
        }
    }else{
      
        if ([self.delegate respondsToSelector:@selector(clickButtonWithCell:gameType:index:isSelected:)]) {
            
            [self.delegate clickButtonWithCell:self gameType:GameTypeLcSfc index:((int)sender.tag - kBetControlTag ) isSelected:NO ];
        }
    }
    
}

- (void)setSp_Numbers:(NSArray *)sp_Numbers
{
    if (sp_Numbers.count < 12) {
        return;
    }
    for (int i = 0; i < 12; i++) {
        UIButton *button = (UIButton *)self.buttonsArray[i];
        [button setAttributedTitle:ATCreateAttributStringWith(kOptions[i%6],sp_Numbers[i],NO) forState:UIControlStateNormal];
        [button setAttributedTitle:ATCreateAttributStringWith(kOptions[i%6],sp_Numbers[i],YES) forState:UIControlStateSelected];
    }
   
    
    _sp_Numbers = sp_Numbers;
    
}
- (NSArray *)sp_Numbers
{
    if(_sp_Numbers == nil){
        _sp_Numbers = [NSArray array];
    }
    return _sp_Numbers;
}
- (void)setDefaultOption:(NSArray *)defaultOption
{
    if (defaultOption.count < 12) {
        return;
    }
    for (int i = 0; i < 12; i++) {
        UIButton *button = (UIButton *)self.buttonsArray[i];
        
        button.selected = [defaultOption[i] intValue];
//        if ([defaultOption[i] intValue]) {
//            button.numberLabel.textColor = [UIColor dp_flatRedColor];
//            button.spLabel.textColor = [UIColor dp_flatRedColor];
//        }else{
//            button.numberLabel.textColor = [UIColor dp_colorFromHexString:@"#333333"];
//            button.spLabel.textColor = [UIColor dp_colorFromHexString:@"#C1C1C1"];
//        }
    }
    _defaultOption = defaultOption;
}

- (UILabel *)upTeamNameLabel
{
    if (_upTeamNameLabel == nil ) {
        _upTeamNameLabel = [[UILabel alloc]init];
        _upTeamNameLabel.backgroundColor = UIColorFromRGB(0x639650);
        _upTeamNameLabel.textColor = [UIColor dp_flatWhiteColor];
        _upTeamNameLabel.font = [UIFont dp_systemFontOfSize:13];
        _upTeamNameLabel.textAlignment = NSTextAlignmentCenter;
        _upTeamNameLabel.text = @" ";
        _upTeamNameLabel.contentMode = UIViewContentModeCenter ;
        _upTeamNameLabel.numberOfLines = 0;
    }
    return _upTeamNameLabel;
}
- (UILabel *)downTeamNameLabel
{
    if (_downTeamNameLabel == nil) {
        _downTeamNameLabel = [[UILabel alloc]init];
        _downTeamNameLabel.backgroundColor = UIColorFromRGB(0xD99231);
        _downTeamNameLabel.textColor = [UIColor dp_flatWhiteColor];
        _downTeamNameLabel.font = [UIFont dp_systemFontOfSize:14];
        _downTeamNameLabel.textAlignment = NSTextAlignmentCenter;
        _downTeamNameLabel.numberOfLines = 0;
        _downTeamNameLabel.text = @" ";
    }
    return _downTeamNameLabel;
}


-(UIView*)upView{

    if (_upView == nil) {
        _upView = [[UIView alloc]init];
        [self bulidSinglePartView:_upView withTagBase:kBetControlTag ];

    }
    
    return _upView ;
}
-(UIView*)downView{
    
    if (_downView == nil) {
        _downView = [[UIView alloc]init];
        [self bulidSinglePartView:_downView withTagBase:kBetControlTag+6 ];
        
    }
    
    return _downView ;
}


- (NSMutableArray *)buttonsArray
{
    if (_buttonsArray == nil) {
        _buttonsArray = [NSMutableArray arrayWithCapacity:8];
    }
    return _buttonsArray;
}
- (void)dp_setCelldataModel:(id)dataModel
{
    [super dp_setCelldataModel:dataModel];
    if (![dataModel isKindOfClass:[DPJcdgBasketCellModel class]]) {
        return;
    }
    DPJcdgBasketCellModel *model = (DPJcdgBasketCellModel *)dataModel;
    self.sp_Numbers = model.sp_Numbers;
    self.defaultOption = model.defaultOption;
    _warnContent = model.warnContent;
    self.gameType = model.gameType ;
    self.upTeamNameLabel.text = model.awayName ;
    self.downTeamNameLabel.text = model.homeName ;
    self.bottomContentView.zhuShu = model.zhushu ;
    self.bottomContentView.miniBonus = model.minBonus ;
    self.bottomContentView.maxBonus = model.maxBonus ;

    [self.bottomContentView dp_reloadMoney];
}
@end
