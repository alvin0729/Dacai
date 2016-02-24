//
//  DPLiveDataCenterViews.m
//  DacaiProject
//
//  Created by WUFAN on 14-9-1.
//  Copyright (c) 2014年 dacai. All rights reserved.
//

#import "DPLiveDataCenterViews.h"
#import <CoreText/CoreText.h>

NSString *g_homeName = @"";
NSString *g_awayName = @"";


@interface DPLiveOddsHeaderView () {
@private
    NSInteger _lineNum;    //行数
}
@property(nonatomic ,strong)UIColor *lineColor ;

@end

inline static UIColor *lineColor(UIColor *color) {

    if (color) {
        return color ;
    }
    return [UIColor colorWithRed:0.83 green:0.82 blue:0.8 alpha:1] ;
}

@implementation DPLiveOddsHeaderView

- (instancetype)initWithNoLayer {
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithTopLayer:(BOOL)yesOrno bottomLayer:(BOOL)bottom withHigh:(CGFloat)height withWidth:(CGFloat)width lineColor:(UIColor*)color {

    self = [super init];
    if (self) {
        
        self.lineColor = color ;
        if (yesOrno) {
            self.layer.borderWidth = 0.5;
            self.layer.borderColor = lineColor(self.lineColor).CGColor;
            self.backgroundColor = [UIColor dp_flatWhiteColor];
        } else {
            
            self.bottmoLayer = [CALayer layer];
            self.bottmoLayer.backgroundColor = lineColor(self.lineColor).CGColor;
            self.bottmoLayer.frame = CGRectMake(0, height - 0.5, width, 0.5);
            [self.layer addSublayer:self.bottmoLayer];
            self.bottmoLayer.hidden = !bottom ;
            
            CALayer *layer1 = ({
                CALayer *layer = [CALayer layer];
                layer.backgroundColor = lineColor(self.lineColor).CGColor;
                layer.frame = CGRectMake(0, 0, 0.5, height);
                
                layer;
            });
            CALayer *layer2 = ({
                CALayer *layer = [CALayer layer];
                layer.backgroundColor = lineColor(self.lineColor).CGColor;
                layer.frame = CGRectMake(width - 0.5, 0, 0.5, height);
                
                layer;
            });
            [self.layer addSublayer:layer1];
            [self.layer addSublayer:layer2];
        }
    }
    return self;
}

- (instancetype)initWithTopLayer:(BOOL)yesOrno bottomLayer:(BOOL)bottom withHigh:(CGFloat)height withWidth:(CGFloat)width {
    return [self initWithTopLayer:yesOrno bottomLayer:bottom withHigh:height withWidth:width lineColor:nil];;
}


- (instancetype)initWithTopLayer:(BOOL)yesOrno withHigh:(CGFloat)height withWidth:(CGFloat)width {
    return  [self initWithTopLayer:yesOrno bottomLayer:YES withHigh:height withWidth:width] ;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = lineColor(self.lineColor).CGColor;
        self.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    return self;
}

- (UILabel *)createLabel {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = self.numberOfLabLines > 1 ? self.numberOfLabLines : 1;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.textColor = self.textColors ? self.textColors : [UIColor dp_flatBlackColor];
    label.font = self.titleFont ? self.titleFont : [UIFont dp_systemFontOfSize:13];
    return label;
}

- (void)changeNumberOfLinesWithIndex:(NSInteger)index withNumber:(NSInteger)number {
    UILabel *lab = (UILabel *)[self viewWithTag:labelTag + index];
    lab.numberOfLines = number;
}
- (void)changeFontWithIndex:(NSInteger)index withFont:(UIFont *)font {
    UILabel *lab = (UILabel *)[self viewWithTag:labelTag + index];
    lab.font = font;
}

- (void)setTitles:(NSArray *)titleArray {
    for (int i = 0; i < titleArray.count; i++) {
        UILabel *lab = (UILabel *)[self viewWithTag:labelTag + i];
        id text = [titleArray objectAtIndex:i];
        if ([text isKindOfClass:[NSString class]]) {
            lab.text = text;
        } else {
            lab.attributedText = text;
        }
        //        NSString* str = [titleArray objectAtIndex:i] ;
        //        if ([str rangeOfString:@"font"].length != 0) {
        //            lab.htmlText = str ;
        //        }else
        //            lab.text = str ;
    }
}

- (void)settitleColors:(NSArray *)colorsArray {
    for (int i = 0; i < colorsArray.count; i++) {
        UILabel *lab = (UILabel *)[self viewWithTag:labelTag + i];
        lab.textColor = [colorsArray objectAtIndex:i];
    }
}
- (void)changeAllTitleColor:(UIColor *)color {
    for (int i = 0; i < _lineNum; i++) {
        UILabel *lab = (UILabel *)[self viewWithTag:labelTag + i];
        lab.textColor = color;
    }
}

- (void)setBgColors:(NSArray *)bgColorsArray {
    for (int i = 0; i < bgColorsArray.count; i++) {
        UILabel *lab = (UILabel *)[self viewWithTag:labelTag + i];
        lab.backgroundColor = [bgColorsArray objectAtIndex:i];
        [self sendSubviewToBack:lab];
    }
}

- (void)changeTextAlignWithIndex:(NSInteger)index withAlig:(NSTextAlignment)textAlignment {
    UILabel *lab = (UILabel *)[self viewWithTag:labelTag + index];
    lab.textAlignment = textAlignment ;
}


- (void)createHeaderWithWidthArray:(NSArray *)widthArray whithHigh:(CGFloat)hight withSegIndexArray:(NSArray *)indexArray {
    _lineNum = widthArray.count;
    float leftwidth = 0;
    for (int i = 0; i < widthArray.count; i++) {
        UILabel *lab = [self createLabel];
        lab.tag = labelTag + i;
        [self addSubview:lab];

        float widthLab = [[widthArray objectAtIndex:i] floatValue]*(kScreenWidth/320.0);

        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(@(leftwidth));
            make.bottom.equalTo(self);
            make.width.equalTo(@(widthLab));
        }];

        leftwidth += widthLab;

        if (i == widthArray.count - 1) {
            continue;
        }
        if ([[indexArray objectAtIndex:i] intValue] == 0) {
            continue;
        }

        UIView *lineView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = lineColor(self.lineColor);
            view;
        });

        [self addSubview:lineView];

        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.right.equalTo(lab.mas_right);
            make.bottom.equalTo(self);
            make.width.equalTo(@(0.5));
        }];
    }
}

