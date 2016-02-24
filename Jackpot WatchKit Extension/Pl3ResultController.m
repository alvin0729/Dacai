//
//  Pl3ResultController.m
//  Jackpot
//
//  Created by sxf on 15/7/23.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "Pl3ResultController.h"

#import "DPWatchShareDataDefine.h"

#import <MMWormhole/MMWormhole.h>
@interface Pl3ResultController ()

@property (nonatomic, strong) MMWormhole *wormhole;
@end

@implementation Pl3ResultController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@KWatchGroupIdentifier
                                                         optionalDirectory:@KWatchOptionalDirectory];
    [self.wormhole listenForMessageWithIdentifier:@KWatchResultPl3 listener:^(id messageObject) {
       
        [self updataAllData:messageObject];
    }];

    // Configure interface objects here.
}
-(void)updataAllData:(NSDictionary *)dic{
    if (dic==nil) {
        [self.drawGroup setHidden:YES];
        return;
    }
    NSString *issue = [NSString stringWithFormat:@"%@期开奖号码",[dic valueForKey:@KWatchResultPl3Issue]];
    NSArray *array=[dic objectForKey:@KWatchResultPl3Drawing];
    NSString *drawTime=[dic objectForKey:@KWatchResultPl3DrawTime];
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
    NSDictionary *dic=[self.wormhole messageWithIdentifier:@KWatchResultPl3];
    [self updataAllData:dic];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



