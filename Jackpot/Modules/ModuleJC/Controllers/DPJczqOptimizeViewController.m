//
//  DPJczqOptimizeViewController.m
//  Jackpot
//
//  Created by Ray on 15/12/8.
//  Copyright © 2015年 dacai. All rights reserved.
//

#import "DPFlowSets.h"
#import "DPJczqDataModel.h"
#import "DPJczqOptimizeCell.h"
#import "DPJczqOptimizeViewController.h"
#import "DPLogOnViewController.h"
#import "DPOpenBetServiceController.h"
#import "DPPayRedPacketViewController.h"
#import "DPWebViewController.h"
#import "Order.pbobjc.h"

@interface DPJczqOptimizeViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate> {
    BOOL _isSelectedPro;    //是否选择协议
    BOOL _hasReloaded;      //是否已经更新了优化信息

    NSInteger _baseMoney;    //初始时的金额
    NSInteger _lastMoney;    //上一次的金额

    DPNoteBonusResult _bounusResult;    //实际注数
    NSInteger _currentNote;             //当前注数
    NSArray *_optimizeArray;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *agreeView;              //同意协议
@property (nonatomic, strong) UITextField *moneyTextField;    //预算金额field
@property (nonatomic, strong) UIView *configView;
@property (nonatomic, strong) UILabel *passModeLabel;        //过关方式
@property (nonatomic, strong) UITextField *multipleField;    //倍数
@property (nonatomic, strong) UILabel *bottomLabel;          //底部投注注数详情
@property (nonatomic, strong) UILabel *bottomBoundLabel;     //底部奖金
@property (nonatomic, strong) UIView *submitView;            //底部提交视图
@property (nonatomic, strong) UIView *coverView;             //灰色背景（键盘弹出）

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *codeDictionary;
@property (nonatomic, strong) NSMutableSet *codeKeySet;




@end

@implementation DPJczqOptimizeViewController

- (instancetype)init {
    if (self = [super init]) {
        [DPPaymentFlow pushContextWithViewController:self];
    }
    return self;
}

- (void)dealloc {
    [DPPaymentFlow popContextWithViewController:self];
}

// 设置比赛, 同时设置bit位
-(void)setMatchList:(NSArray *)matchList{
    _matchList = matchList ;
    
    for (int i= 0; i< matchList.count; i++) {
        PBMJczqMatch *match = [matchList objectAtIndex:i] ;
        match.matchCode = 1 << i;
    }
}

#pragma mark- 获取最小/大奖金

-(void)gotMaxAward:(CGFloat*)maxWards min:(CGFloat*)minWards{

    *maxWards = 0 ;
    *minWards = 0 ;
    
    for (NSNumber *number in self.codeKeySet) {
        
        [self.codeDictionary setObject:[NSNumber numberWithFloat:0.00] forKey:number] ;
     }
    
    for ( DPJczqOptimizeModel *model in self.dataArray) {
        
        if (*minWards == 0) {
            *minWards =  model.betPrice * model.betNumber ;
        }else  if (*minWards > model.betPrice * model.betNumber && model.betPrice * model.betNumber > 0) {
            *minWards =  model.betPrice * model.betNumber ;
        }

        // 一个 Model 代表一组比赛, 比如一共选择了 7 场比赛, 分别是 周一001, 周一002, 周一003, ... 周一007
        // 001 的 bit 位表示成 1 << 0, 002 的 bit 位表示成 1 << 1, 003 的 bit 位表示成 1 << 2, 依次类推
        
        // 比如 Model 中包含 3 场比赛  周一002 (胜, 平), 周一004(平), 周一005(让球胜, 让球平, 让球负)
        // 我们目的就是找出所有包含了这3场比赛的组合中奖金最大的
        // 那么采用上面这种方式, Model 能够唯一表达成 00011010, 那么对 00011010 进行查找, 就能找到最大的奖金了
        
        
        CGFloat codeWards = [[self.codeDictionary objectForKey:@(model.betCode)] floatValue] ;
       
        if (model.betPrice * model.betNumber > codeWards) {
            
            [self.codeDictionary setObject:@(model.betPrice * model.betNumber) forKey:@(model.betCode) ];
        }
        
    }
    
    
    for (NSNumber *number in self.codeKeySet) {
        *maxWards += [[self.codeDictionary objectForKey:number]doubleValue] ;
    }
    
 }

/**
 *  进行优化计算
 *
 *  @param note [in]预期生成的注数
 */
- (void)createDataWithNote:(NSInteger)note {
    [self.dataArray removeAllObjects];
    [self.codeDictionary removeAllObjects];
    [self.codeKeySet removeAllObjects];
    _optimizeArray = [DPNoteCalculater optimizeJczqWithOption:self.optionList passMode:self.passModeList note:note output:&_bounusResult];
    for (int i = 0; i < _optimizeArray.count; i++) {
        DPJczqOptimize *optimize = [_optimizeArray objectAtIndex:i];
        DPJczqOptimizeModel *model = [[DPJczqOptimizeModel alloc] init];
        model.betNumber =  optimize.multiple ;
        model.betPrice = [[NSString stringWithFormat:@"%.2f",optimize.spCount * 2.0]floatValue] ;
        
        NSInteger code = 0 ;
        for (DPJczqOptimizeOption *optimizeOption in optimize.options) {
            DPOptimizeMatch *optionModel = [[DPOptimizeMatch alloc] init];
             for (PBMJczqMatch *match in self.matchList) {
                if (match.gameMatchId == optimizeOption.matchId) {
                    optionModel.matchName = match.orderNumberName;
                    optionModel.homeTeamName = match.homeTeamName;
                    optionModel.awayTeamName = match.awayTeamName;
                    optionModel.spNum = [model gotSpWithMatch:match optiion:optimizeOption];
                    optionModel.typeName = [model gotGameTypeNameWithOption:optimizeOption];
                    code += match.matchCode ;
                    break;
                }
            }
            [model.matchInfoArray addObject:optionModel];
        }
        if ([self.codeDictionary objectForKey:@(code)] == nil) {
            [self.codeDictionary setObject:[NSNumber numberWithFloat:0.00] forKey:@(code)] ;
         }
        
        [self.codeKeySet addObject:[NSNumber numberWithInteger:code]];
        
         model.betCode = code ;
        model.passName = [model gotTitleString];
        [self.dataArray addObject:model];
    }

    _currentNote = _bounusResult.note;
    _baseMoney = _lastMoney = _bounusResult.note * 2;
    self.moneyTextField.text = self.moneyTextField.text.length?self.moneyTextField.text :[NSString stringWithFormat:@"%lld", _bounusResult.note * 2];
    [self pvt_changeBottomLabels];
    [self.tableView reloadData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self pvt_hiddenCoverView:YES];

    //键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];

    [self createDataWithNote:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"优化投注";
    self.view.backgroundColor = [UIColor dp_flatWhiteColor];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dp_itemWithTitle:@"说明" target:self action:@selector(pvt_introduce)];
    _isSelectedPro = YES;
    self.dataArray = [[NSMutableArray alloc] init];
    self.codeDictionary = [[NSMutableDictionary alloc]init];
    self.codeKeySet = [[NSMutableSet alloc]init];

    [self buildTopLayout];
    [self buildConfigLayout];
    [self buildSubmitLayout];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.coverView];

