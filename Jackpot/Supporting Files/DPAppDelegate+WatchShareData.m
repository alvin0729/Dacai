//
//  JKTAppDelegate+WatchShareData.m
//  Jackpot
//
//  Created by sxf on 15/7/28.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPAppDelegate+WatchShareData.h"
#import "DPMemberManager+Private.h"
#import "DPMemberManager.h"
#define kdiameter 25
#import "Numberbet.pbobjc.h"
#import "Wcgamelive.pbobjc.h"
//#import "AFImageDiskCache.h"

typedef enum _WatchRequestTag {

    _watchRequestDigitalResult = 1000,
    _watchRequestJczqResult = 1001,
    _watchRequestJclqResult = 1002,
    _watchRequestJczqGameLiving = 1003,
    _watchRequestJclqGameLiving = 1004,
    _watchRequestGlance = 1005,

} WatchRequestTag;

@implementation DPAppDelegate (WatchShareData)

//iphone程序给出应答
- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply {
    _imageCache = [[AFImageDiskCache alloc] init];
    self.imageQueue = [[NSOperationQueue alloc] init];
    NSString *infoString = [userInfo objectForKey:@"action"];
    if ([infoString isEqualToString:@KWatchResult]) {    //开奖公告
        [[AFHTTPSessionManager dp_sharedManager] GET:@"/draw/drawhome"
            parameters:nil
            success:^(NSURLSessionDataTask *task, id responseObject) {

                self.resultDataBase = [PBMDrawHomeList parseFromData:responseObject error:nil];
                [self resultForLottery];
            }
            failure:^(NSURLSessionDataTask *task, NSError *error){

            }];

    } else if ([infoString isEqualToString:@KWatchJczqResult]) {    //竞彩足球开奖公告
        NSString *urlString = [NSString stringWithFormat:@"/draw/GetJczqDrawDetail?gameTime=%@&gametypeid=%d&gameid=0", @"", GameTypeJcRqspf];
        [[AFHTTPSessionManager dp_sharedManager] GET:urlString
            parameters:nil
            success:^(NSURLSessionDataTask *task, id responseObject) {
                PBMDrawSportDetailList *buy = [PBMDrawSportDetailList parseFromData:responseObject error:nil];
                [self resultForJc:_watchRequestJczqResult drawList:buy];
                [self.wormhole passMessageObject:[NSNumber numberWithBool:NO] identifier:@KWatchResultJczqIsRequest];

            }
            failure:^(NSURLSessionDataTask *task, NSError *error){

            }];

    } else if ([infoString isEqualToString:@KWatchJclqResult]) {    //竞彩篮球开奖公告
        NSString *urlString = [NSString stringWithFormat:@"/draw/GetJclqDrawDetail?gameTime=%@&gametypeid=%d&gameid=0", @"", GameTypeLcRfsf];
        [[AFHTTPSessionManager dp_sharedManager] GET:urlString
            parameters:nil
            success:^(NSURLSessionDataTask *task, id responseObject) {
                PBMDrawSportDetailList *buy = [PBMDrawSportDetailList parseFromData:responseObject error:nil];
                [self resultForJc:_watchRequestJclqResult drawList:buy];
                [self.wormhole passMessageObject:[NSNumber numberWithBool:NO] identifier:@KWatchResultJczqIsRequest];

            }
            failure:^(NSURLSessionDataTask *task, NSError *error){

            }];

    } else if ([infoString isEqualToString:@KWatchJczqLiving]) {    //竞彩足球比分直播

        _imageCache = [[AFImageDiskCache alloc] init];
        NSString *urlString = @"live/GetJczqLiveMatchForWatch";
        if ([DPMemberManager sharedInstance].sessionToken.length) {
            urlString = [NSString stringWithFormat:@"live/GetJczqLiveMatchForWatch?sessionToken=%@", [DPMemberManager sharedInstance].sessionToken];
        }

        [[AFHTTPSessionManager dp_sharedManager] GET:urlString
            parameters:nil
            success:^(NSURLSessionDataTask *task, id responseObject) {
                WatchLive *dataBase = [WatchLive parseFromData:responseObject error:nil];
                [self gameLivingInfoForJczq:dataBase.matchesArray];

            }
            failure:^(NSURLSessionDataTask *task, NSError *error) {
                DPLog(@"失败了");
            }];

    } else if ([infoString isEqualToString:@KWatchJclqLiving]) {    //竞彩蓝球比分直播
        _imageCache = [[AFImageDiskCache alloc] init];
        NSString *urlString = @"live/GetJclqLiveMatchForWatch";
        if ([DPMemberManager sharedInstance].sessionToken.length) {
            urlString = [NSString stringWithFormat:@"live/GetJclqLiveMatchForWatch?sessionToken=%@", [DPMemberManager sharedInstance].sessionToken];
        }

        NSLog(@"watch:  ==> %@", [AFHTTPSessionManager dp_sharedImageManager]);
        [[AFHTTPSessionManager dp_sharedManager] GET:urlString
            parameters:nil
            success:^(NSURLSessionDataTask *task, id responseObject) {
                WatchLive *dataBase = [WatchLive parseFromData:responseObject error:nil];
                [self gameLivingInfoForJclq:dataBase.matchesArray];

            }
            failure:^(NSURLSessionDataTask *task, NSError *error) {
                DPLog(@"失败了");
            }];

    } else if ([infoString isEqualToString:@KWatchGlance]) {    //平衡界面
        [[AFHTTPSessionManager dp_sharedManager] GET:@"/Dlt/buy"
            parameters:nil
            success:^(NSURLSessionDataTask *task, id responseObject) {

                PBMNumberBuy *dataBase = [PBMNumberBuy parseFromData:responseObject error:nil];
                [self.wormhole passMessageObject:[NSNumber numberWithInteger:dataBase.globalSurplus] identifier:@KWatchGlaceBonus];
            }
            failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"fail");
            }];
    }

    reply([NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:YES], @"request", nil]);
}

