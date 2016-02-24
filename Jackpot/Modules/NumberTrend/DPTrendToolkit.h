//
//  DPTrendToolkit.h
//  DacaiProject
//
//  Created by WUFAN on 15/2/4.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  绘制细节方法类

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
/**
 *  在指定上下文中绘制文字
 *
 *  @param ctx    [in]指定上下文
 *  @param rect   [in]绘制区域
 *  @param string [in]文字内容, utf-8编码
 *  @param length [in]文字长度
 */
static inline void TTKContextShowTextInRect(CGContextRef ctx, CGRect rect, const char *string, size_t length) {
    CGContextSetTextDrawingMode(ctx, kCGTextInvisible);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    CGContextShowTextAtPoint (ctx, rect.origin.x, rect.origin.y, string, length);
#pragma clang diagnostic pop
    
    //Then get the position of the text and set the mode back to visible:
    CGPoint pt = CGContextGetTextPosition(ctx);
    //Draw at new position
    CGContextSetTextDrawingMode(ctx, kCGTextFill);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    CGContextShowTextAtPoint(ctx, rect.origin.x + (rect.size.width - (pt.x - rect.origin.x)) / 2, rect.origin.y + 14, string, length);
#pragma clang diagnostic pop
}

/**
 *  在指定上下文中绘制文字
 *
 *  @param ctx     [in]指定上下文
 *  @param fontRef [in]指定的字体
 *  @param rect    [in]绘制区域
 *  @param string  [in]文字内容, unicode编码
 *  @param length  [in]文字长度
 */
static inline void TTKContextShowChineseTextInRect(CGContextRef ctx, CTFontRef fontRef, CGRect rect, const UniChar *string, size_t length) {
//    CGGlyph *glyphs = (CGGlyph *)alloca(sizeof(CGGlyph) * length);
//    DPAssert(length < 10);
//    CGGlyph glyphs[10];
//    CTFontGetGlyphsForCharacters(fontRef, string, glyphs, length);
//    
//    CGContextSetTextDrawingMode(ctx, kCGTextInvisible);
//    CGContextShowGlyphsAtPoint(ctx, rect.origin.x, rect.origin.y, (const CGGlyph *)glyphs, length);
//    
//    //Then get the position of the text and set the mode back to visible:
//    CGPoint pt = CGContextGetTextPosition(ctx);
//    //Draw at new position
//    CGContextSetTextDrawingMode(ctx, kCGTextFill);
//    CGContextShowGlyphsAtPoint(ctx, rect.origin.x + (rect.size.width - (pt.x - rect.origin.x)) / 2, rect.origin.y + 14, (const CGGlyph *)glyphs, length);
    
    
    DPAssert(length < 10);
    CGGlyph glyphs[length];
    CTFontGetGlyphsForCharacters(fontRef, string, glyphs, length);
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    CGContextShowGlyphsAtPoint(ctx, rect.origin.x, rect.origin.y, (const CGGlyph *)glyphs, length);
#pragma clang diagnostic pop
}

void TTKCoreGraphicDrawTextInRect(CGContextRef ctx, CGRect rect, const char *text, int fontSize, CGColorRef color);
/**
 *  在指定上下文中绘制文字(CoreText)
 *
 *  @param ctx    [in]指定上下文
 *  @param rect   [in]绘制区域
 *  @param string [in]文字内容
 *  @param isHanzi[in]是否为汉字
 */
void TTKCoreTextDrawTextInRect(CGContextRef ctx, CGRect rect, CFAttributedStringRef string);
/**
 *  创建bitmap位图上下文(采用笛卡尔坐标系). 需要用CGContextRelease进行释放
 *
 *  @param pixelsWide  [in]位图宽所占像素
 *  @param pixelsHigh  [in]位图高所占像素
 *
 *  @return 返回bitmap上下文
 */
CGContextRef TTKCreateBitmapContext(NSInteger pixelsWide, NSInteger pixelsHigh);

/**
 *  将两张高度一样的位图横向合并, 生成一张新图. 需要用CGContextRelease进行释放
 *
 *                     image1
 *  image1 + image2 =  ------
 *                     image2
 *
 *  @param ctx1 [in]第一张位图的绘图上下文
 *  @param ctx2 [in]第二张位图的绘图上下文
 *
 *  @return 新生成图的绘图上下文
 */
CGContextRef TTKCreateVerticalBitmapContext(CGContextRef ctx1, CGContextRef ctx2);

/**
 *  将两张宽度一样的位图纵向合并, 生成一张新图. 需要用CGContextRelease进行释放
 *
 *  image1 + image2 =  image1|image2
 *
 *  @param ctx1 [in]第一张位图的绘图上下文
 *  @param ctx2 [in]第二张位图的绘图上下文
 *
 *  @return 新生成图的绘图上下文
 */
CGContextRef TTKCreateHorizontalBitmapContext(CGContextRef ctx1, CGContextRef ctx2);

/**
 *  将三张位图合并, 生成一张新图. 需要用CGContextRelease进行释放
 *
 *                              image1|image2
 *  image1 + image2 + image3 =  ------+------
 *                                  image3
 *
 *  @param ctx1 [in]第一张位图的绘图上下文
 *  @param ctx2 [in]第二张位图的绘图上下文
 *  @param ctx3 [in]第三张位图的绘图上下文
 *
 *  @return 新生成图的绘图上下文
 */
CGContextRef TTKCreateTriangleBitmapContext(CGContextRef ctx1, CGContextRef ctx2, CGContextRef ctx3);

/**
 *  将四张位图合并, 生成一张新图. 需要用CGContextRelease进行释放
 *
 *                                       image1|image2
 *  image1 + image2 + image3 + image4 =  ------+------
 *                                       image3|image4
 *
 *  @param ctx1 [in]第一张位图的绘图上下文
 *  @param ctx2 [in]第二张位图的绘图上下文
 *  @param ctx3 [in]第三张位图的绘图上下文
 *  @param ctx4 [in]第四张位图的绘图上下文
 *
 *  @return 新生成图的绘图上下文
 */
CGContextRef TTKCreateGridsBitmapContext(CGContextRef ctx1, CGContextRef ctx2, CGContextRef ctx3, CGContextRef ctx4);