    [self.view addSubview:self.configView];
    [self.view addSubview:self.submitView];

    UIView *contentView = self.view;

    [self.configView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@36);
        make.bottom.equalTo(self.submitView.mas_top);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
    }];

    [self.submitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.bottom.equalTo(contentView);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyTextField.mas_bottom).offset(6.5);
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.configView.mas_top);
    }];

    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.coverView setHidden:YES];

    [self.view addGestureRecognizer:({
                   UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_onTap)];
                   tapRecognizer.delegate = self;
                   tapRecognizer;
               })];
}

- (void)buildTopLayout {
    [self.view addSubview:self.moneyTextField];

    UIButton *caculateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [caculateBtn setTitle:@"平衡优化" forState:UIControlStateNormal];
    [caculateBtn addTarget:self action:@selector(pvt_caculete) forControlEvents:UIControlEventTouchUpInside];
    [caculateBtn setTitleColor:[UIColor dp_flatWhiteColor] forState:UIControlStateNormal];
    caculateBtn.titleLabel.font = [UIFont dp_boldArialOfSize:15];
    caculateBtn.backgroundColor = [UIColor dp_flatRedColor];
    caculateBtn.layer.cornerRadius = 4;
    caculateBtn.clipsToBounds = YES;
    [self.view addSubview:caculateBtn];

    [self.moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(6.5);
        make.left.equalTo(self.view).offset(16);
        make.height.mas_equalTo(36);
        make.width.equalTo(self.view).multipliedBy(0.58);
    }];

    [caculateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.moneyTextField);
        make.height.mas_equalTo(self.moneyTextField);
        make.right.equalTo(self.view).offset(-16);
        make.width.equalTo(self.view).multipliedBy(0.28);
    }];
}

