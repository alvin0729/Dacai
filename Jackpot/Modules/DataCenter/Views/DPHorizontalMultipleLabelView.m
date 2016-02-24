//
//  DPHorizontalMultipleLabelView.m
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPHorizontalMultipleLabelView.h"

@interface DPHorizontalMultipleLabelView ()
@property (nonatomic, strong) NSArray *separatorLayers;
@property (nonatomic, strong) NSArray *contentLabels;

@property (nonatomic, strong) CALayer *leftBorderLayer;
@property (nonatomic, strong) CALayer *rightBorderLayer;
@property (nonatomic, strong) CALayer *topBorderLayer;
@property (nonatomic, strong) CALayer *bottomBorderLayer;
@end

@implementation DPHorizontalMultipleLabelView

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSAssert(self.labelCount == self.contentLabels.count, @"failure...");
    NSAssert(self.labelCount == 0 || self.labelCount == self.separatorLayers.count + 1, @"failure...");
    
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat offset = 0;
    for (int i = 0; i < self.labelCount; i++) {
        UILabel *label = self.contentLabels[i];
        CALayer *layer = (i != self.labelCount - 1) ? self.separatorLayers[i] : nil;
        CGFloat width = [self.widths[i] floatValue]*(kScreenWidth/320.0);
        
        label.frame = CGRectMake(offset, 0, width, height);
        layer.frame = CGRectMake(CGRectGetMaxX(label.frame), 0, 0.5, height);
        offset += width;
    }
    
    CGFloat width = CGRectGetWidth(self.bounds);
    self.leftBorderLayer.frame = CGRectMake(0, 0, self.borderWidth, height);
    self.rightBorderLayer.frame = CGRectMake(width - self.borderWidth, 0, self.borderWidth, CGRectGetHeight(self.bounds));
    self.topBorderLayer.frame = CGRectMake(0, 0, width, self.borderWidth);
    self.bottomBorderLayer.frame = CGRectMake(0, height - self.borderWidth, width, self.borderWidth);
}

#pragma mark - Property (getter, setter)

- (void)setLabelCount:(NSInteger)labelCount {
    if (_labelCount != labelCount) {
        _labelCount = labelCount;
        
        for (UILabel *label in _contentLabels) {
            [label removeFromSuperview];
        }
        for (CALayer *layer in _separatorLayers) {
            [layer removeFromSuperlayer];
        }
        
        NSMutableArray *labels = [NSMutableArray arrayWithCapacity:labelCount];
        NSMutableArray *layers = [NSMutableArray arrayWithCapacity:labelCount - 1];
        for (int i = 0; i < labelCount; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = _alignment;
            label.textColor = _textColor;
            label.font = _font;
            
            [labels addObject:label];
            [self addSubview:label];
        }
        for (int i = 0; i < labelCount - 1; i++) {
            CALayer *layer = [CALayer layer];
            layer.backgroundColor = _separatorColor.CGColor;
            layer.hidden = _showSeparator;
            
            [layers addObject:layer];
            [self.layer addSublayer:layer];
        }
        _contentLabels = labels;
        _separatorLayers = layers;
        
        [self setNeedsLayout];
    }
}

- (void)setShowSeparator:(BOOL)showSeparator {
    if (_showSeparator != showSeparator) {
        _showSeparator = showSeparator;
        
        for (CALayer *layer in _separatorLayers) {
            layer.hidden = showSeparator;
        }
    }
}

- (void)setWidths:(NSArray *)widths {
    if (![_widths isEqualToArray:widths]) {
        _widths = widths.copy;
        
        [self setNeedsLayout];
    }
}

- (void)setTexts:(NSArray *)texts {
    if (![_texts isEqualToArray:texts]) {
        _texts = [texts dp_mapObjectUsingBlock:^id(id obj, NSUInteger idx, BOOL *stop) {
            return [obj copy];
        }];
        
        NSAssert(texts.count == _contentLabels.count, @"failure...");
        
        for (int i = 0; i< texts.count && i < _contentLabels.count; i++) {
            id text = _texts[i];
            UILabel *label = self.contentLabels[i];
            if ([text isKindOfClass:[NSString class]]) {
                label.text = text;
            } else if ([text isKindOfClass:[NSAttributedString class]]) {
                label.attributedText = text;
            } else {
                NSAssert(NO, @"failure...");
            }
        }
    }
}

- (void)setAlignment:(NSTextAlignment)alignment {
    if (_alignment != alignment) {
        _alignment = alignment;
        
        for (UILabel *label in _contentLabels) {
            label.textAlignment = alignment;
        }
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (_textColor != textColor) {
        _textColor = textColor;
        
        for (UILabel *label in _contentLabels) {
            label.textColor = textColor;
        }
    }
}

-(void)changeTexColorWithIndex:(NSInteger)index color:(UIColor*)color {

    if(index<_contentLabels.count){
        UILabel *label = [_contentLabels objectAtIndex:index];
        label.textColor = color ;
    }
}


- (void)setSeparatorColor:(UIColor *)separatorColor {
    if (_separatorColor != separatorColor) {
        _separatorColor = separatorColor;
        
        for (CALayer *layer in _separatorLayers) {
            layer.backgroundColor = separatorColor.CGColor;
        }
    }
}

- (void)setFont:(UIFont *)font {
    if (_font != font) {
        _font = font;
        
        for (UILabel *label in _contentLabels) {
            label.font = font;
        }
    }
}

- (void)setBorderColor:(UIColor *)borderColor {
    if (_borderColor != borderColor) {
        _borderColor = borderColor;
        
        _leftBorderLayer.backgroundColor =
        _rightBorderLayer.backgroundColor =
        _topBorderLayer.backgroundColor =
        _bottomBorderLayer.backgroundColor = borderColor.CGColor;
    }
}

- (void)setDirection:(DPBorderDirection)direction {
    if (_direction != direction) {
        _direction = direction;
        
        _topBorderLayer.hidden = !(direction & DPBorderDirectionTop);
        _bottomBorderLayer.hidden = !(direction & DPBorderDirectionBottom);
        _leftBorderLayer.hidden = !(direction & DPBorderDirectionLeft);
        _rightBorderLayer.hidden = !(direction & DPBorderDirectionRight);
    }
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    if (_borderWidth != borderWidth) {
        _borderWidth = borderWidth;
        
        if (_leftBorderLayer == nil) {
            _leftBorderLayer = [CALayer layer];
            _rightBorderLayer = [CALayer layer];
            _topBorderLayer = [CALayer layer];
            _bottomBorderLayer = [CALayer layer];
            
            _leftBorderLayer.backgroundColor =
            _rightBorderLayer.backgroundColor =
            _topBorderLayer.backgroundColor =
            _bottomBorderLayer.backgroundColor = _borderColor.CGColor;
            
            _topBorderLayer.hidden = !(_direction & DPBorderDirectionTop);
            _bottomBorderLayer.hidden = !(_direction & DPBorderDirectionBottom);
            _leftBorderLayer.hidden = !(_direction & DPBorderDirectionLeft);
            _rightBorderLayer.hidden = !(_direction & DPBorderDirectionRight);
            
            [self.layer addSublayer:_leftBorderLayer];
            [self.layer addSublayer:_rightBorderLayer];
            [self.layer addSublayer:_topBorderLayer];
            [self.layer addSublayer:_bottomBorderLayer];
        }
        
        [self setNeedsLayout];
    }
}

@end
