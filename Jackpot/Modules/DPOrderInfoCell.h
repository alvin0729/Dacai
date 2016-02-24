//
//  DPOrderInfoCell.h
//  Jackpot
//
//  Created by sxf on 15/8/28.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <UIKit/UIKit.h>
//数字彩内容
@interface DPOrderInfoCell : UICollectionViewCell

//序号
- (void)orderNumberLabelText:(NSString*)string;
//订单期号等信息
- (void)titleLabelText:(NSString*)string;
//订单金额
- (void)moneyLabelText:(NSString*)string;
//订单详情
- (void)infoLabelText:(NSMutableAttributedString*)attributedText;
@end

//竞彩内容
@interface DPJcOrderInfoCell : UICollectionViewCell

//标示  如周一001
- (void)rqLableText:(NSString*)text;
//订单详情
- (void)infoLabelText:(NSMutableAttributedString*)attributedText;
//订单详情标题
- (void)infoLabelTitleText:(NSString*)attributedText;
@end

//竞彩区头
@interface DPHeaderViewForJcOrder : UICollectionReusableView

//序号
- (void)orderNumberLabelText:(NSString*)string;
//订单期号等信息
- (void)titleLabelText:(NSString*)string;
//订单金额
- (void)moneyLabelText:(NSString*)string;

@end

//竞彩区尾
@interface DPFooterViewForJcOrder : UICollectionReusableView

//标示  如周一001
- (void)rqLableText:(NSString*)text;
//订单详情
- (void)infoLabelText:(NSMutableAttributedString*)attributedText;
//订单详情标题
- (void)infoLabelTitleText:(NSString*)attributedText;

@end

//第一分区的区头
@interface DPHeaderViewForOrderFirstView : UICollectionReusableView {
    UILabel *_ticketLabel; //总票数
    UILabel *_moneyLabel; //总金额
}
@property (nonatomic, strong, readonly) UILabel *ticketLabel;
@property (nonatomic, strong, readonly) UILabel *moneyLabel;
@property (nonatomic, assign) BOOL isBulid; //是否创建过视图

- (void)bulidLayOut:(GameTypeId)gameType;
@end