//获取开奖信息（竞彩足球，竞彩篮球单独处理）
- (void)resultForLottery {
    for (int i = 0; i < self.resultDataBase.itemsArray.count; i++) {
        PBMDrawHomeList_Item *item = [self.resultDataBase.itemsArray objectAtIndex:i];
        switch (item.gameType) {
            case GameTypeDlt: {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                NSString *tempString = [item.resluts stringByReplacingOccurrencesOfString:@"|" withString:@","];
                [dic setObject:[tempString componentsSeparatedByString:@","] forKey:@KWatchResultDltDrawing];
                [dic setObject:item.gameName forKey:@KWatchResultDltIssue];
                [dic setObject:item.drawTime forKey:@KWatchResultDltDrawTime];
                [self.wormhole passMessageObject:dic identifier:@KWatchResultDlt];
            } break;
            case GameTypeSsq: {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                NSString *tempString = [item.resluts stringByReplacingOccurrencesOfString:@"|" withString:@","];
                [dic setObject:[tempString componentsSeparatedByString:@","] forKey:@KWatchResultSsqDrawing];
                [dic setObject:item.gameName forKey:@KWatchResultSsqIssue];
                [dic setObject:item.drawTime forKey:@KWatchResultSsqDrawTime];
                [self.wormhole passMessageObject:dic identifier:@KWatchResultSsq];
            } break;
            case GameTypeZc14: {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                if (item.resluts.length == 14) {
                    [dic setObject:[self stringTransferToArray:item.resluts] forKey:@KWatchResultSfcDrawing];
                }
                [dic setObject:item.gameName forKey:@KWatchResultSfcIssue];
                [dic setObject:item.drawTime forKey:@KWatchResultSfcDrawTime];
                [self.wormhole passMessageObject:dic identifier:@KWatchResultSfc];

            } break;
            case GameTypeSd: {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                NSString *tempString = @"";
                if (item.resluts.length >= 3) {
                    tempString = [item.resluts substringToIndex:3];
                }
                [dic setObject:[self stringTransferToArray:tempString] forKey:@KWatchResultFc3dDrawing];
                [dic setObject:item.gameName forKey:@KWatchResultFc3dIssue];
                [dic setObject:item.drawTime forKey:@KWatchResultFc3dDrawTime];
                [self.wormhole passMessageObject:dic identifier:@KWatchResultFc3d];
            } break;
            case GameTypePs: {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                if (item.resluts.length == 3) {
                    [dic setObject:[self stringTransferToArray:item.resluts] forKey:@KWatchResultPl3Drawing];
                }
                [dic setObject:item.gameName forKey:@KWatchResultPl3Issue];
                [dic setObject:item.drawTime forKey:@KWatchResultPl3DrawTime];
                [self.wormhole passMessageObject:dic identifier:@KWatchResultPl3];

            } break;
            case GameTypePw: {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                if (item.resluts.length == 5) {
                    [dic setObject:[self stringTransferToArray:item.resluts] forKey:@KWatchResultPl5Drawing];
                }
                [dic setObject:item.gameName forKey:@KWatchResultPl5Issue];
                [dic setObject:item.drawTime forKey:@KWatchResultPl5DrawTime];
                [self.wormhole passMessageObject:dic identifier:@KWatchResultPl5];
            } break;
            case GameTypeQxc: {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                if (item.resluts.length == 7) {
                    [dic setObject:[self stringTransferToArray:item.resluts] forKey:@KWatchResultQxcDrawing];
                }
                [dic setObject:item.gameName forKey:@KWatchResultQxcIssue];
                [dic setObject:item.drawTime forKey:@KWatchResultQxcDrawTime];
                [self.wormhole passMessageObject:dic identifier:@KWatchResultQxc];
            } break;
            case GameTypeQlc: {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                NSString *tempString = [item.resluts stringByReplacingOccurrencesOfString:@"|" withString:@","];
                [dic setObject:[tempString componentsSeparatedByString:@","] forKey:@KWatchResultQlcDrawing];
                [dic setObject:item.gameName forKey:@KWatchResultQlcIssue];
                [dic setObject:item.drawTime forKey:@KWatchResultQlcDrawTime];
                [self.wormhole passMessageObject:dic identifier:@KWatchResultQlc];
            } break;
            default:
                break;
        }
    }
}
//没有间隔的字符串按字符转为NSArry;
- (NSMutableArray *)stringTransferToArray:(NSString *)string {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < string.length; i++) {
        NSString *tempString = [string substringWithRange:NSMakeRange(i, 1)];
        [array addObject:tempString];
    }
    return array;
}
//获取竞彩足球开奖信息
- (void)resultForJc:(int)watchRequest drawList:(PBMDrawSportDetailList *)drawList {
    NSString *gameNameString = [NSString stringWithFormat:@"●%@", [NSDate dp_coverDateString:drawList.gameName fromFormat:@"YYYYMMdd" toFormat:@"MM-dd  EEEE"]];

    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < drawList.itemsArray.count; i++) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];

        PBMDrawSportDetailList_Item *item = [drawList.itemsArray objectAtIndex:i];
        [dic setObject:item.homeName forKey:@KWatchResultJcHomeName];
        [dic setObject:item.awayName forKey:@KWatchResultJcAwayName];
        if (item.homeScore < 0 || item.awayScore < 0) {
            [dic setObject:@"- : -" forKey:@KWatchResultJcScore];
        } else {
            [dic setObject:watchRequest == _watchRequestJczqResult ? [NSString stringWithFormat:@"%d : %d", item.homeScore, item.awayScore] : [NSString stringWithFormat:@"%d : %d", item.awayScore, item.homeScore] forKey:@KWatchResultJcScore];
        }

        [dic setObject:AFImageDiskCachePathFromURL(item.homeURL) forKey:@KWatchGameLiveHomeUrl];
        [dic setObject:AFImageDiskCachePathFromURL(item.awayURL) forKey:@KWatchGameLiveAwayUrl];
        [dic setObject:item.homeURL forKey:@"homelogo"];
        [dic setObject:item.awayURL forKey:@"awaylogo"];
        [array addObject:dic];

    }
    if (watchRequest == _watchRequestJczqResult) {
        [self.wormhole passMessageObject:[NSNumber numberWithInteger:-1] identifier:@KWatchJczqResultIndex];
        [self.wormhole passMessageObject:array identifier:@KWatchResultJczqArray];
        [self.wormhole passMessageObject:gameNameString identifier:@KWatchResultJczqGameName];
        for (int i = 0; i < array.count; i++) {
            NSMutableDictionary *dic = [array objectAtIndex:i];
            [self requestImageIfNeeded:YES index:i iconImageUrl:[dic objectForKey:@KWatchGameLiveHomeUrl] requestType:_watchRequestJczqResult];
            [self requestImageIfNeeded:NO index:i iconImageUrl:[dic objectForKey:@KWatchGameLiveAwayUrl] requestType:_watchRequestJczqResult];
        }

    } else if (watchRequest == _watchRequestJclqResult) {
        [self.wormhole passMessageObject:[NSNumber numberWithInteger:-1] identifier:@KWatchJclqResultIndex];
        [self.wormhole passMessageObject:array identifier:@KWatchResultJclqArray];
        [self.wormhole passMessageObject:gameNameString identifier:@KWatchResultJclqGameName];
        for (int i = 0; i < array.count; i++) {
            NSMutableDictionary *dic = [array objectAtIndex:i];
            [self requestImageIfNeeded:YES index:i iconImageUrl:[dic objectForKey:@KWatchGameLiveHomeUrl] requestType:_watchRequestJclqResult];
            [self requestImageIfNeeded:NO index:i iconImageUrl:[dic objectForKey:@KWatchGameLiveAwayUrl] requestType:_watchRequestJclqResult];
        }
    }
}

