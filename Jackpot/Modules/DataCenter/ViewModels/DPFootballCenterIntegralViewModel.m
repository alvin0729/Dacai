//
//  DPFootballCenterIntegralViewModel.m
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPFootballCenterIntegralViewModel.h"
#import "DPDataCenterBaseViewModel+Private.h"
#import "FootballDataCenter.pbobjc.h"


@interface DPFootballCenterIntegralTeamModel : NSObject
@property (nonatomic, strong) NSArray *textList;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@end
@implementation DPFootballCenterIntegralTeamModel
@end


@implementation DPFootballCenterIntegralViewModel {
    NSArray *_teamModelList;
}

#pragma mark - Public Interface

- (NSArray *)textListAtIndex:(NSInteger)index {
    return [self teamModelAtIndex:index].textList;
}

- (UIColor *)textColorAtIndex:(NSInteger)index {
    return [self teamModelAtIndex:index].textColor;
}

- (UIColor *)backgroundColorAtIndex:(NSInteger)index {
    return [self teamModelAtIndex:index].backgroundColor;
}

#pragma mark - Private Interface

- (DPFootballCenterIntegralTeamModel *)teamModelAtIndex:(NSInteger)index {
    return [_teamModelList dp_safeObjectAtIndex:index];
}

#pragma mark - Property (getter, setter) 

- (NSInteger)rowCount {
    return _teamModelList.count;
}

#pragma mark - IDPDataCenterViewModel

- (NSString *)fetchURL {
    return @"/datacenter/GetFootBallTeamRanking";
}

- (void)parserData:(NSData *)data {
    PBMFootIntegral *message = [PBMFootIntegral parseFromData:data error:nil];
    NSAssert(message.areaNameArray.count == message.areaColorArray.count, @"failure...");
    
    MTStringParser *areaParser = [[MTStringParser alloc] init];
    [areaParser setDefaultAttributes:({
        MTStringAttributes *attr = [[MTStringAttributes alloc] init];
        attr.font = [UIFont dp_systemFontOfSize:11];
        attr.textColor = UIColorFromRGB(0x535353);
        attr;
    })];
    NSMutableArray *markupTextArray = [NSMutableArray arrayWithCapacity:message.areaNameArray.count];
    for (int i = 0; i < message.areaColorArray.count; i++) {
        NSString *hexColor = [[message.areaColorArray objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
        NSString *name = [message.areaNameArray objectAtIndex:i];
        NSString *markupText = [NSString stringWithFormat:@"<%@>■</%@>%@", hexColor, hexColor, name];
        [markupTextArray addObject:markupText];
        
        UIColor *color = [UIColor dp_colorFromHexString:hexColor];
        [areaParser addStyleWithTagName:hexColor color:color];
    }
    NSMutableArray *teamList = [NSMutableArray arrayWithCapacity:message.integralListArray.count];
    for (PBMFootIntegral_IntegralDetailInfo *info in message.integralListArray) {
        DPFootballCenterIntegralTeamModel *team = [[DPFootballCenterIntegralTeamModel alloc] init];
        team.textList = @[ [NSString stringWithFormat:@"%d", info.rank],
                           [NSString stringWithString:info.team],
                           [NSString stringWithFormat:@"%d", info.winTimes + info.tieTimes + info.loseTimes],
                           [NSString stringWithFormat:@"%d", info.winTimes],
                           [NSString stringWithFormat:@"%d", info.tieTimes],
                           [NSString stringWithFormat:@"%d", info.loseTimes],
                           [NSString stringWithFormat:@"%d", info.point] ];
        team.backgroundColor = info.color.length ? [UIColor dp_colorFromHexString:info.color] : [UIColor dp_flatWhiteColor];
        team.textColor = ([info.team isEqualToString:message.matchInfo.homeTeamName] ||
                          [info.team isEqualToString:message.matchInfo.awayTeamName]) ? [UIColor dp_flatRedColor] : UIColorFromRGB(0x535353);
        [teamList addObject:team];
    }
    
    _title = message.title.copy;
    _areaText = [areaParser attributedStringFromMarkup:[markupTextArray componentsJoinedByString:@"  "]];
    _teamModelList = teamList;
    
    [self updateHeaderInfo:message.matchInfo];
}

@end