- (void)buildConfigLayout {
    UIView *topLine = ({
        [UIView dp_viewWithColor:[UIColor colorWithRed:0.89 green:0.86 blue:0.81 alpha:1]];
    });
    UIView *middleLine = ({
        [UIView dp_viewWithColor:[UIColor colorWithRed:0.89 green:0.86 blue:0.81 alpha:1]];
    });

    UIView *contentView = self.configView;

    [contentView addSubview:topLine];
    [contentView addSubview:middleLine];

    [contentView addSubview:self.passModeLabel];
    [contentView addSubview:self.multipleField];

    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(contentView);
        make.height.equalTo(@0.5);
    }];
    [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.height.equalTo(contentView);
        make.width.equalTo(@0.5);
        make.top.equalTo(contentView);
    }];
    [self.passModeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.multipleField.mas_centerY);
        make.right.equalTo(middleLine.mas_left);
        make.left.equalTo(contentView).offset(5);
    }];
    [self.multipleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView).multipliedBy(1.5);
        make.width.equalTo(@70);
        make.top.equalTo(contentView).offset(8);
        make.bottom.equalTo(contentView).offset(-6);
    }];

    UILabel *left = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"投";
        label.textColor = [UIColor dp_flatBlackColor];
        label.font = [UIFont dp_systemFontOfSize:13];
        label;
    });
    UILabel *right = ({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"倍";
        label.textColor = [UIColor dp_flatBlackColor];
        label.font = [UIFont dp_systemFontOfSize:13];
        label;
    });

    [contentView addSubview:left];
    [contentView addSubview:right];

    [left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.multipleField);
        make.right.equalTo(self.multipleField.mas_left).offset(-2);
    }];
    [right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.multipleField);
        make.left.equalTo(self.multipleField.mas_right).offset(2);
    }];
}

