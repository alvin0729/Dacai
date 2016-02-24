//
//  DPAlterViewController.m
//  Jackpot
//
//  Created by Ray on 15/7/21.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPAlterViewController.h"

#define kCellHeight 28
#define kPointHeight 45

@interface DPPointView : UIView
{
    NSString *_pointStr ;
    NSString *_timeStr ;
    UIImageView *_redRightView ;
    UIView *_bgView ;
    CALayer *_imageLayer ;
}

@property(readonly,nonatomic)UIImageView *redRightView ;
@property(readonly,nonatomic)UIView *bgView ;
@property(readonly,nonatomic)CALayer *imageLayer ;

- (instancetype)initWithPoint:(NSString*)point time:(NSString*)timerStr ;
-(void)startAnimtion ;

@end

@implementation DPPointView

- (instancetype)initWithPoint:(NSString*)point time:(NSString*)timerStr
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _pointStr = point ;
        _timeStr = timerStr ;
        [self creteCommomView];
        
     }
    return self;
}
-(void)startAnimtion {

    UIBezierPath *path =  [UIBezierPath bezierPath] ;
    path.lineJoinStyle = kCGLineCapRound;
    path.lineCapStyle = kCGLineCapRound ;
    [path moveToPoint:CGPointMake(kPointHeight-1, kPointHeight-1) ];
    [path addLineToPoint:CGPointMake(1, kPointHeight-1)];
    [path addLineToPoint:CGPointMake(1, 1)];
    [path addLineToPoint:CGPointMake(kPointHeight-1, 1)];
     [path closePath];
    
  
    CAShapeLayer *progressLayer = [CAShapeLayer layer] ;
    progressLayer.strokeColor = [UIColor dp_flatRedColor].CGColor ;
    progressLayer.fillColor = [UIColor clearColor].CGColor ;
    progressLayer.lineWidth = 2 ;
    progressLayer.lineJoin = kCALineJoinRound ;
    progressLayer.lineCap = kCALineCapRound ;
    progressLayer.path =path.CGPath ;
     progressLayer.anchorPoint = CGPointMake(0.5, 45.0/65.0) ;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"] ;
     animation.fromValue =  [NSNumber numberWithInt:0] ;
    animation.toValue =  [NSNumber numberWithInt:1] ;
    animation.duration = 2;
    animation.delegate = self ;
    animation.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [progressLayer addAnimation:animation forKey:@"Progress"];
 
    [self.layer addSublayer:progressLayer];
    
    CABasicAnimation *imgAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"] ;
     imgAnimation.toValue = [NSNumber numberWithFloat:(M_PI*2)] ;
    imgAnimation.timingFunction  = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear] ;
    imgAnimation.duration =  2;
    imgAnimation.repeatCount = 1 ;
    imgAnimation.removedOnCompletion = YES ;
    
    [self.imageLayer addAnimation:imgAnimation forKey:@"Rattion"];
 
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{

    CABasicAnimation *animation = (CABasicAnimation*)anim ;
    if (flag && [animation.keyPath isEqualToString:@"strokeEnd"]) {
        self.redRightView.hidden = NO ;
        [self bringSubviewToFront:self.redRightView];
    }
    
}

-(void)creteCommomView {
    
    
    [self addSubview:self.bgView];
     [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 20, 0)) ;
    }];
    
    UIImageView *imgView = [[UIImageView alloc]initWithImage:dp_GropSystemResizeImage(@"stone.png")];
    imgView.contentMode = UIViewContentModeCenter ;
    imgView.backgroundColor = [UIColor clearColor] ;
    [self addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView) ;
    }];


    
    [self addSubview:self.redRightView];
    [self.redRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView).offset(2) ;
        make.right.equalTo(self.bgView).offset(5) ;
        make.width.equalTo(@16) ;
        make.height.equalTo(@16) ;
    }];
    
    UILabel *pointLabel = [DPAlterViewController createLabelWithText:_pointStr color:UIColorFromRGB(0xd46413) font:[UIFont dp_systemFontOfSize:18]] ;
    [self addSubview:pointLabel];
    [pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView) ;
    }];

      [self.bgView.layer addSublayer:self.imageLayer];

    
    
    UILabel *timeLabel = [DPAlterViewController createLabelWithText:_timeStr color:UIColorFromRGB(0xc6926c) font:[UIFont dp_systemFontOfSize:10]] ;
    timeLabel.backgroundColor = [UIColor clearColor] ;
    [self addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self) ;
        make.centerX.equalTo(self) ;
    }] ;
    
}

-(UIImageView*)redRightView{

    if (_redRightView == nil) {
        _redRightView  = [[UIImageView alloc]initWithImage:dp_GropSystemResizeImage(@"right_img.png")];
        _redRightView.backgroundColor = [UIColor clearColor] ;
        _redRightView.contentMode = UIViewContentModeCenter ;
        _redRightView.hidden = YES ;
    }
    
    return _redRightView ;
}

-(UIView *)bgView{
    if (_bgView == nil) {
        
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = UIColorFromRGB(0xF67B31) ;
         _bgView.layer.borderColor = [UIColor clearColor].CGColor ;
        _bgView.layer.borderWidth = 2 ;
        _bgView.layer.cornerRadius = 2 ;
        _bgView.clipsToBounds = YES ;
    }
    
    return _bgView ;
}

-(CALayer*)imageLayer{

    if (_imageLayer == nil) {
        _imageLayer =[CALayer layer];
//        _imageLayer.frame = CGRectMake(2, 2, 41, 41);
        _imageLayer.frame = CGRectMake(-2, -2, 60, 60);

        _imageLayer.cornerRadius =2.0;
        _imageLayer.contents =(id)dp_GropSystemResizeImage(@"bg_light.png").CGImage;
        _imageLayer.masksToBounds =YES;

    }
    
    return _imageLayer ;
}


@end




@interface DPAlterViewController ()<UITextFieldDelegate>{


    UIView *_backgroundView ;
    