- (void)createHeaderWithWidthArray:(NSArray *)widthArray whithHigh:(CGFloat)hight withSeg:(BOOL)yesOrNo {
    _lineNum = widthArray.count;
    float leftwidth = 0;
    for (int i = 0; i < widthArray.count; i++) {
        UILabel *lab = [self createLabel];
        lab.tag = labelTag + i;
        [self addSubview:lab];

        float widthLab = [[widthArray objectAtIndex:i] floatValue] *(kScreenWidth/320.0);

        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(@(leftwidth));
            make.bottom.equalTo(self);
            make.width.equalTo(@(widthLab));
        }];

        leftwidth += widthLab;
        if (!yesOrNo) {
            continue;
        }

        UIView *lineView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = lineColor(self.lineColor);
            view;
        });

        if (i == widthArray.count - 1) {
            continue;
        }
        [self addSubview:lineView];

        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.right.equalTo(lab.mas_right);
            make.bottom.equalTo(self);
            make.width.equalTo(@(0.5));
        }];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

@interface DPLCCompetitionStateCell (){
    NSArray *_widthArr ;
    CGFloat *_cellHigh ;
    NSArray *_segIndexArr ;
}

@end

@implementation DPLCCompetitionStateCell

-(DPLiveOddsHeaderView*)cellView{

    if (_cellView == nil) {
        _cellView = [[DPLiveOddsHeaderView alloc] initWithNoLayer];
        
        _cellView.titleFont = [UIFont dp_systemFontOfSize:12];
        _cellView.textColors = UIColorFromRGB(0x504f4d);
        
        if (_segIndexArr) {
            [_cellView createHeaderWithWidthArray:_widthArr whithHigh:30 withSegIndexArray:_segIndexArr];

        }else
            [_cellView createHeaderWithWidthArray:_widthArr whithHigh:30 withSeg:YES];

        
        NSMutableArray *colorarr = [[NSMutableArray alloc]initWithCapacity:_widthArr.count];
        for (int i=0; i<_widthArr.count; i++) {
            UIColor*color = [UIColor clearColor] ;
            if (_widthArr.count/2 == i) {
                color = UIColorFromRGB(0xfaf9f2);
            }
            
            [colorarr addObject:color];
        }
        [_cellView setBgColors:colorarr];
        [_cellView changeTextAlignWithIndex:0 withAlig:NSTextAlignmentLeft];
        [_cellView changeTextAlignWithIndex:(_widthArr.count-1) withAlig:NSTextAlignmentRight];
       _cellView.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    
    return _cellView ;
}

- (instancetype)initWithItemWithArray:(NSArray *)widthArray reuseIdentifier:(NSString *)reuseIdentifier withHigh:(CGFloat)height segIndexArray:(NSArray *)segIndexArr {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        _widthArr = widthArray ;
        _segIndexArr = segIndexArr ;
         [self.contentView addSubview:self.cellView];
        
        [self.cellView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5));
        }];
        
        UIView *homeView = [[UIView alloc] init];
        homeView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:homeView];
        [self.contentView sendSubviewToBack:homeView];
        
        UIView *awayView = [[UIView alloc] init];
        awayView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:awayView];
        [self.contentView sendSubviewToBack:awayView];
        
        [homeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(5);
            make.centerY.equalTo(self);
            make.right.equalTo(self.contentView.mas_centerX).offset(-([[widthArray objectAtIndex:(widthArray.count/2)]floatValue]/2));
        }];
        
        [awayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-5);
            make.centerY.equalTo(self);
            make.left.equalTo(self.contentView.mas_centerX).offset(([[widthArray objectAtIndex:(widthArray.count/2)]floatValue]/2));
        }];
        
        self.homeBar = [[UIView alloc] init];
        self.awayBar = [[UIView alloc] init];
        self.homeBar.backgroundColor = UIColorFromRGB(0xbedff6);
        self.awayBar.backgroundColor = UIColorFromRGB(0xf5e5bb);
        [self.cellView addSubview:self.homeBar];
        [self.cellView addSubview:self.awayBar];
        [self.cellView sendSubviewToBack:self.homeBar];
        [self.cellView sendSubviewToBack:self.awayBar];
        
        [self.homeBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(homeView);
            make.centerY.equalTo(self);
            make.height.equalTo(@15);
            make.width.equalTo(@0);
        }];
        [self.awayBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(awayView);
            make.centerY.equalTo(self);
            make.height.equalTo(@15);
            make.width.equalTo(@0);
        }];
        
        self.bottmoLayer = [CALayer layer];
        //        layer.backgroundColor = ( i == rowCount ) ? [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor : [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1].CGColor;
        self.bottmoLayer.frame = CGRectMake(5, height - 0.5, kScreenWidth - 2 * 5, 0.5);
        [self.contentView.layer addSublayer:self.bottmoLayer];
        
        CALayer *layer1 = ({
            CALayer *layer = [CALayer layer];
            layer.backgroundColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor;
            layer.frame = CGRectMake(5, 0, 0.5, height);
            
            layer;
        });
        CALayer *layer2 = ({
            CALayer *layer = [CALayer layer];
            layer.backgroundColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor;
            layer.frame = CGRectMake(kScreenWidth - 5 - 0.5, 0, 0.5, height);
            
            layer;
        });
        [self.contentView.layer addSublayer:layer1];
        [self.contentView.layer addSublayer:layer2];
    }
    
    return self;
}

@end


@implementation DPLiveCompetitionStateCell

