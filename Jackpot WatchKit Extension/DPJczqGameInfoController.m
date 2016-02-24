//
//  DPJczqGameInfoController.m
//  Jackpot
//
//  Created by sxf on 15/7/30.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPJczqGameInfoController.h"
#import "DPWatchShareDataDefine.h"

#import <MMWormhole/MMWormhole.h>
#import "GameLivingARowController.h"
@interface DPJczqGameInfoController ()

@property (nonatomic, strong) MMWormhole *wormhole;
@property(nonatomic,assign)NSInteger rowIndex;
@end

@implementation DPJczqGameInfoController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    self.rowIndex=[context integerValue];
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@KWatchGroupIdentifier
                                                         optionalDirectory:@KWatchOptionalDirectory];
    
//    [self.wormhole listenForMessageWithIdentifier:@KWatchIconIndex listener:^(id messageObject) {
//        int iconIndex=[messageObject intValue];
//        if (iconIndex!=self.rowIndex) {
//            return ;
//        }
//        if (iconIndex==0) {
//            return ;
//        }
//        int  index=0;
//        BOOL isHome=YES;
//        if (iconIndex>0) {
//            index=iconIndex-1;
//        }else{
//            index=-iconIndex-1;
//            isHome=NO;
//        }
//        if (index<0) {
//            return;
//        }
//        NSDictionary *dic=[self.wormhole messageWithIdentifier:@KWatchIconCache];
//        NSArray *array=[self.wormhole messageWithIdentifier:@KWatchJCzqGameLivingArray];
//        NSDictionary *iconDic=[array objectAtIndex:index];
//        if (isHome) {
//            NSString *iconString=[iconDic objectForKey:@KWatchGameLiveHomeUrl];
//            if( [[WKInterfaceDevice currentDevice] addCachedImage:[dic objectForKey:iconString] name:iconString])
//            {
//                [self.leftImage setImageNamed:iconString];
//            }else{
//                [self.leftImage setImage:[dic objectForKey:iconString]];
//            }
//        }else{
//            NSString *iconString=[iconDic objectForKey:@KWatchGameLiveAwayUrl];
//            if( [[WKInterfaceDevice currentDevice] addCachedImage:[dic objectForKey:iconString] name:iconString])
//            {
//                [self.rightImage setImageNamed:iconString];
//            }else{
//                [self.rightImage setImage:[dic objectForKey:iconString]];
//            }
//            
//            
//        }
//        
//        
//        
//    }];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    NSArray *array=[self.wormhole messageWithIdentifier:@KWatchJCzqGameLivingArray];
//    NSDictionary *dic=[[WKInterfaceDevice currentDevice] cachedImages];
    NSDictionary *rowData=[array objectAtIndex:self.rowIndex];
    [self.leftLabel setText:rowData[@KWatchGameLivingHomeName]];
    [self.rightLabel setText:rowData[@KWatchGameLivingAwayName]];
    
    NSData *homeData = [NSData dataWithContentsOfFile:rowData[@KWatchGameLiveHomeUrl]];
    NSData *awayData = [NSData dataWithContentsOfFile:rowData[@KWatchGameLiveAwayUrl]];
    UIImage *homeImage = [UIImage imageWithData:homeData];
    UIImage *awayImage = [UIImage imageWithData:awayData];
    if (homeImage) {
         homeImage = [UIImage imageWithCGImage:homeImage.CGImage scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
        [self.leftImage setImage:homeImage];
        
    }else{
        [self.leftImage setImageNamed:@"default.png"];
    }
    if (awayImage) {
        awayImage = [UIImage imageWithCGImage:awayImage.CGImage scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
        [self.rightImage setImage:awayImage];
    }else{
        [self.rightImage setImageNamed:@"default.png"];
    }
    
    if ([rowData[@KWatchGameLivingScore] isEqualToString:@"VS"]) {
       [self.scoreLabel setText:@"未开始"];
    }else{
    [self.scoreLabel setText:rowData[@KWatchGameLivingScore]];
    }
    [self.stateLabel setText:rowData[@KWatchGameLivingTime]];

}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



