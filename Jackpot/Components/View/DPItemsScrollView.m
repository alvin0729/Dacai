//
//  DPItemsScrollView.m
//  Jackpot
//
//  Created by mu on 15/8/31.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPItemsScrollView.h"

@interface DPItemsScrollView()<UIScrollViewDelegate>

@end

@implementation DPItemsScrollView
- (instancetype)initWithFrame:(CGRect)frame andItems:(NSArray *)items{
    self  = [super initWithFrame:frame];
    if (self) {
        //按钮所在区域
        self.btnsView = [[UIView alloc]init];
        [self addSubview:self.btnsView];
        [self.btnsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-1);
            make.left.mas_equalTo(-1);
            make.right.mas_equalTo(1);
            self.btnViewHeight = make.height.mas_equalTo(37.5);
        }];
        
        
        UIView *btnsBottomLine = [[UIView alloc]init];
        btnsBottomLine.backgroundColor = UIColorFromRGB(0xd0cfcd);
        [self.btnsView addSubview:btnsBottomLine];
        [btnsBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        UIView *btnsUpLine = [[UIView alloc]init];
        btnsUpLine.backgroundColor = UIColorFromRGB(0xd0cfcd);
        [self.btnsView addSubview:btnsUpLine];
        [btnsUpLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        //指示器
        self.indirectorWidth = kScreenWidth/items.count;
        self.indirectorHeight = 3;
        self.indicatorView = [[UIView alloc]init];
        self.indicatorView.backgroundColor = [UIColor dp_flatRedColor];
        [self addSubview:self.indicatorView];
        [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.btnsView.mas_bottom);
            make.width.mas_equalTo(self.indirectorWidth);
            make.height.mas_equalTo(self.indirectorHeight);
            make.centerX.mas_equalTo(0);
        }];
        
        
        self.btnArray = [NSMutableArray array];
        //列表
        self.tablesView.contentSize = CGSizeMake(kScreenWidth*items.count, 0);
        [self addSubview:self.tablesView];
        [self.tablesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.btnsView.mas_bottom);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        self.viewArray = [NSMutableArray array];
        UIView *contentView = [[UIView alloc]init];
        contentView.backgroundColor = [UIColor clearColor];
        [self.tablesView addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tablesView.mas_top);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(self.tablesView.mas_height);
            make.width.mas_equalTo(kScreenWidth*items.count);
            make.centerY.mas_equalTo(self.tablesView.mas_centerY);
        }];
        
        CGFloat btnW = kScreenWidth/items.count;
        for (NSInteger i = 0; i < items.count; i++) {
            //选择按钮
            UIButton *btn = [[UIButton alloc]init];
            btn.tag = 100+i;
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitle:items[i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
            [self.btnsView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(btnW*i);
                make.bottom.mas_equalTo(0);
                make.width.mas_equalTo(btnW);
            }];
            [self.btnArray addObject:btn];
            
            UIView *tableView = [[UIView alloc]init];
            tableView.backgroundColor = [UIColor clearColor];
            [contentView addSubview:tableView];
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(kScreenWidth * i);
                make.bottom.mas_equalTo(0);
                make.width.mas_equalTo(kScreenWidth);
            }];
            [self.viewArray addObject:tableView];
        }
    }
    return self;
}
#pragma mark---------tablesView
- (UIScrollView *)tablesView{
    if (!_tablesView) {
        _tablesView = [[UIScrollView alloc]init];
        _tablesView.showsHorizontalScrollIndicator = NO ;
        _tablesView.delegate = self;
        _tablesView.pagingEnabled = YES;
    }
    return _tablesView;
}
#pragma mark---------function
//选择按钮点击
- (void)btnTapped:(UIButton *)btn{
    if (self.itemTappedBlock) {
        self.itemTappedBlock(btn);
    }
    
    if (btn.selected == NO) {
        self.currentBtn = btn;
        btn.selected = !btn.selected;
        self.lastBtn.selected = !btn.selected;
        self.lastBtn = btn;        
    }
    [self.tablesView setContentOffset:CGPointMake(kScreenWidth*(btn.tag-100), 0) animated:YES];
    
    [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn.mas_centerX);
        make.bottom.equalTo(self.btnsView.mas_bottom);
        make.width.mas_equalTo(self.indirectorWidth);
        make.height.mas_equalTo(self.indirectorHeight);
    }];
    
}

//scroll's delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger tag = scrollView.contentOffset.x/kScreenWidth;
    UIButton *btn= (UIButton *)[self.btnsView viewWithTag:100+tag];
    [self btnTapped:btn];
}
- (void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
    [self.tablesView setContentOffset:CGPointMake(kScreenWidth*_selectIndex, 0)];
    [self scrollViewDidEndDecelerating:self.tablesView];
}
@end
