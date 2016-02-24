//
//  DPBaseDrawVC.m
//  DacaiProject
//
//  Created by Ray on 15/2/9.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPBaseDrawVC.h"
#import "DPWebViewController.h"
#define kDockInfoHeight 40


@interface DPDrawBaseHeaderView ()
{
    NSArray *_titles ;
    NSArray *_navTitles ;
}
@property (nonatomic, strong, readonly) UIView *switchView;
@property (nonatomic, strong, readonly) UIView *countdownView;
@property(nonatomic,strong,readonly)UIButton *backBtn ;
@property(nonatomic,strong,readonly)UIButton *introduceBtn ;
@property(nonatomic,strong,readonly)UIButton *settingBtn ;
@property(nonatomic,strong,readonly)UIView *bottomLine ;

@property (nonatomic, strong, readonly) UIView *leftLineView;


@end


@implementation DPDrawBaseHeaderView
@synthesize switchView = _switchView;
@synthesize countdownView = _countdownView;
@synthesize dockInfoView = _dockInfoView ;
@synthesize backBtn = _backBtn ;
@synthesize introduceBtn = _introduceBtn ;
@synthesize titleSegment = _titleSegment ;
@synthesize settingBtn = _settingBtn ;
@synthesize leftLineView = _leftLineView ;
@synthesize bottomLine = _bottomLine ;

- (instancetype)initWithDocTitles:(NSArray*)titles navTitles:(NSArray*)navTitles{
    if (self = [super init]) {
        [self addSubview:self.switchView];
//        [self addSubview:self.countdownView];
        _titles = titles ;
        _navTitles = navTitles ;
        [self addSubview:self.dockInfoView];
        [self addSubview:self.backBtn];
        [self addSubview:self.introduceBtn];
        if(_navTitles.count){
            [self addSubview:self.titleSegment];
        }
        [self addSubview:self.settingBtn];
        [self addSubview:self.leftLineView];
        [self addSubview:self.bottomLine];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.switchView];
        [self addSubview:self.countdownView];
    }
    return self;
}

- (void)layoutSubviews {
    
    CGFloat height =44;
    if (IOS_VERSION_7_OR_ABOVE && ((self.orientation != UIInterfaceOrientationLandscapeLeft && self.orientation != UIInterfaceOrientationLandscapeRight) || !self.supportRotate)) {
        height = height + 20;
    }

    if ((self.orientation == UIInterfaceOrientationLandscapeLeft || self.orientation == UIInterfaceOrientationLandscapeRight) && self.supportRotate) {
        
        self.backBtn.frame =  CGRectMake(5, height-44, kDockInfoHeight,kDockInfoHeight);
        self.leftLineView.hidden =  NO ;
        
        self.titleSegment.frame =   CGRectMake(CGRectGetWidth(self.bounds)/4-CGRectGetHeight(self.bounds)/2, (CGRectGetHeight(self.bounds)-25)/2, 100, 25);
        self.switchView.frame = CGRectMake(CGRectGetHeight(self.bounds)+10, 0, CGRectGetWidth(self.bounds)/2-CGRectGetHeight(self.bounds)-10, CGRectGetHeight(self.bounds)-kDockInfoHeight);
        self.dockInfoView.frame = CGRectMake(CGRectGetMaxX(self.switchView.bounds)+kSetBtnWidth, 0, CGRectGetWidth(self.bounds)/2-CGRectGetHeight(self.bounds)-10, CGRectGetHeight(self.bounds));
        self.settingBtn.frame = CGRectMake(0, kDockInfoHeight, kSetBtnWidth, 25) ;
        
    } else {
        
        self.backBtn.frame =  CGRectMake(8, height-44, kDockInfoHeight,kDockInfoHeight);
        self.leftLineView.hidden = YES ;
        self.titleSegment.frame =   CGRectMake(CGRectGetWidth(self.bounds)/2-50, (44-25)/2+height-44, 100, 25);

        self.switchView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-kDockInfoHeight);
        self.dockInfoView.frame = CGRectMake(kSetBtnWidth, CGRectGetMaxY(self.switchView.bounds), CGRectGetWidth(self.bounds)-kSetBtnWidth, kDockInfoHeight);

        self.settingBtn.frame = CGRectMake(0, height, kSetBtnWidth, kDockInfoHeight) ;
    }
    
    
    self.bottomLine.frame = CGRectMake(0, CGRectGetMaxY(self.dockInfoView.frame)-0.5, CGRectGetWidth(self.bounds), 0.5);
    self.introduceBtn.frame =  CGRectMake(CGRectGetWidth(self.bounds)-kDockInfoHeight-5, height-44, kDockInfoHeight,kDockInfoHeight);

    
    
}


