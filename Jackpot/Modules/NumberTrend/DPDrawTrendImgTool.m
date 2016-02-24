//
//  DPTrendToolkit.cpp
//  DacaiProject
//
//  Created by WUFAN on 15/2/4.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#include "DPDrawTrendImgTool.h"
#import <CoreText/CoreText.h>

typedef enum {
    kDrawTextTypeNormalMiss = 0, // 普通遗漏
    kDrawTextTypeMixMiss,   // 混合遗漏
    kDrawTextTypeMixTime, // 混合次数文本
} kDrawTextType;

@implementation DPTrendImgCellModel
- (instancetype)init
{
    if (self = [super init]) {
        _point = CGPointMake(- 1, - 1);
        _shapeType = kTrendShapeTypeNone;
        _textColor = [UIColor clearColor];
        _shapeColor = [UIColor clearColor];
        _textType = kTextTypeNumber;
    }
    return self;
}
@end

@implementation DPTrendMixCellModel
@end

 @interface DPDrawTrendImgData ()
@property (nonatomic, assign) CTFontRef fontRef;
@property (nonatomic, assign) CGFloat  scale;                  // 图片缩放  x2 x3 二倍图还是三倍图
@property (nonatomic, strong, readonly) NSMutableDictionary *numberMoveDict;    // 存放数字字形偏移
@property (nonatomic, strong, readonly) NSMutableDictionary *hanziMoveDict;     // 存放汉字字形偏移
@property (nonatomic, strong, readonly) NSMutableDictionary *mixMoveDict;       // 存放混合字形偏移
@property (nonatomic, strong, readonly) NSMutableDictionary *pkMoveDict;        // 存放扑克三字形偏移

