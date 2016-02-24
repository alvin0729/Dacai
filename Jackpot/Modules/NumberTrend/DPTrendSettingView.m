//
//  DPTrendSettingView.m
//  DacaiProject
//
//  Created by wufan on 15/2/28.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPTrendSettingView.h"
#import "DPImageLabel.h"

#define kTrendPreferSetterKey @"kTrendPreferSetterKey"
#define kTrendPreferRowCountKey @"kTrendPreferRowCountKey"
#define kTrendPreferMissOnKey @"kTrendPreferMissOnKey"
#define kTrendPreferBrokenOnKey @"kTrendPreferBrokenOnKey"
#define kTrendPreferStatOnKey @"kTrendPreferStatOnKey"
#define kTrendPreferInfoOnKey @"kTrendPreferInfoOnKey"


static const NSInteger tagIssueTag1 = 101;
static const NSInteger tagIssueTag2 = 102;
static const NSInteger tagIssueTag3 = 103;
static const NSInteger tagIssueTag4 = 104;

static const NSInteger tagMissValueOn = 201;
static const NSInteger tagMissValueOff = 202;

static const NSInteger tagBrokenLineOn = 301;
static const NSInteger tagBrokenLineOff = 302;

static const NSInteger tagStatisticsOn = 401;
static const NSInteger tagStatisticsOff = 402;

static const NSInteger tagInformationOn = 501;
static const NSInteger tagInformationOff = 502;

static const NSInteger tagButtonCancel = 601;
static const NSInteger tagButtonConfirm = 602;

@interface DPTrendSettingView () {
    
}

@property (nonatomic, strong) UIView *lineView1;
@property (nonatomic, strong) UIView *lineView2;

@property (nonatomic, strong) DPImageLabel *titleLabel;
@property (nonatomic, strong) UILabel *helpLabel;

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UILabel *issueLabel;
@property (nonatomic, strong) UILabel *missLabel;
@property (nonatomic, strong) UILabel *brokenLabel;
@property (nonatomic, strong) UILabel *statLabel;
@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, strong) UIButton *issue1Item;
@property (nonatomic, strong) UIButton *issue2Item;
@property (nonatomic, strong) UIButton *issue3Item;
@property (nonatomic, strong) UIButton *issue4Item;

@property (nonatomic, strong) UIButton *missOnItem;
@property (nonatomic, strong) UIButton *missOffItem;

@property (nonatomic, strong) UIButton *brokenOnItem;
@property (nonatomic, strong) UIButton *brokenOffItem;

@property (nonatomic, strong) UIButton *statOnItem;
@property (nonatomic, strong) UIButton *statOffItem;

@property (nonatomic, strong) UIButton *infoOnItem;
@property (nonatomic, strong) UIButton *infoOffItem;

@property (nonatomic, strong) UILabel *statDescLabel;
@property (nonatomic, strong) UILabel *infoDescLabel;
@end

@implementation DPTrendSettingView
@dynamic issueIndex;
@dynamic missOn;
@dynamic brokenOn;
@dynamic statOn;
@dynamic infoOn;

- (UIButton *)generateItem:(NSString *)title tag:(NSInteger)tag {
    UIButton *button = [[UIButton alloc] init];
    [button setImage:dp_DigitLotteryImage(@"normal.png") forState:UIControlStateNormal];
    [button setImage:dp_DigitLotteryImage(@"pressed.png") forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateSelected];
    [button setTitleColor:[UIColor colorWithRed:0.9 green:0.1 blue:0.11 alpha:1] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont dp_systemFontOfSize:14]];
    [button setTag:tag];
    [button addTarget:self action:@selector(onSelected:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UILabel *)generateLabel:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor dp_flatBlackColor];
    label.font = [UIFont dp_systemFontOfSize:15];
    label.text = title;
    return label;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupViews];
        [self buildLayout];
        [self pvt_loadUserPrefer];
    }
    return self;
}

