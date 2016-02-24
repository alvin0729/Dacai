//
//  JclqResultController.h
//  Jackpot
//
//  Created by sxf on 15/7/23.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface JclqResultController : WKInterfaceController

@property(weak,nonatomic)IBOutlet WKInterfaceTable *interfaceTable;
@property(weak,nonatomic)IBOutlet WKInterfaceLabel *infoLabel;
@property(weak,nonatomic)IBOutlet WKInterfaceGroup  *infoGroup;
@property(weak ,nonatomic)IBOutlet WKInterfaceLabel *noDataLabel;
@end
