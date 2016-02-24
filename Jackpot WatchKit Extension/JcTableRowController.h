//
//  JcTableRowController.h
//  Jackpot
//
//  Created by sxf on 15/7/24.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>
@interface JcTableRowController : NSObject

@property (weak, nonatomic) IBOutlet WKInterfaceImage *leftImage;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *rightImage;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *leftLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *rightLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *scoreLabel;
@end
