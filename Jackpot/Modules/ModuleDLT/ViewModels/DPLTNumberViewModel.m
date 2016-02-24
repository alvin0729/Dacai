//
//  DPLotteryNumberPlayStyle.m
//  DacaiProject
//
//  Created by WUFAN on 15/1/4.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页面有sxf做注释，他人如有更改，请标明

#import "DPAlterViewController.h"
#import "DPDltBetData.h"
#import "DPLBDltViewController.h"
#import "DPLTDltViewController.h"
#import "DPLTNumberViewModel.h"
#import <MSWeakTimer/MSWeakTimer.h>

static NSString *kSingleCellClassName = @"DPLTNumberCell";

static NSString *kSsqLotteryClassName = @"DPLBSsqViewController";
static NSString *kDltLotteryClassName = @"DPLBDltViewController";
static NSString *kElevenSfiveLotteryClassName = @"DPLBJxsyxwViewController";
static NSString *kFc3DLotteryClassName = @"DPLBSdViewController";
static NSString *kPk3LotteryClassName = @"DPLBSdpksViewController";
static NSString *kQuick3LotteryClassName = @"DPLBNmgksViewController";
static NSString *kPL3LotteryClassName = @"DPLBPsViewController";
static NSString *kPL5LotteryClassName = @"DPLBPwViewController";
static NSString *kQlcLotteryClassName = @"DPLBQlcViewController";
static NSString *kQxcLotteryClassName = @"DPLBQxcViewController";

#define IssueTrue @"true"
#define IssueFalse @"false"
//大乐透普通单式投注信息字符串
#define DZHLTLottery_BigLotteryNormalStr @"{\\\"__type\\\": \\\"%@\\\",\\\"Nums\\\":[%@],\\\"IsSingle\\\":%@}"
//大乐透普通复式投注信息字符串
#define DZHLTLottery_BigLotteryNormalMulStr @"{\\\"BackAreaNum\\\":[%@],\\\"PropAreaNum\\\":[%@],\\\"__type\\\": \\\"%@\\\",\\\"IsSingle\\\":%@}"
//大乐透胆拖投注信息字符串
#define DZHLTLottery_BigLotteryDanStr @"{\\\"__type\\\": \\\"%@\\\",\\\"PropAreaDan\\\":[%@],\\\"PropAreaTuo\\\":[%@],\\\"BackAreaDan\\\":[%@],\\\"BackAreaTuo\\\":[%@],\\\"IsSingle\\\":%@}"

@interface DPLTCellViewModel : NSObject <DPLTNumberCellDataSource>
//设置投注内容
- (void)setNumberString:(NSAttributedString *)numberString;
//设置投注信息
- (void)setDescString:(NSString *)descString;
- (void)setTypeString:(NSString *)typeString;
@end

@implementation DPLTCellViewModel
@synthesize numberString = _numberString;
@synthesize descString = _descString;
@synthesize typeString = _typeString;
- (void)setNumberString:(NSAttributedString *)numberString {
    _numberString = numberString;
}
- (void)setDescString:(NSString *)descString {
    _descString = descString;
}
- (void)setTypeString:(NSString *)typeString {
    _typeString = typeString;
}
@end

#pragma mark -

@interface DPLTNumberViewModel ()

@property (nonatomic, strong) NSDate *endTime;                                  // 截止时间
@property (nonatomic, strong) NSString *countDownString;                        //倒计时（首页用）
@property (nonatomic, strong) NSMutableAttributedString *countDownAttString;    //倒计时(中转投注页面用)

@property (nonatomic, strong) NSMutableAttributedString *bonusMoney;           // 奖池
@property (nonatomic, strong) NSMutableAttributedString *globalSurplusText;    //底部奖池
@property (nonatomic, assign) NSInteger globalMultiple;                        //多少倍可以掏空奖池
@property (nonatomic, strong) NSString *highListGame;                          //高概率排行截止期号
@property (nonatomic, strong) NSMutableAttributedString *highListAttString;    //高概率排行倒计时
@property (nonatomic, assign) NSInteger countDown;                             // 倒计时
@property (nonatomic, assign) NSInteger waitDrawed;                            // 等待开奖计时器

