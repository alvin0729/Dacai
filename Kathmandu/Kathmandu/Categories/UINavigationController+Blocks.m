//
//  UINavigationController+Blocks.m
//  Kathmandu
//
//  Created by WUFAN on 14-9-26.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "UINavigationController+Blocks.h"
#import <objc/runtime.h>

static const void *POPCompletionBlockKey = &POPCompletionBlockKey;

@interface UINavigationController () <UINavigationControllerDelegate>
@property (nonatomic, copy) void(^popCompletionBlock)() ;
@end

@implementation UINavigationController (Blocks)

- (UIViewController *)dp_popViewControllerAnimated:(BOOL)animated completion:(void (^)())completion {
    self.delegate = self;
    self.popCompletionBlock = completion;
    return [self popViewControllerAnimated:animated];
}

- (NSArray *)dp_popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)())completion {
    self.delegate = self;
    self.popCompletionBlock = completion;
    return [self popToRootViewControllerAnimated:animated];
}

- (NSArray *)dp_popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)())completion {
    self.delegate = self;
    self.popCompletionBlock = completion;
    return [self popToViewController:viewController animated:animated];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.popCompletionBlock) {
        self.delegate = nil;
        self.popCompletionBlock();
        self.popCompletionBlock = nil;
    }
}

#pragma mark - getter, setter

- (void (^)())popCompletionBlock {
    return objc_getAssociatedObject(self, POPCompletionBlockKey);
}

- (void)setPopCompletionBlock:(void (^)())popCompletionBlock {
    objc_setAssociatedObject(self, POPCompletionBlockKey, popCompletionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
