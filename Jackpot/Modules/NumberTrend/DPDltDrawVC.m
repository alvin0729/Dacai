//
//  DPDltDrawVC.m
//  DacaiProject
//
//  Created by Ray on 15/2/9.
//  Copyright (c) 2015年 dacai. All rights reserved.
//

#import "DPDltDrawVC.h"
#import "DPDltDrawTrendViewModel.h"

@interface DPDltDrawVC () <DPTrendViewDelegate, DPDltDrawTrendViewModelDelegate> {
    UIImageView *_baseImgView;

    UIImage *_normalImage;    //常规走势图

    int _redBall[35];
    int _blueBall[12];

    int _normalThreadRes[3];
    int _threadRes[3][3];
}

@property (nonatomic, strong) DPDltDrawTrendViewModel *viewModel;
@end

@implementation DPDltDrawVC

- (instancetype)initWithTitles:(NSArray *)titleArray withDocTitles:(NSArray *)docTitles titleSelectColor:(UIColor *)selectColor titleNormalColor:(UIColor *)normlColor bottomImg:(UIImage *)bottomImg redBall:(NSArray *)redballs blueBall:(NSArray *)blueballs {
    self = [super initWithTitles:titleArray withDocTitles:docTitles titleSelectColor:selectColor titleNormalColor:normlColor bottomImg:bottomImg supportRota:YES];
    if (self) {
        _currentGameType = GameTypeDlt;
        for (int i = 0; i < 35; i++) {
            _redBall[i] = [[redballs objectAtIndex:i] intValue];
        }

        for (int i = 0; i < 12; i++) {
            _blueBall[i] = [[blueballs objectAtIndex:i] intValue];
        }

        for (int i = 0; i < 3; i++) {
            _normalThreadRes[i] = 1;
            for (int j = 0; j < 3; j++) {
                _threadRes[i][j] = 1;
            }
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self caculateBottom];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor dp_flatWhiteColor];

    self.redBallNumber = 35;
    
    [self.viewModel fetch];
}
#pragma mark - DPDrawInfoDockDelegate

- (void)changeDocIndex:(NSInteger)index {
    if (_navSelectIndex == 0) {
        if (self.dockView.currentDocIndex == 0) {
            _trendView.offset = CGPointMake(0, _trendView.offset.y);
        } else if (self.dockView.currentDocIndex == 1) {
            _trendView.offset = CGPointMake(self.redBallNumber * 25, _trendView.offset.y);
        }
    } else {
        if ([self dp_hasData]) {
            [self reloadTrendView:(int)TrendEnumToCount(self.trendSetting.issueIndex) miss:self.trendSetting.missOn broken:self.trendSetting.brokenOn stat:self.trendSetting.statOn info:self.trendSetting.infoOn];
        }
    }
}
- (BOOL)dp_hasData {
    return [self.viewModel hasData];
}

- (void)pvt_onSwitch:(DPSegmentedControl *)seg {
    [super pvt_onSwitch:seg];
    self.dockView.currentDocIndex = 0;
    DPLog(@"pvt_onSwitch ====  %d", _navSelectIndex);
    if (_navSelectIndex == 0) {
        self.dockView.titleArray = [NSArray arrayWithObjects:@"前区走势(红)", @"后区走势(蓝)", nil];

    } else if (_navSelectIndex == 1) {
        self.dockView.titleArray = [NSArray arrayWithObjects:@"一区走势", @"二区走势", @"三区走势", nil];
    }
    if ([self dp_hasData]) {
        [self reloadTrendView:(int)TrendEnumToCount(self.trendSetting.issueIndex) miss:self.trendSetting.missOn broken:self.trendSetting.brokenOn stat:self.trendSetting.statOn info:self.trendSetting.infoOn];
    }
}