- (CGSize)intrinsicContentSize {
    
    
    CGFloat height =44;
    if (IOS_VERSION_7_OR_ABOVE) {
        height = height + 20;
    }
    
    if (!self.supportRotate) {
        return CGSizeMake(0, kDockInfoHeight+height);
    }

    if (self.orientation == UIInterfaceOrientationLandscapeLeft || self.orientation == UIInterfaceOrientationLandscapeRight) {
        return CGSizeMake(0, kDockInfoHeight);
    } else {
        return CGSizeMake(0, kDockInfoHeight+height);
    }
}

- (UIView *)switchView {
    if (_switchView == nil) {
        _switchView = [[UIView alloc] init];
        _switchView.backgroundColor = [UIColor dp_flatDarkRedColor];
       
    }
    return _switchView;
}

- (UIView *)countdownView {
    if (_countdownView == nil) {
        _countdownView = [[UIView alloc] init];
        _countdownView.backgroundColor = [UIColor yellowColor];
    }
    return _countdownView;
}
-(DPDrawInfoDockView*)dockInfoView{

    if (_dockInfoView == nil) {
        _dockInfoView = [[DPDrawInfoDockView alloc]initWithTitles:_titles bottomImg:dp_AccountImage(@"selectedTop.png") selectColor:[UIColor dp_flatRedColor] normalColor:UIColorFromRGB(0x988B81)];
        _dockInfoView.backgroundColor = [UIColor clearColor] ;
    }
    return _dockInfoView ;
}
-(UIButton*)backBtn{
    
    if (_backBtn == nil) {
        
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setTitleColor:[UIColor dp_flatBlueColor] forState:UIControlStateNormal];
        [_backBtn setImage:dp_NavigationImage(@"back.png") forState:UIControlStateNormal];
        _backBtn.backgroundColor = [UIColor clearColor] ;
        _backBtn.titleLabel.font = [UIFont dp_systemFontOfSize:kTextFont];
    }
    
    return _backBtn ;
}
-(UIButton*)introduceBtn{
    
    if (_introduceBtn == nil) {
        
        _introduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_introduceBtn setTitleColor:[UIColor dp_flatBlueColor] forState:UIControlStateNormal];
        [_introduceBtn setImage:dp_NavigationImage(@"introduceImg.png") forState:UIControlStateNormal];
        _introduceBtn.backgroundColor = [UIColor clearColor] ;
        _introduceBtn.titleLabel.font = [UIFont dp_systemFontOfSize:kTextFont];
    }
    
    return _introduceBtn ;
}

-(DPSegmentedControl*)titleSegment{
    
    if (_titleSegment == nil && _navTitles) {
        _titleSegment = [[DPSegmentedControl alloc]initWithItems:_navTitles];
        [_titleSegment setTintColor:UIColorFromRGB(0x810F13)];
        //        _titleSegment.frame = CGRectMake(0, 0, _titleArray.count*50, 25) ;
        _titleSegment.containerView.backgroundColor = [UIColor clearColor] ;
    }
    return _titleSegment ;
}


-(UIButton*)settingBtn{
    
    if (_settingBtn == nil  ) {
        _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [_settingBtn setTitleColor:[UIColor dp_flatBlueColor] forState:UIControlStateNormal];
        [_settingBtn setTitle:@"设置" forState:UIControlStateNormal];
        [_settingBtn setImage:dp_AccountImage(@"settingImg.png") forState:UIControlStateNormal];
        _settingBtn.backgroundColor = [UIColor clearColor] ;
        _settingBtn.titleLabel.font = [UIFont dp_systemFontOfSize:kTextFont];
        
    }
    
    return _settingBtn ;
}

