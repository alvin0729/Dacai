//
//  DZNEmptyDataStyle.m
//  Jackpot
//
//  Created by WUFAN on 15/7/26.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DZNEmptyDataStyle.h"

@interface DZNEmptyDataStyle () <NSCopying>
@end

@implementation DZNEmptyDataStyle

#pragma mark - NSCopying
- (instancetype)copyWithZone:(NSZone *)zone {
    DZNEmptyDataStyle *style = [[DZNEmptyDataStyle allocWithZone:zone] init];
    style.titleText = self.titleText.copy;
    style.titleForEmptyDataSetBlock = self.titleForEmptyDataSetBlock;
    style.descriptionText = self.descriptionText.copy;
    style.descriptionForEmptyDataSetBlock = self.descriptionForEmptyDataSetBlock;
    style.image = self.image;
    style.imageForEmptyDataSetBlock = self.imageForEmptyDataSetBlock;
    style.imageTintColor = self.imageTintColor;
    style.imageTintColorForEmptyDataSetBlock = self.imageTintColorForEmptyDataSetBlock;
    style.buttonTitle = self.buttonTitle.copy;
    style.buttonTitleForEmptyDataSetBlock = self.buttonTitleForEmptyDataSetBlock;
    style.buttonImage = self.buttonImage;
    style.buttonImageForEmptyDataSetBlock = self.buttonImageForEmptyDataSetBlock;
    style.buttonBackgroundImage = self.buttonBackgroundImage;
    style.buttonBackgroundImageForEmptyDataSetBlock = self.buttonBackgroundImageForEmptyDataSetBlock;
    style.backgroundColor = self.backgroundColor;
    style.backgroundColorForEmptyDataSetBlock = self.backgroundColorForEmptyDataSetBlock;
    style.customView = self.customView;
    style.customViewForEmptyDataSetBlock = self.customViewForEmptyDataSetBlock;
    style.verticalOffset = self.verticalOffset;
    style.verticalOffsetForEmptyDataSetBlock = self.verticalOffsetForEmptyDataSetBlock;
    style.spaceHeight = self.spaceHeight;
    style.spaceHeightForEmptyDataSetBlock = self.spaceHeightForEmptyDataSetBlock;
    style.shouldDisplay = self.shouldDisplay;
    style.shouldDisplayBlock = self.shouldDisplayBlock;
    style.allowTouch = self.allowTouch;
    style.allowTouchBlock = self.allowTouchBlock;
    style.allowScroll = self.allowScroll;
    style.allowScrollBlock = self.allowScrollBlock;
    style.didTapViewBlock = self.didTapViewBlock;
    style.didTapButtonBlock = self.didTapButtonBlock;
    style.willAppearBlock = self.willAppearBlock;
    style.didAppearBlock = self.didAppearBlock;
    style.willDisappearBlock = self.willDisappearBlock;
    style.didDisappearBlock = self.didDisappearBlock;
    return style;
}

#pragma mark - Life Cycle
+ (instancetype)style {
    return [[DZNEmptyDataStyle alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        _allowTouch = NO;
        _allowScroll = YES;
        _shouldDisplay = NO;
    }
    return self;
}

#pragma mark - Override
- (BOOL)respondsToSelector:(SEL)aSelector {
    // DZNEmptyDataSetSource
    if (aSelector == @selector(titleForEmptyDataSet:)) {
        return self.titleText || self.titleForEmptyDataSetBlock;
    }
    if (aSelector == @selector(descriptionForEmptyDataSet:)) {
        return self.descriptionText || self.descriptionForEmptyDataSetBlock;
    }
    if (aSelector == @selector(imageForEmptyDataSet:)) {
        return self.image || self.imageForEmptyDataSetBlock;
    }
    if (aSelector == @selector(imageTintColorForEmptyDataSet:)) {
        return self.imageTintColor || self.imageTintColorForEmptyDataSetBlock;
    }
    if (aSelector == @selector(buttonTitleForEmptyDataSet:forState:)) {
        return self.buttonTitle || self.buttonTitleForEmptyDataSetBlock;
    }
    if (aSelector == @selector(buttonImageForEmptyDataSet:forState:)) {
        return self.buttonImage || self.buttonImageForEmptyDataSetBlock;
    }
    if (aSelector == @selector(buttonBackgroundImageForEmptyDataSet:forState:)) {
        return self.buttonBackgroundImage || self.buttonBackgroundImageForEmptyDataSetBlock;
    }
    if (aSelector == @selector(backgroundColorForEmptyDataSet:)) {
        return self.backgroundColor || self.backgroundColorForEmptyDataSetBlock;
    }
    if (aSelector == @selector(customViewForEmptyDataSet:)) {
        return self.customView || self.customViewForEmptyDataSetBlock;
    }
    if (aSelector == @selector(verticalOffsetForEmptyDataSet:)) {
        return YES;
    }
    if (aSelector == @selector(spaceHeightForEmptyDataSet:)) {
        return YES;
    }
    // DZNEmptyDataSetDelegate
    if (aSelector == @selector(emptyDataSetShouldDisplay:)) {
        return YES;
    }
    if (aSelector == @selector(emptyDataSetShouldAllowTouch:)) {
        return YES;
    }
    if (aSelector == @selector(emptyDataSetShouldAllowScroll:)) {
        return YES;
    }
    if (aSelector == @selector(emptyDataSetDidTapView:)) {
        return self.didTapViewBlock != nil;
    }
    if (aSelector == @selector(emptyDataSetDidTapButton:)) {
        return self.didTapButtonBlock != nil;
    }
    if (aSelector == @selector(emptyDataSetWillAppear:)) {
        return self.willAppearBlock != nil;
    }
    if (aSelector == @selector(emptyDataSetDidAppear:)) {
        return self.didAppearBlock != nil;
    }
    if (aSelector == @selector(emptyDataSetWillDisappear:)) {
        return self.willDisappearBlock != nil;
    }
    if (aSelector == @selector(emptyDataSetDidDisappear:)) {
        return self.didDisappearBlock != nil;
    }
    return [NSObject instancesRespondToSelector:aSelector];
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.titleForEmptyDataSetBlock) {
        return self.titleForEmptyDataSetBlock(scrollView);
    }
    return self.titleText;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.descriptionForEmptyDataSetBlock) {
        return self.descriptionForEmptyDataSetBlock(scrollView);
    }
    return self.descriptionText;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.imageForEmptyDataSetBlock) {
        return self.imageForEmptyDataSetBlock(scrollView);
    }
    return self.image;
}

