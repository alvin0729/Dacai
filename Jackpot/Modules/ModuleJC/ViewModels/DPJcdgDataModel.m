//
//  DPJcdgDataModel.m
//  DacaiProject
//
//  Created by jacknathan on 15-1-16.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPJcdgDataModel.h"

@implementation DPJcdgDataModel {
  MyGameType _myGameType;
}
@synthesize gameCountFootBall = _gameCountFootBall;
@synthesize gameCountBasketBall = _gameCountBasketBall;
@synthesize curGameIndex = _curGameIndex;
@synthesize visibleGamesFootBall = _visibleGamesFootBall;
@synthesize visibleGamesBasket = _visibleGamesBasket;
@synthesize payGameType = _payGameType;
@synthesize payMultiple = _payMultiple;
@synthesize payNote = _payNote;
@synthesize myGameType = _myGameType;
//@synthesize bonusBetterGameType = _bonusBetterGameType;
//@synthesize note = _note;
@synthesize timesDict = _timesDict;
- (instancetype)initWithMyGameType:(MyGameType)type {
  if (self = [super init]) {

    _myGameType = type;
    _gameCountFootBall = _gameCountBasketBall = -1;
    _curGameIndex = 0;

    _visibleGamesFootBall = [NSMutableArray arrayWithCapacity:4];
    _visibleGamesBasket = [NSMutableArray arrayWithCapacity:4];
    _timesDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [self dp_becomeDelegate];
  }
  return self;
}
- (void)dp_sendGoPayRequest {
//  [self dpn_bindId:CFrameWork::GetInstance()->GetAccount()->Net_RefreshRedPacket( self.payGameType, 1, (int)(self.payNote * self.payMultiple) * 2, 0) type:ACCOUNT_RED_PACKET];
}
- (void)dp_goPayWithGameType:(GameTypeId)gameType times:(int)times {

  int note = 0, minBonus = 0, maxBonus = 0;

    // TODO:
//  if (_myGameType == GameTypeFootBall) {
//    _lotteryJczq->SetMultiple(times);
//    _lotteryJczq->SetSingleSelectedTarget(self.curGameIndex, gameType);
//    _lotteryJczq->SetTogetherType(false);
//
//    _lotteryJczq->GetSingleTargetAmount(self.curGameIndex, gameType, note,
//                                        minBonus, maxBonus);
//
//  } else if (_myGameType == GameTypeBasketBall) {
//
//    _lotteryJcLq->SetMultiple(times);
//    _lotteryJcLq->SetSingleSelectedTarget(self.curGameIndex, gameType);
//    _lotteryJcLq->SetTogetherType(false);
//
//    _lotteryJcLq->GetSingleTargetAmount(self.curGameIndex, gameType, note,
//                                        minBonus, maxBonus);
//  } else {
//    DPAssert(NO);
//  }

  _payGameType = gameType;
  _payMultiple = times;
  _payNote = note;
}
- (NSInteger)dp_sendJcdgDataRequest {
  if (_myGameType == GameTypeBasketBall) {
    if (self.gameCountBasketBall <= 0) {
//      return [self dpn_rebindId:_lotteryJcLq->Net_SingleList() type:Jclq_Single];
    }
  } else if (_myGameType == GameTypeFootBall) {
    if (self.gameCountFootBall <= 0) {
//      return [self dpn_rebindId:_lotteryJczq->Net_SingleList() type:JCZQ_SingleList];
    }
  }

  return -1;
}
- (void)dp_setSingleSelectedTargetWithGameType:(GameTypeId)gameType {

  if (_myGameType == GameTypeFootBall) {
//    _lotteryJczq->SetSingleSelectedTarget(self.curGameIndex, gameType);

  } else if (_myGameType == GameTypeBasketBall) {
//    _lotteryJcLq->SetSingleSelectedTarget(self.curGameIndex, gameType);

  } else {
    DPAssert(NO);
  }
}
- (NSInteger)dp_getNoteWithGameType:(GameTypeId)gameType note:(out int *)note {
  int minBonus = 0, maxBonus = 0;
  if (_myGameType == GameTypeFootBall) {
//    return _lotteryJczq->GetSingleTargetAmount(_curGameIndex, gameType, *note, minBonus, maxBonus);
  } else if (_myGameType == GameTypeBasketBall) {
//    return _lotteryJcLq->GetSingleTargetAmount(_curGameIndex, gameType, *note, minBonus, maxBonus);
  }
  return -1;
}
- (NSInteger)dp_sendNetBalance {
  if (_myGameType == GameTypeFootBall) {
//    return _lotteryJczq->NetBalance();
      return 0;
  } else { //篮球无奖金优化

    return 0;
  }
}
- (void)dp_setProjectBuyType:(NSInteger)type {
  if (_myGameType == GameTypeFootBall) {
//    _lotteryJczq->SetProjectBuyType((int)type);
  } else if (_myGameType == GameTypeBasketBall) {
  }
}
- (void)dp_becomeDelegate {
}
- (void)setCurGameIndex:(int)curGameIndex {
  _curGameIndex = curGameIndex;
}