- (void)requestImageIfNeeded:(BOOL)isHome                //是否主队
                       index:(NSInteger)index            //在数组中的位置
                iconImageUrl:(NSString *)imageURL    //队名下载地址
                 requestType:(int)requestType
 {
    if (imageURL) {
        UIImage *image = [[AFImageDiskCache sharedCache] cachedImageForURL:imageURL];
        if (image) {
            if (requestType==_watchRequestJczqGameLiving) {
                [self.wormhole passMessageObject:[NSNumber numberWithInteger:isHome?(index+1):(-index-1)] identifier:@KWatchIconIndex];
            }else if(requestType==_watchRequestJclqGameLiving){
                [self.wormhole passMessageObject:[NSNumber numberWithInteger:isHome?(index+1):(-index-1)] identifier:@KWatchJclqIconIndex];
            }else if(requestType==_watchRequestJczqResult){
                [self.wormhole passMessageObject:[NSNumber numberWithInteger:isHome?(index+1):(-index-1)] identifier:@KWatchZqRequestIconIndex];
            }else if(requestType==_watchRequestJclqResult){
                [self.wormhole passMessageObject:[NSNumber numberWithInteger:isHome?(index+1):(-index-1)] identifier:@KWatchLqRequestIconIndex];
            }

            return;
        }
        
        [[AFHTTPSessionManager dp_sharedImageManager] GET:imageURL
            parameters:nil
            success:^(NSURLSessionDataTask *task, id responseObject) {
                [[AFImageDiskCache sharedCache] cacheImage:responseObject forURL:imageURL];
                if (requestType == _watchRequestJczqGameLiving) {
                    [self.wormhole passMessageObject:[NSNumber numberWithInteger:isHome ? (index + 1) : (-index - 1)] identifier:@KWatchIconIndex];
                } else if (requestType == _watchRequestJclqGameLiving) {
                    [self.wormhole passMessageObject:[NSNumber numberWithInteger:isHome ? (index + 1) : (-index - 1)] identifier:@KWatchJclqIconIndex];
                } else if (requestType == _watchRequestJczqResult) {
                    [self.wormhole passMessageObject:[NSNumber numberWithInteger:isHome ? (index + 1) : (-index - 1)] identifier:@KWatchZqRequestIconIndex];
                } else if (requestType == _watchRequestJclqResult) {
                    [self.wormhole passMessageObject:[NSNumber numberWithInteger:isHome ? (index + 1) : (-index - 1)] identifier:@KWatchLqRequestIconIndex];
                }


            }
            failure:^(NSURLSessionDataTask *task, NSError *error) {
                DPLog(@"sss");
            }];
    }
}

