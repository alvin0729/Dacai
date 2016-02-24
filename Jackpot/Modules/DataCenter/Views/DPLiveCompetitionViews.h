//
//  DPLiveCompetitionViews.h
//  Jackpot
//
//  Created by wufan on 15/9/12.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPImageLabel.h"
#import <UIKit/UIKit.h>

// 赛事实况
@interface DPLiveCompetitionLiveContentView : UIView
@property (nonatomic, strong, readonly) DPImageLabel *homeLabel;
@property (nonatomic, strong, readonly) DPImageLabel *awayLabel;
@property (nonatomic, strong, readonly) DPImageLabel *timeLabel;
@end

// 赛事实况
@interface DPLiveCompetitionLiveContentCell : UITableViewCell
@property (nonatomic, strong, readonly) DPLiveCompetitionLiveContentView *liveView;
@property (nonatomic, strong, readonly) UIView *bottomView;

@end

//评论
@class DPAgreeControl;
typedef void (^ShowDetailBlock)(UITableViewCell *curCell);
typedef void (^SupportBlock)(UITableViewCell *curCell);

@interface DPCommentTableCell : UITableViewCell

@property (nonatomic, strong, readonly) UIButton *detailButton;    //详情（全文）
@property (nonatomic, copy) ShowDetailBlock showDetail;
@property (nonatomic, copy) SupportBlock supportClick;

@property (nonatomic, strong) NSString *commentString;
@property (nonatomic, strong) NSString *agreeNum;
@property (nonatomic, strong) NSString *timeString;    //时间

@property (nonatomic, strong, readonly) UIImageView *imageIcon;         //用户头像
@property (nonatomic, strong, readonly) DPAgreeControl *agreeButton;    //点赞按钮
@property (nonatomic, strong, readonly) UILabel *nameLabel;             //名字 

@end
;

typedef NS_ENUM(NSInteger, DPControlSelectStatus) {
    SelectStatusNO,
    SelectStatusYES,
};

/**
 *  点赞控件
 */
@interface DPAgreeControl : UIControl

/**
 *  正常图片
 */
@property (nonatomic, strong) UIImage *normalStateImg;
/**
 *  选中时图片
 */
@property (nonatomic, strong) UIImage *selectedStateImg;
/**
 *  文字
 */
@property (nonatomic, strong) NSString *title;
/**
 *  上一个状态
 */
@property (nonatomic, assign) DPControlSelectStatus lastFlag;
/**
 *  设置状态
 *
 *  @param flag DPControlSelectStatus
 */
- (void)setFlag:(DPControlSelectStatus)flag;

@end