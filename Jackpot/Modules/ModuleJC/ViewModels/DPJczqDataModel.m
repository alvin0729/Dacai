//
//  DPJczqDataModel.m
//  Jackpot
//
//  Created by Ray on 15/8/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPJczqDataModel.h"
#import <objc/runtime.h>

@implementation MatchBetOption

- (instancetype)init {
    self = [super init];
    if (self) {
        memset(&_normalOption, 0, sizeof(_normalOption));
        memset(&_htOption, 0, sizeof(_htOption));
        memset(&_dgOption, 0, sizeof(_dgOption));

        memset(&_normalSelect, 0, sizeof(_normalSelect));
        memset(&_htSelect, 0, sizeof(_htSelect));
        memset(&_dgSelect, 0, sizeof(_dgSelect));

        self.htDanTuo = NO;
        self.dgDanTuo = NO;
        self.spfDanTuo = self.rqspfDanTuo = self.bfDanTuo = self.zjqDanTuo = self.bqcDanTuo = NO;
    }
    return self;
}
- (BOOL)getMarkedStatus:(GameTypeId)gameType {
    BOOL isMarked = NO;
    switch (gameType) {
        case GameTypeJcHt:
            isMarked = self.htDanTuo;
            break;
        case GameTypeJcDg:
        case GameTypeJcDgAll:
            isMarked = self.dgDanTuo;
            break;
        case GameTypeJcSpf:
            isMarked = self.spfDanTuo;
            break;
        case GameTypeJcRqspf:
            isMarked = self.rqspfDanTuo;
            break;
        case GameTypeJcBf:
            isMarked = self.bfDanTuo;
            break;
        case GameTypeJcZjq:
            isMarked = self.zjqDanTuo;
            break;
        case GameTypeJcBqc:
            isMarked = self.bqcDanTuo;
            break;

        default:
            break;
    }
    return isMarked;
}

- (void)exchangeMarkStatus:(GameTypeId)gameType mark:(BOOL)marked {
    switch (gameType) {
        case GameTypeJcHt:
            self.htDanTuo = marked;
            break;
        case GameTypeJcDg:
        case GameTypeJcDgAll:
            self.dgDanTuo = marked;
            break;
        case GameTypeJcSpf:
            self.spfDanTuo = marked;
            break;
        case GameTypeJcRqspf:
            self.rqspfDanTuo = marked;
            break;
        case GameTypeJcBf:
            self.bfDanTuo = marked;
            break;
        case GameTypeJcZjq:
            self.zjqDanTuo = marked;
            break;
        case GameTypeJcBqc:
            self.bqcDanTuo = marked;
            break;

        default:
            break;
    }
}

- (NSInteger)getSelectedStatus:(NSInteger)total option:(int[])option {
    NSInteger count = 0;

    for (int i = 0; i < total; i++) {
        int status = option[i];
        if (status) {
            count = 1;
            break;
        }
    }

    return count;
}

- (BOOL)hasSelectedWithType:(GameTypeId)type {
    NSInteger count = 0;
    switch (type) {
        case GameTypeJcHt: {
            count += [self getSelectedStatus:3 option:self.htOption.betSpf];
            count += [self getSelectedStatus:3 option:self.htOption.betRqspf];
            count += [self getSelectedStatus:9 option:self.htOption.betBqc];
            count += [self getSelectedStatus:8 option:self.htOption.betZjq];
            count += [self getSelectedStatus:31 option:self.htOption.betBf];
        } break;
        case GameTypeJcDg:
        case GameTypeJcDgAll: {
            count += [self getSelectedStatus:3 option:self.dgOption.betSpf];
            count += [self getSelectedStatus:3 option:self.dgOption.betRqspf];
            count += [self getSelectedStatus:9 option:self.dgOption.betBqc];
            count += [self getSelectedStatus:8 option:self.dgOption.betZjq];
            count += [self getSelectedStatus:31 option:self.dgOption.betBf];
        } break;
        case GameTypeJcSpf:
            count += [self getSelectedStatus:3 option:self.normalOption.betSpf];
            break;
        case GameTypeJcRqspf:
            count += [self getSelectedStatus:3 option:self.normalOption.betRqspf];
            break;
        case GameTypeJcBf:
            count += [self getSelectedStatus:31 option:self.normalOption.betBf];
            break;
        case GameTypeJcZjq:
            count += [self getSelectedStatus:8 option:self.normalOption.betZjq];
            break;
        case GameTypeJcBqc:
            count += [self getSelectedStatus:9 option:self.normalOption.betBqc];
            break;
        default:

            break;
    }

    return count;
}

