//
//  DPUAObject.h
//  Jackpot
//
//  Created by mu on 15/9/1.
//  Copyright (c) 2015年 dacai. All rights reserved.
//
typedef NS_ENUM(int, bundKindType){
    //充值
    TopUp = 1,
    //提款
    Drawing = 2,
    //购买
    Buy = 5,
    //返奖
    Awarded = 8,
    //系统赠送
    SysPresent = 81,
    //系统充值
    SysTopUp = 82,
    //系统扣款
    SysDrawing = 83,
    //系统退款
    SysrRefund = 88,
};
    
inline static NSString *dp_BundKindTypeFirstName(bundKindType bundKind) {
    switch (bundKind) {
        case TopUp:
            return @"充值";
            break;
        case Drawing:
            return @"提款";
            break;
        case Buy:
            return @"购买";
            break;
        case Awarded:
            return @"返奖";
            break;
        case SysPresent:
            return @"系统赠送";
            break;
        case SysTopUp:
            return @"系统充值";
            break;
        case SysDrawing:
            return @"系统扣款 ";
            break;
        case SysrRefund:
            return @"系统退款";
            break;
        default:
            return @"";
            break;
    }
}


typedef NS_ENUM(int, ticketState){
    //     不出票
    Hold = 0,
    //     待出票
    WaitTicket = 1,
    //     出票中
    Ticketing = 2,
    //     出票完成
    Succeed = 3,
    //     出票失败
    Failure = 4,
    //     部分出票
    PartSucceed = 5,
};

/* buyTicketRecordEnum_h */
inline static NSString *dp_ticketStateFirstName(ticketState state) {
    switch (state) {
        case Hold:
            return @"不出票";
            break;
        case WaitTicket:
            return @"待出票";
            break;
        case Ticketing:
            return @"出票中";
            break;
        case Succeed:
            return @"出票完成";
            break;
        case Failure:
            return @"出票失败";
            break;
        case PartSucceed:
            return @"部分出票";
            break;
        default:
            return @"";
            break;
    }
}

typedef enum {
    /**
     *  收支明细的类型有以下几种（充值、提现、购买、返奖、系统赠送、系统充值、系统扣款、系统退款）。
     */
    DPUAFundRechangeType = 0,
    DPUAFundDrawType = 1,
    DPUAFundBuyTicketType = 2,
    DPUAFundRewordType = 3,
    DPUAFundSystemRewordType = 4,
    DPUAFundSystemDrawType = 5,
    DPUAFundSystemRechageType = 6,
    DPUAFundSystemBackType = 7,

} DPUAFundType;

typedef enum {
    /**
     *  红包状态有以下几种（可使用，派发中，已过期/使用）。
     */
    DPRedGiftUseableState = 0,
    DPRedGiftComingState = 1,
    DPRedGiftUnUsedState = 2,

} DPRedGiftState;

@interface DPUAObject : NSObject


//==============================common
/**
 *  id
 */
@property (nonatomic, copy) NSString *ID;
/**
 *  title
 */
@property (nonatomic, copy) NSString *title;
/**
 *  value
 */
@property (nonatomic, copy) NSString *value;
/**
 *  subTitle
 */
@property (nonatomic, copy) NSString *subTitle;
/**
 *  subValue
 */
@property (nonatomic, copy) NSString *subValue;
/**
 *  describTitle
 */
@property (nonatomic, copy) NSString *describTitle;
/**
 *  describValue
 */
@property (nonatomic, copy) NSString *describValue;
/**
 *  date
 */
@property (nonatomic, copy) NSString *date;
/**
 *  time
 */
@property (nonatomic, copy) NSString *time;
/**
 *  imageName
 */
@property (nonatomic, copy) NSString *imageName;
//==============================fundDetail
/**
 *  金额变化文案
 */
@property (nonatomic, copy) NSString *fundTitle;
/**
 *  金额变化时间
 */
@property (nonatomic, copy) NSString *fundTime;
/**
 *  变化金额
 */
@property (nonatomic, copy) NSString *fundValue;
/**
 *  金额变化图标
 */
@property (nonatomic, copy) NSString *fundIconName;
/**
 *  方案Id
 */
@property (nonatomic, copy) NSString *projectId;
/**
 *  方案类型
 */
@property (nonatomic, copy) NSString *projectType;
/**
 *  资源Id
 */
@property (nonatomic, assign) NSInteger sourceId;
/**
 *  资源类型
 */
@property (nonatomic, assign) NSInteger sourceType;
/**
 *  玩法类型
 */
@property (nonatomic, assign) NSInteger gameTypeId;

/**
 *  金额变化类型
 */
@property (nonatomic, assign) bundKindType fundType;

//==============================buyRecord
/**
 *  购彩日期
 */
@property (nonatomic, copy) NSString *buyDate;
/**
 *  购彩彩种
 */
@property (nonatomic, copy) NSString *ticketKind;
/**
 *  购彩期号
 */
@property (nonatomic, copy) NSString *buyNumber;
/**
 *  购彩金额
 */
@property (nonatomic, copy) NSString *buyValue;
/**
 *  中奖金额
 */
@property (nonatomic, copy) NSString *awardValue;
/**
 *  购彩时间
 */
@property (nonatomic, copy) NSString *buyTime;
/**
 *  购彩状态
 */
@property (nonatomic, assign) ticketState state;
/**
 *  是否中奖
 */
@property (nonatomic, assign) BOOL isAward;
//==============================redGift
/**
 *  红包时间
 */
@property (nonatomic, copy) NSString *redGiftTime;
/**
 *  红包状态
 */
@property (nonatomic, assign) DPRedGiftState giftState;
//==============================消息中心
/**
 *  是否处于编辑状态
 */
@property (nonatomic, assign) BOOL isEdit;
/**
 *  是否处于选中状态
 */
@property (nonatomic, assign) BOOL isSelect;
/**
 *  是否处于隐藏状态
 */
@property (nonatomic, assign) BOOL isHiddle;
/**
 *  是否已读
 */
@property (nonatomic, assign) BOOL isRead;
/**
 *  执行动作
 */
@property (nonatomic, copy) NSString *action;
//==============================意见反馈
/**
 *  是否是用户
 */
@property (nonatomic, assign) BOOL isCusturm;
@end















