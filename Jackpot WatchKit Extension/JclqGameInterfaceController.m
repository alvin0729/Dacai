//
//  JclqGameInterfaceController.m
//  Jackpot
//
//  Created by sxf on 15/7/29.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  这个类注释一般由 sxf提供（其他人则做好标示）

#import "JclqGameInterfaceController.h"
#import "DPWatchShareDataDefine.h"
#import <MMWormhole/MMWormhole.h>
#import "GameLivingARowController.h"
#import <MSWeakTimer/MSWeakTimer.h>
@interface JclqGameInterfaceController ()

@property (nonatomic, strong) MMWormhole *wormhole;
@property(nonatomic,assign)int timeSpace;//时间间隔
@property (nonatomic, strong) MSWeakTimer *timer;//倒计时
@end

@implementation JclqGameInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    //创建对象
    self.wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@KWatchGroupIdentifier
                                                         optionalDirectory:@KWatchOptionalDirectory];
    
    /**
     *  监听图片是否发生改变
     *
     *  @param index 当前第几行的数据（图片）发生改变。，，主队为正(从1开始)，客队为负(从-1开始)，
     *
     *  @return
     */
    [self.wormhole listenForMessageWithIdentifier:@KWatchJclqIconIndex listener:^(id messageObject) {
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
        NSArray *array=[self.wormhole messageWithIdentifier:@KWatchJClqGameLivingArray];
        if (index>=[array count]) {
            return;
        }
        NSDictionary *iconDic=[array objectAtIndex:index];
        GameLivingARowController *elementRow = [self.interfaceTable rowControllerAtIndex:index];
        if (isHome) {
            NSString *iconString=[iconDic objectForKey:@KWatchGameLiveHomeUrl];
            NSData *data=[NSData dataWithContentsOfFile:iconString];
            UIImage *image =[UIImage imageWithData:data];
            if (image) {
                image = [UIImage imageWithCGImage:image.CGImage scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
                [elementRow.rightImage setImage:image];
            }
           
        }else{
            NSString *iconString=[iconDic objectForKey:@KWatchGameLiveAwayUrl];
            NSData *data=[NSData dataWithContentsOfFile:iconString];
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                image = [UIImage imageWithCGImage:image.CGImage scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
                [elementRow.leftImage setImage:image];
            }
        }
    }];

    [self.wormhole listenForMessageWithIdentifier:@KWatchJClqGameLivingArray listener:^(id messageObject) {
        if ([(NSArray *)messageObject count]>0) {
            [self.interfaceTable setHidden:NO];
            [self.noDataLabel setHidden:YES];
            [self loadTableRows:messageObject];
        }else{
            [self.interfaceTable setHidden:YES];
            [self.noDataLabel setHidden:NO];
        }
    }];

    // Configure interface objects here.
}
#pragma NSTimer
//开始倒计时
- (void)startTimer {
    [self setTimer:[[MSWeakTimer alloc] initWithTimeInterval:KWatchJcTimer target:self selector:@selector(pvt_reloadTimer) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()]];
    [self.timer schedule];
    [self.timer fire];
}
//停止倒计时
- (void)pvt_stopTimer {
    [self.timer invalidate];
    [self setTimer:nil];
}
//倒计时请求方法
- (void)pvt_reloadTimer {
    [self updateRequest];
}
/**
 *  更新列表数据
 *
 *  @param array          列表中的数据源
 *
 */
-(void)loadTableRows:(NSArray *)array{
    
    [self.interfaceTable setNumberOfRows:[array count] withRowType:@"defaultLqLiving"];
    [array enumerateObjectsUsingBlock:^(NSDictionary *rowData, NSUInteger idx, BOOL *stop) {
        
        GameLivingARowController *elementRow = [self.interfaceTable rowControllerAtIndex:idx];
        [elementRow.rightLabel setText:rowData[@KWatchGameLivingHomeName]];
        [elementRow.leftLabel setText:rowData[@KWatchGameLivingAwayName]];
        NSData *homeData = [NSData dataWithContentsOfFile:rowData[@KWatchGameLiveHomeUrl]];
        NSData *awayData = [NSData dataWithContentsOfFile:rowData[@KWatchGameLiveAwayUrl]];
        UIImage *homeImage = [UIImage imageWithData:homeData];
        UIImage *awayImage = [UIImage imageWithData:awayData];
        if (homeImage) {
             homeImage = [UIImage imageWithCGImage:homeImage.CGImage scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
            [elementRow.rightImage setImage:homeImage];
            
        }else{
            [elementRow.rightImage setImageNamed:@"default.png"];
        }
        if (awayImage) {
            awayImage = [UIImage imageWithCGImage:awayImage.CGImage scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
            [elementRow.leftImage setImage:awayImage];
        }else{
            [elementRow.leftImage setImageNamed:@"default.png"];
        }
        [elementRow.scoreLabel setText:rowData[@KWatchGameLivingScore]];
        [elementRow.stateLabel setText:rowData[@KWatchGameLivingTime]];
        [elementRow.timeLabel setText:rowData[@KWatchGameLivingStartTime]];
    }];
}
-(void)updateRequest{
    [WKInterfaceController openParentApplication:@{@"action": @KWatchJclqLiving} reply:^(NSDictionary *replyInfo, NSError *error) {
        if (error|| !replyInfo) {
            return ;
        }
    }];
    
}
- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    
    [self pushControllerWithName:@"DPJclqGameInfoController" context:[NSNumber numberWithInteger:rowIndex]];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    NSArray *array= [self.wormhole messageWithIdentifier:@KWatchJClqGameLivingArray];
    if (array.count>0) {
        [self.noDataLabel setHidden:YES];
        [self.interfaceTable setHidden:NO];
        [self loadTableRows:array];
    }else{
        [self.interfaceTable setHidden:YES];
        [self.noDataLabel setHidden:NO];
    }
    [self startTimer];
  
}
- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
     [self pvt_reloadTimer];
}

@end



