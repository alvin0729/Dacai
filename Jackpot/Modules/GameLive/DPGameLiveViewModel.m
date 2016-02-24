//
//  DPGameLiveViewModel.m
//  Jackpot
//
//  Created by wufan on 15/8/14.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "DPGameLiveViewModel.h"
#import "DPGameLiveViewModel+Private.h"
#import "DPGameLiveViewModel+Network.h"
#import "AFImageDiskCache.h"
#import "Gamelive.pbobjc.h"


static NSString *kBaseCellIdentifier = @"base";
static NSString *kFootballCellIdentifier = @"football";
static NSString *kBasketballCellIdentifier = @"basketball";

@interface DPGameLiveViewModel ()
@property (nonatomic, strong) MTStringParser *footballParser;
@property (nonatomic, strong) MTStringParser *basketballParser;
@property (nonatomic, strong) NSURLSessionDataTask *task;


@end

@implementation DPGameLiveViewModel

- (instancetype)initWithDelegate:(id<DPGameLiveViewDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        _dataType = -1;     // 缺省数据类型不属于任何彩种
    }
    return self;
}

- (void)dealloc {
    [self.imageSessionMgr invalidateSessionCancelingTasks:NO];
}

- (NSString *)basketballIdentifier {
    return kBasketballCellIdentifier;
}

- (NSString *)footballIdentifier {
    return kFootballCellIdentifier;
}

- (NSString *)baseIdentifier {
    return kBaseCellIdentifier;
}

- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath forTab:(DPGameLiveTab)tab {
    DPGameLiveMatchModel *matchModel = [self matchModelAtIndexPath:indexPath forTab:tab];
    if (!matchModel.unfold) {
        return kBaseCellIdentifier;
    }
    if (self.gameLiveType == DPGameLiveTypeFootball) {
        return kFootballCellIdentifier;
    } else {
        return kBasketballCellIdentifier;
    }
}

