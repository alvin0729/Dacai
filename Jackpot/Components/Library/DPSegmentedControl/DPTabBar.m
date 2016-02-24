//
//  DPTabBar.m
//  Jackpot
//
//  Created by wufan on 15/9/1.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPTabBar.h"

const static CGFloat kIndicatorLineHeight = 3.0f;

@interface DPTabBarItemView : UIView
@property (nonatomic, strong) DPTabBarItem *item;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation DPTabBarItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)dealloc {
    [_item removeObserver:self forKeyPath:@"title"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.frame = self.bounds;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.item && [keyPath isEqualToString:@"title"]) {
        self.titleLabel.text = self.item.title;
    }
}

#pragma mark - Property (getter, setter)

- (void)setItem:(DPTabBarItem *)item {
    if (_item == item) {
        return;
    }
    [_item removeObserver:self forKeyPath:@"title"];
    _item = item;
    [_item addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    
    _titleLabel.text = item.title;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end

@interface DPTabBarItem ()
@end

@implementation DPTabBarItem
@end

@interface DPTabBar ()
@property (nonatomic, strong) NSArray *itemViews;
@property (nonatomic, strong) CALayer *indicatorLayer;

@property (nonatomic, strong) CALayer *topBorderLayer;
@property (nonatomic, strong) CALayer *bottomBorderLayer;
@end

@implementation DPTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupProperty];
        [self.layer addSublayer:self.topBorderLayer];
        [self.layer addSublayer:self.bottomBorderLayer];
        [self.layer addSublayer:self.indicatorLayer];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTapped:)]];
    }
    return self;
}

- (void)setupProperty {
    _textColor = [UIColor colorWithRed:0.49 green:0.42 blue:0.35 alpha:1];
    _selectedColor = [UIColor dp_flatRedColor] ; 
    
    _indicatorLayer = [CALayer layer];
    _indicatorLayer.backgroundColor = _selectedColor.CGColor;
    
    _topBorderLayer = [CALayer layer];
    _topBorderLayer.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1].CGColor;
    
    _bottomBorderLayer = [CALayer layer];
    _bottomBorderLayer.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1].CGColor;
}

#pragma mark - User 

- (void)viewDidTapped:(UITapGestureRecognizer *)tapGesture {
    CGPoint locationInView = [tapGesture locationInView:self];
    [self.itemViews enumerateObjectsUsingBlock:^(DPTabBarItemView *itemView, NSUInteger idx, BOOL *stop) {
        if (CGRectContainsPoint(itemView.frame, locationInView)) {
            if (_selectedIndex != idx) {
                [self changedSelectedIndex:idx];
                if ([self.delegate respondsToSelector:@selector(tabBar:didSelectItem:)]) {
                    [self.delegate tabBar:self didSelectItem:itemView.item];
                }
            }
            *stop = YES;
        }
    }];
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat itemHeight = CGRectGetHeight(self.bounds);
    CGFloat itemWidth = floorf(CGRectGetWidth(self.bounds) / self.items.count);
    NSInteger upcount = CGRectGetWidth(self.bounds) - itemWidth * self.items.count;

    [self.itemViews enumerateObjectsUsingBlock:^(DPTabBarItemView *itemView, NSUInteger idx, BOOL *stop) {
        itemView.frame = CGRectMake(itemWidth * idx + (idx >= upcount ? upcount : idx), 0, itemWidth + (idx >= upcount ? 0 : 1), itemHeight);

        if (idx == self.selectedIndex) {
            [CATransaction setDisableActions:YES];
            self.indicatorLayer.frame = CGRectMake(CGRectGetMinX(itemView.frame),
                                                   CGRectGetMaxY(itemView.frame) - kIndicatorLineHeight,
                                                   CGRectGetWidth(itemView.frame),
                                                   kIndicatorLineHeight);
        }
    }];
    
    self.topBorderLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 0.5);
    self.bottomBorderLayer.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - 0.5, CGRectGetWidth(self.bounds), 0.5);
}

#pragma mark - Property (getter, setter)

- (void)setItems:(NSArray *)items {
    NSAssert(items.count, @"failure...");
    
    if ([_items isEqualToArray:items]) {
        return;
    }
    for (UIView *view in _itemViews) {
        [view removeFromSuperview];
    }
    
    NSMutableArray *itemViews = [NSMutableArray arrayWithCapacity:items.count];
    for (int i = 0; i < items.count; i++) {
        DPTabBarItemView *itemView = [[DPTabBarItemView alloc] init];
        itemView.item = items[i];
        itemView.titleLabel.textColor = self.textColor;
        itemView.titleLabel.highlightedTextColor = self.selectedColor;
        [self addSubview:itemView];
        [itemViews addObject:itemView];
    }
    
    _items = items.copy;
    _itemViews = itemViews;
    
    // 设置选中的位置
    _selectedIndex = 0;
    _indicatorLayer.frame = CGRectMake(0,
                                       CGRectGetHeight(self.bounds) - kIndicatorLineHeight,
                                       CGRectGetWidth(self.bounds) / items.count,
                                       kIndicatorLineHeight);
    
    [self setNeedsLayout];
}

- (void)setTextColor:(UIColor *)textColor {
    if (_textColor == textColor) {
        return;
    }
    
    _textColor = textColor;
    
    for (DPTabBarItemView *itemView in self.itemViews) {
        itemView.titleLabel.textColor = textColor;
    }
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    if (_selectedColor == selectedColor) {
        return;
    }
    
    _selectedColor = selectedColor;
    
    for (DPTabBarItemView *itemView in self.itemViews) {
        itemView.titleLabel.highlightedTextColor = selectedColor;
    }
    
    _indicatorLayer.backgroundColor = selectedColor.CGColor;
}

- (void)setSelectedItem:(DPTabBarItem *)selectedItem {
    NSInteger selectedIndex = [_items indexOfObject:selectedItem];
    if (selectedIndex == NSNotFound) {
        return;
    }
    if (_selectedIndex != selectedIndex) {
        [self changedSelectedIndex:selectedIndex];
    }
}

- (DPTabBarItem *)selectedItem {
    if (_items == nil) {
        return nil;
    }
    
    return _items[_selectedIndex];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex == selectedIndex) {
        return;
    }
    [self changedSelectedIndex:selectedIndex];
}

- (void)changedSelectedIndex:(NSInteger)selectedIndex {
    [self willChangeValueForKey:@"selectedIndex"];
    [self willChangeValueForKey:@"selectedItem"];
    _selectedIndex = selectedIndex;
    [self.itemViews enumerateObjectsUsingBlock:^(DPTabBarItemView *itemView, NSUInteger idx, BOOL *stop) {
        itemView.titleLabel.highlighted = idx == selectedIndex;
        if (idx == selectedIndex) {
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
            [CATransaction setValue:[NSNumber numberWithFloat:0.2f] forKey:kCATransactionAnimationDuration];
            _indicatorLayer.frame = CGRectMake(CGRectGetMinX(itemView.frame),
                                               CGRectGetMaxY(itemView.frame) - kIndicatorLineHeight,
                                               CGRectGetWidth(itemView.frame),
                                               kIndicatorLineHeight);
            [CATransaction commit];
        }
    }];
    [self didChangeValueForKey:@"selectedIndex"];
    [self didChangeValueForKey:@"selectedItem"];
}

@end