    NSArray *_titlesArray ;
    
    AlterType _alterType ;
    NSMutableArray *_pointViewArray ; //存放签到视图

}
/**
 *  上次选中的银行cell
 */
@property (nonatomic, strong)DPUAObject *lastBankObject;
/**
 *  银行表
 */
@property (nonatomic, strong)UITableView *bankTable;
/**
 *
 */
@property (nonatomic, strong)UITextField *password;
@end

static inline  NSMutableAttributedString *TTAttributeStr(  NSString *basStr ,NSString *resultStr){
    NSString *base = [NSString stringWithFormat:@"%@ %@",basStr,resultStr] ;

    NSMutableAttributedString *attributeString = [[NSMutableAttributedString
                                                   alloc]initWithString:base];
    [attributeString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x757676) range:NSMakeRange(0, base.length) ];
    [attributeString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xD75652) range:[base rangeOfString:resultStr options:NSBackwardsSearch]] ;
    
    return attributeString ;
    
    
}


@implementation DPAlterViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    for (int i=0; i<self.registerTime; i++) {
        DPPointView *view = [_pointViewArray objectAtIndex:i] ;
        
         if (i<self.registerTime-1 || !self.checkIn) {
            view.bgView.layer.borderColor  = [UIColor dp_flatRedColor].CGColor ;
            view.redRightView.hidden = NO ;
        }else
            [view startAnimtion];
    }
    
    
}


- (instancetype)initWithAlterType:(AlterType)type
{
    self = [super init];
    if (self) {
        _alterType = type ;
    }
    return self;
}


#pragma mark- 创建任务升级后的弹出框
-(void)createPromoteView{
    
    UIImageView *imageView= [[UIImageView alloc]initWithImage:dp_GropSystemResizeImage(@"upSuccess.png")];
    imageView.contentMode = UIViewContentModeCenter;
     [_backgroundView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backgroundView).offset(10) ;
        make.centerX.equalTo(self.view) ;
        make.width.equalTo(@80) ;
        make.height.equalTo(@80) ;
    }];
    
    NSString *congratulationTitle = [NSString stringWithFormat:@" 恭喜您,升级到LV%d！",self.award.newLevel];
     UILabel *congratulationLabel = [[self class] createLabelWithText:congratulationTitle color:UIColorFromRGB(0xFB0C28) font:[UIFont dp_systemFontOfSize:22]] ;
    congratulationLabel.backgroundColor =  UIColorFromRGB(0xF5F0EC) ;
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = UIColorFromRGB(0xFB0C28) ;
    
    UILabel *growLabel =[ [self class] createLabelWithText:@"升级特权" color:UIColorFromRGB(0x767676) font:[UIFont dp_systemFontOfSize:14]] ;
    
    
    [_backgroundView addSubview:lineView];
     [_backgroundView addSubview:congratulationLabel];
    [_backgroundView addSubview:growLabel];
    
    [congratulationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(10) ;
        make.centerX.equalTo(_backgroundView) ;
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backgroundView) ;
        make.right.equalTo(_backgroundView) ;
        make.centerY.equalTo(congratulationLabel) ;
        make.height.equalTo(@1) ;
    }];
    [growLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(congratulationLabel.mas_bottom).offset(10) ;
        make.centerX.equalTo(_backgroundView) ;
    }];
    
    [self createChatViewWithTextArray:self.award.privilegeArray  topView:growLabel];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.backgroundColor =  UIColorFromRGB(0xDA4F4F) ;
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter ;
    [btn addTarget:self action:@selector(pvt_dismiss:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 7 ;
    btn.clipsToBounds = YES ;
    btn.titleLabel.font = [UIFont dp_systemFontOfSize:20] ;
    [_backgroundView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_backgroundView).offset(-20) ;
        make.left.equalTo(_backgroundView).offset(20) ;
        make.right.equalTo(_backgroundView).offset(-20) ;
    }];
    
    
    
}




-(void)createChatViewWithTextArray:(NSArray *)titleArray topView:(UIView*)topView{

    UIView *contentView = [[UIView alloc]init];
    contentView.layer.borderColor = UIColorFromRGB(0xd7d6d6).CGColor ;
    contentView.layer.borderWidth = 0.5 ;
    contentView.backgroundColor  = UIColorFromRGB(0xFFFFFF) ;
    [_backgroundView addSubview:contentView];
    
    CGFloat contentHeight = (kCellHeight+0.5)*(titleArray.count%2+titleArray.count/2) - 0.5 ;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(5) ;
        make.left.equalTo(_backgroundView).offset(20) ;
        make.right.equalTo(_backgroundView).offset(-20) ;
        make.height.equalTo(@(contentHeight)) ;
    }];
    
    
    UIView *lastBaseView ;
    for (int i=0;i<titleArray.count ; i++ ) {
        UILabel *lab = [self createChatLabel:titleArray[i]] ;
        [contentView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i<2) {
                make.top.equalTo(contentView) ;
             }else
                 make.top.equalTo(lastBaseView.mas_bottom) ;

            if (i%2 == 0) {
                make.left.equalTo(contentView) ;
             }else
                 make.right.equalTo(contentView) ;
            
            make.height.equalTo(@(kCellHeight)) ;
            make.width.equalTo(contentView).multipliedBy(0.5) ;
        }];
        
        if (i%2 != 0 && i%2+i/2 < titleArray.count%2+titleArray.count/2 ) {
            UIView *line = [self createLineView] ;
            [contentView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lab.mas_bottom) ;
                make.left.equalTo(contentView) ;
                make.right.equalTo(contentView) ;
                make.height.equalTo(@0.5) ;
            }];
                lastBaseView = line ;
          }
        
    }
    
    
    UIView *middleVLine = [[UIView alloc]init];
    middleVLine.backgroundColor = UIColorFromRGB(0xd7d6d6) ;
    [contentView addSubview:middleVLine];
    [middleVLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView) ;
        make.width.equalTo(@0.5) ;
        make.top.equalTo(contentView) ;
        make.bottom.equalTo(contentView) ;
    }];

  
}

