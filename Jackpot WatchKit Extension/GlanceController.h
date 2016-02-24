//
//  GlanceController.h
//  Jackpot WatchKit Extension
//
//  Created by sxf on 15/7/21.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface GlanceController : WKInterfaceController

@property(nonatomic,weak)IBOutlet WKInterfaceLabel *issueLabel;
@property(nonatomic,weak)IBOutlet WKInterfaceLabel *infoLabel;
@property(nonatomic,weak)IBOutlet WKInterfaceLabel *noDataLabel;
@end