- (NSInteger)dp_numberOfRowsInSection:(NSInteger)section {

  if (_myGameType == GameTypeFootBall) {
    if (self.gameCountFootBall <= 0) {
      return 0;
    }
    [self.visibleGamesFootBall removeAllObjects];

    int gamesTypes[4] = {GameTypeJcRqspf, GameTypeJcSpf, GameTypeJcZjq,
                         GameTypeJcBf};
    for (int i = 0; i < 4; i++) {
//      int result = _lotteryJczq->IsSingleGameVisible(_curGameIndex, gamesTypes[i]);
//      if (result)
//        [_visibleGamesFootBall
//            addObject:[NSNumber numberWithInt:gamesTypes[i]]];
    }

    return self.visibleGamesFootBall.count;
  } else {
    if (self.gameCountBasketBall <= 0) {
      return 0;
    }
    [self.visibleGamesBasket removeAllObjects];
    int gamesTypes[4] = {GameTypeLcSf, GameTypeLcRfsf, GameTypeLcDxf,
                         GameTypeLcSfc};
    for (int i = 0; i < 4; i++) {
//      int result = _lotteryJcLq->IsSingleGameVisible(_curGameIndex, gamesTypes[i]);
//      if (result)
//        [_visibleGamesBasket addObject:[NSNumber numberWithInt:gamesTypes[i]]];
    }
    return self.visibleGamesBasket.count;
  }

  return 0;
}

//- (NSInteger)dp_numberOfRowsInSection:(NSInteger)section
//{
//    if (self.gameCount <= 0) {
//        return 0;
//    }
//    [self.visibleGamesTypeArray removeAllObjects];
//    int gamesTypes[4] = {GameTypeJcRqspf, GameTypeJcSpf, GameTypeJcZjq,
//    GameTypeJcBf};
//    for (int i = 0; i < 4; i++) {
//        int result = _lotteryJczq -> IsSingleGameVisible(_curGameIndex,
//        gamesTypes[i]);
//        if (result) [_visibleGamesTypeArray addObject:[NSNumber
//        numberWithInt:gamesTypes[i]]];
//    }
//    return self.visibleGamesTypeArray.count;
//
//}

- (NSString *)dp_cellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath
                                       withType:(MyGameType)type {

  return [self dp_cellClassForRowAtIndexPath:indexPath type:type];
}
- (NSString *)dp_cellClassForRowAtIndexPath:(NSIndexPath *)indexPath
                                       type:(MyGameType)type {
  //    GameTypeLcSf    = 131,  // 胜负
  //    GameTypeLcRfsf  = 132,  // 让分胜负
  //    GameTypeLcSfc   = 133,  // 胜分差
  //    GameTypeLcDxf   = 134,  // 大小分
  //

  // 有比赛时
  int gameType;

  if (type == GameTypeFootBall) {
    if (self.gameCountFootBall <= 0) {
      return @"";
    }
    gameType = [self.visibleGamesFootBall[indexPath.row] intValue];
    switch (gameType) {
    case GameTypeJcRqspf:
      return @"DPjcdgTypeRqspfCell";
      break;
    case GameTypeJcSpf:
      return @"DPjcdgTypeRqspfCell";
      break;
    case GameTypeJcZjq:
      return @"DPjcdgAllgoalCell";
      break;
    case GameTypeJcBf:
      return @"dpJcdgGuessWinCell";
      break;

    default:
      return @"";
      break;
    }

  } else {

    if (self.gameCountBasketBall <= 0) {

      return @"";
    }

    gameType = [self.visibleGamesBasket[indexPath.row] intValue];

    switch (gameType) {

    case GameTypeLcSf:
    case GameTypeLcRfsf:
      return @"DPJcdgBasketRfsfCell";
      break;
    case GameTypeLcDxf:
      return @"DPJcdgBasketDxfCell";
      break;
    case GameTypeLcSfc:
      return @"DPjcdgBasketSfcCell";
      break;
    default:
      return @"";
      break;
    }
  }
}

