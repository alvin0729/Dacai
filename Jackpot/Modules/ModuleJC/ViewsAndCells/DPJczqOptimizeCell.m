//
//  DPJczqOptimizeCell.m
//  Jackpot
//
//  Created by Ray on 15/12/8.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPJczqOptimizeCell.h"

#import "DPLiveDataCenterViews.h"


#define kLineColor   UIColorFromRGB(0xc4c1ba)

@interface DPMatchInfoView ()

 
@property(strong ,nonatomic) NSMutableArray *cellsArray ;

@end


@implementation DPMatchInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.cellsArray = [[NSMutableArray alloc]init];
        [self setupProperty];
    }
    return self;
}


- (void)setupProperty {
    
    DPLiveOddsHeaderView * headerView = [[DPLiveOddsHeaderView alloc]initWithTopLayer:YES bottomLayer:YES withHigh:kRowHeight withWidth:kScreenWidth lineColor:UIColorFromRGB(0x16242d)];
    headerView.backgroundColor = [UIColor clearColor ] ;
    headerView.textColors =  UIColorFromRGB(0x9badbb) ;
    headerView.titleFont = [UIFont dp_systemFontOfSize:11] ;
    [headerView createHeaderWithWidthArray:@[[NSNumber numberWithFloat:320/5.0*1.5],[NSNumber numberWithFloat:320/5.0],[NSNumber numberWithFloat:320/5.0],[NSNumber numberWithFloat:320/5.0*1.5]] whithHigh:kRowHeight withSeg:YES];
    [headerView setTitles:@[@"场次",@"主队" ,@"客队" ,@"场次"]];

    [self addSubview:headerView];
    [self.cellsArray addObject:headerView];

}

-(void)setMatchArray:(NSArray *)matchArray{
    if (_matchArray == matchArray) {
        return;
    }

    _matchArray = matchArray;

    if (self.cellsArray.count - 1 < matchArray.count) {
        for (int i = 0; i < matchArray.count; i++) {
            DPLiveOddsHeaderView *view = [[DPLiveOddsHeaderView alloc]initWithTopLayer:NO bottomLayer:YES withHigh:kRowHeight withWidth:kScreenWidth lineColor:UIColorFromRGB(0x16242d)];
            view.backgroundColor = [UIColor clearColor];
            view.textColors = [UIColor dp_flatWhiteColor];
            view.titleFont = [UIFont dp_systemFontOfSize:11];
            [view createHeaderWithWidthArray:@[ [NSNumber numberWithFloat:320 / 5.0 * 1.5], [NSNumber numberWithFloat:320 / 5.0], [NSNumber numberWithFloat:320 / 5.0], [NSNumber numberWithFloat:320 / 5.0 * 1.5] ] whithHigh:kRowHeight withSeg:YES];
           
            DPOptimizeMatch *matchOption = [matchArray objectAtIndex:i] ;
            [view setTitles:[self headViewTitle:matchOption]];

            [self addSubview:view];
            [self.cellsArray addObject:view];
        }
        [self setNeedsLayout];
    }else{
        for (int i = 0; i<matchArray.count; i++) {
            DPLiveOddsHeaderView *view = [self.cellsArray objectAtIndex:i+1] ;
            DPOptimizeMatch *matchOption = [matchArray objectAtIndex:i] ;
            [view setTitles:[self headViewTitle:matchOption]];

        }
    }
}

-(NSArray*)headViewTitle:(DPOptimizeMatch*)match{

    NSArray *arr = @[match.matchName, match.homeTeamName, match.awayTeamName, [NSString stringWithFormat:@"(%@)%@",match.typeName,match.spNum]];
    return arr ;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat offsetY = 5;
    for (int i =0 ; i<self.cellsArray.count; i++) {
        DPLiveOddsHeaderView * view = self.cellsArray[i] ;
        view.frame = CGRectMake(0, offsetY, kScreenWidth, kRowHeight) ;
        offsetY+=kRowHeight ;
    }
}

@end


#pragma mark -加减视图

@interface DPMinusPlusView (){
     @private
    UILabel *_leftLine ;
    UILabel *_rightLine ;


}

@property(nonatomic, strong)UIButton *minusBtn ;
@property(nonatomic, strong)UIButton *plusBtn ;
 
@end