//获取竞彩足球比分直播信息
- (void)gameLivingInfoForJczq:(NSArray *)matchArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < matchArray.count; i++) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        WatchLive_MatchItem *item = [matchArray objectAtIndex:i];
        NSString *time = @"";
        NSString *score = [NSString stringWithFormat:@"%d : %d", item.homeScore, item.awayScore];
        // 比赛进行状态
        switch (item.matchState) {
            case 0: {
                time = [NSDate dp_coverDateString:item.startTime fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:dp_DateFormatter_HH_mm];
                score = @"VS";
            } break;
            case 11: {
                NSTimeInterval timespan = [[NSDate dp_date] timeIntervalSinceDate:[NSDate dp_dateFromString:item.startTime withFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss]];

                timespan /= 60;
                if (timespan < 0) {
                    timespan = 0;
                }
                if (timespan > 45) {
                    time = @"45+";
                } else {
                    time = [NSString stringWithFormat:@"%ld", (long)(int)timespan];
                }
                break;
            }
            case 21:
                time = @"中场";
                break;
            case 31: {
                NSTimeInterval timespan = [[NSDate dp_date] timeIntervalSinceDate:[NSDate dp_dateFromString:item.startTime withFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss]];
                timespan /= 60;
                if (timespan < 0) {
                    timespan = 0;
                }
                if (timespan > 45) {
                    time = @"90+";
                } else {
                    time = [NSString stringWithFormat:@"%d", 45 + (int)timespan];
                }
                break;
            }
            case 41:
                time = @"已结束";
                break;
            case 95:
                time = @"中断";
                break;
            case 96:
                time = @"待定";
                break;
            case 97:
                time = @"腰折";
                break;
            case 98:
                time = @"推迟";
                break;
            case 99:
                time = @"已取消";
                break;
            default:
                break;
        }

        [dic setObject:item.homeName forKey:@KWatchGameLivingHomeName];
        [dic setObject:item.awayName forKey:@KWatchGameLivingAwayName];
        [dic setObject:AFImageDiskCachePathFromURL(item.homeLogo) forKey:@KWatchGameLiveHomeUrl];
        [dic setObject:AFImageDiskCachePathFromURL(item.awayLogo) forKey:@KWatchGameLiveAwayUrl];
        [dic setObject:item.homeLogo forKey:@"homelogo"];
        [dic setObject:item.awayLogo forKey:@"awaylogo"];
        [dic setObject:time forKey:@KWatchGameLivingTime];
        [dic setObject:[NSDate dp_coverDateString:item.startTime fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:@"MM-dd EEEE"] forKey:@KWatchGameLivingStartTime];
        [dic setObject:score forKey:@KWatchGameLivingScore];
        [array addObject:dic];
    }
    [self.wormhole passMessageObject:array identifier:@KWatchJCzqGameLivingArray];
    for (int i = 0; i < array.count; i++) {
        NSMutableDictionary *dic = [array objectAtIndex:i];
        [self requestImageIfNeeded:YES index:i iconImageUrl:[dic objectForKey:@"homelogo"] requestType:_watchRequestJczqGameLiving];
        [self requestImageIfNeeded:NO index:i iconImageUrl:[dic objectForKey:@"awaylogo"] requestType:_watchRequestJczqGameLiving];
    }
}

