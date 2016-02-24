//
//  DPIconNameSetViewController.m
//  Jackpot
//
//  Created by mu on 15/9/1.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页注释由sxf提供，如有更改，请标明

#import "DPIconNameSetViewController.h"
#import "UserAccount.pbobjc.h"
#import "UMComPushRequest.h"
#import "UMComLoginManager.h"
@interface DPIconNameSetViewController()<UIActionSheetDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIImageView *icon;//头像
@property (nonatomic, strong) UITextField *nameText;//昵称输入框
@property (nonatomic, strong) UIView *nameSetView;
@property (nonatomic, strong) UIButton *nameSetBtn;//编辑按钮
@property (nonatomic, strong) UIButton *saveBtn;//保存按钮
@property (nonatomic, strong) UIImagePickerController *imagePicker;//头像选择器
@property (nonatomic, strong) PBMUserNameIconParam *param;//头像昵称入参
@end

@implementation DPIconNameSetViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self initiralize];
}

- (void)initiralize{
    self.title = @"编辑信息";
    [self initiralizeData];
    [self initiralizeUI];
}
#pragma mark---------ui
- (void)initiralizeUI{

    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    //头像
    self.icon = [[UIImageView alloc]init];
    self.icon.layer.cornerRadius =40;
    self.icon.layer.masksToBounds = YES;
    self.icon.userInteractionEnabled = YES;
    
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.userInfo.userIcon] ]] ;
    [self.icon setImageWithURL:[NSURL URLWithString:self.userInfo.userIcon] placeholderImage:dp_AccountImage(@"UAIconDefalt.png")];
    UITapGestureRecognizer *iconTappedGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconTapped)];
    [self.icon addGestureRecognizer:iconTappedGesture];
    [self.view addSubview:self.icon];
    [self.view addSubview:self.nameSetView];
    //保存按钮
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveBtn.layer.cornerRadius = 8 ;
    self.saveBtn.backgroundColor = UIColorFromRGB(0xdc4e4c);
    [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveBtn setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
    [self.saveBtn addTarget:self action:@selector(saveBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveBtn];
    
    [self layoutUI];
    
}
//nameSetView
- (UIView *)nameSetView{
    if (!_nameSetView) {
        _nameSetView = [[UIView alloc]init];
        _nameSetView.layer.borderColor = UIColorFromRGB(0xd5d6b1).CGColor;
        _nameSetView.layer.borderWidth = 0.66;
        _nameSetView.backgroundColor = [UIColor dp_flatWhiteColor];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.text = @"昵称:";
        nameLabel.textColor = UIColorFromRGB(0x333333);
        nameLabel.font = [UIFont systemFontOfSize:16];
        [_nameSetView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.bottom.mas_equalTo(0);
        }];
        
        self.nameText = [[UITextField alloc]init];
        self.nameText.delegate = self;
        self.nameText.placeholder = @"请输入购彩昵称";
        self.nameText.text = self.userInfo.userName;
        self.nameText.borderStyle = UITextBorderStyleNone;
        self.nameText.textAlignment = NSTextAlignmentCenter;
        self.nameText.textColor = UIColorFromRGB(0x676767);
        [_nameSetView addSubview:self.nameText];
        self.nameText.clearButtonMode=UITextFieldViewModeWhileEditing;
        [self.nameText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        UIButton *nameSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [nameSetBtn setImage:dp_AccountImage(@"UANameSetIcon.png") forState:UIControlStateNormal];
        [nameSetBtn addTarget:self action:@selector(nameSetBtnTapped) forControlEvents:UIControlEventTouchUpInside];
        [_nameSetView addSubview:nameSetBtn];
        self.nameSetBtn = nameSetBtn;
        [nameSetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_nameSetView.mas_centerY);
            make.right.mas_equalTo(-15);
        }];
        
    }
    return _nameSetView;
}
//自动布局
- (void)layoutUI {
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(35);
        make.size.mas_equalTo(CGSizeMake(80,80));
    }];
    
    [self.nameSetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_bottom).offset(35);
        make.left.mas_equalTo(-1);
        make.right.mas_equalTo(1);
        make.height.mas_equalTo(45);
    }];
    
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameSetView.mas_bottom).offset(15);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
    }];
}
#pragma mark---------imagerPicker
- (UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
    }
    return _imagePicker;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    CGFloat width = image.dp_width;
    CGFloat height = image.dp_height;
    CGFloat length = MIN(width, height);
    CGFloat scale = MAX(1, [UIScreen mainScreen].scale);
    
    image = [image dp_croppedImage:CGRectMake((width - length) / 2, (height - length) / 2, length, length)];
    image = [image dp_resizedImageToSize:CGSizeMake(80 * scale / image.scale, 80 * scale / image.scale)];
    
    NSData *iconData = UIImageJPEGRepresentation(image, 0.9);
    self.param.icon = iconData;
    self.icon.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark---------function
//点击头像
- (void)iconTapped{
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照", nil];
    [action showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0://从相册选择
        {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        }
            break;
        case 1://拍照
        {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        }
            break;
        case 2://取消
        {

        }
            break;
        default:
            break;
    }
}
//昵称编辑
- (void)nameSetBtnTapped{
    [self.nameText becomeFirstResponder];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
//textfiled's delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.nameSetBtn.hidden = YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.nameSetBtn.hidden = NO;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    self.nameSetBtn.hidden = NO;
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *text = [textField.text stringByAppendingString:string];
    self.nameSetBtn.hidden = text.length>0;
    return YES;
}
//提交昵称头像
- (void)saveBtnTapped{
    if (self.nameText.text.length<=0) {
        [[DPToast makeText:@"请输入昵称" color:[UIColor dp_flatBlackColor]] show];;
        return;
    }
    
    self.param.nickName = self.nameText.text;
    BOOL temp = [self.param.nickName isEqualToString:self.userInfo.userName];
    if (temp==NO|| self.param.icon.length>0) {
        [self showHUD];
        @weakify(self);
        [DPUARequestData setHeaderIconAndNicknameWithParam:self.param Success:^(PBMUserNameIconItem *result) {
            @strongify(self);
            [DPMemberManager sharedInstance].iconImageURL = result.iconURL;
            [[DPMemberManager sharedInstance] resetNickName:result.nickName];
            [self dismissHUD];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } andFail:^(NSString *failMessage) {
            @strongify(self);
            [self dismissHUD];
            [[DPToast makeText:failMessage color:[UIColor dp_flatBlackColor]] show];
        }];
    }else{
        [[DPToast makeText:@"请修改昵称或头像" color:[UIColor dp_flatBlackColor]] show];
    }
    
    UMComUserAccount *userAccount = [[UMComUserAccount alloc]init];
    userAccount.iconImage = [DPMemberManager sharedInstance].iconImage;
    userAccount.name = self.nameText.text;
    [UMComPushRequest updateWithUser:userAccount completion:^(NSError *error) {
        if (!error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"update user profile success!" object:self];
            
        }
    }];
}
#pragma mark---------data
- (void)initiralizeData{
    self.param = [[PBMUserNameIconParam alloc]init];
}
@end