@implementation DPMinusPlusView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.font = [UIFont dp_systemFontOfSize:15] ;
        self.keyboardType = UIKeyboardTypeNumberPad ;
        self.textColor = [UIColor dp_flatRedColor] ;
        self.leftView = self.minusBtn ;
        self.rightView = self.plusBtn ;
        self.rightViewMode = UITextFieldViewModeAlways ;
        self.leftViewMode = UITextFieldViewModeAlways ;
        self.textAlignment = NSTextAlignmentCenter ;
        
        _leftLine = ({
            UILabel *lab = [[UILabel alloc]init];
            lab.backgroundColor = kLineColor ;
            lab ;
        });
        
        _rightLine = ({
            UILabel *lab = [[UILabel alloc]init];
            lab.backgroundColor = kLineColor ;
            lab ;
        });
        
        [self addSubview:_leftLine];
        [self addSubview:_rightLine];
        
     }
    return self;
}


-(void)layoutSubviews{

    [super layoutSubviews];
    
    _leftLine.frame = CGRectMake(24, 0, 0.5, CGRectGetHeight(self.bounds)) ;
    _rightLine.frame = CGRectMake(CGRectGetWidth(self.bounds) - 24, 0, 0.5, CGRectGetHeight(self.bounds)) ;
    
}




-(UIButton*)minusBtn{

    if (_minusBtn == nil) {
        _minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _minusBtn.backgroundColor = [UIColor clearColor] ;
        _minusBtn.titleLabel.font = [UIFont dp_boldArialOfSize:20] ;
        _minusBtn.frame = CGRectMake(0, 0, 24, 24) ;
        [_minusBtn setImage:dp_SportLotteryImage(@"minus.png") forState:UIControlStateNormal];
        [_minusBtn setTitleColor:UIColorFromRGB(0x7e6b5a) forState:UIControlStateNormal];
     }
    
    return _minusBtn ;
}

-(UIButton*)plusBtn{
    
    if (_plusBtn == nil) {
        _plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _plusBtn.backgroundColor = [UIColor clearColor] ;
        [_plusBtn setImage:dp_SportLotteryImage(@"plus.png") forState:UIControlStateNormal];
         [_plusBtn setTitleColor:UIColorFromRGB(0x7e6b5a) forState:UIControlStateNormal];
         _plusBtn.titleLabel.font = [UIFont dp_boldArialOfSize:20] ;
        _plusBtn.frame = CGRectMake(0, 0, 24, 24) ;
    }
    
    return _plusBtn ;
}


@end


@interface DPJczqOptimizeCell ()<UITextFieldDelegate>

@property(nonatomic,strong) UILabel* matchLabel ;//比赛名称

@property(nonatomic,strong) UIImageView* rightImgView ;

@property(nonatomic, strong) UIView *topView ;

 @property(nonatomic, strong) UIView *bottomView ;

@property (nonatomic, strong) DPMatchInfoView *middleView ;


@property(nonatomic,strong)UILabel *priceLab ;
@property(nonatomic,strong)DPMinusPlusView *countView ;



@end

@implementation DPJczqOptimizeCell


- (id)initWithCellStyle:(OptimizeCellType)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor dp_flatWhiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildLayout:style];
    }
    
    return self;
}

-(void)analysisViewIsExpand:(BOOL)isExpand{
    if (isExpand) {
        self.rightImgView.highlighted = NO ;
    }else{
        self.rightImgView.highlighted = YES ;
        
    }
}

-(void)buildLayout:(OptimizeCellType)style{
    
    UIView* contentView = self.contentView ;
    contentView.userInteractionEnabled  =YES ;
    
    [contentView addSubview:self.topView];

    UIImageView* rightImg = self.rightImgView ;
    rightImg.userInteractionEnabled = YES  ;
    [rightImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onMatchInfo)]];
    
    [contentView addSubview:rightImg];
    [contentView addSubview:self.matchLabel];
    
    [self.matchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(10) ;
        make.right.equalTo(contentView).offset(-40) ;
         make.top.equalTo(contentView) ;
        make.height.mas_equalTo(38) ;

     }] ;
    
    [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-15) ;
         make.centerY.equalTo(self.matchLabel.mas_centerY) ;
        make.width.and.height.mas_equalTo(25);
    }] ;
    

    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView);
        make.left.equalTo(contentView).offset(-0.5) ;
        make.right.equalTo(contentView).offset(0.5) ;