- (instancetype)initWithItemWithArray:(NSArray *)widthArray reuseIdentifier:(NSString *)reuseIdentifier withHigh:(CGFloat)height {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.cellView = [[DPLiveOddsHeaderView alloc] initWithNoLayer];
        self.cellView.titleFont = [UIFont dp_systemFontOfSize:11];
        self.cellView.textColors = UIColorFromRGB(0x535353);

        [self.cellView createHeaderWithWidthArray:widthArray whithHigh:30 withSeg:NO];
        [self.cellView changeTextAlignWithIndex:1 withAlig:NSTextAlignmentLeft];
        [self.cellView changeTextAlignWithIndex:3 withAlig:NSTextAlignmentRight];

        [self.cellView setBgColors:[NSArray arrayWithObjects:[UIColor clearColor],[UIColor clearColor], UIColorFromRGB(0xf6f2ef),[UIColor clearColor], [UIColor clearColor], nil]];
        self.cellView.backgroundColor = [UIColor dp_flatWhiteColor];
        [self.contentView addSubview:self.cellView];

        [self.cellView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5));
        }];

        UIView *homeView = [[UIView alloc] init];
        homeView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:homeView];
        [self.contentView sendSubviewToBack:homeView];

        UIView *awayView = [[UIView alloc] init];
        awayView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:awayView];
        [self.contentView sendSubviewToBack:awayView];

        [homeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(@([[widthArray objectAtIndex:1] floatValue]));
        }];

        [awayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-20);
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(@([[widthArray objectAtIndex:1] floatValue]));
        }];

        self.homeBar = [[UIView alloc] init];
        self.awayBar = [[UIView alloc] init];
        self.homeBar.backgroundColor = UIColorFromRGB(0x83bff5);
        self.awayBar.backgroundColor = UIColorFromRGB(0xf89e9e);
        [self.cellView addSubview:self.homeBar];
        [self.cellView addSubview:self.awayBar];
        [self.cellView sendSubviewToBack:self.homeBar];
        [self.cellView sendSubviewToBack:self.awayBar];

        [self.homeBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(homeView);
            make.centerY.equalTo(self);
            make.height.equalTo(@15);
            make.width.equalTo(@0);
        }];
        [self.awayBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(awayView);
            make.centerY.equalTo(self);
            make.height.equalTo(@15);
            make.width.equalTo(@0);
        }];

        self.bottmoLayer = [CALayer layer];
        //        layer.backgroundColor = ( i == rowCount ) ? [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor : [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1].CGColor;
        self.bottmoLayer.frame = CGRectMake(5, height - 0.5, kScreenWidth - 2 * 5, 0.5);
        [self.contentView.layer addSublayer:self.bottmoLayer];

        CALayer *layer1 = ({
            CALayer *layer = [CALayer layer];
            layer.backgroundColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor;
            layer.frame = CGRectMake(5, 0, 0.5, height);

            layer;
        });
        CALayer *layer2 = ({
            CALayer *layer = [CALayer layer];
            layer.backgroundColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor;
            layer.frame = CGRectMake(kScreenWidth - 5 - 0.5, 0, 0.5, height);

            layer;
        });
        [self.contentView.layer addSublayer:layer1];
        [self.contentView.layer addSublayer:layer2];
    }

    return self;
}

@end

@implementation DPLiveDataCenterSectionHeaderView

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier {

    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self _initialize];
        
        [self.contentView addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-8);
        }];

    }
    
    return self ;

}
 
- (void)_initialize {
    self.contentView.backgroundColor = UIColorFromRGB(0xfaf9f2);
    self.backgroundView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xfaf9f2);
        view;
    });

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont dp_systemFontOfSize:15];
    _titleLabel.textColor = UIColorFromRGB(0x7e6b5a);
}

@end

@implementation DPLiveAnalysisViewCell

- (instancetype)initWithWidthArray:(NSArray *)widArray reuseIdentifier:(NSString *)reuseIdentifier withHight:(CGFloat)height {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.rootbgView = [[DPLiveOddsHeaderView alloc] initWithTopLayer:NO withHigh:height withWidth:kScreenWidth - 10];
        self.rootbgView.backgroundColor = [UIColor dp_flatWhiteColor];
        [self.rootbgView createHeaderWithWidthArray:widArray whithHigh:height withSeg:NO];
        [self.contentView addSubview:self.rootbgView];

        [self.rootbgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5));
        }];
    }
    return self;
}

@end

@implementation DPLiveNoDataCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self buildLayouyt];
    }

    return self;
}

- (void)buildLayouyt {
    _noDataImgView = [[DPImageLabel alloc] init];
    _noDataImgView.textColor = [UIColor colorWithRed:0.57 green:0.5 blue:0.34 alpha:1];
    _noDataImgView.text = @"暂无数据";
    _noDataImgView.backgroundColor = UIColorFromRGB(0xfaf9f2);

    [self.contentView addSubview:_noDataImgView];

    [_noDataImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 5, 0, 5));
    }];
}

@end

@interface DPRecentView () {
    NSInteger hInterval;
    NSInteger vInterval;
    NSArray *_colorsArrr;
    GameTypeId _gameType ;
}

@end

@implementation DPRecentView
@synthesize titleLabel = _titleLabel;

- (instancetype)initWithGameType:(GameTypeId)type {
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        hInterval = 20;
        vInterval = 17;
        _gameType = type ;
        if (type == GameTypeJcNone) {
            _colorsArrr = @[ UIColorFromRGB(0x2ab5f6), UIColorFromRGB(0x8cc447), UIColorFromRGB(0xff7e83) ];

        } else {
            _colorsArrr = @[ UIColorFromRGB(0x2ab5f6), UIColorFromRGB(0xff7e83) ];
            vInterval = 22;
        }

        [self addSubview:self.titleLabel];

        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self);
            make.height.equalTo(@15);
        }];
    }
    return self;
}

#define ZeroPoint CGPointMake(20, 110)