- (void)buildSubmitLayout {
    UIButton *submitButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundColor:[UIColor dp_flatRedColor]];
        [button addTarget:self action:@selector(pvt_onSubmit) forControlEvents:UIControlEventTouchUpInside];
        button;
    });

    UIImageView *confirmView = [[UIImageView alloc] init];
    confirmView.image = [UIImage dp_retinaImageNamed:dp_ImagePath(kCommonImageBundlePath, @"sumit001_24.png")];
    UIView *contentView = self.submitView;

    [contentView addSubview:submitButton];
    [contentView addSubview:self.bottomLabel];
    [contentView addSubview:self.bottomBoundLabel];

    UILabel *yuanLabel = ({

        UILabel *label = [[UILabel alloc] init];
        label.text = @"元";
        label.font = [UIFont dp_systemFontOfSize:11.0f];
        label.textColor = [UIColor dp_flatWhiteColor];
        label.backgroundColor = [UIColor clearColor];
        label;
    });
    [contentView addSubview:yuanLabel];
    [contentView addSubview:confirmView];

    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(contentView);
        make.bottom.equalTo(contentView);
    }];
    [confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-15);

        make.centerY.equalTo(submitButton);
        make.width.equalTo(@23.5);
        make.height.equalTo(@23);
    }];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(15);
        make.right.equalTo(contentView).offset(-40);
        make.top.equalTo(contentView).offset(5);
        make.bottom.equalTo(contentView.mas_centerY);
    }];

    [self.bottomBoundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(15);
        make.width.lessThanOrEqualTo(@250);
        make.top.equalTo(contentView.mas_centerY).offset(5);
        make.bottom.equalTo(contentView).offset(-5);
    }];

    [yuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomBoundLabel.mas_right);
        make.top.equalTo(contentView.mas_centerY).offset(5);
        make.bottom.equalTo(contentView).offset(-5);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DPJczqOptimizeModel *model = [self.dataArray objectAtIndex:indexPath.row];

    if (model.unfold) {
        NSString *foldCellIdentifyer = model.cellIdentifyStr;
        DPJczqOptimizeCell *cell = [tableView dequeueReusableCellWithIdentifier:foldCellIdentifyer];
        if (cell == nil) {
            cell = [[DPJczqOptimizeCell alloc] initWithCellStyle:OptimizeCellTypeFold reuseIdentifier:foldCellIdentifyer];

            @weakify(self);
            cell.changeValue = ^(DPJczqOptimizeCell *curCell) {
                @strongify(self);
                DPLog(@"数值发生改变%@", curCell.countView.text);
                 [self refreshCurrentCell:curCell];
            };
        }

        cell.modelData = model;
        @weakify(tableView);

        cell.showMatch = ^(DPJczqOptimizeCell *currentCell) {
            @strongify(tableView);

            NSIndexPath *path = [tableView indexPathForCell:currentCell];
            [tableView beginUpdates];
            [tableView reloadRowsAtIndexPaths:@[ path ] withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];

        };

        if (indexPath.row == self.dataArray.count - 1) {
            cell.contentView.backgroundColor = [UIColor dp_flatBackgroundColor];
        } else {
            cell.contentView.backgroundColor = [UIColor dp_flatWhiteColor];
        }

        return cell;
    }

    static NSString *cellIdentifyer = @"cellIdentifyer";
    DPJczqOptimizeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifyer];
    if (cell == nil) {
        cell = [[DPJczqOptimizeCell alloc] initWithCellStyle:OptimizeCellTypeNormal reuseIdentifier:cellIdentifyer];
        @weakify(self);
        cell.changeValue = ^(DPJczqOptimizeCell *curCell) {
            @strongify(self);
            DPLog(@"数值发生改变%@", curCell.countView.text);
             [self refreshCurrentCell:curCell];
        };
    }

    cell.modelData = model;
    @weakify(tableView);

    cell.showMatch = ^(DPJczqOptimizeCell *currentCell) {
        @strongify(tableView);

        NSIndexPath *path = [tableView indexPathForCell:currentCell];
        [tableView beginUpdates];
        [tableView reloadRowsAtIndexPaths:@[ path ] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];

    };
    if (indexPath.row == self.dataArray.count - 1) {
        cell.contentView.backgroundColor = [UIColor dp_flatBackgroundColor];
    } else {
        cell.contentView.backgroundColor = [UIColor dp_flatWhiteColor];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DPJczqOptimizeModel *model = [self.dataArray objectAtIndex:indexPath.row];
    NSString *str = model.passName;

    //    CGSize size = [NSString dpsizeWithSting:str andFont:[UIFont dp_boldArialOfSize:11] andMaxWidth:kScreenWidth-50] ;
    //
    //    if (model.unfold) {
    //        return 12 + size.height + 12 + kRowHeight*(model.matchInfoArray.count+1)+10  + 58+5;
    //    }
    //
    //    return  12 + size.height + 12 + 58+5;

    if (model.unfold) {
        return 38 + kRowHeight * (model.matchInfoArray.count + 1) + 10 + 58 + 5;
    }

    return 38 + 58 + 5;
}