- (UIColor *)imageTintColorForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.imageTintColorForEmptyDataSetBlock) {
        return self.imageTintColorForEmptyDataSetBlock(scrollView);
    }
    return self.imageTintColor;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if (self.buttonTitleForEmptyDataSetBlock) {
        return self.buttonTitleForEmptyDataSetBlock(scrollView, state);
    }
    return self.buttonTitle;
}

- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if (self.buttonImageForEmptyDataSetBlock) {
        return self.buttonImageForEmptyDataSetBlock(scrollView, state);
    }
    return self.buttonImage;
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if (self.buttonBackgroundImageForEmptyDataSetBlock) {
        return self.buttonBackgroundImageForEmptyDataSetBlock(scrollView, state);
    }
    return self.buttonBackgroundImage;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.backgroundColorForEmptyDataSetBlock) {
        return self.backgroundColorForEmptyDataSetBlock(scrollView);
    }
    return self.backgroundColor;
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.customViewForEmptyDataSetBlock) {
        return self.customViewForEmptyDataSetBlock(scrollView);
    }
    return self.customView;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.verticalOffsetForEmptyDataSetBlock) {
        return self.verticalOffsetForEmptyDataSetBlock(scrollView);
    }
    return self.verticalOffset;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.spaceHeightForEmptyDataSetBlock) {
        return self.spaceHeightForEmptyDataSetBlock(scrollView);
    }
    return self.spaceHeight;
}

#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    // 判断 table view 是否存在 section header, 只要存在就认为有数据
    if ([scrollView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)scrollView;
        BOOL respondsToHeightSelector = [tableView.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)];
        BOOL respondsToViewForHeaderInSection = [tableView.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)];
        NSInteger section = [tableView.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)] ? [tableView.dataSource numberOfSectionsInTableView:tableView] : 1;
        for (int i = 0; i < section; i++) {
            CGFloat height = 0;
            if (respondsToHeightSelector) {
                height = [tableView.delegate tableView:tableView heightForHeaderInSection:section];
            } else {
                height = tableView.sectionHeaderHeight;
            }
            
            if (height > 0 && (respondsToViewForHeaderInSection && [tableView.delegate tableView:tableView viewForHeaderInSection:i])) {
                return NO;
            }
        }
    }
    if (self.shouldDisplayBlock) {
        return self.shouldDisplayBlock(scrollView);
    }
    return self.shouldDisplay;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    if (self.allowTouchBlock) {
        return self.allowTouchBlock(scrollView);
    }
    return self.allowTouch;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    if (self.allowScrollBlock) {
        return self.allowScrollBlock(scrollView);
    }
    return self.allowScroll;
}

- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView {
    if (self.didTapViewBlock) {
        self.didTapViewBlock(scrollView);
    }
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView {
    if (self.didTapButtonBlock) {
        self.didTapButtonBlock(scrollView);
    }
}

- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    if (self.willAppearBlock) {
        self.willAppearBlock(scrollView);
    }
}

- (void)emptyDataSetDidAppear:(UIScrollView *)scrollView {
    if (self.didAppearBlock) {
        self.didAppearBlock(scrollView);
    }
}

- (void)emptyDataSetWillDisappear:(UIScrollView *)scrollView {
    if (self.willDisappearBlock) {
        self.willDisappearBlock(scrollView);
    }
}

- (void)emptyDataSetDidDisappear:(UIScrollView *)scrollView {
    if (self.didDisappearBlock) {
        self.didDisappearBlock(scrollView);
    }
}

@end