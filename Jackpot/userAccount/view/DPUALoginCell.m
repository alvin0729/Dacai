//
//  DPUALoginCell.m
//  Jackpot
//
//  Created by mu on 15/8/17.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页面目前有sxf做注释，如发生改动，请注明

#import "DPUALoginCell.h"
@interface DPUALoginCell()
/**
 *  btnSize
 */
@property (nonatomic, assign) CGSize btnSize;
@end

@implementation DPUALoginCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorLine.backgroundColor = UIColorFromRGB(0xc7c8cc);
        
        //属性介绍
        self.titleLab = [[UILabel alloc]init];
        self.titleLab.textColor = UIColorFromRGB(0x676767);
        self.titleLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.titleLab];
        //属性输入框
        self.textField  = [[UITextField alloc]init];
        self.textField.font = [UIFont systemFontOfSize:14];
        self.textField.textColor = UIColorFromRGB(0x676767);
        self.textField.clearButtonMode=UITextFieldViewModeWhileEditing;
        [self.contentView addSubview:self.textField];
        
        //点击选项
        self.cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cellBtn.backgroundColor = UIColorFromRGB(0xdc4e4c);
        self.cellBtn.layer.cornerRadius = 5;
        [self.cellBtn setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        self.cellBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [[self.cellBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
            self.textField.secureTextEntry = btn.selected ;
            if (self.btnBlock) {
                self.btnBlock(btn);
            }
        }];
        [self.contentView addSubview:self.cellBtn];

    }
    return self;
}
- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"DPUALoginCell";
    DPUALoginCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [self initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
        if (indexPath.row == 0) {
            UIView *upLineView = [[UIView alloc]init];
            upLineView.backgroundColor = UIColorFromRGB(0xc7c8cc);
            [cell.contentView addSubview:upLineView];
            [upLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(0.5);
            }];
            
        }
    }
    return cell;
}
//UI布局
- (void)layoutUI{
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(90);
    }];
    
    [self.cellBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(-16);
        if (self.object.describTitle.length>0) {
            make.size.mas_equalTo(CGSizeMake(95,36));
        }else if (self.object.describValue.length>0){
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }else{
           make.size.mas_equalTo(CGSizeMake(0, 0)); 
        }
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.titleLab.mas_right).offset(14);
        make.right.equalTo(self.cellBtn.mas_left).offset(-14);
        make.height.equalTo(self.contentView.mas_height);
    }];
    
    [self.separatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
}



#pragma mark---------data
//赋值
- (void)setObject:(DPUAObject *)object{
    [super setObject:object];
    self.titleLab.text = object.title;
    self.textField.placeholder = object.subTitle;
    [self.cellBtn setTitle:object.describTitle forState:UIControlStateNormal];
    if (object.describValue.length>0) {
        self.cellBtn.backgroundColor = [UIColor clearColor];
         [self.cellBtn setImage:dp_AccountImage(object.describValue) forState:UIControlStateNormal];
    }
    if (object.subValue.length>0) {
         [self.cellBtn setImage:dp_AccountImage(object.subValue) forState:UIControlStateSelected];
    }
    [self layoutUI];
}



@end