#pragma mark - textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textField selectAll:self];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIMenuController.sharedMenuController setMenuVisible:NO];
        });
    });
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.moneyTextField]) {
        _hasReloaded = NO;

        if ([textField.text integerValue] <= 0) {
//            textField.text = [NSString stringWithFormat:@"%zd", _baseMoney];
        } else if ([textField.text integerValue] % 2 != 0) {
            textField.text = [NSString stringWithFormat:@"%d", [textField.text intValue] + 1];
        }
        [self pvt_changeBottomLabels];
        return;
    }

    if ([textField.text integerValue] <= 0) {
        textField.text = @"1";
    }
    [self pvt_changeBottomLabels];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![KTMValidator isNumber:string]) {
        return NO;
    }

    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if ([textField isEqual:self.moneyTextField]) {
        if (![textField.text isEqualToString:newString]) {
            self.multipleField.text = @"1";
            //清除数据重新计算
            if (!_hasReloaded) {
                _currentNote = 0 ;
                 [self.dataArray removeAllObjects];
                [self.tableView reloadData];
                _hasReloaded = YES;
            }
        }

        if ([newString intValue] > 100000) {
            //            [[DPToast makeText:@"预算金额最大支持10万"]show];
            textField.text = @"100000";
            [self pvt_changeBottomLabels];

            return NO;
        }

        if (newString.length <= 0) {
            textField.text = @"";
            [self pvt_changeBottomLabels];

            return NO;
        }

        if ([textField.text isEqualToString:newString]) {
            textField.text = @"";    // fix iOS8
        }
        textField.text = [NSString stringWithFormat:@"%d", [newString intValue]];

        [self pvt_changeBottomLabels];

        return NO;
    }

    if ([textField isEqual:self.multipleField]) {
        if (newString.length == 0) {
            textField.text = @"";
            [self pvt_changeBottomLabels];
            return NO;
        }
        if ([newString intValue] > 99) {
            textField.text = @"99";
            //            [[DPToast makeText:@"最大倍数不得超过99"] show];
            [self pvt_changeBottomLabels];

            return NO;
        }

        //        int quantity ; int64_t minBonus,maxBonus ;
        //        _jczqInstance->GetBalanceOrderInfo(quantity, minBonus, maxBonus) ;
        //
        //        if (_currentNote*2*[newString intValue] >6000){
        //            [[DPToast makeText:[NSString stringWithFormat:@"方案金额超限"]]show];
        //            textField.text =[NSString stringWithFormat:@"%ld",3000/_currentNote]  ;
        //            return NO;
        //
        //        }
        //
        //        if (quantity == 0) {
        //            if ([newString intValue]*[self.moneyTextField.text intValue] >2000000) {
        //                [[DPToast makeText:[NSString stringWithFormat:@"实际金额必须小于200万"]]show];
        //                return NO;
        //            }
        //        }

        if ([textField.text isEqualToString:newString]) {
            textField.text = @"";    // fix iOS8
        }
        textField.text = [NSString stringWithFormat:@"%d", [newString intValue]];
        [self pvt_changeBottomLabels];
    }

    return NO;
}

#pragma mark - 更新注数
- (void)refreshCurrentCell:(DPJczqOptimizeCell *)cell {
    NSInteger lastNote = [cell.lastNumString integerValue];
    _currentNote -= lastNote;

    DPJczqOptimizeModel *model = cell.modelData;
    DPJczqOptimize *option = [_optimizeArray objectAtIndex:[self.dataArray indexOfObject:model]];

    if ([cell.countView.text intValue] <= 9999) {
        
        _currentNote += [cell.countView.text integerValue];
        cell.countView.text = [NSString stringWithFormat:@"%zd",[cell.countView.text integerValue]];
         model.betNumber = option.multiple = [cell.countView.text intValue];

 
     } else {
 
         
         cell.countView.text = @"9999" ;
         _currentNote += 9999 ;
         model.betNumber = option.multiple = 9999 ;
         
//         _currentNote += [cell.lastNumString integerValue];
//         cell.countView.text =cell.lastNumString ;
//         model.betNumber =  option.multiple = [cell.lastNumString intValue];
     }
    
    cell.awardLab.text = [NSString stringWithFormat:@"%.2f",model.betPrice * [cell.countView.text integerValue]] ;
     [self pvt_changeBottomLabels];


 }

#pragma mark - setter/getter

- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor dp_coverColor];
    }
    return _coverView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor dp_flatBackgroundColor];
        _tableView.tableFooterView = self.agreeView;
    }
    return _tableView;
}

- (UITextField *)moneyTextField {
    if (_moneyTextField == nil) {
        _moneyTextField = [[UITextField alloc] init];
        _moneyTextField.borderStyle = UITextBorderStyleRoundedRect;
        _moneyTextField.backgroundColor = [UIColor dp_flatWhiteColor];
        _moneyTextField.textAlignment = NSTextAlignmentLeft;
        _moneyTextField.font = [UIFont dp_boldSystemFontOfSize:16];
        _moneyTextField.keyboardType = UIKeyboardTypeNumberPad;
        _moneyTextField.textColor = UIColorFromRGB(0xadadad);
        _moneyTextField.delegate = self;
        _moneyTextField.placeholder = @"预算金额";
        //         _moneyTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"我说两句" attributes:[NSDictionary dictionaryWithObjectsAndKeys:NSForegroundColorAttributeName ,UIColorFromRGB(0xd6d5da), nil]] ;
        _moneyTextField.inputAccessoryView = ({
            UIView *line = [UIView dp_viewWithColor:UIColorFromRGB(0xadadad)];
            line.bounds = CGRectMake(0, 0, 0, 0.5f);
            line;
        });
    }
    return _moneyTextField;
}