- (void)initializeOptionWithType:(GameTypeId)type {
    switch (type) {
        case GameTypeJcHt: {
            memset(&_htOption, 0, sizeof(_htOption));
            memset(&_htSelect, 0, sizeof(_htSelect));
            self.htDanTuo = NO;

        } break;
        case GameTypeJcDg:
        case GameTypeJcDgAll: {
            memset(&_dgOption, 0, sizeof(_dgOption));
            memset(&_dgSelect, 0, sizeof(_dgSelect));
            self.dgDanTuo = NO;
        } break;
        case GameTypeJcSpf: {
            memset(&_normalOption.betSpf, 0, sizeof(_normalOption.betSpf));
            memset(&_normalSelect.numSpf, 0, sizeof(_normalSelect.numSpf));
            self.spfDanTuo = NO;

        } break;
        case GameTypeJcRqspf: {
            memset(&_normalOption.betRqspf, 0, sizeof(_normalOption.betRqspf));
            memset(&_normalSelect.numRqspf, 0, sizeof(_normalSelect.numRqspf));
            self.rqspfDanTuo = NO;

        } break;
        case GameTypeJcBf: {
            memset(&_normalOption.betBf, 0, sizeof(_normalOption.betBf));
            memset(&_normalSelect.numBf, 0, sizeof(_normalSelect.numBf));
            self.bfDanTuo = NO;
        } break;
        case GameTypeJcZjq: {
            memset(&_normalOption.betZjq, 0, sizeof(_normalOption.betZjq));
            memset(&_normalSelect.numZjq, 0, sizeof(_normalSelect.numZjq));
            self.zjqDanTuo = NO;
        } break;
        case GameTypeJcBqc: {
            memset(&_normalOption.betBqc, 0, sizeof(_normalOption.betBqc));
            memset(&_normalSelect.numBqc, 0, sizeof(_normalSelect.numBqc));
            self.bqcDanTuo = NO;

        } break;
        default:

            break;
    }
}

- (void)initializeSelectNumWithType:(GameTypeId)type {
    switch (type) {
        case GameTypeJcHt: {
             memset(&_htSelect, 0, sizeof(_htSelect));
            self.htDanTuo = NO;
            
        } break;
        case GameTypeJcDg:
        case GameTypeJcDgAll: {
             memset(&_dgSelect, 0, sizeof(_dgSelect));
            self.dgDanTuo = NO;
        } break;
        case GameTypeJcSpf: {
             memset(&_normalSelect.numSpf, 0, sizeof(_normalSelect.numSpf));
            self.spfDanTuo = NO;
            
        } break;
        case GameTypeJcRqspf: {
             memset(&_normalSelect.numRqspf, 0, sizeof(_normalSelect.numRqspf));
            self.rqspfDanTuo = NO;
            
        } break;
        case GameTypeJcBf: {
             memset(&_normalSelect.numBf, 0, sizeof(_normalSelect.numBf));
            self.bfDanTuo = NO;
        } break;
        case GameTypeJcZjq: {
             memset(&_normalSelect.numZjq, 0, sizeof(_normalSelect.numZjq));
            self.zjqDanTuo = NO;
        } break;
        case GameTypeJcBqc: {
             memset(&_normalSelect.numBqc, 0, sizeof(_normalSelect.numBqc));
            self.bqcDanTuo = NO;
            
        } break;
        default:
            
            break;
    }
}
@end

static const char *matchOption_key = "matchOption_key";
static const char *gameID_keys = "gameID_keys";

@implementation PBMJczqMatch (Addation)
@dynamic matchOption;

- (NSInteger)dpGameId {
    
     return [objc_getAssociatedObject(self, gameID_keys) integerValue];
}

