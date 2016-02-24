//
//  DPJclqDataModel.m
//  Jackpot
//
//  Created by Ray on 15/8/7.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPJclqDataModel.h"
#import <objc/runtime.h>

@implementation MatchLcOption

- (instancetype)init {
    self = [super init];
    if (self) {
        memset(&_normalOption, 0, sizeof(_normalOption));
        memset(&_htOption, 0, sizeof(_htOption));

        memset(&_normalSelect, 0, sizeof(_normalSelect));
        memset(&_htSelect, 0, sizeof(_htSelect));

        self.htDanTuo = self.sfDanTuo = self.rfsfDanTuo = self.dxfDanTuo = self.sfcDanTuo = NO;
    }
    return self;
}

- (BOOL)getMarkedStatus:(GameTypeId)gameType {
    BOOL isMarked = NO;
    switch (gameType) {
        case GameTypeLcHt:
            isMarked = self.htDanTuo;
            break;

        case GameTypeLcSf:
            isMarked = self.sfDanTuo;
            break;

        case GameTypeLcRfsf:
            isMarked = self.rfsfDanTuo;
            break;
        case GameTypeLcDxf:
            isMarked = self.dxfDanTuo;
            break;
        case GameTypeLcSfc:
            isMarked = self.sfcDanTuo;
            break;

        default:
            break;
    }
    return isMarked;
}

- (void)exchangeMarkStatus:(GameTypeId)gameType mark:(BOOL)marked {
    switch (gameType) {
        case GameTypeLcHt:
            self.htDanTuo = marked;
            break;

        case GameTypeLcSf:
            self.sfDanTuo = marked;
            break;

        case GameTypeLcRfsf:
            self.rfsfDanTuo = marked;
            break;
        case GameTypeLcDxf:
            self.dxfDanTuo = marked;
            break;
        case GameTypeLcSfc:
            self.sfcDanTuo = marked;
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
        case GameTypeLcHt: {
            count += [self getSelectedStatus:2 option:self.htOption.betSf];
            count += [self getSelectedStatus:2 option:self.htOption.betRfsf];
            count += [self getSelectedStatus:2 option:self.htOption.betDxf];
            count += [self getSelectedStatus:12 option:self.htOption.betSfc];
        } break;

        case GameTypeLcSf:
            count += [self getSelectedStatus:2 option:self.normalOption.betSf];
            break;
        case GameTypeLcRfsf:
            count += [self getSelectedStatus:2 option:self.normalOption.betRfsf];
            break;
        case GameTypeLcDxf:
            count += [self getSelectedStatus:2 option:self.normalOption.betDxf];
            break;
        case GameTypeLcSfc:
            count += [self getSelectedStatus:12 option:self.normalOption.betSfc];
            break;

        default:

            break;
    }

    return count;
}

- (void)initializeOptionWithType:(GameTypeId)type {
    switch (type) {
        case GameTypeLcHt: {
            memset(&_htOption, 0, sizeof(_htOption));
            memset(&_htSelect, 0, sizeof(_htSelect));
            self.htDanTuo = NO;
        } break;
        case GameTypeLcSf: {
            memset(&_normalOption.betSf, 0, sizeof(_normalOption.betSf));
            memset(&_normalSelect.numSf, 0, sizeof(_normalSelect.numSf));
            self.sfDanTuo = NO;

        } break;
        case GameTypeLcRfsf: {
            memset(&_normalOption.betRfsf, 0, sizeof(_normalOption.betRfsf));
            memset(&_normalSelect.numRfsf, 0, sizeof(_normalSelect.numRfsf));
            self.rfsfDanTuo = NO;

        } break;
        case GameTypeLcDxf: {
            memset(&_normalOption.betDxf, 0, sizeof(_normalOption.betDxf));
            memset(&_normalSelect.numDxf, 0, sizeof(_normalSelect.numDxf));
            self.dxfDanTuo = NO;

        } break;
        case GameTypeLcSfc: {
            memset(&_normalOption.betSfc, 0, sizeof(_normalOption.betSfc));
            memset(&_normalSelect.numSfc, 0, sizeof(_normalSelect.numSfc));
            self.sfcDanTuo = NO;

        } break;

        default:

            break;
    }
}

