//
//  DPTrendToolkit.cpp
//  DacaiProject
//
//  Created by WUFAN on 15/2/4.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#include "DPTrendToolkit.h"
#include <CoreText/CoreText.h>

#define PER_PIXEL_BYTE_COUNT     4   // 每一个像素所占字节数

CGContextRef TTKCreateBitmapContext(NSInteger pixelsWide, NSInteger pixelsHigh) {
    NSInteger bitmapBytesPerRow = (pixelsWide * PER_PIXEL_BYTE_COUNT); // 每个颜色占4字节
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    if (!context) return nil;
    CGColorSpaceRelease(colorSpace);
    return context;
}

// 合并竖向的2个图
CGContextRef TTKCreateVerticalBitmapContext(CGContextRef ctx1, CGContextRef ctx2) {
    NSInteger pixelsWide1 = CGBitmapContextGetWidth(ctx1);
    NSInteger pixelsWide2 = CGBitmapContextGetWidth(ctx2);
    NSInteger pixelsHigh1 = CGBitmapContextGetHeight(ctx1);
    NSInteger pixelsHigh2 = CGBitmapContextGetHeight(ctx2);
    
    NSInteger pixelsWide = pixelsWide1;
    NSInteger pixelsHigh = pixelsHigh1 + pixelsHigh2;
    
    NSInteger bitmapBytesPerRow = pixelsWide * PER_PIXEL_BYTE_COUNT;
    
    DPAssert(pixelsWide1 == pixelsWide2);
    DPAssert(pixelsWide1 * 4 == CGBitmapContextGetBytesPerRow(ctx1));
    DPAssert(pixelsWide2 * 4 == CGBitmapContextGetBytesPerRow(ctx2));
    DPAssert(CGBitmapContextGetBitsPerPixel(ctx1) == 32);
    DPAssert(CGBitmapContextGetBitsPerPixel(ctx2) == 32);
    DPAssert(CGBitmapContextGetBitsPerComponent(ctx1) == 8);
    DPAssert(CGBitmapContextGetBitsPerComponent(ctx2) == 8);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    if (!context) return nil;
    CGColorSpaceRelease(colorSpace);
    
    unsigned char *data = CGBitmapContextGetData(context);
    unsigned char *data1 = CGBitmapContextGetData(ctx1);
    unsigned char *data2 = CGBitmapContextGetData(ctx2);
    memcpy(data, data1, bitmapBytesPerRow * pixelsHigh1);
    memcpy(data + bitmapBytesPerRow * pixelsHigh1, data2, bitmapBytesPerRow * pixelsHigh2);
    
    return context;
}

// 合并横向的2个图
CGContextRef TTKCreateHorizontalBitmapContext(CGContextRef ctx1, CGContextRef ctx2) {
    NSInteger pixelsWide1 = CGBitmapContextGetWidth(ctx1);
    NSInteger pixelsWide2 = CGBitmapContextGetWidth(ctx2);
    NSInteger pixelsHigh1 = CGBitmapContextGetHeight(ctx1);
    NSInteger pixelsHigh2 = CGBitmapContextGetHeight(ctx2);
    
    NSInteger pixelsWide = pixelsWide1 + pixelsWide2;
    NSInteger pixelsHigh = pixelsHigh1;
    
    NSInteger bitmapBytesPerRow = pixelsWide * PER_PIXEL_BYTE_COUNT;
    
    DPAssert(pixelsHigh1 == pixelsHigh2);
    DPAssert(pixelsWide1 * 4 == CGBitmapContextGetBytesPerRow(ctx1));
    DPAssert(pixelsWide2 * 4 == CGBitmapContextGetBytesPerRow(ctx2));
    DPAssert(CGBitmapContextGetBitsPerPixel(ctx1) == 32);
    DPAssert(CGBitmapContextGetBitsPerPixel(ctx2) == 32);
    DPAssert(CGBitmapContextGetBitsPerComponent(ctx1) == 8);
    DPAssert(CGBitmapContextGetBitsPerComponent(ctx2) == 8);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    if (!context) return nil;
    CGColorSpaceRelease(colorSpace);
    
    unsigned char *data = CGBitmapContextGetData(context);
    unsigned char *data1 = CGBitmapContextGetData(ctx1);
    unsigned char *data2 = CGBitmapContextGetData(ctx2);
    
    for (int i = 0; i < pixelsHigh; i++) {
        memcpy(data + i * pixelsWide * PER_PIXEL_BYTE_COUNT,
               data1 + i * pixelsWide1 * PER_PIXEL_BYTE_COUNT,
               pixelsWide1 * PER_PIXEL_BYTE_COUNT);
        memcpy(data + i * pixelsWide * PER_PIXEL_BYTE_COUNT + pixelsWide1 * PER_PIXEL_BYTE_COUNT,
               data2 + i * pixelsWide2 * PER_PIXEL_BYTE_COUNT,
               pixelsWide2 * PER_PIXEL_BYTE_COUNT);
    }
    
    return context;
}