- (NSInteger)numberOfSectionsForTab:(DPGameLiveTab)tab {
    switch (tab) {
        case DPGameLiveTabUnfinished:
            return self.visibleUnfinished.count;
        case DPGameLiveTabCompleted:
            return self.visibleCompleted.count;
        case DPGameLiveTabAttention:
            return 1;
    }
    return 0;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section forTab:(DPGameLiveTab)tab {
    switch (tab) {
        case DPGameLiveTabUnfinished: {
            DPGameLiveDailyModel *dailyModel = self.visibleUnfinished[section];
            if (dailyModel.unfold) {
                return dailyModel.matches.count;
            } else {
                return 0;
            }
        }
        case DPGameLiveTabCompleted: {
            DPGameLiveDailyModel *dailyModel = self.visibleCompleted[section];
            if (dailyModel.unfold) {
                return dailyModel.matches.count;
            } else {
                return 0;
            }
        }
        case DPGameLiveTabAttention:
            return self.attention.count;
    }
    return 0;
}

- (NSString *)titleForSection:(NSInteger)section forTab:(DPGameLiveTab)tab {
    switch (tab) {
        case DPGameLiveTabUnfinished:
            return [self.visibleUnfinished[section] gameTime];
        case DPGameLiveTabCompleted:
            return [self.visibleCompleted[section] gameTime];
        case DPGameLiveTabAttention:
            return nil;
    }
    return 0;
}

- (BOOL)cellUnfoldAtIndexPath:(NSIndexPath *)indexPath forTab:(DPGameLiveTab)tab {
    return [self matchModelAtIndexPath:indexPath forTab:tab].unfold;
}

- (void)toggleCellAtIndexPath:(NSIndexPath *)indexPath forTab:(DPGameLiveTab)tab {
    DPGameLiveMatchModel *matchModel = [self matchModelAtIndexPath:indexPath forTab:tab];
    matchModel.unfold = !matchModel.unfold;
}

- (BOOL)unfoldSection:(NSInteger)section forTab:(DPGameLiveTab)tab {
    switch (tab) {
        case DPGameLiveTabUnfinished:
            return [self.visibleUnfinished[section] unfold];
        case DPGameLiveTabCompleted:
            return [self.visibleCompleted[section] unfold];
        default:
            return 0;
    }
}

- (void)toggleSection:(NSInteger)section forTab:(DPGameLiveTab)tab {
    DPGameLiveDailyModel *dailyModel;
    switch (tab) {
        case DPGameLiveTabUnfinished:
            dailyModel = self.visibleUnfinished[section];
            break;
        case DPGameLiveTabCompleted:
            dailyModel = self.visibleCompleted[section];
            break;
        default:
            break;
    }
    dailyModel.unfold = !dailyModel.unfold;
}

- (NSInteger)matchCountForCompetition:(NSArray *)competition {
    NSInteger count = 0;
    for (DPGameLiveMatchModel *matchModel in self.allMatches) {
        if ([competition containsObject:matchModel.competition]) {
            count++;
        }
    }
    return count;
}

- (void)filterWithVisibleCompetition:(NSArray *)competition {
    self.visibleUnfinished = [self filterAllArray:self.allUnfinished withCompetition:competition];
    self.visibleCompleted = [self filterAllArray:self.allCompleted withCompetition:competition];
    self.visibleCompetition = competition;
}

- (DPGameLiveMatchModel *)matchModelAtIndexPath:(NSIndexPath *)indexPath forTab:(DPGameLiveTab)tab {
    switch (tab) {
        case DPGameLiveTabUnfinished:
            return [self.visibleUnfinished[indexPath.section] matches][indexPath.row];
        case DPGameLiveTabCompleted:
            return [self.visibleCompleted[indexPath.section] matches][indexPath.row];
        case DPGameLiveTabAttention:
            return [self.attention objectAtIndex:indexPath.row];
    }
}

// 足球赛事状态
- (NSArray *)footballStatusAtIndexPath:(NSIndexPath *)indexPath forTab:(DPGameLiveTab)tab {
    DPGameLiveMatchModel *matchModel = [self matchModelAtIndexPath:indexPath forTab:tab];
    switch (matchModel.matchStatus) {
        case DPGameLiveFootballMatchStatus_NotStart:
            return @[[self.footballParser attributedStringFromMarkup:@"<status>未开始</status>"],
                     [self.footballParser attributedStringFromMarkup:@"VS"]];
        case DPGameLiveFootballMatchStatus_FirstHalf: {
            NSTimeInterval timeInterval = [[NSDate dp_date] timeIntervalSinceDate:matchModel.startTime] / 60;
            NSString *markupText1 = timeInterval > 45 ? @"<status>45+</status>" : [NSString stringWithFormat:@"<status>%d</status>", (int)MAX(0, timeInterval)];
            NSString *markupText2 = [NSString stringWithFormat:@"<score>%d-%d</score>", matchModel.homeScore, matchModel.awayScore];
            return @[[self.footballParser attributedStringFromMarkup:markupText1],
                     [self.footballParser attributedStringFromMarkup:markupText2]];
        }
        case DPGameLiveFootballMatchStatus_Halftime: {
            NSString *markupText1 = @"<status>中场休息</status>";
            NSString *markupText2 = [NSString stringWithFormat:@"<score>%d-%d</score>", matchModel.homeScore, matchModel.awayScore];
            NSString *markupText3 = [NSString stringWithFormat:@"<half>半场:%d-%d</half>", matchModel.homeHalfScore, matchModel.awayHalfScore];
            return @[[self.footballParser attributedStringFromMarkup:markupText1],
                     [self.footballParser attributedStringFromMarkup:markupText2],
                     [self.footballParser attributedStringFromMarkup:markupText3]];
        }
        case DPGameLiveFootballMatchStatus_SecondHalf: {
            NSTimeInterval timeInterval = [[NSDate dp_date] timeIntervalSinceDate:matchModel.halfTime] / 60 + 45;
            NSString *markupText1 = timeInterval > 90 ? @"<status>90+</status>" : [NSString stringWithFormat:@"<status>%d</status>", (int)MAX(45, timeInterval)];
            NSString *markupText2 = [NSString stringWithFormat:@"<score>%d-%d</score>", matchModel.homeScore, matchModel.awayScore];
            NSString *markupText3 = [NSString stringWithFormat:@"<half>半场:%d-%d</half>", matchModel.homeHalfScore, matchModel.awayHalfScore];
            return @[[self.footballParser attributedStringFromMarkup:markupText1],
                     [self.footballParser attributedStringFromMarkup:markupText2],
                     [self.footballParser attributedStringFromMarkup:markupText3]];
        }
        case DPGameLiveFootballMatchStatus_Ended: {
            NSString *markupText1 = @"<status>已结束</status>";
            NSString *markupText2 = [NSString stringWithFormat:@"<score>%d-%d</score>", matchModel.homeScore, matchModel.awayScore];
            NSString *markupText3 = [NSString stringWithFormat:@"<half>半场:%d-%d</half>", matchModel.homeHalfScore, matchModel.awayHalfScore];
            return @[[self.footballParser attributedStringFromMarkup:markupText1],
                     [self.footballParser attributedStringFromMarkup:markupText2],
                     [self.footballParser attributedStringFromMarkup:markupText3]];
        }
        case DPGameLiveFootballMatchStatus_Pending:
            return @[[self.footballParser attributedStringFromMarkup:@"<status>待定</status>"],
                     [self.footballParser attributedStringFromMarkup:@"VS"]];
        case DPGameLiveFootballMatchStatus_PutOff:
            return @[[self.footballParser attributedStringFromMarkup:@"<status>推迟</status>"],
                     [self.footballParser attributedStringFromMarkup:@"VS"]];
        case DPGameLiveFootballMatchStatus_Cancel:
            return @[[self.footballParser attributedStringFromMarkup:@"<status>已取消</status>"],
                     [self.footballParser attributedStringFromMarkup:@"VS"]];
        case DPGameLiveFootballMatchStatus_Interrupt:
            return @[[self.footballParser attributedStringFromMarkup:@"<status>中断</status>"],
                     [self.footballParser attributedStringFromMarkup:@"VS"]];
        case DPGameLiveFootballMatchStatus_Cut:
            return @[[self.footballParser attributedStringFromMarkup:@"<status>腰斩</status>"],
                     [self.footballParser attributedStringFromMarkup:@"VS"]];
    }
    return nil;
}

// 篮球赛事状态
- (NSArray *)basketballStatusAtIndexPath:(NSIndexPath *)indexPath forTab:(DPGameLiveTab)tab {
    DPGameLiveMatchModel *matchModel = [self matchModelAtIndexPath:indexPath forTab:tab];
    NSString *markupText1, *markupText2, *markupText3;
    switch (matchModel.matchStatus) {
        case DPGameLiveBasketballMatchStatus_NotStart:
            markupText1 = @"<score>VS</score>";
            markupText2 = @"<status>未开始</status>";
            return @[[self.basketballParser attributedStringFromMarkup:markupText1],
                     [self.basketballParser attributedStringFromMarkup:markupText2]];
        case DPGameLiveBasketballMatchStatus_FirstSection:
            markupText1 = [NSString stringWithFormat:@"<score>%d:%d</score>", matchModel.awayScore, matchModel.homeScore];
            markupText2 = @"<red>●</red><gray>●●●</gray>";
            markupText3 = [NSString stringWithFormat:@"<status>%@</status>", matchModel.onTime];
            break;
        case DPGameLiveBasketballMatchStatus_FirstBreak:
            markupText1 = [NSString stringWithFormat:@"<score>%d:%d</score>", matchModel.awayScore, matchModel.homeScore];
            markupText2 = @"<red>●</red><gray>●●●</gray>";
            markupText3 = @"<status>第一节休息</status>";
            break;
        case DPGameLiveBasketballMatchStatus_SecondSection:
            markupText1 = [NSString stringWithFormat:@"<score>%d:%d</score>", matchModel.awayScore, matchModel.homeScore];
            markupText2 = @"<red>●>●</red><gray>●●</gray>";
            markupText3 = [NSString stringWithFormat:@"<status>%@</status>", matchModel.onTime];
            break;
        case DPGameLiveBasketballMatchStatus_SecondBreak:
            markupText1 = [NSString stringWithFormat:@"<score>%d:%d</score>", matchModel.awayScore, matchModel.homeScore];
            markupText2 = @"<red>●●</red><gray>●●</gray>";
            markupText3 = @"<status>中场休息</status>";
            break;
        case DPGameLiveBasketballMatchStatus_ThirdSection:
            markupText1 = [NSString stringWithFormat:@"<score>%d:%d</score>", matchModel.awayScore, matchModel.homeScore];
            markupText2 = @"<red>●●●</red><gray>●</gray>";
            markupText3 = [NSString stringWithFormat:@"<status>%@</status>", matchModel.onTime];
            break;
        case DPGameLiveBasketballMatchStatus_ThirdBreak:
            markupText1 = [NSString stringWithFormat:@"<score>%d:%d</score>", matchModel.awayScore, matchModel.homeScore];
            markupText2 = @"<red>●●●</red><gray>●</gray>";
            markupText3 = @"<status>第三节休息</status>";
            break;
        case DPGameLiveBasketballMatchStatus_FourthSection:
            markupText1 = [NSString stringWithFormat:@"<score>%d:%d</score>", matchModel.awayScore, matchModel.homeScore];
            markupText2 = @"<red>●●●●</red>";
            markupText3 = [NSString stringWithFormat:@"<status>%@</status>", matchModel.onTime];
            break;
        case DPGameLiveBasketballMatchStatus_FourthBreak:
            markupText1 = [NSString stringWithFormat:@"<score>%d:%d</score>", matchModel.awayScore, matchModel.homeScore];
            markupText2 = @"<red>●●●●</red><gray>●</gray>";
            markupText3 = @"<status>第四节休息</status>";
            break;
        case DPGameLiveBasketballMatchStatus_ExtraSection:
            markupText1 = [NSString stringWithFormat:@"<score>%d:%d</score>", matchModel.awayScore, matchModel.homeScore];
            markupText2 = @"<red>●●●●</red><green>●</green>";
            markupText3 = [NSString stringWithFormat:@"<status>%@</status>", matchModel.onTime];
            break;
        case DPGameLiveBasketballMatchStatus_ExtraBreak:
            markupText1 = [NSString stringWithFormat:@"<score>%d:%d</score>", matchModel.awayScore, matchModel.homeScore];
            markupText2 = @"<red>●●●●</red><green>●</green>";
            markupText3 = @"<status>加时赛休息</status>";
            break;
        case DPGameLiveBasketballMatchStatus_NormalEnded:
            markupText1 = [NSString stringWithFormat:@"<score>%d:%d</score>", matchModel.awayScore, matchModel.homeScore];
            markupText2 = @"<status>已结束</status>";
            return @[[self.basketballParser attributedStringFromMarkup:markupText1],
                     [self.basketballParser attributedStringFromMarkup:markupText2]];
            break;
        case DPGameLiveBasketballMatchStatus_ExtraEnded:
            markupText1 = [NSString stringWithFormat:@"<score>%d:%d</score>", matchModel.awayScore, matchModel.homeScore];
            markupText2 = @"<status>已结束</status>";
            return @[[self.basketballParser attributedStringFromMarkup:markupText1],
                     [self.basketballParser attributedStringFromMarkup:markupText2]];
    }
    return @[[self.basketballParser attributedStringFromMarkup:markupText1],
             [self.basketballParser attributedStringFromMarkup:markupText2],
             [self.basketballParser attributedStringFromMarkup:markupText3]];
}

- (NSArray *)matchStatusAtIndexPath:(NSIndexPath *)indexPath forTab:(DPGameLiveTab)tab {
    switch (self.gameLiveType) {
        case DPGameLiveTypeFootball:
            return [self footballStatusAtIndexPath:indexPath forTab:tab];
        case DPGameLiveTypeBasketball:
            return [self basketballStatusAtIndexPath:indexPath forTab:tab];
    }
}

- (BOOL)matchGoingAtIndexPath:(NSIndexPath *)indexPath forTab:(DPGameLiveTab)tab {
    DPGameLiveMatchModel *model = [self matchModelAtIndexPath:indexPath forTab:tab];
    switch (self.gameLiveType) {
        case DPGameLiveTypeFootball: {
            switch (model.matchStatus) {
                case DPGameLiveFootballMatchStatus_FirstHalf:
                case DPGameLiveFootballMatchStatus_SecondHalf:
                    return YES;
                default:
                    return NO;
            }
        }
        case DPGameLiveTypeBasketball: {
            switch (model.matchStatus) {
                case DPGameLiveBasketballMatchStatus_FirstSection:
                case DPGameLiveBasketballMatchStatus_SecondSection:
                case DPGameLiveBasketballMatchStatus_ThirdSection:
                case DPGameLiveBasketballMatchStatus_FourthSection:
                case DPGameLiveBasketballMatchStatus_ExtraSection:
                    return YES;
                default:
                    return NO;
            }
        }
    }
}

- (void)attentionMatch:(BOOL)attention atIndexPath:(NSIndexPath *)indexPath forTab:(DPGameLiveTab)tab needLoad:(BOOL)needLoad {
    DPGameLiveMatchModel *model = [self matchModelAtIndexPath:indexPath forTab:tab];
    NSAssert(model.attention != attention, @"failure...");
    model.attention = attention;
    
    if (attention) {
        NSAssert(![self.attention containsObject:model], @"failure...");
        [self.attention addObject:model];
    } else {
        NSAssert([self.attention containsObject:model], @"failure...");
        [self.attention removeObject:model];
    }
    [self sortAttentionList];
    self.attentionCount = self.attention.count;
    
    if (!needLoad) {
        return ;
    }
    
    PBMActionStatus *status = [PBMActionStatus message];
    status.deviceToken = @"";
    status.gameType = self.gameLiveType == DPGameLiveTypeFootball ? GameTypeJcHt : GameTypeLcHt;
    status.matchId = model.matchId;
    status.beginDate = [model.startTime dp_stringWithFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss];
    status.focus = attention;
    
    if ([self.task.dp_userInfo isEqualToString:[NSString stringWithFormat:@"%ld",model.matchId]]) {
        [self.task cancel];
    }

    @weakify(self);
    self.task = [[AFHTTPSessionManager dp_sharedManager] POST:@"/live/setlivematch"
        parameters:status
        success:^(NSURLSessionDataTask *task, id responseObject) {
            @strongify(self);
            self.task = nil;
        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
            @strongify(self);
            self.task = nil;
        }];
    self.task.dp_userInfo = [NSString stringWithFormat:@"%ld", (long)model.matchId];
}

- (NSArray *)basketballHomeScoresAtIndexPath:(NSIndexPath *)indexPath forTab:(DPGameLiveTab)tab {
    DPGameLiveMatchModel *model = [self matchModelAtIndexPath:indexPath forTab:tab];
    
    NSAssert(self.gameLiveType == DPGameLiveTypeBasketball, @"basketball");
    NSAssert(model.homeSectionScore.count == 5, @"failure...");
    
    NSMutableArray *scores = [NSMutableArray arrayWithCapacity:5];
    NSArray *sectionScore = model.homeSectionScore;
    switch (model.matchStatus) {
        case DPGameLiveBasketballMatchStatus_NotStart:
            return nil;
        case DPGameLiveBasketballMatchStatus_ExtraEnded:
        case DPGameLiveBasketballMatchStatus_ExtraSection:
        case DPGameLiveBasketballMatchStatus_ExtraBreak:
            [scores insertObject:[sectionScore[4] stringValue] atIndex:0];
        case DPGameLiveBasketballMatchStatus_NormalEnded:
        case DPGameLiveBasketballMatchStatus_FourthSection:
        case DPGameLiveBasketballMatchStatus_FourthBreak:
            [scores insertObject:[sectionScore[3] stringValue] atIndex:0];
        case DPGameLiveBasketballMatchStatus_ThirdSection:
        case DPGameLiveBasketballMatchStatus_ThirdBreak:
            [scores insertObject:[sectionScore[2] stringValue] atIndex:0];
        case DPGameLiveBasketballMatchStatus_SecondSection:
        case DPGameLiveBasketballMatchStatus_SecondBreak:
            [scores insertObject:[sectionScore[1] stringValue] atIndex:0];
        case DPGameLiveBasketballMatchStatus_FirstSection:
        case DPGameLiveBasketballMatchStatus_FirstBreak:
            [scores insertObject:[sectionScore[0] stringValue] atIndex:0];
    }
    return scores;
}

- (NSArray *)basketballAwayScoresAtIndexPath:(NSIndexPath *)indexPath forTab:(DPGameLiveTab)tab {
    DPGameLiveMatchModel *model = [self matchModelAtIndexPath:indexPath forTab:tab];
    
    NSAssert(self.gameLiveType == DPGameLiveTypeBasketball, @"basketball");
    NSAssert(model.awaySectionScore.count == 5, @"failure...");
    
    NSMutableArray *scores = [NSMutableArray arrayWithCapacity:5];
    NSArray *sectionScore = model.awaySectionScore;
    switch (model.matchStatus) {
        case DPGameLiveBasketballMatchStatus_NotStart:
            return nil;
        case DPGameLiveBasketballMatchStatus_ExtraEnded:
        case DPGameLiveBasketballMatchStatus_ExtraSection:
        case DPGameLiveBasketballMatchStatus_ExtraBreak:
            [scores insertObject:[sectionScore[4] stringValue] atIndex:0];
        case DPGameLiveBasketballMatchStatus_NormalEnded:
        case DPGameLiveBasketballMatchStatus_FourthSection:
        case DPGameLiveBasketballMatchStatus_FourthBreak:
            [scores insertObject:[sectionScore[3] stringValue] atIndex:0];
        case DPGameLiveBasketballMatchStatus_ThirdSection:
        case DPGameLiveBasketballMatchStatus_ThirdBreak:
            [scores insertObject:[sectionScore[2] stringValue] atIndex:0];
        case DPGameLiveBasketballMatchStatus_SecondSection:
        case DPGameLiveBasketballMatchStatus_SecondBreak:
            [scores insertObject:[sectionScore[1] stringValue] atIndex:0];
        case DPGameLiveBasketballMatchStatus_FirstSection:
        case DPGameLiveBasketballMatchStatus_FirstBreak:
            [scores insertObject:[sectionScore[0] stringValue] atIndex:0];
    }
    return scores;
}

- (BOOL)shouldAttentionAtIndexPath:(NSIndexPath *)indexPath forTab:(DPGameLiveTab)tab {
    if (tab == DPGameLiveTabAttention) {
        return YES;
    }
    DPGameLiveMatchModel *model = [self matchModelAtIndexPath:indexPath forTab:tab];
    if (self.gameLiveType == DPGameLiveTypeFootball) {
        switch (model.matchStatus) {
            case DPGameLiveFootballMatchStatus_NotStart:
            case DPGameLiveFootballMatchStatus_FirstHalf:
            case DPGameLiveFootballMatchStatus_Halftime:
            case DPGameLiveFootballMatchStatus_SecondHalf:
                return YES;
            default:
                return NO;
        }
    } else {
        switch (model.matchStatus) {
            case DPGameLiveBasketballMatchStatus_NormalEnded:
            case DPGameLiveBasketballMatchStatus_ExtraEnded:
                return NO;
            default:
                return YES;
        }
    }
    return NO;
}

- (BOOL)shouldUnfoldAtIndexPath:(NSIndexPath *)indexPath forTab:(DPGameLiveTab)tab {
    DPGameLiveMatchModel *model = [self matchModelAtIndexPath:indexPath forTab:tab];
    if (self.gameLiveType == DPGameLiveTypeFootball) {
        switch (model.matchStatus) {
            case DPGameLiveFootballMatchStatus_FirstHalf:
            case DPGameLiveFootballMatchStatus_Halftime:
            case DPGameLiveFootballMatchStatus_SecondHalf:
            case DPGameLiveFootballMatchStatus_Ended:
                return YES;
            default:
                return NO;
        }
    } else {
        switch (model.matchStatus) {
            case DPGameLiveBasketballMatchStatus_NotStart:
                return NO;
            default:
                return YES;
        }
    }
    return NO;
}

- (BOOL)extraBasketballAtIndexPath:(NSIndexPath *)indexPath forTab:(DPGameLiveTab)tab {
    NSAssert(self.gameLiveType == DPGameLiveTypeBasketball, @"failure...");
    DPGameLiveMatchModel *model = [self matchModelAtIndexPath:indexPath forTab:tab];
    switch (model.matchStatus) {
        case DPGameLiveBasketballMatchStatus_ExtraBreak:
        case DPGameLiveBasketballMatchStatus_ExtraEnded:
        case DPGameLiveBasketballMatchStatus_ExtraSection:
            return YES;
        default:
            return NO;
    }
}


#pragma mark - getter, setter

- (void)setGameLiveType:(DPGameLiveType)gameLiveType {
    if (_gameLiveType == gameLiveType) {
        return;
    }
    _gameLiveType = gameLiveType;
    
    // 清空数据
    _allMatches = nil;
    _attention = nil;
    _allUnfinished = nil;
    _visibleUnfinished = nil;
    _allCompleted = nil;
    _visibleCompleted = nil;
    _allCompetition = nil;
    _visibleCompetition = nil;
    _timeTicks = nil;
    
    // 触发kvo
//    self.attentionCount = 0;
}

- (NSMutableDictionary *)imageRequestTable {
    if (_imageRequestTable == nil) {
        _imageRequestTable = [NSMutableDictionary dictionary];
    }
    return _imageRequestTable;
}

- (AFHTTPSessionManager *)imageSessionMgr {
    if (_imageSessionMgr == nil) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 10;
        
        _imageSessionMgr = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:configuration];
        _imageSessionMgr.responseSerializer = [[AFImageResponseSerializer alloc] init];
        _imageSessionMgr.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    }
    return _imageSessionMgr;
}

