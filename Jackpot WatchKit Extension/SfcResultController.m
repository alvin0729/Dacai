//
//  SfcResultController.m
//  Jackpot
//
//  Created by sxf on 15/7/23.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "SfcResultController.h"

#import "DPWatchShareDataDefine.h"

#import <MMWormhole/MMWormhole.h>
@interface SfcResultController ()

@property (nonatomic, strong) MMWormhole *wormhole;
@end

@implementation SfcResultController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@KWatchGroupIdentifier
                                                         optionalDirectory:@KWatchOptionalDirectory];
    [self.wormhole listenForMessageWithIdentifier:@KWatchResultSfc listener:^(id messageObject) {
        [self updataAllData:messageObject];
    }];

    // Configure interface objects here.
}
-(void)updataAllData:(NSDictionary *)dic{
    if (dic==nil) {
        [self.drawGroup setHidden:YES];
        return;
    }
    NSString *issue = [NSString stringWithFormat:@"%@期开奖号码",[dic valueForKey:@KWatchResultSfcIssue]];
    NSArray *array=[dic objectForKey:@KWatchResultSfcDrawing];
    NSString *drawTime=[dic objectForKey:@KWatchResultSfcDrawTime];
    if (array.count<14) {
        return ;
    }
    [self.drawGroup setHidden:NO];
    [self.drawLabel1  setText:[array objectAtIndex:0]];
    [self.drawLabel2  setText:[array objectAtIndex:1]];
    [self.drawLabel3  setText:[array objectAtIndex:2]];
    [self.drawLabel4  setText:[array objectAtIndex:3]];
    [self.drawLabel5  setText:[array objectAtIndex:4]];
    [self.drawLabel6  setText:[array objectAtIndex:5]];
    [self.drawLabel7  setText:[array objectAtIndex:6]];
    [self.drawLabel8  setText:[array objectAtIndex:7]];
    [self.drawLabel9  setText:[array objectAtIndex:8]];
    [self.drawLabel10 setText:[array objectAtIndex:9]];
    [self.drawLabel11 setText:[array objectAtIndex:10]];
    [self.drawLabel12 setText:[array objectAtIndex:11]];
    [self.drawLabel13 setText:[array objectAtIndex:12]];
    [self.drawLabel14 setText:[array objectAtIndex:13]];
    [self.issueLabel setText:issue];
    [self.drawTimeLabel setText:drawTime];

}
- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    NSDictionary *dic=[self.wormhole messageWithIdentifier:@KWatchResultSfc];
    [self updataAllData:dic];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



