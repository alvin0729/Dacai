//
//  UITextView+KTMAdditions.m
//  Kathmandu
//
//  Created by Ray on 15/4/22.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "UITextView+KTMAdditions.h"
#import <objc/runtime.h>
static char *kAction;
static char *klimit;
static char *targetKey;


@implementation UITextView (KTMAdditions)

/**
 *  限制字符提示
 *
 *  @param target   action的Target
 *  @param action   限制执行事件
 *  @param limitMax 限制数量
 */
-(void)addTarget:(id)target action:(SEL)action limitMax:(NSInteger)limitMax
{
    
    NSString *limitStr=[NSString stringWithFormat:@"%ld",(long)limitMax];
    objc_setAssociatedObject(self, &klimit, limitStr, OBJC_ASSOCIATION_COPY);
    objc_setAssociatedObject(self, &targetKey, target, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, &kAction, NSStringFromSelector(action), OBJC_ASSOCIATION_COPY);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIControlEventEditingChangedByLimit) name: UITextViewTextDidChangeNotification object:nil];
}


+(void)load
{
    Class class = [self class];
    
    SEL originalSelector = @selector(removeFromSuperview);
    SEL swizzledSelector = @selector(removeFromSuperviewExt);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}


-(void)removeFromSuperviewExt
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeFromSuperviewExt];
}


/**
 *  输入内容限制
 */
-(void)UIControlEventEditingChangedByLimit
{
    id target = objc_getAssociatedObject(self, &targetKey);
    if (!target&&![target isKindOfClass:[NSNull class]]) {
        return;
    }
    NSString *actionStr = objc_getAssociatedObject(self, &kAction);
    SEL runAction  = NSSelectorFromString(actionStr);
    if (!runAction) {
        return;
    }
    
    NSString *limitStr = objc_getAssociatedObject(self, &klimit);
    NSInteger maxLength=[limitStr integerValue];
    
    NSString *toBeString = self.text;
    
    UITextInputMode *currentInputMode = self.textInputMode;
    NSString *lang = [currentInputMode primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > maxLength) {
                
                //找到当前输入光标位置, 删除超出内容
                UITextPosition* beginning = self.beginningOfDocument;
                UITextRange* selectedRange = self.selectedTextRange;
                UITextPosition* selectionStart = selectedRange.start;
                
                NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
                self.text = [self.text stringByReplacingCharactersInRange:NSMakeRange(location-(toBeString.length-maxLength), toBeString.length-maxLength) withString:@""];
                
                {
                    //[target performSelector:action];
                    if ([target respondsToSelector:runAction]) {
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"  //消除performSelector 可能不存在的警告
                        [target performSelector:runAction ];
                    }
                    
                }
            }
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
            else
            {
            }
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > maxLength)
        {
            //找到当前输入光标位置, 删除超出内容
            UITextPosition* beginning = self.beginningOfDocument;
            UITextRange* selectedRange = self.selectedTextRange;
            UITextPosition* selectionStart = selectedRange.start;
            
            NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
            self.text = [self.text stringByReplacingCharactersInRange:NSMakeRange(location-(toBeString.length-maxLength), toBeString.length-maxLength) withString:@""];
            
            if ([target respondsToSelector:runAction]) {
                [target performSelector:runAction ];
            }
            
        }
        
    }
}

@end
