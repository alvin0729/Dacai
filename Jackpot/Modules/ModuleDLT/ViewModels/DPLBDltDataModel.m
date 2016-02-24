//
//  DPLBDltDataModel.m
//  DacaiProject
//
//  Created by jacknathan on 15-1-26.
//  Copyright (c) 2015年 dacai. All rights reserved.
//  本页面有sxf做注释，他人如有更改，请标明

#import "DPLBDltDataModel.h"
#import "DPLBCellViewModel.h"
#import "DPDltBetData.h"

@implementation DPLBDltDataModel

{
@private
    int _normalRed[DLTREDNUM];//普通红
    int _normalBlue[DLTBLUENUM];//普通蓝
    int _danRed[DLTREDNUM];//胆拖红
    int _danBlue[DLTBLUENUM];//胆拖蓝
    int _maxNum ;//可以选择的最大数
}
@synthesize viewModel       = _viewModel;
- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}
//彩种信息
- (GameTypeId)gameType
{
    return GameTypeDlt ;
}
//彩种玩法标题
- (NSArray *)titleArray
{
    return @[@"大乐透普通", @"大乐透胆拖"];
}
//注数
- (NSInteger)note
{
    int red[DLTREDNUM];
    int blue[DLTBLUENUM];
    [self touzhuInfo:red target2:blue];
    return [DPNoteCalculater calcDltWithRed:red blue:blue];
}
- (BOOL)hasData
{
    return NO;
}
//红篮球转换
- (void)touzhuInfo:(int[])red target2:(int[])blue {
    if (self.gameIndex == 0) {
        for(int i=0;i<DLTREDNUM;i++){
            red[i]=_normalRed[i];
        }
        for(int i=0;i<DLTBLUENUM;i++){
            blue[i]=_normalBlue[i];
        }
    }else if (self.gameIndex == 1){
        
        for(int i=0;i<DLTREDNUM;i++){
            red[i]=_danRed[i];
        }
        for(int i=0;i<DLTBLUENUM;i++){
            blue[i]=_danBlue[i];
        }
    }
}
//第一响应
- (BOOL)canBecomeFirstResponder
{
    if (self.gameIndex == 1) {
        return NO;
    }
    return YES;
}
//胆拖没有随机一注，因此这个是判断随机一注是否隐藏的
- (BOOL)isRandomBtnHidden
{
    return self.gameIndex;
}
//清空数据源
-(void)clearAllSelectedData{
    if (self.gameIndex == 0) {
        memset(_normalRed, 0, sizeof(_normalRed));
        memset(_normalBlue, 0, sizeof(_normalBlue));
    }else if (self.gameIndex == 1){
        memset(_danRed, 0, sizeof(_danRed));
        memset(_danBlue, 0, sizeof(_danBlue));
    }
}