-(UIView*)leftLineView
{
    if (_leftLineView == nil) {
        _leftLineView = [[UIView alloc]initWithFrame:CGRectMake(kDockInfoHeight+9.5, 0, 0.5, kDockInfoHeight)] ;
        _leftLineView.backgroundColor = UIColorFromRGB(0xDFD9D3) ;
    }
    
    return _leftLineView ;

}

-(UIView*)bottomLine{
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = UIColorFromRGB(0xDFD9D3) ;
        
    }
    
    return _bottomLine ;
}



@end


@interface DPBaseDrawVC ()<DPDrawInfoDockDelegate,DPTrendSettingViewDelegate>
{

    DPSegmentedControl *_titleSegment;

    
    NSArray* _titleArray ;//顶部数组
    NSArray* _docInfoArray ;//选择标题
    
    UIColor *_docSelectColor ;
    UIColor *_docNormalColor ;
    UIImage*_bottomImage ;
    
    UIButton *_backBtn ;
    UIButton *_introduceBtn ;
    UIButton *_smallSettingBtn ;
}
@property(nonatomic,strong,readonly)UIButton *smallSettingBtn ;
@property (nonatomic, strong, readonly)UIView *settingbgView ; ;



@end

@implementation DPBaseDrawVC
@synthesize headerView = _headerView;
@synthesize smallSettingBtn = _smallSettingBtn ;
@synthesize trendSetting = _trendSetting ;
@synthesize settingbgView = _settingbgView ;


- (instancetype)initWithTitles:(NSArray*)titleArray withDocTitles:(NSArray*)docTitles titleSelectColor:(UIColor*)selectColor titleNormalColor:(UIColor*)normlColor bottomImg:(UIImage*)bottomImg supportRota:(BOOL)supportRota
{
    self = [super init];
    if (self) {
        _titleArray = [titleArray copy];
        _docInfoArray = [docTitles copy];
        _docSelectColor = selectColor ;
        _docNormalColor = normlColor ;
        _bottomImage = bottomImg ;
        self.supportRation = supportRota ;
    }
    return self;
}


- (instancetype)initWithTitles:(NSArray*)titleArray withDocTitles:(NSArray*)docTitles titleSelectColor:(UIColor*)selectColor titleNormalColor:(UIColor*)normlColor bottomImg:(UIImage*)bottomImg
{
    self = [super init];
    if (self) {
        _titleArray = [titleArray copy];
        _docInfoArray = [docTitles copy];
        _docSelectColor = selectColor ;
        _docNormalColor = normlColor ;
        _bottomImage = bottomImg ;
    }
    return self;
}

- (instancetype)init {
    DPException(@"user initWithTitles.");
}


#pragma mark - DPDrawInfoDockDelegate
-(void)changeDocIndex:(NSInteger)index{

    DPLog(@"DPDrawInfoDockDelegate ====  %ld",index) ;


}



-(UIButton*)smallSettingBtn{
    
    if (_smallSettingBtn == nil  ) {
        _smallSettingBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        [_smallSettingBtn setTitleColor:[UIColor dp_flatBlueColor] forState:UIControlStateNormal];
        [_smallSettingBtn setTitle:@"设置" forState:UIControlStateNormal];
        [_smallSettingBtn setImage:dp_AccountImage(@"settingImg.png") forState:UIControlStateNormal];
        _smallSettingBtn.backgroundColor = [UIColor clearColor] ;
        _smallSettingBtn.titleLabel.font = [UIFont dp_systemFontOfSize:kTextFont];
        [_smallSettingBtn addTarget:self action:@selector(pvt_setting:) forControlEvents:UIControlEventTouchUpInside];
        
        _smallSettingBtn.layer.borderWidth = 1 ;
        _smallSettingBtn.layer.borderColor = UIColorFromRGB(0xDFD9D3).CGColor ;
    }
    
    return _smallSettingBtn ;
}


