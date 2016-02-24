//
//  DPFootballCenterCommentController.m
//  Jackpot
//
//  Created by wufan on 15/9/6.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "BasketballDataCenter.pbobjc.h"
#import "DPDataCenterTableController+Private.h"
#import "DPFootballCenterCommentController.h"
#import "DPFootballCenterCommentViewModel.h"
#import "DPLiveCompetitionViews.h"
#import "DPLogOnViewController.h"
#import "DZNEmptyDataStyle+CustomStyle.h"
#import "FootballDataCenter.pbobjc.h"
#import "SVPullToRefresh.h"

@interface DPFootballCenterCommentController () <UITableViewDelegate, UITableViewDataSource> {
@private
    NSMutableSet *_selectedSet;    //展开的集合
    NSMutableArray *_dataArray;
    NSTimeInterval _lastTime;    //记录上次评论的时间
}

@property (nonatomic, strong) DPFootballCenterCommentViewModel *viewModel;
@property (nonatomic, strong) AFHTTPSessionManager *imageSessionMgr;    // 图片请求回话
/**
 *  评论输入框
 */
@property (nonatomic, strong) UITextField *inputTextField;
/**
 *  发送按钮
 */
@property (nonatomic, strong) UIButton *sendButton;
/**
 *  评论的id
 */
@property (nonatomic, strong) NSString *commentID;
/**
 *  空视图
 */
@property (nonatomic, strong) DZNEmptyDataStyle *emptyDataStyle;

@end

@implementation DPFootballCenterCommentController
@dynamic viewModel;
@synthesize commentView = _commentView;

#pragma mark - Lifecycle

- (instancetype)initWithMatchId:(NSInteger)matchId delegate:(id<DPDataCenterTableControllerDelegate>)delegate {
    if (self = [super initWithMatchId:matchId delegate:delegate]) {
        _title = @"评论";
        _viewModel = [[DPFootballCenterCommentViewModel alloc] initWithMatchId:matchId];
        _viewModel.delegate = self;
        _selectedSet = [[NSMutableSet alloc] init];
        _dataArray = [[NSMutableArray alloc] init];
        self.isDownLoad = YES;
        [RACObserve(self, isDownLoad) subscribeNext:^(id x) {
            if ([x boolValue]) {
                self.viewModel.commendId = @"";
            } else {
                self.viewModel.commendId = ((PBMComment *)[_dataArray lastObject]).commentId;
            }
        }];

        self.tableView.emptyDataSetSource = self.emptyDataStyle;
        self.tableView.emptyDataSetDelegate = self.emptyDataStyle;
    }
    return self;
}

#pragma mark - Delegate

#pragma mark - DPDataCenterViewModelDelegate

- (void)fetchFinished:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(requestDidFinish:error:)]) {
        [self.delegate requestDidFinish:self error:error];
    }

    if (self.isDownLoad) {
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:self.viewModel.message.commentArray];

    } else {
        [_dataArray addObjectsFromArray:self.viewModel.message.commentArray];
    }
    self.emptyDataStyle.shouldDisplay = YES;

    [self addInfinitView];
    [self.tableView reloadData];
}

