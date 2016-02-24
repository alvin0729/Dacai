//
//  DPTrendSettingView.h
//  DacaiProject
//
//  Created by wufan on 15/2/28.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  走势图设置视图

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DPTrendStatCount) {
    DPTrendStatCount50 = 0,
    DPTrendStatCount100,
    DPTrendStatCount150,
    DPTrendStatCount200
};

inline static DPTrendStatCount TrendCountToEnum(NSInteger count) {
    switch (count) {
        case 50:
            return DPTrendStatCount50;
        case 100:
            return DPTrendStatCount100;
        case 150:
            return DPTrendStatCount150;
        case 200:
            return DPTrendStatCount200;
        default:
            return DPTrendStatCount50;
    }
}

inline static NSInteger TrendEnumToCount(DPTrendStatCount count) {
    switch (count) {
        case DPTrendStatCount50:
            return 50;
        case DPTrendStatCount100:
            return 100;
        case DPTrendStatCount150:
            return 150;
        case DPTrendStatCount200:
            return 200;
        default:
            return 50;
    }
}

@protocol DPTrendSettingViewDelegate;

@interface DPTrendSettingView : UIView
@property (nonatomic, weak) id<DPTrendSettingViewDelegate> delegate;

@property (nonatomic, assign, readonly) DPTrendStatCount issueIndex; // 期数
@property (nonatomic, assign, readonly) BOOL missOn;   // 遗漏
@property (nonatomic, assign, readonly) BOOL brokenOn; // 折线
@property (nonatomic, assign, readonly) BOOL statOn;   // 统计
@property (nonatomic, assign, readonly) BOOL infoOn;   // 数据
- (void)refresh; // 刷新界面
@end

@protocol DPTrendSettingViewDelegate <NSObject>
- (void)viewDidConfirm:(DPTrendSettingView *)view;
- (void)viewDidCancel:(DPTrendSettingView *)view;
- (void)viewDidHelp:(DPTrendSettingView *)view;

@end
