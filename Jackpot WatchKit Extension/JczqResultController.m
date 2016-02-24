//
//  JczqResultController.m
//  Jackpot
//
//  Created by sxf on 15/7/23.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "JczqResultController.h"
#import "DPWatchShareDataDefine.h"

#import <MMWormhole/MMWormhole.h>
#import "JcTableRowController.h"
@interface JczqResultController ()

@property (nonatomic, strong) MMWormhole *wormhole;
@end

@implementation JczqResultController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@KWatchGroupIdentifier
                                                         optionalDirectory:@KWatchOptionalDirectory];
    
    [self.wormhole listenForMessageWithIdentifier:@KWatchZqRequestIconIndex listener:^(id messageObject) {
        int iconIndex=[messageObject intValue];
        if (iconIndex==0) {
            return ;
        }
        int  index=0;
        BOOL isHome=YES;
        if (iconIndex>0) {
            index=iconIndex-1;
        }else{
            index=-iconIndex-1;
            isHome=NO;
        }
        if (index<0) {
            return;
        }
        NSDictionary *dic=[self.wormhole messageWithIdentifier:@KWatchIconCache];
        NSArray *array=[self.wormhole messageWithIdentifier:@KWatchResultJczqArray];
        NSDictionary *iconDic=[array objectAtIndex:index];
        JcTableRowController *elementRow = [self.interfaceTable rowControllerAtIndex:index];
        if (isHome) {
            NSString *iconString=[iconDic objectForKey:@KWatchGameLiveHomeUrl];
            if( [[WKInterfaceDevice currentDevice] addCachedImage:[dic objectForKey:iconString] name:iconString])
            {
                [elementRow.leftImage setImageNamed:iconString];
            }else{
                [elementRow.leftImage setImage:[dic objectForKey:iconString]];
            }
        }else{
            NSString *iconString=[iconDic objectForKey:@KWatchGameLiveAwayUrl];
            if( [[WKInterfaceDevice currentDevice] addCachedImage:[dic objectForKey:iconString] name:iconString])
            {
                [elementRow.rightImage setImageNamed:iconString];
            }else{
                [elementRow.rightImage setImage:[dic objectForKey:iconString]];
            }
            
        }
        
        }];
    [self.wormhole listenForMessageWithIdentifier:@KWatchResultJczqArray listener:^(id messageObject) {
        if ([(NSArray *)messageObject count]>0) {
            [self.interfaceTable setHidden:NO];
            [self.noDataLabel setHidden:YES];
            [self loadTableRows:messageObject];
        }else{
            [self.interfaceTable setHidden:YES];
            [self.noDataLabel setHidden:NO];
        }
        
    }];

    [self.wormhole listenForMessageWithIdentifier:@KWatchResultJczqGameName listener:^(id messageObject) {
        if (messageObject) {
            [self.infoGroup setHidden:NO];
             [self.infoLabel setText:messageObject];
        }else{
        [self.infoGroup setHidden:YES];
        }
       
    }];
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    NSArray *array=[self.wormhole messageWithIdentifier:@KWatchResultJczqArray];
    if (array.count>0) {
        [self.noDataLabel setHidden:YES];
        [self.interfaceTable setHidden:NO];
        
        [self loadTableRows:array];
    }else{
        [self.interfaceTable setHidden:YES];
        [self.noDataLabel setHidden:NO];
    }
    NSString *timeString=[self.wormhole messageWithIdentifier:@KWatchResultJczqGameName];
    if (timeString) {
        [self.infoGroup setHidden:NO];
        [self.infoLabel setText:timeString];
    }else{
        [self.infoGroup setHidden:YES];
    }
    BOOL isRequest=[[self.wormhole messageWithIdentifier:@KWatchResultJczqIsRequest ] boolValue];
    if (isRequest) {
        [WKInterfaceController openParentApplication:@{@"action": @KWatchJczqResult} reply:^(NSDictionary *replyInfo, NSError *error) {
            if (error|| !replyInfo) {
                return ;
            } 
        }];
    }
   
    
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}


- (void)loadTableRows:(NSArray *)array {
    [self.interfaceTable setNumberOfRows:array.count withRowType:@"defaultJczq"];
    
    // Create all of the table rows.
    NSDictionary *dic=[[WKInterfaceDevice currentDevice] cachedImages];
    [array enumerateObjectsUsingBlock:^(NSDictionary *rowData, NSUInteger idx, BOOL *stop) {
        JcTableRowController *elementRow = [self.interfaceTable rowControllerAtIndex:idx];
        
        [elementRow.leftLabel setText:rowData[@KWatchResultJcHomeName]];
        [elementRow.rightLabel setText:rowData[@KWatchResultJcAwayName]];
        [elementRow.scoreLabel setText:rowData[@KWatchResultJcScore]];
        if ([dic objectForKey:rowData[@KWatchGameLiveHomeUrl]]) {
            [elementRow.leftImage setImageNamed:rowData[@KWatchGameLiveHomeUrl]];
        }else{
            [elementRow.leftImage setImageNamed:@"default.png"];
        }
        if ([dic objectForKey:rowData[@KWatchGameLiveAwayUrl]]) {
            [elementRow.rightImage setImageNamed:rowData[@KWatchGameLiveAwayUrl]];
        }else{
            [elementRow.rightImage setImageNamed:@"default.png"];
        }

    }];
}
@end