-(void)pvt_setting:(UIButton*)sender
{
    
    DPLog(@"=== 设置 ====") ;
    [self.trendSetting refresh];
    self.settingbgView.hidden = NO ;
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self willRotateToInterfaceOrientation:self.interfaceOrientation duration:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _navSelectIndex = 0 ;
    
    self.headerView.supportRotate = self.supportRation ;
    [self.view addSubview:self.headerView];
    
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
    }];

    
    _trendView = [[DPTrendView alloc]init];
    _trendView.backgroundColor = [UIColor dp_flatWhiteColor];
    _trendView.delegate =self ;

    [self.view addSubview:_trendView];
    [_trendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom) ;
        make.left.equalTo(self.view) ;
        make.right.equalTo(self.view) ;
        make.bottom.equalTo(self.view).offset(-76) ;
    }];
    
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_trendView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

    
    if (self.supportRation) { //支持旋转的时候才加
        [self.view addSubview:self.smallSettingBtn];
        if([self dp_isOrientationLandscape]){
            self.smallSettingBtn.hidden = NO ;
            self.headerView.leftLineView.hidden = NO ;
            
            [_backBtn setImage:dp_NavigationImage(@"ks_redBack.png") forState:UIControlStateNormal];
            [_introduceBtn setImage:dp_NavigationImage(@"ks_redIntroduce.png") forState:UIControlStateNormal];
            
        }else{
            self.smallSettingBtn.hidden = YES ;
            self.headerView.leftLineView.hidden = YES ;
            [_backBtn setImage:dp_NavigationImage(@"back.png") forState:UIControlStateNormal];
            [_introduceBtn setImage:dp_NavigationImage(@"introduceImg.png") forState:UIControlStateNormal];
        }
        
        [self.smallSettingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_bottom).offset(-0.5) ;
            make.left.equalTo(self.view) ;
            make.width.equalTo(@(kSetBtnWidth)) ;
            make.height.equalTo(@25) ;
        }];
        

    }
    
   
    [self.view addSubview:self.settingbgView];
    self.settingbgView.hidden = YES ;
    [self.settingbgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.right.equalTo(self.view) ;
        make.edges.equalTo(self.view) ;
    }];
    [self.trendSetting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view) ;
    }];

    
}


// 横屏支持
- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight){
        self.headerView.switchView.backgroundColor = [UIColor dp_flatWhiteColor] ;
        [_backBtn setImage:dp_NavigationImage(@"ks_redBack.png") forState:UIControlStateNormal];
        [_introduceBtn setImage:dp_NavigationImage(@"ks_redIntroduce.png") forState:UIControlStateNormal];
        self.smallSettingBtn.hidden = NO ;
        [UIApplication sharedApplication].statusBarHidden = YES;
    }else{
        self.headerView.switchView.backgroundColor = [UIColor dp_flatDarkRedColor] ;
        [_backBtn setImage:dp_NavigationImage(@"back.png") forState:UIControlStateNormal];
        [_introduceBtn setImage:dp_NavigationImage(@"introduceImg.png") forState:UIControlStateNormal];
        self.smallSettingBtn.hidden = YES ;
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
    self.headerView.orientation = toInterfaceOrientation;
    [self.headerView invalidateIntrinsicContentSize];

    [self.trendSetting invalidateIntrinsicContentSize];
  
}


#pragma mark- DPTrendViewDelegate
-(void)trendView:(DPTrendView *)trendView offset:(CGPoint)offset{
    if (_navSelectIndex == 0) {
        if (offset.x>self.redBallNumber*25-(CGRectGetWidth(self.view.bounds)-50)/2) {
            self.dockView.currentDocIndex = 1 ;
        }else {
            self.dockView.currentDocIndex = 0 ;
        }
    }
    self.bottomView.scrollView.contentOffset=CGPointMake(offset.x, 0);
}


-(void)pvt_onBack{
    
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES ];
}

