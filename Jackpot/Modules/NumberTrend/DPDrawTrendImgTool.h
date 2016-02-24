//
//  DPTrendToolkit.h
//  DacaiProject
//
//  Created by WUFAN on 15/2/4.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  曲线图工具类

#import <UIKit/UIKit.h>
#import "DPTrendToolkit.h"


//图片样式
typedef enum {
    KTrendImgTypeNormal = 0,
    KTrendImgTypeMix,        // 混合型的，显示出现次数
    KTrendImgTypePoker,     // 扑克三
} KTrendImgType;

typedef enum {
    kTrendShapeTypeNone = 0,
    kTrendShapeTypeCircle,  // 圆
    kTrendShapeTypeSquare,  // 方
} kTrendShapeType;

typedef enum {
    kTextTypeNumber = 0,    // 数字
    kTextTypeHanzi,         // 中文
    kTextTypeMix,           // 数字和中文混合
    kTextTypePK,            // 扑克三
} kTextType;

typedef enum {
    KTrendImgWaitTypeNone = 0,
    KTrendImgWaitTypeFirstEmpty, // 第一行空
    KTrendImgWaitTypeAllEmpty,   // 全空
} KTrendImgWaitType;

// 四周线
typedef NS_OPTIONS(NSUInteger, kTrendAroundLine){
    kTrendAroundLineNone        = 0,
    kTrendAroundLineTop         = 1 << 0,
    kTrendAroundLineLeft        = 1 << 1,
    kTrendAroundLineRight       = 1 << 2,
    kTrendAroundLineBottom      = 1 << 3,
};

 
// 基本型
@interface DPTrendImgCellModel : NSObject
@property (nonatomic, assign) CGPoint point;            // 坐标索引，用CG坐标系
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *shapeColor;
@property (nonatomic, assign) kTrendShapeType shapeType;
@property (nonatomic, assign) kTextType textType;       // 内容类型
@end

// 混合型（cell 里面有shape， 有出现次数）
@interface DPTrendMixCellModel : DPTrendImgCellModel
@property (nonatomic, strong) NSString *timesText;      // 出现次数
@property (nonatomic, strong) UIColor *timesTextColor;
@end



typedef void(^drawFinishedFlag)(UIImage *image, int flag); // 画图回调
typedef void(^drawFinished)(UIImage *); // 画图回调

@interface DPDrawTrendImgData : NSObject
@property (nonatomic, strong) NSArray           *modelArray;            // 里面的model是DPTrendImgCellModel
@property (nonatomic, assign) KTrendImgType     imageType;              // 图片样式类型
@property (nonatomic, assign) BOOL              hasConnectLine;         // 是否有连接折线
@property (nonatomic, assign) CGFloat           rowHeight;              // 行高
@property (nonatomic, assign) int               rowCount;               // 行数
@property (nonatomic, assign) int               columnCount;            // 列数
@property (nonatomic, strong) UIColor           *singleRowColor;        // 单行背景色
@property (nonatomic, strong) UIColor           *doubleRowColor;        // 双行背景色
@property (nonatomic, strong) UIColor           *conectLineColor;       // 连接线颜色
@property (nonatomic, strong) UIColor           *columnLineColor;       // 分割竖线颜色
@property (nonatomic, strong) NSArray           *columnWidthArray;      // 列宽
@property (nonatomic, assign) int               fontSize;               // 字体大小 默认13
@property (nonatomic, assign) kTrendAroundLine  aroundLine;             // 四周画线
@property (nonatomic, assign) KTrendImgWaitType waitType;               // 等待开奖，第一行空或者全空

- (CGContextRef)startDrawImgeContext;
@end

@interface DPDrawTrendImgTool : NSObject
//+ (UIImage *)drawVerticalCombinationImageWithData1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2;
//+ (UIImage *)drawHorizontalCombinationImageWithData1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2;
//+ (UIImage *)drawThreeCombineImgWithData1:(DPDrawTrendImgData*)data1 data2:(DPDrawTrendImgData*)data2 data3:(DPDrawTrendImgData *)data3;
//+ (UIImage *)drawFourCombineImgWithData1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 data3:(DPDrawTrendImgData *)data3 data4:(DPDrawTrendImgData *)data4;

//+ (UIImage *)drawImageWithData:(DPDrawTrendImgData *)data; // 画一张图
//+ (void)drawHorizontalCombinationImageWithData1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 finish:(drawFinished)finished;
//+ (void)drawVerticalCombinationImageWithData1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 finish:(drawFinished)finished;
//+ (void)drawThreeCombineImgWithData1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 data3:(DPDrawTrendImgData *)data3 finish:(drawFinished)finished;
//+ (void)drawVerticalCombinationImageHeighPriorityWithData1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 finish:(drawFinished)finished;
//+ (void)drawFourCombineImgWithData1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 data3:(DPDrawTrendImgData *)data3 data4:(DPDrawTrendImgData *)data4 finish:(drawFinished)finished;
#pragma mark - 多线程方法
+ (void)drawImageWithPriority:(long)priority data:(DPDrawTrendImgData *)data finish:(drawFinished)finished; // 画一张图片
+ (void)drawHorizontalCombinationImageWithPriority:(long)priority Data1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 finish:(drawFinished)finished;
+ (void)drawVerticalCombinationImageWithPriority:(long)priority Data1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 finish:(drawFinished)finished;
+ (void)drawThreeCombineImgWithPriority:(long)priority data1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 data3:(DPDrawTrendImgData *)data3 finish:(drawFinished)finished;
+ (void)drawThreeCombineImgMidLineWithPriority:(long)priority data1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 data3:(DPDrawTrendImgData *)data3 finish:(drawFinished)finished;
+ (void)drawFourCombineImgWithPriority:(long)priority data1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 data3:(DPDrawTrendImgData *)data3 data4:(DPDrawTrendImgData *)data4 finish:(drawFinished)finished;

#pragma mark - 多线程方法（带标识）
+ (void)drawImageWithPriority:(long)priority data:(DPDrawTrendImgData *)data flag:(int)flag finish:(drawFinishedFlag)finished; // 画一张图片
+ (void)drawHorizontalCombinationImageWithPriority:(long)priority Data1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 flag:(int)flag finish:(drawFinishedFlag)finished;
+ (void)drawVerticalCombinationImageWithPriority:(long)priority Data1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 flag:(int)flag finish:(drawFinishedFlag)finished;
+ (void)drawThreeCombineImgWithPriority:(long)priority data1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 data3:(DPDrawTrendImgData *)data3 flag:(int)flag finish:(drawFinishedFlag)finished;
+ (void)drawThreeCombineImgMidLineWithPriority:(long)priority data1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 data3:(DPDrawTrendImgData *)data3 flag:(int)flag finish:(drawFinishedFlag)finished;
+ (void)drawFourCombineImgWithPriority:(long)priority data1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 data3:(DPDrawTrendImgData *)data3 data4:(DPDrawTrendImgData *)data4 flag:(int)flag finish:(drawFinishedFlag)finished;
@end