- (void)setupViews {
    self.lineView1 = [[UIView alloc] init];
    self.lineView1.backgroundColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1];
    self.lineView2 = [[UIView alloc] init];
    self.lineView2.backgroundColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1];
    
    self.titleLabel = ({
        UIImage *image = dp_DigitLotteryImage(@"setter.png");
        image = [image dp_imageWithTintColor:[UIColor dp_flatBlueColor]];
        DPImageLabel *label = [[DPImageLabel alloc] init];
        label.image = image;
        label.text = @"走势图设置";
        label.font = [UIFont dp_systemFontOfSize:15];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor dp_flatBlackColor];
        label.imagePosition = DPImagePositionLeft;
        label;
    });
    self.helpLabel = ({
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:@"走势图帮助"];
        NSRange range = { 0, content.length };
        [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
        [content addAttribute:NSForegroundColorAttributeName value:[UIColor dp_flatBlueColor] range:range];
        [content addAttribute:NSFontAttributeName value:[UIFont dp_systemFontOfSize:13] range:range];
        
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.attributedText = content;
        label.userInteractionEnabled = YES;
        label;
    });
    
    [self.helpLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapHelp)]];
    
    self.cancelButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundColor:[UIColor colorWithRed:0.87 green:0.85 blue:0.82 alpha:1]];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_flatBlackColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_systemFontOfSize:16]];
        [button setTag:tagButtonCancel];
        [button addTarget:self action:@selector(onCancelOrConfirm:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    self.confirmButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundColor:[UIColor dp_flatRedColor]];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont dp_boldSystemFontOfSize:16]];
        [button setTag:tagButtonConfirm];
        [button addTarget:self action:@selector(onCancelOrConfirm:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    self.statDescLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:0.6 green:0.53 blue:0.48 alpha:1];
        label.text = @"(走势图底部展现出现次数等统计数据)";
        label.font = [UIFont dp_systemFontOfSize:11];
        label;
    });
    self.infoDescLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:0.6 green:0.53 blue:0.48 alpha:1];
        label.text = @"(走势图底部为选择期数的统计数据)";
        label.font = [UIFont dp_systemFontOfSize:11];
        label;
    });
    
    self.issueLabel = [self generateLabel:@"期数："];
    self.missLabel = [self generateLabel:@"遗漏："];
    self.brokenLabel = [self generateLabel:@"折线："];
    self.statLabel = [self generateLabel:@"统计："];
    self.infoLabel = [self generateLabel:@"数据："];
    
    self.issue1Item = [self generateItem:@"50期" tag:tagIssueTag1];
    self.issue2Item = [self generateItem:@"100期" tag:tagIssueTag2];
    self.issue3Item = [self generateItem:@"150期" tag:tagIssueTag3];
    self.issue4Item = [self generateItem:@"200期" tag:tagIssueTag4];
    
    self.missOnItem = [self generateItem:@"显示遗漏" tag:tagMissValueOn];
    self.missOffItem = [self generateItem:@"隐藏遗漏" tag:tagMissValueOff];
    
    self.brokenOnItem = [self generateItem:@"显示折线" tag:tagBrokenLineOn];
    self.brokenOffItem = [self generateItem:@"隐藏折线" tag:tagBrokenLineOff];
    
    self.statOnItem = [self generateItem:@"显示统计" tag:tagStatisticsOn];
    self.statOffItem = [self generateItem:@"隐藏统计" tag:tagStatisticsOff];
    
    self.infoOnItem = [self generateItem:@"选定期数" tag:tagInformationOn];
    self.infoOffItem = [self generateItem:@"所有期数" tag:tagInformationOff];
    
    self.issue1Item.selected = self.missOnItem.selected = self.brokenOnItem.selected = self.statOnItem.selected = self.infoOnItem.selected = YES;
    
    // 根据需求, 隐藏200期
    self.issue4Item.hidden = YES;
}

