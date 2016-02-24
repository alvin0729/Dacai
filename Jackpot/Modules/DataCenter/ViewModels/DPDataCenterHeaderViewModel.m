//
//  DPDataCenterHeaderViewModel.m
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPDataCenterHeaderViewModel.h"
#import "FootballDataCenter.pbobjc.h"
#import "BasketballDataCenter.pbobjc.h"
#import "DPGameLiveEnum.h"
#import <AFNetworking/AFNetworking.h>

static NSString *kDataCenterMatchInfoNotification = @"DataCenterMatchInfoNotification";
static NSString *kMessageKey = @"Message";
static NSString *kMatchIdKey = @"MatchId";
static const NSInteger kDIAMETER = 40;

@protocol IDPDataCenterHeaderViewModel <NSObject>
@required
- (void)matchInfoMessage:(id)message;
@end

@interface DPDataCenterHeaderViewModel ()
@property (nonatomic, weak) id<IDPDataCenterHeaderViewModel> interface;
@property (nonatomic, strong) NSURLSessionDataTask *homeIconTask;
@property (nonatomic, strong) NSURLSessionDataTask *awayIconTask;
@property (nonatomic, strong) AFHTTPSessionManager *imageSessionManager;

- (void)fetchImageWithURL:(NSString *)url forTaskKeyPath:(NSString *)taskKeyPath forImageKeyPath:(NSString *)imageKeyPath;
@end

@implementation DPDataCenterHeaderViewModel

#pragma mark - Lifycycle
- (instancetype)init {
    if (self = [super init]) {
        NSAssert([self conformsToProtocol:@protocol(IDPDataCenterHeaderViewModel)], @"failure...");
        
        _interface = (id<IDPDataCenterHeaderViewModel>)self;
        
        // 注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(matchInfoArrive:)
                                                     name:kDataCenterMatchInfoNotification
                                                   object:nil];
        [self imageSessionManager];
    }
    return self;
}

- (void)dealloc {
    [self.imageSessionManager invalidateSessionCancelingTasks:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Interface

- (void)fetchImageWithURL:(NSString *)url forTaskKeyPath:(NSString *)taskKeyPath forImageKeyPath:(NSString *)imageKeyPath {
    UIImage *image = [[AFImageDiskCache sharedCache] cachedImageForURL:url];
    if (image) {
        // 图片已在本地, 则直接处理
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            UIImage *roundImage = [image dp_roundImageWithDiameter:kDIAMETER];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setValue:roundImage forKeyPath:imageKeyPath];
            });
        });
        return;
    }
    @weakify(self);
    NSURLSessionDataTask *task = [self.imageSessionManager GET:url
        parameters:nil
        success:^(NSURLSessionDataTask *task, UIImage *image) {
            @strongify(self);
            // 缓存图片
            [[AFImageDiskCache sharedCache] cacheImage:image forURL:url];
            
            // 处理图片
            UIImage *roundImage = [image dp_roundImageWithDiameter:kDIAMETER];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setValue:roundImage forKeyPath:imageKeyPath];
                [self setValue:nil forKeyPath:taskKeyPath];
            });
        }
        failure:^(NSURLSessionDataTask *task, NSError *error){
            @strongify(self);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setValue:nil forKeyPath:taskKeyPath];
            });
        }];
    [self setValue:task forKeyPath:taskKeyPath];
}

#pragma mark - Notification

- (void)matchInfoArrive:(NSNotification *)notification {
    id message = [notification.userInfo objectForKey:kMessageKey];
    NSInteger matchId = [[notification.userInfo objectForKey:kMatchIdKey] integerValue];
    
    if (self.matchId != matchId) {
        NSLog(@"match info match id unmatch.");
        return;
    }
    if ([self.interface respondsToSelector:@selector(matchInfoMessage:)]) {
        [self.interface matchInfoMessage:message];
    }
}

#pragma mark - Property (getter, setter)

- (AFHTTPSessionManager *)imageSessionManager {
    if (_imageSessionManager == nil) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 10;
        
        _imageSessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        _imageSessionManager.responseSerializer = [AFImageResponseSerializer serializer];
        _imageSessionManager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    }
    return _imageSessionManager;
}

@end

@interface DPFootballCenterHeaderViewModel () <IDPDataCenterHeaderViewModel>
@end
@implementation DPFootballCenterHeaderViewModel

#pragma mark - Private Interface

