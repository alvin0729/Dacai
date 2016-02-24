//
//  DPIconTextCell.m
//  Jackpot
//
//  Created by mu on 15/8/18.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPIconTextCell.h"
@interface DPIconTextCell()<UITextFieldDelegate>

@end

@implementation DPIconTextCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorLine.backgroundColor = colorWithRGB(192, 192, 192);
        [self.separatorLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        //图标
        self.iconImage = [[UIImageView alloc]init];
        [self.contentView addSubview:self.iconImage];
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(@20);
            make.width.equalTo(@25);
            make.height.equalTo(@25);
        }];
       //输入框
        self.text = [[UITextField alloc]init];
        self.text.borderStyle = UITextBorderStyleNone;
        self.text.font = [UIFont systemFontOfSize:16];
        self.text.delegate = self;
        self.text.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.contentView addSubview:self.text];
        [self.text mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.left.equalTo(self.iconImage.mas_right).offset(20);
            make.right.mas_equalTo(0);
        }];
        
    }
    return self;
}
- (instancetype)initWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId = @"DPIconTextCell";
    DPIconTextCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [self initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
        if (indexPath.row == 0) {
            UIView *upLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
            upLineView.backgroundColor = colorWithRGB(192, 192, 192);
            [cell.contentView addSubview:upLineView];
        }
    }
    return cell;
}

#pragma mark---------data
//赋值
- (void)setObject:(DPUAObject *)object{
    [super setObject:object];
    self.iconImage.image = dp_AccountImage(object.subTitle);
    self.text.placeholder = object.title;
    self.text.text = object.value;
}
#pragma mark---------delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}



@end