- (MTStringParser *)footballParser {
    if (_footballParser == nil) {
        _footballParser = [[MTStringParser alloc] init];
        [_footballParser setDefaultAttributes:({
            MTStringAttributes *attr = [[MTStringAttributes alloc] init];
            attr.alignment = NSTextAlignmentCenter;
            attr.font = [UIFont dp_boldSystemFontOfSize:20];
            attr.textColor = [UIColor dp_flatBlackColor];
            attr;
        })];
        [_footballParser addStyleWithTagName:@"status" font:[UIFont dp_systemFontOfSize:11] color:UIColorFromRGB(0xa8a69d)];
        [_footballParser addStyleWithTagName:@"score" font:[UIFont dp_boldSystemFontOfSize:25] color:[UIColor dp_flatRedColor]];
        [_footballParser addStyleWithTagName:@"half" font:[UIFont dp_systemFontOfSize:8] color:[UIColor colorWithWhite:0.6 alpha:1]];
    }
    return _footballParser;
}

- (MTStringParser *)basketballParser {
    if (_basketballParser == nil) {
        _basketballParser = [[MTStringParser alloc] init];
        [_basketballParser setDefaultAttributes:({
            MTStringAttributes *attr = [[MTStringAttributes alloc] init];
            attr.alignment = NSTextAlignmentCenter;
            attr;
        })];
        [_basketballParser addStyleWithTagName:@"score" font:[UIFont dp_boldSystemFontOfSize:20] color:[UIColor dp_flatBlackColor]];
        [_basketballParser addStyleWithTagName:@"red" font:[UIFont dp_systemFontOfSize:15] color:[UIColor colorWithRed:0.96 green:0.16 blue:0.09 alpha:1]];
        [_basketballParser addStyleWithTagName:@"green" font:[UIFont dp_boldSystemFontOfSize:15] color:[UIColor colorWithRed:0.17 green:0.71 blue:0 alpha:1]];
        [_basketballParser addStyleWithTagName:@"gray" font:[UIFont dp_boldSystemFontOfSize:15] color:[UIColor colorWithRed:0.75 green:0.69 blue:0.59 alpha:1]];
        [_basketballParser addStyleWithTagName:@"status" font:[UIFont dp_systemFontOfSize:10] color:UIColorFromRGB(0xa8a69d)];
    }
    return _basketballParser;
}

- (NSMutableSet *)goalSet {
    if (_goalSet == nil) {
        _goalSet = [[NSMutableSet alloc] init];
    }
    return _goalSet;
}

- (BOOL)hasMatches {
    return self.allMatches;
}

@end