- (instancetype)init
{
    self = [super init];
    if (self) {
      self.scoreText =  [[NSAttributedString alloc]initWithString:@"- : -" attributes:@{NSForegroundColorAttributeName:[UIColor dp_flatBlackColor],NSFontAttributeName:[UIFont dp_boldSystemFontOfSize:30]}];
    }
    return self;
}
- (void)configureTeamName {
    MTStringParser *parser = [[MTStringParser alloc] init];
    [parser setDefaultAttributes:({
        MTStringAttributes *attr = [[MTStringAttributes alloc] init];
        attr.font = [UIFont dp_systemFontOfSize:13];
        attr.textColor = [UIColor dp_flatBlackColor];
        attr;
    })];
    [parser addStyleWithTagName:@"rank" font:[UIFont dp_systemFontOfSize:9] color:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1]];
    
    NSString *homeMarkupText, *awayMarkupText;
    
    // 球队名+排名
    if (self.homeRank.length) {
        homeMarkupText = [NSString stringWithFormat:@"<rank>[%@]</rank>%@", self.homeRank, self.homeName];
    } else {
        homeMarkupText = [NSString stringWithFormat:@"%@", self.homeName];
    }
    if (self.awayRank.length) {
        awayMarkupText = [NSString stringWithFormat:@"%@<rank>[%@]</rank>", self.awayName, self.awayRank];
    } else {
        awayMarkupText = [NSString stringWithFormat:@"%@", self.awayName];
    }
    
    self.homeText = [parser attributedStringFromMarkup:homeMarkupText];
    self.awayText = [parser attributedStringFromMarkup:awayMarkupText];
}

- (void)configureTeamLogo {
    if (self.homeIconImage == nil && self.homeIconTask == nil && self.homeIconURL.length) {
        [self fetchImageWithURL:self.homeIconURL forTaskKeyPath:@"homeIconTask" forImageKeyPath:@"homeIconImage"];
    }
    if (self.awayIconImage == nil && self.awayIconTask == nil && self.awayIconURL.length) {
        [self fetchImageWithURL:self.awayIconURL forTaskKeyPath:@"awayIconTask" forImageKeyPath:@"awayIconImage"];
    }
}

- (void)configureTimeText {
    switch (self.matchStatus) {
        case DPGameLiveFootballMatchStatus_Interrupt:
        case DPGameLiveFootballMatchStatus_Pending:
        case DPGameLiveFootballMatchStatus_Cut:
        case DPGameLiveFootballMatchStatus_PutOff:
        case DPGameLiveFootballMatchStatus_Cancel:
        case DPGameLiveFootballMatchStatus_NotStart:
            self.timeText = [NSDate dp_coverDateString:self.startTime
                                            fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss
                                              toFormat:@"MM月dd日 HH:mm"];
            break;
        case DPGameLiveFootballMatchStatus_Ended:
        case DPGameLiveFootballMatchStatus_Halftime:
            self.timeText = nil;
            break;
        case DPGameLiveFootballMatchStatus_SecondHalf: {
            NSDate *halfTime = [NSDate dp_dateFromString:self.halfTime withFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss];
            NSTimeInterval timeInterval = [[NSDate dp_date] timeIntervalSinceDate:halfTime] / 60 + 45;
            self.timeText = timeInterval > 90 ? @"90+'" : [NSString stringWithFormat:@"%d'", (int)MAX(45, timeInterval)];
            break;
        }
        case DPGameLiveFootballMatchStatus_FirstHalf: {
            NSDate *startTime = [NSDate dp_dateFromString:self.startTime withFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss];
            NSTimeInterval timeInterval = [[NSDate dp_date] timeIntervalSinceDate:startTime] / 60;
            self.timeText = timeInterval > 45 ? @"45+'" : [NSString stringWithFormat:@"%d'", (int)MAX(0, timeInterval)];
            break;
        }
    }
}

