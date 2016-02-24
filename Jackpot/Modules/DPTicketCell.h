//
//  DPTicketCell.h
//  Jackpot
//
//  Created by sxf on 15/9/1.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DPTicketCellDelegate;
@interface DPTicketCell : UICollectionViewCell

@property (nonatomic, weak) id<DPTicketCellDelegate> delegate;
//序号
- (void)orderNumberLabelText:(NSString*)string;
//订单期号等信息
- (void)titleLabelText:(NSString*)string;
//订单金额
- (void)moneyLabelText:(NSString*)string;
//订单详情
- (void)infoLabelText:(NSMutableAttributedString*)attributedText;
//中奖信息
- (void)winInfoText:(NSAttributedString*)text;
//是否中奖
- (void)isShowWinImageView:(BOOL)isWin;
//是否出票
- (void)showCopyTicket:(BOOL)isTicket;
@end

@interface DPJcTicketCell : UICollectionViewCell
@property (nonatomic, weak) id<DPTicketCellDelegate> delegate;

//订单详情
- (void)infoLabelText:(NSMutableAttributedString*)attributedText;
//订单详情标题
- (void)infoLabelTitleText:(NSString*)attributedText;

//标示  如周一001
- (void)rqLableText:(NSString*)text;
@end

@interface DPHeaderViewForJcTicket : UICollectionReusableView

@property (nonatomic, weak) id<DPTicketCellDelegate> delegate;
//序号
- (void)orderNumberLabelText:(NSString*)string;
//订单期号等信息
- (void)titleLabelText:(NSString*)string;
//订单金额
- (void)moneyLabelText:(NSString*)string;
//是否出票
- (void)showCopyTicket:(BOOL)isTicket;
@end

@interface DPFooterViewForJcTicket : UICollectionReusableView

//标示  如周一001
- (void)rqLableText:(NSString*)text;
//订单详情
- (void)infoLabelText:(NSMutableAttributedString*)attributedText;
//订单详情标题
- (void)infoLabelTitleText:(NSString*)attributedText;
//中奖信息
- (void)winInfoText:(NSAttributedString*)text;
//是否中奖
- (void)isShowWinImageView:(BOOL)isWin;

@end

@interface DPHeaderViewForFirstView : UICollectionReusableView {
    UILabel *_issueLabel;
    UILabel *_winLabel;
}
@property (nonatomic, strong, readonly) UILabel* winLabel; //开奖状态
@property (nonatomic, strong, readonly) UILabel* issueLabel;
@property (nonatomic, assign) BOOL isBulid; //是否创建过视图

- (void)bulidLayOut:(GameTypeId)gameType;
@end

@protocol DPTicketCellDelegate <NSObject>

- (void)copyTicketSearchForTicketCell:(NSString*)ticketText;
@end