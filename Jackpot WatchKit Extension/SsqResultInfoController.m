//
//  SsqResultInfoController.m
//  Jackpot
//
//  Created by sxf on 15/7/23.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "SsqResultInfoController.h"

#import "DPWatchShareDataDefine.h"

#import <MMWormhole/MMWormhole.h>
@interface SsqResultInfoController ()
@property (nonatomic, strong) MMWormhole *wormhole;
@end
#define kDataCenterLogoImageLength 27.5f

@implementation SsqResultInfoController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@KWatchGroupIdentifier
                                                        optionalDirectory:@KWatchOptionalDirectory];
    [self.wormhole listenForMessageWithIdentifier:@KWatchResultSsq listener:^(id messageObject) {
      
         [self updataAllData:messageObject];
    }];

    // Configure interface objects here.
}
-(void)updataAllData:(NSDictionary *)dic{
    if (dic==nil) {
         [self.drawGroup setHidden:YES];
        return;
    }
    NSString *issue = [NSString stringWithFormat:@"%@期开奖号码",[dic valueForKey:@KWatchResultSsqIssue]];
    NSArray *array=[dic objectForKey:@KWatchResultSsqDrawing];
    NSString *drawTime=[dic objectForKey:@KWatchResultSsqDrawTime];
    if (array.count<7) {
        [self.drawGroup setHidden:YES];
        return ;
    }
    [self.drawGroup setHidden:NO];
    [self.drawLabel1 setText:[array objectAtIndex:0]];
    [self.drawLabel2 setText:[array objectAtIndex:1]];
    [self.drawLabel3 setText:[array objectAtIndex:2]];
    [self.drawLabel4 setText:[array objectAtIndex:3]];
    [self.drawLabel5 setText:[array objectAtIndex:4]];
    [self.drawLabel6 setText:[array objectAtIndex:5]];
    [self.drawLabel7 setText:[array objectAtIndex:6]];
    [self.issueLabel setText:issue];
    [self.drawTimeLabel setText:drawTime];
}
- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    NSDictionary *dic=[self.wormhole messageWithIdentifier:@KWatchResultSsq];
    [self updataAllData:dic];

   
}
- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