- (void)initializeSelectNumWithType:(GameTypeId)type {
    switch (type) {
        case GameTypeLcHt: {
            memset(&_htSelect, 0, sizeof(_htSelect));
            self.htDanTuo = NO;
        } break;
        case GameTypeLcSf: {
            memset(&_normalSelect.numSf, 0, sizeof(_normalSelect.numSf));
            self.sfDanTuo = NO;

        } break;
        case GameTypeLcRfsf: {
            memset(&_normalSelect.numRfsf, 0, sizeof(_normalSelect.numRfsf));
            self.rfsfDanTuo = NO;

        } break;
        case GameTypeLcDxf: {
            memset(&_normalSelect.numDxf, 0, sizeof(_normalSelect.numDxf));
            self.dxfDanTuo = NO;

        } break;
        case GameTypeLcSfc: {
            memset(&_normalSelect.numSfc, 0, sizeof(_normalSelect.numSfc));
            self.sfcDanTuo = NO;

        } break;

        default:

            break;
    }
}

@end

static const char *matchOption_key = "matchLcOption_key";
static const char *gameID_key = "gameID_key";

@implementation PBMJclqMatch (Addation)
@dynamic matchOption, dp_gameId;

- (int)dp_gameId {
    return [objc_getAssociatedObject(self, gameID_key) intValue];
}

