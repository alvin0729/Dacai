//
//  DPAddBankView.m
//  Jackpot
//
//  Created by sxf on 15/8/25.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPAddBankView.h"


@interface DPAddBankView ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView ;
    NSString *_currentBankName ;
    NSString *_currentBankCode ;
    
    UIView* _bottomView ;
    
}
@property(nonatomic,strong,readonly)UIView *bottomView;

@end

@implementation DPAddBankView
@synthesize tableView = _tableView ;
@synthesize currentBankName = _currentBankName ;
@synthesize currentBankCode = _currentBankCode ;
@synthesize bottomView =_bottomView ;


-(void)commomInt{
    
    self.userInteractionEnabled = YES ;
    self.dataArray = [NSMutableArray array] ;
    self.codeArray = [NSMutableArray array] ;
    _currentBankName = @"" ;
    _currentBankCode = @"" ;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commomInt];
        
        UIView *contentView = [[UIView alloc]init];
        contentView.backgroundColor = UIColorFromRGB(0xE9E7E1);
        contentView.layer.cornerRadius = 7 ;
        contentView.layer.masksToBounds = YES ;
        
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(30) ;
            make.right.equalTo(self).offset(-30) ;
            make.height.equalTo(@(400));
            make.top.equalTo(self).offset(65) ;
        }];
        
        [contentView addSubview:self.tableView];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView) ;
            make.right.equalTo(contentView) ;
            make.height.equalTo(@(340));
            make.top.equalTo(contentView) ;
        }];
        
        [contentView addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView) ;
            make.right.equalTo(contentView) ;
            make.height.equalTo(@(60));
            make.top.equalTo(self.tableView.mas_bottom) ;
        }];
        
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.6] ;
        
    }
    return self;
}

-(NSString*)currentBankName{
    if (_currentBankName == nil) {
        _currentBankName = @"" ;
    }
    return _currentBankName ;
}
-(NSString*)currentBankCode{
    if (_currentBankCode == nil) {
        _currentBankCode = @"" ;
    }
    return _currentBankCode ;
}

-(UIView*)bottomView{
    if (_bottomView == nil) {
        _bottomView = ({
            UIView *bgView = [[UIView alloc]init];
            bgView.backgroundColor = UIColorFromRGB(0xFFFFFF) ;
            bgView.layer.shadowOffset = CGSizeMake(0, -2);
            bgView.layer.shadowRadius =3.0;
            bgView.layer.shadowColor =UIColorFromRGB(0xBBB8B6).CGColor;
            bgView.layer.shadowOpacity =0.86;
            
            UIButton *cancleBtn  = ({
                UIButton *button = [[UIButton alloc] init];
                [button setBackgroundColor:[UIColor colorWithRed:0.87 green:0.85 blue:0.82 alpha:1]];
                [button setTitle:@"取消" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont dp_systemFontOfSize:16]];
                [button setTag:333];
                button.layer.cornerRadius = 5 ;
                button.layer.masksToBounds = YES ;
                [button addTarget:self action:@selector(onCancelOrConfirm:) forControlEvents:UIControlEventTouchUpInside];
                button;
            });
            UIButton *confirmBtn = ({
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [button setBackgroundColor:[UIColor dp_flatRedColor]];
                [button setTitle:@"确定" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont dp_boldSystemFontOfSize:16]];
                [button setTag:334];
                button.layer.cornerRadius = 5 ;
                button.layer.masksToBounds = YES ;
                [button addTarget:self action:@selector(onCancelOrConfirm:) forControlEvents:UIControlEventTouchUpInside];
                button;
            });
            [bgView addSubview:cancleBtn];
            [bgView addSubview:confirmBtn];
            
            [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@110) ;
                make.centerY.equalTo(bgView) ;
                make.left.equalTo(bgView).offset(15) ;
            }];
            
            [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@110) ;
                make.centerY.equalTo(bgView) ;
                make.right.equalTo(bgView).offset(-15) ;
            }];
            
            bgView ;
            
        }) ;
    }
    
    return _bottomView ;
}

-(UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        _tableView.bounces = NO ;
        _tableView.rowHeight = 42.5 ;
        _tableView.delegate =self ;
        _tableView.dataSource =self ;
        _tableView.backgroundColor = UIColorFromRGB(0xE9E7E1) ;
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
        
    }
    
    return _tableView ;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count ;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CellIdentifier" ;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier] ;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIImageView *imgView= [[UIImageView alloc]initWithImage:dp_DigitLotteryImage(@"normal.png") highlightedImage:dp_DigitLotteryImage(@"pressed.png")] ;
        cell.accessoryView = imgView ;
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray ;
        
        cell.backgroundColor = UIColorFromRGB(0xE9E7E1) ;
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        
    }
    
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row] ;
    
    return cell ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DPLog(@"indexPath = %ld",(long)indexPath.row) ;
    _currentBankName = [self.dataArray objectAtIndex:indexPath.row] ;
    
    _currentBankCode = [self.codeArray objectAtIndex:indexPath.row] ;
    
}



- (void)onCancelOrConfirm:(UIButton *)button {
    
    BOOL isSure = NO ;
    if (button.tag == 333) {
        DPLog(@"取消") ;
    }else{
        DPLog(@"确定") ;
        isSure = YES ;
        
    }
    if (self.bankBlock) {
        self.bankBlock(_currentBankName,_currentBankCode,isSure) ;
    }
    [self removeFromSuperview];
    
}


@end