@end
@implementation DPDrawTrendImgData
@synthesize modelArray = _modelArray;
- (instancetype)init
{
    if (self = [super init]) {
        _hasConnectLine = NO;  // 是否有连接折
        _imageType = KTrendImgTypeNormal;
        _fontSize = 13;   // 字体大小
        _scale = [[UIScreen mainScreen] scale];//获取图片缩放因子
        _aroundLine = kTrendAroundLineNone;
        _waitType = KTrendImgWaitTypeNone;
        _numberMoveDict = [NSMutableDictionary dictionaryWithCapacity:10];
        _hanziMoveDict = [NSMutableDictionary dictionaryWithCapacity:10];
        _mixMoveDict = [NSMutableDictionary dictionaryWithCapacity:10];
        _pkMoveDict = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return self;
}
- (CTFontRef)fontRef
{
    if (_fontRef == nil) {
        UIFont *font = [UIFont fontWithName:@"ArialMT" size:self.fontSize * self.scale];
        CFStringRef fontName = (__bridge CFStringRef)font.fontName;
        _fontRef = CTFontCreateWithName(fontName, self.fontSize * self.scale, NULL);
    }
    return _fontRef;
}
- (id)copy
{
    DPDrawTrendImgData *data = [[DPDrawTrendImgData alloc]init];
    data.modelArray = self.modelArray;
    data.rowCount = self.rowCount;
    data.columnCount = self.columnCount;
    data.columnWidthArray = self.columnWidthArray;
    data.columnLineColor = self.columnLineColor;
    data.conectLineColor = self.conectLineColor;
    data.imageType = self.imageType;
    data.hasConnectLine = self.hasConnectLine;
    data.rowHeight = self.rowHeight;
    data.scale = self.scale;
    data.fontSize = self.fontSize;
    return data;
}
- (void)dealloc
{
    if (self.fontRef) CFRelease(_fontRef);
}
- (CGContextRef)startDrawImgeContext
{
    if (self.modelArray.count == 0) return NULL;
//    NSAssert(self.modelArray.count > 0, @"model 不能为空");
    
    return [self pvt_drawImgWithCellImgType:self.imageType modelArray:self.modelArray];
}

- (CGContextRef)pvt_drawImgWithCellImgType:(KTrendImgType)imageType modelArray:(NSArray *)modelArray
{
    DPAssertMsg(self.rowCount > 0, @"行数不能为0");
    DPAssertMsg(self.columnCount > 0, @"列数不能为0");
    DPAssertMsg(self.columnCount == self.columnWidthArray.count, @"列数和列宽数组的count要一致");
    
    CGFloat allColumnW = 0; // 整张图的宽度
    for (int i = 0; i < self.columnWidthArray.count; i++) {
        allColumnW += [self.columnWidthArray[i] floatValue];
    }
    
    CGContextRef context = TTKCreateBitmapContext(allColumnW *self.scale , self.rowCount * self.rowHeight * self.scale);
    [self pvt_drawRowAndColumnWithContext:context]; // 画行和列 分割线
    if (self.waitType != KTrendImgWaitTypeAllEmpty) {
        [self pvt_drawContentWithContext:context imageType:self.imageType]; // 画单元格内容
        [self pvt_drawAroundLineWithContext:context width:allColumnW * self.scale height:self.rowCount * self.rowHeight * self.scale];
    }
    return context;
}
// 画图的四周的线
- (void)pvt_drawAroundLineWithContext:(CGContextRef)context width:(CGFloat)width height:(CGFloat)height
{
    if (kTrendAroundLineNone == self.aroundLine) {
        return;
    }
    CGContextSetStrokeColorWithColor(context, self.columnLineColor.CGColor);
    CGContextSetLineWidth(context, 2.0f * self.scale);
    if (kTrendAroundLineTop & self.aroundLine) {
//        CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
        CGContextMoveToPoint(context, 0, height);
        CGContextAddLineToPoint(context, width, height);
//        DPLog(@"%d, top 线", self.aroundLine);
    }
    if (kTrendAroundLineLeft & self.aroundLine){
//        CGContextSetStrokeColorWithColor(context, [UIColor dp_flatRedColor].CGColor);
        CGFloat y = 0;
        if (self.waitType == KTrendImgWaitTypeFirstEmpty) y = self.rowHeight * self.scale;
        CGContextMoveToPoint(context, 0, y);
        CGContextAddLineToPoint(context, 0, height);
//        DPLog(@"%d, left 线", self.aroundLine);
    }
    if (kTrendAroundLineBottom & self.aroundLine){
//        CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
        CGContextMoveToPoint(context, 0, 0);
        CGContextAddLineToPoint(context, width, 0);
//        DPLog(@"%d, bottom 线", self.aroundLine);
    }
    if (kTrendAroundLineRight & self.aroundLine){
//        CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
        CGFloat y = 0;
        if (self.waitType == KTrendImgWaitTypeFirstEmpty) y = self.rowHeight * self.scale;
        CGContextMoveToPoint(context, width, y);
        CGContextAddLineToPoint(context, width, height);
//        DPLog(@"%d, right 线", self.aroundLine);
    }
    CGContextDrawPath(context, kCGPathStroke);
}
// 画行和列背景
- (void)pvt_drawRowAndColumnWithContext:(CGContextRef)context
{
    int singleRowCount =  self.rowCount / 2;//单行个数
    int doubleRowCount = self.rowCount % 2 == 0 ? singleRowCount : self.rowCount / 2 + 1;//双行个数
    CGRect *rectsSingle = alloca(sizeof(CGRect) * singleRowCount);//单行位置
    CGRect *rectsDouble = alloca(sizeof(CGRect) * doubleRowCount);//双行位置

    CGFloat allColumnW = 0; // 整张图的宽度
    for (int i = 0; i < self.columnWidthArray.count; i++) {
           allColumnW += ([self.columnWidthArray[i] floatValue] * self.scale);
    }
    int s = 0;
    int d = 0;
    for (int i = 0; i < self.rowCount; i++) {
        if (i % 2== 0) {
            rectsDouble[d].origin.x = 0;
            rectsDouble[d].origin.y = i * self.rowHeight * self.scale;
            rectsDouble[d].size.width = allColumnW ;
            rectsDouble[d].size.height = self.rowHeight * self.scale;
            d++;
        }else{
            rectsSingle[s].origin.x = 0;
            rectsSingle[s].origin.y = i * self.rowHeight * self.scale;
            rectsSingle[s].size.width = allColumnW ;
            rectsSingle[s].size.height = self.rowHeight * self.scale;
            s++;
        }
    }
    // 行背景
    CGContextSetFillColorWithColor(context, self.singleRowColor.CGColor);
    CGContextFillRects(context, rectsSingle, singleRowCount);
    CGContextSetFillColorWithColor(context, self.doubleRowColor.CGColor);
    CGContextFillRects(context, rectsDouble, doubleRowCount);
    
    // 画分割线（列分割线）
    if (self.columnWidthArray.count < 2 || self.waitType == KTrendImgWaitTypeAllEmpty) return;
    CGContextSetStrokeColorWithColor(context, self.columnLineColor.CGColor);
    CGContextSetLineWidth(context, 0.5f * self.scale);
    CGFloat colomnWidth = 0;
    for (int i = 0; i < self.columnWidthArray.count; i++) {
        // 线比列数多一个
        colomnWidth += ([self.columnWidthArray[i] floatValue] * self.scale);
//        if (i == self.columnWidthArray.count - 1){
//            // 最后一根线
//            CGContextMoveToPoint(context, colomnWidth - 0.5f * self.scale, 0);
//            CGContextAddLineToPoint(context, colomnWidth - 0.5f * self.scale, self.rowHeight * self.rowCount * self.scale);
//            continue;
//        }
        CGFloat y = 0;
        if (self.waitType == KTrendImgWaitTypeFirstEmpty) y = self.rowHeight * self.scale; // 第一行不画
        CGContextMoveToPoint(context, colomnWidth, y);
        CGContextAddLineToPoint(context, colomnWidth, self.rowHeight * self.rowCount * self.scale);
//        if (i == self.columnWidthArray.count) break;
    }
    CGContextDrawPath(context, kCGPathStroke);
    
    // 大分割线
}
// 画单元格内容
- (void)pvt_drawContentWithContext:(CGContextRef)context imageType:(KTrendImgType)imageType
{
    if (imageType == KTrendImgTypeMix) { // 混合型的
        if (self.hasConnectLine == NO) {
            // 没有连线的（先画shape 再画字）
            for (DPTrendMixCellModel *mixModel in self.modelArray) {
                [self pvt_drawMixShapeWithContext:context model:mixModel];
                [self pvt_drawMixTimesTextWithContext:context model:mixModel];
                [self pvt_drawMixMissTextWithContext:context model:mixModel];
            }
        }else{
            // 有连线 （先shape，连线，再画字）
            NSMutableArray *highlightArray = [NSMutableArray arrayWithCapacity:self.rowCount + 10]; // 存放高亮要画线的model
            for (DPTrendMixCellModel *mixModel in self.modelArray) {
                if (mixModel.shapeType == kTrendShapeTypeCircle){
                    [self pvt_drawMixShapeWithContext:context model:mixModel];
                    [highlightArray addObject:mixModel];
                    if (self.waitType == KTrendImgWaitTypeFirstEmpty && mixModel.point.y == 0) {
                        // 显示开奖状态，第一行不画
                        [highlightArray removeLastObject];
                    }
                }
                [self pvt_drawMixMissTextWithContext:context model:mixModel];
            }
            // 画连接线
            [self pvt_drawConnnectLineWithContext:context imageType:KTrendImgTypeMix modelArray:highlightArray];
            // 画time text
            for (DPTrendMixCellModel *mixModel in self.modelArray) {
                [self pvt_drawMixTimesTextWithContext:context model:mixModel];
            }
        }
        return;
    }
    
    // 普通型
    if (self.hasConnectLine == NO) {
        // 没有连线的（先画shape 再画字）
        for (DPTrendImgCellModel *model in self.modelArray) {
            // 画圆或者方
            if (model.shapeType == kTrendShapeTypeCircle || model.shapeType == kTrendShapeTypeSquare) {
                [self pvt_drawShapeWithContext:context model:model];
            }
            // 画字
            [self pvt_drawNomralMissTextWithContext:context model:model];
        }
    }else{
        // 有连线 （先shape，遗漏字，高亮字空着，线，再高亮字）
        NSMutableArray *highlightArray = [NSMutableArray arrayWithCapacity:self.rowCount + 10]; // 存放高亮要画线的model
        for (DPTrendImgCellModel *model in self.modelArray) {
            // 画圆或者方
            if (model.shapeType == kTrendShapeTypeCircle || model.shapeType == kTrendShapeTypeSquare) {
                [self pvt_drawShapeWithContext:context model:model];
                [highlightArray addObject:model];
                if (self.waitType == KTrendImgWaitTypeFirstEmpty && model.point.y == 0) {
                    // 显示开奖状态，第一行不画
                    [highlightArray removeLastObject];
                }
                continue;
            }
            // 画字
            [self pvt_drawNomralMissTextWithContext:context model:model];
        }
        // 画连线
        [self pvt_drawConnnectLineWithContext:context imageType:KTrendImgTypeNormal modelArray:highlightArray];
        
        // 再画高亮字
        for (DPTrendImgCellModel *model in highlightArray) {
            [self pvt_drawNomralMissTextWithContext:context model:model];
        }
    }
}
// 画圆或者方形(混合型)
- (void)pvt_drawMixShapeWithContext:(CGContextRef)context model:(DPTrendMixCellModel *)model
{
    if (model.shapeType == kTrendShapeTypeNone || model.shapeType == kTrendShapeTypeSquare) {
        return;
    }
    if (self.waitType == KTrendImgWaitTypeFirstEmpty && model.point.y == 0) {
        return; // 如果显示正在开奖，第一行不画
    }
    [self pvt_drawShapeWithImgType:KTrendImgTypeMix Context:context model:model];
}
// 画圆或者方形(普通)
- (void)pvt_drawShapeWithContext:(CGContextRef)context model:(DPTrendImgCellModel *)model
{
    if (model.shapeType == kTrendShapeTypeNone) {
        return;
    }
    if (self.waitType == KTrendImgWaitTypeFirstEmpty && model.point.y == 0) {
        return; // 显示正在开奖，第一行不画
    }
    [self pvt_drawShapeWithImgType:KTrendImgTypeNormal Context:context model:model];
}
// 画圆或者方形共用方法
- (void)pvt_drawShapeWithImgType:(KTrendImgType)imageType Context:(CGContextRef)context model:(DPTrendImgCellModel *)model
{
    CGContextSetFillColorWithColor(context, model.shapeColor.CGColor);
    CGRect shapeRect = [self pvt_shapeRectWithType:imageType model:model];
    if (model.shapeType == kTrendShapeTypeCircle) {
        CGContextFillEllipseInRect(context, shapeRect);
        //                CGContextAddEllipseInRect(, ), 这句和上一句的区别
    }else if (model.shapeType == kTrendShapeTypeSquare){
        CGContextFillRect(context, shapeRect);
    }
    CGContextDrawPath(context, kCGPathFill);
}
// 画连线
- (void)pvt_drawConnnectLineWithContext:(CGContextRef)context imageType:(KTrendImgType)imageType modelArray:(NSMutableArray *)modelArray
{
    NSArray *sortedArray = [modelArray sortedArrayUsingComparator:^NSComparisonResult(DPTrendImgCellModel *obj1, DPTrendImgCellModel *obj2) {
        if (obj1.point.y < obj2.point.y) {
            return NSOrderedAscending;
        }else{
            return NSOrderedDescending;
        }
    }];

    CGContextSetStrokeColorWithColor(context, self.conectLineColor.CGColor);
    CGContextSetLineWidth(context, 1.0f * self.scale);

    DPTrendImgCellModel *firstModel = [sortedArray firstObject];
    CGRect shapeRect = [self pvt_shapeRectWithType:imageType model:firstModel];
    
    CGFloat x = shapeRect.origin.x;
    CGFloat y = shapeRect.origin.y;
    CGFloat moveX = CGRectGetWidth(shapeRect) / 2.0f;  // 水平偏移
    CGFloat moveY = CGRectGetHeight(shapeRect) / 2.0f; // 垂直偏移
    CGContextMoveToPoint(context, x + moveX, y + moveY);

    
    for (DPTrendImgCellModel *model in sortedArray) {
        shapeRect = [self pvt_shapeRectWithType:imageType model:model];
        CGFloat x = shapeRect.origin.x;
        CGFloat y = shapeRect.origin.y;
        CGFloat moveX = CGRectGetWidth(shapeRect) / 2.0f;  // 水平偏移
        CGFloat moveY = CGRectGetHeight(shapeRect) / 2.0f; // 垂直偏移

        CGContextAddLineToPoint(context, x + moveX, y + moveY);
//        CGContextMoveToPoint(context, x + moveX, y + moveY);
    }
    CGContextDrawPath(context, kCGPathStroke);
}
// 画字
// 普通的miss
- (void)pvt_drawNomralMissTextWithContext:(CGContextRef)context model:(DPTrendImgCellModel *)model
{
    if (model.text == nil || model.text.length == 0) {
        return;
    }
    if (self.waitType == KTrendImgWaitTypeFirstEmpty && model.point.y == 0) {
        return; // 显示正在开奖，第一行不画
    }
    CGRect textRect = [self pvt_textRectWithType:kDrawTextTypeNormalMiss model:model];
    [self pvt_drawTextWithContext:context text:model.text coordinateRect:textRect color:model.textColor textType:model.textType];
}
// 混合型的miss
- (void)pvt_drawMixMissTextWithContext:(CGContextRef)context model:(DPTrendMixCellModel *)model
{
    if (self.waitType == KTrendImgWaitTypeFirstEmpty && model.point.y == 0) {
        return; // 显示正在开奖，第一行不画
    }
    if (model.timesText == nil || model.text.length == 0) {
        // 没有timeText
        [self pvt_drawNomralMissTextWithContext:context model:model];
        return;
    }
    CGRect textRect = [self pvt_textRectWithType:kDrawTextTypeMixMiss model:model];
    [self pvt_drawTextWithContext:context text:model.text coordinateRect:textRect color:model.textColor textType:model.textType];
}
// 混合型的times
- (void)pvt_drawMixTimesTextWithContext:(CGContextRef)context model:(DPTrendMixCellModel *)model
{
    if (model.timesText.length <= 0) {
        return;
    }
    if (self.waitType == KTrendImgWaitTypeFirstEmpty && model.point.y == 0) {
        return; // 显示正在开奖，第一行不画
    }
    DPAssertMsg([model isKindOfClass:[DPTrendMixCellModel class]], @"model 类型不对");
    DPAssertMsg(model.timesText.length > 0, @"model times text 不能为空");
    
    CGRect textRect = [self pvt_textRectWithType:kDrawTextTypeMixTime model:model];
    [self pvt_drawTextWithContext:context text:model.timesText coordinateRect:textRect color:model.timesTextColor textType:model.textType];
}
// 画字的公有方法
- (void)pvt_drawTextWithContext:(CGContextRef)context text:(NSString *)text coordinateRect:(CGRect)rect color:(UIColor *)color textType:(kTextType)textType
{
    CGRect drawRect = [self pvt_getDrawTextRectInRect:rect string:text textType:textType];
    if (textType == kTextTypeNumber) {
        TTKCoreGraphicDrawTextInRect(context, drawRect, text.UTF8String, self.fontSize * self.scale, color.CGColor);
    }else{
        NSMutableAttributedString *attM = [[NSMutableAttributedString alloc]initWithString:text];
        [attM addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.fontSize * self.scale] range:NSMakeRange(0, text.length)];
        [attM addAttribute:NSForegroundColorAttributeName value:(id)color.CGColor range:NSMakeRange(0, text.length)];
        TTKCoreTextDrawTextInRect(context, drawRect, (__bridge CFAttributedStringRef)attM);
    }
}
// 绘制文字字形的具体rect
- (CGRect)pvt_getDrawTextRectInRect:(CGRect)rect string:(NSString *)string textType:(kTextType)textType
{
    if (textType == kTextTypePK){
        // 针对扑克三
        NSString *huaSe = [string substringToIndex:1];
        if (self.pkMoveDict[huaSe] == nil || self.pkMoveDict[huaSe][@(string.length)] == nil) {
            NSMutableAttributedString *attM = [[NSMutableAttributedString alloc]initWithString:string];
            [attM addAttribute:NSFontAttributeName value:(__bridge id)self.fontRef range:NSMakeRange(0, string.length)];
            
            CGFloat ascent, descent, leading;
            CTLineRef lineRef = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)attM);
            CGFloat width = CTLineGetTypographicBounds(lineRef, &ascent, &descent, &leading);
            CFRelease(lineRef);
            
            CGFloat moveX = (rect.size.width - width) / 2.0f;               // 水平偏移
            CGFloat moveY = (rect.size.height - ascent - descent) / 2.0f;
            NSDictionary *resDict = [NSDictionary dictionaryWithObject:[NSValue valueWithCGPoint:CGPointMake(moveX, moveY)] forKey:@(string.length)];
            [self.pkMoveDict setObject:resDict forKey:huaSe];
            return CGRectMake(rect.origin.x + moveX , rect.origin.y - moveY, rect.size.width, rect.size.height);
        }