- (void)drawRect:(CGRect)rect {
    [self setClearsContextBeforeDrawing:YES];
    CGContextRef context = UIGraphicsGetCurrentContext();

    if (self.recentArray.count == 0) {
        
        UIImage *img = dp_SportLiveImage(@"foot_down.png");
        if (_gameType == GameTypeLcNone) {
            img = dp_SportLiveImage(@"basket_down.png");
            
        }

 
        CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
        rect.origin.x = self.bounds.size.width / 2 - img.size.width / 2;
        rect.origin.y = self.bounds.size.height / 2 - img.size.height / 2;

        [img drawInRect:rect];
        return;
    }

    //画背景线条------------------

    CGContextSetLineWidth(context, 1.0);    //主线宽度

    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0x969696).CGColor);
    CGContextSaveGState(context);

    int x = self.frame.size.width - 20;
    int y = 110;

    CGPoint bPoint = ZeroPoint;
    CGPoint ePoint = CGPointMake(x, y);

    CGContextMoveToPoint(context, bPoint.x, bPoint.y - vInterval);
    CGContextAddLineToPoint(context, bPoint.x, 25);

    CGContextMoveToPoint(context, bPoint.x, bPoint.y - vInterval);
    CGContextAddLineToPoint(context, ePoint.x, bPoint.y - vInterval);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);

    bPoint = CGPointMake(20, y - vInterval);
    ePoint = CGPointMake(x, y - vInterval);
    y -= vInterval;

    CGContextSetLineWidth(context, 0.5f);    //主线宽度
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xe4e4e4).CGColor);

    CGContextSaveGState(context);

    for (int i = 0; i < _colorsArrr.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        [view setCenter:CGPointMake(bPoint.x - 5, bPoint.y - vInterval)];

        [view setBackgroundColor:_colorsArrr[i]];

        [self addSubview:view];

        CGContextMoveToPoint(context, bPoint.x, bPoint.y - vInterval);
        CGContextAddLineToPoint(context, ePoint.x, ePoint.y - vInterval);

        bPoint = CGPointMake(20, y - vInterval);
        ePoint = CGPointMake(x, y - vInterval);

        y -= vInterval;
    }

    for (int i = 0; i < self.recentArray.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((i + 1) * hInterval + 20 - 2.5, ZeroPoint.y - vInterval - 1.5, 3, 3)];

        UIColor *color;
        if ([self.recentArray[i] integerValue] == -1) {
            color = _colorsArrr[0];
        } else if ([self.recentArray[i] integerValue] == 0) {
            color = _colorsArrr[1];
        } else
            color = [_colorsArrr lastObject];

        [view setBackgroundColor:color];
        [self addSubview:view];
    }
    CGContextStrokePath(context);
    CGContextRestoreGState(context);

    //    //画点线条------------------
    CGFloat pointLineWidth = 1.5f;
    CGContextSetLineWidth(context, pointLineWidth);    //主线宽度

    CGContextSetLineJoin(context, kCGLineJoinMiter);
    CGContextSetStrokeColorWithColor(context, [UIColor dp_flatRedColor].CGColor);
    CGContextSaveGState(context);

    //绘图
    NSInteger p1 = [[self.recentArray objectAtIndex:0] integerValue];
    CGContextMoveToPoint(context, 20 + hInterval - 2.5, ZeroPoint.y - vInterval * 3 - vInterval * p1);

    UILabel *labNear = [[UILabel alloc] init];
    labNear.text = @"近";
    labNear.backgroundColor = [UIColor clearColor];
    labNear.font = [UIFont dp_systemFontOfSize:11];
    labNear.frame = CGRectMake(0, 0, 15, vInterval);
    labNear.center = CGPointMake(20 + hInterval - 2.5, ZeroPoint.y - vInterval / 2 + 3);
    labNear.textAlignment = NSTextAlignmentCenter;
    labNear.textColor = UIColorFromRGB(0xA1A1A1);
    [self addSubview:labNear];

    UILabel *labFar = [[UILabel alloc] init];
    labFar.text = @"远";
    labFar.backgroundColor = [UIColor clearColor];
    labFar.font = [UIFont dp_systemFontOfSize:11];
    labFar.frame = CGRectMake(0, 0, 15, vInterval);
    labFar.center = CGPointMake(x - hInterval, ZeroPoint.y - vInterval / 2 + 3);

    labFar.textAlignment = NSTextAlignmentCenter;
    labFar.textColor = UIColorFromRGB(0xA1A1A1);
    [self addSubview:labFar];

    for (int i = 1; i < [self.recentArray count]; i++) {
        p1 = [[self.recentArray objectAtIndex:i] integerValue];
        CGPoint goPoint = CGPointMake(20 + hInterval * (i + 1) - 2.5, ZeroPoint.y - vInterval * 3 - vInterval * p1);
        CGContextAddLineToPoint(context, goPoint.x, goPoint.y);
        ;
    }
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"日本";
        _titleLabel.font = [UIFont dp_systemFontOfSize:12];
        _titleLabel.textColor = UIColorFromRGB(0x000000);
        _titleLabel.backgroundColor = [UIColor clearColor];
    }

    return _titleLabel;
}

@end

@interface DPAnalysicRecentCell () {
    GameTypeId _gameType;
}

@end
@implementation DPAnalysicRecentCell
@synthesize leftRecentView = _leftRecentView, rightRecentView = _rightRecentView;

- (id)initWithGameType:(GameTypeId)type reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        _gameType = type;
        self.backgroundColor =
        self.contentView.backgroundColor = [UIColor clearColor] ;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        backView.layer.borderWidth = 0.5;
        backView.layer.borderColor = UIColorFromRGB(0xededeb).CGColor;
        [self.contentView addSubview:backView];

        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(5);
            make.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-5);
        }];

        [self.contentView addSubview:self.leftRecentView];
        [self.contentView addSubview:self.rightRecentView];

        UIView *middelLine = [[UIView alloc] init];
        middelLine.backgroundColor = UIColorFromRGB(0xededeb);
        [self.contentView addSubview:middelLine];

        [self.leftRecentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(15);
            make.left.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView.mas_centerX).offset(-0.5);
            make.height.equalTo(@125);
        }];

        [middelLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView);
            make.width.equalTo(@1);
            make.bottom.equalTo(self.leftRecentView);

        }];

        [self.rightRecentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(middelLine.mas_right);
            make.top.equalTo(self.leftRecentView);
            make.right.equalTo(self.contentView).offset(-5);
            make.height.equalTo(@125);
        }];

        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = UIColorFromRGB(0xededeb);
        [self.contentView addSubview:bottomLine];

        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.leftRecentView.mas_bottom);
            make.left.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(-5);
            make.height.equalTo(@1);
        }];

        MTStringParser *_parser = [[MTStringParser alloc] init];
        [_parser setDefaultAttributes:({
                     MTStringAttributes *attr = [[MTStringAttributes alloc] init];
                     attr.alignment = NSTextAlignmentCenter;
                     attr.font = [UIFont dp_systemFontOfSize:11];
                     attr;
                 })];

        [_parser addStyleWithTagName:@"font12" font:[UIFont dp_systemFontOfSize:12]];
        [_parser addStyleWithTagName:@"win" color:UIColorFromRGB(0xff7e83)];
        [_parser addStyleWithTagName:@"tie" color:UIColorFromRGB(0x8cc447)];
        [_parser addStyleWithTagName:@"lose" color:UIColorFromRGB(0x2ab5f6)];

        UILabel *bottomLabel = [[UILabel alloc] init];
        bottomLabel.backgroundColor = [UIColor clearColor];
        if (type == GameTypeJcNone) {
            bottomLabel.attributedText = [_parser attributedStringFromMarkup:[NSString stringWithFormat:@"<win><font12>■</font12> 胜</win>   <tie><font12>■</font12> 平</tie>   <lose><font12>■</font12> 负</lose> "]];

        } else
            bottomLabel.attributedText = [_parser attributedStringFromMarkup:[NSString stringWithFormat:@"<win><font12>■</font12> 胜</win>   <lose><font12>■</font12> 负</lose> "]];

        [self.contentView addSubview:bottomLabel];

        [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(bottomLine.mas_bottom);
            make.height.equalTo(@30);
        }];
    }
    return self;
}