- (void)pvt_refreshTopImg {
    int flag = 0;

    if (_navSelectIndex == 0) {
        if (_normalThreadRes[2] == 0) {
            return;
        } else {
            _normalThreadRes[2] = 0;
        }
    } else if (_navSelectIndex == 1) {
        int curIndex = (int)self.dockView.currentDocIndex;
        flag = curIndex + 1;

        if (_threadRes[curIndex][2] == 0) {
            return;
        } else {
            _threadRes[curIndex][2] = 0;
        }
    }

    __weak __typeof(self) weakSelf = self;

    @autoreleasepool {
        if (_navSelectIndex == 0) {
            NSMutableArray *topRedData = [[NSMutableArray alloc] init];
            for (int i = 1; i < 48; i++) {
                if (i >= 36) {
                    [topRedData addObject:[NSString stringWithFormat:@"%02d", i - 35]];
                    continue;
                }
                [topRedData addObject:[NSString stringWithFormat:@"%02d", i]];
            }
            DPDrawTrendImgData *topImgData = [self getImageDateWithTextColor:UIColorFromRGB(0x472700) rowCount:1 columnCount:47 lastCount:6 hasLine:NO withWinNumbers:topRedData isleft:NO statOn:YES isChinese:NO];

            [DPDrawTrendImgTool drawImageWithPriority:DISPATCH_QUEUE_PRIORITY_HIGH
                                                 data:topImgData
                                                 flag:flag
                                               finish:^(UIImage *image, int flag) {

                                                   dispatch_async(dispatch_get_main_queue(), ^{

                                                       if (_navSelectIndex == 0) {
                                                           if (flag == 0) {
                                                               _trendView.topImage = image;
                                                               [_trendView reloadData];
                                                           }
                                                       } else {
                                                           if (flag == weakSelf.dockView.currentDocIndex + 1) {
                                                               _trendView.topImage = image;
                                                               [_trendView reloadData];
                                                           }
                                                       }

                                                       if (flag == 0) {
                                                           _normalThreadRes[2] = YES;
                                                       } else {
                                                           _threadRes[flag - 1][2] = YES;
                                                       }

                                                   });
                                               }];

        } else {
            DPDrawTrendImgData *topImgData = [self getImageDateWithTextColor:UIColorFromRGB(0x472700) rowCount:1 columnCount:(self.dockView.currentDocIndex == 1 ? 17 : 18)lastCount:6 hasLine:NO withWinNumbers:[self getiImageDataArray:self.dockView.currentDocIndex totalNum:(self.dockView.currentDocIndex == 1 ? 17 : 18)lastNum:6] isleft:NO statOn:YES isChinese:NO];
            [DPDrawTrendImgTool drawImageWithPriority:DISPATCH_QUEUE_PRIORITY_HIGH
                                                 data:topImgData
                                                 flag:flag
                                               finish:^(UIImage *image, int flag) {

                                                   dispatch_async(dispatch_get_main_queue(), ^{

                                                       if (_navSelectIndex == 0) {
                                                           if (flag == 0) {
                                                               _trendView.topImage = image;
                                                               [_trendView reloadData];
                                                           }
                                                       } else {
                                                           if (flag == weakSelf.dockView.currentDocIndex + 1) {
                                                               _trendView.topImage = image;
                                                               [_trendView reloadData];
                                                           }
                                                       }

                                                       if (flag == 0) {
                                                           _normalThreadRes[2] = YES;
                                                       } else {
                                                           _threadRes[flag - 1][2] = YES;
                                                       }

                                                   });

                                               }];
        }
    }
}