@property (nonatomic, assign) NSInteger gameName;            // 当前期号
@property (nonatomic, assign) NSInteger gameId;              //期号
@property (nonatomic, assign) NSInteger gameIndex;           //玩法类型
@property (nonatomic, strong) MSWeakTimer *timer;            //倒计时
@property (nonatomic, strong) NSString *switchGameString;    // 切换期号文字
@property (nonatomic, assign) BOOL hasGameInfo;              // 是否获取到了期号信息数据
@property (nonatomic, strong) PBMNumberBuy *dataBase;        //投注请求获取信息
@property (nonatomic, strong) NSMutableArray *infoArray;     //投注内容组合

- (void)pullGameInfo;    // 请求网络
- (void)parserGameInfo;
- (NSString *)logogramForMoney:(NSInteger)money;

@end

@implementation DPLTNumberViewModel
@synthesize multiple;
@synthesize followCount;
@synthesize addition;
@synthesize attStr = _attStr;
@synthesize stopAfterWin = _stopAfterWin;
@synthesize goPayFinish = _goPayFinish;
@synthesize reloginBlock = _reloginBlock;

- (instancetype)init {
    if (self = [super init]) {
        self.stopAfterWin = NO;    // 初始化
    }
    return self;
}

- (void)setupWithControllerName:(NSString *)controlName {
    self.timer = [MSWeakTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(onTimer) userInfo:controlName repeats:YES dispatchQueue:dispatch_get_main_queue()];

    self.multiple = 1;
    self.followCount = 1;
    self.countDown = 0;
    self.lastName = 0;
    self.gameName = 0;
    //    self.addition = NO;

    // 根据需求, 锁屏恢复不刷新数据 VIOS-681
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dp_ApplicationBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];

    [self pullGameInfo];
}

- (void)uninstall {
    [self.timer invalidate];
    self.timer = nil;

    self.countDown = 0;
    self.lastName = 0;
    self.gameName = 0;
    self.endTime = nil;
    self.countDownString = nil;
    self.countDownAttString = nil;
    self.bonusMoney = nil;
    self.timer = nil;
    self.switchGameString = nil;    // 切换期号文字
    self.attStr = nil;
    self.highListAttString = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dp_ApplicationBecomeActive:(NSNotification *)info {
    //    [self pullGameInfo];
}

- (NSInteger)note {
    return 0;
}

- (NSInteger)amount {
    return self.note * self.multiple * self.followCount * 2;
}

#pragma mark - 定时器
- (void)onTimer {
    // 解析底层数据, 转化为上层可用的格式
    [self parserGameInfo];

    // TODO:
    // 当前没有在请数据
    //    if (![self dpn_hasType:REFRESH]) {
    //        // 无当前期或者已经截止
    //        if (self.countDown <= 0) {
    //            [self pullGameInfo];
    //        }
    //        // 正在等待开奖, 20秒请求一次
    //        else if (self.waitDrawed > 20) {
    //            self.waitDrawed = 0;
    //            [self pullGameInfo];
    //        }
    //    }

    // 定时器通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kDPNumberTimerNotificationKey object:self];
    //    DPLog(@"onTime--------%d",(int)self.countDown);
    // 期号切换通知
    if (self.lastName != 0 && self.lastName != self.gameName) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDPNumberSwitchNotificationKey object:nil];
        DPLog(@"kDPNumberSwitchNotificationKey");
    }
}

- (void)pullGameInfo {
}
- (void)parserGameInfo {
}