-(UILabel*)createChatLabel:(NSString*)title{

    UILabel *label = [[self class] createLabelWithText:title color:UIColorFromRGB(0x888888) font:[UIFont dp_systemFontOfSize:14]] ;
    return label ;
}

-(UIView *)createLineView{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = UIColorFromRGB(0xE6E5E3) ;
    return view ;
}


#pragma  mark- 创建任务领取成功弹框
-(void)createSuccessView{

    
    UIImageView *imageView= [[UIImageView alloc]initWithImage:dp_GropSystemResizeImage(@"getSuccess.png")];
    imageView.contentMode = UIViewContentModeCenter;
    [_backgroundView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backgroundView).offset(27) ;
        make.centerX.equalTo(self.view) ;
        make.width.equalTo(@64) ;
        make.height.equalTo(@64) ;
    }];
    
    UILabel *successLabel = [[self class] createLabelWithText:@"领取成功" color:UIColorFromRGB(0x0C780F) font:[UIFont dp_systemFontOfSize:22]] ;
    UILabel *growLabel =[ [self class] createLabelWithText:@"成长值" color:UIColorFromRGB(0x969694) font:[UIFont dp_systemFontOfSize:14]] ;
    UILabel *pointLabel= [ [self class] createLabelWithText:@"积分" color:UIColorFromRGB(0x969694) font:[UIFont dp_systemFontOfSize:14]] ;
    NSString *growup = [NSString stringWithFormat:@"+%d",self.award.growup];
    NSString *credit = [NSString stringWithFormat:@"+%d",self.award.credit];
    growLabel.attributedText = TTAttributeStr(@"成长值：", growup) ;
    pointLabel.attributedText = TTAttributeStr(@"积   分：",credit) ;
    
    
    [_backgroundView addSubview:successLabel];
    [_backgroundView addSubview:growLabel];
     [_backgroundView addSubview:pointLabel];
    
    [successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(18) ;
        make.centerX.equalTo(_backgroundView) ;
    }];
    [growLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(successLabel.mas_bottom).offset(10) ;
        make.centerX.equalTo(_backgroundView) ;
    }];
    
    [pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(growLabel.mas_bottom).offset(5) ;
        make.centerX.equalTo(_backgroundView) ;
    }];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.backgroundColor =  UIColorFromRGB(0xDA4F4F) ;
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter ;
    [btn addTarget:self action:@selector(pvt_dismiss:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 7 ;
    btn.clipsToBounds = YES ;
    btn.titleLabel.font = [UIFont dp_systemFontOfSize:18] ;
    [_backgroundView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(36);
        make.bottom.equalTo(_backgroundView).offset(-20) ;
        make.left.equalTo(_backgroundView).offset(20) ;
        make.right.equalTo(_backgroundView).offset(-20) ;
    }];
 
    
}

+(UILabel *)createLabelWithText:(NSString*)text color:(UIColor*)color font:(UIFont*)font{
    
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor] ;
    label.textColor = color ;
    label.text = text ;
    label.font = font ;
    label.textAlignment = NSTextAlignmentCenter ;
    return label ;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.password resignFirstResponder];
    [self.passwordView.passwordText resignFirstResponder];
    [self.view endEditing:YES];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.password becomeFirstResponder];
    [self.passwordView.passwordText becomeFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor clearColor]];

    _backgroundView = [[UIView alloc]init];
    _backgroundView.backgroundColor = UIColorFromRGB(0xF5F0EC) ;
    _backgroundView.layer.cornerRadius = 10 ;
    _backgroundView.clipsToBounds = YES ;
    
    [self.view addSubview:_backgroundView];
    
    CGFloat backHeight = 0;
    
    switch (_alterType) {
        case AlterTypePoint:{
        
            backHeight = kScreenWidth - 45 ;
            [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.view) ;
                 make.width.equalTo(@(kScreenWidth-60)) ;
                make.height.equalTo(@(backHeight)) ;
            }];
            [self createPointView] ;

        }break ;
        case AlterTypeSuccess:
        {
            backHeight = kScreenWidth - 60 ;
            [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.view) ;
                make.width.mas_equalTo(256) ;
                make.height.mas_equalTo(256) ;
            }];

            [self createSuccessView];
        
        }
            break;
        case AlterTypePromote:{
        
            _titlesArray =  @[@"返点3%",@"购彩优惠2%",@"比分直播", @"短信通知"  ] ;
            
            backHeight = kScreenWidth-85+(_titlesArray.count/2+_titlesArray.count%2)*(kCellHeight+0.5)-0.5 ;
            [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.view) ;
                make.width.equalTo(@(kScreenWidth-60)) ;
                make.height.equalTo(@(backHeight)) ;
            }];
            [self createPromoteView];

        }
            break;
        case AlterTypeService:{
            
            [self creatServiceAlter];
     
        }
            break;
        case AlterTypeSet:{
            
            [self creatUserIconSet];
            
        }
            break;
        case AlterTypeLoginSucce:{
            [self createLoginSuccess];
        }
            break;
        case AlterTypeBankChose:{
            [self createBankChoseView];
        }
            break;
        case AlterTypeOpenBetSuccess:{
            [self createOpenBetSuccessView];
        }
            break;
        case AlterTypeCancelledBetSuccess:{
            [self createCancelAccount];
        }
            break;
        case AlterTypeBackForNoPay:{
            [self createBackForNoPay];
        }
            break;
        case AlterTypePayPassowrd:{
            [self createPasswordView];
        }
            break;
        case AlterTypeDLTNumChange:{
            [self createDLTNumChangeView];
        }
            break;
        case AlterTypeDLTNumStop:{
            [self createDLTNumStopView];
        }
            break;
        case AlterTypeDLTNumOver:{
            [self createDLTNumOverView];
        }
            break;
        case AlterTypeJcUnGetNoBuy:{
            [self createJcUnGetNoView];
        }
            break;
        case AlterTypeJcUnGetBuy:{
            [self createJcUnGetView];
        }
            break;
        case AlterTypeJcStop:{
            [self createJcStopView];
        }
            break;
        case AlterTypeStopChase:{
            [self createStopChase];
        }
            break;
        default:
            break;
    }
    
    /*    AlterTypeDLTNumChange,//大乐透期号切换
     AlterTypeDLTNumStop,//大乐透订单遇到当前期截止
     AlterTypeDLTNumOver,//进入大乐透中转页面停售弹窗
     AlterTypeJcUnGetNoBuy,   //竞彩所有玩法投注/中转页面夜间不出票弹窗
     AlterTypeJcUnGetBuy,   //竞彩订单确认页面夜间不出票弹窗
     AlterTypeJcStop,   //竞彩停售玩法投注页面停售弹窗*/

}

