//
//  DPUANoTroubleController.m
//  Jackpot
//
//  Created by mu on 15/8/20.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPUANoTroubleController.h"
#import "DPUABaseCell.h"
#import "DPUARequestData.h"
@interface DPUANoTroubleController()
@property (nonatomic, strong) DPUABaseCell *contentCell;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UISwitch *notrobleSwitch;
@property (nonatomic, strong) PBMPushItem *pushItem;
@end

@implementation DPUANoTroubleController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"比赛推送";
    [self.view addSubview:self.contentCell];
    self.view.backgroundColor = [UIColor dp_flatBackgroundColor];
    
    [self.contentCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(11);
        make.left.mas_equalTo(-1);
        make.right.mas_equalTo(1);
        make.height.mas_equalTo(56.5);
    }];
    [self.view addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentCell.mas_bottom).offset(15);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(12);
    }];

    @weakify(self);
    self.pushItem.pushDevice = [KTMUtilities pushDeviceToken];
    [DPUARequestData pushSetWithParam:self.pushItem Success:^(PBMPushItem *pushItem) {
        @strongify(self);
        self.pushItem = pushItem;
        self.notrobleSwitch.on = self.pushItem.notroble;
    } andFail:^(NSString *failMessage) {
        [[DPToast makeText:failMessage color:[UIColor dp_flatBlackColor]] show];
    }];

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dp_itemWithImage:dp_NavigationImage(@"back.png") target:self action:@selector(didBackTapped)];
}
- (void)didBackTapped{
    
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [DPUARequestData saveLivePushSetWithParam:self.pushItem Success:^{
        
    } andFail:^(NSString *failMessage) {
        [[DPToast makeText:failMessage color:[UIColor dp_flatBlackColor]] show];
    }];
}
- (DPUABaseCell *)contentCell{
    if (!_contentCell) {
        _contentCell = [[DPUABaseCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        _contentCell.textLabel.text = @"夜间防打扰";
        _contentCell.detailTextLabel.text = @"22:00~7:00开始的比赛不推送消息";
         _contentCell.detailTextLabel.textColor = ycolorWithRGB(0.73, 0.73, 0.74);
        _contentCell.imageView.image = dp_AccountImage(@"notrouble.png");
        _contentCell.layer.borderColor = UIColorFromRGB(0xc7c8cc).CGColor;
        _contentCell.layer.borderWidth = 0.5;
        _contentCell.contentView.backgroundColor = [UIColor dp_flatWhiteColor];
        _contentCell.separatorLine.hidden = YES;
        UISwitch *cellSwitch = [[UISwitch alloc]init];
        cellSwitch.onTintColor = [UIColor dp_flatRedColor];
        cellSwitch.on = self.noTrouble;
        self.notrobleSwitch =cellSwitch;
        [cellSwitch addTarget:self action:@selector(cellSwitchTapped:) forControlEvents:UIControlEventValueChanged];
        [_contentCell.contentView addSubview:cellSwitch];
        [cellSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_contentCell.contentView.mas_centerY);
            make.right.mas_equalTo(-20);
        }];
    }
    return _contentCell;
}
- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel dp_labelWithText:nil backgroundColor:[UIColor clearColor] textColor:UIColorFromRGB(0xccc5b5) font:[UIFont systemFontOfSize:12]];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.text = @"关闭夜间防打扰，关注比赛的信息将会在全天进行推送";
    }
    return _contentLabel;
}
- (void)cellSwitchTapped:(UISwitch *)sender{
    if (self.notroubleBlock) {
        self.notroubleBlock(sender.on);
    }
    self.pushItem.notroble = sender.on;
}

@end