- (UIView *)submitView {
    if (_submitView == nil) {
        _submitView = [[UIView alloc] init];
        _submitView.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    return _submitView;
}

- (UIView *)agreeView {
    if (_agreeView == nil) {
        _agreeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15 + 30 + 25)];
        _agreeView.backgroundColor = [UIColor dp_flatBackgroundColor];

        UILabel *agreeLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = UIColorFromRGB(0xb9b2a5);
            label.font = [UIFont dp_systemFontOfSize:11];
            label.text = @"我已同意《用户合买代购协议》其中条款";
            //            MTStringParser *parser = [[MTStringParser alloc] init];
            //            [parser setDefaultAttributes:({
            //                MTStringAttributes *attr = [[MTStringAttributes alloc] init];
            //                attr.font = [UIFont dp_systemFontOfSize:11];
            //                attr.textColor = UIColorFromRGB(0xc4bcaf);
            //                attr;
            //            })];
            //            [parser addStyleWithTagName:@"blue" color:UIColorFromRGB(0x0b76d4)];
            //
            //            NSString *markupText = [NSString stringWithFormat:@"同意并勾选<blue>《代购协议》</blue>其中条款 "];
            //
            //            label.attributedText = [parser attributedStringFromMarkup:markupText];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_agreementLabelClick)];
            label.userInteractionEnabled = YES;
            [label addGestureRecognizer:tap];
            label;
        });

        UIButton *agreementButton = ({
            UIButton *button = [[UIButton alloc] init];
            button.userInteractionEnabled = YES;
            [button setImage:dp_CommonImage(@"check.png") forState:UIControlStateSelected];
            [button setImage:dp_CommonImage(@"uncheck.png") forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor clearColor]];
            button.selected = YES;
            [button addTarget:self action:@selector(pvt_agree:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });

        UILabel *redLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = UIColorFromRGB(0xfba09b);
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont dp_systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            label.text = @"赔率等信息以出票后的票样为准。";
            label;
        });

        [_agreeView addSubview:agreeLabel];
        [_agreeView addSubview:redLabel];
        [_agreeView addSubview:agreementButton];

        [agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_agreeView).offset(20);
            make.centerX.equalTo(_agreeView).offset(5);
        }];

        [agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(agreeLabel);
            make.right.equalTo(agreeLabel.mas_left).offset(-2);
        }];

        [redLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(agreeLabel.mas_bottom).offset(5);
            make.centerX.equalTo(_agreeView);
        }];
    }

    return _agreeView;
}

- (UIView *)configView {
    if (_configView == nil) {
        _configView = [[UIView alloc] init];
        _configView.backgroundColor = [UIColor dp_flatWhiteColor];
    }
    return _configView;
}

- (UILabel *)passModeLabel {
    if (_passModeLabel == nil) {
        _passModeLabel = [[UILabel alloc] init];
        _passModeLabel.numberOfLines = 1;
        _passModeLabel.font = [UIFont dp_systemFontOfSize:13];
        _passModeLabel.textAlignment = NSTextAlignmentCenter;
        _passModeLabel.text = @"过关方式:2串1";
        _passModeLabel.userInteractionEnabled = YES;
        _passModeLabel.backgroundColor = [UIColor clearColor];
        _passModeLabel.textColor = UIColorFromRGB(0x333333);
        [_passModeLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pvt_showPassModel)]];
    }

    return _passModeLabel;
}