- (void)addInfinitView {
    if (_dataArray.count) {
        @weakify(self);

        if (!self.tableView.infiniteScrollingView) {
            [self.tableView addInfiniteScrollingWithActionHandler:^{
                @strongify(self);
                [self.tableView.infiniteScrollingView stopAnimating];
                self.isDownLoad = NO;
                [self request];

            }];
        }

        if (_dataArray.count < self.viewModel.message.totalNum) {
            self.tableView.infiniteScrollingView.enabled = YES;
        } else {
            self.tableView.infiniteScrollingView.enabled = NO;
        }
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PBMComment *comment = [_dataArray objectAtIndex:indexPath.row];

    NSString *ss = comment.content;

    CGFloat detailHeigh = 0;
    if (ss.length > 60) {
        detailHeigh = 15;
    } else {
        detailHeigh = 0;
    }

    if (![_selectedSet containsObject:[NSNumber numberWithInteger:indexPath.row]] && ss.length > 60) {
        ss = [ss substringToIndex:60];

        ss = [ss stringByAppendingString:@"..."];
    }

    return 60 + detailHeigh + [NSString dpsizeWithSting:ss andFont:[UIFont dp_systemFontOfSize:14] andMaxSize:CGSizeMake(kScreenWidth - 75, CGFLOAT_MAX)].height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cell_identify = @"cell_identify";

    DPCommentTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_identify];
    if (cell == nil) {
        cell = [[DPCommentTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_identify];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
    }

    cell.detailButton.selected = [_selectedSet containsObject:[NSNumber numberWithInteger:indexPath.row]];

    PBMComment *comment = [_dataArray objectAtIndex:indexPath.row];
    cell.agreeButton.selected = comment.isSupported;
    cell.nameLabel.text = comment.username;
    if ([comment.username isEqual:[DPMemberManager sharedInstance].nickName]) {
        cell.nameLabel.textColor = UIColorFromRGB(0x4085d2);
    } else {
        cell.nameLabel.textColor = UIColorFromRGB(0x7f7e7a);
    }
    cell.timeString = comment.time;
    cell.agreeButton.title = [NSString stringWithFormat:@"%d", comment.supportCount];
    cell.commentString = comment.content;
    [self setImageWitImageView:cell.imageIcon imgLink:comment.userAvatar];
    cell.showDetail = ^(UITableViewCell *curCell) {

        NSIndexPath *path = [tableView indexPathForCell:curCell];

        if (((DPCommentTableCell *)curCell).detailButton.selected) {
            [_selectedSet addObject:[NSNumber numberWithInteger:path.row]];
        } else if ([_selectedSet containsObject:[NSNumber numberWithInteger:path.row]]) {
            [_selectedSet removeObject:[NSNumber numberWithInteger:path.row]];
        }

        [self.tableView reloadRowsAtIndexPaths:@[ path ] withRowAnimation:UITableViewRowAnimationFade];

    };

    cell.supportClick = ^(UITableViewCell *curCell) {

        @weakify(self);
        __block BOOL needLoadData = NO;

        void (^block)(void) = ^() {
            @strongify(self);
            NSIndexPath *path = [tableView indexPathForCell:curCell];
            PBMComment *comment = [_dataArray objectAtIndex:path.row];

            PBMSupport *supportData = [PBMSupport message];
            supportData.matchId = self.matchId;
            supportData.commentId = comment.commentId;
            supportData.gametype = 0;

            [[AFHTTPSessionManager dp_sharedManager] POST:@"/datacenter/SupportComment"
                parameters:supportData
                success:^(NSURLSessionDataTask *task, id responseObject) {
                    DPLog(@"点赞成功！！");
                    comment.supportCount += 1;
                    comment.isSupported = YES;
                    ((DPCommentTableCell *)curCell).agreeButton.title = [NSString stringWithFormat:@"%d", comment.supportCount];

                    ((DPCommentTableCell *)curCell).agreeButton.selected = YES;
                    ((DPCommentTableCell *)curCell).agreeButton.lastFlag = SelectStatusYES;
                    if (needLoadData) {
                        self.isDownLoad = YES;
                        [self request];
                    }
                }
                failure:^(NSURLSessionDataTask *task, NSError *error) {
                    DPLog(@"点赞失败！！");
                    [[DPToast makeText:[NSString stringWithFormat:@"%@", error.dp_errorMessage]] show];
                    ((DPCommentTableCell *)curCell).agreeButton.selected = NO;
                    ((DPCommentTableCell *)curCell).agreeButton.lastFlag = SelectStatusNO;
                    if (needLoadData) {
                        self.isDownLoad = YES;

                        [self request];
                    }

                }];
        };

        if ([DPMemberManager sharedInstance].isLogin) {
            needLoadData = NO;
            block();
        } else {
            needLoadData = YES;
            ((DPCommentTableCell *)curCell).agreeButton.selected = NO;
            ((DPCommentTableCell *)curCell).agreeButton.lastFlag = SelectStatusNO;
            DPLogOnViewController *viewController = [[DPLogOnViewController alloc] init];
            viewController.finishBlock = block;
            [self.navController pushViewController:viewController animated:YES];
        }

    };

    // Configure the cell...

    return cell;
}

- (AFHTTPSessionManager *)imageSessionMgr {
    if (_imageSessionMgr == nil) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 10;

        _imageSessionMgr = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:configuration];
        _imageSessionMgr.responseSerializer = [[AFImageResponseSerializer alloc] init];
        _imageSessionMgr.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    }
    return _imageSessionMgr;
}

- (void)setImageWitImageView:(UIImageView *)imgView imgLink:(NSString *)url {
    if (!url)
        return;

    UIImage *cachImg = [[AFImageDiskCache sharedCache] cachedImageForURL:url];

    if (cachImg) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            UIImage *roundImage = [cachImg dp_roundImageWithDiameter:40];

            dispatch_async(dispatch_get_main_queue(), ^{
                imgView.image = roundImage;
            });
        });
        return;
    }
    [self.imageSessionMgr GET:url
        parameters:nil
        success:^(NSURLSessionDataTask *task, UIImage *image) {

            // 处理图片
            UIImage *roundImage = [image dp_roundImageWithDiameter:40];

            // 缓存图片
            [[AFImageDiskCache sharedCache] cacheImage:image forURL:url];
            DPLog(@"图片请求成功");

            [[NSOperationQueue mainQueue] addOperation:[NSBlockOperation blockOperationWithBlock:^{
                                              imgView.image = roundImage;
                                          }]];
        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
            DPLog(@"图片请求失败");
            [[NSOperationQueue mainQueue] addOperation:[NSBlockOperation blockOperationWithBlock:^{
                                              imgView.image = dp_GameLiveImage(@"userIcon.png");
                                          }]];

        }];
}
#pragma mark - getter/setter
- (UIView *)commentView {
    if (_commentView == nil) {
        _commentView = [[UIView alloc] init];
        _commentView.backgroundColor = [UIColor dp_flatWhiteColor];

        [_commentView addSubview:self.inputTextField];
        [_commentView addSubview:self.sendButton];

        UIView *topLine = [UIView dp_viewWithColor:UIColorFromRGB(0xc8c7c2)];
        [_commentView addSubview:topLine];
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_commentView);
            make.left.and.right.equalTo(_commentView);
            make.height.equalTo(@0.5);
        }];
        [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_commentView).offset(5);
            make.top.equalTo(_commentView).offset(5);
            make.bottom.equalTo(_commentView).offset(-5);
        }];
        [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.inputTextField.mas_right).offset(5);
            make.right.equalTo(_commentView).offset(-5);
            make.top.equalTo(_commentView).offset(5);
            make.bottom.equalTo(_commentView).offset(-5);
            make.width.equalTo(self.sendButton.mas_height);
        }];
    }
    return _commentView;
}

