//
//  DPDltContentModel.m
//  Jackpot
//
//  Created by WUFAN on 15/12/18.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPDltContentModel.h"

@interface DPProjectDltBaseModel () 
@end
@implementation DPProjectDltBaseModel

#pragma mark - YYModel

+ (Class)modelCustomClassForDictionary:(NSDictionary *)dictionary {
    NSString *type = dictionary[@"__type"];
    return type ? NSClassFromString([@"DPProject" stringByAppendingString:type]) : nil;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"add": @"IsAdd",
              @"single": @"IsSingle",
              @"bets": @"Bets",
              @"backAreaNums": @"BackAreaNums",
              @"propAreaNums": @"PropAreaNums",
              @"backAreaGalls": @"BackAreaGalls",
              @"propAreaGalls": @"PropAreaGalls",
              @"backAreaDrags": @"BackAreaDrags",
              @"propAreaDrags": @"PropAreaDrags", };
}

- (NSString *)title {
    NSString *type;
    if ([self isKindOfClass:[DPProjectDltDuplex class]]) {
        type = @"复式";
    } else if ([self isKindOfClass:[DPProjectDltSingle class]]) {
        type = @"单式";
    } else if ([self isKindOfClass:[DPProjectDltGallDrag class]]) {
        type = @"带胆复式";
    }
    return [NSString stringWithFormat:@"%@  %d注", type, (int)self.note];
}

@end

@implementation DPProjectDltDuplex
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"backAreaNums": NSString.class,
              @"propAreaNums": NSString.class };
}
- (NSInteger)note {
    return [DPNoteCalculater calcDltWithRedTuo:(int)self.propAreaNums.count redDan:0 blueTuo:(int)self.backAreaNums.count blueDan:0];
}

@end

@implementation DPProjectDltSingle
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"bets": NSString.class };
}
- (NSInteger)note {
    return self.bets.count;
}
@end

@implementation DPProjectDltGallDrag
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"backAreaGalls": NSString.class,
              @"propAreaGalls": NSString.class,
              @"backAreaDrags": NSString.class,
              @"propAreaDrags": NSString.class, };
}
- (NSInteger)note {
    return [DPNoteCalculater calcDltWithRedTuo:(int)self.propAreaDrags.count redDan:(int)self.propAreaGalls.count blueTuo:(int)self.backAreaDrags.count blueDan:(int)self.backAreaGalls.count];
}
@end