- (UITextField *)multipleField {
    if (_multipleField == nil) {
        _multipleField = [[UITextField alloc] init];
        _multipleField.borderStyle = UITextBorderStyleNone;
        _multipleField.layer.cornerRadius = 3;
        _multipleField.layer.borderWidth = 0.5;
        _multipleField.layer.borderColor = [UIColor colorWithRed:0.85 green:0.84 blue:0.8 alpha:1].CGColor;
        _multipleField.backgroundColor = [UIColor clearColor];
        _multipleField.font = [UIFont dp_systemFontOfSize:13];
        _multipleField.keyboardType = UIKeyboardTypeNumberPad;
        _multipleField.textColor = [UIColor dp_flatBlackColor];
        _multipleField.textAlignment = NSTextAlignmentCenter;
        _multipleField.text = @"1";
        _multipleField.delegate = self;
        _multipleField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _multipleField.inputAccessoryView = ({
            UIView *line = [UIView dp_viewWithColor:UIColorFromRGB(0xdad5cc)];
            line.bounds = CGRectMake(0, 0, 0, 0.5f);

            line;
        });
    }
    return _multipleField;
}

- (UILabel *)bottomLabel {
    if (_bottomLabel == nil) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.numberOfLines = 1;
        _bottomLabel.textColor = [UIColor dp_flatWhiteColor];
        _bottomLabel.font = [UIFont dp_systemFontOfSize:11.0f];
        _bottomLabel.backgroundColor = [UIColor clearColor];
        _bottomLabel.textAlignment = NSTextAlignmentLeft;
        _bottomLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _bottomLabel.text = @"实际金额：19000元";
        _bottomLabel.userInteractionEnabled = NO;
    }
    return _bottomLabel;
}

- (UILabel *)bottomBoundLabel {
    if (_bottomBoundLabel == nil) {
        _bottomBoundLabel = [[UILabel alloc] init];
        _bottomBoundLabel.numberOfLines = 1;
        _bottomBoundLabel.textColor = [UIColor dp_flatWhiteColor];
        _bottomBoundLabel.font = [UIFont dp_systemFontOfSize:11.0f];
        _bottomBoundLabel.backgroundColor = [UIColor clearColor];
        _bottomBoundLabel.textAlignment = NSTextAlignmentLeft;
        _bottomBoundLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _bottomBoundLabel.userInteractionEnabled = NO;
        _bottomBoundLabel.text = @"奖金范围：12300000-900000000";
    }
    return _bottomBoundLabel;
}

#pragma mark - 点击事件


- (void)pvt_showPassModel {
    [[DPToast makeText:self.passModeLabel.text] show];
}

- (void)pvt_introduce {
    DPLog(@"说明");
    
    DPWebViewController *vc = [[DPWebViewController alloc]init];
    vc.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:kHelpOptimizeURL]] ;
    [self.navigationController pushViewController: vc  animated:YES];
}

- (void)pvt_agree:(UIButton *)sender {
    sender.selected = !sender.selected;
    _isSelectedPro = sender.selected;
}

- (void)pvt_agreementLabelClick {
    DPWebViewController *webCtrl = [[DPWebViewController alloc] init];
    webCtrl.requset = [NSURLRequest requestWithURL:[NSURL URLWithString:kPayAgreementURL]];
    webCtrl.canHighlight = NO;
    [self.navigationController pushViewController:webCtrl animated:YES];
}

- (void)pvt_caculete {
    DPLog(@"计算平衡投注");

    [[DPToast sharedToast] dismiss];
    [[[UIApplication sharedApplication] keyWindow] endEditing:NO];
    [self createDataWithNote:[self.moneyTextField.text integerValue] / 2];
}

- (void)pvt_onSubmit {
    DPLog(@"提交");
    if (!_isSelectedPro) {
        [[DPToast makeText:@"请勾选用户协议！"] show];
        return;
    }

    if ((_currentNote * 2 * [self.multipleField.text integerValue]) <= 0) {
        [[DPToast makeText:@"请选择投注内容"] show];
        return;
    }

    if ((_currentNote * 2 * [self.multipleField.text integerValue]) > 6000) {
        [[DPToast makeText:@"投注金额已超限"] show];
        return;
    }
    [self.view endEditing:YES];

    
    NSMutableArray *orderNumbers = [[NSMutableArray alloc]initWithCapacity:self.matchList.count];
    for (PBMJczqMatch *match in self.matchList) {
        [orderNumbers addObject:[NSString stringWithFormat:@"%lld",match.gameMatchId]];
    }
    
    NSString *urlStr =[NSString stringWithFormat:@"/Service/JcMatchIsEnd?orderNumbers=%@&gameTypeId=%d",[orderNumbers componentsJoinedByString:@","],self.gameType]  ;
    
    @weakify(self) ;
    [[AFHTTPSessionManager dp_sharedManager]GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        @strongify(self) ;
        
        [DPPaymentFlow paymentWithOrder:[self getOrderData] gameType:self.gameType inViewController:self];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [[DPToast makeText:error.dp_errorMessage]show];
    }];
    

    
}
#pragma mark - 键盘事件
- (void)keyboardWillChange:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;

    CGRect endFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];

    CGFloat keyboardY = endFrame.origin.y;
    CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;

    [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
        if (obj.firstItem == self.submitView && obj.firstAttribute == NSLayoutAttributeBottom) {
            obj.constant = keyboardY - screenHeight;

            [self.view setNeedsUpdateConstraints];
            [self.view setNeedsLayout];
            [UIView animateWithDuration:duration
                                  delay:0
                                options:curve << 16
                             animations:^{
                                 [self.view layoutIfNeeded];
                             }
                             completion:nil];

            *stop = YES;
        }
    }];

    if (keyboardY != UIScreen.mainScreen.bounds.size.height && self.multipleField.editing) {
        [self pvt_hiddenCoverView:NO];
    } else {
        [self pvt_hiddenCoverView:YES];
    }
}