- (void)pvt_refreshLeftImg {
    int flag = 0;
    if (_navSelectIndex == 0) {
        if (_normalThreadRes[0] == 0) {
            return;
        } else {
            _normalThreadRes[0] = 0;
        }
    } else if (_navSelectIndex == 1) {
        int curIndex = (int)self.dockView.currentDocIndex;
        flag = curIndex + 1;
        if (_threadRes[curIndex][0] == 0) {
            return;
        } else {
            _threadRes[curIndex][0] = 0;
        }
    }

    __weak __typeof(self) weakSelf = self;

    @autoreleasepool {
        int gameNames[200] = {0};

        int issueNumbers = (int)TrendEnumToCount(self.trendSetting.issueIndex);
        [self.viewModel getChartGameNames:gameNames count:issueNumbers];

        NSMutableArray *namesArray = [[NSMutableArray alloc] initWithCapacity:issueNumbers];
        for (int i = 0; i < issueNumbers; i++) {
            NSString *ss = [NSString stringWithFormat:@"%03d期", gameNames[i] % 1000];

            [namesArray addObject:ss];
        }
        DPDrawTrendImgData *imageData1 = [self getImageDateWithTextColor:UIColorFromRGB(0x472700) rowCount:issueNumbers columnCount:1 lastCount:6 hasLine:NO withWinNumbers:namesArray isleft:YES statOn:NO isChinese:YES];
        if (self.trendSetting.statOn == NO) {
            [DPDrawTrendImgTool drawImageWithPriority:DISPATCH_QUEUE_PRIORITY_HIGH
                                                 data:imageData1
                                                 flag:flag
                                               finish:^(UIImage *image, int flag) {

                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       if (_navSelectIndex == 0) {
                                                           if (flag == 0) {
                                                               _trendView.leftImage = image;
                                                               [_trendView reloadData];
                                                           }
                                                       } else {
                                                           if (flag == weakSelf.dockView.currentDocIndex + 1) {
                                                               _trendView.leftImage = image;
                                                               [_trendView reloadData];
                                                           }
                                                       }

                                                       if (flag == 0) {
                                                           _normalThreadRes[0] = YES;
                                                       } else {
                                                           _threadRes[flag - 1][0] = YES;
                                                       }

                                                   });

                                               }];

            return;
        }

        NSMutableArray *bottomArray = [[NSMutableArray alloc] initWithCapacity:4];
        for (int i = 0; i < 4; i++) {
            NSString *ss;
            if (i == 0) {
                ss = @"最大连出";
            } else if (i == 1) {
                ss = @"最大遗漏";
            } else if (i == 2) {
                ss = @"平均遗漏";
            } else if (i == 3) {
                ss = @"出现次数";
            }

            [bottomArray addObject:ss];
        }
        DPDrawTrendImgData *imageData2 = [self getImageDateWithTextColor:UIColorFromRGB(0x472700) rowCount:4 columnCount:1 lastCount:6 hasLine:NO withWinNumbers:bottomArray isleft:YES statOn:YES isChinese:YES];

        [DPDrawTrendImgTool drawVerticalCombinationImageWithPriority:DISPATCH_QUEUE_PRIORITY_HIGH
                                                               Data1:imageData1
                                                               data2:imageData2
                                                                flag:flag
                                                              finish:^(UIImage *image, int flag) {
                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      if (_navSelectIndex == 0) {
                                                                          if (flag == 0) {
                                                                              _trendView.leftImage = image;
                                                                              [_trendView reloadData];
                                                                          }
                                                                      } else {
                                                                          if (flag == weakSelf.dockView.currentDocIndex + 1) {
                                                                              _trendView.leftImage = image;
                                                                              [_trendView reloadData];
                                                                          }
                                                                      }

                                                                      if (flag == 0) {
                                                                          _normalThreadRes[0] = YES;
                                                                      } else {
                                                                          _threadRes[weakSelf.dockView.currentDocIndex][0] = YES;
                                                                      }

                                                                  });
                                                              }];
    }
}
- (void)pvt_refreshCenterImg {
    int flag = 0;
    if (_navSelectIndex == 0) {
        if (_normalThreadRes[1] == 0) {
            return;
        } else {
            _normalThreadRes[1] = 0;
        }
    } else {
        int curIndex = (int)self.dockView.currentDocIndex;
        flag = curIndex + 1;

        if (_threadRes[curIndex][1] == 0) {
            return;
        } else {
            _threadRes[curIndex][1] = 0;
        }
    }
    _trendView.centerImage = nil;

    __weak __typeof(self) weakSelf = self;

    @autoreleasepool {
        int issueNumbers = (int)TrendEnumToCount(self.trendSetting.issueIndex);

        int drawValue[200][49] = {0};
        if (_navSelectIndex == 0) {
            int redValue[200][35];
            int blueValue[200][12];
            [self.viewModel getChartNormalRed:redValue blue:blueValue count:issueNumbers];
            for (int i = 0; i < 35; i++) {
                for (int j = 0; j < issueNumbers; j++) {
                    drawValue[j][i] = redValue[j][i];
                }
            }

            DPDrawTrendImgData *imageData1 = [self getImageDateWithTextColor:UIColorFromRGB(0xC7BDB3) ShapColor:[UIColor dp_flatRedColor] rowCount:issueNumbers columnCount:35 lastNumbers:6 hasLine:NO withDatas:drawValue isBottom:NO missOn:self.trendSetting.missOn hasRightLine:YES];

            for (int i = 0; i < 12; i++) {
                for (int j = 0; j < issueNumbers; j++) {
                    drawValue[j][i] = blueValue[j][i];
                }
            }
            DPDrawTrendImgData *imageData2 = [self getImageDateWithTextColor:UIColorFromRGB(0xC7BDB3) ShapColor:[UIColor dp_flatBlueColor] rowCount:issueNumbers columnCount:12 lastNumbers:6 hasLine:NO withDatas:drawValue isBottom:NO missOn:self.trendSetting.missOn hasRightLine:NO];

            if (!self.trendSetting.statOn) {
                [DPDrawTrendImgTool drawHorizontalCombinationImageWithPriority:DISPATCH_QUEUE_PRIORITY_DEFAULT
                                                                         Data1:imageData1
                                                                         data2:imageData2
                                                                          flag:flag
                                                                        finish:^(UIImage *image, int flag) {

                                                                            dispatch_async(dispatch_get_main_queue(), ^{

                                                                                if (_navSelectIndex == 0) {
                                                                                    if (flag == 0) {
                                                                                        _trendView.centerImage = image;
                                                                                        [_trendView reloadData];
                                                                                    }
                                                                                } else {
                                                                                    if (flag == weakSelf.dockView.currentDocIndex + 1) {
                                                                                        _trendView.centerImage = image;
                                                                                        [_trendView reloadData];
                                                                                    }
                                                                                }

                                                                                if (flag == 0) {
                                                                                    _normalThreadRes[1] = YES;
                                                                                } else {
                                                                                    _threadRes[flag - 1][1] = YES;
                                                                                }

                                                                            });

                                                                        }];

                return;
            }

            int dataValue[4][47];
            [self.viewModel getChartStatisticsValue:dataValue type:0 count:self.trendSetting.infoOn ? issueNumbers : 0];
            for (int i = 0; i < 47; i++) {
                for (int j = 0; j < 4; j++) {
                    drawValue[j][i] = dataValue[j][i];
                }
            }
            DPDrawTrendImgData *imageData3 = [self getImageDateWithTextColor:UIColorFromRGB(0xC7BDB3) ShapColor:[UIColor dp_flatBlueColor] rowCount:4 columnCount:47 lastNumbers:6 hasLine:NO withDatas:drawValue isBottom:YES missOn:YES hasRightLine:YES];

            [DPDrawTrendImgTool drawThreeCombineImgMidLineWithPriority:DISPATCH_QUEUE_PRIORITY_DEFAULT
                                                                 data1:imageData1
                                                                 data2:imageData2
                                                                 data3:imageData3
                                                                  flag:flag
                                                                finish:^(UIImage *image, int flag) {
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        if (_navSelectIndex == 0) {
                                                                            if (flag == 0) {
                                                                                _trendView.centerImage = image;
                                                                                [_trendView reloadData];
                                                                            }
                                                                        } else {
                                                                            if (flag == weakSelf.dockView.currentDocIndex + 1) {
                                                                                _trendView.centerImage = image;
                                                                                [_trendView reloadData];
                                                                            }
                                                                        }

                                                                        if (flag == 0) {
                                                                            _normalThreadRes[1] = YES;
                                                                        } else {
                                                                            _threadRes[flag - 1][1] = YES;
                                                                        }
                                                                    });

                                                                }];

        } else if (_navSelectIndex == 1) {
            if (self.dockView.currentDocIndex == 0) {
                int redValue[200][12];
                int blueValue[200][6];
                [self.viewModel getChartOneAreaRed:redValue area:blueValue count:issueNumbers];
                [self getCenterImgWithType:1 rowNumber:issueNumbers withRedValue:redValue blueValue:blueValue statOn:self.trendSetting.statOn infoOn:self.trendSetting.infoOn];
            } else if (self.dockView.currentDocIndex == 2) {
                int redValue[200][12];
                int blueValue[200][6];
                [self.viewModel getChartThreeAreaRed:redValue area:blueValue count:issueNumbers];
                [self getCenterImgWithType:3 rowNumber:issueNumbers withRedValue:redValue blueValue:blueValue statOn:self.trendSetting.statOn infoOn:self.trendSetting.infoOn];

            } else if (self.dockView.currentDocIndex == 1) {
                int redValue[200][11];
                int blueValue[200][6];
                [self.viewModel getChartTwoAreaRed:redValue area:blueValue count:issueNumbers];
                for (int i = 0; i < 11; i++) {
                    for (int j = 0; j < issueNumbers; j++) {
                        drawValue[j][i] = redValue[j][i];
                    }
                }

                DPDrawTrendImgData *imageData1 = [self getImageDateWithTextColor:UIColorFromRGB(0xC7BDB3) ShapColor:[UIColor dp_flatRedColor] rowCount:issueNumbers columnCount:11 lastNumbers:6 hasLine:NO withDatas:drawValue isBottom:NO missOn:self.trendSetting.missOn hasRightLine:YES isRightData:NO];

                for (int i = 0; i < 6; i++) {
                    for (int j = 0; j < issueNumbers; j++) {
                        drawValue[j][i] = blueValue[j][i];
                    }
                }
                DPDrawTrendImgData *imageData2 = [self getImageDateWithTextColor:UIColorFromRGB(0xC7BDB3) ShapColor:UIColorFromRGB(0xF88A37) rowCount:issueNumbers columnCount:6 lastNumbers:6 hasLine:self.trendSetting.brokenOn withDatas:drawValue isBottom:NO missOn:self.trendSetting.missOn hasRightLine:NO isRightData:YES];

                if (!self.trendSetting.statOn) {
                    [DPDrawTrendImgTool drawHorizontalCombinationImageWithPriority:DISPATCH_QUEUE_PRIORITY_DEFAULT
                                                                             Data1:imageData1
                                                                             data2:imageData2
                                                                              flag:flag
                                                                            finish:^(UIImage *image, int flag) {

                                                                                dispatch_async(dispatch_get_main_queue(), ^{

                                                                                    if (_navSelectIndex == 0) {
                                                                                        if (flag == 0) {
                                                                                            _trendView.centerImage = image;
                                                                                            [_trendView reloadData];
                                                                                        }
                                                                                    } else {
                                                                                        if (flag == weakSelf.dockView.currentDocIndex + 1) {
                                                                                            _trendView.centerImage = image;
                                                                                            [_trendView reloadData];
                                                                                        }
                                                                                    }

                                                                                    if (flag == 0) {
                                                                                        _normalThreadRes[1] = YES;
                                                                                    } else {
                                                                                        _threadRes[flag - 1][1] = YES;
                                                                                    }
                                                                                });
                                                                            }];
                    return;
                }

                int dataValue[4][47];
                [self.viewModel getChartStatisticsValue:dataValue type:2 count:self.trendSetting.infoOn ? issueNumbers : 0];
                for (int i = 0; i < 17; i++) {
                    for (int j = 0; j < 4; j++) {
                        drawValue[j][i] = dataValue[j][i];
                    }
                }
                DPDrawTrendImgData *imageData3 = [self getImageDateWithTextColor:UIColorFromRGB(0xC7BDB3) ShapColor:[UIColor dp_flatBlueColor] rowCount:4 columnCount:17 lastNumbers:6 hasLine:NO withDatas:drawValue isBottom:YES missOn:YES hasRightLine:YES isRightData:YES];
                [DPDrawTrendImgTool drawThreeCombineImgMidLineWithPriority:DISPATCH_QUEUE_PRIORITY_DEFAULT
                                                                     data1:imageData1
                                                                     data2:imageData2
                                                                     data3:imageData3
                                                                      flag:flag
                                                                    finish:^(UIImage *image, int flag) {
                                                                        dispatch_async(dispatch_get_main_queue(), ^{

                                                                            if (_navSelectIndex == 0) {
                                                                                if (flag == 0) {
                                                                                    _trendView.centerImage = image;
                                                                                    [_trendView reloadData];
                                                                                }
                                                                            } else {
                                                                                if (flag == weakSelf.dockView.currentDocIndex + 1) {
                                                                                    _trendView.centerImage = image;
                                                                                    [_trendView reloadData];
                                                                                }
                                                                            }

                                                                            if (flag == 0) {
                                                                                _normalThreadRes[1] = YES;
                                                                            } else {
                                                                                _threadRes[flag - 1][1] = YES;
                                                                            }

                                                                        });

                                                                    }];
            }
        }
    }
}

