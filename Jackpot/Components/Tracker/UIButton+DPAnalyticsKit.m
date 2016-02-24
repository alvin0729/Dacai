//
//  UIButton+Statistics.m
//  Jackpot
//
//  Created by wufan on 15/10/12.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "UIButton+DPAnalyticsKit.h"
#import "DPAnalyticsKit.h"
#import <objc/runtime.h>
#import <objc/message.h>



static const void *kStatisticsEventIdKey = &kStatisticsEventIdKey;

@implementation UIButton (DPAnalyticsKit)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        Class class = [self class];
//        
//        SEL originalSelector = @selector(addTarget:action:forControlEvents:);
//        SEL swizzledSelector = @selector(cimc_addTarget:action:forControlEvents:);
//        
//        Method originalMethod = class_getInstanceMethod(class, originalSelector);
//        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//        
//        // 交换方法
//        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (void)cimc_addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    Method method = class_getInstanceMethod([UIButton class], @selector(cimc_addTarget:action:forControlEvents:));
    ((void(*)(id, Method, id, SEL, UIControlEvents))method_invoke)(self, method, target, action, controlEvents);
//    IMP implementation = class_getMethodImplementation([UIButton class], @selector(cimc_addTarget:action:forControlEvents:));
    
//    [self cimc_addTarget:target action:action forControlEvents:controlEvents];
    
    Class class = [target class];
    NSString *oldSelString = NSStringFromSelector(action);
    if ([oldSelString rangeOfString:@"cimc_"].location != NSNotFound) {
        return;
    }
    
    SEL actionSel = action;
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"cimc_%@", oldSelString]);
    
    Method dis_originalMethod = class_getInstanceMethod(class, actionSel);
    if (class_addMethod(class, selector, (IMP)cimc_buttonAction, method_getTypeEncoding(dis_originalMethod))) {
        Method dis_swizzledMethod = class_getInstanceMethod(class, selector);
        
        method_exchangeImplementations(dis_originalMethod, dis_swizzledMethod);
    }
}

void cimc_buttonAction(id self, SEL _cmd, ...) {
    NSString *oldSelString = NSStringFromSelector(_cmd);
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"cimc_%@", oldSelString]);
    
    Method method = class_getInstanceMethod([self class], _cmd);
    unsigned int argumentCount =  method_getNumberOfArguments(method);
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
    
    [invocation setTarget:self];
    [invocation setSelector:selector];
    
    id eachObject;
    int index = 2;
    va_list argumentList;
    va_start(argumentList, _cmd);
    for (unsigned int i = 0; i < argumentCount - 2; i++) {
        eachObject = va_arg(argumentList, id);
        [invocation setArgument:&eachObject atIndex:index];
        index++;
    }
    va_end(argumentList);
    
    [invocation invoke];
}

#pragma mark - Property (setter, getter)

- (void)dp_setEventId:(NSInteger)dp_eventId {
    NSArray *actions = [self actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
    if ([actions containsObject:NSStringFromSelector(@selector(dp_statisticsEvent))]) {
        [self removeTarget:self action:@selector(dp_statisticsEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addTarget:self action:@selector(dp_statisticsEvent) forControlEvents:UIControlEventTouchUpInside];
    
    objc_setAssociatedObject(self, kStatisticsEventIdKey, @(dp_eventId), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)dp_eventId {
    return [objc_getAssociatedObject(self, kStatisticsEventIdKey) integerValue];
}

- (void)dp_statisticsEvent {
    if (self.dp_eventId != 0) {
        [DPAnalyticsKit logKeyValueEvent:[NSString stringWithFormat:@"%@", @(self.dp_eventId)] props:nil];
    }
}

@end