//        DPLog(@"pks move dict = %@", self.pkMoveDict);
        CGPoint movePoint = [self.pkMoveDict[huaSe][@(string.length)] CGPointValue];
        return CGRectMake(rect.origin.x + movePoint.x , rect.origin.y - movePoint.y , rect.size.width, rect.size.height);

    }
    NSMutableDictionary *targetDict = self.numberMoveDict;
    int change = 1;
    int changeDes = 1;
    if (textType == kTextTypeHanzi){
        targetDict = self.hanziMoveDict;
        change = - 1;
        changeDes = 0;
    }
    if (textType == kTextTypeMix){
        targetDict = self.mixMoveDict;
        change = - 1;
        changeDes = - 1;
    }

    if (targetDict[@(rect.size.width)] == nil || targetDict[@(rect.size.width)][@(string.length)] == nil) {
        NSMutableAttributedString *attM = [[NSMutableAttributedString alloc]initWithString:string];
        [attM addAttribute:NSFontAttributeName value:(__bridge id)self.fontRef range:NSMakeRange(0, string.length)];
        
        CGFloat ascent, descent, leading;
        CTLineRef lineRef = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)attM);
        CGFloat width = CTLineGetTypographicBounds(lineRef, &ascent, &descent, &leading);
        CFRelease(lineRef);
        
        CGFloat moveX = (rect.size.width - width) / 2.0f;               // 水平偏移
        CGFloat moveY = (rect.size.height - ascent + descent * changeDes) / 2.0f * change;
        NSDictionary *resDict = [NSDictionary dictionaryWithObject:[NSValue valueWithCGPoint:CGPointMake(moveX, moveY)] forKey:@(string.length)];
        [targetDict setObject:resDict forKey:@(rect.size.width)];
        return CGRectMake(rect.origin.x + moveX , rect.origin.y + moveY, rect.size.width, rect.size.height);
    }