//大乐透随机一注
- (void)digitalDataRandom {
    int red[DLTREDNUM] = {0};
    [self partRandom:5 total:DLTREDNUM target2:red];
    for (int i=0; i<DLTREDNUM; i++) {
        _normalRed[i]=red[i];
    }
    
    int blue[DLTBLUENUM] = {0};
    [self partRandom:2 total:DLTBLUENUM target2:blue];
    for (int i=0; i<DLTBLUENUM; i++) {
        _normalBlue[i]=blue[i];
    }
    
}
//默认的普通投注
- (NSDictionary *)ballUIDict
{
    if (_ballUIDict == nil) {
        _ballUIDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"35", @"12", nil], @"total",
                       [NSArray arrayWithObjects:@"35", @"12", nil], @"maxTotal",
                       [NSArray arrayWithObjects:@"前区，至少选择5个号码", @"后区，至少选择2个号码", nil],@"title",
                       @"2", @"totalRow",
                       [NSArray arrayWithObjects:@"1", @"0", nil], @"redColor",
                       nil];
    }
    return _ballUIDict;
}
//切换不同玩法
- (void)reloadGameIndex:(NSInteger)gameIndex
{
    self.gameIndex = gameIndex;
    switch (gameIndex) {
        case 0: {
            self.ballUIDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"35", @"12", nil], @"total",
                               [NSArray arrayWithObjects:@"35", @"12", nil], @"maxTotal",
                               [NSArray arrayWithObjects:@"前区，至少选择5个号码", @"后区，至少选择2个号码", nil], @"title",
                               @"2", @"totalRow",
                               [NSArray arrayWithObjects:@"1", @"0", nil], @"redColor",
                               nil];
            //            self.isRandomBtnHidden = NO;
        } break;
        case 1: {
            self.ballUIDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"35", @"35", @"12", @"12", nil], @"total",
                               [NSArray arrayWithObjects:@"4", @"35",@"1", @"12", nil], @"maxTotal",
                               [NSArray arrayWithObjects:@"胆码前区，至少选择1个，至多4个", @"拖码前区，至少选择2个", @"胆码后区，最多选择1个号码", @"拖码后区，至少选择2个号码", nil], @"title",
                               @"4", @"totalRow",
                               [NSArray arrayWithObjects:@"1", @"1", @"0", @"0", nil], @"redColor",
                               nil];
            //            self.isRandomBtnHidden = YES;
        } break;
        default:
            break;
    }
}

//当前区已经选了多少个球
- (NSInteger)numberOfSelectedBallsForRow:(NSInteger)row gameIndex:(NSInteger)gameIndex
{
    NSInteger total = 0;
    if (gameIndex == 0) {
        if (row == 0) {
            for (int i = 0; i < DLTREDNUM; i++) {
                if (_normalRed[i] == 1) total++;
            }
        }else if (row == 1){
            for (int i = 0; i < DLTBLUENUM; i++) {
                if (_normalBlue[i] == 1) total++;
            }
        }
        
    }else{
        if (row == 0) {
            for (int i = 0; i < DLTREDNUM; i++) {
                if (_danRed[i] == -1) total++;
            }
        }else if (row == 1){
            for (int i = 0; i < DLTREDNUM; i++) {
                if (_danRed[i] == 1) total++;
            }
        }else if (row ==2){
            for (int i = 0; i < DLTBLUENUM; i++) {
                if (_danBlue[i] == -1) total++;
            }
        }else if (row ==3){
            for (int i = 0; i < DLTBLUENUM; i++) {
                if (_danBlue[i] == 1) total++;
            }
        }
    }
    return total;
}

- (void)refreshBalls:(int[12])blue redBalls:(int[35])red {

    for (int i=0; i<DLTBLUENUM; i++) {
        _normalBlue[i] = blue[i] ;
    }
    
    for (int i=0; i<DLTREDNUM; i++) {
        _normalRed[i] = red[i] ;
    }
    self.gameIndex = 0 ;
    [self reloadGameIndex:0];

    
//    switch (self.gameIndex) {
//        case 0:
//        {
//            for (int i=0; i<DLTBLUENUM; i++) {
//                _normalBlue[i] = blue[i] ;
//            }
//            
//            for (int i=0; i<DLTREDNUM; i++) {
//                _normalRed[i] = red[i] ;
//            }
//           
//        }
//            break;
//       
//        default:
//            break;
//    }
//

}

 // 刷新选中状态
- (void)refreshBallSelected:(BOOL)selected index:(NSInteger)index row:(NSInteger)row
{
    switch (self.gameIndex) {
        case 0:
        {
            if (row == 0) {
                _normalRed[index] = selected;
            }else if (row==1){
                _normalBlue[index] = selected;
            }
        }
            break;
        case 1:
        {
            if (row==0) {
                _danRed[index]=(selected == 0 ? 0 : -1);
            }else if(row==1){
                _danRed[index] = selected;
            }else if(row==2){
                _danBlue[index] = (selected == 0 ? 0 : -1);
            }else if (row == 3){
                _danBlue[index] = selected;
            }
        }
            break;
        default:
            break;
    }
    
}