- (void)buildLayout {
    [self setBackgroundColor:[UIColor dp_flatWhiteColor]];
    [self addSubview:self.titleLabel];
    [self addSubview:self.helpLabel];
    [self addSubview:self.cancelButton];
    [self addSubview:self.confirmButton];
    [self addSubview:self.lineView1];
    [self addSubview:self.lineView2];
    
    [self addSubview:self.issueLabel];
    [self addSubview:self.missLabel];
    [self addSubview:self.brokenLabel];
    [self addSubview:self.statLabel];
    [self addSubview:self.infoLabel];
    [self addSubview:self.statDescLabel];
    [self addSubview:self.infoDescLabel];
    
    [self addSubview:self.issue1Item];
    [self addSubview:self.issue2Item];
    [self addSubview:self.issue3Item];
    [self addSubview:self.issue4Item];
    [self addSubview:self.missOnItem];
    [self addSubview:self.missOffItem];
    [self addSubview:self.brokenOnItem];
    [self addSubview:self.brokenOffItem];
    [self addSubview:self.statOnItem];
    [self addSubview:self.statOffItem];
    [self addSubview:self.infoOnItem];
    [self addSubview:self.infoOffItem];
}

- (CGSize)intrinsicContentSize {
    if (([self.dp_viewController supportedInterfaceOrientations] & UIInterfaceOrientationMaskLandscape) && [UIDevice dp_orientationIsLandscape]) {
        return CGSizeMake(450, 260);
    } else {
        return CGSizeMake(305, 330);
    }
}