- (UITextField *)inputTextField {
    if (_inputTextField == nil) {
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.backgroundColor = [UIColor clearColor];
        _inputTextField.placeholder = @"我说两句...";
        _inputTextField.font = [UIFont dp_systemFontOfSize:12];
        _inputTextField.textColor = UIColorFromRGB(0x333333);
        _inputTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"我说两句" attributes:[NSDictionary dictionaryWithObjectsAndKeys:NSForegroundColorAttributeName, UIColorFromRGB(0xd6d5da), nil]];
    }
    return _inputTextField;
}

- (UIButton *)sendButton {
    if (_sendButton == nil) {
        _sendButton = [[UIButton alloc] init];
        _sendButton.backgroundColor = [UIColor clearColor];
        [_sendButton setImage:dp_FeedbackResizeImage(@"messageFly.png") forState:UIControlStateSelected];
        [_sendButton setImage:dp_FeedbackResizeImage(@"messageFly.png") forState:UIControlStateNormal];
        _sendButton.contentMode = UIViewContentModeCenter;

        @weakify(self);
        void (^block)(void) = ^() {
            @strongify(self);
            PBMCommentData *commData = [PBMCommentData message];
            commData.matchId = self.matchId;
            commData.gametype = 0;
            commData.text = self.inputTextField.text;

            [[AFHTTPSessionManager dp_sharedManager] POST:@"/datacenter/SubmitComment"
                parameters:commData
                success:^(NSURLSessionDataTask *task, id responseObject) {
                    DPLog(@"success ....");
                    @strongify(self);
                    PBMFootComment *comment = [PBMFootComment parseFromData:responseObject error:nil];
                    [_dataArray removeAllObjects];
                    [_dataArray addObjectsFromArray:comment.commentArray];

                    [[DPToast makeText:@"评论成功"] show];
                    self.isDownLoad = NO;
                    self.viewModel.commendId = ((PBMComment *)[comment.commentArray lastObject]).commentId;
                    [self addInfinitView];
                    [self.tableView reloadData];

                    _lastTime = [[NSDate dp_date] timeIntervalSince1970];
                    self.inputTextField.text = @"";
                    [self.navController.view endEditing:YES];

                }
                failure:^(NSURLSessionDataTask *task, NSError *error) {

                    DPLog(@"failure ...%@", error);
                    [[DPToast makeText:[NSString stringWithFormat:@"%@", error.dp_errorMessage]] show];
                    self.emptyDataStyle.shouldDisplay = YES;

                }];

        };

        [[_sendButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            NSLog(@"click....");
            if ([[NSDate dp_date] timeIntervalSince1970] - _lastTime <= 5) {
                [[DPToast makeText:@"评论过于频繁,稍后再发"] show];
                return;
            } else if (self.inputTextField.text.length > 140) {
                [[DPToast makeText:@"最多只能发布140个字"] show];
                return;
            } else if (self.inputTextField.text.length <= 0) {
                [[DPToast makeText:@"请输入评论内容"] show];
                return;
            } else if (self.inputTextField.text.length <= 1) {
                [[DPToast makeText:@"至少输入1个字以上"] show];
                return;
            }

            if ([DPMemberManager sharedInstance].isLogin) {
                block();
            } else {
                DPLogOnViewController *viewController = [[DPLogOnViewController alloc] init];
                viewController.finishBlock = block;
                [self.navController pushViewController:viewController animated:YES];
            }

        }];
    }
    return _sendButton;
}

- (DZNEmptyDataStyle *)emptyDataStyle {
    if (_emptyDataStyle == nil) {
        _emptyDataStyle = [DZNEmptyDataStyle ctm_listStyle];
        _emptyDataStyle.ctm_noDataImage = dp_SportLiveImage(@"nocomment.png");
        _emptyDataStyle.ctm_noDataTitle = [[NSAttributedString alloc] initWithString:@""];
        _emptyDataStyle.verticalOffset = -80;
        _emptyDataStyle.shouldDisplay = NO;
    }
    return _emptyDataStyle;
}

@end