-(void)pvt_dismiss:(UIButton *)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.fullBtnTapped) {
        self.fullBtnTapped(btn);
    }
}


#pragma mark- 创建签到弹窗
-(void)createPointView{

    _pointViewArray = [[NSMutableArray alloc]initWithCapacity:7];
    
    UIImageView *imageView= [[UIImageView alloc]initWithImage:dp_GropSystemResizeImage(@"pre_img.png")];
     imageView.contentMode = UIViewContentModeCenter;
    [self.view  addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backgroundView).offset(-28) ;
        make.centerX.equalTo(self.view) ;
        make.width.equalTo(_backgroundView) ;
        make.height.equalTo(@60) ;
    }];
    
    NSString *title = [NSString stringWithFormat:@"连续签到%zd天",self.checkIn?self.checkIn.runningDays:self.registerTime];
    UILabel *_titleLabel = [[self class] createLabelWithText:title color:UIColorFromRGB(0xc6926c) font:[UIFont dp_systemFontOfSize:16]] ;
    _titleLabel.backgroundColor = UIColorFromRGB(0xF5F0EC) ;
    
    [_backgroundView addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(5) ;
        make.centerX.equalTo(_backgroundView) ;
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = UIColorFromRGB(0xc6926c) ;
    [_backgroundView addSubview:lineView];
    [_backgroundView sendSubviewToBack:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backgroundView).offset(15) ;
        make.right.equalTo(_backgroundView).offset(-15) ;
        make.centerY.equalTo(_titleLabel);
        make.height.equalTo(@0.5) ;
    }];
    
    
     UIView *lastView  ;
    CGFloat margin = (kScreenWidth - 92 - kPointHeight*4)/3;
    for (int i=0; i<7; i++) {
        DPPointView *pointView =[[ DPPointView alloc]initWithPoint:[NSString stringWithFormat:@"%d",(i+1)*10] time:[NSString stringWithFormat:@"%d%@",i+1,i>5?@"天及以上":@"天"]];
        [_backgroundView addSubview:pointView];
        [pointView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i<4) {
                make.top.equalTo(_titleLabel.mas_bottom).offset(10) ;
                make.left.equalTo(_backgroundView).offset(16+(margin+kPointHeight)*i) ;
             }else{
                make.top.equalTo(_titleLabel.mas_bottom).offset(80) ;
                 make.centerX.equalTo(_backgroundView.mas_centerX).offset((margin+kPointHeight)*(i-5)) ;
            }
            
            make.width.equalTo(@kPointHeight) ;
            make.height.equalTo(@65) ;
        }];
        
         lastView = pointView ;
        [_pointViewArray addObject:pointView];

    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    if(self.checkIn){
        [btn setTitle:@"确定" forState:UIControlStateNormal];
    }else{
        [btn setTitle:@"已签到" forState:UIControlStateNormal];
    }
  
    btn.backgroundColor =  UIColorFromRGB(0xDA4F4F) ;
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter ;
    [btn addTarget:self action:@selector(pvt_dismiss:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 7 ;
    btn.clipsToBounds = YES ;
    btn.titleLabel.font = [UIFont dp_systemFontOfSize:20] ;
    [_backgroundView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_backgroundView).offset(-20) ;
        make.left.equalTo(_backgroundView).offset(20) ;
        make.right.equalTo(_backgroundView).offset(-20) ;
    }];



}