- (void)layoutSubviews {
    //
    self.titleLabel.frame = CGRectMake(10, 0, self.titleLabel.dp_intrinsicWidth, 35);
    self.helpLabel.frame = CGRectMake(CGRectGetWidth(self.bounds) - self.helpLabel.dp_intrinsicWidth - 15, 0, self.helpLabel.dp_intrinsicWidth, 35);
    //
    self.lineView1.frame = CGRectMake(0, 35, CGRectGetWidth(self.bounds), 0.5);
    self.lineView2.frame = CGRectMake(15, CGRectGetHeight(self.bounds) - 60, CGRectGetWidth(self.bounds) - 30, 0.5);
    //
    CGFloat width = (CGRectGetWidth(self.bounds) - 20 - 20 - 10) / 2;
    CGFloat y = CGRectGetHeight(self.bounds) - 60 + 12;
    self.cancelButton.frame = CGRectMake(20, y, width, 35);
    self.confirmButton.frame = CGRectMake(20 + width + 10, y, width, 35);
    
    if (([self.dp_viewController supportedInterfaceOrientations] & UIInterfaceOrientationMaskLandscape) && [UIDevice dp_orientationIsLandscape]) {
        self.issueLabel.frame = CGRectMake(20, 35 + 10, self.issueLabel.dp_intrinsicWidth, self.issueLabel.dp_intrinsicHeight);
        self.missLabel.frame = CGRectMake(20, 35 + 40, self.missLabel.dp_intrinsicWidth, self.missLabel.dp_intrinsicHeight);
        self.brokenLabel.frame = CGRectMake(20, 35 + 70, self.brokenLabel.dp_intrinsicWidth, self.brokenLabel.dp_intrinsicHeight);
        self.statLabel.frame = CGRectMake(20, 35 + 100, self.statLabel.dp_intrinsicWidth, self.statLabel.dp_intrinsicHeight);
        self.infoLabel.frame = CGRectMake(20, 35 + 130, self.infoLabel.dp_intrinsicWidth, self.infoLabel.dp_intrinsicHeight);
        
        self.issue1Item.frame = CGRectMake(65, CGRectGetMinY(self.issueLabel.frame) + (CGRectGetHeight(self.issueLabel.frame) - 25) / 2, self.issue1Item.dp_intrinsicWidth, 25);
        self.issue2Item.frame = CGRectMake(65 + 95, CGRectGetMinY(self.issue1Item.frame), self.issue2Item.dp_intrinsicWidth, 25);
        self.issue3Item.frame = CGRectMake(65 + 95 * 2, CGRectGetMinY(self.issue1Item.frame), self.issue3Item.dp_intrinsicWidth, 25);
        self.issue4Item.frame = CGRectMake(65 + 95 * 3, CGRectGetMinY(self.issue1Item.frame), self.issue4Item.dp_intrinsicWidth, 25);
        
        self.missOnItem.frame = CGRectMake(65, CGRectGetMinY(self.missLabel.frame) + (CGRectGetHeight(self.missLabel.frame) - 25) / 2, self.missOnItem.dp_intrinsicWidth, 25);
        self.missOffItem.frame = CGRectMake(65 + 95, CGRectGetMinY(self.missOnItem.frame), self.missOffItem.dp_intrinsicWidth, 25);
        
        self.brokenOnItem.frame = CGRectMake(65, CGRectGetMinY(self.brokenLabel.frame) + (CGRectGetHeight(self.brokenLabel.frame) - 25) / 2, self.brokenOnItem.dp_intrinsicWidth, 25);
        self.brokenOffItem.frame = CGRectMake(65 + 95, CGRectGetMinY(self.brokenOnItem.frame), self.brokenOffItem.dp_intrinsicWidth, 25);
        
        self.statOnItem.frame = CGRectMake(65, CGRectGetMinY(self.statLabel.frame) + (CGRectGetHeight(self.statLabel.frame) - 25) / 2, self.statOnItem.dp_intrinsicWidth, 25);
        self.statOffItem.frame = CGRectMake(65 + 95, CGRectGetMinY(self.statOnItem.frame), self.statOffItem.dp_intrinsicWidth, 25);
        self.statDescLabel.frame = CGRectMake(CGRectGetMaxX(self.statOffItem.frame) + 5, CGRectGetMinY(self.statLabel.frame) + (CGRectGetHeight(self.statLabel.frame) - self.statDescLabel.dp_intrinsicHeight) / 2, self.statDescLabel.dp_intrinsicWidth, self.statDescLabel.dp_intrinsicHeight);
        
        self.infoOnItem.frame = CGRectMake(65, CGRectGetMinY(self.infoLabel.frame) + (CGRectGetHeight(self.infoLabel.frame) - 25) / 2, self.infoOnItem.dp_intrinsicWidth, 25);
        self.infoOffItem.frame = CGRectMake(65 + 95, CGRectGetMinY(self.infoOnItem.frame), self.infoOffItem.dp_intrinsicWidth, 25);
        self.infoDescLabel.frame = CGRectMake(CGRectGetMaxX(self.infoOffItem.frame) + 5, CGRectGetMinY(self.infoLabel.frame) + (CGRectGetHeight(self.infoLabel.frame) - self.infoDescLabel.dp_intrinsicHeight) / 2, self.infoDescLabel.dp_intrinsicWidth, self.infoDescLabel.dp_intrinsicHeight);
        
    } else {
        self.issueLabel.frame = CGRectMake(20, 35 + 15, self.issueLabel.dp_intrinsicWidth, self.issueLabel.dp_intrinsicHeight);
        self.missLabel.frame = CGRectMake(20, 35 + 75, self.missLabel.dp_intrinsicWidth, self.missLabel.dp_intrinsicHeight);
        self.brokenLabel.frame = CGRectMake(20, 35 + 105, self.brokenLabel.dp_intrinsicWidth, self.brokenLabel.dp_intrinsicHeight);
        self.statLabel.frame = CGRectMake(20, 35 + 135, self.statLabel.dp_intrinsicWidth, self.statLabel.dp_intrinsicHeight);
        self.infoLabel.frame = CGRectMake(20, 35 + 185, self.infoLabel.dp_intrinsicWidth, self.infoLabel.dp_intrinsicHeight);
        
        self.issue1Item.frame = CGRectMake(65, CGRectGetMinY(self.issueLabel.frame) + (CGRectGetHeight(self.issueLabel.frame) - 25) / 2, self.issue1Item.dp_intrinsicWidth, 25);
        self.issue2Item.frame = CGRectMake(65 + 105, CGRectGetMinY(self.issue1Item.frame), self.issue2Item.dp_intrinsicWidth, 25);
        self.issue3Item.frame = CGRectMake(65, CGRectGetMaxY(self.issue1Item.frame) + 5, self.issue3Item.dp_intrinsicWidth, 25);
        self.issue4Item.frame = CGRectMake(65 + 105, CGRectGetMinY(self.issue3Item.frame), self.issue4Item.dp_intrinsicWidth, 25);
        
        self.missOnItem.frame = CGRectMake(65, CGRectGetMinY(self.missLabel.frame) + (CGRectGetHeight(self.missLabel.frame) - 25) / 2, self.missOnItem.dp_intrinsicWidth, 25);
        self.missOffItem.frame = CGRectMake(65 + 105, CGRectGetMinY(self.missOnItem.frame), self.missOffItem.dp_intrinsicWidth, 25);
        
        self.brokenOnItem.frame = CGRectMake(65, CGRectGetMinY(self.brokenLabel.frame) + (CGRectGetHeight(self.brokenLabel.frame) - 25) / 2, self.brokenOnItem.dp_intrinsicWidth, 25);
        self.brokenOffItem.frame = CGRectMake(65 + 105, CGRectGetMinY(self.brokenOnItem.frame), self.brokenOffItem.dp_intrinsicWidth, 25);
        
        self.statOnItem.frame = CGRectMake(65, CGRectGetMinY(self.statLabel.frame) + (CGRectGetHeight(self.statLabel.frame) - 25) / 2, self.statOnItem.dp_intrinsicWidth, 25);
        self.statOffItem.frame = CGRectMake(65 + 105, CGRectGetMinY(self.statOnItem.frame), self.statOffItem.dp_intrinsicWidth, 25);
        self.statDescLabel.frame = CGRectMake(70, 35 + 160, self.statDescLabel.dp_intrinsicWidth, self.statDescLabel.dp_intrinsicHeight);
        
        self.infoOnItem.frame = CGRectMake(65, CGRectGetMinY(self.infoLabel.frame) + (CGRectGetHeight(self.infoLabel.frame) - 25) / 2, self.infoOnItem.dp_intrinsicWidth, 25);
        self.infoOffItem.frame = CGRectMake(65 + 105, CGRectGetMinY(self.infoOnItem.frame), self.infoOffItem.dp_intrinsicWidth, 25);
        self.infoDescLabel.frame = CGRectMake(70, 35 + 210, self.infoDescLabel.dp_intrinsicWidth, self.infoDescLabel.dp_intrinsicHeight);
    }
}

