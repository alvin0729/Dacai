//
//  KTMCopyableLabel.m
//  Kathmandu
//
//  Created by WUFAN on 15/12/25.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "KTMCopyableLabel.h"

@implementation KTMCopyableLabel

// default is NO
- (BOOL)canBecomeFirstResponder {
    return YES;
}

// "反馈"关心的功能
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copy:));
}

// 针对于copy的实现
- (void)copy:(id)sender {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = self.text;
}

// 绑定事件
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)]];
    }
    return self;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer {
    [self becomeFirstResponder];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:self.frame inView:self.superview];
    [menu setMenuVisible:YES animated:YES];
}

@end