CGContextRef TTKCreateTriangleBitmapContext(CGContextRef ctx1, CGContextRef ctx2, CGContextRef ctx3) {
    NSInteger pixelsWide1 = CGBitmapContextGetWidth(ctx1);
    NSInteger pixelsWide2 = CGBitmapContextGetWidth(ctx2);
    NSInteger pixelsWide3 = CGBitmapContextGetWidth(ctx3);
    NSInteger pixelsHigh1 = CGBitmapContextGetHeight(ctx1);
    NSInteger pixelsHigh2 = CGBitmapContextGetHeight(ctx2);
    NSInteger pixelsHigh3 = CGBitmapContextGetHeight(ctx3);
    
    NSInteger pixelsWide = pixelsWide1 + pixelsWide2;
    NSInteger pixelsHigh = pixelsHigh1 + pixelsHigh3;
    
    NSInteger bitmapBytesPerRow = pixelsWide * PER_PIXEL_BYTE_COUNT;
    
    DPAssert(pixelsHigh1 == pixelsHigh2);
    DPAssert(pixelsWide3 == pixelsWide1 + pixelsWide2);
    DPAssert(pixelsWide1 * 4 == CGBitmapContextGetBytesPerRow(ctx1));
    DPAssert(pixelsWide2 * 4 == CGBitmapContextGetBytesPerRow(ctx2));
    DPAssert(pixelsWide3 * 4 == CGBitmapContextGetBytesPerRow(ctx3));
    DPAssert(CGBitmapContextGetBitsPerPixel(ctx1) == 32);
    DPAssert(CGBitmapContextGetBitsPerPixel(ctx2) == 32);
    DPAssert(CGBitmapContextGetBitsPerPixel(ctx3) == 32);
    DPAssert(CGBitmapContextGetBitsPerComponent(ctx1) == 8);
    DPAssert(CGBitmapContextGetBitsPerComponent(ctx2) == 8);
    DPAssert(CGBitmapContextGetBitsPerComponent(ctx3) == 8);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    if (!context) return nil;
    CGColorSpaceRelease(colorSpace);
    
    unsigned char *data = CGBitmapContextGetData(context);
    unsigned char *data1 = CGBitmapContextGetData(ctx1);
    unsigned char *data2 = CGBitmapContextGetData(ctx2);
    unsigned char *data3 = CGBitmapContextGetData(ctx3);
    
    // 拷贝第一第二两张图
    for (int i = 0; i < pixelsHigh1; i++) {
        memcpy(data + i * pixelsWide * PER_PIXEL_BYTE_COUNT,
               data1 + i * pixelsWide1 * PER_PIXEL_BYTE_COUNT,
               pixelsWide1 * PER_PIXEL_BYTE_COUNT);
        memcpy(data + i * pixelsWide * PER_PIXEL_BYTE_COUNT + pixelsWide1 * PER_PIXEL_BYTE_COUNT,
               data2 + i * pixelsWide2 * PER_PIXEL_BYTE_COUNT,
               pixelsWide2 * PER_PIXEL_BYTE_COUNT);
    }
    // 拷贝第三张图
    for (int i = 0; i < pixelsHigh3; i++) {
        memcpy(data + (pixelsHigh1 + i) * pixelsWide * PER_PIXEL_BYTE_COUNT,
               data3 + i * pixelsWide * PER_PIXEL_BYTE_COUNT,
               pixelsWide * PER_PIXEL_BYTE_COUNT);
    }
    
    return context;
}