- (void)pvt_refreshBottom {
    int selectRedBall[12] = {0};

    if (_navSelectIndex == 0) {
        NSMutableArray *array = [NSMutableArray array];
        NSMutableArray *array2 = [NSMutableArray array];
        for (int i = 0; i < 35; i++) {
            [array addObject:[NSString stringWithFormat:@"%02d", i + 1]];
        }
        for (int i = 0; i < 12; i++) {
            [array2 addObject:[NSString stringWithFormat:@"%02d", i + 1]];
        }

        [self.bottomView createTrendBottomBallView:array blueArray:array2 rowWidth:25 normalBallTextColor:UIColorFromRGB(0x665445) selectBallTextColor:UIColorFromRGB(0xffffff) normalbackImage:dp_DigitLotteryImage(@"ballNormal001_0.png") selectRedBackImage:dp_DigitLotteryImage(@"ballSelectedRed001_07.png") selectBlueBackImage:dp_DigitLotteryImage(@"ballSelectedBlue001_14.png") redBall:_redBall blueBall:_blueBall];

    } else if (_navSelectIndex == 1) {
        if (self.dockView.currentDocIndex == 0) {
            //测试
            NSMutableArray *array = [NSMutableArray array];
            for (int i = 0; i < 12; i++) {
                [array addObject:[NSString stringWithFormat:@"%02d", i + 1]];
            }
            [self.bottomView createTrendBottomBallView:array blueArray:nil rowWidth:25 normalBallTextColor:UIColorFromRGB(0x665445) selectBallTextColor:UIColorFromRGB(0xffffff) normalbackImage:dp_DigitLotteryImage(@"ballNormal001_0.png") selectRedBackImage:dp_DigitLotteryImage(@"ballSelectedRed001_07.png") selectBlueBackImage:dp_DigitLotteryImage(@"ballSelectedBlue001_14.png") redBall:[self getRedBallSelected:selectRedBall total:12] blueBall:nil];

        } else if (self.dockView.currentDocIndex == 1) {    //二区
                                                            //测试
            NSMutableArray *array = [NSMutableArray array];
            for (int i = 12; i < 24; i++) {
                [array addObject:[NSString stringWithFormat:@"%02d", i + 1]];
            }
            [self.bottomView createTrendBottomBallView:array blueArray:nil rowWidth:25 normalBallTextColor:UIColorFromRGB(0x665445) selectBallTextColor:UIColorFromRGB(0xffffff) normalbackImage:dp_DigitLotteryImage(@"ballNormal001_0.png") selectRedBackImage:dp_DigitLotteryImage(@"ballSelectedRed001_07.png") selectBlueBackImage:dp_DigitLotteryImage(@"ballSelectedBlue001_14.png") redBall:[self getRedBallSelected:selectRedBall total:12] blueBall:nil];

        } else if (self.dockView.currentDocIndex == 2) {    //三区走势

            //测试
            NSMutableArray *array = [NSMutableArray array];
            for (int i = 24; i < 35; i++) {
                [array addObject:[NSString stringWithFormat:@"%02d", i + 1]];
            }
            [self.bottomView createTrendBottomBallView:array blueArray:nil rowWidth:25 normalBallTextColor:UIColorFromRGB(0x665445) selectBallTextColor:UIColorFromRGB(0xffffff) normalbackImage:dp_DigitLotteryImage(@"ballNormal001_0.png") selectRedBackImage:dp_DigitLotteryImage(@"ballSelectedRed001_07.png") selectBlueBackImage:dp_DigitLotteryImage(@"ballSelectedBlue001_14.png") redBall:[self getRedBallSelected:selectRedBall total:11] blueBall:nil];
        }
    }
}