//获取竞彩篮球比分直播信息
- (void)gameLivingInfoForJclq:(NSArray *)matchArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < matchArray.count; i++) {
        WatchLive_MatchItem *item = [matchArray objectAtIndex:i];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        NSString *time = [self gameLiveMatchForLC:item.matchState onTime:item.onTime startTime:item.startTime];

        NSString *score = [NSString stringWithFormat:@"%d : %d", item.awayScore, item.homeScore];
        if (item.matchState == 0) {
            score = @"VS";
        }
        [dic setObject:item.homeName forKey:@KWatchGameLivingHomeName];
        [dic setObject:item.awayName forKey:@KWatchGameLivingAwayName];

        [dic setObject:AFImageDiskCachePathFromURL(item.homeLogo) forKey:@KWatchGameLiveHomeUrl];
        [dic setObject:AFImageDiskCachePathFromURL(item.awayLogo) forKey:@KWatchGameLiveAwayUrl];
        [dic setObject:item.homeLogo forKey:@"homelogo"];
        [dic setObject:item.awayLogo forKey:@"awaylogo"];
        [dic setObject:time forKey:@KWatchGameLivingTime];
        [dic setObject:score forKey:@KWatchGameLivingScore];
        [dic setObject:[NSDate dp_coverDateString:item.startTime fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:@"MM-dd EEEE"] forKey:@KWatchGameLivingStartTime];
        [array addObject:dic];
    }
    [self.wormhole passMessageObject:array identifier:@KWatchJClqGameLivingArray];
    for (int i = 0; i < array.count; i++) {
        NSMutableDictionary *dic = [array objectAtIndex:i];
        [self requestImageIfNeeded:YES index:i iconImageUrl:[dic objectForKey:@"homelogo"] requestType:_watchRequestJclqGameLiving];
        [self requestImageIfNeeded:NO index:i iconImageUrl:[dic objectForKey:@"awaylogo"] requestType:_watchRequestJclqGameLiving];
    }
}