// 合并左上、右上、左下、右下4张图
CGContextRef TTKCreateGridsBitmapContext(CGContextRef ctx1, CGContextRef ctx2, CGContextRef ctx3, CGContextRef ctx4) {
    NSInteger pixelsWide1 = CGBitmapContextGetWidth(ctx1);
    NSInteger pixelsWide2 = CGBitmapContextGetWidth(ctx2);
    NSInteger pixelsWide3 = CGBitmapContextGetWidth(ctx3);
    NSInteger pixelsWide4 = CGBitmapContextGetWidth(ctx4);
    NSInteger pixelsHigh1 = CGBitmapContextGetHeight(ctx1);
    NSInteger pixelsHigh2 = CGBitmapContextGetHeight(ctx2);
    NSInteger pixelsHigh3 = CGBitmapContextGetHeight(ctx3);
    NSInteger pixelsHigh4 = CGBitmapContextGetHeight(ctx4);
    
    NSInteger pixelsWide = pixelsWide1 + pixelsWide2;
    NSInteger pixelsHigh = pixelsHigh1 + pixelsHigh3;
    
    NSInteger bitmapBytesPerRow = pixelsWide * PER_PIXEL_BYTE_COUNT;
    
    DPAssert(pixelsHigh1 == pixelsHigh2 && pixelsHigh3 == pixelsHigh4);
    DPAssert(pixelsWide1 == pixelsWide3 && pixelsWide2 == pixelsWide4);
    DPAssert(pixelsWide1 * 4 == CGBitmapContextGetBytesPerRow(ctx1));
    DPAssert(pixelsWide2 * 4 == CGBitmapContextGetBytesPerRow(ctx2));
    DPAssert(pixelsWide3 * 4 == CGBitmapContextGetBytesPerRow(ctx3));
    DPAssert(pixelsWide4 * 4 == CGBitmapContextGetBytesPerRow(ctx4));
    DPAssert(CGBitmapContextGetBitsPerPixel(ctx1) == 32);
    DPAssert(CGBitmapContextGetBitsPerPixel(ctx2) == 32);
    DPAssert(CGBitmapContextGetBitsPerPixel(ctx3) == 32);
    DPAssert(CGBitmapContextGetBitsPerPixel(ctx4) == 32);
    DPAssert(CGBitmapContextGetBitsPerComponent(ctx1) == 8);
    DPAssert(CGBitmapContextGetBitsPerComponent(ctx2) == 8);
    DPAssert(CGBitmapContextGetBitsPerComponent(ctx3) == 8);
    DPAssert(CGBitmapContextGetBitsPerComponent(ctx4) == 8);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    if (!context) return nil;
    CGColorSpaceRelease(colorSpace);
    
    unsigned char *data = CGBitmapContextGetData(context);
    unsigned char *data1 = CGBitmapContextGetData(ctx1);
    unsigned char *data2 = CGBitmapContextGetData(ctx2);
    unsigned char *data3 = CGBitmapContextGetData(ctx3);
    unsigned char *data4 = CGBitmapContextGetData(ctx4);
    
    // 拷贝第一第二两张图
    for (int i = 0; i < pixelsHigh1; i++) {
        memcpy(data + i * pixelsWide * PER_PIXEL_BYTE_COUNT,
               data1 + i * pixelsWide1 * PER_PIXEL_BYTE_COUNT,
               pixelsWide1 * PER_PIXEL_BYTE_COUNT);
        memcpy(data + i * pixelsWide * PER_PIXEL_BYTE_COUNT + pixelsWide1 * PER_PIXEL_BYTE_COUNT,
               data2 + i * pixelsWide2 * PER_PIXEL_BYTE_COUNT,
               pixelsWide2 * PER_PIXEL_BYTE_COUNT);
    }
    // 拷贝第三第四两张图
    for (int i = 0; i < pixelsHigh3; i++) {
        memcpy(data + (pixelsHigh1 + i) * pixelsWide * PER_PIXEL_BYTE_COUNT,
               data3 + i * pixelsWide3 * PER_PIXEL_BYTE_COUNT,
               pixelsWide3 * PER_PIXEL_BYTE_COUNT);
        memcpy(data + (pixelsHigh1 + i) * pixelsWide * PER_PIXEL_BYTE_COUNT + pixelsWide3 * PER_PIXEL_BYTE_COUNT,
               data4 + i * pixelsWide4 * PER_PIXEL_BYTE_COUNT,
               pixelsWide4 * PER_PIXEL_BYTE_COUNT);
    }
    
    return context;
}

void TTKCoreTextDrawTextInRect(CGContextRef ctx, CGRect rect, CFAttributedStringRef string){
    
    DPAssertMsg(ctx != NULL, @"context 不能为空");
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(string);
    CGMutablePathRef pathRef = CGPathCreateMutable();

    
    CGPathAddRect(pathRef, NULL, rect);
    CTFrameRef frameRef =  CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), pathRef, NULL);
    CTFrameDraw(frameRef, ctx);
    
    CFRelease(frameRef);
    CGPathRelease(pathRef);
    CFRelease(frameSetter);
}

void TTKCoreGraphicDrawTextInRect(CGContextRef ctx, CGRect rect, const char *text, int fontSize, CGColorRef color){
    CGContextSetFillColorWithColor(ctx, color);
    CGContextSetTextDrawingMode(ctx, kCGTextFill);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    CGContextSelectFont(ctx, "Arial", fontSize, kCGEncodingMacRoman);
    CGContextShowTextAtPoint(ctx, rect.origin.x, rect.origin.y, text, strlen(text));
#pragma clang diagnostic pop
}