//    DPLog(@"target = %@", targetDict);

    CGPoint movePoint = [targetDict[@(rect.size.width)][@(string.length)] CGPointValue];
    return CGRectMake(rect.origin.x + movePoint.x , rect.origin.y + movePoint.y , rect.size.width, rect.size.height);
}
// 获取text绘制的rect, 分三种类型
- (CGRect)pvt_textRectWithType:(kDrawTextType)textType model:(DPTrendImgCellModel *)model
{
    CGFloat x = [self pvt_coordinateXwithRect:model.point];
    CGFloat y = model.point.y * self.rowHeight * self.scale;
    CGFloat width = [self pvt_colomnWidthAtIndex:model.point.x];
    CGFloat height = self.rowHeight * self.scale;
    int minMargin = width > height ? height : width; // 取小边
    
    if (textType == kDrawTextTypeNormalMiss){
         return CGRectMake(x, y, width, height);
    }else if (textType == kDrawTextTypeMixTime){
        return (CGRect){CGPointMake(x, y), CGSizeMake(minMargin, minMargin)}; // 转换成context的坐标
    }else{
        return (CGRect){CGPointMake(x + minMargin, y), CGSizeMake(width - minMargin, height)};
    }
}
// 获取shape绘制的rect, 分2种情况（普通和混合）
- (CGRect)pvt_shapeRectWithType:(KTrendImgType)imageType model:(DPTrendImgCellModel *)model
{
    if (imageType == KTrendImgTypeNormal) {
        CGRect textRect = [self pvt_textRectWithType:kDrawTextTypeNormalMiss model:model];
        if (model.shapeType == kTrendShapeTypeCircle) {
            // 如果是圆有偏移量，和边线保持距离
            CGFloat minW = textRect.size.width > textRect.size.height ? textRect.size.height : textRect.size.width; // 取小边
            CGFloat circleMargin = minW - 4.0f * self.scale; // 圆的边长
            CGPoint circleP = CGPointMake(textRect.origin.x + (textRect.size.width - circleMargin) / 2.0f, textRect.origin.y + (textRect.size.height - circleMargin) / 2.0f);
            return (CGRect){circleP, CGSizeMake(circleMargin, circleMargin)};
        }
        return [self pvt_textRectWithType:kDrawTextTypeNormalMiss model:model];
    }else {
        // 混合的shape，目前只有圆形
        DPAssertMsg(model.shapeType == kTrendShapeTypeCircle, @"混合图形里，time text 只有圆形");
        CGRect textRect = [self pvt_textRectWithType:kDrawTextTypeMixTime model:model];
        return (CGRect){CGPointMake(textRect.origin.x + 2 * self.scale, textRect.origin.y + 2 * self.scale), CGSizeMake(textRect.size.width - 4 *self.scale, textRect.size.height - 4 * self.scale)};
    }
}

// 根据model的rect获取在context的x坐标
- (CGFloat)pvt_coordinateXwithRect:(CGPoint)point
{
    CGFloat coloumnX = 0;
    for (int i = 0; i < point.x; i++) {
        coloumnX += ([self.columnWidthArray[i] floatValue] * self.scale);
    }
    return coloumnX;
}
- (CGFloat)pvt_colomnWidthAtIndex:(int)index
{
    return [self.columnWidthArray[index] floatValue] * self.scale;
}