//        make.bottom.equalTo(self.matchLabel).offset(12) ;
        make.bottom.equalTo(self.matchLabel).offset(0.5);

    }];
    
    [self buildBottomLayout];
    [contentView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView).offset(-5) ;
        make.left.equalTo(contentView).offset(-1) ;
        make.right.equalTo(contentView).offset(1) ;
        make.height.mas_equalTo(58) ;
    }];

    
    if (style == OptimizeCellTypeFold ) {
        [contentView addSubview:self.middleView];
        [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.matchLabel.mas_bottom);
            make.left.and.right.equalTo(contentView);
            make.bottom.equalTo(self.bottomView.mas_top);
        }];
        
                
        UIImageView *imgview = [[UIImageView alloc]initWithImage:dp_SportLotteryImage(@"optim_arrow.png")];
        imgview.contentMode = UIViewContentModeCenter ;
        imgview.backgroundColor = [UIColor clearColor] ;
        [contentView addSubview:imgview];
        [imgview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.middleView.mas_top) ;
            make.centerX.equalTo(self.rightImgView) ;
        }];
        
    }
    
}

 -(void)buildBottomLayout{

    UIView *contentView  = self.bottomView ;
    
    UILabel *vLeftLine = ({
        UILabel *lab = [[UILabel alloc]init] ;
        lab.backgroundColor = kLineColor ;
        lab ;
    });
    
    UILabel *vRightLine = ({
        UILabel *lab = [[UILabel alloc]init] ;
        lab.backgroundColor = kLineColor ;
        lab ;
    });
    
    UILabel *hLine = ({
        UILabel *lab = [[UILabel alloc]init] ;
        lab.backgroundColor = kLineColor ;
        lab ;
    });

    
    UILabel *priceLabel = [self createLabelWithText:@"单注奖金 (元)" color:UIColorFromRGB(0x999999) font:11] ;
    UILabel *countLabel = [self createLabelWithText:@"注数" color:UIColorFromRGB(0x999999) font:11] ;
    UILabel *awardLabel = [self createLabelWithText:@"奖金 (元)" color:UIColorFromRGB(0x999999) font:11] ;
    
    [contentView addSubview:priceLabel];
    [contentView addSubview:countLabel];
    [contentView addSubview:awardLabel];
    [contentView addSubview:self.priceLab];
    [contentView addSubview:self.countView];
    [contentView addSubview:self.awardLab];
    
    [contentView addSubview:vLeftLine];
    [contentView addSubview:vRightLine];
    [contentView addSubview:hLine];
    
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(contentView) ;
        make.width.equalTo(contentView).dividedBy(3) ;
        make.height.mas_equalTo(22) ;
    }];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView) ;
        make.left.equalTo(priceLabel.mas_right) ;
        make.width.equalTo(contentView).dividedBy(3) ;
        make.height.mas_equalTo(22) ;
     }];
    [awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView) ;
        make.left.mas_equalTo(countLabel.mas_right) ;
        make.width.equalTo(contentView).dividedBy(3) ;
        make.height.mas_equalTo(22) ;
     }];
    
    [vLeftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLabel.mas_right) ;
        make.top.and.bottom.equalTo(contentView) ;
        make.width.mas_equalTo(0.5) ;
    }] ;
    [vRightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(countLabel.mas_right) ;
        make.top.and.bottom.equalTo(contentView) ;
        make.width.mas_equalTo(0.5) ;
    }] ;
    
    [hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(contentView) ;
        make.top.equalTo(contentView).offset(23) ;
        make.height.mas_equalTo(0.5) ;
    }];
    
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceLabel.mas_bottom) ;
        make.left.and.right.equalTo(priceLabel) ;
        make.bottom.equalTo(contentView) ;
    }];
    
    [self.countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(countLabel.mas_bottom).offset(5) ;
        make.left.equalTo(countLabel).offset(5) ;
        make.right.equalTo(countLabel).offset(-5) ;
        make.bottom.equalTo(contentView).offset(-5) ;
    }];
    
    [self.awardLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(awardLabel.mas_bottom) ;
        make.left.and.right.equalTo(awardLabel) ;
        make.bottom.equalTo(contentView) ;
    }];
}

-(UILabel*)createLabelWithText:(NSString *)text color:(UIColor *)color font:(CGFloat)font  {
    
    UILabel *lab = [[UILabel alloc]init];
    lab.textColor = color ;
    lab.text = text ;
    lab.textAlignment = NSTextAlignmentCenter ;
    lab.font = [UIFont dp_systemFontOfSize:font] ;
    lab.backgroundColor = [UIColor clearColor] ;
    
    return lab ;
}


#pragma mark -响应事件
- (void)pvt_onMatchInfo {
    DPLog(@"查看详情") ;
    self.modelData.unfold = !self.rightImgView.highlighted ;
     self.rightImgView.highlighted = !self.rightImgView.highlighted ;
    if (self.showMatch) {
        self.showMatch(self) ;
    }
    
}

-(void)minOrPlusBtnClick:(UIButton*)sender{
    
    int issue = [self.countView.text intValue] ;
    
    if (sender == self.countView.minusBtn) {
        issue-- ;
    }else{
        issue ++ ;
    }
    if (issue<0) {
        return ;
    }
    self.lastNumString = self.countView.text ;
    self.countView.text = [NSString stringWithFormat:@"%d",issue] ;
    [self changeFieldCount];
    
}