- (DPRecentView *)leftRecentView {
    if (_leftRecentView == nil) {
        _leftRecentView = [[DPRecentView alloc] initWithGameType:_gameType];
        _leftRecentView.backgroundColor = [UIColor clearColor];
    }

    return _leftRecentView;
}

- (DPRecentView *)rightRecentView {
    if (_rightRecentView == nil) {
        _rightRecentView = [[DPRecentView alloc] initWithGameType:_gameType];
        _rightRecentView.backgroundColor = [UIColor clearColor];
    }

    return _rightRecentView;
}

@end

@interface DPHistoryView () {
    NSArray *_colorArr;
    NSMutableArray *_labArray;
}

@end

@implementation DPHistoryView

- (instancetype)init {
    self = [super init];
    if (self) {
        _colorArr = @[ UIColorFromRGB(0x28b6f6), UIColorFromRGB(0x8cc34b), UIColorFromRGB(0xff7f7e) ];
        _labArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self setClearsContextBeforeDrawing:YES];

    for (UILabel *lab in _labArray) {
        [lab removeFromSuperview];
    }
    [_labArray removeAllObjects];

    CGContextRef context = UIGraphicsGetCurrentContext();

    float sum = 0.0;
    for (int i = 0; i < self.percentArray.count; ++i) {
        sum += [[self.percentArray objectAtIndex:i] floatValue];
    }
    if (sum == 0) {
        UIImage *img = dp_SportLiveImage(@"foot_left.png");
 
        CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
        rect.origin.x = self.bounds.size.width / 2 - img.size.width / 2;
        rect.origin.y = self.bounds.size.height / 2 - img.size.height / 2;

        [img drawInRect:rect];

        return;
    }
    float frac = 2.0 * M_PI / sum;

    int centerX = rect.size.width / 2.0;
    int centerY = rect.size.height / 2.0;
    int radius = (centerX > centerY ? centerY - 15 : centerX - 15);

    float startAngle = M_PI_2;
    float endAngle = M_PI_2;

    float startPoint = -M_PI_2, endPoint =-M_PI_2, xDesc = 0, yDesc = 0;
    CGPoint linePoint;
    for (int i = 0; i < self.percentArray.count; i++) {
        startAngle = endAngle;

        endAngle += [[self.percentArray objectAtIndex:i] floatValue] * frac;

        if (startAngle == endAngle) {
            continue;
        }

        [[_colorArr objectAtIndex:i] setFill];

        CGContextMoveToPoint(context, centerX, centerY);
        CGContextAddArc(context, centerX, centerY, radius, startAngle, endAngle, 0);
        CGContextClosePath(context);
        CGContextFillPath(context);

        startPoint = endPoint;
        endPoint -= [[self.percentArray objectAtIndex:i] floatValue] * frac;

        linePoint.x = centerX + cos((endPoint - startPoint) / 2.0 + startPoint) * radius;
        linePoint.y = centerY - sin((endPoint - startPoint) / 2.0 + startPoint) * radius;
        xDesc = cos((endPoint - startPoint) / 2.0 + startPoint) * radius >= 0 ? 1 : -1;
        yDesc = sin((endPoint - startPoint) / 2.0 + startPoint) * radius >= 0 ? -1 : 1;

        CGContextMoveToPoint(context, linePoint.x, linePoint.y);
        CGContextAddLineToPoint(context, linePoint.x + 5 * xDesc, linePoint.y + 5 * yDesc);
        CGContextAddLineToPoint(context, linePoint.x + 15 * xDesc, linePoint.y + 5 * yDesc);
        [[_colorArr objectAtIndex:i] setStroke];
        CGContextStrokePath(context);

        UILabel *lab = [[UILabel alloc] init];
        lab.textColor = _colorArr[i];
        lab.font = [UIFont dp_systemFontOfSize:12];
        lab.text = [NSString stringWithFormat:@"%@", self.titleArray[i]];
        lab.frame = CGRectMake(linePoint.x + 15 * xDesc + (xDesc >= 0 ? 0 : -80), linePoint.y + 5 * yDesc - 7.5, 80, 15);
        lab.backgroundColor = [UIColor clearColor];
        lab.textAlignment = xDesc >= 0 ? NSTextAlignmentLeft : NSTextAlignmentRight;
        [self addSubview:lab];

        [_labArray addObject:lab];
    }
}

@end

@interface DPAnalysisHistoryCell ()
@end

@implementation DPAnalysisHistoryCell
@synthesize historyView = _historyView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor =
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        backView.layer.borderWidth = 0.5;
        backView.layer.borderColor = UIColorFromRGB(0xededeb).CGColor;
        [self.contentView addSubview:backView];

        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(5);
            make.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-5);
        }];

        [self.contentView addSubview:self.historyView];
        [self.historyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(1);
            make.left.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(-5);
            //            make.height.equalTo(@128);
            make.bottom.equalTo(self.contentView).offset(-1);
        }];
    }
    return self;
}