- (void)onSelected:(UIButton *)button {
    switch (button.tag) {
        case tagIssueTag1:
        case tagIssueTag2:
        case tagIssueTag3:
        case tagIssueTag4:
            self.issue1Item.selected =
            self.issue2Item.selected =
            self.issue3Item.selected =
            self.issue4Item.selected = NO;
            break;
        case tagBrokenLineOn:
        case tagBrokenLineOff:
            self.brokenOnItem.selected = self.brokenOffItem.selected = NO;
            break;
        case tagMissValueOn:
        case tagMissValueOff:
            self.missOnItem.selected = self.missOffItem.selected = NO;
            break;
        case tagStatisticsOn:
        case tagStatisticsOff:
            self.statOnItem.selected = self.statOffItem.selected = NO;
            break;
        case tagInformationOn:
        case tagInformationOff:
            self.infoOnItem.selected = self.infoOffItem.selected = NO;
            break;
        default:
            break;
    }
    
    button.selected = YES;
}

- (void)onTapHelp {
    if ([self.delegate respondsToSelector:@selector(viewDidHelp:)]) {
        [self.delegate viewDidHelp:self];
    }
}

- (void)onCancelOrConfirm:(UIButton *)button {
    switch (button.tag) {
        case tagButtonCancel:
            if ([self.delegate respondsToSelector:@selector(viewDidCancel:)]) {
                [self.delegate viewDidCancel:self];
            }
            break;
        case tagButtonConfirm:{
            NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:kTrendPreferSetterKey];
            DPTrendStatCount rowCount = [dict[kTrendPreferRowCountKey] intValue];
            BOOL brokenOn = [dict[kTrendPreferBrokenOnKey] boolValue];
            BOOL missOn = [dict[kTrendPreferMissOnKey] boolValue];
            BOOL statOn = [dict[kTrendPreferStatOnKey] boolValue];
            BOOL infoOn = [dict[kTrendPreferInfoOnKey] boolValue];
            if (self.issueIndex == rowCount && self.missOn == missOn && self.statOn == statOn && self.brokenOn == brokenOn && self.infoOn == infoOn) {
                [self.cancelButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                return;
            }
            if ([self.delegate respondsToSelector:@selector(viewDidConfirm:)]) {
                [self.delegate viewDidConfirm:self];
                [self pvt_savePrefer];
            }
        }
            break;
        default:
            DPAssert(NO);
            break;
    }
}
- (void)refresh
{
    [self pvt_loadUserPrefer];
}
#pragma 记录用户偏好
- (void)pvt_savePrefer
{
    NSDictionary *dict = @{kTrendPreferRowCountKey : @(self.issueIndex), kTrendPreferBrokenOnKey : @(self.brokenOn), kTrendPreferMissOnKey : @(self.missOn), kTrendPreferStatOnKey : @(self.statOn), kTrendPreferInfoOnKey : @(self.infoOn)};
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:kTrendPreferSetterKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark 下载用户偏好
- (void)pvt_loadUserPrefer
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:kTrendPreferSetterKey];
    if (dict == nil) {
        self.issueIndex = DPTrendStatCount50;
        self.brokenOn = YES;
        self.missOn = YES;
        self.statOn = YES;
        self.infoOn = YES;
        [self pvt_savePrefer];
        return;
    }
    self.issueIndex = [dict[kTrendPreferRowCountKey] intValue];
    self.brokenOn = [dict[kTrendPreferBrokenOnKey] boolValue];
    self.missOn = [dict[kTrendPreferMissOnKey] boolValue];
    self.statOn = [dict[kTrendPreferStatOnKey] boolValue];
    self.infoOn = [dict[kTrendPreferInfoOnKey] boolValue];
}
#pragma mark - setter, getter
- (void)setIssueIndex:(DPTrendStatCount)issueIndex {
    self.issue1Item.selected =
    self.issue2Item.selected =
    self.issue3Item.selected =
    self.issue4Item.selected = NO;
    
    switch (issueIndex) {
        case DPTrendStatCount50:
            self.issue1Item.selected = YES;
            break;
        case DPTrendStatCount100:
            self.issue2Item.selected = YES;
            break;
        case DPTrendStatCount150:
            self.issue3Item.selected = YES;
            break;
        case DPTrendStatCount200:
            self.issue4Item.selected = YES;
            break;
        default:
            break;
    }
}

