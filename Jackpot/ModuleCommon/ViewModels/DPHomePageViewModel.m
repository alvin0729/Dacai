//
//  DPHomePageViewModel.m
//  Jackpot
//
//  Created by WUFAN on 15/10/30.
//  Copyright © 2015年 dacai. All rights reserved.
//  本页注释由sxf提供，如有更改，请标明

#import "DPHomePageViewModel.h"
#import "Home.pbobjc.h"

//数字彩快速投注
@interface DPNumberQuickBetModel ()
@property (nonatomic, strong) NSDate *endTime;//截止时间
@property (nonatomic, assign) NSInteger gameId;//彩种id
@property (nonatomic, copy) NSString *gameName;//彩种期号
@end

//竞彩快速投注
@interface DPSportQuickBetModel ()
@property (nonatomic, assign) NSInteger gameId;// 期号id
@property (nonatomic, assign) NSInteger gameMatchId;// 比赛id
@property (nonatomic, assign) NSInteger gameType;//彩种
@property (nonatomic, strong) NSDate *endTime;// 截至时间
@property (nonatomic, strong) NSArray<NSString *> *spList;// sp值
@property (nonatomic, strong) NSArray<NSString *> *rateList;// 投注比例
@property (nonatomic, copy) NSString *balacne;// 平衡因子 - 让球数, 让分, 总分
@property (nonatomic, copy) NSString *gameName;// 期号
@property (nonatomic, copy) NSString *title;// 标题
@property (nonatomic, copy) NSString *homeName;// 主队名
@property (nonatomic, copy) NSString *awayName;// 客队名
@property (nonatomic, copy) NSString *orderName;// 比赛序号
@end

@interface DPHomeImageBaseModel ()
@property (nonatomic, strong) NSURLSessionDataTask *task;

- (void)dealWithImage:(UIImage *)image;
@end

@interface DPHomePageViewModel ()
@property (nonatomic, strong) DPHomePageGameModel *lotteryDlt;//大乐透
@property (nonatomic, strong) DPHomePageGameModel *lotteryJczq;//竞彩足球
@property (nonatomic, strong) DPHomePageGameModel *lotteryJclq;//竞彩篮球
@property (nonatomic, strong) DPNumberQuickBetModel *numberQuick;//数字彩快速投注
@property (nonatomic, strong) DPSportQuickBetModel *sportQuick;//竞彩快速投注

@property (nonatomic, strong) DPHomeLinkItemModel *recommend;//资讯
@property (nonatomic, strong) NSArray<DPBannerItemModel *> *bannerItems;//轮播图
@property (nonatomic, strong) NSMutableArray<DPHomeLinkItemModel *> *communityItems;//微社区
@end

@implementation DPHomePageViewModel

- (instancetype)init {
    if (self = [super init]) {
        _lotteryDlt = [[DPHomePageGameModel alloc] init];
        _lotteryJczq = [[DPHomePageGameModel alloc] init];
        _lotteryJclq = [[DPHomePageGameModel alloc] init];
        _numberQuick = [[DPNumberQuickBetModel alloc] init];
        _sportQuick  =[[DPSportQuickBetModel alloc] init];
        
        _lotteryDlt.gameTypeName = @"大乐透";
        _lotteryJczq.gameTypeName = @"竞彩足球";
        _lotteryJclq.gameTypeName = @"竞彩篮球";
        
        
        DPHomeLinkItemModel *(^linkItem)(NSString *, UIImage *, NSString *) = ^DPHomeLinkItemModel *(NSString *title, UIImage *image, NSString *event) {
            DPHomeLinkItemModel *model = [[DPHomeLinkItemModel alloc] init];
            model.image = image;
            model.title = title;
            model.eventURL = event;
            return model;
        };
        _communityItems = @[linkItem(@"晒单广场", dp_AppRootImage(@"communityImage1.png"), @""),
                            linkItem(@"女神推号", dp_AppRootImage(@"communityImage2.png"), @""),
                            linkItem(@"今日运势", dp_AppRootImage(@"communityImage3.png"), @"")].mutableCopy;
    }
    return self;
}
//请求首页数据
- (void)fetch {
    [[AFHTTPSessionManager dp_sharedManager] GET:@"home/buy"
        parameters:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
            PBMHomePage *homePage = [PBMHomePage parseFromData:responseObject error:nil];

            NSLog(@"....");
        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
        }];
}

#pragma mark - Public Interface

- (NSInteger)sectionCount {
    return 0;
}

- (NSInteger)rowCountForIndex:(NSInteger)section {
    
    return 0;
}