- (NSMutableAttributedString *)attStr {
    if (_attStr == nil) {
        NSString *words = @"同意并勾选《代购协议》其中条款";
        _attStr = [[NSMutableAttributedString alloc] initWithString:words];
        NSRange range1 = [words rangeOfString:@"同意并勾选"];
        NSRange range2 = [words rangeOfString:@"《代购协议》"];
        NSRange range3 = [words rangeOfString:@"其中条款"];
        [_attStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xbbb3a5) range:range1];
        [_attStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x0977d5) range:range2];
        [_attStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xbbb3a5) range:range3];
        [_attStr addAttribute:NSFontAttributeName value:[UIFont dp_systemFontOfSize:12] range:NSMakeRange(0, _attStr.length)];
    }
    return _attStr;
}

// 产生随机数
- (void)partRandom:(int)count total:(int)total target2:(int *)target {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < total; i++) {
        [array addObject:[NSNumber numberWithInt:i]];
    }
    for (int i = 0; i < count; i++) {
        int x = arc4random() % ((total - i) == 0 ? 1 : (total - i));
        target[[array[x] integerValue]] = 1;
        [array removeObjectAtIndex:x];
    }
}

//得到滚存钱
- (NSString *)logogramForMoney:(NSInteger)money isLimit:(BOOL)isLimit {
    if (money < 0) {
        return @"";
    }
    NSString *tempMoney = [NSString stringWithFormat:@"%ld", money];
    NSString *string1 = @" ";
    NSString *string2 = @"元";
    if (money / 100000000.0 >= 1) {
        if (isLimit) {
            string1 = [NSString stringWithFormat:@"%.1f", [[tempMoney substringToIndex:tempMoney.length - 7] integerValue] / 10.0];
        } else {
            string1 = [NSString stringWithFormat:@"%.2f", [[tempMoney substringToIndex:tempMoney.length - 6] integerValue] / 100.0];
        }
        string2 = @"亿元";
    } else {
        if (isLimit) {
            if (money / 1000000.0 >= 1) {
                string1 = [NSString stringWithFormat:@"%.1f", [[tempMoney substringToIndex:tempMoney.length - 6] integerValue] / 10.0];
                string2 = @"千万元";
            } else {
                return [NSString stringWithFormat:@"%ld元", money];
            }
        } else {
            if (money / 10000.0 >= 1) {
                string1 = [NSString stringWithFormat:@"%ld", [[tempMoney substringToIndex:tempMoney.length - 4] integerValue]];
                string2 = @"万元";
            }
        }
    }
    return [NSString stringWithFormat:@"%@ %@", string1, string2];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [self.timer invalidate];
    [self cleanAllModelData];
    DPAssert(NO);
}

- (BOOL)isSwitchGame {
    return self.lastName != 0 && self.lastName != self.gameName;
}

- (void)switchHandled {
    self.lastName = self.gameName;
}

- (void)cleanAllModelData {
}
- (void)dp_setTogetherAndPayType:(BOOL)isTogether {
}
- (NSString *)dp_orderInfoUrl {
    return nil;
}
@end

#pragma mark - 大乐透

@implementation DPLTDltModel

- (instancetype)init {
    if (self = [super init]) {
        self.infoArray = [NSMutableArray array];
    }
    return self;
}
- (void)pullGameInfo {
    [[AFHTTPSessionManager dp_sharedManager] GET:@"/Dlt/buy"
        parameters:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
            self.dataBase = [PBMNumberBuy parseFromData:responseObject error:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kDPNumberRefreshNotificationKey object:nil];

            UIViewController *viewController = [KTMHierarchySearcher topmostViewController];

            if ([viewController isKindOfClass:[DPLBDltViewController class]] ||
                [viewController isKindOfClass:[DPLTDltViewController class]]) {
                NSDate *date = [NSDate dp_date];
                if (!self.dataBase.enable) {
                    // 停售
                    DPAlterViewController *controller = [[DPAlterViewController alloc] initWithAlterType:AlterTypeDLTNumOver];
                    [viewController dp_showViewController:controller animatorType:DPTransitionAnimatorTypeAlert completion:nil];
                } else if ((date.dp_weekday == 2 || date.dp_weekday == 4 || date.dp_weekday == 7) && (date.dp_hour == 20 && date.dp_minute <= 30)) {
                    // 期号切换
                    DPAlterViewController *controller = [[DPAlterViewController alloc] initWithAlterType:AlterTypeDLTNumChange];
                    [viewController dp_showViewController:controller animatorType:DPTransitionAnimatorTypeAlert completion:nil];
                }
            }
        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"fail");
        }];
}

