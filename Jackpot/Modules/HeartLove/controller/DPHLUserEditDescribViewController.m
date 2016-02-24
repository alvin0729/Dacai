//
//  DPHLUserEditDescribViewController.m
//  Jackpot
//
//  Created by mu on 16/1/15.
//  Copyright © 2016年 dacai. All rights reserved.
//

#import "DPHLUserEditDescribViewController.h"
#import "Wages.pbobjc.h"
@interface DPHLUserEditDescribViewController ()<UITextViewDelegate>
@property (nonatomic, strong) UITextView *describText;
@property (nonatomic, strong) UILabel *describLengthLab;
@property (nonatomic, strong) UILabel *describLabel;
@property (nonatomic, copy) NSString *describStr;
@end

@implementation DPHLUserEditDescribViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupUI];
    [self setupConfig];
}
#pragma mark---------nav
- (void)setupNav{
    self.title = @"修改个人简历";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithTitle:@"取消" target:self action:@selector(cancelEdit)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithTitle:@"完成" target:self action:@selector(downEdit)];
}
//取消编辑
- (void)cancelEdit{
    [self.navigationController popViewControllerAnimated:YES];
}
//确定编辑
- (void)downEdit{
    if (self.describText.text.length==0) {
        [[DPToast makeText:@"请输入个人简介"]show];
        return;
    }
    
    EditWagesUserInput *userInput = [[EditWagesUserInput alloc] init];
    userInput.desription =self.describLabel.text;
    
    @weakify(self);
    [self showHUD];
    [[AFHTTPSessionManager dp_sharedManager] POST:@"/wages/EditUser" parameters:userInput success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self);
        [self dismissHUD];
        [[DPToast makeText:@"修改成功"] show];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.editSuccessBlock) {
            self.editSuccessBlock();
        }
    }failure:^(NSURLSessionDataTask *task, NSError *error) {
        @strongify(self);
        [self dismissHUD];
        [[DPToast makeText:[error dp_errorMessage]] show];
    }];
}
//初始化UI
- (void)setupUI{
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    UIView *describBgView = [[UIView alloc]init];
    describBgView.layer.borderColor = UIColorFromRGB(0xd0cfcd).CGColor;
    describBgView.layer.borderWidth = 0.5;
    describBgView.backgroundColor = [UIColor dp_flatWhiteColor];
    [self.view addSubview:describBgView];
    [describBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.left.mas_equalTo(-0.5);
        make.right.mas_equalTo(0.5);
        make.height.mas_equalTo(91);
    }];
    
    
    //编辑输入框
    self.describText = [[UITextView alloc]init];
    self.describText.textColor = UIColorFromRGB(0x999999);
    self.describText.font = [UIFont systemFontOfSize:14];
    self.describText.text = self.userDescrib;
    self.describText.delegate = self;
    @weakify(self);
    [self.describText.rac_textSignal subscribeNext:^(NSString *text) {
        @strongify(self);
        
        self.describLengthLab.text = [NSString stringWithFormat:@"%zd",15-text.length];
        self.describLabel.text = text;
    }];
    [describBgView addSubview:self.describText];
    [self.describText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.bottom.mas_equalTo(-12);
    }];
    
    //可输入字符长度
    self.describLengthLab = [UILabel dp_labelWithText:[NSString stringWithFormat:@"%zd",15-self.userDescrib.length] backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x999999) font:[UIFont systemFontOfSize:12]];
    [describBgView addSubview:self.describLengthLab];
    [self.describLengthLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(describBgView.mas_bottom).offset(-4);
        make.right.equalTo(describBgView.mas_right).offset(-16);
    }];
    
    //输入内容
    self.describLabel = [UILabel dp_labelWithText:self.userDescrib backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0x999999) font:[UIFont systemFontOfSize:12]];
    [self.view addSubview:self.describLabel];
    [self.describLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(describBgView.mas_bottom).offset(8);
        make.left.mas_equalTo(16);
    }];

}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location>14) {
        [[DPToast makeText:@"个人简历的输入框限制15个字符"]show];
        return NO;
    }else{
        return YES;
    }
}

- (void)setupConfig{
     [self.describText becomeFirstResponder];
}
@end