- (NSString *)gameLiveMatchForLC:(NSInteger)matchState onTime:(NSString *)ontime startTime:(NSString *)startTime {
    switch (matchState) {
        case 0:
            return [NSDate dp_coverDateString:startTime fromFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss toFormat:@"hh:mm"];
        case -1:
            return @"第一节休息";
        case -2:
            return @"中场休息";
        case -3:
            return @"第三节休息";
        case -4:
            return @"第四节休息";
        case 9:
        case 11:
            return @"已结束";
        default:
            return ontime;
    }
}
/*
- (void)UpDateGameLivingImage:(BOOL)isHome                //是否主队
                        index:(NSInteger)index            //在数组中的位置
                 iconImageUrl:(NSString *)IcomImageUrl    //队名下载地址
                  requestType:(int)requestType

{
    NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:IcomImageUrl]];
    UIImage *currenentimage = [[AFImageDiskCache sharedCache] cachedImageForURL:IcomImageUrl];
//    NSMutableDictionary *dic = [self.wormhole messageWithIdentifier:@KWatchIconCache];
//    if (dic == nil) {
//        dic = [[NSMutableDictionary alloc] init];
//    }
    if (currenentimage) {
////        [dic setObject:currenentimage forKey:IcomImageUrl];
//        //            [self.wormhole passMessageObject:dic identifier:@KWatchIconCache];
//        if (requestType == _watchRequestJczqGameLiving) {
//            [self.wormhole passMessageObject:[NSNumber numberWithInteger:isHome ? (index + 1) : (-index - 1)] identifier:@KWatchIconIndex];
//        } else if (requestType == _watchRequestJclqGameLiving) {
//            [self.wormhole passMessageObject:[NSNumber numberWithInteger:isHome ? (index + 1) : (-index - 1)] identifier:@KWatchJclqIconIndex];
//        } else if (requestType == _watchRequestJczqResult) {
//            [self.wormhole passMessageObject:[NSNumber numberWithInteger:isHome ? (index + 1) : (-index - 1)] identifier:@KWatchZqRequestIconIndex];
//        } else if (requestType == _watchRequestJclqResult) {
//            [self.wormhole passMessageObject:[NSNumber numberWithInteger:isHome ? (index + 1) : (-index - 1)] identifier:@KWatchLqRequestIconIndex];
//        }
    } else {
        __weak __typeof(self) weakSelf = self;

        AFHTTPRequestOperation *operation =
            [[AFHTTPRequestOperation alloc] initWithRequest:requset];
        operation.responseSerializer = [AFImageResponseSerializer serializer];

        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation
                                                       *operation,
                                                   id responseObject) {
            [weakSelf.imageCache cacheImage:responseObject
                                 forRequest:operation.request];
//            [dic setObject:responseObject forKey:IcomImageUrl];
            //                [self.wormhole passMessageObject:dic identifier:@KWatchIconCache];
            [[AFImageDiskCache sharedCache] cacheImage:responseObject forURL:IcomImageUrl];
            if (requestType == _watchRequestJczqGameLiving) {
                [self.wormhole passMessageObject:[NSNumber numberWithInteger:isHome ? (index + 1) : (-index - 1)] identifier:@KWatchIconIndex];
            } else if (requestType == _watchRequestJclqGameLiving) {
                [self.wormhole passMessageObject:[NSNumber numberWithInteger:isHome ? (index + 1) : (-index - 1)] identifier:@KWatchJclqIconIndex];
            } else if (requestType == _watchRequestJczqResult) {
                [self.wormhole passMessageObject:[NSNumber numberWithInteger:isHome ? (index + 1) : (-index - 1)] identifier:@KWatchZqRequestIconIndex];
            } else if (requestType == _watchRequestJclqResult) {
                [self.wormhole passMessageObject:[NSNumber numberWithInteger:isHome ? (index + 1) : (-index - 1)] identifier:@KWatchLqRequestIconIndex];
            }

        }
            failure:^(AFHTTPRequestOperation *operation, NSError *error){
         
            }];
        [self.imageQueue addOperation:operation];
    }
}
 */