- (BOOL)enable {
    return self.dataBase.enable;
}

- (NSMutableAttributedString *)createAttStr:(NSString *)baseStr timeStr:(NSString *)timeStr {
    NSString *string = [NSString stringWithFormat:@"%@%@", baseStr, timeStr];
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc] initWithString:string];
    [attributStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x666676) range:NSMakeRange(0, baseStr.length)];
    [attributStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xD14E53) range:[string rangeOfString:timeStr options:NSBackwardsSearch]];

    return attributStr;
}

- (void)parserGameInfo {
    PBMGameItem *item = self.dataBase.onsoldGame;
    self.gameId = item.gameId;
    if (self.dataBase.hasOnsoldGame) {    //当前在售
        self.endTime = [NSDate dp_dateFromString:item.endBuyTime withFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss];
        self.gameName = [item.gameName integerValue];
        self.countDown = [self.endTime dp_timeIntervalSinceNow];
        if (self.countDown > 0) {
            NSInteger hours = (self.countDown) / 3600;
            NSInteger mins = ((self.countDown) - 3600 * hours) / 60;
            NSInteger seconds = (self.countDown) - 3600 * hours - 60 * mins;

            if (hours <= 0) {
                self.countDownString = [NSString stringWithFormat:@"%02d:%02d", (int)mins, (int)seconds];
            } else {
                self.countDownString = [NSString stringWithFormat:@"%02d:%02d:%02d", (int)hours, (int)mins, (int)seconds];
            }
            NSString *timeString = [NSString stringWithFormat:@"距%zd期截止还有:%@", self.gameName, self.countDownString];
            self.countDownAttString = [[NSMutableAttributedString alloc] initWithString:timeString];
            NSRange numberRange = [timeString rangeOfString:self.countDownString options:NSCaseInsensitiveSearch];
            [self.countDownAttString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.45 green:0.37 blue:0.30 alpha:1.0] range:NSMakeRange(0, self.countDownAttString.length)];
            [self.countDownAttString addAttribute:NSForegroundColorAttributeName value:[UIColor dp_flatRedColor] range:numberRange];

            //奖池
            NSArray *array = [[self logogramForMoney:self.dataBase.globalSurplus isLimit:YES] componentsSeparatedByString:@" "];
            if (array.count >= 2) {
                NSString *money = [array objectAtIndex:0];
                NSString *danwei = [array objectAtIndex:1];
                self.bonusMoney = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"奖池 : %@%@", money, danwei]];
                [self.bonusMoney addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.45 green:0.37 blue:0.30 alpha:1.0] range:NSMakeRange(0, 5)];
                [self.bonusMoney addAttribute:NSForegroundColorAttributeName value:[UIColor dp_flatRedColor] range:NSMakeRange(5, money.length)];
                [self.bonusMoney addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.45 green:0.37 blue:0.30 alpha:1.0] range:NSMakeRange(self.bonusMoney.length - danwei.length, danwei.length)];
            }
            self.globalMultiple = self.dataBase.globalSurplus / 5000000 > 1 ? (self.dataBase.globalSurplus / 5000000) : 1;
            if (self.dataBase.globalSurplus < 5000000) {
                self.globalSurplusText = [[NSMutableAttributedString alloc] initWithString:@"可掏空奖池"];
                [self.globalSurplusText addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x816d5e) range:NSMakeRange(0, self.globalSurplusText.length)];
            } else {
                NSArray *globalArray = [[self logogramForMoney:self.dataBase.globalSurplus isLimit:NO] componentsSeparatedByString:@" "];
                if (globalArray.count >= 2) {
                    NSString *money = [globalArray objectAtIndex:0];
                    NSString *danwei = [globalArray objectAtIndex:1];
                    self.globalSurplusText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"可掏空%@%@奖池", money, danwei]];
                    [self.globalSurplusText addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x816d5e) range:NSMakeRange(0, self.globalSurplusText.length)];
                    [self.globalSurplusText addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xdb4b49) range:NSMakeRange(3, money.length)];
                }
            }

        } else {
            self.countDownString = @"期号正在获取中...";

            self.countDownAttString = [[NSMutableAttributedString alloc] initWithString:self.countDownString];
        }

    } else {
        self.endTime = nil;
        self.gameName = 0;
        self.countDown = 0;
        self.countDownString = @"期号正在获取中...";
        self.countDownAttString = [[NSMutableAttributedString alloc] initWithString:self.countDownString];
    }
}

