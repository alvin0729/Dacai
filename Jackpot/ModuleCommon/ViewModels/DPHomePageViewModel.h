//
//  DPHomePageViewModel.h
//  Jackpot
//
//  Created by WUFAN on 15/10/30.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPHomePageBaseModel : NSObject
@property (nonatomic, copy, readonly) NSString *cellIdentifier;
@end

//大家都在玩->彩种信息
@interface DPHomePageGameModel : DPHomePageBaseModel
@property (nonatomic, assign) BOOL enable;          // 是否在售
@property (nonatomic, strong) UIImage *gameImage;   // 彩种图标
@property (nonatomic, copy) NSString *gameTypeName; // 彩种名称
@property (nonatomic, copy) NSString *markText;     // 角标文字
@property (nonatomic, copy) NSString *secondText;   // 二级标题
@property (nonatomic, copy) NSString *thirdText;    // 三级标题
@end

//数字彩快速投注
@interface DPNumberQuickBetModel : DPHomePageBaseModel

@end

//竞彩快速投注
@interface DPSportQuickBetModel : DPHomePageBaseModel

@end

//图片事件处理
@interface DPHomeImageBaseModel : NSObject
@property (nonatomic, copy) NSString *eventURL;//点击事件地址
@property (nonatomic, copy) NSString *imageURL;//图片地址
@property (nonatomic, strong) UIImage *image;//图片
@end

//轮播图
@interface DPBannerItemModel : DPHomeImageBaseModel
@end

//资讯
@interface DPHomeLinkItemModel : DPHomeImageBaseModel
@property (nonatomic, copy) NSString *title;
@end

@protocol DPHomePageViewModelDelegate;
@interface DPHomePageViewModel : NSObject
@property (nonatomic, weak) id<DPHomePageViewModelDelegate> delegate;
@property (nonatomic, assign, readonly) NSInteger numberOfBannerItem;
@property (nonatomic, strong, readonly) DPHomeLinkItemModel *recommend;

//请求首页数据
- (void)fetch;
// 先公开，重构完成后隐藏该方法
- (void)parser:(id)message;
//获取轮播图
- (DPBannerItemModel *)bannerItemModelAtIndex:(NSInteger)index;
//获取微社区
- (DPHomeLinkItemModel *)linkItemModelAtIndex:(NSInteger)index;

- (NSInteger)sectionCount;
- (NSInteger)rowCountForIndex:(NSInteger)section;
- (CGFloat)heightForIndexPath:(NSIndexPath *)indexPath;
- (__kindof DPHomePageBaseModel *)modelForIndexPath:(NSIndexPath *)indexPath;

/**
 *  下载图片
 *
 *  @param model [in]图片对象
 */
- (void)requestImageIfNeeded:(DPHomeImageBaseModel *)model;
@end

@protocol DPHomePageViewModelDelegate <NSObject>
@required
- (void)fetchFinished:(NSError *)error;
@end