-(void)pvt_introduce
{
    
    
    DPWebViewController *viewController = [[DPWebViewController alloc] init];
    
    viewController.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:kTrendChartHelpURL]];
    UINavigationController *navCtrl = [UINavigationController dp_controllerWithRootViewController:viewController];
    [self presentViewController:navCtrl animated:YES completion:nil];
    DPLog(@"=== pvt_introduce ===") ;
    
}

-(void)pvt_onSwitch:(DPSegmentedControl*)seg{

    DPLog(@"selectedIndex === %d",seg.selectedIndex );
    _navSelectIndex = seg.selectedIndex ;
}

-(DPDrawTrendImgData*)getImageDateWithTextColor:(UIColor*)textColor rowCount:(int)rowCount columnCount:(int)columCount lastCount:(int)lastCount hasLine:(BOOL)hasLine withWinNumbers:(NSArray*)winArray isleft:(BOOL)isleft statOn:(BOOL)statOn isChinese:(BOOL)isChinese{
    
    
    DPDrawTrendImgData *imageData = [[DPDrawTrendImgData alloc]init];
    imageData.rowCount = rowCount;
    imageData.columnCount = columCount;
    imageData.rowHeight = 25;
    imageData.hasConnectLine = hasLine;
    imageData.imageType = KTrendImgTypeNormal;
    imageData.singleRowColor = UIColorFromRGB(0xF7F6EF);
    imageData.doubleRowColor = UIColorFromRGB(0xFEFEFC);
    if (!isleft) {
        imageData.singleRowColor =
        imageData.doubleRowColor = UIColorFromRGB(0xE7E1D9);
    }else{
    
        imageData.aroundLine= kTrendAroundLineRight ;
    }
    imageData.columnLineColor = UIColorFromRGB(0xDFD9D3);
    imageData.fontSize = 11 ;
    
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:columCount] ;
    
    
    for (int i = 0; i < columCount; i++) {
        
        if (!isleft && _navSelectIndex == 1 && i>=columCount-lastCount) {
            [arr addObject:[NSNumber numberWithFloat:50]] ;
            continue ;
        }
        
        if (columCount == 1) {
            [arr addObject:[NSNumber numberWithFloat:50]] ;
            continue ;
        }
        [arr addObject:[NSNumber numberWithFloat:25]] ;
        
    }
    imageData.columnWidthArray =  arr  ;
    
    
    
    NSMutableArray * arrayM = [NSMutableArray arrayWithCapacity:columCount*rowCount];
    NSArray *colorArray = nil ;
    if (isleft && statOn) {
        colorArray = [NSArray arrayWithObjects:[UIColor dp_flatBlueColor],UIColorFromRGB(0x4F4325),UIColorFromRGB(0x387E00),UIColorFromRGB(0xFB0096), nil];
    }
    
   
    for (int y = 0; y < rowCount; y++) {
            for (int x = 0; x < columCount; x++) {
                DPTrendMixCellModel *model = [[DPTrendMixCellModel alloc]init];
                model.textType = isChinese?kTextTypeHanzi:kTextTypeMix ;
                model.point = CGPointMake(x, y);
                model.text = [winArray objectAtIndex:MAX(x, y)];
                                
                model.shapeType = kTrendShapeTypeNone;
                if (colorArray && y<colorArray.count) {
                    model.textColor = [colorArray objectAtIndex:y] ;
                }else
                    model.textColor = textColor ;
                
                [arrayM addObject:model];
                
            }
        }

    
    imageData.modelArray = arrayM;
    
    return imageData ;
    
}


-(DPDrawTrendImgData*)getImageDateWithTextColor:(UIColor*)textColor ShapColor:(UIColor*)shpColor rowCount:(int)rowCount columnCount:(int)columCount lastNumbers:(int)lastNumbers hasLine:(BOOL)hasLine withDatas:(int [200][49])DataArray isBottom:(BOOL)isBottom  missOn:(BOOL)missOn hasRightLine:(BOOL)hasRightLine {

    return [self getImageDateWithTextColor:textColor ShapColor:shpColor rowCount:rowCount columnCount:columCount lastNumbers:lastNumbers hasLine:hasLine withDatas:DataArray isBottom:isBottom missOn:missOn hasRightLine:hasRightLine isRightData:YES];

}