#pragma mark---------创建客服弹筐
- (void)creatServiceAlter{
    UIView *alterView = [[UIView alloc]init];
    alterView.backgroundColor = [UIColor dp_flatBackgroundColor];
    alterView.layer.cornerRadius = 8;
    
    UIButton *onSeviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    onSeviceBtn.layer.cornerRadius = 28;
    onSeviceBtn.imageView.contentMode = UIViewContentModeScaleToFill;
    [onSeviceBtn addTarget:self action:@selector(onServiceBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [onSeviceBtn setImage:dp_AccountImage(@"onlineSevice.png") forState:UIControlStateNormal];
    [alterView addSubview:onSeviceBtn];
    [onSeviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(alterView.mas_centerX).offset(-55);
        make.top.mas_equalTo(34);
        make.size.mas_equalTo(CGSizeMake(62.5, 62.5));
    }];
    
    UILabel *onSeviceLabel = [[UILabel alloc]init];
    onSeviceLabel.textColor = ycolorWithRGB(0.71, 0.71, 0.71);
    onSeviceLabel.font = [UIFont systemFontOfSize:12];
    onSeviceLabel.textAlignment = NSTextAlignmentCenter;
    onSeviceLabel.text = @"在线客服";
    [alterView addSubview:onSeviceLabel];
    [onSeviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(onSeviceBtn.mas_bottom).offset(8);
        make.centerX.equalTo(onSeviceBtn.mas_centerX);
        make.height.mas_equalTo(12);
    }];
    
    UIButton *servicePhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    servicePhoneBtn.layer.cornerRadius = 28;
    servicePhoneBtn.imageView.contentMode = UIViewContentModeScaleToFill;
    [servicePhoneBtn setImage:dp_AccountImage(@"servicePhone.png") forState:UIControlStateNormal];
    [servicePhoneBtn addTarget:self action:@selector(servicePhoneBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [alterView addSubview:servicePhoneBtn];
    [servicePhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(alterView.mas_centerX).offset(55);
        make.top.mas_equalTo(34);
        make.size.mas_equalTo(CGSizeMake(62.5, 62.5));
    }];
    
    UILabel *servicePhoneLabel = [[UILabel alloc]init];
    servicePhoneLabel.textColor = ycolorWithRGB(0.71, 0.71, 0.71);
    servicePhoneLabel.font = [UIFont systemFontOfSize:12];
    servicePhoneLabel.textAlignment = NSTextAlignmentCenter;
    servicePhoneLabel.text = @"客服热线";
    [alterView addSubview:servicePhoneLabel];
    [servicePhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(servicePhoneBtn.mas_bottom).offset(8);
        make.centerX.equalTo(servicePhoneBtn.mas_centerX);
        make.height.mas_equalTo(12);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.layer.cornerRadius = 5;
    closeBtn.backgroundColor = UIColorFromRGB(0xd14d49);
    closeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [alterView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(37);
    }];
    
    
    
    [self.view addSubview:alterView];
    [alterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-20);
        make.size.mas_equalTo(CGSizeMake(256, 210));
    }];
    
}
- (void)onServiceBtnTapped{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.sevice) {
        self.sevice();
    }
}
- (void)servicePhoneBtnTapped{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"400-826-5536"];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
- (void)closeBtnTapped{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark---------创建用户头像设置
- (void)creatUserIconSet{
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bgImage.backgroundColor = [UIColor blackColor];
    bgImage.alpha = 0.33;
    [self.view insertSubview:bgImage atIndex:0];
    
    NSArray *btnTitles = @[@"取消",@"设置头像",@"设置昵称"];
    for (NSInteger i = 0; i<3; i++) {
        UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor dp_flatWhiteColor];
        btn.layer.borderColor = [UIColor dp_flatGreenColor].CGColor;
        btn.layer.borderWidth = 0.66;
        btn.layer.cornerRadius = 5;
        btn.tag = 100+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
        [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(userSetBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-10-50*i);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(40);
        }];
        
    }
}
- (void)userSetBtnTapped:(UIButton *)btn{

    [self dismissViewControllerAnimated:YES completion:^{
            self.setBtnTappedBlock(btn);
    }];
}



