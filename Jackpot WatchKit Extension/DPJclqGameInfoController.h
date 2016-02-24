//
//  DPJclqGameInfoController.h
//  Jackpot
//
//  Created by sxf on 15/7/30.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface DPJclqGameInfoController : WKInterfaceController

@property (weak, nonatomic) IBOutlet WKInterfaceImage *leftImage;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *rightImage;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *leftLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *rightLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *scoreLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *stateLabel;
@end