-(DPDrawTrendImgData*)getImageDateWithTextColor:(UIColor*)textColor ShapColor:(UIColor*)shpColor rowCount:(int)rowCount columnCount:(int)columCount lastNumbers:(int)lastNumbers hasLine:(BOOL)hasLine withDatas:(int [200][49])DataArray isBottom:(BOOL)isBottom  missOn:(BOOL)missOn hasRightLine:(BOOL)hasRightLine isRightData:(BOOL)isRightData{
    
    UIColor *whiteColo = [UIColor dp_flatWhiteColor] ;
    
    
    DPDrawTrendImgData *imageData = [[DPDrawTrendImgData alloc]init];
    imageData.rowCount = rowCount;
    imageData.columnCount = columCount;
    imageData.rowHeight = 25;
    imageData.hasConnectLine = hasLine;
    if (_navSelectIndex == 1 && isRightData) {
        imageData.imageType = KTrendImgTypeMix;
    }else
        imageData.imageType = KTrendImgTypeNormal;
    imageData.singleRowColor = UIColorFromRGB(0xF7F6EF);
    imageData.doubleRowColor = UIColorFromRGB(0xFEFEFC);
    imageData.conectLineColor = shpColor;
    imageData.columnLineColor = UIColorFromRGB(0xDFD9D3);
    imageData.fontSize = 13 ;
    if (isBottom) {
        imageData.aroundLine = kTrendAroundLineTop ;

    }else if (hasRightLine) {
        imageData.aroundLine = kTrendAroundLineRight ;
    }else{
            imageData.aroundLine = kTrendAroundLineLeft ;
    }
    
    
    
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:columCount] ;
    
    for (int i = 0; i < columCount; i++) {
        
        if (_navSelectIndex == 1 && isRightData && !isBottom) {
            [arr addObject:[NSNumber numberWithFloat:50]] ;;
        }else if (_navSelectIndex == 1 && isBottom && i>=columCount-lastNumbers ){
            [arr addObject:[NSNumber numberWithFloat:50]] ;;
            
        } else{
            [arr addObject:[NSNumber numberWithFloat:25]] ;;
        }
        
    }
    
    
    imageData.columnWidthArray =  arr  ;
    NSArray *colorArray = nil ;
    if (isBottom) {
        colorArray = [NSArray arrayWithObjects:[UIColor dp_flatBlueColor],UIColorFromRGB(0x4F4325),UIColorFromRGB(0x387E00),UIColorFromRGB(0xFB0096), nil];
    }
    
    NSMutableArray * arrayM = [NSMutableArray arrayWithCapacity:columCount*rowCount];
    for (int y = 0; y < rowCount; y++) {
        for (int x = 0; x < columCount; x++) {
            DPTrendMixCellModel *model = [[DPTrendMixCellModel alloc]init];
            model.point = CGPointMake(x, y);
            model.shapeType = kTrendShapeTypeNone;
            if (colorArray) {
                model.textColor = [colorArray objectAtIndex:y] ;
            }else
                model.textColor = textColor ;
            model.text = missOn? [NSString stringWithFormat:@"%d", DataArray[y][x]]:@"";
            
            
            if (DataArray[y][x] <0) {
                
                model.shapeType = kTrendShapeTypeCircle;
                model.shapeColor = shpColor ;
                model.textColor = whiteColo ;
                
                if (_navSelectIndex == 1 && isRightData) {
                    model.timesText =[NSString stringWithFormat:@"%d",x];
                    model.timesTextColor = [UIColor dp_flatWhiteColor];
                    model.text = missOn?  [NSString stringWithFormat:@"%d",ABS(DataArray[y][x])]:@"" ;
                    model.textColor = textColor ;
                    
                    
                }else{
                    if(_navSelectIndex == 1){
                        if (_currentGameType == GameTypeSsq) { //双色球
                            model.text = [NSString stringWithFormat:@"%02d",x+1+11*(int)self.dockView.currentDocIndex];
                        }else
                            
                            model.text = [NSString stringWithFormat:@"%02d",x+1+(self.dockView.currentDocIndex == 0?0:(self.dockView.currentDocIndex == 1?12:23))];
                        
                    }else
                        model.text = [NSString stringWithFormat:@"%02d",x+1];
                    
                }
                
                
            }
            
            
            [arrayM addObject:model];
            
        }
    }
    imageData.modelArray = arrayM;
    
    return imageData ;
    
    
}


