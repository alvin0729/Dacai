//
//  DPTimerCenter.m
//  Jackpot
//
//  Created by Ray on 15/8/13.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPTimerCenter.h"

@interface DPTimerCenter()
@property (nonatomic, strong) MSWeakTimer *timer;


@end

@implementation DPTimerCenter

+(instancetype)defaultCenter {

    static DPTimerCenter *defaluter ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaluter = [[DPTimerCenter alloc]init];
    });
    
    return defaluter ;
}

-(void)startWithControllerName:(NSString*)controllerName {
    
    if (self.timer && ![[self.timer userInfo] isEqualToString:controllerName]) {
        [self.timer invalidate];
        self.timer = nil ;
    }
    
    if ((!self.timer)) {
        self.timer = [self setupWithControllerName:controllerName] ;
    }
    

}
-(void)stopWithControllerName:(NSString*)controllerName {

    if (self.timer && [[self.timer userInfo]isEqualToString:controllerName]) {
        [self.timer invalidate];
        self.timer  = nil ;
    }

}

-(MSWeakTimer*)setupWithControllerName:(NSString *)controlName{
    
    MSWeakTimer *timer = [MSWeakTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(onTimer) userInfo:controlName repeats:YES dispatchQueue:dispatch_get_main_queue()];
    
    return timer ;
     
}



#pragma mark - 定时器
- (void)onTimer {
        // 定时器通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kDPNumberTimerNotificationKey object:self];
    
}


-(void)dealloc{

    [self.timer invalidate];
    self.timer = nil ;
    
 }
@end
