//
//  GlanceController.m
//  Jackpot WatchKit Extension
//
//  Created by sxf on 15/7/21.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "GlanceController.h"
#import <MMWormhole/MMWormhole.h>
#import "DPWatchShareDataDefine.h"


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0x00FF0000) >> 16)) / 255.0     \
green:((float)((rgbValue & 0x0000FF00) >>  8)) / 255.0     \
blue:((float)((rgbValue & 0x000000FF) >>  0)) / 255.0     \
alpha:1.0]

@interface GlanceController()

@property (nonatomic, strong) MMWormhole *wormhole;
@end


@implementation GlanceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@KWatchGroupIdentifier
                                                         optionalDirectory:@KWatchOptionalDirectory];
    NSInteger bonus=[[self.wormhole messageWithIdentifier:@KWatchGlaceBonus] integerValue];
    [self updateAllData:bonus];
    [self updateRequest];
    [self.wormhole listenForMessageWithIdentifier:@KWatchResultDlt listener:^(id messageObject) {
        
        [self updateAllData:[messageObject integerValue]];
    }];
 
}
-(void)updateRequest{
    [WKInterfaceController openParentApplication:@{@"action": @KWatchGlance} reply:^(NSDictionary *replyInfo, NSError *error) {
        if (error|| !replyInfo) {
            return ;
        }
    }];
}
-(void)updateAllData:(NSInteger)bonus{
    if (bonus<1) {
        [self.issueLabel setHidden:YES];
         [self.infoLabel setHidden:YES];
         [self.noDataLabel setHidden:NO];
        return;
    }else{
        [self.issueLabel setHidden:NO];
        [self.infoLabel setHidden:NO];
        [self.noDataLabel setHidden:YES];
    }
    // TODO:
    
    NSMutableAttributedString *hinstring=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"奖池%@",[self logogramForMoney:bonus]]];
    [hinstring addAttribute:NSForegroundColorAttributeName value:(id)[UIColor whiteColor] range:NSMakeRange(0,hinstring.length)];
    [hinstring addAttribute:NSForegroundColorAttributeName value:(id)UIColorFromRGB(0xf6cb01) range:NSMakeRange(0,2)];
    [hinstring addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(0, hinstring.length)];
    [hinstring addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 2)];
    [self.issueLabel setAttributedText:hinstring];
    
    NSString *bonusTotal=[NSString stringWithFormat:@"%zd",bonus/5000000];
    NSMutableAttributedString *hinstring2=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"可中出%@注500万",bonusTotal]];
    [hinstring2 addAttribute:NSForegroundColorAttributeName value:(id)[UIColor whiteColor] range:NSMakeRange(0,hinstring.length)];
    [hinstring2 addAttribute:NSForegroundColorAttributeName value:(id)UIColorFromRGB(0xf6cb01) range:NSMakeRange(3,bonusTotal.length)];
    [hinstring2 addAttribute:NSForegroundColorAttributeName value:(id)UIColorFromRGB(0xf6cb01) range:NSMakeRange(3+bonusTotal.length+1,4)];
    [self.infoLabel setAttributedText:hinstring2];


    
}
- (NSString *)logogramForMoney:(NSInteger)money {
    if (money < 0) {
        return @"";
    }
    NSString *string1 = @"0";
    NSString *string2 = @"元";
    if (money / 100000000.0 >= 1) {
        string1 = [NSString stringWithFormat:@"%.2f", money / 100000000.0];
        string2 = @"亿元";
    } else {
        if (money / 1000000.0 >= 1) {
            string1 = [NSString stringWithFormat:@"%.2f", money / 10000000.0];
            string2 = @"千万元";
        } else {
            return @"";
        }
    }
    return [NSString stringWithFormat:@"%@%@", string1, string2];
}
- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