#pragma mark---------注销账户
- (void)createCancelAccount{
    
    UIView *alterView = [[UIView alloc]init];
    alterView.backgroundColor = [UIColor dp_flatBackgroundColor];
    alterView.layer.cornerRadius = 8;
    [self.view addSubview:alterView];
    [alterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-20);
        make.size.mas_equalTo(CGSizeMake(256,120));
    }];
    
    UILabel *titleLable = [[UILabel alloc]init];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont systemFontOfSize:18];
    titleLable.textColor = [UIColor dp_flatRedColor];
    titleLable.text = @"确认注销";
    [alterView addSubview:titleLable];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(18);
    }];
    
    UIButton *knowBtn = [self creatBtnWithTitle:@"确认"];
    knowBtn.backgroundColor = UIColorFromRGB(0xe96968);
    [knowBtn addTarget:self action:@selector(knowBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *fullBtn = [self creatBtnWithTitle:@"取消"];
    fullBtn.backgroundColor = UIColorFromRGB(0xd24b48);
    [fullBtn addTarget:self action:@selector(fullBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [alterView addSubview:knowBtn];
    [alterView addSubview:fullBtn];
    [knowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.left.mas_equalTo(20);
        make.right.equalTo(fullBtn.mas_left).offset(-20);
        make.height.mas_equalTo(40);
    }];
    [fullBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.width.equalTo(knowBtn.mas_width);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(40);
    }];
    
}


#pragma mark---------未支付返回
-(void)createBackForNoPay{
    UIView *alterView = [[UIView alloc]init];
    alterView.backgroundColor = [UIColor dp_flatBackgroundColor];
    alterView.layer.cornerRadius = 12;
    [self.view addSubview:alterView];
    [alterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-20);
        make.size.mas_equalTo(CGSizeMake(256,256));
    }];
    UIImageView *imageView=[[UIImageView alloc] init];
    imageView.backgroundColor=[UIColor clearColor];
   
    UIImage *image=dp_AccountImage(@"newreminder.png");
    [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageView.image=image;
     imageView.tintColor=[UIColor dp_flatRedColor];
    [alterView addSubview:imageView];
    
    UILabel *titleLable = [[UILabel alloc]init];
    titleLable.textAlignment = NSTextAlignmentLeft;
    titleLable.font = [UIFont systemFontOfSize:17.0];
    titleLable.textColor = UIColorFromRGB(0xdc4e4c);
    titleLable.text = @"温馨提示";
    [alterView addSubview:titleLable];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(imageView.mas_right).offset(5);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleLable);
        make.left.mas_equalTo(16);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
    
    UILabel *contentLable = [[UILabel alloc]init];
    contentLable.textAlignment = NSTextAlignmentLeft;
    contentLable.font = [UIFont systemFontOfSize:14.0];
    contentLable.textColor = UIColorFromRGB(0x686869);
    contentLable.text = @"我们将会把你创建的方案保存在购\n彩记录里，随时等待您的激活。";
    contentLable.numberOfLines = 0;
    [alterView addSubview:contentLable];
    [contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLable.mas_bottom).offset(15);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
    }];
    
    UIButton *knowBtn = [self creatBtnWithTitle:@"我知道了"];
    knowBtn.backgroundColor = UIColorFromRGB(0xd24b48);
    [knowBtn addTarget:self action:@selector(knowBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *fullBtn = [self creatBtnWithTitle:@"前去查看"];
    fullBtn.backgroundColor = UIColorFromRGB(0xe96968);
    [fullBtn addTarget:self action:@selector(fullBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [alterView addSubview:knowBtn];
    [alterView addSubview:fullBtn];
    [fullBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.left.mas_equalTo(20);
        make.right.equalTo(knowBtn.mas_left).offset(-20);
        make.height.mas_equalTo(36);
    }];
    [knowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.width.equalTo(fullBtn.mas_width);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(36);
    }];

}
-(void)createStopChase{

    UIView *alterView = [[UIView alloc]init];
    alterView.backgroundColor = [UIColor dp_flatBackgroundColor];
    alterView.layer.cornerRadius = 12;
    [self.view addSubview:alterView];
    [alterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-20);
        make.size.mas_equalTo(CGSizeMake(256,186));
    }];
    
    UILabel *titleLable = [[UILabel alloc]init];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont systemFontOfSize:17.0];
    titleLable.textColor = UIColorFromRGB(0xdc4e4c);
    titleLable.text = @"停止追号";
    [alterView addSubview:titleLable];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    UILabel *contentLable = [[UILabel alloc]init];
    contentLable.textAlignment = NSTextAlignmentLeft;
    contentLable.font = [UIFont systemFontOfSize:14.0];
    contentLable.textColor = UIColorFromRGB(0x686869);
    contentLable.text = @"系统将会对未追期次进行停止追号，并自动返还冻结金额";
    contentLable.numberOfLines = 0;
    [alterView addSubview:contentLable];
    [contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLable.mas_bottom).offset(15);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
    }];
    
    UIButton *cancelBtn = [self creatBtnWithTitle:@"取消"];
    cancelBtn.backgroundColor = UIColorFromRGB(0xd24b48);
    [cancelBtn addTarget:self action:@selector(knowBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *sureBtn = [self creatBtnWithTitle:@"确认"];
    sureBtn.backgroundColor = UIColorFromRGB(0xe96968);
    [sureBtn addTarget:self action:@selector(fullBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [alterView addSubview:cancelBtn];
    [alterView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.left.mas_equalTo(20);
        make.right.equalTo(cancelBtn.mas_left).offset(-20);
        make.height.mas_equalTo(36);
    }];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.width.equalTo(sureBtn.mas_width);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(36);
    }];

}
#pragma mark---------注册成功弹框
- (void)createLoginSuccess{
    
    UIView *alterView = [[UIView alloc]init];
    alterView.backgroundColor = [UIColor dp_flatBackgroundColor];
    alterView.layer.cornerRadius = 8;
    [self.view addSubview:alterView];
    [alterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-20);
        make.size.mas_equalTo(CGSizeMake(256,256));
    }];
    
    UILabel *titleLable = [[UILabel alloc]init];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont systemFontOfSize:18];
    titleLable.textColor = [UIColor dp_flatRedColor];
    titleLable.text = @"大彩账户开通成功";
    [alterView addSubview:titleLable];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(18);
    }];
    
    UILabel *contentLable = [[UILabel alloc]init];
    contentLable.textAlignment = NSTextAlignmentLeft;
    contentLable.font = [UIFont systemFontOfSize:14];
    contentLable.textColor = [UIColor darkGrayColor];
    contentLable.text = @"您可以使用手机号码或者第三方登录方式直接登录。\n但是完善实名信息才能享有充值、提现、投注等服务。";
    contentLable.numberOfLines = 0;
    [alterView addSubview:contentLable];
    [contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLable.mas_bottom).offset(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    UIButton *knowBtn = [self creatBtnWithTitle:@"我知道了"];
    knowBtn.dp_eventId =  DPAnalyticsTypeAccountClose ;
    knowBtn.backgroundColor = UIColorFromRGB(0xe96968);
    [knowBtn addTarget:self action:@selector(knowBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *fullBtn = [self creatBtnWithTitle:@"立即完善"];
    fullBtn.dp_eventId = DPAnalyticsTypeAccountNext ;
    fullBtn.backgroundColor = UIColorFromRGB(0xd24b48);
    [fullBtn addTarget:self action:@selector(fullBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [alterView addSubview:knowBtn];
    [alterView addSubview:fullBtn];
    [knowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.left.mas_equalTo(20);
        make.right.equalTo(fullBtn.mas_left).offset(-20);
        make.height.mas_equalTo(36);
    }];
    [fullBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.width.equalTo(knowBtn.mas_width);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(36);
    }];

}
- (UIButton *)creatBtnWithTitle:(NSString *)title{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = UIColorFromRGB(0xdc4e4c);
    btn.layer.cornerRadius = 5;
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
    return btn;
}
- (void)knowBtnTapped:(UIButton *)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.fullBtnTapped) {
        self.fullBtnTapped(btn);
    }
}
- (void)fullBtnTapped:(UIButton *)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.sevice) {
        self.sevice(btn);
    }
}