#pragma mark - DPLTNumberMainDataSource
- (void)cleanAllModelData {
}
//获取彩种
- (NSInteger)gameType {
    return GameTypeDlt;
}
//获取标题名称
- (NSString *)gameTypeName {
    return @"大乐透中转";
}

- (Class)cellClass {
    return NSClassFromString(kSingleCellClassName);
}
- (Class)lotteryClass {
    return NSClassFromString(kDltLotteryClassName);
}
- (NSInteger)cellCount {
    return self.infoArray.count;
}
//获取过关类型
- (int)projectBetType {
    int isSingle = 0;
    int isMul = 0;
    int isDan = 0;
    for (int i = 0; i < self.infoArray.count; i++) {
        DPDltBetData *data = [self.infoArray objectAtIndex:i];
        if (data.mark) {
            isDan = 4;
        } else {
            if ([data.note integerValue] == 1) {
                isSingle = 1;
            } else {
                isMul = 2;
            }
        }
    }

    return isSingle + isDan + isMul;
}
//组装投注信息(生成订单)
- (NSString *)goBodyStrinfForPay:(NSInteger)followCount {
    NSArray *options = [self.infoArray dp_mapObjectUsingBlock:^DPDltBetStore *(DPDltBetData *obj, NSUInteger idx, BOOL *stop) {
        DPDltBetStore *store = [[DPDltBetStore alloc] init];
        store.red = obj.red;
        store.blue = obj.blue;
        return store;
    }];
    if (followCount > 1) {
        return [DPBetDescription descriptionDltWithOption:options addition:self.isAddition multiple:self.multiple followCount:followCount];
    }
    return [DPBetDescription descriptionDltWithOption:options addition:self.isAddition];
}