@end


@implementation DPDrawTrendImgTool
#pragma mark - 非多线程方法（看看和多线程方法性能差多少）
//+ (UIImage *)drawImageWithData:(DPDrawTrendImgData *)data
//{
//    CGContextRef context = [data startDrawImgeContext];
//    CGImageRef imageref = CGBitmapContextCreateImage(context);
//    UIImage *image = [UIImage imageWithCGImage:imageref scale:data.scale orientation:UIImageOrientationUp];
//    CGContextRelease(context);
//    CGImageRelease(imageref);
//    return image;
//}
//+ (UIImage *)drawHorizontalCombinationImageWithData1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2
//{
//    CGContextRef context1 = [data1 startDrawImgeContext];
//    CGContextRef context2 = [data2 startDrawImgeContext];
//    CGContextRef context = TTKCreateHorizontalBitmapContext(context1, context2);
//    CGContextRelease(context1);
//    CGContextRelease(context2);
//    
//    CGImageRef imageref = CGBitmapContextCreateImage(context);
//    CGContextRelease(context);
//    UIImage *image = [UIImage imageWithCGImage:imageref scale:data1.scale orientation:UIImageOrientationUp];
//    CGImageRelease(imageref);
//    
//    return image;
//}
//+ (UIImage *)drawVerticalCombinationImageWithData1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2
//{
//    CGContextRef context1 = [data1 startDrawImgeContext];
//    CGContextRef context2 = [data2 startDrawImgeContext];
//    CGContextRef context = TTKCreateVerticalBitmapContext(context1, context2);
//    CGContextRelease(context1);
//    CGContextRelease(context2);
//    
//    CGImageRef imageref = CGBitmapContextCreateImage(context);
//    CGContextRelease(context);
//    UIImage *image = [UIImage imageWithCGImage:imageref scale:data1.scale orientation:UIImageOrientationUp];
//    CGImageRelease(imageref);
//    return image;
//}
//+ (UIImage *)drawThreeCombineImgWithData1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 data3:(DPDrawTrendImgData *)data3
//{
//    CGContextRef context1 = [data1 startDrawImgeContext];
//    CGContextRef context2 = [data2 startDrawImgeContext];
//    CGContextRef context3 = [data3 startDrawImgeContext];
//    CGContextRef context = TTKCreateTriangleBitmapContext(context1, context2, context3);
//    CGContextRelease(context1);
//    CGContextRelease(context2);
//    CGContextRelease(context3);
//    UIImage *image = [self pvt_createImageFromContext:context scale:data1.scale];
//    CGContextRelease(context);
//    return image;
//}
//+ (UIImage *)drawFourCombineImgWithData1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 data3:(DPDrawTrendImgData *)data3 data4:(DPDrawTrendImgData *)data4
//{
//    CGContextRef context1 = [data1 startDrawImgeContext];
//    CGContextRef context2 = [data2 startDrawImgeContext];
//    CGContextRef context3 = [data3 startDrawImgeContext];
//    CGContextRef context4 = [data3 startDrawImgeContext];
//    CGContextRef context = TTKCreateGridsBitmapContext(context1, context2, context3, context4);
//    CGContextRelease(context1);
//    CGContextRelease(context2);
//    CGContextRelease(context3);
//    CGContextRelease(context4);
//    UIImage *image = [self pvt_createImageFromContext:context scale:data1.scale];
//    CGContextRelease(context);
//    return image;
//}
#pragma mark - 多线程方法（不带标识）
+ (void)drawImageWithPriority:(long)priority data:(DPDrawTrendImgData *)data finish:(drawFinished)finished
{
    dispatch_async(dispatch_get_global_queue(priority, 0), ^{
        CGContextRef context = [data startDrawImgeContext];
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:data.scale orientation:UIImageOrientationUp];
        finished(image);
        CGContextRelease(context);
        CGImageRelease(imageRef);
    });
}
+ (void)drawHorizontalCombinationImageWithPriority:(long)priority Data1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 finish:(drawFinished)finished
{
    __block __typeof(CGContextRef) weak_context1 = NULL;
    __block __typeof(CGContextRef) weak_context2 = NULL;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(priority, 0);
    
    dispatch_group_async(group, globalQueue, ^{
        DPLog(@"画图执行 1 ");
        DPAssertMsg(data1, @"data1 不能为空");
        weak_context1 = [data1 startDrawImgeContext];
    });
    
    dispatch_group_async(group, globalQueue, ^{
        DPLog(@"画图执行 2 ");
        DPAssertMsg(data2, @"data2 不能为空");
        weak_context2 = [data2 startDrawImgeContext];
        
    });
    //    NSInteger waitRes = dispatch_group_wait(group, DISPATCH_TIME_FOREVER); // 等待group全部执行完毕
    //    DPLog(@"waitres 1 = %d", waitRes);
    dispatch_group_notify(group, globalQueue, ^{
        DPLog(@"group notify 1 执行");
        DPAssertMsg(weak_context1 && weak_context2, @"context 不能为空");
        CGContextRef contextArray[2] = {0};
        contextArray[0] = weak_context1;
        contextArray[1] = weak_context2;
        [DPDrawTrendImgTool handleContextArray:contextArray count:2 callBack:finished scale:data1.scale vertical:NO midLine:NO];
        CGContextRelease(weak_context1);
        CGContextRelease(weak_context2);
    });
}

+ (void)drawVerticalCombinationImageWithPriority:(long)priority Data1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 finish:(drawFinished)finished
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(priority, 0);

    __block __typeof(CGContextRef) weak_context1 = NULL;
    __block __typeof(CGContextRef) weak_context2 = NULL;
    dispatch_group_async(group, globalQueue, ^{
        DPLog(@"画图执行 3 ");
        DPAssertMsg(data1, @"data1 不能为空");
        weak_context1 = [data1 startDrawImgeContext];
    });
    
    dispatch_group_async(group, globalQueue, ^{
        DPLog(@"画图执行 4 ");
        DPAssertMsg(data2, @"data2 不能为空");
        weak_context2 = [data2 startDrawImgeContext];
        
    });
    
    dispatch_group_notify(group, globalQueue, ^{
        DPLog(@"group notify 2 执行");
        DPAssertMsg(weak_context1 && weak_context2, @"context 不能为空");
        CGContextRef contextArray[2] = {0};
        contextArray[0] = weak_context1;
        contextArray[1] = weak_context2;
        [DPDrawTrendImgTool handleContextArray:contextArray count:2 callBack:finished scale:data1.scale vertical:YES midLine:NO];
        CGContextRelease(weak_context1);
        CGContextRelease(weak_context2);
    });
    
    dispatch_group_enter(group);
    //    dispatch_cancel();
    //    dispatch_suspend()'
    
    dispatch_group_leave(group);
    //    dispatch_cancel(group);
    
}