#pragma mark---------创建选择银行试图
- (void)createBankChoseView{
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bgImage.backgroundColor = [UIColor blackColor];
    bgImage.alpha = 0.33;
    [self.view insertSubview:bgImage atIndex:0];
    self.view.backgroundColor = [UIColor clearColor];
    
    UITableView *bankTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    bankTable.dataSource = self;
    bankTable.delegate = self;
    self.bankTable = bankTable;
    [self.view addSubview:bankTable];
    [bankTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(300);
    }];

    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bankArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DPBankCell *cell = [[DPBankCell alloc]initWithTableView:tableView atIndexPath:indexPath];
    cell.object = self.bankArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.lastBankObject.isSelect = NO;
    DPUAObject *object = self.bankArray[indexPath.row];
    object.isSelect = YES;
    self.lastBankObject = object;
    [self.bankTable reloadData];
    
    if (self.bankBlock) {
        self.bankBlock(object);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setBankArray:(NSMutableArray *)bankArray{
    _bankArray = bankArray;
    for (DPUAObject *object in _bankArray) {
        if (object.isSelect) {
            self.lastBankObject = object;
        }
    }
    [self.bankTable reloadData];
}

#pragma mark---------创建开通账户成功试图
- (void)createOpenBetSuccessView{
    
    UIView *alterView = [[UIView alloc]init];
    alterView.backgroundColor = [UIColor dp_flatBackgroundColor];
    alterView.layer.cornerRadius = 8;
    [self.view addSubview:alterView];
    [alterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-20);
        make.size.mas_equalTo(CGSizeMake(256,256));
    }];
    
    UILabel *titleLable = [[UILabel alloc]init];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.font = [UIFont systemFontOfSize:21];
    titleLable.textColor = UIColorFromRGB(0xdc4e4c);
    titleLable.text = @"开通投注服务申请成功";
    [alterView addSubview:titleLable];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(18);
    }];
    
    UILabel *contentLable = [[UILabel alloc]init];
    contentLable.textAlignment = NSTextAlignmentLeft;
    contentLable.font = [UIFont systemFontOfSize:14];
    contentLable.textColor = UIColorFromRGB(0x777777);
    contentLable.text = @"您开通投注服务的申请已经提交审核，审核通过我们会以短信的形式通知您。";
    contentLable.numberOfLines = 0;
    [alterView addSubview:contentLable];
    [contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLable.mas_bottom).offset(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    UIButton *knowBtn = [self creatBtnWithTitle:@"我知道了"];
    knowBtn.dp_eventId =  DPAnalyticsTypeServiceClose ;
    [knowBtn addTarget:self action:@selector(openSeviceBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [alterView addSubview:knowBtn];
    [knowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(36);
    }];
   
}

- (void)openSeviceBtnTapped{
    if (self.sevice) {
        self.sevice();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark---------创建密码输入框
- (void)createPasswordView{
    
    UITextField *password = [[UITextField alloc]init];
    password.delegate = self;
    password.inputAccessoryView = self.passwordView;
    [self.view addSubview:password];
    self.password = password;
    [password.rac_textSignal subscribeNext:^(NSString *x) {
        self.passwordView.passwordText.text = x;
    }];
    
    
}

- (DPPayPasswordView *)passwordView{
    if (!_passwordView) {
        __weak DPAlterViewController *weakSelf = self;
        _passwordView = [[DPPayPasswordView alloc]initWithFrame:CGRectZero];
        _passwordView.passwordText.delegate = self;
        _passwordView.forgetPasswordTapped = ^{
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                if (weakSelf.forgetPassword) {
                    weakSelf.forgetPassword();
                }
            }];
        };
        _passwordView.surePasswordTapped = ^(NSString *passWord){
            [weakSelf dismissViewControllerAnimated:YES completion:^{
            if (weakSelf.passwordBlock) {
                weakSelf.passwordBlock(passWord);
            }
                }];
            
        };
       UITapGestureRecognizer *closeKeyboardGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboardTapped:)];
        [_passwordView addGestureRecognizer:closeKeyboardGesture];
    }
    return _passwordView;
}
- (void)closeKeyboardTapped:(UITapGestureRecognizer *)gesture{
     [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if (_alterType == AlterTypePayPassowrd) {
         [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if (self.passwordBlock&&textField == self.passwordView.passwordText) {
//        self.passwordBlock(self.passwordView.passwordText.text);
//    }
}
#pragma mark---------大乐透期号切换
- (void)createDLTNumChangeView{
    UIView *alterView = [[UIView alloc]init];
    alterView.backgroundColor = [UIColor dp_flatBackgroundColor];
    alterView.layer.cornerRadius = 8;
    [self.view addSubview:alterView];
    [alterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-20);
        make.size.mas_equalTo(CGSizeMake(256,256));
    }];
    
    self.contentLabel = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x666666) font:[UIFont systemFontOfSize:14]];
    [alterView addSubview:self.contentLabel];;
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
    }];
    
    UIButton *knowBtn = [UIButton dp_buttonWithTitle:@"我知道了" titleColor:[UIColor dp_flatWhiteColor] backgroundColor:[UIColor dp_flatRedColor] font:[UIFont systemFontOfSize:17]];
    [alterView addSubview:knowBtn];
    knowBtn.layer.cornerRadius = 5;
    [[knowBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *btn) {
        if (self.confirmBlock) {
            self.confirmBlock();
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [knowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-19);
        make.left.mas_equalTo(19);
        make.right.mas_equalTo(-19);
        make.height.mas_equalTo(36);
    }];
}
#pragma mark---------大乐透期号截至
- (void)createDLTNumStopView{
    UIView *alterView = [[UIView alloc]init];
    alterView.backgroundColor = [UIColor dp_flatBackgroundColor];
    alterView.layer.cornerRadius = 8;
    [self.view addSubview:alterView];
    [alterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-20);
        make.size.mas_equalTo(CGSizeMake(256,256));
    }];
    
    self.contentLabel = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x666666) font:[UIFont systemFontOfSize:14]];
    [alterView addSubview:self.contentLabel];;
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
    }];
    
    UIButton *knowBtn = [UIButton dp_buttonWithTitle:@"确认" titleColor:[UIColor dp_flatWhiteColor] backgroundColor:[UIColor dp_flatRedColor] font:[UIFont systemFontOfSize:17]];
    [alterView addSubview:knowBtn];
    knowBtn.layer.cornerRadius = 5;

    [[knowBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *btn) {
        if (self.confirmBlock) {
            self.confirmBlock();
        }
         [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    
    UIButton *cancelBtn = [UIButton dp_buttonWithTitle:@"取消" titleColor:[UIColor dp_flatWhiteColor] backgroundColor:[UIColor dp_flatRedColor] font:[UIFont systemFontOfSize:17]];
    [alterView addSubview:cancelBtn];
    cancelBtn.layer.cornerRadius = 5;
    [[cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *btn) {
        if (self.cancelBlock) {
            self.cancelBlock();
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [knowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-19);
        make.left.mas_equalTo(19);
        make.right.equalTo(cancelBtn.mas_left).offset(-19);
        make.width.equalTo(cancelBtn.mas_width);
        make.height.mas_equalTo(36);
    }];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-19);
        make.right.mas_equalTo(-19);
        make.height.mas_equalTo(36);
    }];
}
#pragma mark---------大乐透期号停售
- (void)createDLTNumOverView{
    UIView *alterView = [[UIView alloc]init];
    alterView.backgroundColor = [UIColor dp_flatBackgroundColor];
    alterView.layer.cornerRadius = 8;
    [self.view addSubview:alterView];
    [alterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-20);
        make.size.mas_equalTo(CGSizeMake(256,256));
    }];
    
    self.contentLabel = [UILabel dp_labelWithText:@"当前玩法已停售" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x666666) font:[UIFont systemFontOfSize:14]];
    [alterView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
    }];
    
    UIButton *knowBtn = [UIButton dp_buttonWithTitle:@"我知道了" titleColor:[UIColor dp_flatWhiteColor] backgroundColor:[UIColor dp_flatRedColor] font:[UIFont systemFontOfSize:17]];
    [alterView addSubview:knowBtn];
    knowBtn.layer.cornerRadius = 5;

    [[knowBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *btn) {
        if (self.confirmBlock) {
            self.confirmBlock();
        }
         [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [knowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-19);
        make.left.mas_equalTo(19);
        make.right.mas_equalTo(-19);
        make.height.mas_equalTo(36);
    }];
}
#pragma mark---------竞彩所有玩法投注/中转页面夜间不出票弹窗
- (void)createJcUnGetNoView{
    UIView *alterView = [[UIView alloc]init];
    alterView.backgroundColor = [UIColor dp_flatBackgroundColor];
    alterView.layer.cornerRadius = 8;
    [self.view addSubview:alterView];
    [alterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-20);
        make.size.mas_equalTo(CGSizeMake(256,256));
    }];
    
    UILabel *contentLabel = [UILabel dp_labelWithText:@"官方夜间已停止出票，大彩网仍将为用户提供下单功能，当前赔率信息在第二天出票后可能会有出入。" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x666666) font:[UIFont systemFontOfSize:14]];
    [alterView addSubview:contentLabel];
        self.contentLabel = contentLabel;
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
    }];
    
    UIButton *knowBtn = [UIButton dp_buttonWithTitle:@"我知道了" titleColor:[UIColor dp_flatWhiteColor] backgroundColor:[UIColor dp_flatRedColor] font:[UIFont systemFontOfSize:17]];
    [alterView addSubview:knowBtn];
    knowBtn.layer.cornerRadius = 5;

    [[knowBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *btn) {
        if (self.confirmBlock) {
            self.confirmBlock();
        }
         [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [knowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-19);
        make.left.mas_equalTo(19);
        make.right.mas_equalTo(-19);
        make.height.mas_equalTo(36);
    }];
}
#pragma mark---------竞彩订单确认页面夜间不出票弹窗
- (void)createJcUnGetView{
    UIView *alterView = [[UIView alloc]init];
    alterView.backgroundColor = [UIColor dp_flatBackgroundColor];
    alterView.layer.cornerRadius = 8;
    [self.view addSubview:alterView];
    [alterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-20);
        make.size.mas_equalTo(CGSizeMake(256,256));
    }];
    
    UILabel *contentLabel = [UILabel dp_labelWithText:@"官方夜间已停止出票，大彩网仍将为用户提供下单功能，当前赔率信息在第二天出票后可能会有出入。\n\n是否继续投注" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x666666) font:[UIFont systemFontOfSize:14]];
    [alterView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
    }];
    
    UIButton *knowBtn = [UIButton dp_buttonWithTitle:@"继续" titleColor:[UIColor dp_flatWhiteColor] backgroundColor:[UIColor dp_flatRedColor] font:[UIFont systemFontOfSize:17]];
    [alterView addSubview:knowBtn];
    knowBtn.layer.cornerRadius = 5;
    [[knowBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *btn) {
        if (self.confirmBlock) {
            self.confirmBlock();
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    
    UIButton *cancelBtn = [UIButton dp_buttonWithTitle:@"取消" titleColor:[UIColor dp_flatWhiteColor] backgroundColor:[UIColor dp_flatRedColor] font:[UIFont systemFontOfSize:17]];
    [alterView addSubview:cancelBtn];
    cancelBtn.layer.cornerRadius = 5;
    [[cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *btn) {
        if (self.cancelBlock) {
            self.cancelBlock();
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [knowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-19);
        make.left.mas_equalTo(19);
        make.right.equalTo(cancelBtn.mas_left).offset(-19);
        make.width.equalTo(cancelBtn.mas_width);
        make.height.mas_equalTo(36);
    }];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-19);
        make.right.mas_equalTo(-19);
        make.height.mas_equalTo(36);
    }];
}
#pragma mark---------竞彩停售玩法投注页面停售弹窗
- (void)createJcStopView{
    UIView *alterView = [[UIView alloc]init];
    alterView.backgroundColor = [UIColor dp_flatBackgroundColor];
    alterView.layer.cornerRadius = 8;
    [self.view addSubview:alterView];
    [alterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-20);
        make.size.mas_equalTo(CGSizeMake(256,256));
    }];
    
    self.contentLabel = [UILabel dp_labelWithText:@"当前玩法已停售。" backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x666666) font:[UIFont systemFontOfSize:14]];
    [alterView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(18);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
    }];
    
    UIButton *knowBtn = [UIButton dp_buttonWithTitle:@"我知道了" titleColor:[UIColor dp_flatWhiteColor] backgroundColor:[UIColor dp_flatRedColor] font:[UIFont systemFontOfSize:17]];
    knowBtn.layer.cornerRadius = 5;
    [alterView addSubview:knowBtn];
    [[knowBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *btn) {
        if (self.confirmBlock) {
            self.confirmBlock();
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [knowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-19);
        make.left.mas_equalTo(19);
        make.right.mas_equalTo(-19);
        make.height.mas_equalTo(36);
    }];
}

@end