- (void)trendBottomView:(DPTrendBottomView *)trendView offset:(CGPoint)offset{
    _trendView.offset=offset;
    
    
}
-(void)saveSelectedBallForBottomView:(NSInteger)index isSelected:(BOOL)isSelected{

    NSMutableAttributedString *hinstring=[[NSMutableAttributedString alloc] initWithString:@""];
    [self.bottomView selectedballInfoLabelText:hinstring];
}
-(DPTrendBottomView *)bottomView{
    if (_bottomView==nil) {
        _bottomView=[[DPTrendBottomView alloc] init];
        _bottomView.backgroundColor=[UIColor clearColor];
        _bottomView.delegate=self;
    }
    return _bottomView;
}
- (DPDrawBaseHeaderView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[DPDrawBaseHeaderView alloc]initWithDocTitles:_docInfoArray navTitles:_titleArray];
        _headerView.backgroundColor = [UIColor dp_flatWhiteColor];
        
        _backBtn = _headerView.backBtn ;
        _introduceBtn = _headerView.introduceBtn ;
        
        
        [_headerView.backBtn addTarget:self action:@selector(pvt_onBack) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.introduceBtn addTarget:self action:@selector(pvt_introduce) forControlEvents:UIControlEventTouchUpInside];
        
//         上面选项卡视图
        _headerView.dockInfoView.delegate =self ;
        _dockView = _headerView.dockInfoView;
        
        _titleSegment = _headerView.titleSegment ;
        [_titleSegment addTarget:self action:@selector(pvt_onSwitch:) forControlEvents:UIControlEventValueChanged];
        
        UIButton *bigButton = _headerView.settingBtn ;
        [bigButton addTarget:self action:@selector(pvt_setting:) forControlEvents:UIControlEventTouchUpInside];
        _headerView.orientation = self.interfaceOrientation;
        
    }
    return  _headerView;
}
-(DPTrendSettingView*)trendSetting{
    if (_trendSetting == nil) {
        _trendSetting =[[DPTrendSettingView alloc]init];
        _trendSetting.delegate =self ;
        
        
    }
    return _trendSetting ;
}

-(UIView*)settingbgView{

    if (_settingbgView == nil) {
        _settingbgView = [[UIView alloc]init];
        _settingbgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7] ;
        [_settingbgView addSubview:self.trendSetting];
        
    }
    
    return  _settingbgView ;
}

-(void)viewDidCancel:(DPTrendSettingView *)view
{

    self.settingbgView.hidden = YES ;
}

-(void)viewDidConfirm:(DPTrendSettingView *)view{

    self.settingbgView.hidden = YES ;
    
    if ([self dp_hasData]){ // 判断底层是否有数据
        [self reloadTrendView:(int)(self.trendSetting.issueIndex+1)*50  miss:self.trendSetting.missOn broken:self.trendSetting.brokenOn stat:self.trendSetting.statOn info:self.trendSetting.infoOn];
    }

}
- (BOOL)dp_hasData
{
    // 子类重写
    return YES;
}
-(void)reloadTrendView:(int)issueNumbers miss:(BOOL)missOn broken:(BOOL)brokenOn stat:(BOOL)statOn info:(BOOL)infoOn {


}
- (void)viewDidHelp:(DPTrendSettingView *)view{
    DPWebViewController *viewController = [[DPWebViewController alloc] init];
    
    viewController.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:kTrendChartHelpURL]];
    UINavigationController *navCtrl = [UINavigationController dp_controllerWithRootViewController:viewController];
    [self presentViewController:navCtrl animated:YES completion:nil];
}

@end