//中转页面跳过来的时候的处理
- (void)setIndexPathRow:(NSInteger)indexPathRow
{
    _indexPathRow = indexPathRow;
    
    int gameIndex = 0;
    DPDltBetData *dltData=[self.viewModel.infoArray objectAtIndex:indexPathRow];
    if (dltData.mark) {
        gameIndex = 1; // 胆拖
    }
    self.gameIndex = gameIndex;
    
    if (gameIndex == 0) {
        for (int i=0; i<DLTREDNUM; i++) {
            _normalRed[i]=[dltData.red[i] intValue];
        }
        for (int i=0; i<DLTBLUENUM; i++) {
            _normalBlue[i]=[dltData.blue[i] intValue];
        }
    }else{
        for (int i=0; i<DLTREDNUM; i++) {
            _danRed[i]=[dltData.red[i] intValue];
        }
        for (int i=0; i<DLTBLUENUM; i++) {
            _danBlue[i]=[dltData.blue[i] intValue];
        }
    }
    [self reloadGameIndex:gameIndex];


}
//行数
- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    if (self.gameIndex == 0) {
        return 2;
    }else{
        return 4;
    }
}
//走势cell
- (NSString *)trendCellClass
{
    return kDPHistoryTendencyCell;
}
//投注cell
- (NSString *)numberCellClass
{
    return kDPDigitalBallCell;
}
//走势图cell高度
- (CGFloat)trendCellHeight
{
    return 23.5;
}
//投注行cell高度
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [self.ballUIDict objectForKey:@"total"];
    int ballTotal = 0;
    if (array.count > indexPath.row) {
        ballTotal = [[array objectAtIndex:indexPath.row] intValue];
    }
    
    float space = yilouSpace;
    if (!self.isOpenSwitch) {
        space = noYilouSpace;
    }
    int numOfEveryRow = 7;
    int rowTotalNum = ballTotal % numOfEveryRow == 0 ? ballTotal / numOfEveryRow : (ballTotal / numOfEveryRow + 1);
    float cellHeight =(self.gameIndex&&(indexPath.row==0))?rowTotalNum * (ballHeight + space): rowTotalNum * (ballHeight + space) + 22;
    
    return cellHeight;
}