- (void)configureScoreText {
    MTStringParser *parser = [[MTStringParser alloc] init];
    [parser setDefaultAttributes:({
        MTStringAttributes *attr = [[MTStringAttributes alloc] init];
        attr.alignment = NSTextAlignmentCenter;
        attr.font = [UIFont dp_boldSystemFontOfSize:30];
        attr.textColor = [UIColor dp_flatBlackColor] ;
        attr;
    })];
     [parser addStyleWithTagName:@"score" color:[UIColor dp_flatRedColor]];
    
    NSString *markupText;
    switch (self.matchStatus) {
        case DPGameLiveFootballMatchStatus_Interrupt:
        case DPGameLiveFootballMatchStatus_Pending:
        case DPGameLiveFootballMatchStatus_Cut:
        case DPGameLiveFootballMatchStatus_PutOff:
        case DPGameLiveFootballMatchStatus_Cancel:
        case DPGameLiveFootballMatchStatus_NotStart:
            markupText = @"VS";
            break;
        case DPGameLiveFootballMatchStatus_FirstHalf:
        case DPGameLiveFootballMatchStatus_SecondHalf:
            markupText = [NSString stringWithFormat:@"%d : %d", self.homeScore, self.awayScore];
             break ;
        case DPGameLiveFootballMatchStatus_Halftime:
         case DPGameLiveFootballMatchStatus_Ended:
            markupText = [NSString stringWithFormat:@"<score>%d : %d</score>", self.homeScore, self.awayScore];
            break;
    }
    
    self.scoreText = [parser attributedStringFromMarkup:markupText];
}

- (void)configureStatusText {
    MTStringParser *parser = [[MTStringParser alloc] init];
    [parser setDefaultAttributes:({
        MTStringAttributes *attr = [[MTStringAttributes alloc] init];
        attr.alignment = NSTextAlignmentCenter;
        attr.font = [UIFont dp_systemFontOfSize:11];
        attr.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
        attr.lineSpacing = 3;
        attr;
    })];
    NSString *markupText;
    switch (self.matchStatus) {
        case DPGameLiveFootballMatchStatus_NotStart:
            markupText = @"未开始";
            break;
        case DPGameLiveFootballMatchStatus_Interrupt:
            markupText = @"中断";
            break;
        case DPGameLiveFootballMatchStatus_Pending:
            markupText = @"待定";
            break;
        case DPGameLiveFootballMatchStatus_Cut:
            markupText = @"腰斩";
            break;
        case DPGameLiveFootballMatchStatus_PutOff:
            markupText = @"推迟";
            break;
        case DPGameLiveFootballMatchStatus_Cancel:
            markupText = @"已取消";
            break;
        case DPGameLiveFootballMatchStatus_FirstHalf:
            markupText = nil;
            break;
        case DPGameLiveFootballMatchStatus_SecondHalf:
            markupText = [NSString stringWithFormat:@"半场%d:%d", self.homeHalfScore, self.awayHalfScore];
            break;
        case DPGameLiveFootballMatchStatus_Halftime:
            markupText = @"中场休息";
            break;
        case DPGameLiveFootballMatchStatus_Ended:
            markupText = [NSString stringWithFormat:@"半场%d:%d\n已结束", self.homeHalfScore, self.awayHalfScore];
            break;
    }
    
    self.statusText = markupText ? [parser attributedStringFromMarkup:markupText] : nil;
}

#pragma mark - IDPDataCenterHeaderViewModel

- (void)matchInfoMessage:(PBMFootballHeader *)message {
    NSAssert([message isKindOfClass:[PBMFootballHeader class]], @"failure...");
    
    self.homeScore = message.homeScore;
    self.awayScore = message.awayScore;
    self.homeHalfScore = message.homeHalfScore;
    self.awayHalfScore = message.awayHalfScore;
    self.startTime = message.startTime;
    self.halfTime = message.halfStartTime;
    self.homeIconURL = message.homeTeamIcon;
    self.awayIconURL = message.awayTeamIcon;
    self.matchStatus = message.status;
    self.homeName = message.homeTeamName;
    self.awayName = message.awayTeamName;
    self.homeRank = message.homeTeamRank;
    self.awayRank = message.awayTeamRank;
    self.action = message.focus ;
    
    [self configureTeamLogo];
    [self configureTeamName];
    [self configureTimeText];
    [self configureScoreText];
    [self configureStatusText];
}

@end

@interface DPBasketballCenterHeaderViewModel () <IDPDataCenterHeaderViewModel>
@end
@implementation DPBasketballCenterHeaderViewModel

#pragma mark - Private Interface
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scoreText =  [[NSAttributedString alloc]initWithString:@"- : -" attributes:@{NSForegroundColorAttributeName:[UIColor dp_flatBlackColor],NSFontAttributeName:[UIFont dp_boldSystemFontOfSize:30]}];
    }
    return self;
}

