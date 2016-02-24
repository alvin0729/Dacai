//
//  MTStringAttributes.m
//  MTStringAttributes
//
//  Created by Adam Kirk on 2/12/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MTStringAttributes.h"


@interface MTStringAttributes ()
@property (nonatomic, strong) NSMutableDictionary     *attributes;
@property (nonatomic, strong) NSMutableParagraphStyle *internalParagraphStyle;
@property (nonatomic, strong) NSShadow                *shadow;
@end


@implementation MTStringAttributes

@dynamic lineSpacing;
@dynamic paragraphSpacing;
@dynamic alignment;
@dynamic firstLineHeadIndent;
@dynamic headIndent;
@dynamic tailIndent;
@dynamic lineBreakMode;
@dynamic minimumLineHeight;
@dynamic maximumLineHeight;
@dynamic tabStop;
@dynamic removeTabStop;
@dynamic tabStops;
@dynamic writingDirection;
@dynamic lineHeightMultiple;
@dynamic paragraphSpacingBefore;
@dynamic defaultTabInterval;
@dynamic textBlocks;
@dynamic textLists;
@dynamic hyphenationFactor;
@dynamic tighteningFactorForTruncation;
@dynamic headerLevel;
@dynamic shadowBlurRadius;
@dynamic shadowColor;
@dynamic shadowOffset;

- (id)init
{
    self = [super init];
    if (self) {
        _attributes = [NSMutableDictionary new];
    }
    return self;
}

- (void)setAttributesValue:(id)value forKey:(NSString *)key
{
    if (value == nil) {
        if ([_attributes objectForKey:key]) {
            [_attributes removeObjectForKey:key];
        }
    } else {
        _attributes[key] = value;
    }
}

#pragma mark - Basics

- (void)setFont:(id)font
{
    _font = font;
    [self setAttributesValue:font forKey:NSFontAttributeName];
}

- (void)setTextColor:(id)textColor
{
    _textColor = textColor;
    [self setAttributesValue:textColor forKey:NSForegroundColorAttributeName];
}

- (void)setBackgroundColor:(id)backgroundColor
{
    _backgroundColor = backgroundColor;
    [self setAttributesValue:backgroundColor forKey:NSBackgroundColorAttributeName];
}





#pragma mark - More

- (void)setLigatures:(BOOL)ligatures
{
    _ligatures = ligatures;
}

- (void)setKern:(CGFloat)kern
{
    _kern = kern;
    [self setAttributesValue:@(kern) forKey:NSKernAttributeName];
}

- (void)setStrikethrough:(BOOL)strikethrough
{
    _strikethrough = strikethrough;
    [self setAttributesValue:@(strikethrough) forKey:NSStrikethroughStyleAttributeName];
}

- (void)setStrikethroughColor:(id)strikethroughColor
{
    _strikethroughColor = strikethroughColor;
    [self setAttributesValue:strikethroughColor forKey:NSStrikethroughColorAttributeName];
}

- (void)setUnderline:(BOOL)underline
{
    _underline = underline;
    [self setAttributesValue:@(_underline) forKey:NSUnderlineStyleAttributeName];
}

- (void)setUnderlineColor:(id)underlineColor
{
    _underlineColor = underlineColor;
    [self setAttributesValue:underlineColor forKey:NSUnderlineColorAttributeName];
}

- (void)setStrokeColor:(id)strokeColor
{
    _strokeColor = strokeColor;
    [self setAttributesValue:strokeColor forKey:NSStrokeColorAttributeName];
}

- (void)setStrokeWidth:(CGFloat)strokeWidth
{
    _strokeWidth = strokeWidth;
    [self setAttributesValue:@(strokeWidth) forKey:NSStrokeWidthAttributeName];
}

- (void)setTextAttachment:(NSTextAttachment *)textAttachment
{
    _textAttachment = textAttachment;
    [self setAttributesValue:textAttachment forKey:NSAttachmentAttributeName];
}

- (void)setLink:(NSURL *)link
{
    _link = link;
    [self setAttributesValue:link forKey:NSLinkAttributeName];
}

- (void)setBaselineOffset:(CGFloat)baselineOffset
{
    _baselineOffset = baselineOffset;
    [self setAttributesValue:@(baselineOffset) forKey:NSBaselineOffsetAttributeName];
}

- (void)setObliqueness:(CGFloat)obliqueness
{
    _obliqueness = obliqueness;
    [self setAttributesValue:@(obliqueness) forKey:NSObliquenessAttributeName];
}

- (void)setExpansion:(CGFloat)expansion
{
    _expansion = expansion;
    [self setAttributesValue:@(expansion) forKey:NSExpansionAttributeName];
}

- (void)setVerticalGlyphForm:(BOOL)verticalGlyphForm
{
    _verticalGlyphForm = verticalGlyphForm;
    [self setAttributesValue:@(verticalGlyphForm) forKey:NSVerticalGlyphFormAttributeName];
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self.internalParagraphStyle respondsToSelector:aSelector]) {
        return self.internalParagraphStyle;
    }
    else if ([self.shadow respondsToSelector:aSelector]) {
        return self.shadow;
    }
    return [super forwardingTargetForSelector:aSelector];
}

#pragma mark - outline stroke

- (void)setOutlineColor:(id)outlineColorNew
{
    _outlineColor = outlineColorNew;
    [self setAttributesValue:outlineColorNew forKey:NSStrokeColorAttributeName];
}


- (void)setOutlineWidth:(CGFloat)outlineWidthNew
{
    _outlineWidth = outlineWidthNew;
    [self setAttributesValue:@(outlineWidthNew) forKey:NSStrokeWidthAttributeName];
}



#pragma mark - Paragraph Style

- (void)setParagraphStyle:(NSParagraphStyle *)paragraphStyle
{
    self.internalParagraphStyle = [paragraphStyle mutableCopy];
}

- (NSParagraphStyle *)paragraphStyle
{
    return [self.internalParagraphStyle copy];
}



#pragma mark - Dictionary

- (NSDictionary *)dictionary
{
    if (_internalParagraphStyle) {
        self.attributes[NSParagraphStyleAttributeName] = self.internalParagraphStyle;
    }
    if (_shadow) {
        self.attributes[NSShadowAttributeName] = self.shadow;
    }
    return [self.attributes copy];
}




#pragma mark - Private

- (NSMutableParagraphStyle *)internalParagraphStyle
{
    if (!_internalParagraphStyle) {
        _internalParagraphStyle = [NSMutableParagraphStyle new];
    }
    return _internalParagraphStyle;
}

- (NSShadow *)shadow
{
    if (!_shadow) {
        _shadow = [NSShadow new];
    }
    return _shadow;
}

@end
