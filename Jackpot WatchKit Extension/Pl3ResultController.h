//
//  Pl3ResultController.h
//  Jackpot
//
//  Created by sxf on 15/7/23.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface Pl3ResultController : WKInterfaceController


@property(nonatomic,weak)IBOutlet WKInterfaceLabel *issueLabel;
@property(nonatomic,weak)IBOutlet WKInterfaceLabel *drawLabel1;
@property(nonatomic,weak)IBOutlet WKInterfaceLabel *drawLabel2;
@property(nonatomic,weak)IBOutlet WKInterfaceLabel *drawLabel3;
@property(nonatomic,weak)IBOutlet WKInterfaceLabel *drawTimeLabel;

@property(nonatomic,weak)IBOutlet WKInterfaceGroup *drawGroup;
@end