- (void)configureTeamName {
    MTStringParser *parser = [[MTStringParser alloc] init];
    [parser setDefaultAttributes:({
        MTStringAttributes *attr = [[MTStringAttributes alloc] init];
        attr.font = [UIFont dp_systemFontOfSize:13];
        attr.textColor = [UIColor dp_flatBlackColor];
        attr;
    })];
    [parser addStyleWithTagName:@"rank" font:[UIFont dp_systemFontOfSize:9] color:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1]];
    
    NSString *homeMarkupText, *awayMarkupText;
    
    // 球队名+排名
    if (self.homeRank.length) {
        homeMarkupText = [NSString stringWithFormat:@"%@\n<rank>[%@]</rank>", self.homeRank, self.homeName];
    } else {
        homeMarkupText = [NSString stringWithFormat:@"%@", self.homeName];
    }
    if (self.awayRank.length) {
        awayMarkupText = [NSString stringWithFormat:@"%@\n<rank>[%@]</rank>", self.awayName, self.awayRank];
    } else {
        awayMarkupText = [NSString stringWithFormat:@"%@", self.awayName];
    }
    
    self.homeText = [parser attributedStringFromMarkup:homeMarkupText];
    self.awayText = [parser attributedStringFromMarkup:awayMarkupText];
}

- (void)configureTeamLogo {
    if (self.homeIconImage == nil && self.homeIconTask == nil && self.homeIconURL.length) {
        [self fetchImageWithURL:self.homeIconURL forTaskKeyPath:@"homeIconTask" forImageKeyPath:@"homeIconImage"];
    }
    if (self.awayIconImage == nil && self.awayIconTask == nil && self.awayIconURL.length) {
        [self fetchImageWithURL:self.awayIconURL forTaskKeyPath:@"awayIconTask" forImageKeyPath:@"awayIconImage"];
    }
}

- (void)configureTimeText {
    
    switch (self.matchStatus) {
        case DPGameLiveBasketballMatchStatus_NotStart:
            self.timeText = [NSDate dp_coverDateString:self.startTime
                                            fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss
                                              toFormat:@"MM月dd日 HH:mm"];
            break;
        case DPGameLiveBasketballMatchStatus_FirstSection:
        case DPGameLiveBasketballMatchStatus_SecondSection:
        case DPGameLiveBasketballMatchStatus_ThirdSection:
        case DPGameLiveBasketballMatchStatus_FourthSection:
        case DPGameLiveBasketballMatchStatus_ExtraSection:
            self.timeText = self.onTime ;
            break;
        case DPGameLiveBasketballMatchStatus_FirstBreak:
        case DPGameLiveBasketballMatchStatus_SecondBreak:
        case DPGameLiveBasketballMatchStatus_ThirdBreak:
        case DPGameLiveBasketballMatchStatus_FourthBreak:
        case DPGameLiveBasketballMatchStatus_ExtraBreak:
        case DPGameLiveBasketballMatchStatus_NormalEnded:
        case DPGameLiveBasketballMatchStatus_ExtraEnded:
            self.timeText = nil;
            break;
    }
}

- (void)configureScoreText {
    MTStringParser *parser = [[MTStringParser alloc] init];
    [parser setDefaultAttributes:({
        MTStringAttributes *attr = [[MTStringAttributes alloc] init];
        attr.alignment = NSTextAlignmentCenter;
        attr.font = [UIFont dp_systemFontOfSize:30];
        attr;
    })];
    [parser addStyleWithTagName:@"vs" color:[UIColor dp_flatBlackColor]];
    [parser addStyleWithTagName:@"score" color:[UIColor dp_flatBlackColor]];
    
    NSString *markupText;
    switch (self.matchStatus) {
        case DPGameLiveBasketballMatchStatus_NotStart:
            markupText = @"<vs>VS</vs>";
            break;
        case DPGameLiveBasketballMatchStatus_FirstSection:
        case DPGameLiveBasketballMatchStatus_FirstBreak:
        case DPGameLiveBasketballMatchStatus_SecondSection:
        case DPGameLiveBasketballMatchStatus_SecondBreak:
        case DPGameLiveBasketballMatchStatus_ThirdSection:
        case DPGameLiveBasketballMatchStatus_ThirdBreak:
        case DPGameLiveBasketballMatchStatus_FourthSection:
        case DPGameLiveBasketballMatchStatus_FourthBreak:
        case DPGameLiveBasketballMatchStatus_ExtraSection:
        case DPGameLiveBasketballMatchStatus_ExtraBreak:
        case DPGameLiveBasketballMatchStatus_NormalEnded:
        case DPGameLiveBasketballMatchStatus_ExtraEnded:
            markupText = [NSString stringWithFormat:@"<score>%d : %d</score>", self.awayScore, self.homeScore];
            break;
    }

    self.scoreText = [parser attributedStringFromMarkup:markupText];
}