#pragma mark- getter 

-(UIView*)topView{

    if (_topView == nil) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = [UIColor dp_flatBackgroundColor] ;
        _topView.layer.borderColor = kLineColor.CGColor ;
        _topView.layer.borderWidth = 0.5 ;
    }
    return _topView ;
}

-(UILabel*)priceLab{
    if (_priceLab == nil) {
        _priceLab = [self createLabelWithText:@"12.33" color:[UIColor dp_flatRedColor] font:15 ];
    }
    
    return _priceLab ;
}

-(DPMinusPlusView*)countView{

    if (_countView == nil) {
        _countView = [[DPMinusPlusView alloc]init];
        _countView.backgroundColor = [UIColor dp_flatWhiteColor] ;
        _countView.layer.borderColor = kLineColor.CGColor ;
        _countView.layer.borderWidth = 0.5 ;
        _countView.text = @"1" ;
        _countView.delegate = self ;
        [_countView.plusBtn addTarget:self action:@selector(minOrPlusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_countView.minusBtn addTarget:self action:@selector(minOrPlusBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        _countView.inputAccessoryView = ({
            UIView *line = [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
            line.bounds = CGRectMake(0, 0, 0, 0.5f);
            
            line;
        });
        
        [_countView addTarget:self action:@selector(changeFieldCount) forControlEvents:UIControlEventEditingChanged];
    }
    
    return _countView ;
}

-(UILabel*)awardLab{
    
    if (_awardLab == nil) {
        _awardLab = [self createLabelWithText:@"240000000000000" color:[UIColor dp_flatRedColor] font:15];
    }
    
    return _awardLab ;
}

-(DPMatchInfoView*)middleView{

    if (_middleView == nil) {
        _middleView = [[DPMatchInfoView alloc]init];
        _middleView.backgroundColor = UIColorFromRGB(0x30414b);
     }
    
    return _middleView ;
}

-(UIView*)bottomView{

    if (_bottomView == nil) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor =  [UIColor dp_flatBackgroundColor] ;
        _bottomView.layer.borderColor = kLineColor.CGColor ;
        _bottomView.layer.borderWidth = 0.5 ;
    }
    
    return _bottomView ;
}

-(UILabel*)matchLabel{
    
    if (_matchLabel == nil) {
        _matchLabel = [[UILabel alloc]init];
        _matchLabel.numberOfLines = 1 ;
        _matchLabel.backgroundColor = [UIColor clearColor] ;
        _matchLabel.font = [UIFont dp_systemFontOfSize:11] ;
        _matchLabel.textColor = [UIColor dp_colorFromRGB:0x666666] ;
    }
    
    return _matchLabel ;
}


-(UIImageView *)rightImgView{

    if (_rightImgView == nil ) {
        _rightImgView = [[UIImageView alloc]initWithImage:dp_CommonImage(@"black_arrow_down.png") highlightedImage:dp_CommonImage(@"black_arrow_up.png")];
        _rightImgView.contentMode = UIViewContentModeCenter ;
    }
    
    return _rightImgView ;
}


#pragma mark- textFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.26 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [textField selectAll:self];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIMenuController.sharedMenuController setMenuVisible:NO];
        });
    });
    
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (![KTMValidator isNumber:string]) {
        return NO;
    }
    self.lastNumString = [NSString stringWithFormat:@"%ld",[textField.text integerValue]];
    return YES ;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{

    DPLog(@"textFieldDidEndEditing") ;
}
 
-(void)changeFieldCount{
    
    DPLog(@"textField ==== %@",self.countView.text) ;
    
    if (self.changeValue) {
       self.changeValue(self) ;
      }
}

-(void)setModelData:(DPJczqOptimizeModel *)modelData {

    _modelData = modelData ;
    
    self.matchLabel.text = modelData.passName ;
    self.rightImgView.highlighted = modelData.unfold  ;
    self.middleView.matchArray = modelData.matchInfoArray ;
    self.countView.text = [NSString stringWithFormat:@"%zd", modelData.betNumber] ;
    self.priceLab.text = [NSString stringWithFormat:@"%.2f",modelData.betPrice] ;
    self.awardLab.text = [NSString stringWithFormat:@"%.2f",[self.priceLab.text floatValue] * modelData.betNumber] ;
    
    self.lastNumString = self.countView.text ;

}

 
//+ (CGFloat)unfoldHeightForRowCount:(NSInteger)rowCount {
//    
//    return kRowHeight*(rowCount+1) + 5 + 5  ;
//    
//}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
