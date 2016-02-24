//
//  DPJczqDataModel.h
//  Jackpot
//
//  Created by Ray on 15/8/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "Jczq.pbobjc.h"

typedef struct JczqOption {
    int betSpf[3];
    int betRqspf[3];
    int betBf[31];
    int betBqc[9];
    int betZjq[8];
    // ...
} JczqOption;

typedef struct JczqSelectNum {
    int numSpf ;
    int numRqspf ;
    int numBf ;
    int numBqc ;
    int numZjq ;
}JczqSelectNum ;

@interface MatchBetOption : NSObject

@property(nonatomic, assign) JczqOption htOption;
@property(nonatomic, assign) JczqOption dgOption;
@property(nonatomic, assign) JczqOption normalOption;

@property(nonatomic, assign) JczqSelectNum htSelect;
@property(nonatomic, assign) JczqSelectNum dgSelect;
@property(nonatomic, assign) JczqSelectNum normalSelect;

@property(nonatomic, assign) BOOL htDanTuo;
@property(nonatomic, assign) BOOL dgDanTuo;
@property(nonatomic, assign) BOOL spfDanTuo;
@property(nonatomic, assign) BOOL rqspfDanTuo;
@property(nonatomic, assign) BOOL bfDanTuo;
@property(nonatomic, assign) BOOL zjqDanTuo;
@property(nonatomic, assign) BOOL bqcDanTuo;


/**
 *  初始化选中状态和选中数目
 *
 *  @param type 彩种
 */
- (void)initializeOptionWithType:(GameTypeId)type ;
/**
 *  初始化选中数目
 *
 *  @param type 彩种
 */
- (void)initializeSelectNumWithType:(GameTypeId)type ;

/**
 *  是否被选中
 *
 *  @param type 彩种
 *
 *  @return 是否被选中
 */
-(BOOL)hasSelectedWithType:(GameTypeId)type ;

-(NSInteger)getSelectedStatus:(NSInteger)total option:(int [])option  ;

 /**
 *  获取胆拖标记
 *
 *  @param gameType 彩种
 */
-(BOOL)getMarkedStatus:(GameTypeId)gameType ;
/**
 *  修改胆拖状态
 *
 *  @param gameType 彩种
 *  @param marked   是否胆拖
 */
-(void)exchangeMarkStatus:(GameTypeId)gameType  mark:(BOOL)marked;


@end




@interface PBMJczqMatch (Addation)

@property(nonatomic, strong, readonly) MatchBetOption *matchOption;
/**
 *  期号
 */
@property(nonatomic, assign) NSInteger dpGameId;


 
/**
 *  是否选择的都是单关玩法
 *
 *  @param type 玩法
 *
 *  @return 是否全是单关
 */
-(BOOL)isSelectedAllSignalWithType:(GameTypeId)type ;
/**
 *  是否被选中
 *
 *  @param type 彩种
 *
 *  @return 是否被选中
 */
-(BOOL)isSelectedWithType:(GameTypeId)type ;


-(NSArray *)getSelectedTypeArrWithType:(GameTypeId)type ;


/**
 *  更新选中状态
 *
 *  @param baseGameType 基础GameType
 *  @param gametype     （里面的小彩种）混投合单关时有效
 *  @param index        下标
 *  @param isSelect     是否选中
 *  @param isAllsub     是否是通过更多中的确定提交

 */
- (void)updateSelectStatusWithBaseType:(GameTypeId )baseGameType  selectGmaeType:(GameTypeId)gametype  index:(int)index select:(BOOL)isSelect isAllSub:(BOOL)isAllsub;

@end



@interface DPJczqTranseModel : NSObject

@end