- (UIImage *)maskImageWithImage:(UIImage *)image diameter:(CGFloat)diameter {
    CGFloat width = CGImageGetWidth(image.CGImage);
    CGFloat height = CGImageGetHeight(image.CGImage);

    CGSize resize;
    CGRect cropRect = CGRectMake(0, 0, diameter, diameter);
    if (width > height) {
        resize.height = diameter;
        resize.width = diameter / height * width;

        cropRect.origin = CGPointMake((resize.width - diameter) / 2, 0);
    } else {
        resize.width = diameter;
        resize.height = diameter / width * height;

        cropRect.origin = CGPointMake(0, (resize.height - diameter) / 2);
    }

    UIGraphicsBeginImageContextWithOptions(cropRect.size, NO, image.scale);
    CGRect bounds = (CGRect){CGPointZero, cropRect.size};
    [[UIBezierPath bezierPathWithRoundedRect:bounds
                                cornerRadius:diameter / 2] addClip];
    [image drawInRect:bounds];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return finalImage;
}

- (void)getDataBufWithUrlStr:(NSString *)urlStr complete:(void (^)(id obj))complete error:(void (^)(id obj))errorBlock {
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *str = [NSString stringWithFormat:@"http://10.12.2.37:99/%@", urlStr];

    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        complete(responseObject);

    }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"abc");
            errorBlock(error);
        }];
}

@end