- (NSString *)dp_cellReuseIdentifierAtIndexPath:(NSIndexPath *)indexPath {
  return [self dp_cellClassForRowAtIndexPath:indexPath];
}

- (NSString *)dp_cellClassForRowAtIndexPath:(NSIndexPath *)indexPath {
  //    GameTypeLcSf    = 131,  // 胜负
  //    GameTypeLcRfsf  = 132,  // 让分胜负
  //    GameTypeLcSfc   = 133,  // 胜分差
  //    GameTypeLcDxf   = 134,  // 大小分
  //

  return @"DPjcdgTypeRqspfCell";
  if (self.gameCountFootBall <= 0) {

    return @"";
  }
  // 有比赛时
  int gameType = [self.visibleGamesFootBall[indexPath.row] intValue];
  switch (gameType) {
  case GameTypeJcRqspf:
  case GameTypeJcSpf:
    return @"DPjcdgTypeRqspfCell";
    break;
  case GameTypeJcZjq:
    return @"DPjcdgAllgoalCell";
    break;
  case GameTypeJcBf:
    return @"dpJcdgGuessWinCell";
    break;
  case GameTypeLcSfc:
    return @"DPjcdgBasketSfcCell";
  case GameTypeLcDxf:
    return @"DPJcdgBasketDxfCell";
  case GameTypeLcRfsf:
  case GameTypeLcSf:
    return @"DPJcdgBasketRfsfCell";
  default:
    return @"";
    break;
  }
}
- (id)dp_cellModelForIndexPath:(NSIndexPath *)indexPath {
  // 有比赛时
  GameTypeId gameType;
  if (_myGameType == GameTypeFootBall) {
    if (self.gameCountFootBall <= 0) {
        
        return nil;
       
    }

    gameType = (GameTypeId)[self.visibleGamesFootBall[indexPath.row] intValue];
  } else {
    if (self.gameCountBasketBall <= 0) {
       return nil;
    }

    gameType = (GameTypeId)[self.visibleGamesBasket[indexPath.row] intValue];
  }
    return nil;
}
#pragma mark - 获取cell model