//生成胆拖/复式投注字符串
- (NSString *)getMulstr:(NSString *)mulStr {
    if (mulStr.length == 0) {
        return nil;
    }
    NSString *mulString = nil;
    NSArray *tempArray = [mulStr componentsSeparatedByString:@" "];
    for (int i = 0; i < tempArray.count; i++) {
        NSString *tempStr = [tempArray objectAtIndex:i];
        if (i == 0) {
            mulString = [NSString stringWithFormat:@"\\\"%@\\\"", tempStr];
        } else {
            mulString = [NSString stringWithFormat:@"%@,\\\"%@\\\"", mulString, tempStr];
        }
    }

    return mulString;
}
//获取中转页面内容的数据模型
- (id<DPLTNumberCellDataSource>)modelForCellAtIndex:(NSInteger)index {
    DPLTCellViewModel *model = model = [[DPLTCellViewModel alloc] init];
    DPDltBetData *data = [self.infoArray objectAtIndex:index];
    int blue[DLTBLUENUM] = {0}, red[DLTREDNUM] = {0}, note = [data.note intValue], mark = data.mark;
    for (int i = 0; i < DLTBLUENUM; i++) {
        blue[i] = [data.blue[i] intValue];
    }
    for (int i = 0; i < DLTREDNUM; i++) {
        red[i] = [data.red[i] intValue];
    }

    NSMutableArray *tuoNumbers = [NSMutableArray array];
    NSMutableArray *danNumbers = [NSMutableArray array];
    NSMutableArray *blueNumbers = [NSMutableArray array];
    NSMutableArray *blueDanNumbers = [NSMutableArray array];

    for (int i = 0; i < DLTBLUENUM; i++) {
        if (blue[i] < 0) {
            [blueDanNumbers addObject:[NSString stringWithFormat:@"%02d", i + 1]];
        } else if (blue[i] > 0) {
            [blueNumbers addObject:[NSString stringWithFormat:@"%02d", i + 1]];
        }
    }
    for (int i = 0; i < DLTREDNUM; i++) {
        if (red[i] > 0) {
            [tuoNumbers addObject:[NSString stringWithFormat:@"%02d", i + 1]];
        } else if (red[i] < 0) {
            [danNumbers addObject:[NSString stringWithFormat:@"%02d", i + 1]];
        }
    }
    NSString *redString = mark ? [NSString stringWithFormat:@"(%@) %@", [danNumbers componentsJoinedByString:@" "], [tuoNumbers componentsJoinedByString:@" "]] : [tuoNumbers componentsJoinedByString:@" "];    // 根据是否包含胆生成不同格式字符串
    NSString *blueString = mark ? (blueDanNumbers.count > 0 ? [NSString stringWithFormat:@"(%@) %@", [blueDanNumbers componentsJoinedByString:@" "], [blueNumbers componentsJoinedByString:@" "]] : [NSString stringWithFormat:@"%@", [blueNumbers componentsJoinedByString:@" "]]) : [blueNumbers componentsJoinedByString:@" "];
    NSString *numberString = [NSString stringWithFormat:@"%@ %@", redString, blueString];

    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:numberString];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor dp_flatRedColor] range:NSMakeRange(0, redString.length)];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor dp_flatBlueColor] range:NSMakeRange(redString.length + 1, blueString.length)];

    model.descString = [NSString stringWithFormat:@"%@ %d注 %d元", mark ? @"胆拖" : (note <= 1 ? @"单式 " : @"复式"), note, note * (self.addition ? 3 : 2)];
    model.numberString = attrString;
    return model;
}

//随机生成一注并保存在数据源里
- (void)generateNumber:(NSInteger)gameIndex {
    int red[50] = {0};
    [self partRandom:5 total:DLTREDNUM target2:red];

    int blue[50] = {0};
    [self partRandom:2 total:DLTBLUENUM target2:blue];
    if (self.infoArray == nil) {
        self.infoArray = [NSMutableArray array];
    }
    DPDltBetData *dltData = [[DPDltBetData alloc] init];
    for (int i = 0; i < 50; i++) {
        [dltData.red addObject:[NSNumber numberWithInt:red[i]]];
    }
    for (int i = 0; i < 50; i++) {
        [dltData.blue addObject:[NSNumber numberWithInt:blue[i]]];
    }

    dltData.mark = NO;
    dltData.note = [NSNumber numberWithInt:[DPNoteCalculater calcDltWithRed:red blue:blue]];
    [self.infoArray insertObject:dltData atIndex:0];
}
//从数据源删除一注
- (void)deleteSingleCellAtIndex:(NSInteger)index {
    if (index >= self.infoArray.count) {
        return;
    }
    [self.infoArray removeObjectAtIndex:index];
}

#pragma mark - DPLTNumberMutualDataSource
//获取总注数
- (NSInteger)note {
    NSInteger note = 0;
    for (int i = 0; i < self.infoArray.count; i++) {
        DPDltBetData *dltData = [self.infoArray objectAtIndex:i];
        note = note + [dltData.note intValue];
    }
    return note;
}

- (void)uninstall {
    [super uninstall];
    [self.infoArray removeAllObjects];
}

@end