- (DPHistoryView *)historyView {
    if (_historyView == nil) {
        _historyView = [[DPHistoryView alloc] init];
        _historyView.backgroundColor = [UIColor clearColor];
    }

    return _historyView;
}

@end

@implementation DPFutureView
@synthesize nameLabel = _nameLabel, timeLabel = _timeLabel, leftImgView = _leftImgView, rightImgView = _rightImgView,leftLabel = _leftLabel,rightLabel = _rightLabel, nodataView = _nodataView;
;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UILabel *vsLabel = [[UILabel alloc] init];
    vsLabel.backgroundColor = [UIColor clearColor];
    vsLabel.text = @"VS";
    vsLabel.font = [UIFont dp_systemFontOfSize:15];
    vsLabel.textColor = [UIColor dp_flatBlackColor];
    vsLabel.textAlignment = NSTextAlignmentCenter;

    [self addSubview:self.nameLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.leftImgView];
    [self addSubview:self.leftLabel];

    [self addSubview:vsLabel];
    [self addSubview:self.rightImgView];
    [self addSubview:self.rightLabel];


    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.centerX.equalTo(self);
        make.height.equalTo(@15);
    }];

    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
        make.centerX.equalTo(self);
        make.height.equalTo(@10);
    }];
    [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
        make.width.and.height.equalTo(@25) ;

    }];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leftImgView);
        make.top.equalTo(self.leftImgView.mas_bottom).offset(10);

    }];

    [vsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.leftImgView);

    }];
    

    [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
        make.width.and.height.equalTo(@25) ;


    }];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rightImgView);
        make.top.equalTo(self.rightImgView.mas_bottom).offset(10);
        
    }];


    [self addSubview:self.nodataView];
    [self.nodataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont dp_systemFontOfSize:12];
        _nameLabel.text = @"主队";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor dp_flatBlackColor];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont dp_systemFontOfSize:10];
        _timeLabel.text = @"2015-09-11 开赛";
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = UIColorFromRGB(0x666666);
    }
    return _timeLabel;
}

- (UIImageView *)leftImgView {
    if (_leftImgView == nil) {
        _leftImgView = [[UIImageView alloc] init];
         _leftImgView.image = dp_SportLiveImage(@"default.png");
         _leftImgView.backgroundColor = [UIColor clearColor] ;
        _leftImgView.contentMode = UIViewContentModeCenter ;
    }

    return _leftImgView;
}
- (UIImageView *)rightImgView {
    if (_rightImgView == nil) {
        _rightImgView = [[UIImageView alloc] init];
        _rightImgView.image = dp_SportLiveImage(@"default.png");
        _rightImgView.backgroundColor = [UIColor clearColor] ;
        _rightImgView.contentMode = UIViewContentModeCenter ;
    }
    
    return _rightImgView;
}

 - (UILabel *)leftLabel {
    if (_leftLabel == nil) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.backgroundColor = [UIColor clearColor];
        _leftLabel.font = [UIFont dp_systemFontOfSize:11];
        _leftLabel.text = @"主队";
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        _leftLabel.textColor = UIColorFromRGB(0x666666);
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if (_rightLabel == nil) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.backgroundColor = [UIColor clearColor];
        _rightLabel.font = [UIFont dp_systemFontOfSize:11];
        _rightLabel.text = @"客队";
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        _rightLabel.textColor = UIColorFromRGB(0x666666);
    }
    return _rightLabel;
}

- (UIImageView *)nodataView {
    if (_nodataView == nil) {
        _nodataView = [[UIImageView alloc] initWithImage:dp_SportLiveImage(@"foot_down.png")];
        _nodataView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        _nodataView.contentMode = UIViewContentModeCenter;
        _nodataView.hidden = YES;
    }

    return _nodataView;
}

@end

@interface DPAnalysisFutureCell ()

@end

@implementation DPAnalysisFutureCell
@synthesize leftView = _leftView, rightView = _rightView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    backView.layer.borderWidth = 0.5;
    backView.layer.borderColor = UIColorFromRGB(0xededeb).CGColor;
    [self.contentView addSubview:backView];

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-5);
    }];

    UIView *middleLine = [UIView dp_viewWithColor:UIColorFromRGB(0xEEEDE9)];

    [self.contentView addSubview:self.leftView];
    [self.contentView addSubview:middleLine];
    [self.contentView addSubview:self.rightView];

    [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.width.equalTo(@1);
        make.bottom.equalTo(self.contentView);
    }];

    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(5);
        make.right.equalTo(middleLine.mas_left);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];

    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(middleLine.mas_right);
        make.right.equalTo(self.contentView).offset(-5);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
}

- (DPFutureView *)leftView {
    if (_leftView == nil) {
        _leftView = [[DPFutureView alloc] init];
        _leftView.backgroundColor =[UIColor clearColor] ;
    }

    return _leftView;
}

- (DPFutureView *)rightView {
    if (_rightView == nil) {
        _rightView = [[DPFutureView alloc] init];
        _rightView.backgroundColor = [UIColor clearColor] ;
    }

    return _rightView;
}

@end