- (void)setDp_gameId:(int)dp_gameId {
    objc_setAssociatedObject(self, gameID_key, [NSNumber numberWithInt:dp_gameId], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MatchLcOption *)matchOption {
    MatchLcOption *option = objc_getAssociatedObject(self, matchOption_key);
    if (option == nil) {
        option = [[MatchLcOption alloc] init];
        objc_setAssociatedObject(self, matchOption_key, option,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return option;
}

- (BOOL)isSelectedWithType:(GameTypeId)type {
    BOOL isSelected = NO;
    switch (type) {
        case GameTypeLcHt: {
            if ([self.matchOption getSelectedStatus:2 option:self.matchOption.htOption.betSf]) {
                isSelected = YES;
                break;
            }
            if ([self.matchOption getSelectedStatus:2 option:self.matchOption.htOption.betRfsf]) {
                isSelected = YES;
                break;
            }

            if ([self.matchOption getSelectedStatus:2 option:self.matchOption.htOption.betDxf]) {
                isSelected = YES;
                break;
            }
            if ([self.matchOption getSelectedStatus:12 option:self.matchOption.htOption.betSfc]) {
                isSelected = YES;
                break;
            }

        } break;
        case GameTypeLcSf: {
            if ([self.matchOption getSelectedStatus:2 option:self.matchOption.normalOption.betSf]) {
                isSelected = YES;
            }

        } break;
        case GameTypeLcRfsf: {
            if ([self.matchOption getSelectedStatus:2 option:self.matchOption.normalOption.betRfsf]) {
                isSelected = YES;
            }
        } break;
        case GameTypeLcDxf: {
            if ([self.matchOption getSelectedStatus:2 option:self.matchOption.normalOption.betDxf]) {
                isSelected = YES;
            }
        } break;
        case GameTypeLcSfc: {
            if ([self.matchOption getSelectedStatus:12 option:self.matchOption.normalOption.betSfc]) {
                isSelected = YES;
            }
        } break;

        default:
            isSelected = NO;
            break;
    }

    return isSelected;
}

- (NSArray *)getSelectedTypeArrWithType:(GameTypeId)type {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    switch (type) {
        case GameTypeLcHt: {
            if ([self.matchOption getSelectedStatus:2 option:self.matchOption.htOption.betSf]) {
                [arr addObject:[NSNumber numberWithInt:GameTypeLcSf]];
            }
            if ([self.matchOption getSelectedStatus:2 option:self.matchOption.htOption.betRfsf]) {
                [arr addObject:[NSNumber numberWithInt:GameTypeLcRfsf]];
            }

            if ([self.matchOption getSelectedStatus:2 option:self.matchOption.htOption.betDxf]) {
                [arr addObject:[NSNumber numberWithInt:GameTypeLcDxf]];
            }
            if ([self.matchOption getSelectedStatus:12 option:self.matchOption.htOption.betSfc]) {
                [arr addObject:[NSNumber numberWithInt:GameTypeLcSfc]];
            }

        } break;
        case GameTypeLcSf: {
            if ([self.matchOption getSelectedStatus:2 option:self.matchOption.normalOption.betSf]) {
                [arr addObject:[NSNumber numberWithInt:GameTypeLcSf]];
            }

        } break;
        case GameTypeLcRfsf: {
            if ([self.matchOption getSelectedStatus:2 option:self.matchOption.normalOption.betRfsf]) {
                [arr addObject:[NSNumber numberWithInt:GameTypeLcRfsf]];
            }
        } break;
        case GameTypeLcDxf: {
            if ([self.matchOption getSelectedStatus:2 option:self.matchOption.normalOption.betDxf]) {
                [arr addObject:[NSNumber numberWithInt:GameTypeLcDxf]];
            }
        } break;
        case GameTypeLcSfc: {
            if ([self.matchOption getSelectedStatus:12 option:self.matchOption.normalOption.betSfc]) {
                [arr addObject:[NSNumber numberWithInt:GameTypeLcSfc]];
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
        case GameTypeLcHt: {
            if ([self.matchOption getSelectedStatus:2 option:self.matchOption.htOption.betSf]) {
                if (!self.sfItem.supportSingle) {
                    isAllsignal = NO;
                }
            }
            if ([self.matchOption getSelectedStatus:2 option:self.matchOption.htOption.betRfsf]) {
                if (!self.rfsfItem.supportSingle) {
                    isAllsignal = NO;
                }
            }

            if ([self.matchOption getSelectedStatus:2 option:self.matchOption.htOption.betDxf]) {
                if (!self.dxfItem.supportSingle) {
                    isAllsignal = NO;
                }
            }
            if ([self.matchOption getSelectedStatus:12 option:self.matchOption.htOption.betSfc]) {
                if (!self.sfcItem.supportSingle) {
                    isAllsignal = NO;
                }
            }

        } break;
        case GameTypeLcSf: {
            if ([self.matchOption getSelectedStatus:2 option:self.matchOption.normalOption.betSf]) {
                if (!self.sfItem.supportSingle) {
                    isAllsignal = NO;
                }
            }

        } break;
        case GameTypeLcRfsf: {
            if ([self.matchOption getSelectedStatus:2 option:self.matchOption.normalOption.betRfsf]) {
                if (!self.rfsfItem.supportSingle) {
                    isAllsignal = NO;
                }
            }
        } break;
        case GameTypeLcDxf: {
            if ([self.matchOption getSelectedStatus:2 option:self.matchOption.normalOption.betDxf]) {
                if (!self.dxfItem.supportSingle) {
                    isAllsignal = NO;
                }
            }
        } break;
        case GameTypeLcSfc: {
            if ([self.matchOption getSelectedStatus:12 option:self.matchOption.normalOption.betSfc]) {
                if (!self.sfcItem.supportSingle) {
                    isAllsignal = NO;
                }
            }
        } break;

        default:
            isAllsignal = YES;
            break;
    }

    return isAllsignal;
}

- (void)updateSelectStatusWithBaseType:(GameTypeId)baseGameType
                        selectGmaeType:(GameTypeId)gametype
                                 index:(int)index
                                select:(BOOL)isSelect
                              isAllSub:(BOOL)isAllSub {
    JclqOption option = self.matchOption.normalOption;
    JclqSelectNum selectNum = self.matchOption.normalSelect;

    NSInteger temp = isAllSub ? 0 : -1;

    switch (baseGameType) {
        case GameTypeLcHt: {
            option = self.matchOption.htOption;
            selectNum = self.matchOption.htSelect;

            switch (gametype) {
                case GameTypeLcSf: {
                    option.betSf[index] = isSelect;
                    selectNum.numSf += isSelect ? 1 : temp;
                } break;
                case GameTypeLcRfsf: {
                    option.betRfsf[index] = isSelect;
                    selectNum.numRfsf += isSelect ? 1 : temp;
                } break;
                case GameTypeLcDxf: {
                    option.betDxf[index] = isSelect;
                    selectNum.numDxf += isSelect ? 1 : temp;
                } break;
                case GameTypeLcSfc: {
                    option.betSfc[index] = isSelect;
                    selectNum.numSfc += isSelect ? 1 : temp;
                } break;

                default:
                    break;
            }
            self.matchOption.htOption = option;
            self.matchOption.htSelect = selectNum;

            return;
        } break;
        case GameTypeLcSf: {
            option.betSf[index] = isSelect;
            selectNum.numSf += isSelect ? 1 : (-1);

        } break;
        case GameTypeLcRfsf: {
            option.betRfsf[index] = isSelect;
            selectNum.numRfsf += isSelect ? 1 : (-1);
        } break;

        case GameTypeLcDxf: {
            option.betDxf[index] = isSelect;
            selectNum.numDxf += isSelect ? 1 : (-1);
        } break;
        case GameTypeLcSfc: {
            option.betSfc[index] = isSelect;
            selectNum.numSfc += isSelect ? 1 : temp;
        } break;

        default:
            break;
    }

    self.matchOption.normalOption = option;
    self.matchOption.normalSelect = selectNum;
}

@end