//走势图开奖数据源
- (id)trendCellModelForIndexPath:(NSIndexPath *)indexPath
{
    DPLBTrendCellViewModel *trendModel = [[DPLBTrendCellViewModel alloc]init];
    trendModel.gameType = self.gameType;
    if (indexPath.row==0) {
        trendModel.ballViewImg = [UIImage dp_retinaImageNamed:dp_ImagePath(kDigitLotteryImageBundlePath, @"ballHistoryBonus_02.png")];
        trendModel.gameNameColor = UIColorFromRGB(0xe7161a);
    }
    
    if (indexPath.row>=self.viewModel.dataBase.drawsArray.count) {
        return trendModel;
    }
    PBMDrawItem *item=[self.viewModel.dataBase.drawsArray objectAtIndex:indexPath.row];
    trendModel.gameNameText = item.gameName;

    if (item.hasResult) {
        NSArray *array=[item.result componentsSeparatedByString:@"|"];
        if (array.count!=2) {
            return trendModel;
        }
        NSString *resultRed=[array objectAtIndex:0];
        NSString *resultBlue=[array objectAtIndex:1];
        resultRed=[resultRed stringByReplacingOccurrencesOfString:@"," withString:@" "];
        resultBlue=[resultBlue stringByReplacingOccurrencesOfString:@"," withString:@" "];
        NSMutableAttributedString *hintString1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  |  %@",resultRed,resultBlue]];
        [hintString1 addAttribute:NSForegroundColorAttributeName  value:(id)[UIColor dp_flatRedColor] range:NSMakeRange(0,resultRed.length)];
        [hintString1 addAttribute:NSForegroundColorAttributeName  value:(id)[UIColor colorWithRed:0.78 green:0.70 blue:0.63 alpha:1.0] range:NSMakeRange(resultRed.length+2,1)];
        [hintString1 addAttribute:NSForegroundColorAttributeName  value:(id)UIColorFromRGB(0x0a77d4) range:NSMakeRange(resultRed.length+5,resultBlue.length)];
        trendModel.gameInfoAttText = hintString1;
    }
    return trendModel;
}
//投注数据源
- (id)numberCellModelForIndexPath:(NSIndexPath *)indexPath
{
    DPLBDigitalCellViewModel *numberModel = [[DPLBDigitalCellViewModel alloc]init];
    numberModel.gameType = self.gameType;
    numberModel.indexPath = indexPath;
    numberModel.isOpenSwitch = self.isOpenSwitch;
    
    NSMutableArray *arrayM = nil;
    
    int mis[47] = {0};//遗漏值
    for (int i=0; i<self.viewModel.dataBase.missDataArray.count; i++) {
        mis[i]=[self.viewModel.dataBase.missDataArray valueAtIndex:i];
    }
    // maxNum:数据最大的标示特殊颜色 startIndex:起始位置  total:行长度
    int maxNum = 0, startIndex = 0, total = 0;
    switch (self.gameIndex) {
        case 0://普通投注
        {
            if (indexPath.row==0) {
                arrayM = [NSMutableArray arrayWithCapacity:DLTREDNUM];
                for (int i=0; i < DLTREDNUM; i++) {
                    [arrayM addObject:@(_normalRed[i])];
                    if (mis[i]>= maxNum) {
                        maxNum = mis[i] ;
                    }
                }
                total = DLTREDNUM;
            }
            if (indexPath.row==1) {
                arrayM = [NSMutableArray arrayWithCapacity:DLTBLUENUM];
                for (int i=0; i<DLTBLUENUM; i++) {
                    [arrayM addObject:@(_normalBlue[i])];
                    if (mis[i+DLTREDNUM] >= maxNum) {
                        maxNum = mis[i+DLTREDNUM] ;
                    }
                }
                startIndex = DLTREDNUM;
                total = DLTBLUENUM;
            }
        }
            break;
        case 1://胆拖投注
        {
            if (indexPath.row==0) {
                arrayM = [NSMutableArray arrayWithCapacity:DLTREDNUM];
                for (int i=0; i<DLTREDNUM; i++) {
                    if (mis[i] >= maxNum) {
                        maxNum = mis[i] ;
                    }
                    if (_danRed[i]==-1) {
                        [arrayM addObject:@(YES)];
                        continue;
                    }
                    [arrayM addObject:@(NO)];
                }
                total = DLTREDNUM;
            }else if (indexPath.row==1){
                arrayM = [NSMutableArray arrayWithCapacity:DLTREDNUM];
                for (int i=0; i<DLTREDNUM; i++) {
                    if (mis[i] >= maxNum) {
                        maxNum = mis[i] ;
                    }
                    if (_danRed[i]==1) {
                        [arrayM addObject:@(YES)];
                        continue;
                    }
                    [arrayM addObject:@(NO)];
                }
                total = DLTREDNUM;
            }else if (indexPath.row==2){
                arrayM = [NSMutableArray arrayWithCapacity:DLTBLUENUM];
                
                for (int i=0; i<DLTBLUENUM; i++) {
                    if (mis[i+DLTREDNUM] >= maxNum) {
                        maxNum = mis[i+DLTREDNUM] ;
                    }
                    if (_danBlue[i]==-1) {
                        [arrayM addObject:@(YES)];
                        continue;
                    }
                    [arrayM addObject:@(NO)];
                    
                }
                startIndex = DLTREDNUM;
                total = DLTBLUENUM;
            } else if (indexPath.row==3){
                arrayM = [NSMutableArray arrayWithCapacity:DLTBLUENUM];
                
                for (int i=0; i<DLTBLUENUM; i++) {
                    if (mis[i+DLTREDNUM] >= maxNum) {
                        maxNum = mis[i+DLTREDNUM] ;
                    }
                    if (_danBlue[i]==1) {
                        [arrayM addObject:@(YES)];
                        continue;
                    }
                    [arrayM addObject:@(NO)];
                    
                }
                startIndex = DLTREDNUM;
                total = DLTBLUENUM;
            }
        }
            break;
        default:
            break;
    }
    
    NSMutableArray *labelTextArray = [NSMutableArray arrayWithCapacity:total];
    NSMutableArray *labelColorArray = [NSMutableArray arrayWithCapacity:total];
    for (int i = 0; i < total; i++) {
        [labelTextArray addObject:[NSString stringWithFormat:@"%d", mis[i + startIndex]]];
        if (mis[i+startIndex] == maxNum) {
            [labelColorArray addObject:[UIColor dp_flatRedColor]];
        }else{
            [labelColorArray addObject:UIColorFromRGB(0x999999)];
        }
    }
    numberModel.total = total;
    numberModel.btnSelectArray = arrayM;
    numberModel.labelTextArray = labelTextArray;
    numberModel.labelColorArray = labelColorArray;
    return numberModel;
}