+ (void)drawThreeCombineImgWithPriority:(long)priority data1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 data3:(DPDrawTrendImgData *)data3 finish:(drawFinished)finished
{
    [self pvt_drawThreeCombineImgWithPriority:priority data1:data1 data2:data2 data3:data3 finish:finished midLine:NO];
}
+ (void)drawThreeCombineImgMidLineWithPriority:(long)priority data1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 data3:(DPDrawTrendImgData *)data3 finish:(drawFinished)finished
{
    // 中间画条黑线
    [self pvt_drawThreeCombineImgWithPriority:priority data1:data1 data2:data2 data3:data3 finish:finished midLine:YES];
}
+ (void)pvt_drawThreeCombineImgWithPriority:(long)priority data1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 data3:(DPDrawTrendImgData *)data3 finish:(drawFinished)finished midLine:(BOOL)midLine
{
    __block __typeof(CGContextRef) weak_context1 = NULL;
    __block __typeof(CGContextRef) weak_context2 = NULL;
    __block __typeof(CGContextRef) weak_context3 = NULL;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(priority, 0);
    
    dispatch_group_async(group, globalQueue, ^{
        DPLog(@"画图执行 5 ");
        
        DPAssertMsg(data1, @"data1 不能为空");
        weak_context1 = [data1 startDrawImgeContext];
    });
    dispatch_group_async(group, globalQueue, ^{
        DPLog(@"画图执行 6 ");
        DPAssertMsg(data2, @"data2 不能为空");
        weak_context2 = [data2 startDrawImgeContext];
        
    });
    dispatch_group_async(group, globalQueue, ^{
        DPLog(@"画图执行 7 ");
        DPAssertMsg(data3, @"data3 不能为空");
        weak_context3 = [data3 startDrawImgeContext];
        
    });
    dispatch_group_notify(group, globalQueue, ^{
        DPLog(@"group notify 3 执行");
        DPAssertMsg(weak_context1 && weak_context2 && weak_context3, @"context 不能为空");
        CGContextRef contextArray[3] = {0};
        contextArray[0] = weak_context1;
        contextArray[1] = weak_context2;
        contextArray[2] = weak_context3;
        [DPDrawTrendImgTool handleContextArray:contextArray count:3 callBack:finished scale:data1.scale vertical:NO midLine:midLine];
        CGContextRelease(weak_context1);
        CGContextRelease(weak_context2);
        CGContextRelease(weak_context3);
    });
}