- (NSArray *)getiImageDataArray:(NSInteger)docIndex totalNum:(int)totalNum lastNum:(int)lastNum {
    NSMutableArray *topRedData = [[NSMutableArray alloc] init];
    for (int i = 1; i <= totalNum; i++) {
        if (i <= totalNum - lastNum) {
            [topRedData addObject:[NSString stringWithFormat:@"%02d", (int)(i + (self.dockView.currentDocIndex == 1 ? 12 : (self.dockView.currentDocIndex == 0 ? 0 : 23)))]];
        } else {
            [topRedData addObject:[NSString stringWithFormat:@"%d个", i - (totalNum - lastNum) - 1]];
        }
    }
    return topRedData;
}
- (void)reloadTrendView:(int)issueNumbers miss:(BOOL)missOn broken:(BOOL)brokenOn stat:(BOOL)statOn info:(BOOL)infoOn {
    [self pvt_refreshLeftImg];
    [self pvt_refreshTopImg];
    [self pvt_refreshCenterImg];
    [self pvt_refreshBottom];
}

- (void)finishedSelectedBallForBottomView {
    if (self.modifyBalls) {
        self.modifyBalls(_blueBall, _redBall);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getCenterImgWithType:(int)type rowNumber:(int)rowNumbers withRedValue:(int[200][12])redValue blueValue:(int[200][6])blueValue statOn:(BOOL)statOn infoOn:(BOOL)infoOn {
    int curIndex = (int)self.dockView.currentDocIndex;
    int flag = curIndex + 1;

    __weak __typeof(self) weakSelf = self;
    int drawValue[200][49] = {0};
    for (int i = 0; i < 12; i++) {
        for (int j = 0; j < rowNumbers; j++) {
            drawValue[j][i] = redValue[j][i];
        }
    }

    DPDrawTrendImgData *imageData1 = [self getImageDateWithTextColor:UIColorFromRGB(0xC7BDB3) ShapColor:[UIColor dp_flatRedColor] rowCount:rowNumbers columnCount:12 lastNumbers:6 hasLine:NO withDatas:drawValue isBottom:NO missOn:self.trendSetting.missOn hasRightLine:YES isRightData:NO];

    for (int i = 0; i < 6; i++) {
        for (int j = 0; j < rowNumbers; j++) {
            drawValue[j][i] = blueValue[j][i];
        }
    }
    DPDrawTrendImgData *imageData2 = [self getImageDateWithTextColor:UIColorFromRGB(0xC7BDB3) ShapColor:UIColorFromRGB(0xF88A37) rowCount:rowNumbers columnCount:6 lastNumbers:6 hasLine:self.trendSetting.brokenOn withDatas:drawValue isBottom:NO missOn:self.trendSetting.missOn hasRightLine:NO isRightData:YES];

    if (!statOn) {
        [DPDrawTrendImgTool drawHorizontalCombinationImageWithPriority:DISPATCH_QUEUE_PRIORITY_DEFAULT
                                                                 Data1:imageData1
                                                                 data2:imageData2
                                                                  flag:flag
                                                                finish:^(UIImage *image, int flag) {

                                                                    dispatch_async(dispatch_get_main_queue(), ^{

                                                                        if (_navSelectIndex == 0) {
                                                                            if (flag == 0) {
                                                                                _trendView.centerImage = image;
                                                                                [_trendView reloadData];
                                                                            }
                                                                        } else {
                                                                            if (flag == weakSelf.dockView.currentDocIndex + 1) {
                                                                                _trendView.centerImage = image;
                                                                                [_trendView reloadData];
                                                                            }
                                                                        }

                                                                        if (flag == 0) {
                                                                            _normalThreadRes[1] = YES;
                                                                        } else {
                                                                            _threadRes[flag - 1][1] = YES;
                                                                        }
                                                                    });
                                                                }];
        return;
    }

    int dataValue[4][47];
    [self.viewModel getChartStatisticsValue:dataValue type:type count:infoOn ? (int)TrendEnumToCount(self.trendSetting.issueIndex) : 0];
    for (int i = 0; i < 18; i++) {
        for (int j = 0; j < 4; j++) {
            drawValue[j][i] = dataValue[j][i];
        }
    }
    DPDrawTrendImgData *imageData3 = [self getImageDateWithTextColor:UIColorFromRGB(0xC7BDB3) ShapColor:[UIColor dp_flatBlueColor] rowCount:4 columnCount:18 lastNumbers:6 hasLine:NO withDatas:drawValue isBottom:YES missOn:YES hasRightLine:YES isRightData:YES];

    [DPDrawTrendImgTool drawThreeCombineImgMidLineWithPriority:DISPATCH_QUEUE_PRIORITY_DEFAULT
                                                         data1:imageData1
                                                         data2:imageData2
                                                         data3:imageData3
                                                          flag:flag
                                                        finish:^(UIImage *image, int flag) {
                                                            dispatch_async(dispatch_get_main_queue(), ^{

                                                                if (_navSelectIndex == 0) {
                                                                    if (flag == 0) {
                                                                        _trendView.centerImage = image;
                                                                        [_trendView reloadData];
                                                                    }
                                                                } else {
                                                                    if (flag == weakSelf.dockView.currentDocIndex + 1) {
                                                                        _trendView.centerImage = image;
                                                                        [_trendView reloadData];
                                                                    }
                                                                }

                                                                if (flag == 0) {
                                                                    _normalThreadRes[1] = YES;
                                                                } else {
                                                                    _threadRes[flag - 1][1] = YES;
                                                                }

                                                            });

                                                        }];
}

//#pragma makr- 更新底部所选小球的状态

- (int *)getRedBallSelected:(int[12])redBall total:(int)total {
    for (int i = 0; i < total; i++) {
        redBall[i] = _redBall[i + 12 * self.dockView.currentDocIndex];
    }

    return redBall;
}
#pragma makr - 更新底部选中文字
- (void)caculateBottom {
    NSMutableString *redString = [[NSMutableString alloc] initWithString:@""];
    for (int i = 0; i < 35; i++) {
        if (_redBall[i]) {
            [redString appendString:[NSString stringWithFormat:@"%02d ", i + 1]];
        }
    }

    NSMutableString *blueString = [[NSMutableString alloc] initWithString:@""];
    for (int i = 0; i < 12; i++) {
        if (_blueBall[i]) {
            [blueString appendString:[NSString stringWithFormat:@"%02d ", i + 1]];
        }
    }

    NSMutableAttributedString *hinstring = [[NSMutableAttributedString alloc] initWithString:redString];

    if (blueString.length && redString.length) {
        [hinstring appendAttributedString:[[NSAttributedString alloc] initWithString:@"| "]];
    }

    [hinstring appendAttributedString:[[NSAttributedString alloc] initWithString:blueString]];

    [hinstring addAttribute:NSForegroundColorAttributeName value:(id)[UIColor dp_flatRedColor] range:NSMakeRange(0, redString.length)];

    if (redString.length && blueString.length) {
        [hinstring addAttribute:NSForegroundColorAttributeName value:(id)UIColorFromRGB(0xA0A0A0) range:NSMakeRange(redString.length, 1)];
        [hinstring addAttribute:NSForegroundColorAttributeName value:(id)[UIColor dp_flatBlueColor] range:NSMakeRange(redString.length + 1, blueString.length)];
    } else {
        [hinstring addAttribute:NSForegroundColorAttributeName value:(id)[UIColor dp_flatBlueColor] range:NSMakeRange(redString.length, blueString.length)];
    }

    [self.bottomView selectedballInfoLabelText:hinstring];
}

- (void)saveSelectedBallForBottomView:(NSInteger)index isSelected:(BOOL)isSelected {
    if (_navSelectIndex == 0) {
        if (index > 34) {
            _blueBall[index - 35] = isSelected;
        } else
            _redBall[index] = isSelected;

    } else if (_navSelectIndex == 1) {
        _redBall[index + self.dockView.currentDocIndex * 12] = isSelected;
    }
    [self caculateBottom];
}

#pragma mark - Delegate
#pragma mark - DPDltDrawTrendViewModelDelegate

- (void)trendViewModel:(DPDltDrawTrendViewModel *)viewModel error:(NSError *)error {
    if (!error) {
        [self reloadTrendView:(int)TrendEnumToCount(self.trendSetting.issueIndex)
                         miss:self.trendSetting.missOn
                       broken:self.trendSetting.brokenOn
                         stat:self.trendSetting.statOn
                         info:self.trendSetting.infoOn];
    }
}


#pragma mark - Property (getter, setter)

- (DPDltDrawTrendViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[DPDltDrawTrendViewModel alloc] init];
        _viewModel.delegate = self;
    }
    return _viewModel;
}

@end