@implementation DPLCHistoryView {
    NSArray *_colorArray;
    NSArray *_scoreColor;
    NSMutableArray *_labArray;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _colorArray = @[ UIColorFromRGB(0xff7f7e), UIColorFromRGB(0x288ebe) ];
        _scoreColor = @[ UIColorFromRGB(0xff885c), UIColorFromRGB(0x4db7ad) ];
        _labArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self setClearsContextBeforeDrawing:YES];

    for (UILabel *lab in _labArray) {
        [lab removeFromSuperview];
    }
    [_labArray removeAllObjects];

    CGContextRef context = UIGraphicsGetCurrentContext();

    //    画内圆
    float sum = 0.0;
    for (int i = 0; i < self.percentArray.count; ++i) {
        sum += [[self.percentArray objectAtIndex:i] floatValue];
    }

    if (sum == 0) {
        
        UIImage *img = dp_SportLiveImage(@"basket_left.png");
         CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
        rect.origin.x = self.bounds.size.width / 2 - img.size.width / 2;
        rect.origin.y = self.bounds.size.height / 2 - img.size.height / 2;
        
        [img drawInRect:rect];

        return;
    }
    float frac = 2.0 * M_PI / sum;

    int centerX = rect.size.width / 2.0;
    int centerY = rect.size.height / 2.0;
    int radius = (centerX > centerY ? centerY - 30 : centerX - 30);

    float startAngle = M_PI_2;
    float endAngle = M_PI_2;

    for (int i = 0; i < self.percentArray.count; i++) {
        startAngle = endAngle;
        endAngle += [[self.percentArray objectAtIndex:i] floatValue] * frac;
        [[_colorArray objectAtIndex:i] setFill];

        CGContextMoveToPoint(context, centerX, centerY);
        CGContextAddArc(context, centerX, centerY, radius, startAngle, endAngle, 0);
        CGContextClosePath(context);
        CGContextFillPath(context);

        if (startAngle == endAngle || [self.percentArray[i] intValue] == 0) {
            continue;
        }
        CGRect labRect;
        if (i == 0) {
            if ([self.percentArray[i] intValue] == sum) {
                labRect = CGRectMake(centerX - 20, centerY - 15, 40, 30);
            } else if (endAngle < M_PI_2*3) {
                labRect = CGRectMake(centerX-35 , centerY + radius / 2 - 15, 40, 30);
            }  else {
                labRect = CGRectMake(centerX - 35, centerY - radius / 2 - 15, 40, 30);
            }
            UILabel *lab = [[UILabel alloc] init];
            lab.backgroundColor = [UIColor clearColor];
            lab.text = [NSString stringWithFormat:@"%@\n%d胜", self.teamNameArray[i], [self.percentArray[i] intValue]];
            lab.font = [UIFont dp_systemFontOfSize:10];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = [UIColor whiteColor];
            lab.frame = labRect;
            lab.numberOfLines = 0 ;

            [self addSubview:lab];
            [_labArray addObject:lab];

        } else {
            if ([self.percentArray[i] intValue] == sum) {
                labRect = CGRectMake(centerX - 20, centerY - 15, 40, 30);
            } else if (startAngle < M_PI_2*3) {
                labRect = CGRectMake(centerX-5 , centerY -radius / 2 - 15, 40, 30);
            } else {
                labRect = CGRectMake(centerX-5 , centerY + radius / 2 - 15, 40, 30);
            }
            UILabel *lab = [[UILabel alloc] init];
            lab.backgroundColor = [UIColor clearColor];
            lab.numberOfLines = 0 ;
            lab.text = [NSString stringWithFormat:@"%@\n%d胜", self.teamNameArray[i], [self.percentArray[i] intValue]];
            lab.font = [UIFont dp_systemFontOfSize:10];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = [UIColor whiteColor];
            lab.frame = labRect;
            [self addSubview:lab];
            [_labArray addObject:lab];
        }
    }

    //画外围圆圈
    
    if ([self.scoreArray[0]floatValue] +[self.scoreArray[1]floatValue] <=0) {
        return ;
    }
    startAngle = M_PI_2;
    endAngle = M_PI_2;

    
    frac = 2.0 * M_PI / ([self.scoreArray[0] floatValue] + [self.scoreArray[1] floatValue]);

    float startPoint = -M_PI_2, endPoint = -M_PI_2, xDesc = 0, yDesc = 0;
    CGPoint linePoint;

    for (int i = 0; i < self.scoreArray.count; i++) {
        startAngle = endAngle;
        endAngle += [[self.scoreArray objectAtIndex:i] floatValue] * frac;

        if (startAngle == endAngle) {
            continue;
        }
        CGContextSetLineWidth(context, 10);
        [_scoreColor[i] setStroke];
        CGContextSaveGState(context);
        CGContextAddArc(context, centerX, centerY, radius + 10, startAngle, endAngle, 0);

        CGContextStrokePath(context);

        CGContextRestoreGState(context);

        CGContextSetLineWidth(context, 1);
        [_scoreColor[i] setStroke];
        CGContextSaveGState(context);

        if (startAngle == endAngle) {
            continue;
        }

        startPoint = endPoint;
        endPoint -= [[self.scoreArray objectAtIndex:i] floatValue] * frac;

        linePoint.x = centerX + cos((endPoint - startPoint) / 2.0 + startPoint) * (radius + 16);
        linePoint.y = centerY - sin((endPoint - startPoint) / 2.0 + startPoint) * (radius + 16);
        xDesc = cos((endPoint - startPoint) / 2.0 + startPoint) * (radius + 16) >= 0 ? 1 : -1;
        yDesc = sin((endPoint - startPoint) / 2.0 + startPoint) * (radius + 16) >= 0 ? -1 : 1;

        CGContextMoveToPoint(context, linePoint.x, linePoint.y);
        CGContextAddLineToPoint(context, linePoint.x + 10 * xDesc, linePoint.y + 10 * yDesc);
        CGContextAddLineToPoint(context, linePoint.x + 25 * xDesc, linePoint.y + 10 * yDesc);

        UILabel *lab = [[UILabel alloc] init];
        lab.backgroundColor = [UIColor clearColor];
        lab.text = [NSString stringWithFormat:@"%@分%d场", i == 0 ? @"大" : @"小", [self.scoreArray[i] intValue]];
        lab.font = [UIFont dp_systemFontOfSize:12];
        lab.textAlignment = xDesc >= 0 ? NSTextAlignmentLeft : NSTextAlignmentRight;
        ;
        lab.textColor = _scoreColor[i];
        lab.frame = CGRectMake(linePoint.x + 25 * xDesc + (xDesc >= 0 ? 0 : -60), linePoint.y + 10 * yDesc - 10, 60, 20);
        [self addSubview:lab];

        CGContextStrokePath(context);
        CGContextRestoreGState(context);
    }
}

@end

@interface DPAnalysisLCHistoryCell ()
@end