//- (id)dp_cellModelForGameType:(GameTypeId)gameType {
//  if (_myGameType == GameTypeFootBall) {
//
//    int note, minBonus, maxBonus;
////    _lotteryJczq->GetSingleTargetAmount(_curGameIndex, gameType, note, minBonus,
////                                        maxBonus);
//
//    switch (gameType) {
//    case GameTypeJcRqspf:
//    case GameTypeJcSpf: {
//      string homeTeamName, awayTeamName, homeTeamRank, awayTeamRank,
//          competitionName, endTime, orderName;
//      int rqspf_sp[3], bf_sp[31], zjq_sp[8], bqc_sp[9], spf_sp[3], options[10],
//          betProportion[6], rqs;
//
//      _lotteryJczq->GetSingleTargetInfo(
//          _curGameIndex, homeTeamName, awayTeamName, homeTeamRank, awayTeamRank,
//          orderName, competitionName, endTime, rqs);
//      _lotteryJczq->GetSingleTargetSpList(_curGameIndex, rqspf_sp, bf_sp,
//                                          zjq_sp, bqc_sp, spf_sp);
//      _lotteryJczq->GetSingleTargetOption(_curGameIndex, gameType, options);
//      _lotteryJczq->GetSingleTargetAnalysis(_curGameIndex, betProportion);
//
//      NSString *homeTeamNameS =
//          [NSString stringWithUTF8String:homeTeamName.c_str()];
//      NSString *awayTeamNameS =
//          [NSString stringWithUTF8String:awayTeamName.c_str()];
//
//      int res_sp[3];
//      res_sp[0] = gameType == GameTypeJcRqspf ? rqspf_sp[0] : spf_sp[0];
//      res_sp[1] = gameType == GameTypeJcRqspf ? rqspf_sp[1] : spf_sp[1];
//      res_sp[2] = gameType == GameTypeJcRqspf ? rqspf_sp[2] : spf_sp[2];
//
//      NSArray *betProArray = gameType == GameTypeJcSpf
//                                 ? @[
//                                   [NSNumber numberWithInt:betProportion[0]],
//                                   [NSNumber numberWithInt:betProportion[1]],
//                                   [NSNumber numberWithInt:betProportion[2]]
//                                 ]
//                                 : @[
//                                   [NSNumber numberWithInt:betProportion[3]],
//                                   [NSNumber numberWithInt:betProportion[4]],
//                                   [NSNumber numberWithInt:betProportion[5]]
//                                 ];
//
//      float leftNum = [FloatTextForIntDivHundred(res_sp[0]) floatValue];
//      float middleNum = [FloatTextForIntDivHundred(res_sp[1]) floatValue];
//      float rightNum = [FloatTextForIntDivHundred(res_sp[2]) floatValue];
//
//      _lotteryJczq->GetSingleTargetRqs(_curGameIndex, rqs);
//      NSString *leftName = [homeTeamNameS
//          stringByAppendingString:[NSString
//                                      stringWithFormat:@" 胜\n%.2f", leftNum]];
//      NSString *warnContent =
//          @"对指定的比赛场次在全场90分钟(含伤停补时)"
//          @"的主队和客队的胜平负结果进行投注, "
//          @"所选比赛均不让球";
//      if (gameType == GameTypeJcRqspf) {
//        NSString *rqsString = nil;
//        if (rqs > 0)
//          rqsString = [NSString stringWithFormat:@"+%d", rqs];
//        if (rqs < 0)
//          rqsString = [NSString stringWithFormat:@"-%d", -rqs];
//        leftName = [homeTeamNameS
//            stringByAppendingString:[NSString stringWithFormat:@"(%@)\n胜 %.2f",
//                                                               rqsString,
//                                                               leftNum]];
//        warnContent =
//            @"对指定的比赛场次在全场90分钟(含伤停补时)"
//            @"的主队和客队的胜平负结果进行投注";
//      }
//      NSString *middleName = [NSString stringWithFormat:@"平\n%.2f", middleNum];
//      NSString *rightName = [awayTeamNameS
//          stringByAppendingString:[NSString stringWithFormat:@" \n胜 %.2f",
//                                                             rightNum]];
//
//      NSArray *optionArray = @[
//        [NSNumber numberWithInt:options[0]],
//        [NSNumber numberWithInt:options[1]],
//        [NSNumber numberWithInt:options[2]]
//      ];
//
//      DPJcdgSpfCellModel *spfModel = [[DPJcdgSpfCellModel alloc] init];
//      spfModel.teamsName = @[ leftName, middleName, rightName ];
//      spfModel.gameType = gameType;
//      spfModel.defaultOption = optionArray;
//      spfModel.percents = betProArray;
//      spfModel.warnContent = warnContent;
//      spfModel.zhushu = note;
//      spfModel.minBonus = minBonus / 100.0;
//      spfModel.maxBonus = maxBonus / 100.0;
//
//      return spfModel;
//    } break;
//    case GameTypeJcZjq: {
//      int rqspf_sp[3], bf_sp[31], zjq_sp[8], bqc_sp[9], spf_sp[3], options[10];
//      _lotteryJczq->GetSingleTargetSpList(_curGameIndex, rqspf_sp, bf_sp,
//                                          zjq_sp, bqc_sp, spf_sp);
//      _lotteryJczq->GetSingleTargetOption(_curGameIndex, gameType, options);
//
//      NSArray *optionsArray = @[
//        [NSNumber numberWithInt:options[0]],
//        [NSNumber numberWithInt:options[1]],
//        [NSNumber numberWithInt:options[2]],
//        [NSNumber numberWithInt:options[3]],
//        [NSNumber numberWithInt:options[4]],
//        [NSNumber numberWithInt:options[5]],
//        [NSNumber numberWithInt:options[6]],
//        [NSNumber numberWithInt:options[7]]
//      ];
//      NSArray *spArray = @[
//        FloatTextForIntDivHundred(zjq_sp[0]),
//        FloatTextForIntDivHundred(zjq_sp[1]),
//        FloatTextForIntDivHundred(zjq_sp[2]),
//        FloatTextForIntDivHundred(zjq_sp[3]),
//        FloatTextForIntDivHundred(zjq_sp[4]),
//        FloatTextForIntDivHundred(zjq_sp[5]),
//        FloatTextForIntDivHundred(zjq_sp[6]),
//        FloatTextForIntDivHundred(zjq_sp[7])
//      ];
//      DPJcdgZjqCellModel *zjqModel = [[DPJcdgZjqCellModel alloc] init];
//      zjqModel.sp_Numbers = spArray;
//      zjqModel.defaultOption = optionsArray;
//      zjqModel.warnContent =
//          @"对指定的比赛场次在全场90分钟(含伤停补时)"
//          @"的主队和客队的总进球数结果进行投注。";
//      zjqModel.gameType = GameTypeJcZjq;
//      zjqModel.zhushu = note;
//      zjqModel.minBonus = minBonus / 100.0;
//      zjqModel.maxBonus = maxBonus / 100.0;
//
//      return zjqModel;
//    } break;
//    case GameTypeJcBf: {
//      int rqs, options[10];
//      _lotteryJczq->GetSingleTargetOption(_curGameIndex, gameType, options);
//      string homeTeamName, awayTeamName, homeTeamRank, awayTeamRank,
//          competitionName, endTime, orderName;
//      _lotteryJczq->GetSingleTargetInfo(
//          _curGameIndex, homeTeamName, awayTeamName, homeTeamRank, awayTeamRank,
//          orderName, competitionName, endTime, rqs);
//      NSString *homeTeamNameS =
//          [NSString stringWithUTF8String:homeTeamName.c_str()];
//      NSString *awayTeamNameS =
//          [NSString stringWithUTF8String:awayTeamName.c_str()];
//      NSArray *optionsArray = @[
//        [NSNumber numberWithInt:options[0]],
//        [NSNumber numberWithInt:options[1]],
//        [NSNumber numberWithInt:options[2]],
//        [NSNumber numberWithInt:options[3]],
//        [NSNumber numberWithInt:options[4]],
//        [NSNumber numberWithInt:options[5]],
//        [NSNumber numberWithInt:options[6]],
//        [NSNumber numberWithInt:options[7]],
//        [NSNumber numberWithInt:options[8]]
//      ];
//      DPJcdgGuessCellModel *model = [[DPJcdgGuessCellModel alloc] init];
//      model.leftTeamName = homeTeamNameS;
//      model.rightTeamName = awayTeamNameS;
//      model.defaultOption = optionsArray;
//      model.gameType = GameTypeJcBf;
//      model.warnContent =
//          @"竞猜本场全场比分,猜球队能赢几个球。\n主队胜1球:"
//          @" " @"包含1:0、2:1、3:2、胜其他。\n主队胜2球: "
//          @"包含2:0、3:1、4:2、胜其他。\n主队胜3球: "
//          @"包含3:0、4:1、5:2、胜其他。\n主队胜更多: "
//          @"包含4:0、5:0、5:1、胜其他。\n两队平局: "
//          @"包含0:0、1:1、2:2、3:3、平其他。\n客队胜1球: "
//          @"包含0:1、1:2、2:3、负其他。\n客队胜2球: "
//          @"包含0:2、1:3、2:4、负其他。\n客队胜3球: "
//          @"包含0:3、1:4、2:5、负其他。\n客队胜更多: "
//          @"包含0:4、0:5、1:5、负其他。";
//      model.zhushu = note;
//      model.minBonus = minBonus / 100.0;
//      model.maxBonus = maxBonus / 100.0;
//
//      return model;
//    } break;
//    default:
//      return nil;
//      break;
//    }
//
//  } else {
//    int spList[12], betOption[12], proportion[2], rf, zf;
//
//    string homeTeamName, awayTeamName, homeTeamRank, awayTeamRank,
//        competitionName, endTime, orderName;
//
//    _lotteryJcLq->GetSingleTargetOption(_curGameIndex, gameType,
//                                        betOption); //获取投注
//    _lotteryJcLq->GetSingleTargetSpList(_curGameIndex, gameType, spList); // sp
//
//    _lotteryJcLq->GetSingleTargetInfo(_curGameIndex, homeTeamName, awayTeamName,
//                                      homeTeamRank, awayTeamRank, orderName,
//                                      competitionName, endTime, rf, zf);
//
//    int note, minBonus, maxBonus;
//    _lotteryJcLq->GetSingleTargetAmount(_curGameIndex, gameType, note, minBonus,
//                                        maxBonus);
//
//    switch (gameType) {
//    case GameTypeLcRfsf:
//    case GameTypeLcSf: {
//
//      _lotteryJcLq->GetSingleTargetAnalysis(_curGameIndex, gameType,
//                                            proportion);
//
//      NSString *homeTeamNameS =
//          [NSString stringWithUTF8String:homeTeamName.c_str()];
//      NSString *awayTeamNameS =
//          [NSString stringWithUTF8String:awayTeamName.c_str()];
//
//      NSArray *betProArray = @[
//        [NSNumber numberWithInt:proportion[1]],
//        [NSNumber numberWithInt:proportion[0]]
//      ];
//
//        float awayNum = [FloatTextForIntDivHundred(spList[0]) floatValue];
//        float homeNum = [FloatTextForIntDivHundred(spList[1]) floatValue];
//
//      NSString *homeN = [homeTeamNameS
//          stringByAppendingString:[NSString
//                                      stringWithFormat:@" \n胜 %.2f", homeNum]];
//      NSString *AwayN = [awayTeamNameS
//          stringByAppendingString:[NSString
//                                      stringWithFormat:@" \n胜 %.2f", awayNum]];
//
//      NSString *warnContent = @"竞猜该场比赛（包含加时赛）获取的球队。";
//
//      if (gameType == GameTypeLcRfsf) {
//            NSString *rqsString = [NSString stringWithFormat:@"%+.1f", rf / 10.0];
//
//            homeN = [homeTeamNameS
//                stringByAppendingString:[NSString
//                                            stringWithFormat:@" (%@)\n胜 %.2f",
//                                                             rqsString, homeNum]];
//            warnContent =
//                @"竞猜该场比赛（包含加时赛）主队让球或者受让球后获胜的球队。让球值会随时发生变化，以出票时为准。";
//      }
//
//      NSArray *optionArray = @[
//        [NSNumber numberWithInt:betOption[0]],
//        [NSNumber numberWithInt:betOption[1]]
//      ];
//
//      DPJcdgBasketCellModel *spfModel = [[DPJcdgBasketCellModel alloc] init];
//      spfModel.homeName = homeN;
//      spfModel.awayName = AwayN;
//      spfModel.gameType = gameType;
//      spfModel.defaultOption = optionArray;
//      spfModel.percents = betProArray;
//      spfModel.warnContent = warnContent;
//      spfModel.zhushu = note;
//      spfModel.minBonus = minBonus / 100.0;
//      spfModel.maxBonus = maxBonus / 100.0;
//      return spfModel;
//    } break;
//    case GameTypeLcDxf: {
//
//      _lotteryJcLq->GetSingleTargetAnalysis(_curGameIndex, gameType,
//                                            proportion);
//      NSArray *betProArray = @[
//        [NSNumber numberWithInt:proportion[0]],
//        [NSNumber numberWithInt:proportion[1]]
//      ];
//
//      NSArray *optionsArray = @[
//        [NSNumber numberWithInt:betOption[0]],
//        [NSNumber numberWithInt:betOption[1]],
//      ];
//      NSArray *spArray = @[
//        FloatTextForIntDivHundred(spList[0]),
//        [NSString stringWithFormat:@"%.1f", zf / 10.0],
//        FloatTextForIntDivHundred(spList[1]),
//      ];
//      DPJcdgBasketCellModel *zjqModel = [[DPJcdgBasketCellModel alloc] init];
//      zjqModel.homeName = @"小分";
//      zjqModel.awayName = @"大分";
//
//      zjqModel.sp_Numbers = spArray;
//      zjqModel.defaultOption = optionsArray;
//      zjqModel.percents = betProArray;
//      zjqModel.warnContent =
//          @"竞猜该场比赛（包含加时赛）2球队比分相加后和预设总分的大小比对情况。预设总分会随时发生变化，以出票时为准。";
//      zjqModel.gameType = gameType;
//      zjqModel.zhushu = note;
//      zjqModel.minBonus = minBonus / 100.0;
//      zjqModel.maxBonus = maxBonus / 100.0;
//      return zjqModel;
//    } break;
//    case GameTypeLcSfc: {
//
//      NSString *homeTeamNameS =
//          [NSString stringWithUTF8String:homeTeamName.c_str()];
//      NSString *awayTeamNameS =
//          [NSString stringWithUTF8String:awayTeamName.c_str()];
//      NSArray *optionsArray = @[
//        [NSNumber numberWithInt:betOption[0]],
//        [NSNumber numberWithInt:betOption[1]],
//        [NSNumber numberWithInt:betOption[2]],
//        [NSNumber numberWithInt:betOption[3]],
//        [NSNumber numberWithInt:betOption[4]],
//        [NSNumber numberWithInt:betOption[5]],
//        [NSNumber numberWithInt:betOption[6]],
//        [NSNumber numberWithInt:betOption[7]],
//        [NSNumber numberWithInt:betOption[8]],
//        [NSNumber numberWithInt:betOption[9]],
//        [NSNumber numberWithInt:betOption[10]],
//        [NSNumber numberWithInt:betOption[11]]
//      ];
//
//      NSArray *spArray = @[
//        FloatTextForIntDivHundred(spList[0]),
//        FloatTextForIntDivHundred(spList[1]),
//        FloatTextForIntDivHundred(spList[2]),
//        FloatTextForIntDivHundred(spList[3]),
//        FloatTextForIntDivHundred(spList[4]),
//        FloatTextForIntDivHundred(spList[5]),
//        FloatTextForIntDivHundred(spList[6]),
//        FloatTextForIntDivHundred(spList[7]),
//        FloatTextForIntDivHundred(spList[8]),
//        FloatTextForIntDivHundred(spList[9]),
//        FloatTextForIntDivHundred(spList[10]),
//        FloatTextForIntDivHundred(spList[11])
//      ];
//
//      DPJcdgBasketCellModel *model = [[DPJcdgBasketCellModel alloc] init];
//      model.awayName = awayTeamNameS;
//      model.homeName = homeTeamNameS;
//      model.defaultOption = optionsArray;
//      model.warnContent = @"竞猜该场比赛（包含加时赛）主、客2队的得分差距。";
//      model.gameType = gameType;
//      model.sp_Numbers = spArray;
//      model.zhushu = note;
//      model.minBonus = minBonus / 100.0;
//      model.maxBonus = maxBonus / 100.0;
//
//      return model;
//    } break;
//    default:
//      return nil;
//      break;
//    }
//  }
//  return nil;
//}
- (NSString *)dp_timesTextForGameType:(GameTypeId)gameType {
  NSString *timesText =
      (NSString *)[_timesDict objectForKey:[NSNumber numberWithInt:gameType]];
  if (timesText.length == 0 || [timesText isEqualToString:@""]) {
    timesText = @"5";
  }
  return timesText;
}
- (void)dp_setTimesText:(NSString *)text forGameType:(GameTypeId)gameType {
  [_timesDict setObject:text forKey:@(gameType)];
}
- (void)dp_removeTimesData {
  [_timesDict removeAllObjects];
}
- (NSArray *)dp_getOpenOptionWithGameType:(GameTypeId)gameType {

  NSMutableArray *arrayM;
  if (_myGameType == GameTypeFootBall) {
    int options[10] = {0};
//    _lotteryJczq->GetSingleTargetOption(self.curGameIndex, gameType, options);
    arrayM = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < 10; i++) {
      [arrayM addObject:@(options[i])];
    }

  } else {

    int betOptions[12] = {0};
//    _lotteryJcLq->GetSingleTargetOption(self.curGameIndex, gameType, betOptions);
    arrayM = [NSMutableArray arrayWithCapacity:12];
    for (int i = 0; i < 12; i++) {
      [arrayM addObject:@(betOptions[i])];
    }
  }

  return arrayM;
}
- (void)dp_setOpenOptionWithGameType:(GameTypeId)gameType
                               index:(NSInteger)index
                          isSelected:(BOOL)isSelected {
  if (_myGameType == GameTypeFootBall) {
//    _lotteryJczq->SetSingleTargetOption(self.curGameIndex, gameType, (int)index, isSelected);

  } else {
//    _lotteryJcLq->SetSingleTargetOption(self.curGameIndex, gameType, (int)index, isSelected);
  }
}
- (id<DPJcdgPerTeamData>)dp_perTeamModelForIndex:(NSInteger)index
                                    withGameType:(MyGameType)type {
//  string homeTeamName, awayTeamName, homeTeamRank, awayTeamRank,
//      competitionName, endTime, orderName, homeImg, awayImg, descString;
//  int rqs, rf, zf;
//
//  if (_myGameType == GameTypeFootBall) {
//    _lotteryJczq->GetSingleTargetInfo((int)index, homeTeamName, awayTeamName,
//                                      homeTeamRank, awayTeamRank, orderName,
//                                      competitionName, endTime, rqs);
//    _lotteryJczq->GetSingleTargetImages((int)index, homeImg, awayImg,
//                                        descString);
//  } else {
//
//    _lotteryJcLq->GetSingleTargetInfo((int)index, homeTeamName, awayTeamName,
//                                      homeTeamRank, awayTeamRank, orderName,
//                                      competitionName, endTime, rf, zf);
//    _lotteryJcLq->GetSingleTargetImages((int)index, homeImg, awayImg,
//                                        descString);
//  }

//  NSString *homeTeamNameS =
//      [NSString stringWithUTF8String:homeTeamName.c_str()];
//  NSString *awayTeamNameS =
//      [NSString stringWithUTF8String:awayTeamName.c_str()];
//  NSString *homeTeamRankS =
//      [NSString stringWithUTF8String:homeTeamRank.c_str()];
//  NSString *awayTeamRankS =
//      [NSString stringWithUTF8String:awayTeamRank.c_str()];
//  NSString *competitionNameS =
//      [NSString stringWithUTF8String:competitionName.c_str()];
//  NSString *dateString = [NSString stringWithUTF8String:endTime.c_str()];
//  NSDate *date =
//      [NSDate dp_dateFromString:dateString
//                     withFormat:dp_DateFormatter_yyyy_MM_dd_HH_mm_ss];
//  NSString *endTimeS =
//      [NSString stringWithFormat:@"截止 %@%@", [date dp_weekdayNameSimple],
//                                 [date dp_stringWithFormat:@"HH:mm"]];
//  NSString *homeImgS = [NSString stringWithUTF8String:homeImg.c_str()];
//  NSString *awayImgS = [NSString stringWithUTF8String:awayImg.c_str()];
//  NSString *describString = [NSString stringWithUTF8String:descString.c_str()];
//
//  DPJcdgPerTeamModel *model = [[DPJcdgPerTeamModel alloc] init];
//  model.index = index;
//  if (_myGameType == GameTypeFootBall) {
//    model.homeName = homeTeamNameS;
//    model.awayName = awayTeamNameS;
//    model.homeRank = homeTeamRankS;
//    model.awayRank = awayTeamRankS;
//    model.homeImg = homeImgS;
//    model.awayImg = awayImgS;
//  } else {
//
//    model.homeName = awayTeamNameS;
//    model.awayName = homeTeamNameS;
//    model.homeRank = awayTeamRankS;
//    model.awayRank = homeTeamRankS;
//    model.homeImg = awayImgS;
//    model.awayImg = homeImgS;
//  }
//
//  model.compitionName = competitionNameS;
//  model.endTime = endTimeS;
//  model.sugest = describString;
//
//  return model;
    return nil;
}
- (void)dp_getWebPayMentWithRet:(int)ret {
//  if (ret >= 0) {
//    int buyType;
//    string token;
//    if (_myGameType == GameTypeFootBall) {
//      _lotteryJczq->GetWebPayment(buyType, token);
//    } else {
//      _lotteryJcLq->GetWebPayment(buyType, token);
//    }
//
//    NSString *urlString =
//        kConfirmPayURL(buyType, [NSString stringWithUTF8String:token.c_str()]);
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
//      
//    // TODO: 返回到首页
//  }
}
- (void)Notify:(int)cmdId result:(int)ret type:(int)cmdtype {

}
- (NSInteger)balanceCost {
  if (_myGameType == GameTypeFootBall) {
//    return _lotteryJczq->GetBalanceCost();
  }

  return 0;
}
- (void)dealloc {
}
@end


