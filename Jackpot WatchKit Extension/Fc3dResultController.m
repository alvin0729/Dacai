//
//  Fc3dResultController.m
//  Jackpot
//
//  Created by sxf on 15/7/23.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "Fc3dResultController.h"
#import "DPWatchShareDataDefine.h"
#import <MMWormhole/MMWormhole.h>
@interface Fc3dResultController ()

@property (nonatomic, strong) MMWormhole *wormhole;
@end

@implementation Fc3dResultController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@KWatchGroupIdentifier
                                                         optionalDirectory:@KWatchOptionalDirectory];
    [self.wormhole listenForMessageWithIdentifier:@KWatchResultFc3d listener:^(id messageObject) {
       
        [self updataAllData:messageObject];
    }];

    // Configure interface objects here.
}
-(void)updataAllData:(NSDictionary *)dic{
    if (dic==nil) {
        [self.drawGroup setHidden:YES];
        return;
    }
    NSString *issue = [NSString stringWithFormat:@"%@期开奖号码",[dic valueForKey:@KWatchResultFc3dIssue]];
    NSArray *array=[dic objectForKey:@KWatchResultFc3dDrawing];
    NSString *drawTime=[dic objectForKey:@KWatchResultFc3dDrawTime];
    if (array.count<3) {
        [self.drawGroup setHidden:YES];
        return ;
    }
    [self.drawGroup setHidden:NO];
    [self.drawLabel1 setText:[array objectAtIndex:0]];
    [self.drawLabel2 setText:[array objectAtIndex:1]];
    [self.drawLabel3 setText:[array objectAtIndex:2]];
    [self.issueLabel setText:issue];
    [self.drawTimeLabel setText:drawTime];
}
- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    NSDictionary *dic=[self.wormhole messageWithIdentifier:@KWatchResultFc3d];
    [self updataAllData:dic];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