- (void)setMissOn:(BOOL)missOn {
    self.missOnItem.selected = missOn;
    self.missOffItem.selected = !missOn;
}

- (void)setBrokenOn:(BOOL)brokenOn {
    self.brokenOnItem.selected = brokenOn;
    self.brokenOffItem.selected = !brokenOn;
}

- (void)setStatOn:(BOOL)statOn {
    self.statOnItem.selected = statOn;
    self.statOffItem.selected = !statOn;
}

- (void)setInfoOn:(BOOL)infoOn {
    self.infoOnItem.selected = infoOn;
    self.infoOffItem.selected = !infoOn;
}

- (DPTrendStatCount)issueIndex {
    if (self.issue1Item.selected) {
        return DPTrendStatCount50;
    }
    if (self.issue2Item.selected) {
        return DPTrendStatCount100;
    }
    if (self.issue3Item.selected) {
        return DPTrendStatCount150;
    }
    if (self.issue4Item.selected) {
        return DPTrendStatCount200;
    }
    DPAssert(NO);
    return -1;
}

- (BOOL)missOn {
    return self.missOnItem.selected;
}

- (BOOL)brokenOn {
    return self.brokenOnItem.selected;
}

- (BOOL)statOn {
    return self.statOnItem.selected;
}

- (BOOL)infoOn {
    return self.infoOnItem.selected;
}

@end