+ (void)drawFourCombineImgWithPriority:(long)priority data1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 data3:(DPDrawTrendImgData *)data3 data4:(DPDrawTrendImgData *)data4 finish:(drawFinished)finished{
    
    __block __typeof(CGContextRef) weak_context1 = NULL;
    __block __typeof(CGContextRef) weak_context2 = NULL;
    __block __typeof(CGContextRef) weak_context3 = NULL;
    __block __typeof(CGContextRef) weak_context4 = NULL;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(priority, 0);
    
    
    dispatch_group_async(group, globalQueue, ^{
        DPLog(@"画图执行 8 ");
        DPAssertMsg(data1, @"data1 不能为空");
        weak_context1 = [data1 startDrawImgeContext];
    });
    dispatch_group_async(group, globalQueue, ^{
        DPLog(@"画图执行 9 ");
        DPAssertMsg(data2, @"data2 不能为空");
        weak_context2 = [data2 startDrawImgeContext];
    });
    dispatch_group_async(group, globalQueue, ^{
        DPLog(@"画图执行 10 ");
        DPAssertMsg(data3, @"data3 不能为空");
        weak_context3 = [data3 startDrawImgeContext];
    });
    dispatch_group_async(group, globalQueue, ^{
        DPLog(@"画图执行 11 ");
        DPAssertMsg(data4, @"data4 不能为空");
        weak_context4 = [data4 startDrawImgeContext];
    });
    //    NSInteger waitRes = dispatch_group_wait(group, DISPATCH_TIME_FOREVER); // 等待group全部执行完毕
    //    DPLog(@"waitres 4= %d", waitRes);
    dispatch_group_notify(group, globalQueue, ^{
        DPLog(@"group notify 4 执行");
        DPAssertMsg(weak_context1 && weak_context2 && weak_context3 && weak_context4, @"context 不能为空");
        CGContextRef contextArray[4] = {0};
        contextArray[0] = weak_context1;
        contextArray[1] = weak_context2;
        contextArray[2] = weak_context3;
        contextArray[3] = weak_context4;
        [DPDrawTrendImgTool handleContextArray:contextArray count:4 callBack:finished scale:data1.scale vertical:NO midLine:NO];
        CGContextRelease(weak_context1);
        CGContextRelease(weak_context2);
        CGContextRelease(weak_context3);
        CGContextRelease(weak_context4);
    });
}
+ (void)handleContextArray:(CGContextRef *)ctxArray count:(int)count callBack:(drawFinished)finish scale:(CGFloat)scale vertical:(BOOL)vertical midLine:(BOOL)midLine;
{
    if (count <= 1) {
        return;
    }
    CGContextRef contextRes = NULL;
    if (count == 2) {
        CGContextRef context1 = ctxArray[0];
        CGContextRef context2 = ctxArray[1];
        if (vertical) {
            contextRes = TTKCreateVerticalBitmapContext(context1, context2);
        }else{
            contextRes = TTKCreateHorizontalBitmapContext(context1, context2);
        }
        if (!contextRes) return;
    }else if (count == 3){
        CGContextRef context1 = ctxArray[0];
        CGContextRef context2 = ctxArray[1];
        CGContextRef context3 = ctxArray[2];
        CGContextRef m_context = TTKCreateHorizontalBitmapContext(context1, context2);
        contextRes = TTKCreateVerticalBitmapContext(m_context, context3);
        if (!contextRes) return;
        if (midLine == YES) {
            int width = (int)CGBitmapContextGetWidth(context1);
            int height = (int)CGBitmapContextGetHeight(contextRes);
            CGContextSetLineWidth(contextRes, 1.0f * [UIScreen mainScreen].scale);
            CGContextSetStrokeColorWithColor(contextRes, UIColorFromRGB(0xDFD9D3).CGColor);
            CGContextMoveToPoint(contextRes, width, 0);
            CGContextAddLineToPoint(contextRes, width, height);
            CGContextDrawPath(contextRes, kCGPathStroke);
        }
        
        CGContextRelease(m_context);
    }else if (count == 4){
        CGContextRef context1 = ctxArray[0];
        CGContextRef context2 = ctxArray[1];
        CGContextRef context3 = ctxArray[2];
        CGContextRef context4 = ctxArray[3];
        CGContextRef u_context = TTKCreateHorizontalBitmapContext(context1, context2);
        CGContextRef d_context = TTKCreateHorizontalBitmapContext(context3, context4);
        if (!u_context || !d_context) return;
        contextRes = TTKCreateVerticalBitmapContext(u_context, d_context);
        if (!contextRes) return;
        CGContextRelease(u_context);
        CGContextRelease(d_context);
    }else{
        //        DPLog(@"4 个以上了");
        return;
    }
    DPAssertMsg(contextRes != NULL, @"context = null");
    CGImageRef imageref = CGBitmapContextCreateImage(contextRes);
    CGContextRelease(contextRes);
    UIImage *image = [UIImage imageWithCGImage:imageref scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(imageref);
    finish(image);
}
#pragma mark - 多线程方法（带标识）
+ (void)drawImageWithPriority:(long)priority data:(DPDrawTrendImgData *)data flag:(int)flag finish:(drawFinishedFlag)finished
{
    dispatch_async(dispatch_get_global_queue(priority, 0), ^{
        CGContextRef context = [data startDrawImgeContext];
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:data.scale orientation:UIImageOrientationUp];
        finished(image, flag);
        CGContextRelease(context);
        CGImageRelease(imageRef);
    });
}
+ (void)drawHorizontalCombinationImageWithPriority:(long)priority Data1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 flag:(int)flag finish:(drawFinishedFlag)finished
{
    __block __typeof(CGContextRef) weak_context1 = NULL;
    __block __typeof(CGContextRef) weak_context2 = NULL;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(priority, 0);
    
    dispatch_group_async(group, globalQueue, ^{
        DPLog(@"画图执行 1 ");
        DPAssertMsg(data1, @"data1 不能为空");
        weak_context1 = [data1 startDrawImgeContext];
    });
    
    dispatch_group_async(group, globalQueue, ^{
        DPLog(@"画图执行 2 ");
        DPAssertMsg(data2, @"data2 不能为空");
        weak_context2 = [data2 startDrawImgeContext];
        
    });
    //    NSInteger waitRes = dispatch_group_wait(group, DISPATCH_TIME_FOREVER); // 等待group全部执行完毕
    //    DPLog(@"waitres 1 = %d", waitRes);
    dispatch_group_notify(group, globalQueue, ^{
        DPLog(@"group notify 1 执行");
        DPAssertMsg(weak_context1 && weak_context2, @"context 不能为空");
        CGContextRef contextArray[2] = {0};
        contextArray[0] = weak_context1;
        contextArray[1] = weak_context2;
        [DPDrawTrendImgTool handleContextArray:contextArray count:2 callBack:finished scale:data1.scale vertical:NO midLine:NO flag:flag];
        CGContextRelease(weak_context1);
        CGContextRelease(weak_context2);
    });
}
//+ (void)drawVerticalCombinationImageHeighPriorityWithData1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 finish:(drawFinished)finished
//{
//    [self drawVerticalCombinationImageWithPriority:DISPATCH_QUEUE_PRIORITY_HIGH Data1:data1 data2:data2 finish:finished];
//}
//+ (void)drawVerticalCombinationImageWithData1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 finish:(drawFinished)finished
//{
//    [self drawVerticalCombinationImageWithPriority:DISPATCH_QUEUE_PRIORITY_DEFAULT Data1:data1 data2:data2 finish:finished];
//}
+ (void)drawVerticalCombinationImageWithPriority:(long)priority Data1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 flag:(int)flag finish:(drawFinishedFlag)finished
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(priority, 0);
//    if (priority == DISPATCH_QUEUE_PRIORITY_HIGH) {
//        globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
//    }else if (priority == DISPATCH_QUEUE_PRIORITY_DEFAULT){
//        globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    }
    __block __typeof(CGContextRef) weak_context1 = NULL;
    __block __typeof(CGContextRef) weak_context2 = NULL;
    dispatch_group_async(group, globalQueue, ^{
        DPLog(@"画图执行 3 ");
        DPAssertMsg(data1, @"data1 不能为空");
        weak_context1 = [data1 startDrawImgeContext];
    });
    
    dispatch_group_async(group, globalQueue, ^{
        DPLog(@"画图执行 4 ");
        DPAssertMsg(data2, @"data2 不能为空");
        weak_context2 = [data2 startDrawImgeContext];
        
    });
    //   NSInteger waitRes = dispatch_group_wait(group, DISPATCH_TIME_FOREVER); // 等待group全部执行完毕
    //    DPLog(@"waitres 2= %d", waitRes);
    
    dispatch_group_notify(group, globalQueue, ^{
        DPLog(@"group notify 2 执行");
        DPAssertMsg(weak_context1 && weak_context2, @"context 不能为空");
        CGContextRef contextArray[2] = {0};
        contextArray[0] = weak_context1;
        contextArray[1] = weak_context2;
        [DPDrawTrendImgTool handleContextArray:contextArray count:2 callBack:finished scale:data1.scale vertical:YES midLine:NO flag:flag];
        CGContextRelease(weak_context1);
        CGContextRelease(weak_context2);
    });
    
    dispatch_group_enter(group);
//    dispatch_cancel();
//    dispatch_suspend()'
    
    dispatch_group_leave(group);
//    dispatch_cancel(group);
    
}

