//
//  HelperMacro.h
//  DacaiProject
//
//  Created by WUFAN on 14-7-17.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#ifndef __DacaiProject_HelperMacro_H__
#define __DacaiProject_HelperMacro_H__

// 图片文件夹路径
#define kImageBundlePath                [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images"]

#define kCommonImageBundlePath          [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/Common"]
#define kNavigationImageBundlePath      [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/Navigation"]
#define kDigitLotteryImageBundlePath    [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/DigitLottery"]
#define kSportLotteryImageBundlePath    [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/SportLottery"]
 #define kAccountImageBundlePath         [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/Account"]
#define kProjectBundlePath              [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/Project"]
#define kLotteryResultBundlePath        [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/LotteryResult"]
#define kAppRootBundlePath              [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/AppRoot"]
#define kSportLiveBundlePath            [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/SportLive"]
#define kTogetherBuyBundlePath          [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/TogetherBuy"]
#define kRedPacketBundlePath            [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/RedPacket"]
#define kBankIconImageBundlePath        [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/BankIcon"]
#define kStartupImageBundlePath         [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/Startup"]
#define kGameLiveImageBundlePath    [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/GameLive"]
#define kNumberHighListBundlePath    [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/NumberHighList"]
#define kGropSysytemFeedbackBundlePath    [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/Feedback"]
#define kGropSysytemBundlePath    [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/GropSystem"]
#define kLoadingBundlePath    [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/Loading"]
#define kHeartLoveBundlePath    [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"DacaiResource.bundle/Images/HeartLove"]
// 图片路径
#define dp_ImagePath(bundlePath, name)      [bundlePath stringByAppendingPathComponent:name]

// 图片
#define dp_CommonImage(name)                [UIImage dp_retinaImageNamed:dp_ImagePath(kCommonImageBundlePath, name)]
#define dp_NavigationImage(name)            [UIImage dp_retinaImageNamed:dp_ImagePath(kNavigationImageBundlePath, name)]
#define dp_SportLotteryImage(name)          [UIImage dp_retinaImageNamed:dp_ImagePath(kSportLotteryImageBundlePath, name)]
#define dp_DigitLotteryImage(name)          [UIImage dp_retinaImageNamed:dp_ImagePath(kDigitLotteryImageBundlePath, name)]
#define dp_AccountImage(name)               [UIImage dp_retinaImageNamed:dp_ImagePath(kAccountImageBundlePath, name)]
#define dp_ProjectImage(name)               [UIImage dp_retinaImageNamed:dp_ImagePath(kProjectBundlePath, name)]
#define dp_ResultImage(name)                [UIImage dp_retinaImageNamed:dp_ImagePath(kLotteryResultBundlePath, name)]
#define dp_AppRootImage(name)               [UIImage dp_retinaImageNamed:dp_ImagePath(kAppRootBundlePath, name)]
#define dp_SportLiveImage(name)             [UIImage dp_retinaImageNamed:dp_ImagePath(kSportLiveBundlePath, name)]
#define dp_TogetherBuyImage(name)           [UIImage dp_retinaImageNamed:dp_ImagePath(kTogetherBuyBundlePath, name)]
#define dp_RedPacketImage(name)             [UIImage dp_retinaImageNamed:dp_ImagePath(kRedPacketBundlePath, name)]
#define dp_BankIconImage(name)              [UIImage dp_retinaImageNamed:dp_ImagePath(kBankIconImageBundlePath, name)]
#define dp_GameLiveImage(name)              [UIImage dp_retinaImageNamed:dp_ImagePath(kGameLiveImageBundlePath, name)]
#define dp_NumberHighList(name)             [UIImage dp_retinaImageNamed:dp_ImagePath(kNumberHighListBundlePath, name)]
#define dp_LoadingImage(name)               [UIImage dp_retinaImageNamed:dp_ImagePath(kLoadingBundlePath, name)]
#define dp_HeartLoveImage(name)             [UIImage dp_retinaImageNamed:dp_ImagePath(kHeartLoveBundlePath, name)]

#define dp_CommonResizeImage(name)          [UIImage dp_resizeImageNamed:dp_ImagePath(kCommonImageBundlePath, name)]
#define dp_NavigationResizeImage(name)      [UIImage dp_resizeImageNamed:dp_ImagePath(kNavigationImageBundlePath, name)]
#define dp_SportLotteryResizeImage(name)    [UIImage dp_resizeImageNamed:dp_ImagePath(kSportLotteryImageBundlePath, name)]
#define dp_DigitLotteryResizeImage(name)    [UIImage dp_resizeImageNamed:dp_ImagePath(kDigitLotteryImageBundlePath, name)]
#define dp_AccountResizeImage(name)         [UIImage dp_resizeImageNamed:dp_ImagePath(kAccountImageBundlePath, name)]
#define dp_ProjectResizeImage(name)         [UIImage dp_resizeImageNamed:dp_ImagePath(kProjectBundlePath, name)]
#define dp_ResultResizeImage(name)          [UIImage dp_resizeImageNamed:dp_ImagePath(kLotteryResultBundlePath, name)]
#define dp_AppRootResizeImage(name)         [UIImage dp_resizeImageNamed:dp_ImagePath(kAppRootBundlePath, name)]
#define dp_SportLiveResizeImage(name)       [UIImage dp_resizeImageNamed:dp_ImagePath(kSportLiveBundlePath, name)]
#define dp_TogetherBuyResizeImage(name)     [UIImage dp_resizeImageNamed:dp_ImagePath(kTogetherBuyBundlePath, name)]
#define dp_BankIconResizeImage(name)        [UIImage dp_resizeImageNamed:dp_ImagePath(kBankIconImageBundlePath, name)]
#define dp_RedPackertResizeImage(name)      [UIImage dp_resizeImageNamed:dp_ImagePath(kRedPacketBundlePath, name)]
#define dp_GameLiveResizeImage(name)        [UIImage dp_resizeImageNamed:dp_ImagePath(kGameLiveImageBundlePath, name)]
#define dp_FeedbackResizeImage(name)        [UIImage dp_resizeImageNamed:dp_ImagePath(kGropSysytemFeedbackBundlePath, name)]
#define dp_GropSystemResizeImage(name)      [UIImage dp_resizeImageNamed:dp_ImagePath(kGropSysytemBundlePath, name)]

#endif