//把选择的号码存入数组里
- (int)sendSubmitReq
{
    
    int red[DLTREDNUM];
    int blue[DLTBLUENUM];
    [self touzhuInfo:red target2:blue];
    DPDltBetData *dltData=[[DPDltBetData alloc] init];
    for (int i=0; i<50; i++) {
        [ dltData.red addObject:[NSNumber numberWithInt:red[i]]];
    }
    for (int i=0; i<50; i++) {
        [ dltData.blue addObject:[NSNumber numberWithInt:blue[i]]];
    }
    dltData.mark = NO;
    dltData.note = @([DPNoteCalculater calcDltWithRed:red blue:blue]);
    switch (self.gameIndex) {
        case 0:{
            if (self.indexPathRow >= 0) {
                if (self.indexPathRow>=self.viewModel.infoArray.count) {
                    return -1;
                }
                [self.viewModel.infoArray replaceObjectAtIndex:self.indexPathRow withObject:dltData];
                return 0;
            }else{
                [self.viewModel.infoArray insertObject:dltData atIndex:0];
                return 0;
            }
        }
            break;
        case 1:{
            dltData.mark=YES;
            if (self.indexPathRow >= 0) {
                if (self.indexPathRow>=self.viewModel.infoArray.count) {
                    return -1;
                }
                [self.viewModel.infoArray replaceObjectAtIndex:self.indexPathRow withObject:dltData];
                return 0;
            }else{
                [self.viewModel.infoArray insertObject:dltData atIndex:0];
                return 0;
            }
        }
            break;
        default:
            return - 1;
            break;
    }
}
//红球
-(NSArray*)redBallArray{
    
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:DLTREDNUM] ;
    for (int i=0; i<DLTREDNUM; i++) {
        [arr addObject:[NSNumber numberWithInt:_normalRed[i]]];
    }
    
    return arr ;
}
//篮球
-(NSArray*)blueBallArray{
    
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:DLTBLUENUM] ;
    for (int i=0; i<DLTBLUENUM; i++) {
        [arr addObject:[NSNumber numberWithInt:_normalBlue[i]]];
    }
    
    return arr ;
    
    
}
//中转页面模型
- (id<DPLTNumberMainDataSource, DPLTNumberMutualDataSource, DPLTNumberTimerDataSource>)viewModel {
    if (_viewModel == nil) {
        _viewModel = (id)[DPLTNumberViewModel sharedModel:self.gameType];
    }
    return _viewModel;
}

@end
