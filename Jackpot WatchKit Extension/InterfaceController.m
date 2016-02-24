//
//  InterfaceController.m
//  Jackpot WatchKit Extension
//
//  Created by sxf on 15/7/21.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "InterfaceController.h"

#import "DPWatchShareDataDefine.h"

#import <MMWormhole/MMWormhole.h>
#import "GameLivingARowController.h"
@interface InterfaceController()

@property (nonatomic, strong) MMWormhole *wormhole;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@KWatchGroupIdentifier
                                                         optionalDirectory:@KWatchOptionalDirectory];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [self.wormhole passMessageObject:[NSNumber numberWithBool:YES] identifier:@KWatchResultJczqIsRequest];
    [self.wormhole passMessageObject:[NSNumber numberWithBool:YES] identifier:@KWatchResultJclqIsRequest];
    
    
}
//- (IBAction)modelToDrawing {
//    [self presentControllerWithNames:[NSArray arrayWithObjects:@"DltResultController",@"JczqResultController",@"JclqResultController",@"SsqResultInfoController",@"SfcResultController",@"Fc3dResultController",@"Pl3ResultController",@"Pl5ResultController",@"QxcReslutController",@"QlcResultController", nil] contexts:nil];
//
//}
- (IBAction)pushToGameLingJczq {
    [self pushControllerWithName:@"JczqGameInterfaceController" context:nil];
}
- (IBAction)pushToGameLingJclq {
    [self pushControllerWithName:@"JclqGameInterfaceController" context:nil];
}
- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