@implementation DPJcdgSpfCellModel
@synthesize teamsName = _teamsName;
@synthesize gameType = _gameType;
@synthesize defaultOption = _defaultOption;
@synthesize percents = _percents;
@synthesize warnContent = _warnContent;
@synthesize minBonus = _minBonus;
@synthesize maxBonus = _maxBonus;
@synthesize zhushu = _zhushu;
@end

@implementation DPJcdgZjqCellModel
@synthesize sp_Numbers = _sp_Numbers;
@synthesize defaultOption = _defaultOption;
@synthesize warnContent = _warnContent;
@synthesize gameType = _gameType;
@synthesize minBonus = _minBonus;
@synthesize maxBonus = _maxBonus;
@synthesize zhushu = _zhushu;

@end

@implementation DPJcdgGuessCellModel
@synthesize leftTeamName = _leftTeamName;
@synthesize rightTeamName = _rightTeamName;
@synthesize defaultOption = _defaultOption;
@synthesize warnContent = _warnContent;
@synthesize gameType = _gameType;
@synthesize minBonus = _minBonus;
@synthesize maxBonus = _maxBonus;
@synthesize zhushu = _zhushu;

@end

@implementation DPJcdgPerTeamModel
@synthesize homeName = _homeName;
@synthesize awayName = _awayName;
@synthesize homeRank = _homeRank;
@synthesize awayRank = _awayRank;
@synthesize homeImg = _homeImg;
@synthesize awayImg = _awayImg;
@synthesize compitionName = _compitionName;
@synthesize endTime = _endTime;
@synthesize sugest = _sugest;
@synthesize index = _index;

@end

@implementation DPJcdgBasketCellModel

@synthesize homeName = _homeName;
@synthesize awayName = _awayName;
@synthesize gameType = _gameType;
@synthesize sp_Numbers = _sp_Numbers;
@synthesize warnContent = _warnContent;
@synthesize percents = _percents;
@synthesize defaultOption = _defaultOption;
@synthesize minBonus = _minBonus;
@synthesize maxBonus = _maxBonus;
@synthesize zhushu = _zhushu;

@end
