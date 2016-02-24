//
//  JclqGameInterfaceController.h
//  Jackpot
//
//  Created by sxf on 15/7/29.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface JclqGameInterfaceController : WKInterfaceController

@property(weak ,nonatomic)IBOutlet WKInterfaceTable *interfaceTable;
@property(weak ,nonatomic)IBOutlet WKInterfaceLabel *noDataLabel;

@end