@implementation DPAnalysisLCHistoryCell
@synthesize historyView = _historyView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        backView.layer.borderWidth = 0.5;
        backView.layer.borderColor = UIColorFromRGB(0xededeb).CGColor;
        [self.contentView addSubview:backView];

        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(5);
            make.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-5);
        }];

        [self.contentView addSubview:self.historyView];
        [self.historyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(5);
            make.left.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(-5);
//            make.height.equalTo(@140);
            make.bottom.equalTo(self.contentView).offset(-5);

        }];
    }
    return self;
}

- (DPLCHistoryView *)historyView {
    if (_historyView == nil) {
        _historyView = [[DPLCHistoryView alloc] init];
        _historyView.backgroundColor = [UIColor clearColor];
    }

    return _historyView;
}

@end

@interface DPLCPlotView () {
    NSArray *_colorArr;
}

@end

@implementation DPLCPlotView

- (instancetype)init {
    self = [super init];
    if (self) {
        _colorArr = @[  UIColorFromRGB(0xff8a66),UIColorFromRGB(0x4db7ad) ];
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    [self setClearsContextBeforeDrawing:YES];

    CGContextRef context = UIGraphicsGetCurrentContext();

    float sum = 0.0;
    for (int i = 0; i < self.scoreArray.count; ++i) {
        sum += [[self.scoreArray objectAtIndex:i] floatValue];
    }
    if (sum == 0) {
        UIImage *img = dp_SportLiveImage(@"basket_down.png");
        
        CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
        rect.origin.x = self.bounds.size.width / 2 - img.size.width / 2;
        rect.origin.y = self.bounds.size.height / 2 - img.size.height / 2;
        
        [img drawInRect:rect];

        return;
    }
    float frac = 2.0 * M_PI / sum;

    int centerX = rect.size.width / 2.0;
    int centerY = rect.size.height / 2.0;
    int radius = MIN(centerY, centerX);

    float startAngle = M_PI_2;
    float endAngle = M_PI_2;

    for (int i = 0; i < self.scoreArray.count; i++) {
        startAngle = endAngle;
        endAngle += [[self.scoreArray objectAtIndex:i] floatValue] * frac;
        [[_colorArr objectAtIndex:i] setFill];

        CGContextMoveToPoint(context, centerX, centerY);
        CGContextAddArc(context, centerX, centerY, radius, startAngle, endAngle, 0);
        CGContextClosePath(context);
        CGContextFillPath(context);

        MTStringParser *_parser = [[MTStringParser alloc] init];
        [_parser setDefaultAttributes:({
                     MTStringAttributes *attr = [[MTStringAttributes alloc] init];
                     attr.alignment = NSTextAlignmentCenter;
                     attr.font = [UIFont dp_systemFontOfSize:10];
                     attr.textColor = [UIColor dp_flatWhiteColor];
                     attr;
                 })];

        [_parser addStyleWithTagName:@"font12" font:[UIFont dp_systemFontOfSize:12]];

        if (endAngle == startAngle) {
            continue;
        }
        CGRect labRect;
        if (i == 0) {
            if ([self.scoreArray[i] intValue] == sum) {
                labRect = CGRectMake(centerX - 20, centerY - 15, 30, 30);

            } else if (endAngle < M_PI_2*3) {
                labRect = CGRectMake(centerX-30, centerY + radius / 2 - 15, 30, 30);
            } else {
                labRect = CGRectMake(centerX-30, centerY- radius / 2 - 15, 30, 30);
            }
            UILabel *lab = [[UILabel alloc] init];
            lab.backgroundColor = [UIColor clearColor];
            lab.attributedText = [_parser attributedStringFromMarkup:[NSString stringWithFormat:@"<font12>大分</font12>\n%d场 ", [self.scoreArray[i] intValue]]];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.numberOfLines = 0;
            lab.textColor = [UIColor whiteColor];
            lab.frame = labRect;
            [self addSubview:lab];
        } else {
            if ([self.scoreArray[i] intValue] == sum) {
                labRect = CGRectMake(centerX - 20, centerY - 15, 40, 30);

            } else if (startAngle < M_PI_2*3) {
                labRect = CGRectMake(centerX , centerY-radius / 2 - 15, 30, 30);
            } else {
                labRect = CGRectMake(centerX , centerY + radius / 2 - 15, 30, 30);
            }
            UILabel *lab = [[UILabel alloc] init];
            lab.backgroundColor = [UIColor clearColor];
            lab.numberOfLines = 0;
            lab.attributedText = [_parser attributedStringFromMarkup:[NSString stringWithFormat:@"<font12>小分</font12>\n%d场 ", [self.scoreArray[i] intValue]]];

            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = [UIColor whiteColor];
            lab.frame = labRect;
            [self addSubview:lab];
        }
    }
}

@end

@interface DPLCRecentCell ()
@end

@implementation DPLCRecentCell
@synthesize leftPlotView = _leftPlotView, rightPlotView = _rightPlotView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        backView.layer.borderWidth = 0.5;
        backView.layer.borderColor = UIColorFromRGB(0xededeb).CGColor;
        [self.contentView addSubview:backView];

        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(5);
            make.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-5);
        }];

        [self.contentView addSubview:self.leftPlotView];
        [self.contentView addSubview:self.rightPlotView];

        UIView *middelLine = [[UIView alloc] init];
        middelLine.backgroundColor = UIColorFromRGB(0xededeb);
        [self.contentView addSubview:middelLine];

        [self.leftPlotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.left.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView.mas_centerX).offset(-0.5);
            make.height.equalTo(@80);
        }];

        [middelLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView);
            make.width.equalTo(@1);
            make.bottom.equalTo(self.contentView);

        }];

        [self.rightPlotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(middelLine.mas_right);
            make.top.equalTo(self.leftPlotView);
            make.right.equalTo(self.contentView).offset(-5);
            make.height.equalTo(@80);
        }];
    }
    return self;
}

- (DPLCPlotView *)leftPlotView {
    if (_leftPlotView == nil) {
        _leftPlotView = [[DPLCPlotView alloc] init];
        _leftPlotView.backgroundColor = [UIColor clearColor];
    }

    return _leftPlotView;
}

- (DPLCPlotView *)rightPlotView {
    if (_rightPlotView == nil) {
        _rightPlotView = [[DPLCPlotView alloc] init];
        _rightPlotView.backgroundColor = [UIColor clearColor];
    }

    return _rightPlotView;
}

@end