- (void)configureStatusText {
    MTStringParser *parser = [[MTStringParser alloc] init];
    [parser setDefaultAttributes:({
        MTStringAttributes *attr = [[MTStringAttributes alloc] init];
        attr.alignment = NSTextAlignmentCenter;
        attr.font = [UIFont dp_systemFontOfSize:11];
        attr.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
        attr;
    })];
    [parser addStyleWithTagName:@"red" font:[UIFont dp_systemFontOfSize:15] color:[UIColor colorWithRed:0.96 green:0.16 blue:0.09 alpha:1]];
    [parser addStyleWithTagName:@"green" font:[UIFont dp_boldSystemFontOfSize:15] color:[UIColor colorWithRed:0.17 green:0.71 blue:0 alpha:1]];
    [parser addStyleWithTagName:@"gray" font:[UIFont dp_boldSystemFontOfSize:15] color:[UIColor colorWithRed:0.75 green:0.69 blue:0.59 alpha:1]];
    
    NSString *markupText;
    switch (self.matchStatus) {
        case DPGameLiveBasketballMatchStatus_NotStart:
            markupText = @"未开始";
            break;
        case DPGameLiveBasketballMatchStatus_FirstSection:
            markupText = @"<red>●</red><gray>●●●</gray>";
            break;
        case DPGameLiveBasketballMatchStatus_FirstBreak:
            markupText = @"<red>●</red><gray>●●●</gray>\n第一节休息";
            break;
        case DPGameLiveBasketballMatchStatus_SecondSection:
            markupText = @"<red>●>●</red><gray>●●</gray>";
            break;
        case DPGameLiveBasketballMatchStatus_SecondBreak:
            markupText = @"<red>●●</red><gray>●●</gray>\n中场休息";
            break;
        case DPGameLiveBasketballMatchStatus_ThirdSection:
            markupText = @"<red>●●●</red><gray>●</gray>";
            break;
        case DPGameLiveBasketballMatchStatus_ThirdBreak:
            markupText = @"<red>●●●</red><gray>●</gray>\n第三节休息";
            break;
        case DPGameLiveBasketballMatchStatus_FourthSection:
            markupText = @"<red>●●●●</red>";
            break;
        case DPGameLiveBasketballMatchStatus_FourthBreak:
            markupText = @"<red>●●●●</red><gray>●</gray>\n第四节休息";
            break;
        case DPGameLiveBasketballMatchStatus_ExtraSection:
            markupText = @"<red>●●●●</red><green>●</green>";
            break;
        case DPGameLiveBasketballMatchStatus_ExtraBreak:
            markupText = @"<red>●●●●</red><green>●</green>\n加时赛休息";
            break;
        case DPGameLiveBasketballMatchStatus_NormalEnded:
        case DPGameLiveBasketballMatchStatus_ExtraEnded:
            markupText = @"已结束";
            break;
    }
    self.statusText = markupText ? [parser attributedStringFromMarkup:markupText] : nil;
}

#pragma mark - IDPDataCenterHeaderViewModel

- (void)matchInfoMessage:(PBMBasketballHeader *)message {
    NSAssert([message isKindOfClass:[PBMBasketballHeader class]], @"failure...");
    
    self.homeScore = message.homeTotalScore;
    self.awayScore = message.awayTotalScore;
    self.startTime = message.startTime;
    self.homeIconURL = message.homeLogo;
    self.awayIconURL = message.awayLogo;
    self.matchStatus = message.status;
    self.homeName = message.homeName;
    self.awayName = message.awayName;
    self.homeRank = message.homeRank;
    self.awayRank = message.awayRank;
    self.onTime = [NSString stringWithFormat:@"%@'",message.onTime];
    self.action = message.focus ;
    
    [self configureTeamLogo];
    [self configureTeamName];
    [self configureTimeText];
    [self configureScoreText];
    [self configureStatusText];
}

@end