+ (void)drawThreeCombineImgWithPriority:(long)priority data1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 data3:(DPDrawTrendImgData *)data3 flag:(int)flag finish:(drawFinishedFlag)finished
{
    [self pvt_drawThreeCombineImgWithPriority:priority data1:data1 data2:data2 data3:data3 finish:finished midLine:NO flag:flag];
}
+ (void)drawThreeCombineImgMidLineWithPriority:(long)priority data1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 data3:(DPDrawTrendImgData *)data3 flag:(int)flag finish:(drawFinishedFlag)finished
{
    // 中间画条黑线
    [self pvt_drawThreeCombineImgWithPriority:priority data1:data1 data2:data2 data3:data3 finish:finished midLine:YES flag:flag];
}
+ (void)pvt_drawThreeCombineImgWithPriority:(long)priority data1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 data3:(DPDrawTrendImgData *)data3 finish:(drawFinishedFlag)finished midLine:(BOOL)midLine flag:(int)flag
{
    __block __typeof(CGContextRef) weak_context1 = NULL;
    __block __typeof(CGContextRef) weak_context2 = NULL;
    __block __typeof(CGContextRef) weak_context3 = NULL;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(priority, 0);
    
    dispatch_group_async(group, globalQueue, ^{
        DPLog(@"画图执行 5 ");
        
        DPAssertMsg(data1, @"data1 不能为空");
        weak_context1 = [data1 startDrawImgeContext];
    });
    dispatch_group_async(group, globalQueue, ^{
        DPLog(@"画图执行 6 ");
        DPAssertMsg(data2, @"data2 不能为空");
        weak_context2 = [data2 startDrawImgeContext];
        
    });
    dispatch_group_async(group, globalQueue, ^{
        DPLog(@"画图执行 7 ");
        DPAssertMsg(data3, @"data3 不能为空");
        weak_context3 = [data3 startDrawImgeContext];
        
    });
    dispatch_group_notify(group, globalQueue, ^{
        DPLog(@"group notify 3 执行");
        DPAssertMsg(weak_context1 && weak_context2 && weak_context3, @"context 不能为空");
        CGContextRef contextArray[3] = {0};
        contextArray[0] = weak_context1;
        contextArray[1] = weak_context2;
        contextArray[2] = weak_context3;
        [DPDrawTrendImgTool handleContextArray:contextArray count:3 callBack:finished scale:data1.scale vertical:NO midLine:midLine flag:flag];
        CGContextRelease(weak_context1);
        CGContextRelease(weak_context2);
        CGContextRelease(weak_context3);
    });
}

+ (void)drawFourCombineImgWithPriority:(long)priority data1:(DPDrawTrendImgData *)data1 data2:(DPDrawTrendImgData *)data2 data3:(DPDrawTrendImgData *)data3 data4:(DPDrawTrendImgData *)data4 flag:(int)flag finish:(drawFinishedFlag)finished{
    
    __block __typeof(CGContextRef) weak_context1 = NULL;
    __block __typeof(CGContextRef) weak_context2 = NULL;
    __block __typeof(CGContextRef) weak_context3 = NULL;
    __block __typeof(CGContextRef) weak_context4 = NULL;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(priority, 0);
    
    
    dispatch_group_async(group, globalQueue, ^{
        DPLog(@"画图执行 8 ");
        DPAssertMsg(data1, @"data1 不能为空");
        weak_context1 = [data1 startDrawImgeContext];
    });
    dispatch_group_async(group, globalQueue, ^{
        DPLog(@"画图执行 9 ");
        DPAssertMsg(data2, @"data2 不能为空");
        weak_context2 = [data2 startDrawImgeContext];
    });
    dispatch_group_async(group, globalQueue, ^{
        DPLog(@"画图执行 10 ");
        DPAssertMsg(data3, @"data3 不能为空");
        weak_context3 = [data3 startDrawImgeContext];
    });
    dispatch_group_async(group, globalQueue, ^{
        DPLog(@"画图执行 11 ");
        DPAssertMsg(data4, @"data4 不能为空");
        weak_context4 = [data4 startDrawImgeContext];
    });
    //    NSInteger waitRes = dispatch_group_wait(group, DISPATCH_TIME_FOREVER); // 等待group全部执行完毕
    //    DPLog(@"waitres 4= %d", waitRes);
    dispatch_group_notify(group, globalQueue, ^{
        DPLog(@"group notify 4 执行");
        DPAssertMsg(weak_context1 && weak_context2 && weak_context3 && weak_context4, @"context 不能为空");
        CGContextRef contextArray[4] = {0};
        contextArray[0] = weak_context1;
        contextArray[1] = weak_context2;
        contextArray[2] = weak_context3;
        contextArray[3] = weak_context4;
        [DPDrawTrendImgTool handleContextArray:contextArray count:4 callBack:finished scale:data1.scale vertical:NO midLine:NO flag:flag];
        CGContextRelease(weak_context1);
        CGContextRelease(weak_context2);
        CGContextRelease(weak_context3);
        CGContextRelease(weak_context4);
    });
}
+ (void)handleContextArray:(CGContextRef *)ctxArray count:(int)count callBack:(drawFinishedFlag)finish scale:(CGFloat)scale vertical:(BOOL)vertical midLine:(BOOL)midLine flag:(int)flag;
{
    if (count <= 1) {
        return;
    }
    CGContextRef contextRes = NULL;
    if (count == 2) {
        CGContextRef context1 = ctxArray[0];
        CGContextRef context2 = ctxArray[1];
        if (vertical) {
            contextRes = TTKCreateVerticalBitmapContext(context1, context2);
        }else{
            contextRes = TTKCreateHorizontalBitmapContext(context1, context2);
        }
        if (!contextRes) return;
    }else if (count == 3){
        CGContextRef context1 = ctxArray[0];
        CGContextRef context2 = ctxArray[1];
        CGContextRef context3 = ctxArray[2];
        CGContextRef m_context = TTKCreateHorizontalBitmapContext(context1, context2);
        if (!m_context) return;
        contextRes = TTKCreateVerticalBitmapContext(m_context, context3);
        if (!contextRes) return;
        if (midLine == YES) {
            int width = (int)CGBitmapContextGetWidth(context1);
            int height = (int)CGBitmapContextGetHeight(contextRes);
            CGContextSetLineWidth(contextRes, 1.0f * [UIScreen mainScreen].scale);
            CGContextSetStrokeColorWithColor(contextRes, UIColorFromRGB(0xDFD9D3).CGColor);
            CGContextMoveToPoint(contextRes, width, 0);
            CGContextAddLineToPoint(contextRes, width, height);
            CGContextDrawPath(contextRes, kCGPathStroke);
        }
        
        CGContextRelease(m_context);
    }else if (count == 4){
        CGContextRef context1 = ctxArray[0];
        CGContextRef context2 = ctxArray[1];
        CGContextRef context3 = ctxArray[2];
        CGContextRef context4 = ctxArray[3];
        CGContextRef u_context = TTKCreateHorizontalBitmapContext(context1, context2);
        CGContextRef d_context = TTKCreateHorizontalBitmapContext(context3, context4);
        if (!u_context || !d_context) return;
        contextRes = TTKCreateVerticalBitmapContext(u_context, d_context);
        if (!contextRes) return;
        CGContextRelease(u_context);
        CGContextRelease(d_context);
    }else{
//        DPLog(@"4 个以上了");
        return;
    }
    DPAssertMsg(contextRes != NULL, @"context = null");
    CGImageRef imageref = CGBitmapContextCreateImage(contextRes);
    CGContextRelease(contextRes);
    UIImage *image = [UIImage imageWithCGImage:imageref scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(imageref);
    finish(image, flag);
}

@end