#pragma mark - 键盘弹出或退出时灰色背景处理
- (void)pvt_hiddenCoverView:(BOOL)hidden {
    if (hidden) {
        if (!self.coverView.hidden) {
            self.coverView.alpha = 1;
            [UIView animateWithDuration:0.2
                animations:^{
                    self.coverView.alpha = 0;
                }
                completion:^(BOOL finished) {
                    self.coverView.hidden = YES;
                }];
        }
    } else {
        if (self.coverView.hidden) {
            self.coverView.alpha = 0;
            self.coverView.hidden = NO;
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.coverView.alpha = 1;
                             }];
        }
    }
}
#pragma mark - 取消键盘事件
- (void)pvt_onTap {
    DPLog(@"taptaptaptaptaptaptap");
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    if (self.multipleField.isEditing) {
        [self.multipleField resignFirstResponder];
    }

    [self pvt_hiddenCoverView:YES];
}

- (void)pvt_changeBottomLabels {
    
    
    CGFloat max ;
    CGFloat min ;
    
    [self gotMaxAward:&max min:&min];
    
    self.bottomLabel.text = [NSString stringWithFormat:@"实际金额：%ld元", _currentNote * 2 * [self.multipleField.text integerValue]];
    self.bottomBoundLabel.text = [[NSString stringWithFormat:@"%.2f",min] isEqualToString:[NSString stringWithFormat:@"%.2f",max]]  ? [NSString stringWithFormat:@"奖金范围：%.2f", min * [self.multipleField.text intValue] ] : [NSString stringWithFormat:@"奖金范围：%.2f-%.2f", min* [self.multipleField.text intValue] , max * [self.multipleField.text intValue] ];

}

- (PBMPlaceAnOrder *)getOrderData {
    PBMPlaceAnOrder *order = [[PBMPlaceAnOrder alloc] init];
    order.betDescription = [DPBetDescription descriptionOptimizeWithOption:self.optionList passMode:self.passModeList optimize:_optimizeArray gameType:self.gameType];
    order.betOrderNumbers = [self getOrderNumberStr];
    order.betType = 2;
    order.channelType = 1;
    order.deviceNum = @"";
    PBMJczqMatch *match = [self.matchList firstObject];
    order.gameId = (int32_t)match.dpGameId;
    order.gameTypeId = self.gameType;
    order.multiple = self.multipleField.text.intValue;
    order.platformType = 1;
    order.quantity = _currentNote;
    order.totalAmount = (int)_currentNote * 2 * self.multipleField.text.intValue;
    order.passTypeDesc = [self.passModeLabel.text substringFromIndex:5];
    order.betTypeDesc = @"复式";
    order.projectBuyType = 1;

    return order;
}

- (NSString *)getOrderNumberStr {
    NSMutableArray *orders = [[NSMutableArray alloc] initWithCapacity:self.matchList.count];
    for (int i = 0; i < self.matchList.count; i++) {
        PBMJczqMatch *match = self.matchList[i];
        [orders addObject:[NSString stringWithFormat:@"%lld", match.gameMatchId]];
    }

    return [NSString stringWithFormat:@",%@,", [orders componentsJoinedByString:@","]];
}

@end
