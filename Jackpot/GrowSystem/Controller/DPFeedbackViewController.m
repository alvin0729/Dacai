//
//  DPFeedbackViewController.m
//  Jackpot
//
//  Created by mu on 15/7/10.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPFeedbackViewController.h"
#import "DPFeedbackLeftCell.h"
#import "DPFeedbackRightCell.h"
#import "UMCommunity.h"
#import "UMComUserAccount.h"
#import "UMComLoginManager.h"
#import "UMComNavigationController.h"
#import "UMFeedback.h"
#import "UMFeedbackViewController.h"

@interface DPFeedbackViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
@property (nonatomic, strong)UITableView *contentTable;
@property (nonatomic, strong)UIView *sendView;
@property (nonatomic, strong)UITextField *sendTF;
@property (nonatomic, strong)UIButton *sendBtn;
@property (nonatomic, strong)NSMutableArray *messageArray;
/**
 *  调整聊天窗口的contentOfSize的开关
 */
@property (nonatomic, assign)BOOL locationOpen;
@property (nonatomic, strong)MASConstraint *tableBottomCons;
@property (nonatomic, strong)NSTimer *checkMessageTime;
@property (nonatomic, strong)MASConstraint *sendViewBottomCons;
@end

@implementation DPFeedbackViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.checkMessageTime invalidate];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"意见反馈";
    
    //初始化
    [self initilizer];
    //初始化UI
    [self initilizerUI];
    //初始化数据
    [self initilizerData];
}

- (void)initilizer{
    //定时刷新
    self.checkMessageTime = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(requestMessage) userInfo:nil repeats:YES];
    [self.checkMessageTime fire];
}
#pragma mark---------ui
- (void)initilizerUI {
    [self.view addSubview:self.sendView];
    [self.sendView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.sendViewBottomCons = make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    [self.view addSubview:self.contentTable];
    [self.contentTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.equalTo(self.sendView.mas_top).offset(0);
    }];
}

//contentTable
- (UITableView *)contentTable{
    if (!_contentTable) {
        _contentTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _contentTable.dataSource = self;
        _contentTable.delegate = self;
        _contentTable.backgroundColor = [UIColor dp_flatBackgroundColor];
        _contentTable.separatorStyle = UITableViewCellSelectionStyleNone;
        _contentTable.contentInset = UIEdgeInsetsMake(20, 0, 64, 0);
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard:)];
        [_contentTable addGestureRecognizer:gesture];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
      
    }
    return _contentTable;
}
- (void)keyboardChanged:(NSNotification *)notice{
    NSDictionary *info = notice.userInfo;
    NSValue *keyBoardValue = [info valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyBoardRect = [keyBoardValue CGRectValue];
    CGFloat bottom = - (kScreenHeight - keyBoardRect.origin.y);
    self.sendViewBottomCons.mas_equalTo(bottom);
}
- (void)closeKeyboard:(UITapGestureRecognizer *)gesture{
    [self.view endEditing:YES];
}
//sendView
- (UIView *)sendView{
    if (!_sendView) {
        _sendView = [[UIView alloc]init];
        _sendView.backgroundColor = [UIColor dp_flatWhiteColor];
        [_sendView addSubview:self.sendBtn];
        [_sendView addSubview:self.sendTF];
        
        [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(44);
        }];
        
        
        [self.sendTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.right.equalTo(self.sendBtn.mas_left);
            make.bottom.mas_equalTo(0);
        }];
        
    }
    return _sendView;
}
//sendBtn
- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.backgroundColor = [UIColor dp_flatWhiteColor];
        _sendBtn.imageView.contentMode = UIViewContentModeCenter;
        [_sendBtn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [_sendBtn setImage:dp_FeedbackResizeImage(@"messageFly.png") forState:UIControlStateNormal];
    }
    return _sendBtn;
}
//sendTF
- (UITextField *)sendTF{
    if (!_sendTF) {
        _sendTF = [[UITextField alloc]init];
        _sendTF.delegate = self;
        _sendTF.placeholder = @"我想说点什么...";
        _sendTF.backgroundColor =[UIColor dp_flatWhiteColor];
    }
    return _sendTF;
}
#pragma mark---------data
- (void)initilizerData{
    
    self.locationOpen = YES;
    self.messageArray = [NSMutableArray array];
}

#pragma mark---------function
- (void)requestMessage{
    [self.messageArray removeAllObjects];
    @weakify(self);
    [[UMFeedback sharedInstance] get:^(NSError *error) {
        @strongify(self);
        NSMutableArray *topics = [UMFeedback sharedInstance].topicAndReplies;
        for (NSDictionary *info in topics) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[info[@"created_at"] doubleValue] / 1000];
            DPUAObject *object = [[DPUAObject alloc]init];
            object.value = info[@"content"];
            object.date = [date dp_stringWithFormat:@"yyyy.MM.dd"];
            object.time = [date dp_stringWithFormat:@"HH:mm"];
            object.isCusturm = [info[@"type"] isEqualToString:@"user_reply"];
            [self.messageArray addObject:object];
        }
        
        [self.contentTable reloadData];
        
        if (self.locationOpen&&self.messageArray.count>0) {
            NSIndexPath *scrollToIndex = [NSIndexPath indexPathForRow:self.messageArray.count-1 inSection:0];
            [self.contentTable scrollToRowAtIndexPath:scrollToIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }];
}
- (void)sendMessage:(UIButton *)btn{
    self.locationOpen = YES;
    if(self.sendTF.text.length>0){
        NSDictionary *messageDic = @{@"content":self.sendTF.text};
        @weakify(self);
        [[UMFeedback sharedInstance] post:messageDic completion:^(NSError *error) {
            @strongify(self);
            [self requestMessage];
        }];
    }
    
    [self.sendTF resignFirstResponder];
    self.sendTF.text = @"";
}


//table's delegate and datasourse
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DPUAObject *object = self.messageArray[indexPath.row];
    CGSize contentSize = [NSString dpsizeWithSting:object.value andFont:[UIFont systemFontOfSize:14] andMaxWidth:kScreenWidth*0.6];
    CGFloat cellHeight = contentSize.height+50;
    return cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DPUAObject *object = self.messageArray[indexPath.row];
    if (object.isCusturm) {
        DPFeedbackRightCell *cell = [[DPFeedbackRightCell alloc]initWithTableView:tableView atIndexPath:indexPath];
        cell.object = object;
        return cell;
    }else{
        DPFeedbackLeftCell *cell = [[DPFeedbackLeftCell alloc]initWithTableView:tableView atIndexPath:indexPath];
        cell.object = object;
        return cell;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.locationOpen = NO;
}
//textField's delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
