- (CGFloat)heightForIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (__kindof DPHomePageBaseModel *)modelForIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


- (void)parser:(PBMHomePage *)homePage {
    self.lotteryDlt.markText = homePage.lotteryDlt.mark;
    self.lotteryDlt.secondText = homePage.lotteryDlt.title;
    self.lotteryDlt.thirdText = homePage.lotteryDlt.hasDesc ? [NSString stringWithFormat:@"%@, 参与人数: %d", homePage.lotteryDlt.desc, homePage.lotteryDlt.count] : [NSString stringWithFormat:@"%d", homePage.lotteryDlt.count];
    
    self.lotteryJczq.markText = homePage.lotteryJczq.mark;
    self.lotteryJczq.secondText = homePage.lotteryJczq.title;
    self.lotteryJczq.thirdText = homePage.lotteryJczq.hasDesc ? [NSString stringWithFormat:@"%@, 参与人数: %d", homePage.lotteryJczq.desc, homePage.lotteryJczq.count] : [NSString stringWithFormat:@"%d", homePage.lotteryJczq.count];
    
    self.lotteryJclq.markText = homePage.lotteryJclq.mark;
    self.lotteryJclq.secondText = homePage.lotteryJclq.title;
    self.lotteryJclq.thirdText = homePage.lotteryJclq.hasDesc ? [NSString stringWithFormat:@"%@, 参与人数: %d", homePage.lotteryJclq.desc, homePage.lotteryJclq.count] : [NSString stringWithFormat:@"%d", homePage.lotteryJclq.count];
    
    // 轮播图
    self.bannerItems = [homePage.bannersArray dp_mapObjectUsingBlock:^id(PBMHomePage_BannerItem *item, NSUInteger idx, BOOL *stop) {
        DPBannerItemModel *model = [[DPBannerItemModel alloc] init];
        model.imageURL = item.imageURL;
        model.eventURL = item.event;
        return model;
    }];
    // 资讯
    self.recommend = ({
        DPHomeLinkItemModel *model = [[DPHomeLinkItemModel alloc] init];
        model.imageURL = homePage.recommend.image;
        model.eventURL = homePage.recommend.event;
        model.title = homePage.recommend.title;
        model;
    });
    // 社区
    for (int i = 0; i < 3 && i < homePage.communityAreaArray.count; i++) {
        PBMHomePage_LinkItem *item = homePage.communityAreaArray[i];
        DPHomeLinkItemModel *model = [[DPHomeLinkItemModel alloc] init];
        model.imageURL = item.image;
        model.eventURL = item.event;
        model.title = item.title;
        self.communityItems[i] = model;
    }
}
//获取轮播图
- (DPBannerItemModel *)bannerItemModelAtIndex:(NSInteger)index {
    NSAssert(index < self.numberOfBannerItem, @"out of bounds...");
    return self.bannerItems[index];
}
//获取微社区
- (DPHomeLinkItemModel *)linkItemModelAtIndex:(NSInteger)index {
    NSAssert(index < 3, @"out of bounds...");
    return self.communityItems[index];
}
//下载图片
- (void)requestImageIfNeeded:(DPHomeImageBaseModel *)model {
    if (!model.image && !model.task && model.imageURL) {
        UIImage *image = [[AFImageDiskCache sharedCache] cachedImageForURL:model.imageURL];
        if (image) {
            [model dealWithImage:image];
            return;
        }
        
        @weakify(model);
        model.task = [[AFHTTPSessionManager dp_sharedImageManager] GET:model.imageURL
            parameters:nil
            success:^(NSURLSessionDataTask *task, id responseObject) {
                @strongify(model);
                [[AFImageDiskCache sharedCache] cacheImage:responseObject forURL:model.imageURL];
                [model dealWithImage:responseObject];
                model.task = nil;
            }
            failure:^(NSURLSessionDataTask *task, NSError *error) {
                @strongify(model);
                model.task = nil;
            }];
    }
}

#pragma mark - Property (getter, setter)

- (NSInteger)numberOfBannerItem {
    return self.bannerItems.count;
}

@end

@implementation DPHomePageGameModel

@end

@implementation DPHomePageBaseModel

@end

@implementation DPSportQuickBetModel

@end

@implementation DPNumberQuickBetModel

@end

@implementation DPHomeImageBaseModel

- (void)dealWithImage:(UIImage *)image {
    self.image = image;
}

- (void)dealloc {
    [self.task cancel];
}

@end

@implementation DPBannerItemModel

@end

@implementation DPHomeLinkItemModel

@end