- (void)setDpGameId:(NSInteger)dpGameId {
    objc_setAssociatedObject(self, gameID_keys, [NSNumber numberWithInteger:dpGameId], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (MatchBetOption *)matchOption {
    MatchBetOption *option = objc_getAssociatedObject(self, matchOption_key);
    if (option == nil) {
        option = [[MatchBetOption alloc] init];
        objc_setAssociatedObject(self, matchOption_key, option,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return option;
}

- (void)updateSelectStatusWithBaseType:(GameTypeId)baseGameType
                        selectGmaeType:(GameTypeId)gametype
                                 index:(int)index
                                select:(BOOL)isSelect isAllSub:(BOOL)isAllsub{
    JczqOption option = self.matchOption.normalOption;
    JczqSelectNum selectNum = self.matchOption.normalSelect;
    
    NSInteger temp = -1 ;
    if(isAllsub){
         temp = 0 ;
    }
    switch (baseGameType) {
        case GameTypeJcHt: {
            option = self.matchOption.htOption;
            selectNum = self.matchOption.htSelect;

            switch (gametype) {
                case GameTypeJcSpf: {
                    option.betSpf[index] = isSelect;
                    selectNum.numSpf += isSelect ? 1 : temp;
                } break;
                case GameTypeJcRqspf: {
                    option.betRqspf[index] = isSelect;
                    selectNum.numRqspf += isSelect ? 1 : temp;
                } break;
                case GameTypeJcBf: {
                    option.betBf[index] = isSelect;
                    selectNum.numBf += isSelect ? 1 : temp;
                } break;
                case GameTypeJcZjq: {
                    option.betZjq[index] = isSelect;
                    selectNum.numZjq += isSelect ? 1 : temp;
                } break;
                case GameTypeJcBqc: {
                    option.betBqc[index] = isSelect;
                    selectNum.numBqc += isSelect ? 1 : temp;
                } break;

                default:
                    break;
            }
            self.matchOption.htOption = option;
            self.matchOption.htSelect = selectNum;
            return;
        } break;
        case GameTypeJcSpf: {
            option.betSpf[index] = isSelect;
            selectNum.numSpf += isSelect ? 1 : (-1);
        } break;
        case GameTypeJcRqspf: {
            option.betRqspf[index] = isSelect;
            selectNum.numRqspf += isSelect ? 1 : (-1);
        } break;

        case GameTypeJcBf: {
            option.betBf[index] = isSelect;
            selectNum.numBf += isSelect ? 1 : (-1);
        } break;
        case GameTypeJcZjq: {
            option.betZjq[index] = isSelect;
            selectNum.numZjq += isSelect ? 1 : (-1);
        } break;
        case GameTypeJcBqc: {
            option.betBqc[index] = isSelect;
            selectNum.numBqc += isSelect ? 1 : (-1);
        } break;
        case GameTypeJcDgAll:
        case GameTypeJcDg: {
            option = self.matchOption.dgOption;
            selectNum = self.matchOption.dgSelect;

            switch (gametype) {
                case GameTypeJcSpf: {
                    option.betSpf[index] = isSelect;
                    selectNum.numSpf += isSelect ? 1 : temp;
                } break;
                case GameTypeJcRqspf: {
                    option.betRqspf[index] = isSelect;
                    selectNum.numRqspf += isSelect ? 1 : temp;
                } break;
                case GameTypeJcBf: {
                    option.betBf[index] = isSelect;
                    selectNum.numBf += isSelect ? 1 : temp;
                } break;
                case GameTypeJcZjq: {
                    option.betZjq[index] = isSelect;
                    selectNum.numZjq += isSelect ? 1 : temp;
                } break;
                case GameTypeJcBqc: {
                    option.betBqc[index] = isSelect;
                    selectNum.numBqc += isSelect ? 1 : temp;
                } break;

                default:
                    break;
            }
            self.matchOption.dgOption = option;
            self.matchOption.dgSelect = selectNum;
            return;
        } break;
        default:
            break;
    }

    self.matchOption.normalOption = option;
    self.matchOption.normalSelect = selectNum;
}

- (BOOL)isSelectedWithType:(GameTypeId)type {
    BOOL isSelected = NO;
    switch (type) {
        case GameTypeJcHt: {
            if ([self.matchOption getSelectedStatus:3 option:self.matchOption.htOption.betSpf]) {
                isSelected = YES;
                break;
            }
            if ([self.matchOption getSelectedStatus:3 option:self.matchOption.htOption.betRqspf]) {
                isSelected = YES;
                break;
            }

            if ([self.matchOption getSelectedStatus:31 option:self.matchOption.htOption.betBf]) {
                isSelected = YES;
                break;
            }
            if ([self.matchOption getSelectedStatus:8 option:self.matchOption.htOption.betZjq]) {
                isSelected = YES;
                break;
            }
            if ([self.matchOption getSelectedStatus:9 option:self.matchOption.htOption.betBqc]) {
                isSelected = YES;
                break;
            }

        } break;
        case GameTypeJcSpf: {
            if ([self.matchOption getSelectedStatus:3 option:self.matchOption.normalOption.betSpf]) {
                isSelected = YES;
            }

        } break;
        case GameTypeJcRqspf: {
            if ([self.matchOption getSelectedStatus:3 option:self.matchOption.normalOption.betRqspf]) {
                isSelected = YES;
            }
        } break;
        case GameTypeJcBf: {
            if ([self.matchOption getSelectedStatus:31 option:self.matchOption.normalOption.betBf]) {
                isSelected = YES;
            }
        } break;
        case GameTypeJcZjq: {
            if ([self.matchOption getSelectedStatus:8 option:self.matchOption.normalOption.betZjq]) {
                isSelected = YES;
            }
        } break;
        case GameTypeJcBqc: {
            if ([self.matchOption getSelectedStatus:9 option:self.matchOption.normalOption.betBqc]) {
                isSelected = YES;
            }
        } break;
        case GameTypeJcDg:
        case GameTypeJcDgAll: {
            if ([self.matchOption getSelectedStatus:3 option:self.matchOption.dgOption.betSpf]) {
                isSelected = YES;
                break;
            }
            if ([self.matchOption getSelectedStatus:3 option:self.matchOption.dgOption.betRqspf]) {
                isSelected = YES;
                break;
            }

            if ([self.matchOption getSelectedStatus:31 option:self.matchOption.dgOption.betBf]) {
                isSelected = YES;
                break;
            }
            if ([self.matchOption getSelectedStatus:8 option:self.matchOption.dgOption.betZjq]) {
                isSelected = YES;
                break;
            }
            if ([self.matchOption getSelectedStatus:9 option:self.matchOption.dgOption.betBqc]) {
                isSelected = YES;
                break;
            }
        }
        default:
            isSelected = NO;
            break;
    }

    return isSelected;
}

- (NSArray *)getSelectedTypeArrWithType:(GameTypeId)type {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    switch (type) {
        case GameTypeJcHt: {
            if ([self.matchOption getSelectedStatus:3 option:self.matchOption.htOption.betSpf]) {
                [arr addObject:[NSNumber numberWithInt:GameTypeJcSpf]];
            }
            if ([self.matchOption getSelectedStatus:3 option:self.matchOption.htOption.betRqspf]) {
                [arr addObject:[NSNumber numberWithInt:GameTypeJcRqspf]];
            }

            if ([self.matchOption getSelectedStatus:31 option:self.matchOption.htOption.betBf]) {
                [arr addObject:[NSNumber numberWithInt:GameTypeJcBf]];
            }
            if ([self.matchOption getSelectedStatus:8 option:self.matchOption.htOption.betZjq]) {
                [arr addObject:[NSNumber numberWithInt:GameTypeJcZjq]];
            }
            if ([self.matchOption getSelectedStatus:9 option:self.matchOption.htOption.betBqc]) {
                [arr addObject:[NSNumber numberWithInt:GameTypeJcBqc]];
            }

        } break;
        case GameTypeJcSpf: {
            if ([self.matchOption getSelectedStatus:3 option:self.matchOption.normalOption.betSpf]) {
                [arr addObject:[NSNumber numberWithInt:GameTypeJcSpf]];
            }

        } break;
        case GameTypeJcRqspf: {
            if ([self.matchOption getSelectedStatus:3 option:self.matchOption.normalOption.betRqspf]) {
                [arr addObject:[NSNumber numberWithInt:GameTypeJcRqspf]];
            }
        } break;
        case GameTypeJcBf: {
            if ([self.matchOption getSelectedStatus:31 option:self.matchOption.normalOption.betBf]) {
                [arr addObject:[NSNumber numberWithInt:GameTypeJcBf]];
            }
        } break;
        case GameTypeJcZjq: {
            if ([self.matchOption getSelectedStatus:8 option:self.matchOption.normalOption.betZjq]) {
                [arr addObject:[NSNumber numberWithInt:GameTypeJcZjq]];
            }
        } break;
        case GameTypeJcBqc: {
            if ([self.matchOption getSelectedStatus:9 option:self.matchOption.normalOption.betBqc]) {
                [arr addObject:[NSNumber numberWithInt:GameTypeJcBqc]];
            }
        } break;
        case GameTypeJcDg:
        case GameTypeJcDgAll: {
            if ([self.matchOption getSelectedStatus:3 option:self.matchOption.dgOption.betSpf]) {
                [arr addObject:[NSNumber numberWithInt:GameTypeJcSpf]];
            }
            if ([self.matchOption getSelectedStatus:3 option:self.matchOption.dgOption.betRqspf]) {
                [arr addObject:[NSNumber numberWithInt:GameTypeJcRqspf]];
            }

            if ([self.matchOption getSelectedStatus:31 option:self.matchOption.dgOption.betBf]) {
                [arr addObject:[NSNumber numberWithInt:GameTypeJcBf]];
            }
            if ([self.matchOption getSelectedStatus:8 option:self.matchOption.dgOption.betZjq]) {
                [arr addObject:[NSNumber numberWithInt:GameTypeJcZjq]];
            }
            if ([self.matchOption getSelectedStatus:9 option:self.matchOption.dgOption.betBqc]) {
                [arr addObject:[NSNumber numberWithInt:GameTypeJcBqc]];
            }

        } break;
        default:
            break;
    }

    return arr;
}

- (BOOL)isSelectedAllSignalWithType:(GameTypeId)type {
    BOOL isAllsignal = YES;
    switch (type) {
        case GameTypeJcHt: {
            if ([self.matchOption getSelectedStatus:3 option:self.matchOption.htOption.betSpf]) {
                if (!self.spfItem.supportSingle) {
                    isAllsignal = NO;
                }
            }
            if ([self.matchOption getSelectedStatus:3 option:self.matchOption.htOption.betRqspf]) {
                if (!self.rqspfItem.supportSingle) {
                    isAllsignal = NO;
                }
            }

            if ([self.matchOption getSelectedStatus:31 option:self.matchOption.htOption.betBf]) {
                if (!self.bfItem.supportSingle) {
                    isAllsignal = NO;
                }
            }
            if ([self.matchOption getSelectedStatus:8 option:self.matchOption.htOption.betZjq]) {
                if (!self.zjqItem.supportSingle) {
                    isAllsignal = NO;
                }
            }
            if ([self.matchOption getSelectedStatus:9 option:self.matchOption.htOption.betBqc]) {
                if (!self.bqcItem.supportSingle) {
                    isAllsignal = NO;
                }
            }

        } break;
        case GameTypeJcSpf: {
            if ([self.matchOption getSelectedStatus:3 option:self.matchOption.normalOption.betSpf]) {
                if (!self.spfItem.supportSingle) {
                    isAllsignal = NO;
                }
            }

        } break;
        case GameTypeJcRqspf: {
            if ([self.matchOption getSelectedStatus:3 option:self.matchOption.normalOption.betRqspf]) {
                if (!self.rqspfItem.supportSingle) {
                    isAllsignal = NO;
                }
            }
        } break;
        case GameTypeJcBf: {
            if ([self.matchOption getSelectedStatus:31 option:self.matchOption.normalOption.betBf]) {
                if (!self.bfItem.supportSingle) {
                    isAllsignal = NO;
                }
            }
        } break;
        case GameTypeJcZjq: {
            if ([self.matchOption getSelectedStatus:8 option:self.matchOption.normalOption.betZjq]) {
                if (!self.zjqItem.supportSingle) {
                    isAllsignal = NO;
                }
            }
        } break;
        case GameTypeJcBqc: {
            if ([self.matchOption getSelectedStatus:9 option:self.matchOption.normalOption.betBqc]) {
                if (!self.bqcItem.supportSingle) {
                    isAllsignal = NO;
                }
            }
        } break;
        case GameTypeJcDg:
        case GameTypeJcDgAll:
            isAllsignal = YES;
            break;
        default:
            isAllsignal = YES;
            break;
    }

    return isAllsignal;
}

@end

@implementation DPJczqTranseModel

@end
